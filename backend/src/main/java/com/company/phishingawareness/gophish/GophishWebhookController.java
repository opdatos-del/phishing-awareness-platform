package com.company.phishingawareness.gophish;

import java.time.LocalDateTime;
import java.util.Locale;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.company.phishingawareness.campaign.CampaignEvent;
import com.company.phishingawareness.campaign.CampaignEventRepository;
import com.company.phishingawareness.campaign.CampaignRecipient;
import com.company.phishingawareness.campaign.CampaignRecipientRepository;
import com.company.phishingawareness.campaign.CampaignRepository;

@RestController
@RequestMapping("/api/v1/integrations/gophish")
public class GophishWebhookController {
    private final CampaignRepository campaignRepository;
    private final CampaignRecipientRepository recipientRepository;
    private final CampaignEventRepository eventRepository;

    public GophishWebhookController(CampaignRepository campaignRepository,
                                    CampaignRecipientRepository recipientRepository,
                                    CampaignEventRepository eventRepository) {
        this.campaignRepository = campaignRepository;
        this.recipientRepository = recipientRepository;
        this.eventRepository = eventRepository;
    }

    @PostMapping("/webhook")
    public ResponseEntity<Map<String, String>> receive(@RequestBody Map<String, Object> payload,
                                                       @RequestHeader(value = "X-Gophish-Event", required = false) String eventHeader) {
        Long campaignId = firstLong(payload, "campaign_id", "campaignId", "id");
        String email = firstText(payload, "email", "recipient_email");
        String recipientId = firstText(payload, "recipient_id", "rid", "id");
        CampaignRecipient target = null;

        if (campaignId != null && email != null) {
            target = recipientRepository.findByCampaignGophishCampaignIdAndRecipientEmail(campaignId, email).orElse(null);
        }
        if (target == null && campaignId != null && recipientId != null) {
            target = recipientRepository.findByCampaignGophishCampaignIdAndGophishRecipientId(campaignId, recipientId).orElse(null);
        }
        if (target == null && email != null) {
            target = recipientRepository.findAll().stream()
                    .filter(cr -> email.equalsIgnoreCase(cr.getRecipient().getEmail()))
                    .findFirst().orElse(null);
        }
        if (target == null) return ResponseEntity.ok(Map.of("status", "ignored"));

        String event = eventHeader != null ? eventHeader : firstText(payload, "event", "type", "status");
        mapEvent(target, normalize(event), firstText(payload, "user_agent", "userAgent"));
        return ResponseEntity.ok(Map.of("status", "recorded"));
    }

    private void mapEvent(CampaignRecipient target, String event, String userAgent) {
        CampaignEvent.EventType type = switch (event) {
            case "emailsent", "sent", "email_sent" -> CampaignEvent.EventType.EMAIL_SENT;
            case "emaildelivered", "delivered", "email_delivered" -> CampaignEvent.EventType.EMAIL_DELIVERED;
            case "emailopened", "opened", "email_opened" -> CampaignEvent.EventType.EMAIL_OPENED;
            case "clickedlink", "linkclicked", "clicked", "link_clicked" -> CampaignEvent.EventType.LINK_CLICKED;
            case "emailreported", "reported", "email_reported" -> CampaignEvent.EventType.EMAIL_REPORTED;
            case "submitteddata", "formsubmitted", "submitted", "form_submitted" -> CampaignEvent.EventType.FORM_SUBMITTED;
            default -> null;
        };
        if (type == null) return;

        LocalDateTime now = LocalDateTime.now();
        boolean first = switch (type) {
            case EMAIL_SENT -> target.getSentAt() == null;
            case EMAIL_DELIVERED -> target.getDeliveredAt() == null;
            case EMAIL_OPENED -> target.getOpenedAt() == null;
            case LINK_CLICKED -> target.getClickedAt() == null;
            case EMAIL_REPORTED -> target.getReportedAt() == null;
            case FORM_SUBMITTED -> target.getSubmittedAt() == null;
            default -> true;
        };
        if (!first) return;
        switch (type) {
            case EMAIL_SENT -> target.setSentAt(now);
            case EMAIL_DELIVERED -> target.setDeliveredAt(now);
            case EMAIL_OPENED -> target.setOpenedAt(now);
            case LINK_CLICKED -> target.setClickedAt(now);
            case EMAIL_REPORTED -> target.setReportedAt(now);
            case FORM_SUBMITTED -> target.setSubmittedAt(now);
            default -> { }
        }
        recipientRepository.save(target);
        CampaignEvent campaignEvent = new CampaignEvent();
        campaignEvent.setCampaignRecipient(target);
        campaignEvent.setEventType(type);
        campaignEvent.setEventTime(now);
        campaignEvent.setUserAgent(userAgent);
        eventRepository.save(campaignEvent);
    }

    private static String normalize(String value) {
        return value == null ? "" : value.toLowerCase(Locale.ROOT).replaceAll("[^a-z_]", "");
    }

    private static String firstText(Map<String, Object> node, String... fields) {
        for (String field : fields) if (node.get(field) != null) return String.valueOf(node.get(field));
        return null;
    }

    private static Long firstLong(Map<String, Object> node, String... fields) {
        for (String field : fields) {
            Object value = node.get(field);
            if (value instanceof Number number) return number.longValue();
            if (value != null) try { return Long.valueOf(value.toString()); } catch (NumberFormatException ignored) { }
        }
        return null;
    }
}
