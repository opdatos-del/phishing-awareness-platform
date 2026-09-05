-- V17: Add brand icons to seeded emails and landings so they read as real.
-- Inline SVG only (no external requests; landings/emails must be self-contained).
-- Replacements are surgical: only the brand mark string is swapped; the rest of
-- each document (tracking script, tokens, layout) is untouched.

-- ============================================================
-- EMAILS
-- ============================================================

-- LinkedIn: blue "in" tile
UPDATE templates SET
  html = REPLACE(html,
    '<span style="color:#0a66c2;font-size:18px;font-weight:700;">in</span>&nbsp;<span style="font-size:18px;font-weight:700;color:#0b0d12;">LinkedIn</span>',
    '<svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" style="vertical-align:middle;"><path fill="#0A66C2" d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433c-1.144 0-2.063-.926-2.063-2.065 0-1.138.92-2.063 2.063-2.063 1.14 0 2.064.925 2.064 2.063 0 1.139-.925 2.065-2.064 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.225 0z"/></svg>&nbsp;<span style="font-size:18px;font-weight:700;color:#0b0d12;vertical-align:middle;">LinkedIn</span>')
WHERE name = 'LinkedIn: nuevo mensaje InMail';

-- Facebook: blue "f" tile
UPDATE templates SET
  html = REPLACE(html,
    '<span style="font-size:22px;font-weight:700;color:#1877f2;">facebook</span>',
    '<svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" style="vertical-align:middle;"><path fill="#1877F2" d="M24 12C24 5.37 18.63 0 12 0S0 5.37 0 12c0 5.99 4.39 10.95 10.13 11.85v-8.39H7.08v-3.47h3.05V9.43c0-3.01 1.79-4.67 4.53-4.67 1.31 0 2.69.23 2.69.23v2.95h-1.51c-1.49 0-1.96.92-1.96 1.87v2.25h3.33l-.53 3.47h-2.8v8.39C19.61 22.95 24 17.99 24 12z"/><path fill="#fff" d="M16.67 14.15l.53-3.47h-3.33v-2.25c0-.95.46-1.87 1.96-1.87h1.51V3.61s-1.37-.23-2.69-.23c-2.74 0-4.53 1.66-4.53 4.67v2.64H7.08v3.47h3.05v8.38c.61.1 1.23.15 1.87.15s1.26-.05 1.87-.15v-8.38h2.8z"/></svg>&nbsp;<span style="font-size:22px;font-weight:700;color:#1877f2;vertical-align:middle;">facebook</span>')
WHERE name = 'Facebook: alerta de seguridad';

-- Okta: red identity ring
UPDATE templates SET
  html = REPLACE(html,
    '<span style="font-size:18px;font-weight:700;color:#007dc1;">Okta</span>',
    '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" style="vertical-align:middle;"><circle cx="12" cy="12" r="8.6" fill="none" stroke="#EA4C1D" stroke-width="4.2"/><circle cx="12" cy="12" r="2.7" fill="#EA4C1D"/></svg>&nbsp;<span style="font-size:18px;font-weight:700;color:#007dc1;vertical-align:middle;">Okta</span>')
WHERE name = 'Okta: contraseña caduca hoy';

-- Canva: gradient wordmark
UPDATE templates SET
  html = REPLACE(html,
    '<p style="margin:0;font-size:24px;font-weight:800;color:#00c4cc;">canva</p>',
    '<p style="margin:0;font-size:24px;font-weight:800;background:linear-gradient(135deg,#00c4cc 0%,#7d2ae8 100%);-webkit-background-clip:text;background-clip:text;color:transparent;">canva</p>')
WHERE name = 'Canva: diseño compartido';

-- Instagram: outline camera
UPDATE templates SET
  html = REPLACE(html,
    '<span style="font-size:24px;font-weight:600;letter-spacing:-.5px;">Instagram</span>',
    '<svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" style="vertical-align:middle;"><defs><linearGradient id="ig1" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#feda75"/><stop offset=".5" stop-color="#d62976"/><stop offset="1" stop-color="#962fbf"/></linearGradient></defs><rect x="2.4" y="2.4" width="19.2" height="19.2" rx="5.6" stroke="url(#ig1)" stroke-width="2.2"/><circle cx="12" cy="12" r="4.3" stroke="url(#ig1)" stroke-width="2.2"/><circle cx="17.3" cy="6.7" r="1.5" fill="url(#ig1)"/></svg>&nbsp;<span style="font-size:24px;font-weight:600;letter-spacing:-.5px;vertical-align:middle;">Instagram</span>')
WHERE name = 'Instagram: alerta de inicio de sesión';

-- ChatGPT/OpenAI: green knot
UPDATE templates SET
  html = REPLACE(html,
    '<span style="color:#ffffff;font-size:16px;font-weight:600;">OpenAI</span>',
    '<span style="display:inline-block;width:18px;height:18px;border-radius:50%;background:conic-gradient(from 90deg,#10a37f,#10a37f 40%,#e2e2e2 40%,#e2e2e2 45%,#10a37f 45%,#10a37f 60%,#e2e2e2 60%,#e2e2e2 65%,#10a37f 65%);vertical-align:middle;"></span>&nbsp;<span style="color:#ffffff;font-size:16px;font-weight:600;vertical-align:middle;">OpenAI</span>')
