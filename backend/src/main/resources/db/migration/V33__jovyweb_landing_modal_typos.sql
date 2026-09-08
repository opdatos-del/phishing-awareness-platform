-- V33: Jovyweb landing - typos sutiles en el modal de resultado (post-caida).
-- El clon del formulario queda impecable; solo el modal de formacion lleva
-- errores ortograficos a proposito ("actulizada", "correctamete") para
-- reforzar la leccion de phishing despues de la caida.
-- Literales sin comillas simples; no-ASCII como entidades HTML.

UPDATE landing_pages
SET html = REPLACE(html, '<h2>Contrase&#241;a actualizada</h2>', '<h2>Contrase&#241;a actulizada</h2>')
WHERE slug = 'jovyweb-nueva-contrasena';

UPDATE landing_pages
SET html = REPLACE(html, '<p>La contrase&#241;a fue actualizada correctamente.</p>', '<p>La contrase&#241;a fue actualizada correctamete.</p>')
WHERE slug = 'jovyweb-nueva-contrasena';