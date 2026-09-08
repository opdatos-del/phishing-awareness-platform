-- V34: Jovyweb landing - quitar del modal el aviso de simulacion de phishing.
-- Se elimina el parrafo pw-note completo (no solo el texto) para no dejar
-- un <p> vacio con margen. El modal queda: check, titulo, mensaje y boton.
-- Literales sin comillas simples; no-ASCII como entidades HTML.

UPDATE landing_pages
SET html = REPLACE(html, '<p class="pw-note">Esta fue una simulaci&#243;n de phishing. Tu contrase&#241;a real no fue guardada.</p>', '')
WHERE slug = 'jovyweb-nueva-contrasena';