WHERE name = 'ChatGPT: pago pendiente';

-- Slack: four-color hash
UPDATE templates SET
  html = REPLACE(html,
    '<span style="font-size:20px;font-weight:800;color:#4a154b;">Sl<span style="color:#36c5f0;">ack</span></span>',
    '<svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 122.8 122.8" style="vertical-align:middle;"><path d="M25.8 77.6c0 7.1-5.8 12.9-12.9 12.9S0 84.7 0 77.6s5.8-12.9 12.9-12.9h12.9v12.9zm6.5 0c0-7.1 5.8-12.9 12.9-12.9s12.9 5.8 12.9 12.9v32.3c0 7.1-5.8 12.9-12.9 12.9s-12.9-5.8-12.9-12.9V77.6z" fill="#E01E5A"/><path d="M45.2 25.8c-7.1 0-12.9-5.8-12.9-12.9S38.1 0 45.2 0s12.9 5.8 12.9 12.9v12.9H45.2zm0 6.5c7.1 0 12.9 5.8 12.9 12.9s-5.8 12.9-12.9 12.9H12.9C5.8 58.1 0 52.3 0 45.2s5.8-12.9 12.9-12.9h32.3z" fill="#36C5F0"/><path d="M97 45.2c0-7.1 5.8-12.9 12.9-12.9s12.9 5.8 12.9 12.9-5.8 12.9-12.9 12.9H97V45.2zm-6.5 0c0 7.1-5.8 12.9-12.9 12.9s-12.9-5.8-12.9-12.9V12.9C64.7 5.8 70.5 0 77.6 0s12.9 5.8 12.9 12.9v32.3z" fill="#ECB22E"/><path d="M77.6 97c7.1 0 12.9 5.8 12.9 12.9s-5.8 12.9-12.9 12.9-12.9-5.8-12.9-12.9V97h12.9zm0-6.5c-7.1 0-12.9-5.8-12.9-12.9s5.8-12.9 12.9-12.9h32.3c7.1 0 12.9 5.8 12.9 12.9s-5.8 12.9-12.9 12.9H77.6z" fill="#2EB67D"/></svg>&nbsp;<span style="font-size:20px;font-weight:800;color:#4a154b;vertical-align:middle;">Slack</span>')
WHERE name = 'Slack: nuevo mensaje directo';

-- ============================================================
-- LANDINGS
-- ============================================================

-- Google: colorful G above the form
UPDATE landing_pages SET
  html = REPLACE(html,
    '<h1>Acceder</h1>',
    '<div style="margin-bottom:20px;text-align:center;"><svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" viewBox="0 0 48 48"><path fill="#4285F4" d="M45.12 24.5c0-1.56-.14-3.06-.4-4.5H24v8.51h11.84c-.51 2.75-2.06 5.08-4.39 6.64v5.52h7.11c4.16-3.83 6.56-9.47 6.56-16.17z"/><path fill="#34A853" d="M24 46c5.94 0 10.92-1.97 14.56-5.33l-7.11-5.52c-1.97 1.32-4.49 2.1-7.45 2.1-5.73 0-10.58-3.87-12.31-9.07H4.34v5.7C7.96 41.07 15.4 46 24 46z"/><path fill="#FBBC05" d="M11.69 28.18C11.25 26.86 11 25.45 11 24s.25-2.86.69-4.18v-5.7H4.34C2.85 17.09 2 20.45 2 24s.85 6.91 2.34 9.88l7.35-5.7z"/><path fill="#EA4335" d="M24 10.75c3.23 0 6.13 1.11 8.41 3.29l6.31-6.31C34.91 4.18 29.93 2 24 2 15.4 2 7.96 6.93 4.34 14.12l7.35 5.7c1.73-5.2 6.58-9.07 12.31-9.07z"/></svg></div><h1>Acceder</h1>')
WHERE slug = 'google-login';

-- LinkedIn: blue "in" tile
UPDATE landing_pages SET
  html = REPLACE(html,
    '<div class="logo"><i>in</i> LinkedIn</div>',
    '<div class="logo"><svg xmlns="http://www.w3.org/2000/svg" width="26" height="26" viewBox="0 0 24 24" style="vertical-align:middle;"><path fill="#0A66C2" d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433c-1.144 0-2.063-.926-2.063-2.065 0-1.138.92-2.063 2.063-2.063 1.14 0 2.064.925 2.064 2.063 0 1.139-.925 2.065-2.064 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.225 0z"/></svg>&nbsp;LinkedIn</div>')
WHERE slug = 'linkedin-login';

