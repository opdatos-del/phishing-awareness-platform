package com.company.phishingawareness.tracking;

import java.time.LocalDateTime;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.company.phishingawareness.campaign.Campaign;
import com.company.phishingawareness.campaign.CampaignEvent;
import com.company.phishingawareness.campaign.CampaignEventRepository;
import com.company.phishingawareness.campaign.CampaignRecipient;
import com.company.phishingawareness.campaign.CampaignRecipientRepository;
import com.company.phishingawareness.landing.LandingPage;

@RestController
public class TrackingController {

    private final CampaignRecipientRepository campaignRecipientRepository;
    private final CampaignEventRepository campaignEventRepository;

    public TrackingController(CampaignRecipientRepository campaignRecipientRepository,
                              CampaignEventRepository campaignEventRepository) {
        this.campaignRecipientRepository = campaignRecipientRepository;
        this.campaignEventRepository = campaignEventRepository;
    }

    @GetMapping("/t/{token}")
    public ResponseEntity<?> trackLink(@PathVariable String token,
                                       @RequestHeader(value = "User-Agent", required = false) String userAgent) {
        CampaignRecipient cr = campaignRecipientRepository.findByTrackingToken(token)
                .orElse(null);

        if (cr == null) {
            return ResponseEntity.notFound().build();
        }

        // Registrar LINK_CLICKED solo la primera vez
        if (cr.getClickedAt() == null) {
            cr.setClickedAt(LocalDateTime.now());
            campaignRecipientRepository.save(cr);

            CampaignEvent event = new CampaignEvent();
            event.setCampaignRecipient(cr);
            event.setEventType(CampaignEvent.EventType.LINK_CLICKED);
            event.setEventTime(LocalDateTime.now());
            event.setUserAgent(userAgent);
            campaignEventRepository.save(event);
        }

        // Redirigir a landing page correspondiente
        LandingPage landing = cr.getCampaign().getLandingPage();
        String landingUrl = "/landing/" + landing.getSlug() + "?token=" + token;
        return ResponseEntity.status(302).header("Location", landingUrl).build();
    }

    @PostMapping("/api/v1/tracking/{token}/landing-view")
    public ResponseEntity<?> landingView(@PathVariable String token,
                                         @RequestHeader(value = "User-Agent", required = false) String userAgent) {
        CampaignRecipient cr = findByTokenOrNotFound(token);
        if (cr == null) return ResponseEntity.notFound().build();

        if (cr.getLandingViewedAt() == null) {
            cr.setLandingViewedAt(LocalDateTime.now());
            campaignRecipientRepository.save(cr);
            registerEvent(cr, CampaignEvent.EventType.LANDING_VIEWED, userAgent);
        }

        return ResponseEntity.ok(Map.of("status", "recorded"));
    }

    @PostMapping("/api/v1/tracking/{token}/submit")
    public ResponseEntity<?> formSubmit(@PathVariable String token,
                                        @RequestHeader(value = "User-Agent", required = false) String userAgent) {
        CampaignRecipient cr = findByTokenOrNotFound(token);
        if (cr == null) return ResponseEntity.notFound().build();

        if (cr.getSubmittedAt() == null) {
            cr.setSubmittedAt(LocalDateTime.now());
            campaignRecipientRepository.save(cr);
            registerEvent(cr, CampaignEvent.EventType.FORM_SUBMITTED, userAgent);
        }

        return ResponseEntity.ok(Map.of("status", "recorded"));
    }

    @PostMapping("/api/v1/tracking/{token}/training-view")
    public ResponseEntity<?> trainingView(@PathVariable String token,
                                          @RequestHeader(value = "User-Agent", required = false) String userAgent) {
        CampaignRecipient cr = findByTokenOrNotFound(token);
        if (cr == null) return ResponseEntity.notFound().build();

        if (cr.getTrainingViewedAt() == null) {
            cr.setTrainingViewedAt(LocalDateTime.now());
            campaignRecipientRepository.save(cr);
            registerEvent(cr, CampaignEvent.EventType.TRAINING_VIEWED, userAgent);
        }

        return ResponseEntity.ok(Map.of("status", "recorded"));
    }

    private CampaignRecipient findByTokenOrNotFound(String token) {
        return campaignRecipientRepository.findByTrackingToken(token).orElse(null);
    }

    private void registerEvent(CampaignRecipient cr, CampaignEvent.EventType type, String userAgent) {
        CampaignEvent event = new CampaignEvent();
        event.setCampaignRecipient(cr);
        event.setEventType(type);
        event.setEventTime(LocalDateTime.now());
        event.setUserAgent(userAgent);
        campaignEventRepository.save(event);
    }
}
