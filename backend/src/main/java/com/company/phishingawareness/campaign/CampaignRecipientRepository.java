package com.company.phishingawareness.campaign;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

public interface CampaignRecipientRepository extends JpaRepository<CampaignRecipient, Long> {
    List<CampaignRecipient> findByCampaignId(Long campaignId);
    Optional<CampaignRecipient> findByTrackingToken(String trackingToken);
    long countByCampaignId(Long campaignId);
}