-- Instagram: outline camera
UPDATE landing_pages SET
  html = REPLACE(html,
    '<div class="logo"><span>Instagram</span></div>',
    '<div class="logo"><svg xmlns="http://www.w3.org/2000/svg" width="26" height="26" viewBox="0 0 24 24" fill="none" style="vertical-align:middle;"><defs><linearGradient id="ig2" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#feda75"/><stop offset=".5" stop-color="#d62976"/><stop offset="1" stop-color="#962fbf"/></linearGradient></defs><rect x="2.4" y="2.4" width="19.2" height="19.2" rx="5.6" stroke="url(#ig2)" stroke-width="2.2"/><circle cx="12" cy="12" r="4.3" stroke="url(#ig2)" stroke-width="2.2"/><circle cx="17.3" cy="6.7" r="1.5" fill="url(#ig2)"/></svg>&nbsp;<span>Instagram</span></div>')
WHERE slug = 'instagram-login';

-- Facebook: blue "f" tile
UPDATE landing_pages SET
  html = REPLACE(html,
    '<div class="logo">facebook</div>',
    '<div class="logo"><svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" style="vertical-align:middle;"><path fill="#1877F2" d="M24 12C24 5.37 18.63 0 12 0S0 5.37 0 12c0 5.99 4.39 10.95 10.13 11.85v-8.39H7.08v-3.47h3.05V9.43c0-3.01 1.79-4.67 4.53-4.67 1.31 0 2.69.23 2.69.23v2.95h-1.51c-1.49 0-1.96.92-1.96 1.87v2.25h3.33l-.53 3.47h-2.8v8.39C19.61 22.95 24 17.99 24 12z"/><path fill="#fff" d="M16.67 14.15l.53-3.47h-3.33v-2.25c0-.95.46-1.87 1.96-1.87h1.51V3.61s-1.37-.23-2.69-.23c-2.74 0-4.53 1.66-4.53 4.67v2.64H7.08v3.47h3.05v8.38c.61.1 1.23.15 1.87.15s1.26-.05 1.87-.15v-8.38h2.8z"/></svg>&nbsp;facebook</div>')
WHERE slug = 'facebook-login';

-- Okta: red identity ring
UPDATE landing_pages SET
  html = REPLACE(html,
    '<div class="oktalogo">Okta</div>',
    '<div class="oktalogo"><svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" style="vertical-align:middle;"><circle cx="12" cy="12" r="8.6" fill="none" stroke="#EA4C1D" stroke-width="4.2"/><circle cx="12" cy="12" r="2.7" fill="#EA4C1D"/></svg>&nbsp;Okta</div>')
WHERE slug = 'okta-login';

-- Slack: four-color hash
UPDATE landing_pages SET
  html = REPLACE(html,
    '<div class="slacklogo">Sl<span>ack</span></div>',
    '<div class="slacklogo"><svg xmlns="http://www.w3.org/2000/svg" width="26" height="26" viewBox="0 0 122.8 122.8" style="vertical-align:middle;"><path d="M25.8 77.6c0 7.1-5.8 12.9-12.9 12.9S0 84.7 0 77.6s5.8-12.9 12.9-12.9h12.9v12.9zm6.5 0c0-7.1 5.8-12.9 12.9-12.9s12.9 5.8 12.9 12.9v32.3c0 7.1-5.8 12.9-12.9 12.9s-12.9-5.8-12.9-12.9V77.6z" fill="#E01E5A"/><path d="M45.2 25.8c-7.1 0-12.9-5.8-12.9-12.9S38.1 0 45.2 0s12.9 5.8 12.9 12.9v12.9H45.2zm0 6.5c7.1 0 12.9 5.8 12.9 12.9s-5.8 12.9-12.9 12.9H12.9C5.8 58.1 0 52.3 0 45.2s5.8-12.9 12.9-12.9h32.3z" fill="#36C5F0"/><path d="M97 45.2c0-7.1 5.8-12.9 12.9-12.9s12.9 5.8 12.9 12.9-5.8 12.9-12.9 12.9H97V45.2zm-6.5 0c0 7.1-5.8 12.9-12.9 12.9s-12.9-5.8-12.9-12.9V12.9C64.7 5.8 70.5 0 77.6 0s12.9 5.8 12.9 12.9v32.3z" fill="#ECB22E"/><path d="M77.6 97c7.1 0 12.9 5.8 12.9 12.9s-5.8 12.9-12.9 12.9-12.9-5.8-12.9-12.9V97h12.9zm0-6.5c-7.1 0-12.9-5.8-12.9-12.9s5.8-12.9 12.9-12.9h32.3c7.1 0 12.9 5.8 12.9 12.9s-5.8 12.9-12.9 12.9H77.6z" fill="#2EB67D"/></svg>&nbsp;Slack</div>')
WHERE slug = 'slack-login';

-- Canva: gradient wordmark
UPDATE landing_pages SET
  html = REPLACE(html,
    '<div class="logo">canva<small>Design anything</small></div>',
    '<div style="margin-bottom:4px;text-align:center;"><span style="font-size:26px;font-weight:700;background:linear-gradient(135deg,#00c4cc 0%,#7d2ae8 100%);-webkit-background-clip:text;background-clip:text;color:transparent;">canva</span></div><div style="font-size:11px;color:#7d2ae8;text-align:center;margin-bottom:16px;">Design anything</div>')
WHERE slug = 'canva-login';