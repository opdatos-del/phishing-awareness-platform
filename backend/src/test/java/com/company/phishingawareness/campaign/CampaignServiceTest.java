package com.company.phishingawareness.campaign;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import com.company.phishingawareness.landing.LandingPage;
import com.company.phishingawareness.landing.LandingPageRepository;
import com.company.phishingawareness.recipient.Recipient;
import com.company.phishingawareness.recipient.RecipientRepository;
import com.company.phishingawareness.shared.NotFoundException;
import com.company.phishingawareness.template.EmailTemplate;
import com.company.phishingawareness.template.EmailTemplateRepository;

@SpringBootTest
@ActiveProfiles("test")
@Transactional
class CampaignServiceTest {

    @Autowired
    private CampaignService campaignService;

    @Autowired
    private CampaignRepository campaignRepository;

    @Autowired
    private EmailTemplateRepository templateRepository;

    @Autowired
    private LandingPageRepository landingPageRepository;

    @Autowired
    private RecipientRepository recipientRepository;

    private EmailTemplate template;
    private LandingPage landingPage;

    @BeforeEach
    void setup() {
        template = new EmailTemplate();
        template.setName("Test Template");
        template.setSubject("Test Subject");
        template.setHtml("<html>test</html>");
        template.setCategory(EmailTemplate.Category.ACCOUNT);
        template.setDifficulty(EmailTemplate.Difficulty.EASY);
        template.setActive(true);
        template = templateRepository.save(template);

        landingPage = new LandingPage();
        landingPage.setName("Test Landing");
        landingPage.setSlug("test-landing");
        landingPage.setHtml("<html>test</html>");
        landingPage.setCategory(LandingPage.Category.ACCOUNT);
        landingPage.setDifficulty(LandingPage.Difficulty.EASY);
        landingPage.setActive(true);
        landingPage = landingPageRepository.save(landingPage);
    }

    @Test
    void createCampaign_success() {
        var request = new CampaignService.CreateRequest("Test Campaign", "Description", template.getId(), landingPage.getId());
        var result = campaignService.create(request);

        assertThat(result.getId()).isNotNull();
        assertThat(result.getName()).isEqualTo("Test Campaign");
        assertThat(result.getStatus()).isEqualTo(Campaign.Status.DRAFT);
    }

    @Test
    void createCampaign_invalidTemplate_throws() {
        var request = new CampaignService.CreateRequest("Test", "Desc", 99999L, landingPage.getId());
        assertThatThrownBy(() -> campaignService.create(request))
                .isInstanceOf(NotFoundException.class);
    }

    @Test
    void createCampaign_invalidLandingPage_throws() {
        var request = new CampaignService.CreateRequest("Test", "Desc", template.getId(), 99999L);
        assertThatThrownBy(() -> campaignService.create(request))
                .isInstanceOf(NotFoundException.class);
    }

    @Test
    void addRecipients_success() {
        var campaign = campaignService.create(
            new CampaignService.CreateRequest("Test", "Desc", template.getId(), landingPage.getId()));

        var r1 = createRecipient("User 1", "u1@test.com");
        var r2 = createRecipient("User 2", "u2@test.com");

        var added = campaignService.addRecipients(campaign.getId(), List.of(r1.getId(), r2.getId()));
        assertThat(added).hasSize(2);
        assertThat(added.get(0).trackingToken()).isNotNull();
        assertThat(added.get(0).status()).isEqualTo("PENDING");
    }

    @Test
    void addRecipients_duplicate_throws() {
        var campaign = campaignService.create(
            new CampaignService.CreateRequest("Test", "Desc", template.getId(), landingPage.getId()));
        var r1 = createRecipient("User", "dup@test.com");

        campaignService.addRecipients(campaign.getId(), List.of(r1.getId()));

        assertThatThrownBy(() -> campaignService.addRecipients(campaign.getId(), List.of(r1.getId())))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("already in this campaign");
    }

    @Test
    void listRecipients_withStatus() {
        var campaign = campaignService.create(
            new CampaignService.CreateRequest("Test", "Desc", template.getId(), landingPage.getId()));
        var r1 = createRecipient("User", "list@test.com");
        campaignService.addRecipients(campaign.getId(), List.of(r1.getId()));

        var recipients = campaignService.listRecipients(campaign.getId());
        assertThat(recipients).hasSize(1);
        assertThat(recipients.get(0).status()).isEqualTo("PENDING");
    }

    @Test
    void deleteDraftCampaign_success() {
        var campaign = campaignService.create(
            new CampaignService.CreateRequest("Delete Me", "Desc", template.getId(), landingPage.getId()));
        campaignService.delete(campaign.getId());
        assertThatThrownBy(() -> campaignService.findById(campaign.getId()))
                .isInstanceOf(NotFoundException.class);
    }

    private Recipient createRecipient(String name, String email) {
        Recipient r = new Recipient();
        r.setName(name);
        r.setEmail(email);
        r.setActive(true);
        return recipientRepository.save(r);
    }
}
