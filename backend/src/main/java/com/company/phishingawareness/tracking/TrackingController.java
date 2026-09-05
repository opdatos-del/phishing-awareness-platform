package com.company.phishingawareness.tracking;

import java.time.LocalDateTime;
import java.util.Base64;
import java.util.Map;

import org.springframework.http.CacheControl;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.company.phishingawareness.campaign.CampaignEvent;
import com.company.phishingawareness.campaign.CampaignEventRepository;
import com.company.phishingawareness.campaign.CampaignRecipient;
import com.company.phishingawareness.campaign.CampaignRecipientRepository;
import com.company.phishingawareness.landing.LandingPage;
import com.company.phishingawareness.landing.LandingPageRepository;

@RestController
public class TrackingController {

    private static final byte[] TRANSPARENT_PIXEL = Base64.getDecoder().decode(
            "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==");

    private static final String TRAINING_HTML = "<!DOCTYPE html><html><body style='font-family:Arial,sans-serif;margin:0;background:#f8f9fa'>"
            + "<div style='max-width:560px;margin:60px auto;background:#fff;padding:36px;border-radius:10px;box-shadow:0 2px 10px rgba(0,0,0,.12)'>"
            + "<h1 style='color:#d93025;margin-top:0'>Has caido en una simulacion de phishing</h1>"
            + "<p style='color:#333;font-size:16px;line-height:1.5'>Este era un ejercicio controlado del programa de concienciacion. "
            + "No se envio ningun dato personal ni se comprometio su cuenta.</p>"
            + "<h2 style='color:#333'>Como reconocerlo la proxima vez</h2>"
            + "<ul style='color:#333;font-size:15px;line-height:1.6'>"
            + "<li>Revisa siempre el remitente: dominios extranos o ligeramente alterados.</li>"
            + "<li>Desconfia de mensajes que crean urgencia o amenazan con bloquear tu cuenta.</li>"
            + "<li>Pasa el cursor sobre los enlaces antes de hacer clic y verifica la URL.</li>"
            + "<li>Nunca introduzcas tu contrasena desde un enlace de un correo.</li>"
            + "<li>Reporta correos sospechosos con el boton de reportar en tu cliente de correo.</li>"
            + "</ul>"
            + "<p style='color:#666;border-top:1px solid #eee;padding-top:16px'>Simulacion: {SLUG} · Programa de concienciacion de seguridad</p>"
            + "<form id='training-quiz'><h2 style='color:#333'>Comprobacion rapida</h2>"
            + "<label><input type='radio' name='answer' value='yes' required> Revisar remitente y URL antes de actuar</label><br>"
            + "<label><input type='radio' name='answer' value='no'> Compartir mi contrasena si el mensaje parece urgente</label><br>"
            + "<button type='submit' style='margin-top:16px;padding:10px 16px;background:#17324d;color:#fff;border:0;border-radius:5px'>Completar training</button>"
            + "</form><p id='quiz-result' style='color:#18864b'></p>"
            + "<script>document.getElementById('training-quiz').addEventListener('submit',function(e){e.preventDefault();"
            + "var a=document.querySelector('input[name=answer]:checked').value;fetch('/api/v1/tracking/{{TOKEN}}/training-complete',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({answer:a})})"
            + ".then(function(){document.getElementById('quiz-result').textContent='Training completado. Gracias por participar.';});});</script>"
            + "</div></body></html>";

    private final CampaignRecipientRepository campaignRecipientRepository;
    private final CampaignEventRepository campaignEventRepository;
    private final LandingPageRepository landingPageRepository;

    public TrackingController(CampaignRecipientRepository campaignRecipientRepository,
                              CampaignEventRepository campaignEventRepository,
                              LandingPageRepository landingPageRepository) {
        this.campaignRecipientRepository = campaignRecipientRepository;
        this.campaignEventRepository = campaignEventRepository;
        this.landingPageRepository = landingPageRepository;
    }

    @GetMapping("/t/{token}")
    public ResponseEntity<?> trackLink(@PathVariable String token,
                                       @RequestHeader(value = "User-Agent", required = false) String userAgent) {
        CampaignRecipient cr = findByTokenOrNotFound(token);

        if (cr == null) {
            return ResponseEntity.notFound().build();
        }

        // Registrar LINK_CLICKED solo la primera vez
        if (cr.getClickedAt() == null) {
            cr.setClickedAt(LocalDateTime.now());
            campaignRecipientRepository.save(cr);
            registerEvent(cr, CampaignEvent.EventType.LINK_CLICKED, userAgent);
        }

        // Redirigir a landing page correspondiente
        LandingPage landing = cr.getCampaign().getLandingPage();
        String landingUrl = "/landing/" + landing.getSlug() + "?token=" + token;
        return ResponseEntity.status(302).header("Location", landingUrl).build();
    }

