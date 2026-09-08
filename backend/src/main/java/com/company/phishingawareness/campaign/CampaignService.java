package com.company.phishingawareness.campaign;

import java.util.List;
import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.company.phishingawareness.landing.LandingPage;
import com.company.phishingawareness.landing.LandingPageRepository;
import com.company.phishingawareness.recipient.Recipient;
import com.company.phishingawareness.recipient.RecipientRepository;
import com.company.phishingawareness.shared.NotFoundException;
import com.company.phishingawareness.template.EmailTemplate;
import com.company.phishingawareness.template.EmailTemplateRepository;
import com.company.phishingawareness.gophish.GophishClient;

@Service
public class CampaignService {

    private static final Logger log = LoggerFactory.getLogger(CampaignService.class);

    private final CampaignRepository campaignRepo;
    private final CampaignRecipientRepository crRepo;
    private final CampaignEventRepository eventRepo;
    private final EmailTemplateRepository templateRepo;
    private final LandingPageRepository landingPageRepo;
    private final RecipientRepository recipientRepo;
    private final GophishClient gophishClient;

    public CampaignService(CampaignRepository campaignRepo,
                           CampaignRecipientRepository crRepo,
                           CampaignEventRepository eventRepo,
                           EmailTemplateRepository templateRepo,
                           LandingPageRepository landingPageRepo,
                           RecipientRepository recipientRepo,
                           GophishClient gophishClient) {
        this.campaignRepo = campaignRepo;
        this.crRepo = crRepo;
        this.eventRepo = eventRepo;
        this.templateRepo = templateRepo;
        this.landingPageRepo = landingPageRepo;
        this.recipientRepo = recipientRepo;
        this.gophishClient = gophishClient;
    }

    public Page<Campaign> findAll(String search, Pageable pageable) {
        return campaignRepo.search(search, pageable);
    }

    @Transactional(readOnly = true)
    public Page<CampaignCardSummary> cardSummaries(String search, Pageable pageable) {
        Page<Campaign> campaigns = campaignRepo.search(search, pageable);
        List<Long> campaignIds = campaigns.getContent().stream().map(Campaign::getId).toList();
        java.util.Map<Long, long[]> totals = new java.util.HashMap<>();

        if (!campaignIds.isEmpty()) {
            crRepo.findByCampaignIdIn(campaignIds).forEach(recipient -> {
                long[] metrics = totals.computeIfAbsent(recipient.getCampaign().getId(), ignored -> new long[5]);
                if (recipient.getSentAt() != null) metrics[0]++;
                if (recipient.getOpenedAt() != null) metrics[1]++;
                if (recipient.getClickedAt() != null) metrics[2]++;
                if (recipient.getSubmittedAt() != null) metrics[3]++;
                if (recipient.getTrainingCompletedAt() != null) metrics[4]++;
            });
        }

        return campaigns.map(campaign -> {
            long[] metrics = totals.getOrDefault(campaign.getId(), new long[5]);
            return new CampaignCardSummary(
                campaign.getId(), campaign.getName(), campaign.getDescription(), campaign.getStatus().name(),
                campaign.getTemplate().getName(), campaign.getLandingPage().getName(), campaign.getCreatedAt(),
                campaign.getScheduledAt(), campaign.getStartedAt(), metrics[0], metrics[1], metrics[2], metrics[3], metrics[4]
            );
        });
    }

    public Campaign findById(Long id) {
        return campaignRepo.findDetailedById(id)
                .orElseThrow(() -> new NotFoundException("Campaign not found with id: " + id));
    }

    @Transactional
    public Campaign create(CreateRequest request) {
        EmailTemplate template = templateRepo.findById(request.templateId())
                .orElseThrow(() -> new NotFoundException("Template not found with id: " + request.templateId()));
        LandingPage landingPage = landingPageRepo.findById(request.landingPageId())
                .orElseThrow(() -> new NotFoundException("Landing page not found with id: " + request.landingPageId()));

        Campaign campaign = new Campaign();
        campaign.setName(request.name());
        campaign.setDescription(request.description());
        campaign.setStatus(Campaign.Status.DRAFT);
        campaign.setTemplate(template);
        campaign.setLandingPage(landingPage);
        return campaignRepo.save(campaign);
    }

