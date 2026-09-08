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

    private static final String TRAINING_HTML = "<!DOCTYPE html><html lang='es'><head><meta charset='UTF-8'><meta name='viewport' content='width=device-width, initial-scale=1.0'>"
            + "<title>Entrenamiento de seguridad</title></head><body style='font-family:Arial,Helvetica,sans-serif;margin:0;background:#f2f4f8;color:#1e293b'>"
            + "<div style='max-width:620px;margin:40px auto;background:#fff;padding:36px;border-radius:12px;box-shadow:0 2px 12px rgba(0,0,0,.10)'>"
            + "<div style='background:#d93025;color:#fff;font-size:13px;font-weight:700;display:inline-block;padding:5px 12px;border-radius:4px;letter-spacing:.4px'>SIMULACRO CONTROLADO</div>"
            + "<h1 style='color:#1e293b;margin:18px 0 8px;font-size:24px'>Caíste en una simulación de phishing</h1>"
            + "<p style='color:#475569;font-size:15px;line-height:1.55;margin:0 0 6px'>Este mensaje formaba parte del programa interno de concienciación. "
            + "Ningún dato salió de tu cuenta y no hubo consecuencias: el objetivo es que aprendas a detectar el siguiente intento real.</p>"
            + "<h2 style='color:#1e293b;font-size:17px;margin:24px 0 10px'>Señales que debías notar</h2>"
            + "<ul style='color:#334155;font-size:14.5px;line-height:1.65;padding-left:20px;margin:0'>"
            + "<li><strong>Urgencia o amenaza:</strong> avisos de bloqueo, caducidad o verificación en 24 horas buscan que actúes sin pensar.</li>"
            + "<li><strong>Remitente:</strong> dominios parecidos pero alterados (empresa-soporte.com, cuenta.gmail-verify.co) o direcciones con números.</li>"
            + "<li><strong>Saludos genéricos:</strong> 'Estimado cliente' en vez de tu nombre.</li>"
            + "<li><strong>Enlaces:</strong> pasa el cursor sin hacer clic y revisa el dominio real antes de pulsar.</li>"
            + "<li><strong>Solicitud de credenciales:</strong> ningún sistema legítimo te pide contraseña, código SMS o NIP por enlace.</li>"
            + "<li><strong>Errores de forma:</strong> ortografía, logotipos deformados o píxeles rotos.</li>"
            + "<li>Informa los correos sospechosos por el canal interno de seguridad.</li>"
            + "</ul>"
            + "<p style='color:#334155;font-size:14.5px;line-height:1.6;margin:16px 0 0'>Ante la duda: no hagas clic y reporta el correo por el canal interno de seguridad. "
            + "Un reporte equivocado es mejor que un clic equivocado.</p>"
            + "<div style='background:#eef2ff;border:1px solid #c7d2fe;border-radius:8px;padding:12px 16px;font-size:12.5px;color:#3730a3'>"
            + "Simulación: {SLUG} &middot; Programa de concienciación de seguridad</div>"
            + "<form id='training-quiz' style='margin-top:24px;border-top:1px solid #e2e8f0;padding-top:20px'>"
            + "<h2 style='color:#1e293b;font-size:17px;margin:0 0 14px'>Comprobación rápida (3 preguntas)</h2>"
            + "<p style='font-weight:700;color:#334155;font-size:14px;margin:14px 0 6px'>1. Un correo urgente te pide confirmar tu contraseña 'hoy mismo'. ¿Qué haces?</p>"
            + "<label style='display:block;padding:4px 0'><input type='radio' name='q1' value='1'> Introducir mis datos para evitar el bloqueo</label>"
            + "<label style='display:block;padding:4px 0'><input type='radio' name='q1' value='2'> No hacer clic y reportar el correo</label>"
            + "<label style='display:block;padding:4px 0'><input type='radio' name='q1' value='3'> Responder pidiendo más información</label>"
            + "<p style='font-weight:700;color:#334155;font-size:14px;margin:14px 0 6px'>2. ¿Qué debes revisar antes de confiar en un enlace?</p>"
            + "<label style='display:block;padding:4px 0'><input type='radio' name='q2' value='1'> Que el botón se vea grande y de confianza</label>"
            + "<label style='display:block;padding:4px 0'><input type='radio' name='q2' value='2'> El dominio real al pasar el cursor sobre el enlace</label>"
            + "<label style='display:block;padding:4px 0'><input type='radio' name='q2' value='3'> Que el correo tenga un logo de la empresa</label>"
            + "<p style='font-weight:700;color:#334155;font-size:14px;margin:14px 0 6px'>3. ¿Cuál es el mejor canal para verificar un aviso raro?</p>"
            + "<label style='display:block;padding:4px 0'><input type='radio' name='q3' value='1'> Llamar al número del propio correo</label>"
            + "<label style='display:block;padding:4px 0'><input type='radio' name='q3' value='2'> Responder al remitente</label>"
            + "<label style='display:block;padding:4px 0'><input type='radio' name='q3' value='3'> El canal oficial: teléfono de la organización o portal conocido</label>"
            + "<button type='submit' style='margin-top:18px;padding:11px 22px;background:#17324d;color:#fff;border:0;border-radius:6px;font-size:14px;font-weight:600;cursor:pointer'>Enviar respuestas</button>"
            + "</form><p id='quiz-result' style='font-weight:700;font-size:14px;margin-top:10px'></p>"
            + "<script>var answers={q1:2,q2:2,q3:3};"
            + "document.getElementById('training-quiz').addEventListener('submit',function(e){e.preventDefault();"
            + "var n=0;for(var k in answers){var v=document.querySelector('input[name='+k+']:checked');if(v&&parseInt(v.value)===answers[k]){n++;}}"
            + "var msg=(n===3)?'Excelente, 3 de 3. Ya puedes detectar este tipo de engaño.':('Respuestas correctas: '+n+' de 3. Repasa las señales de arriba.');"
            + "var el=document.getElementById('quiz-result');el.textContent=msg;el.style.color=(n===3)?'#16a34a':'#d97706';"
            + "fetch('/api/v1/tracking/{{TOKEN}}/training-complete',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({answer:n})})"
            + ".then(function(){});});</script>"
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
