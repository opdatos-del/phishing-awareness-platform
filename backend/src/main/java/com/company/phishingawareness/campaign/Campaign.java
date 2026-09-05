package com.company.phishingawareness.campaign;

import com.company.phishingawareness.landing.LandingPage;
import com.company.phishingawareness.shared.BaseEntity;
import com.company.phishingawareness.template.EmailTemplate;

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
@Table(name = "campaigns")
public class Campaign extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 200)
    private String name;

    @Column(length = 1000)
    private String description;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private Status status = Status.DRAFT;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "template_id", nullable = false)
    private EmailTemplate template;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "landing_page_id", nullable = false)
    private LandingPage landingPage;

    @Column(name = "scheduled_at")
    private java.time.LocalDateTime scheduledAt;

    @Column(name = "started_at")
    private java.time.LocalDateTime startedAt;

    @Column(name = "completed_at")
    private java.time.LocalDateTime completedAt;

    @Column(name = "sent_at")
    private java.time.LocalDateTime sentAt;

    @Column(name = "gophish_campaign_id", unique = true)
    private Long gophishCampaignId;

    public enum Status {
        DRAFT, SCHEDULED, RUNNING, COMPLETED, CANCELLED
    }

    // Getters and setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public Status getStatus() { return status; }
    public void setStatus(Status status) { this.status = status; }
    public EmailTemplate getTemplate() { return template; }
    public void setTemplate(EmailTemplate template) { this.template = template; }
    public LandingPage getLandingPage() { return landingPage; }
    public void setLandingPage(LandingPage landingPage) { this.landingPage = landingPage; }
    public java.time.LocalDateTime getScheduledAt() { return scheduledAt; }
    public void setScheduledAt(java.time.LocalDateTime scheduledAt) { this.scheduledAt = scheduledAt; }
    public java.time.LocalDateTime getStartedAt() { return startedAt; }
    public void setStartedAt(java.time.LocalDateTime startedAt) { this.startedAt = startedAt; }
    public java.time.LocalDateTime getCompletedAt() { return completedAt; }
    public void setCompletedAt(java.time.LocalDateTime completedAt) { this.completedAt = completedAt; }
    public java.time.LocalDateTime getSentAt() { return sentAt; }
    public void setSentAt(java.time.LocalDateTime sentAt) { this.sentAt = sentAt; }
    public Long getGophishCampaignId() { return gophishCampaignId; }
    public void setGophishCampaignId(Long gophishCampaignId) { this.gophishCampaignId = gophishCampaignId; }
}
