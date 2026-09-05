package com.company.phishingawareness.campaign;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CampaignRecipientRepository extends JpaRepository<CampaignRecipient, Long> {
    List<CampaignRecipient> findByCampaignId(Long campaignId);

    @EntityGraph(attributePaths = {"campaign", "campaign.landingPage"})
    Optional<CampaignRecipient> findByTrackingToken(String trackingToken);
    Optional<CampaignRecipient> findByCampaignIdAndRecipientId(Long campaignId, Long recipientId);
    long countByCampaignId(Long campaignId);
    Optional<CampaignRecipient> findByCampaignGophishCampaignIdAndRecipientEmail(Long gophishCampaignId, String email);
    Optional<CampaignRecipient> findByCampaignGophishCampaignIdAndGophishRecipientId(Long gophishCampaignId, String recipientId);
    long countBySentAtIsNotNull();
    long countByOpenedAtIsNotNull();
    long countByClickedAtIsNotNull();
    long countBySubmittedAtIsNotNull();
    long countByTrainingViewedAtIsNotNull();
    long countByCampaignIdAndSentAtIsNotNull(Long campaignId);
    long countByCampaignIdAndOpenedAtIsNotNull(Long campaignId);
    long countByCampaignIdAndClickedAtIsNotNull(Long campaignId);
    long countByCampaignIdAndSubmittedAtIsNotNull(Long campaignId);
    long countByCampaignIdAndReportedAtIsNotNull(Long campaignId);
    long countByCampaignIdAndTrainingViewedAtIsNotNull(Long campaignId);
    long countByCampaignIdAndTrainingCompletedAtIsNotNull(Long campaignId);
}
