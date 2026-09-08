-- V23: Restore the original Jovyweb landing header.
-- Keep the existing mascot/logo treatment and show only "Bienvenidos".

UPDATE landing_pages
SET html = REPLACE(
    html,
    '<div style="display:flex;align-items:center;gap:10px;margin-top:28px;color:#ffffff;font-size:24px;font-weight:700;"><svg xmlns="http://www.w3.org/2000/svg" width="34" height="34" viewBox="0 0 40 40"><rect width="40" height="40" rx="9" fill="#ffffff"/><path d="M25 9v15.5c0 4.5-2.3 6.5-6.4 6.5-2.2 0-4.1-.7-5.6-2.1l2.2-3.2c1 .9 2 1.4 3.1 1.4 1.4 0 2.1-.8 2.1-2.6V9H25z" fill="#0967c9"/></svg><span>Jovyweb</span></div><h1 class="welcome-title" style="margin-top:14px;">Bienvenidos</h1>',
    '<h1 class="welcome-title">Bienvenidos</h1>'
)
WHERE slug = 'jovyweb-nueva-contrasena';
