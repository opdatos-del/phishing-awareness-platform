package com.company.phishingawareness;

import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;

import com.company.phishingawareness.landing.LandingPage;
import com.company.phishingawareness.landing.LandingPageRepository;
import com.company.phishingawareness.recipient.Recipient;
import com.company.phishingawareness.recipient.RecipientRepository;
import com.company.phishingawareness.template.EmailTemplate;
import com.company.phishingawareness.template.EmailTemplateRepository;

@Configuration
@Profile("dev")
public class DevDataInitializer {

    @Bean
    CommandLineRunner initData(RecipientRepository recipientRepo,
                               EmailTemplateRepository templateRepo,
                               LandingPageRepository landingPageRepo) {
        return args -> {
            // Seed recipients
            if (recipientRepo.count() == 0) {
                createRecipient(recipientRepo, "Juan Pérez", "juan.perez@company.com");
                createRecipient(recipientRepo, "María García", "maria.garcia@company.com");
                createRecipient(recipientRepo, "Carlos López", "carlos.lopez@company.com");
                createRecipient(recipientRepo, "Ana Martínez", "ana.martinez@company.com");
                createRecipient(recipientRepo, "Roberto Sánchez", "roberto.sanchez@company.com");
                createRecipient(recipientRepo, "Laura Fernández", "laura.fernandez@company.com");
                createRecipient(recipientRepo, "Pedro Ramírez", "pedro.ramirez@company.com");
                createRecipient(recipientRepo, "Carmen Torres", "carmen.torres@company.com");
                createRecipient(recipientRepo, "Diego Morales", "diego.morales@company.com");
                createRecipient(recipientRepo, "Isabel Ruiz", "isabel.ruiz@company.com");
            }

            // Seed templates
            if (templateRepo.count() == 0) {
                createTemplate(templateRepo, "Urgente: Actualiza tu contraseña",
                    "Simula un correo de IT solicitando cambio de contraseña urgente",
                    EmailTemplate.Category.ACCOUNT, EmailTemplate.Difficulty.EASY,
                    "Urgente: Tu contraseña expira en 24 horas",
                    "<html><body><h1>Actualiza tu contraseña</h1><p>Tu contraseña expira pronto. Haz clic aquí para actualizarla.</p></body></html>");

                createTemplate(templateRepo, "Documento compartido en OneDrive",
                    "Simula una notificación de documento compartido",
                    EmailTemplate.Category.DOCUMENT, EmailTemplate.Difficulty.MEDIUM,
                    "Carlos compartió un documento contigo",
                    "<html><body><h1>Documento compartido</h1><p>Carlos ha compartido un documento en OneDrive.</p></body></html>");

                createTemplate(templateRepo, "Alerta de seguridad en tu cuenta",
                    "Simula una alerta de actividad sospechosa",
                    EmailTemplate.Category.SECURITY, EmailTemplate.Difficulty.HARD,
                    "Actividad sospechosa detectada en tu cuenta",
                    "<html><body><h1>Alerta de seguridad</h1><p>Hemos detectado actividad inusual en tu cuenta.</p></body></html>");
            }

            // Seed landing pages
            if (landingPageRepo.count() == 0) {
                createLandingPage(landingPageRepo, "Login Corporativo Fake",
                    "corporate-login",
                    LandingPage.Category.ACCOUNT, LandingPage.Difficulty.EASY,
                    "<html><body style='font-family:Arial,sans-serif;margin:0;background:#f0f2f5'>"
                    + "<div style='max-width:400px;margin:60px auto;background:#fff;padding:30px;border-radius:8px;box-shadow:0 2px 10px rgba(0,0,0,.15)'>"
                    + "<h2 style='margin-top:0;color:#333'>Verificacion de cuenta</h2>"
                    + "<p style='color:#555'>Su sesion ha expirado. Verifique sus datos para continuar.</p>"
                    + "<form id='sim-form'>"
                    + "<input type='text' placeholder='Usuario' value='demo' style='width:100%;padding:10px;margin:8px 0;box-sizing:border-box'>"
                    + "<input type='password' placeholder='Contrasena' value='********' style='width:100%;padding:10px;margin:8px 0;box-sizing:border-box'>"
                    + "<button type='submit' style='width:100%;padding:12px;background:#1a73e8;color:#fff;border:none;border-radius:4px;cursor:pointer'>Iniciar sesion</button>"
                    + "</form></div>"
                    + "<script>"
                    + "(function(){var f=document.getElementById('sim-form');f.addEventListener('submit',function(e){e.preventDefault();"
                    + "fetch('/api/v1/tracking/{{TOKEN}}/submit',{method:'POST'}).then(function(){"
                    + "window.location.href='/training/{{SLUG}}?token={{TOKEN}}';});});})();"
                    + "</script></body></html>");

                createLandingPage(landingPageRepo, "OneDrive Document View",
                    "onedrive-document",
                    LandingPage.Category.DOCUMENT, LandingPage.Difficulty.MEDIUM,
                    "<html><body style='font-family:Arial,sans-serif;margin:0;background:#f0f2f5'>"
                    + "<div style='max-width:420px;margin:60px auto;background:#fff;padding:30px;border-radius:8px;box-shadow:0 2px 10px rgba(0,0,0,.15)'>"
                    + "<h2 style='margin-top:0;color:#333'>Documento compartido</h2>"
                    + "<p style='color:#555'>Un usuario compartio un documento contigo en OneDrive.</p>"
                    + "<button id='sim-form' style='width:100%;padding:12px;background:#28a745;color:#fff;border:none;border-radius:4px;cursor:pointer'>Descargar documento</button>"
                    + "</div>"
                    + "<script>"
                    + "(function(){var f=document.getElementById('sim-form');f.addEventListener('click',function(e){"
                    + "fetch('/api/v1/tracking/{{TOKEN}}/submit',{method:'POST'}).then(function(){"
                    + "window.location.href='/training/{{SLUG}}?token={{TOKEN}}';});});})();"
                    + "</script></body></html>");

                createLandingPage(landingPageRepo, "Security Alert Portal",
                    "security-alert",
                    LandingPage.Category.SECURITY, LandingPage.Difficulty.HARD,
                    "<html><body style='font-family:Arial,sans-serif;margin:0;background:#f0f2f5'>"
                    + "<div style='max-width:400px;margin:60px auto;background:#fff;padding:30px;border-radius:8px;box-shadow:0 2px 10px rgba(0,0,0,.15)'>"
                    + "<h2 style='margin-top:0;color:#d93025'>Alerta de seguridad</h2>"
                    + "<p style='color:#555'>Detectamos actividad inusual. Verifique su identidad para reactivar la cuenta.</p>"
                    + "<form id='sim-form'>"
                    + "<input type='text' placeholder='Usuario' value='demo' style='width:100%;padding:10px;margin:8px 0;box-sizing:border-box'>"
                    + "<input type='password' placeholder='Contrasena' value='********' style='width:100%;padding:10px;margin:8px 0;box-sizing:border-box'>"
                    + "<button type='submit' style='width:100%;padding:12px;background:#d93025;color:#fff;border:none;border-radius:4px;cursor:pointer'>Verificar cuenta</button>"
                    + "</form></div>"
                    + "<script>"
                    + "(function(){var f=document.getElementById('sim-form');f.addEventListener('submit',function(e){e.preventDefault();"
                    + "fetch('/api/v1/tracking/{{TOKEN}}/submit',{method:'POST'}).then(function(){"
                    + "window.location.href='/training/{{SLUG}}?token={{TOKEN}}';});});})();"
                    + "</script></body></html>");
            }
        };
    }

    private void createRecipient(RecipientRepository repo, String name, String email) {
        Recipient r = new Recipient();
        r.setName(name);
        r.setEmail(email);
        r.setActive(true);
        repo.save(r);
    }

    private void createTemplate(EmailTemplateRepository repo, String name, String desc,
                                  EmailTemplate.Category cat, EmailTemplate.Difficulty diff,
                                  String subject, String html) {
        EmailTemplate t = new EmailTemplate();
        t.setName(name);
        t.setDescription(desc);
        t.setCategory(cat);
        t.setDifficulty(diff);
        t.setSubject(subject);
        t.setHtml(html);
        t.setActive(true);
        repo.save(t);
    }

    private void createLandingPage(LandingPageRepository repo, String name, String slug,
                                     LandingPage.Category cat, LandingPage.Difficulty diff,
                                     String html) {
        LandingPage lp = new LandingPage();
        lp.setName(name);
        lp.setSlug(slug);
        lp.setCategory(cat);
        lp.setDifficulty(diff);
        lp.setHtml(html);
        lp.setActive(true);
        repo.save(lp);
    }
}