    @Transactional
    public Campaign update(Long id, UpdateRequest request) {
        Campaign campaign = findById(id);
        if (campaign.getStatus() != Campaign.Status.DRAFT) {
            throw new IllegalStateException("Only DRAFT campaigns can be modified");
        }
        if (request.name() != null) campaign.setName(request.name());
        if (request.description() != null) campaign.setDescription(request.description());
        if (request.templateId() != null) {
            EmailTemplate template = templateRepo.findById(request.templateId())
                    .orElseThrow(() -> new NotFoundException("Template not found with id: " + request.templateId()));
            campaign.setTemplate(template);
        }
        if (request.landingPageId() != null) {
            LandingPage landingPage = landingPageRepo.findById(request.landingPageId())
                    .orElseThrow(() -> new NotFoundException("Landing page not found with id: " + request.landingPageId()));
            campaign.setLandingPage(landingPage);
        }
        return campaignRepo.save(campaign);
    }

    @Transactional
    public void delete(Long id) {
        Campaign campaign = findById(id);
        if (campaign.getStatus() == Campaign.Status.RUNNING) {
            throw new IllegalStateException("No se puede eliminar una campaña en curso");
        }
        if (campaign.getGophishCampaignId() != null) {
            try {
                gophishClient.deleteCampaign(campaign.getGophishCampaignId());
            } catch (Exception ex) {
                log.warn("No se pudo borrar la campaña {} en GoPhish: {}", campaign.getGophishCampaignId(), ex.getMessage());
            }
        }
        List<CampaignRecipient> recipients = crRepo.findByCampaignId(id);
        recipients.forEach(cr -> eventRepo.deleteAll(eventRepo.findByCampaignRecipientIdOrderByEventTimeAsc(cr.getId())));
        crRepo.deleteAll(recipients);
        campaignRepo.delete(campaign);
    }

    @Transactional
    public List<CampaignRecipientResponse> addRecipients(Long campaignId, List<Long> recipientIds) {
        Campaign campaign = findById(campaignId);
        if (campaign.getStatus() != Campaign.Status.DRAFT) {
            throw new IllegalStateException("Only DRAFT campaigns can have recipients added");
        }

        List<Recipient> recipients = recipientRepo.findAllById(recipientIds);
        if (recipients.size() != recipientIds.size()) {
            throw new IllegalArgumentException("Some recipients were not found");
        }

        return recipients.stream().map(recipient -> {
            if (crRepo.findByCampaignIdAndRecipientId(campaignId, recipient.getId()).isPresent()) {
                throw new IllegalArgumentException("Recipient " + recipient.getId() + " is already in this campaign");
            }

            CampaignRecipient cr = new CampaignRecipient();
            cr.setCampaign(campaign);
            cr.setRecipient(recipient);
            cr.setTrackingToken(UUID.randomUUID().toString());
            CampaignRecipient saved = crRepo.save(cr);
            return new CampaignRecipientResponse(
                saved.getId(), recipient.getId(), recipient.getName(), recipient.getEmail(),
                saved.getTrackingToken(), "PENDING",
                null, null, null, null, null, null, null, null, null
            );
        }).toList();
    }

    @Transactional(readOnly = true)
    public List<CampaignRecipientResponse> listRecipients(Long campaignId) {
        Campaign campaign = findById(campaignId);
        List<CampaignRecipient> recipients = crRepo.findByCampaignId(campaignId);
        return recipients.stream()
                .map(cr -> new CampaignRecipientResponse(
                    cr.getId(),
                    cr.getRecipient().getId(),
                    cr.getRecipient().getName(),
                    cr.getRecipient().getEmail(),
                    cr.getTrackingToken(),
                    deriveStatus(cr),
                    cr.getSentAt(),
                    cr.getOpenedAt(),
                    cr.getClickedAt(),
                    cr.getLandingViewedAt(),
                    cr.getSubmittedAt(),
                    cr.getReportedAt(),
                    cr.getTrainingViewedAt(),
                    cr.getDeliveredAt(),
                    cr.getTrainingCompletedAt()
                ))
                .toList();
    }

