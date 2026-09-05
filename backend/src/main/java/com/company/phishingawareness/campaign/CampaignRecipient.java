package com.company.phishingawareness.campaign;

import java.time.LocalDateTime;
import java.util.UUID;

import com.company.phishingawareness.recipient.Recipient;
import com.company.phishingawareness.shared.BaseEntity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "campaign_recipients")
public class CampaignRecipient extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "campaign_id", nullable = false)
    private Campaign campaign;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "recipient_id", nullable = false)
    private Recipient recipient;

    @Column(name = "tracking_token", nullable = false, unique = true, length = 36)
    private String trackingToken = UUID.randomUUID().toString();

    @Column(name = "sent_at")
    private LocalDateTime sentAt;

    @Column(name = "opened_at")
    private LocalDateTime openedAt;

    @Column(name = "clicked_at")
    private LocalDateTime clickedAt;

    @Column(name = "landing_viewed_at")
    private LocalDateTime landingViewedAt;

    @Column(name = "submitted_at")
    private LocalDateTime submittedAt;

    @Column(name = "reported_at")
    private LocalDateTime reportedAt;

    @Column(name = "training_viewed_at")
    private LocalDateTime trainingViewedAt;

    @Column(name = "delivered_at")
    private LocalDateTime deliveredAt;

    @Column(name = "training_completed_at")
    private LocalDateTime trainingCompletedAt;

    @Column(name = "gophish_recipient_id", length = 100)
    private String gophishRecipientId;

    // Getters and setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Campaign getCampaign() { return campaign; }
    public void setCampaign(Campaign campaign) { this.campaign = campaign; }
    public Recipient getRecipient() { return recipient; }
    public void setRecipient(Recipient recipient) { this.recipient = recipient; }
    public String getTrackingToken() { return trackingToken; }
    public void setTrackingToken(String trackingToken) { this.trackingToken = trackingToken; }
    public LocalDateTime getSentAt() { return sentAt; }
    public void setSentAt(LocalDateTime sentAt) { this.sentAt = sentAt; }
    public LocalDateTime getOpenedAt() { return openedAt; }
    public void setOpenedAt(LocalDateTime openedAt) { this.openedAt = openedAt; }
    public LocalDateTime getClickedAt() { return clickedAt; }
    public void setClickedAt(LocalDateTime clickedAt) { this.clickedAt = clickedAt; }
    public LocalDateTime getLandingViewedAt() { return landingViewedAt; }
    public void setLandingViewedAt(LocalDateTime landingViewedAt) { this.landingViewedAt = landingViewedAt; }
    public LocalDateTime getSubmittedAt() { return submittedAt; }
    public void setSubmittedAt(LocalDateTime submittedAt) { this.submittedAt = submittedAt; }
    public LocalDateTime getReportedAt() { return reportedAt; }
    public void setReportedAt(LocalDateTime reportedAt) { this.reportedAt = reportedAt; }
    public LocalDateTime getTrainingViewedAt() { return trainingViewedAt; }
    public void setTrainingViewedAt(LocalDateTime trainingViewedAt) { this.trainingViewedAt = trainingViewedAt; }
    public LocalDateTime getDeliveredAt() { return deliveredAt; }
    public void setDeliveredAt(LocalDateTime deliveredAt) { this.deliveredAt = deliveredAt; }
    public LocalDateTime getTrainingCompletedAt() { return trainingCompletedAt; }
    public void setTrainingCompletedAt(LocalDateTime trainingCompletedAt) { this.trainingCompletedAt = trainingCompletedAt; }
    public String getGophishRecipientId() { return gophishRecipientId; }
    public void setGophishRecipientId(String gophishRecipientId) { this.gophishRecipientId = gophishRecipientId; }
}
