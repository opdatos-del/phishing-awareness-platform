package com.company.phishingawareness.tracking;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.lenient;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.Optional;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;

import com.company.phishingawareness.campaign.Campaign;
import com.company.phishingawareness.campaign.CampaignEvent;
import com.company.phishingawareness.campaign.CampaignEventRepository;
import com.company.phishingawareness.campaign.CampaignRecipient;
import com.company.phishingawareness.campaign.CampaignRecipientRepository;
import com.company.phishingawareness.landing.LandingPage;
import com.company.phishingawareness.landing.LandingPageRepository;
import com.company.phishingawareness.recipient.Recipient;
import com.company.phishingawareness.template.EmailTemplate;

@ExtendWith(MockitoExtension.class)
class TrackingControllerTest {

    private static final String TOKEN = "tok-123";
    private static final String SLUG = "corporate-login";

    @Mock private CampaignRecipientRepository campaignRecipientRepository;
    @Mock private CampaignEventRepository campaignEventRepository;
    @Mock private LandingPageRepository landingPageRepository;

    private TrackingController controller;
    private CampaignRecipient cr;

    @BeforeEach
    void setUp() {
        controller = new TrackingController(campaignRecipientRepository, campaignEventRepository, landingPageRepository);

        EmailTemplate template = new EmailTemplate();
        template.setName("Template");
        template.setCategory(EmailTemplate.Category.ACCOUNT);
        template.setDifficulty(EmailTemplate.Difficulty.EASY);
        template.setSubject("Subject");
        template.setHtml("<html></html>");
        template.setActive(true);

        LandingPage landing = new LandingPage();
        landing.setName("Landing");
        landing.setSlug(SLUG);
        landing.setCategory(LandingPage.Category.ACCOUNT);
        landing.setDifficulty(LandingPage.Difficulty.EASY);
        landing.setHtml("<html><body><form id='sim-form'>"
                + "fetch('/api/v1/tracking/{{TOKEN}}/submit',{method:'POST'})"
                + "window.location.href='/training/{{SLUG}}?token={{TOKEN}}'</form></body></html>");
        landing.setActive(true);

        Campaign campaign = new Campaign();
        campaign.setName("Campaign");
        campaign.setTemplate(template);
        campaign.setLandingPage(landing);

        Recipient recipient = new Recipient();
        recipient.setName("Usuario");
        recipient.setEmail("usuario@company.com");
        recipient.setActive(true);

        cr = new CampaignRecipient();
        cr.setTrackingToken(TOKEN);
        cr.setCampaign(campaign);
        cr.setRecipient(recipient);

        lenient().when(campaignRecipientRepository.findByTrackingToken(TOKEN)).thenReturn(Optional.of(cr));
    }

    @Test
    void trackOpen_recordsEmailOpenedOnce_returnsTransparentPixel() {
        ResponseEntity<byte[]> response = controller.trackOpen(TOKEN, "Mozilla/5.0");

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getHeaders().getContentType()).isEqualTo(MediaType.IMAGE_PNG);
        assertThat(response.getBody()).isNotEmpty();
        assertThat(cr.getOpenedAt()).isNotNull();
        verify(campaignRecipientRepository).save(cr);
        verify(campaignEventRepository).save(any(CampaignEvent.class));

        // Segundo open: no se registra duplicado
        controller.trackOpen(TOKEN, "Mozilla/5.0");
        verify(campaignEventRepository, times(1)).save(any(CampaignEvent.class));
    }

    @Test
    void trackOpen_unknownToken_returns404() {
        when(campaignRecipientRepository.findByTrackingToken("bad")).thenReturn(Optional.empty());

        ResponseEntity<byte[]> response = controller.trackOpen("bad", null);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND);
        verify(campaignRecipientRepository, never()).save(any());
    }

    @Test
    void trackLink_redirectsToLandingAndRecordsClick() {
        ResponseEntity<?> response = controller.trackLink(TOKEN, "Mozilla/5.0");

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.FOUND);
        assertThat(response.getHeaders().getLocation()).hasPath("/landing/" + SLUG);
        assertThat(response.getHeaders().getLocation()).hasQuery("token=" + TOKEN);
        assertThat(cr.getClickedAt()).isNotNull();
        verify(campaignEventRepository).save(any(CampaignEvent.class));

        // Segundo click: sin duplicado
        controller.trackLink(TOKEN, "Mozilla/5.0");
        verify(campaignEventRepository, times(1)).save(any(CampaignEvent.class));
    }

    @Test
    void serveLanding_withToken_injectsPlaceholdersAndRecordsLandingViewed() {
        when(landingPageRepository.findBySlug(SLUG)).thenReturn(Optional.of(cr.getCampaign().getLandingPage()));

        ResponseEntity<?> response = controller.serveLanding(SLUG, TOKEN, "Mozilla/5.0");

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getHeaders().getContentType()).isEqualTo(MediaType.TEXT_HTML);
        String body = (String) response.getBody();
        assertThat(body).contains("/api/v1/tracking/" + TOKEN + "/submit");
        assertThat(body).contains("token=" + TOKEN);
        assertThat(cr.getLandingViewedAt()).isNotNull();
        verify(campaignEventRepository).save(any(CampaignEvent.class));
    }

    @Test
    void serveLanding_withoutToken_servesHtmlWithoutRecordingEvent() {
        when(landingPageRepository.findBySlug(SLUG)).thenReturn(Optional.of(cr.getCampaign().getLandingPage()));

        ResponseEntity<?> response = controller.serveLanding(SLUG, null, null);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat((String) response.getBody()).doesNotContain(TOKEN);
        assertThat(cr.getLandingViewedAt()).isNull();
        verify(campaignEventRepository, never()).save(any());
    }

    @Test
    void serveLanding_unknownSlug_returns404() {
        when(landingPageRepository.findBySlug("nope")).thenReturn(Optional.empty());

        ResponseEntity<?> response = controller.serveLanding("nope", TOKEN, null);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND);
    }

    @Test
    void formSubmit_recordsSubmission() {
        ResponseEntity<?> response = controller.formSubmit(TOKEN, "Mozilla/5.0");

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(cr.getSubmittedAt()).isNotNull();
        verify(campaignEventRepository).save(any(CampaignEvent.class));
    }

    @Test
    void serveTraining_withToken_recordsTrainingViewedAndServesHtml() {
        ResponseEntity<?> response = controller.serveTraining(SLUG, TOKEN, "Mozilla/5.0");

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getHeaders().getContentType()).isEqualTo(MediaType.TEXT_HTML);
        assertThat((String) response.getBody()).contains("simulacion de phishing");
        assertThat(cr.getTrainingViewedAt()).isNotNull();
        verify(campaignEventRepository).save(any(CampaignEvent.class));
    }

    @Test
    void serveTraining_withoutToken_servesHtmlWithoutRecordingEvent() {
        ResponseEntity<?> response = controller.serveTraining(SLUG, null, null);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(cr.getTrainingViewedAt()).isNull();
        verify(campaignEventRepository, never()).save(any());
    }
}