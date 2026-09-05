-- Complete the initial library with two additional safe simulations.
INSERT INTO templates (name, description, category, difficulty, subject, html, active, created_at, updated_at)
SELECT 'Revision de beneficios', 'Aviso simulado de Recursos Humanos con enlace de revision.', 'HR', 'MEDIUM',
       'Revisa tu nuevo resumen de beneficios',
       '<html><body><h1>Resumen de beneficios</h1><p>Hay un nuevo resumen disponible para revision.</p><p><a href="{{TRACKING_URL}}">Abrir resumen</a></p><img src="{{TRACKING_OPEN_PIXEL}}" width="1" height="1" alt=""><p><a href="{{TRACKING_REPORT_URL}}">Reportar phishing</a></p></body></html>',
       1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM templates WHERE name = 'Revision de beneficios');

INSERT INTO templates (name, description, category, difficulty, subject, html, active, created_at, updated_at)
SELECT 'Soporte: actividad inusual', 'Aviso simulado de soporte sobre una sesion nueva.', 'SUPPORT', 'HARD', 'Nueva actividad en tu cuenta',
       '<html><body><h1>Nueva actividad detectada</h1><p>Confirma si reconoces esta actividad en tu cuenta.</p><p><a href="{{TRACKING_URL}}">Ver actividad</a></p><img src="{{TRACKING_OPEN_PIXEL}}" width="1" height="1" alt=""><p><a href="{{TRACKING_REPORT_URL}}">Reportar phishing</a></p></body></html>',
       1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM templates WHERE name = 'Soporte: actividad inusual');

INSERT INTO landing_pages (name, slug, category, difficulty, html, active, created_at, updated_at)
SELECT 'Benefits Review', 'benefits-review', 'HR', 'MEDIUM',
       '<html><body><h1>Resumen de beneficios</h1><p>Esta es una pantalla de simulacion.</p><button id="sim-form">Ver resumen</button><script>document.getElementById("sim-form").onclick=function(){fetch("/api/v1/tracking/{{TOKEN}}/submit",{method:"POST"}).then(function(){location.href="/training/{{SLUG}}?token={{TOKEN}}"})}</script></body></html>',
       1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM landing_pages WHERE slug = 'benefits-review');

INSERT INTO landing_pages (name, slug, category, difficulty, html, active, created_at, updated_at)
SELECT 'New Activity Notice', 'new-activity', 'SUPPORT', 'HARD',
       '<html><body><h1>Nueva actividad</h1><p>Esta es una pantalla de simulacion, no introduzcas credenciales.</p><button id="sim-form">Continuar</button><script>document.getElementById("sim-form").onclick=function(){fetch("/api/v1/tracking/{{TOKEN}}/submit",{method:"POST"}).then(function(){location.href="/training/{{SLUG}}?token={{TOKEN}}"})}</script></body></html>',
       1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM landing_pages WHERE slug = 'new-activity');