    private String deriveStatus(CampaignRecipient cr) {
        if (cr.getTrainingCompletedAt() != null) return "TRAINING_COMPLETED";
        if (cr.getTrainingViewedAt() != null) return "TRAINING_VIEWED";
        if (cr.getSubmittedAt() != null) return "FORM_SUBMITTED";
        if (cr.getLandingViewedAt() != null) return "LANDING_VIEWED";
        if (cr.getClickedAt() != null) return "LINK_CLICKED";
        if (cr.getOpenedAt() != null) return "EMAIL_OPENED";
        if (cr.getDeliveredAt() != null) return "EMAIL_DELIVERED";
        if (cr.getSentAt() != null) return "EMAIL_SENT";
        return "PENDING";
    }

    public record CreateRequest(String name, String description, Long templateId, Long landingPageId) {}
    public record UpdateRequest(String name, String description, Long templateId, Long landingPageId) {}
    public record BatchAddRecipientsRequest(List<Long> recipientIds) {}
    public record CampaignStats(long totalSent, long totalOpened, long totalClicked, long totalSubmitted,
                                long totalReported, long totalTrainingViewed, long totalTrainingCompleted,
                                double openRate, double clickRate, double submitRate, double trainingRate) {}
    public record EventResponse(Long id, String type, java.time.LocalDateTime eventTime,
                                String recipientName, String recipientEmail) {}
    public record CampaignSummary(Long id, String name, String status, java.time.LocalDateTime createdAt) {}
    public record CampaignCardSummary(Long id, String name, String description, String status,
                                      String templateName, String landingPageName,
                                      java.time.LocalDateTime createdAt, java.time.LocalDateTime scheduledAt,
                                      java.time.LocalDateTime startedAt, long totalSent, long totalOpened,
                                      long totalClicked, long totalSubmitted, long totalTrainingCompleted) {}
    public record DashboardSummary(long activeCampaigns, long totalCampaigns, long totalSent, long totalOpened,
                                   long totalClicked, long totalSubmitted, long totalReported, long totalTrainingViewed,
                                   long totalTrainingCompleted,
                                   List<CampaignSummary> recentCampaigns) {}
    public record LaunchRequest(java.time.OffsetDateTime scheduledAt, Integer durationMinutes) {}

    @Transactional
    public Campaign launch(Long id, java.time.OffsetDateTime scheduledAt, Integer durationMinutes) {
        Campaign campaign = findById(id);
        if (campaign.getStatus() != Campaign.Status.DRAFT) {
            throw new IllegalStateException("Only DRAFT campaigns can be launched");
        }
        List<CampaignRecipient> recipients = crRepo.findByCampaignId(id);
        if (recipients.isEmpty()) throw new IllegalStateException("Add at least one recipient before launching");

        if (durationMinutes != null && (durationMinutes < 1 || durationMinutes > 1440)) {
            throw new IllegalArgumentException("Duration must be between 1 and 1440 minutes");
        }

        java.time.LocalDateTime scheduledAtUtc = scheduledAt == null ? null
                : scheduledAt.withOffsetSameInstant(java.time.ZoneOffset.UTC).toLocalDateTime();
        GophishClient.ProvisionedCampaign provisioned = gophishClient.provision(campaign, recipients, scheduledAtUtc, durationMinutes);
        campaign.setGophishCampaignId(provisioned.id());
        java.time.LocalDateTime launchAt = scheduledAtUtc != null && scheduledAtUtc.isAfter(java.time.LocalDateTime.now())
                ? scheduledAtUtc : java.time.LocalDateTime.now();
        campaign.setSendByAt(launchAt.plusMinutes(durationMinutes == null ? 5 : durationMinutes));
        if (scheduledAtUtc != null && scheduledAtUtc.isAfter(java.time.LocalDateTime.now())) {
            campaign.setScheduledAt(scheduledAtUtc);
            campaign.setStatus(Campaign.Status.SCHEDULED);
        } else {
            markRunning(campaign, recipients);
        }
        return campaignRepo.save(campaign);
    }

