package com.company.phishingawareness.campaign;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
public class CampaignScheduler {
    private final CampaignService campaignService;

    public CampaignScheduler(CampaignService campaignService) {
        this.campaignService = campaignService;
    }

    @Scheduled(fixedDelayString = "${campaign.scheduler-delay-ms:30000}")
    public void activateDueCampaigns() {
        campaignService.activateScheduledCampaigns();
    }
}
