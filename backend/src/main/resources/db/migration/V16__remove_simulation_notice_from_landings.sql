-- V16: Remove the simulation notice from decorative landings.
-- User decision: maximum realism for the internal audit. The training notice
-- stays visible post-click on /training/{slug}, which is the compliance point.
-- Landing pages never capture credentials; they only register the submit event.

UPDATE landing_pages SET
  html = REPLACE(html,
    '<div class="foot">Términos de uso · Privacidad y cookies<br>Simulación de entrenamiento de seguridad</div>',
    '<div class="foot">Términos de uso · Privacidad y cookies</div>')
WHERE slug = 'm365-login';

UPDATE landing_pages SET
  html = REPLACE(html, '<div class="foot">Simulación de entrenamiento de seguridad</div>', '')
WHERE slug IN ('google-login', 'chatgpt-login', 'canva-login', 'linkedin-login',
               'instagram-login', 'facebook-login', 'okta-login', 'slack-login',
               'banca-login', 'benefits-review', 'new-activity');