    @GetMapping("/api/v1/tracking/{token}/open")
    public ResponseEntity<byte[]> trackOpen(@PathVariable String token,
                                            @RequestHeader(value = "User-Agent", required = false) String userAgent) {
        CampaignRecipient cr = findByTokenOrNotFound(token);

        if (cr == null) {
            return ResponseEntity.notFound().build();
        }

        if (cr.getOpenedAt() == null) {
            cr.setOpenedAt(LocalDateTime.now());
            campaignRecipientRepository.save(cr);
            registerEvent(cr, CampaignEvent.EventType.EMAIL_OPENED, userAgent);
        }

        return ResponseEntity.ok()
                .contentType(MediaType.IMAGE_PNG)
                .cacheControl(CacheControl.noCache())
                .body(TRANSPARENT_PIXEL);
    }

    @GetMapping("/landing/{slug}")
    public ResponseEntity<?> serveLanding(@PathVariable String slug,
                                          @RequestParam(required = false) String token,
                                          @RequestHeader(value = "User-Agent", required = false) String userAgent) {
        LandingPage landing = landingPageRepository.findBySlug(slug).orElse(null);

        if (landing == null || !Boolean.TRUE.equals(landing.getActive())) {
            return ResponseEntity.notFound().build();
        }

        if (token != null && !token.isBlank()) {
            CampaignRecipient cr = findByTokenOrNotFound(token);
            if (cr != null && cr.getLandingViewedAt() == null) {
                cr.setLandingViewedAt(LocalDateTime.now());
                campaignRecipientRepository.save(cr);
                registerEvent(cr, CampaignEvent.EventType.LANDING_VIEWED, userAgent);
            }
        }

        String safeToken = token == null ? "" : token;
        String html = landing.getHtml()
                .replace("{{TOKEN}}", safeToken)
                .replace("{{SLUG}}", slug);
        return ResponseEntity.ok().contentType(MediaType.TEXT_HTML).body(html);
    }

    @GetMapping("/training/{slug}")
    public ResponseEntity<?> serveTraining(@PathVariable String slug,
                                           @RequestParam(required = false) String token,
                                           @RequestHeader(value = "User-Agent", required = false) String userAgent) {
        if (token != null && !token.isBlank()) {
            CampaignRecipient cr = findByTokenOrNotFound(token);
            if (cr != null && cr.getTrainingViewedAt() == null) {
                cr.setTrainingViewedAt(LocalDateTime.now());
                campaignRecipientRepository.save(cr);
                registerEvent(cr, CampaignEvent.EventType.TRAINING_VIEWED, userAgent);
            }
        }

        String html = TRAINING_HTML.replace("{SLUG}", slug.replace('-', ' '))
                .replace("{{TOKEN}}", token == null ? "" : token);
        return ResponseEntity.ok().contentType(MediaType.TEXT_HTML).body(html);
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

    @PostMapping("/api/v1/tracking/{token}/training-complete")
    public ResponseEntity<?> trainingComplete(@PathVariable String token,
                                              @RequestHeader(value = "User-Agent", required = false) String userAgent) {
        CampaignRecipient cr = findByTokenOrNotFound(token);
        if (cr == null) return ResponseEntity.notFound().build();
        if (cr.getTrainingCompletedAt() == null) {
            cr.setTrainingCompletedAt(LocalDateTime.now());
            campaignRecipientRepository.save(cr);
            registerEvent(cr, CampaignEvent.EventType.TRAINING_COMPLETED, userAgent);
        }
        return ResponseEntity.ok(Map.of("status", "completed"));
    }

    @GetMapping("/api/v1/tracking/{token}/report")
    public ResponseEntity<?> reportGet(@PathVariable String token,
                                       @RequestHeader(value = "User-Agent", required = false) String userAgent) {
        return report(token, userAgent);
    }

    @PostMapping("/api/v1/tracking/{token}/report")
    public ResponseEntity<?> reportPost(@PathVariable String token,
                                        @RequestHeader(value = "User-Agent", required = false) String userAgent) {
        return report(token, userAgent);
    }

    private ResponseEntity<?> report(String token, String userAgent) {
        CampaignRecipient cr = findByTokenOrNotFound(token);
        if (cr == null) return ResponseEntity.notFound().build();
        if (cr.getReportedAt() == null) {
            cr.setReportedAt(LocalDateTime.now());
            campaignRecipientRepository.save(cr);
            registerEvent(cr, CampaignEvent.EventType.EMAIL_REPORTED, userAgent);
        }
        return ResponseEntity.ok(Map.of("status", "reported"));
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
