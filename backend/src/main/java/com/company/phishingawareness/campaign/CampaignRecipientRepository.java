package com.company.phishingawareness.campaign;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface CampaignRecipientRepository extends JpaRepository<CampaignRecipient, Long> {
    @Query("SELECT cr FROM CampaignRecipient cr JOIN FETCH cr.recipient JOIN FETCH cr.campaign c JOIN FETCH c.template JOIN FETCH c.landingPage WHERE c.status <> :draftStatus")
    List<CampaignRecipient> findAllForRiskReport(@Param("draftStatus") Campaign.Status draftStatus);
    List<CampaignRecipient> findByCampaignId(Long campaignId);
    List<CampaignRecipient> findByCampaignIdIn(List<Long> campaignIds);

    @EntityGraph(attributePaths = {"campaign", "campaign.landingPage"})
    Optional<CampaignRecipient> findByTrackingToken(String trackingToken);
    Optional<CampaignRecipient> findByCampaignIdAndRecipientId(Long campaignId, Long recipientId);
    long countByCampaignId(Long campaignId);
    Optional<CampaignRecipient> findByCampaignGophishCampaignIdAndRecipientEmail(Long gophishCampaignId, String email);
    Optional<CampaignRecipient> findByCampaignGophishCampaignIdAndGophishRecipientId(Long gophishCampaignId, String recipientId);
    List<CampaignRecipient> findByCampaignGophishCampaignId(Long gophishCampaignId);
    long countBySentAtIsNotNull();
    long countByOpenedAtIsNotNull();
    long countByClickedAtIsNotNull();
    long countBySubmittedAtIsNotNull();
    long countByReportedAtIsNotNull();
    long countByTrainingViewedAtIsNotNull();
    long countByTrainingCompletedAtIsNotNull();
    long countByCampaignIdAndSentAtIsNotNull(Long campaignId);
    long countByCampaignIdAndOpenedAtIsNotNull(Long campaignId);
    long countByCampaignIdAndClickedAtIsNotNull(Long campaignId);
    long countByCampaignIdAndSubmittedAtIsNotNull(Long campaignId);
    long countByCampaignIdAndReportedAtIsNotNull(Long campaignId);
    long countByCampaignIdAndTrainingViewedAtIsNotNull(Long campaignId);
    long countByCampaignIdAndTrainingCompletedAtIsNotNull(Long campaignId);
}
