package com.company.phishingawareness.analytics;

import static org.hamcrest.Matchers.hasSize;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.time.LocalDateTime;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.user;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;

import com.company.phishingawareness.campaign.Campaign;
import com.company.phishingawareness.campaign.CampaignRecipient;
import com.company.phishingawareness.campaign.CampaignRecipientRepository;
import com.company.phishingawareness.campaign.CampaignRepository;
import com.company.phishingawareness.landing.LandingPage;
import com.company.phishingawareness.landing.LandingPageRepository;
import com.company.phishingawareness.recipient.Recipient;
import com.company.phishingawareness.recipient.RecipientRepository;
import com.company.phishingawareness.template.EmailTemplate;
import com.company.phishingawareness.template.EmailTemplateRepository;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
class RiskReportControllerTest {

    @Autowired private MockMvc mockMvc;
    @Autowired private CampaignRepository campaignRepository;
    @Autowired private CampaignRecipientRepository campaignRecipientRepository;
    @Autowired private RecipientRepository recipientRepository;
    @Autowired private EmailTemplateRepository templateRepository;
    @Autowired private LandingPageRepository landingPageRepository;

    @Test
    void aggregatesAllNonDraftCampaignsByRecipient() throws Exception {
        Recipient recipient = new Recipient();
        recipient.setName("Ana Audit");
        recipient.setEmail("ana.audit@test.com");
        recipient.setActive(true);
        recipient = recipientRepository.save(recipient);

        Campaign running = campaign("Running", Campaign.Status.RUNNING);
        Campaign completed = campaign("Completed", Campaign.Status.COMPLETED);
        Campaign draft = campaign("Draft", Campaign.Status.DRAFT);

        add(running, recipient, true, true, true, false, LocalDateTime.of(2026, 1, 2, 10, 0));
        add(completed, recipient, true, false, false, true, LocalDateTime.of(2026, 1, 3, 10, 0));
        add(draft, recipient, true, true, true, true, LocalDateTime.of(2026, 1, 4, 10, 0));

        mockMvc.perform(get("/api/v1/analytics/risk-report").with(user("analyst").roles("ANALYST"))
                .param("search", "ana.audit"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$", hasSize(1)))
            .andExpect(jsonPath("$[0].campaignsReceived").value(2))
            .andExpect(jsonPath("$[0].opens").value(2))
            .andExpect(jsonPath("$[0].clicks").value(1))
            .andExpect(jsonPath("$[0].submits").value(1))
            .andExpect(jsonPath("$[0].reports").value(1))
            .andExpect(jsonPath("$[0].riskScore").value(6))
            .andExpect(jsonPath("$[0].riskLevel").value("ALTO"))
            .andExpect(jsonPath("$[0].firstSubmittedAt").value("2026-01-02T10:00:00"))
            .andExpect(jsonPath("$[0].lastSubmittedAt").value("2026-01-02T10:00:00"));
    }

    private Campaign campaign(String name, Campaign.Status status) {
        EmailTemplate template = new EmailTemplate();
        template.setName(name + " template");
        template.setSubject("Subject");
        template.setHtml("<html></html>");
        template.setCategory(EmailTemplate.Category.ACCOUNT);
        template.setDifficulty(EmailTemplate.Difficulty.EASY);
        template.setActive(true);
        template = templateRepository.save(template);

        LandingPage landing = new LandingPage();
        landing.setName(name + " landing");
        landing.setSlug(name.toLowerCase() + "-landing");
        landing.setHtml("<html></html>");
        landing.setCategory(LandingPage.Category.ACCOUNT);
        landing.setDifficulty(LandingPage.Difficulty.EASY);
        landing.setActive(true);
        landing = landingPageRepository.save(landing);

        Campaign campaign = new Campaign();
        campaign.setName(name);
        campaign.setStatus(status);
        campaign.setTemplate(template);
        campaign.setLandingPage(landing);
        return campaignRepository.save(campaign);
    }

    private void add(Campaign campaign, Recipient recipient, boolean opened, boolean clicked, boolean submitted,
                     boolean reported, LocalDateTime eventTime) {
        CampaignRecipient row = new CampaignRecipient();
        row.setCampaign(campaign);
        row.setRecipient(recipient);
        row.setOpenedAt(opened ? eventTime : null);
        row.setClickedAt(clicked ? eventTime : null);
        row.setSubmittedAt(submitted ? eventTime : null);
        row.setReportedAt(reported ? eventTime : null);
        campaignRecipientRepository.save(row);
    }
}
