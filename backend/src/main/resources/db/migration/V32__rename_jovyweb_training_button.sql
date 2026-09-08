-- V32: Use the requested label while keeping the safe training destination.

UPDATE landing_pages
SET html = REPLACE(html, 'Ver aprendizaje', 'Iniciar sesi&#243;n')
WHERE slug = 'jovyweb-nueva-contrasena';
