-- V18: Add telecom line-blocking pair (Telcel) — classic LATAM smishing-adjacent vector.
-- DECORATIVE LANDING ONLY: no credential capture. Submit registers the event and
-- redirects to training. Placeholders: {{TRACKING_URL}}, {{TRACKING_OPEN_PIXEL}},
-- {{.FirstName}}, {{.Email}} in the email; {{TOKEN}}, {{SLUG}} in the landing.

-- EMAIL: Telcel — your line will be blocked unless you verify
INSERT INTO templates (name, description, category, difficulty, subject, html, active, created_at, updated_at)
SELECT 'Telcel: su línea será bloqueada', 'Aviso realista de telecomunicaciones (Telcel) para LATAM.', 'ACCOUNT', 'EASY',
       'IMPORTANTE: Su línea será bloqueada en 24 horas',
       '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Telcel - Su línea será bloqueada</title></head>
<body style="margin:0;padding:0;background:#f5f5f5;">
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background:#f5f5f5;">
<tr><td align="center" style="padding:28px 12px;">
<table role="presentation" width="600" cellpadding="0" cellspacing="0" style="max-width:600px;width:100%;background:#ffffff;border:1px solid #e6e6e6;border-radius:6px;font-family:Arial,Helvetica,sans-serif;color:#212121;">
<tr><td style="padding:18px 32px;border-bottom:3px solid #c8102e;">
<table role="presentation" cellpadding="0" cellspacing="0"><tr>
<td style="padding-right:10px;vertical-align:middle;"><svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 48 48"><circle cx="24" cy="24" r="22" fill="#c8102e" opacity=".15"/><circle cx="24" cy="24" r="15" fill="none" stroke="#c8102e" stroke-width="5"/><circle cx="24" cy="24" r="4.5" fill="#c8102e"/></svg></td>
<td style="vertical-align:middle;"><span style="font-size:19px;font-weight:700;color:#c8102e;letter-spacing:.5px;">Telcel</span></td>
</tr></table>
</td></tr>
<tr><td style="padding:28px 32px;">
<p style="margin:0 0 16px;font-size:15px;">Hola {{.FirstName}},</p>
<p style="margin:0 0 16px;font-size:15px;line-height:1.6;">Le informamos que su <strong>línea telefónica será bloqueada</strong> por falta de verificación de datos del titular. El bloqueo aplicará a llamadas, mensajes y datos móviles.</p>
<table role="presentation" cellpadding="0" cellspacing="0" style="border:1px solid #e6e6e6;border-radius:6px;width:100%;margin:18px 0;">
<tr><td style="padding:12px 16px;font-size:13px;border-bottom:1px solid #f2f2f2;"><span style="color:#757575;">Número de línea</span>&nbsp;&nbsp;<strong>52 55 4837 2291</strong></td></tr>
<tr><td style="padding:12px 16px;font-size:13px;border-bottom:1px solid #f2f2f2;"><span style="color:#757575;">Fecha de bloqueo</span>&nbsp;&nbsp;<strong>Mañana a las 23:59 h</strong></td></tr>
<tr><td style="padding:12px 16px;font-size:13px;"><span style="color:#757575;">Motivo</span>&nbsp;&nbsp;<strong>Verificación de titular pendiente</strong></td></tr>
</table>
<p style="margin:0 0 16px;font-size:14px;line-height:1.6;">Para evitar la suspensión del servicio, complete la verificación de su titular en las próximas <strong>24 horas</strong>.</p>
<p style="margin:24px 0;text-align:center;"><a href="{{TRACKING_URL}}" style="background:#c8102e;color:#ffffff;text-decoration:none;padding:13px 30px;border-radius:4px;font-size:15px;font-weight:700;display:inline-block;">Evitar el bloqueo de mi línea</a></p>
<p style="margin:0;font-size:12px;color:#757575;">Atentamente,<br>Atención a clientes Telcel</p>
</td></tr>
<tr><td style="padding:16px 32px;border-top:1px solid #e6e6e6;font-size:12px;color:#9e9e9e;">
Radiomóvil DIPSA, S.A. de C.V. · Av. Lomas de Sotelo 902, CDMX<br>Este mensaje se envió a {{.Email}}. No responda a este correo.
</td></tr>
</table>
</td></tr></table>
<img src="{{TRACKING_OPEN_PIXEL}}" width="1" height="1" alt="">
</body></html>',
       1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM templates WHERE name = 'Telcel: su línea será bloqueada');

-- LANDING: Mi Telcel verification screen
INSERT INTO landing_pages (name, slug, category, difficulty, html, active, created_at, updated_at)
SELECT 'Telcel Verificación', 'telcel-linea-bloqueada', 'ACCOUNT', 'EASY',
       '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Mi Telcel - Verificación de línea</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{font-family:"Segoe UI",Arial,sans-serif;background:#f5f5f5;display:flex;align-items:flex-start;justify-content:center;min-height:100vh;padding:48px 16px;}
.card{width:100%;max-width:420px;background:#fff;border:1px solid #e6e6e6;border-radius:8px;box-shadow:0 6px 24px rgba(0,0,0,.06);padding:36px 32px;text-align:center;}
.logo{display:flex;align-items:center;justify-content:center;margin-bottom:18px;}
h1{font-size:21px;color:#111827;margin:0 0 8px;}
.sub{font-size:13px;color:#6b7280;margin:0 0 24px;line-height:1.55;}
.field{border:1px solid #d1d5db;border-radius:4px;padding:13px 14px;color:#4b5563;font-size:14px;margin-bottom:14px;text-align:left;background:#fafafa;}
.warn{background:#fdf2f3;border:1px solid #f6c6cd;color:#c8102e;font-size:13px;padding:11px 14px;border-radius:4px;margin-bottom:20px;text-align:left;line-height:1.5;}
.btn{background:#c8102e;color:#fff;border:none;width:100%;padding:13px;border-radius:4px;font-size:15px;font-weight:600;cursor:pointer;}
.btn:hover{background:#a80d26;}
.secu{font-size:11px;color:#9ca3af;margin-top:16px;}
</style></head>
<body>
<div class="card">
  <div class="logo"><svg xmlns="http://www.w3.org/2000/svg" width="34" height="34" viewBox="0 0 48 48"><circle cx="24" cy="24" r="22" fill="#c8102e" opacity=".15"/><circle cx="24" cy="24" r="15" fill="none" stroke="#c8102e" stroke-width="5"/><circle cx="24" cy="24" r="4.5" fill="#c8102e"/></svg>&nbsp;&nbsp;<span style="font-size:22px;font-weight:700;color:#c8102e;letter-spacing:.5px;">Telcel</span></div>
  <h1>Evita el bloqueo de tu línea</h1>
  <p class="sub">Tu línea 52 55 4837 2291 será suspendida en 24 horas si no verificas tus datos de titular.</p>
  <div class="warn">Verificación de titular pendiente. Completa el proceso para mantener tu servicio activo.</div>
  <div class="field">Número de línea: 52 55 4837 2291</div>
  <button class="btn" id="sim-submit">Verificar y continuar</button>
  <p class="secu">· Conexión cifrada · Mi Telcel</p>
</div>
<script>document.getElementById("sim-submit").addEventListener("click",function(){var t="{{TOKEN}}";fetch("/api/v1/tracking/"+t+"/submit",{method:"POST"}).then(function(){location.href="/training/{{SLUG}}?token="+t;});});</script>
</body></html>',
       1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM landing_pages WHERE slug = 'telcel-linea-bloqueada');