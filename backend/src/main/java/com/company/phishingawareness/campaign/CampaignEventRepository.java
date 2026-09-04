package com.company.phishingawareness.campaign;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface CampaignEventRepository extends JpaRepository<CampaignEvent, Long> {
    List<CampaignEvent> findByCampaignRecipientIdOrderByEventTimeAsc(Long campaignRecipientId);

    @Query("SELECT COUNT(e) FROM CampaignEvent e WHERE e.campaignRecipient.campaign.id = :campaignId AND e.eventType = :eventType")
    long countByCampaignIdAndEventType(Long campaignId, CampaignEvent.EventType eventType);
}
