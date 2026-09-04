package com.company.phishingawareness.campaign;

import java.time.LocalDateTime;

import com.company.phishingawareness.shared.BaseEntity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "campaign_events")
public class CampaignEvent extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "campaign_recipient_id", nullable = false)
    private CampaignRecipient campaignRecipient;

    @Enumerated(EnumType.STRING)
    @Column(name = "event_type", nullable = false, length = 30)
    private EventType eventType;

    @Column(name = "event_time", nullable = false)
    private LocalDateTime eventTime = LocalDateTime.now();

    @Column(name = "user_agent", length = 500)
    private String userAgent;

    @Column(columnDefinition = "JSON")
    private String metadata;

    public enum EventType {
        EMAIL_SENT,
        EMAIL_DELIVERED,
        EMAIL_OPENED,
        LINK_CLICKED,
        LANDING_VIEWED,
        FORM_SUBMITTED,
        EMAIL_REPORTED,
        TRAINING_VIEWED,
        TRAINING_COMPLETED
    }

    // Getters and setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public CampaignRecipient getCampaignRecipient() { return campaignRecipient; }
    public void setCampaignRecipient(CampaignRecipient campaignRecipient) { this.campaignRecipient = campaignRecipient; }
    public EventType getEventType() { return eventType; }
    public void setEventType(EventType eventType) { this.eventType = eventType; }
    public LocalDateTime getEventTime() { return eventTime; }
    public void setEventTime(LocalDateTime eventTime) { this.eventTime = eventTime; }
    public String getUserAgent() { return userAgent; }
    public void setUserAgent(String userAgent) { this.userAgent = userAgent; }
    public String getMetadata() { return metadata; }
    public void setMetadata(String metadata) { this.metadata = metadata; }
}
