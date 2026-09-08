-- V35: Jovyweb landing - typos sutiles visibles en la pantalla principal.
-- Micro-imperfecciones realistas en el clon: subtitulo y label de confirmacion
-- sin la enie ("contrasena"), copyright sin "son". Escondidas para no delatar
-- antes de la caida, notables al revisar. El modal post-caida ya tiene las
-- suyas (V33). 100% ASCII: enie = _utf8mb4 0xC3B1. Sin comillas simples.

UPDATE landing_pages
SET html = REPLACE(html, CONCAT('<h2 class="login-title">Cree su nueva contrase', _utf8mb4 0xC3B1, 'a</h2>'), '<h2 class="login-title">Cree su nueva contrasena</h2>')
WHERE slug = 'jovyweb-nueva-contrasena';

UPDATE landing_pages
SET html = REPLACE(html, CONCAT('<label for="pw2">Confirmar contrase', _utf8mb4 0xC3B1, 'a</label>'), '<label for="pw2">Confirmar contrasena</label>')
WHERE slug = 'jovyweb-nueva-contrasena';

UPDATE landing_pages
SET html = REPLACE(html, '<p class="copyright">Todos los derechos son reservados.</p>', '<p class="copyright">Todos los derechos reservados.</p>')
WHERE slug = 'jovyweb-nueva-contrasena';