    @Transactional
    public void activateScheduledCampaigns() {
        java.time.LocalDateTime now = java.time.LocalDateTime.now();
        campaignRepo.findByStatusAndScheduledAtLessThanEqual(Campaign.Status.SCHEDULED, now)
                .forEach(campaign -> markRunning(campaign, crRepo.findByCampaignId(campaign.getId())));
        campaignRepo.findByStatusAndSendByAtLessThanEqual(Campaign.Status.RUNNING, now)
                .forEach(campaign -> {
                    campaign.setStatus(Campaign.Status.COMPLETED);
                    campaign.setCompletedAt(now);
                });
        campaignRepo.findByStatusAndSendByAtIsNullAndStartedAtLessThanEqual(
                        Campaign.Status.RUNNING, now.minusMinutes(5))
                .forEach(campaign -> {
                    campaign.setStatus(Campaign.Status.COMPLETED);
                    campaign.setCompletedAt(now);
                });
    }

    private void markRunning(Campaign campaign, List<CampaignRecipient> recipients) {
        java.time.LocalDateTime now = java.time.LocalDateTime.now();
        campaign.setStatus(Campaign.Status.RUNNING);
        campaign.setStartedAt(now);
        campaign.setSentAt(now);
        for (CampaignRecipient cr : recipients) {
            if (cr.getSentAt() == null) {
                cr.setSentAt(now);
                crRepo.save(cr);
                CampaignEvent event = new CampaignEvent();
                event.setCampaignRecipient(cr);
                event.setEventType(CampaignEvent.EventType.EMAIL_SENT);
                event.setEventTime(now);
                eventRepo.save(event);
            }
        }
    }

    @Transactional(readOnly = true)
    public CampaignStats stats(Long id) {
        findById(id);
        long sent = crRepo.countByCampaignIdAndSentAtIsNotNull(id);
        long opened = crRepo.countByCampaignIdAndOpenedAtIsNotNull(id);
        long clicked = crRepo.countByCampaignIdAndClickedAtIsNotNull(id);
        long submitted = crRepo.countByCampaignIdAndSubmittedAtIsNotNull(id);
        long completed = crRepo.countByCampaignIdAndTrainingCompletedAtIsNotNull(id);
        return new CampaignStats(sent, opened, clicked, submitted,
                crRepo.countByCampaignIdAndReportedAtIsNotNull(id),
                crRepo.countByCampaignIdAndTrainingViewedAtIsNotNull(id), completed,
                rate(opened, sent), rate(clicked, sent), rate(submitted, sent), rate(completed, sent));
    }

    @Transactional(readOnly = true)
    public List<EventResponse> events(Long id) {
        findById(id);
        return crRepo.findByCampaignId(id).stream()
                .flatMap(cr -> eventRepo.findByCampaignRecipientIdOrderByEventTimeAsc(cr.getId()).stream()
                        .map(event -> new EventResponse(event.getId(), event.getEventType().name(), event.getEventTime(),
                                cr.getRecipient().getName(), cr.getRecipient().getEmail())))
                .toList();
    }

    @Transactional(readOnly = true)
    public DashboardSummary dashboard() {
        List<CampaignSummary> recent = campaignRepo.findTop5ByOrderByCreatedAtDesc().stream()
                .map(c -> new CampaignSummary(c.getId(), c.getName(), c.getStatus().name(), c.getCreatedAt()))
                .toList();
        return new DashboardSummary(campaignRepo.countByStatus(Campaign.Status.RUNNING), campaignRepo.count(),
                crRepo.countBySentAtIsNotNull(), crRepo.countByOpenedAtIsNotNull(),
                crRepo.countByClickedAtIsNotNull(), crRepo.countBySubmittedAtIsNotNull(),
                crRepo.countByReportedAtIsNotNull(), crRepo.countByTrainingViewedAtIsNotNull(),
                crRepo.countByTrainingCompletedAtIsNotNull(), recent);
    }

    private static double rate(long numerator, long denominator) {
        return denominator == 0 ? 0 : Math.round(numerator * 10000.0 / denominator) / 100.0;
    }

    public record CampaignRecipientResponse(
        Long id, Long recipientId, String recipientName, String recipientEmail,
        String trackingToken, String status,
        java.time.LocalDateTime sentAt, java.time.LocalDateTime openedAt,
        java.time.LocalDateTime clickedAt, java.time.LocalDateTime landingViewedAt,
        java.time.LocalDateTime submittedAt, java.time.LocalDateTime reportedAt,
        java.time.LocalDateTime trainingViewedAt,
        java.time.LocalDateTime deliveredAt,
        java.time.LocalDateTime trainingCompletedAt
    ) {}
}
