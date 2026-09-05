package com.company.phishingawareness.gophish;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import com.company.phishingawareness.campaign.Campaign;
import com.company.phishingawareness.campaign.CampaignEvent;
import com.company.phishingawareness.campaign.CampaignEventRepository;
import com.company.phishingawareness.campaign.CampaignRecipient;
import com.company.phishingawareness.campaign.CampaignRecipientRepository;
import com.company.phishingawareness.campaign.CampaignRepository;

/** Pulls GoPhish open/click results into the local funnel.
 *
 *  GoPhish does not publish webhooks for opens/clicks, so a scheduled poller
 *  is the single source of delivery events. Results are matched by the
 *  gophish campaign id plus the recipient e-mail (and a gophish rid fallback).
 */
@Component
public class GophishResultsPoller {

    private static final Logger log = LoggerFactory.getLogger(GophishResultsPoller.class);

    private final GophishClient client;
    private final CampaignRepository campaignRepo;
    private final CampaignRecipientRepository recipientRepo;
    private final CampaignEventRepository eventRepo;

    public GophishResultsPoller(GophishClient client,
                                CampaignRepository campaignRepo,
                                CampaignRecipientRepository recipientRepo,
                                CampaignEventRepository eventRepo) {
        this.client = client;
        this.campaignRepo = campaignRepo;
        this.recipientRepo = recipientRepo;
        this.eventRepo = eventRepo;
    }

    @Scheduled(fixedDelayString = "${gophish.results-poll-delay-ms:30000}")
    @Transactional
    public void poll() {
        if (!client.isConfigured()) return;
        List<Campaign> campaigns = campaignRepo.findByGophishCampaignIdIsNotNull();
        for (Campaign campaign : campaigns) {
            if (campaign.getStatus() == Campaign.Status.CANCELLED) continue;
            processCampaign(campaign);
        }
    }

    private void processCampaign(Campaign campaign) {
        List<Map<String, Object>> results;
        try {
            results = client.campaignResults(campaign.getGophishCampaignId());
        } catch (RuntimeException e) {
            log.warn("gophish: no se pudieron leer resultados de campaña {}: {}", campaign.getGophishCampaignId(), e.getMessage());
            return;
        }
        List<CampaignRecipient> local = recipientRepo.findByCampaignGophishCampaignId(campaign.getGophishCampaignId());
        for (Map<String, Object> result : results) {
            String email = text(result, "email");
            CampaignRecipient target = local.stream()
                    .filter(cr -> email != null && email.equalsIgnoreCase(cr.getRecipient().getEmail()))
                    .findFirst().orElse(null);
            if (target == null) continue;

            String status = normalize(text(result, "status"));
            LocalDateTime opened = time(result, "opened_at");
            LocalDateTime clicked = time(result, "clicked_at");
            if (opened == null && status.contains("opened")) opened = LocalDateTime.now();
            if (clicked == null && status.contains("clicked")) clicked = LocalDateTime.now();
            // Un click implica que el destinatario abrió el correo antes.
            if (opened == null && clicked != null) opened = clicked;

            apply(target, CampaignEvent.EventType.EMAIL_OPENED,
                    target.getOpenedAt(), opened, (cr, ts) -> cr.setOpenedAt(ts));
            apply(target, CampaignEvent.EventType.LINK_CLICKED,
                    target.getClickedAt(), clicked, (cr, ts) -> cr.setClickedAt(ts));
        }
    }

    private void apply(CampaignRecipient target, CampaignEvent.EventType type,
                       LocalDateTime existing, LocalDateTime incoming,
                       java.util.function.BiConsumer<CampaignRecipient, LocalDateTime> setter) {
        if (incoming == null || existing != null) return;
        setter.accept(target, incoming);
        recipientRepo.save(target);
        CampaignEvent event = new CampaignEvent();
        event.setCampaignRecipient(target);
        event.setEventType(type);
        event.setEventTime(incoming);
        eventRepo.save(event);
        log.info("gophish: {} registrado para {}", type, target.getRecipient().getEmail());
    }

    private static String normalize(String value) {
        return value == null ? "" : value.toLowerCase(Locale.ROOT).replaceAll("[^a-z_]", "");
    }

    private static String text(Map<String, Object> node, String field) {
        Object value = node.get(field);
        return value == null ? null : String.valueOf(value);
    }

    private static LocalDateTime time(Map<String, Object> node, String field) {
        Object value = node.get(field);
        if (value == null || String.valueOf(value).isBlank()) return null;
        try { return LocalDateTime.parse(String.valueOf(value)); }
        catch (Exception ignored) { return null; }
    }
}
