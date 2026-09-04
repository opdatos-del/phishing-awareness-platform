package com.company.phishingawareness.campaign;

import java.util.List;
import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.company.phishingawareness.landing.LandingPage;
import com.company.phishingawareness.landing.LandingPageRepository;
import com.company.phishingawareness.recipient.Recipient;
import com.company.phishingawareness.recipient.RecipientRepository;
import com.company.phishingawareness.shared.NotFoundException;
import com.company.phishingawareness.template.EmailTemplate;
import com.company.phishingawareness.template.EmailTemplateRepository;

@Service
public class CampaignService {

    private final CampaignRepository campaignRepo;
    private final CampaignRecipientRepository crRepo;
    private final CampaignEventRepository eventRepo;
    private final EmailTemplateRepository templateRepo;
    private final LandingPageRepository landingPageRepo;
    private final RecipientRepository recipientRepo;

    public CampaignService(CampaignRepository campaignRepo,
                           CampaignRecipientRepository crRepo,
                           CampaignEventRepository eventRepo,
                           EmailTemplateRepository templateRepo,
                           LandingPageRepository landingPageRepo,
                           RecipientRepository recipientRepo) {
        this.campaignRepo = campaignRepo;
        this.crRepo = crRepo;
        this.eventRepo = eventRepo;
        this.templateRepo = templateRepo;
        this.landingPageRepo = landingPageRepo;
        this.recipientRepo = recipientRepo;
    }

    public Page<Campaign> findAll(Pageable pageable) {
        return campaignRepo.findAll(pageable);
    }

    public Campaign findById(Long id) {
        return campaignRepo.findById(id)
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
        if (campaign.getStatus() != Campaign.Status.DRAFT) {
            throw new IllegalStateException("Only DRAFT campaigns can be deleted");
        }
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
                null, null, null, null, null, null, null
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
                    cr.getTrainingViewedAt()
                ))
                .toList();
    }

    private String deriveStatus(CampaignRecipient cr) {
        if (cr.getTrainingViewedAt() != null) return "TRAINING_VIEWED";
        if (cr.getSubmittedAt() != null) return "FORM_SUBMITTED";
        if (cr.getLandingViewedAt() != null) return "LANDING_VIEWED";
        if (cr.getClickedAt() != null) return "LINK_CLICKED";
        if (cr.getOpenedAt() != null) return "EMAIL_OPENED";
        if (cr.getSentAt() != null) return "EMAIL_SENT";
        return "PENDING";
    }

    public record CreateRequest(String name, String description, Long templateId, Long landingPageId) {}
    public record UpdateRequest(String name, String description, Long templateId, Long landingPageId) {}
    public record BatchAddRecipientsRequest(List<Long> recipientIds) {}
    public record CampaignStats(long totalSent, long totalOpened, long totalClicked, long totalSubmitted) {}

    public record CampaignRecipientResponse(
        Long id, Long recipientId, String recipientName, String recipientEmail,
        String trackingToken, String status,
        java.time.LocalDateTime sentAt, java.time.LocalDateTime openedAt,
        java.time.LocalDateTime clickedAt, java.time.LocalDateTime landingViewedAt,
        java.time.LocalDateTime submittedAt, java.time.LocalDateTime reportedAt,
        java.time.LocalDateTime trainingViewedAt
    ) {}
}
