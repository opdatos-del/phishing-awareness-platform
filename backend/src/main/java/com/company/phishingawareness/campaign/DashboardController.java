package com.company.phishingawareness.campaign;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/dashboard")
public class DashboardController {
    private final CampaignService campaignService;

    public DashboardController(CampaignService campaignService) {
        this.campaignService = campaignService;
    }

    @GetMapping
    public CampaignService.DashboardSummary get() {
        return campaignService.dashboard();
    }
}
