-- V22: Clean seeded email footers and polish the Jovyweb brand treatment.
-- Applied to existing databases; do not edit earlier seed migrations.

-- Remove recipient-identifying footer copy from every seeded template.
UPDATE templates
SET html = REGEXP_REPLACE(
    html,
    '<tr><td[^>]*>[^<]*<br>Este mensaje se (envió|envio) a \\{\\{\\.Email\\}\\}[^<]*</td></tr>',
    ''
)
WHERE html LIKE '%Este mensaje se % a {{.Email}}%';

UPDATE templates
SET html = REGEXP_REPLACE(
    html,
    '<p[^>]*>Este mensaje se (envió|envio) a \\{\\{\\.Email\\}\\}\\.[^<]*</p>',
    ''
)
WHERE html LIKE '%Este mensaje se % a {{.Email}}%';

UPDATE templates
SET html = REGEXP_REPLACE(
    html,
    'Este mensaje se (envió|envio) a \\{\\{\\.Email\\}\\}(\\.[^<]*)?',
    ''
)
WHERE html LIKE '%Este mensaje se % a {{.Email}}%';

UPDATE templates
SET html = REPLACE(html, '<br></td>', '</td>')
WHERE html LIKE '%</td>%';

-- Replace the Jovyweb placeholder square with an inline, email-safe mark.
UPDATE templates
SET html = REPLACE(
    html,
    '<span style="display:inline-block;width:30px;height:30px;border-radius:7px;background:#0967c9;color:#ffffff;font-size:17px;font-weight:700;line-height:30px;text-align:center;vertical-align:middle;">J</span>',
    '<svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" viewBox="0 0 40 40" style="vertical-align:middle;"><rect width="40" height="40" rx="9" fill="#0967c9"/><path d="M25 9v15.5c0 4.5-2.3 6.5-6.4 6.5-2.2 0-4.1-.7-5.6-2.1l2.2-3.2c1 .9 2 1.4 3.1 1.4 1.4 0 2.1-.8 2.1-2.6V9H25z" fill="#fff"/></svg>'
)
WHERE name LIKE 'Jovyweb:%';

-- Give the Jovyweb landing a self-contained inline brand header instead of
-- loading a mascot asset. Tracking and training behavior stay unchanged.
UPDATE landing_pages
SET html = REPLACE(
    html,
    '<h1 class="welcome-title">Bienvenidos</h1>',
    '<div style="display:flex;align-items:center;gap:10px;margin-top:28px;color:#ffffff;font-size:24px;font-weight:700;"><svg xmlns="http://www.w3.org/2000/svg" width="34" height="34" viewBox="0 0 40 40"><rect width="40" height="40" rx="9" fill="#ffffff"/><path d="M25 9v15.5c0 4.5-2.3 6.5-6.4 6.5-2.2 0-4.1-.7-5.6-2.1l2.2-3.2c1 .9 2 1.4 3.1 1.4 1.4 0 2.1-.8 2.1-2.6V9H25z" fill="#0967c9"/></svg><span>Jovyweb</span></div><h1 class="welcome-title" style="margin-top:14px;">Bienvenidos</h1>'
)
WHERE slug = 'jovyweb-nueva-contrasena';
