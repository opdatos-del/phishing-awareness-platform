package com.company.phishingawareness.campaign;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CampaignRecipientRepository extends JpaRepository<CampaignRecipient, Long> {
    List<CampaignRecipient> findByCampaignId(Long campaignId);
    Optional<CampaignRecipient> findByTrackingToken(String trackingToken);
    Optional<CampaignRecipient> findByCampaignIdAndRecipientId(Long campaignId, Long recipientId);
    long countByCampaignId(Long campaignId);
}
