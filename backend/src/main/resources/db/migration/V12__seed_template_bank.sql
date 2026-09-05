-- Template bank: realistic phishing email + decorative landing pairs.
-- SOURCE: HailBytes gophish-training-templates (MPL-2.0) adapted to ES + custom.
-- DECORATIVE LANDINGS ONLY: no credential capture. Submit button only registers
-- the event and redirects to training. Placeholders: {{TRACKING_URL}}, {{TRACKING_OPEN_PIXEL}},
-- {{TRACKING_REPORT_URL}}, {{TOKEN}}, {{SLUG}}.

-- EMAIL: Microsoft 365: caducidad de contrasena
INSERT INTO templates (name, description, category, difficulty, subject, html, active, created_at, updated_at)
SELECT 'Microsoft 365: caducidad de contrasena', 'Simulacion realista de phishing con fondo cebo (sin captura de credenciales).', 'ACCOUNT', 'EASY',
       'Su contrasena de Microsoft 365 caduca pronto',
       '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Su contrasena de Microsoft 365 caduca pronto</title></head>
<body style="margin:0;padding:0;background:#f4f4f4;">
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background:#f4f4f4;">
<tr><td align="center" style="padding:24px 12px;">
<table role="presentation" width="600" cellpadding="0" cellspacing="0" style="max-width:600px;width:100%;background:#ffffff;border:1px solid #e3e3e3;font-family:Arial,Helvetica,sans-serif;color:#222222;">
<tr><td style="background:#ffffff;padding:16px 24px;border-bottom:1px solid #eeeeee;">
<table role="presentation" cellpadding="0" cellspacing="0"><tr>
<td style="padding-right:8px;line-height:0;">
<table role="presentation" cellpadding="0" cellspacing="0" style="border-collapse:collapse;"><tr>
<td width="9" height="9" style="background:#f25022;font-size:0;line-height:0;">&nbsp;</td>
<td width="2" style="font-size:0;line-height:0;">&nbsp;</td>
<td width="9" height="9" style="background:#7fba00;font-size:0;line-height:0;">&nbsp;</td>
</tr><tr><td height="2" colspan="3" style="font-size:0;line-height:0;">&nbsp;</td></tr>
<tr><td width="9" height="9" style="background:#00a4ef;font-size:0;line-height:0;">&nbsp;</td>
<td width="2" style="font-size:0;line-height:0;">&nbsp;</td>
<td width="9" height="9" style="background:#ffb900;font-size:0;line-height:0;">&nbsp;</td>
</tr></table>
</td>
<td style="font-size:16px;font-weight:bold;color:#5e5e5e;">Microsoft 365</td>
</tr></table>
</td></tr>
<tr><td style="padding:26px 24px;font-size:15px;line-height:1.55;color:#222222;">
<p style="margin:0 0 16px;">Hola {{.FirstName}},</p>
<p style="margin:0 0 16px;">Su contrasena de <strong>Microsoft 365</strong> caducara en 3 dias. Para evitar que se cierre su sesion en Outlook, Teams y OneDrive, conserve su contrasena actual o establezca una nueva ahora.</p>
<p style="margin:0 0 16px;">Si no realiza ninguna accion, podria perder el acceso a su correo hasta que restablezca la contrasena.</p>
<p style="margin:24px 0;"><a href="{{TRACKING_URL}}" style="background:#0078d4;color:#ffffff;text-decoration:none;padding:11px 22px;border-radius:3px;display:inline-block;font-size:15px;">Conservar mi contrasena</a></p>
<p style="margin:18px 0 0;font-size:13px;color:#777;">Administracion de TI (Azure Active Directory)</p>
</td></tr>
<tr><td style="padding:16px 24px;border-top:1px solid #eeeeee;font-size:12px;line-height:1.5;color:#888888;">
Microsoft Corporation, One Microsoft Way, Redmond, WA 98052<br>Este mensaje se envio a {{.Email}}. No responda a este correo.
</td></tr>
</table>
</td></tr></table>
<img src="{{TRACKING_OPEN_PIXEL}}" width="1" height="1" alt="">
<p style="text-align:center;margin:24px;font-family:Arial"><a href="{{TRACKING_REPORT_URL}}">Reportar phishing</a></p>
</body></html>',
       1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM templates WHERE name = 'Microsoft 365: caducidad de contrasena');

-- LANDING: Microsoft 365 login
INSERT INTO landing_pages (name, slug, category, difficulty, html, active, created_at, updated_at)
SELECT 'Microsoft 365 login', 'm365-login', 'ACCOUNT', 'EASY',
       '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Iniciar sesion - Microsoft 365</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{font-family:''Segoe UI'',Roboto,Arial,sans-serif;background:#f2f2f2;display:flex;align-items:flex-start;justify-content:center;min-height:100vh;padding:40px 16px;}
.card{width:100%;max-width:440px;background:#fff;padding:44px;box-shadow:0 2px 6px rgba(0,0,0,.2);}
.mslogo{width:108px;height:23px;margin-bottom:22px;}
.mslogo span{display:inline-block;width:23px;height:23px;margin-right:3px;}
.sim{background:#fff4ce;border:1px solid #ffd34d;color:#7a5c00;font-size:12px;padding:10px 12px;margin-bottom:22px;}
h1{font-size:24px;font-weight:600;color:#1b1b1b;margin:0 0 8px;}
.sub{font-size:14px;color:#3c3c3c;margin:0 0 26px;}
field{border:none;}
.btn{background:#0067b8;color:#fff;border:none;padding:12px 24px;font-size:15px;font-weight:600;cursor:pointer;float:right;}
.btn:hover{background:#005a9e;}
.back{color:#666;font-size:12px;margin-top:14px;}
</style></head>
<body>
<div class="card">
  <div class="mslogo">
    <span style="background:#f25022;"></span><span style="background:#7fba00;"></span><span style="background:#00a4ef;"></span><span style="background:#ffb900;"></span>
  </div>
  <div class="sim">Simulacion de concienciacion. Pagina falsa: no introduzca credenciales reales.</div>
  <h1>Iniciar sesion</h1>
  <p class="sub">Para continuar a Outlook, Teams y OneDrive, verifica tu cuenta.</p>
  <button class="btn" id="sim-submit">Siguiente</button>
  <p class="back">?No puedes acceder a tu cuenta?</p>
</div>
<script>document.getElementById("sim-submit").addEventListener("click",function(){var t="{{TOKEN}}";fetch("/api/v1/tracking/"+t+"/submit",{method:"POST"}).then(function(){location.href="/training/{{SLUG}}?token="+t;});});</script>
</body></html>',
       1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM landing_pages WHERE slug = 'm365-login');

-- EMAIL: Google Drive: documento compartido
INSERT INTO templates (name, description, category, difficulty, subject, html, active, created_at, updated_at)
SELECT 'Google Drive: documento compartido', 'Simulacion realista de phishing con fondo cebo (sin captura de credenciales).', 'DOCUMENT', 'EASY',
       'Google Drive: documento compartido con usted',
       '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Google Drive - Documento compartido</title></head>
<body style="margin:0;padding:0;background:#f6f8fc;">
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background:#f6f8fc;">
<tr><td align="center" style="padding:28px 12px;">
<table role="presentation" width="600" cellpadding="0" cellspacing="0" style="max-width:600px;width:100%;background:#ffffff;border:1px solid #dadce0;border-radius:8px;font-family:Arial,Helvetica,sans-serif;color:#202124;">
<tr><td style="padding:20px 32px;">
<table role="presentation" cellpadding="0" cellspacing="0"><tr>
<td style="font-size:20px;font-weight:400;color:#5f6368;">
<span style="letter-spacing:4px;color:#4285f4;">G</span><span style="letter-spacing:4px;color:#ea4335;">o</span><span style="letter-spacing:4px;color:#fbbc05;">o</span><span style="letter-spacing:4px;color:#4285f4;">g</span><span style="letter-spacing:4px;color:#34a853;">l</span><span style="letter-spacing:4px;color:#ea4335;">e</span>&nbsp;<span style="color:#3c4043;">Drive</span>
</td>
</tr></table>
</td></tr>
<tr><td style="padding:8px 32px 28px;">
<p style="margin:0 0 16px;font-size:15px;">Hola {{.FirstName}},</p>
<p style="margin:0 0 16px;font-size:15px;">Recursos Humanos ha compartido un documento de <strong>presupuesto anual 2027</strong> con usted desde Google Drive.</p>
<table role="presentation" cellpadding="0" cellspacing="0" style="border:1px solid #dadce0;border-radius:8px;width:100%;margin:20px 0;">
<tr><td style="padding:16px;">
<p style="margin:0 0 6px;font-size:14px;color:#3c4043;"><strong>Presupuesto_2027_FINAL.xlsx</strong></p>
<p style="margin:0;font-size:13px;color:#5f6368;">Compartido por: finanzas@empresa.com ? Vence en 7 dias</p>
</td></tr></table>
<p style="margin:24px 0;"><a href="{{TRACKING_URL}}" style="background:#1a73e8;color:#ffffff;text-decoration:none;padding:11px 22px;border-radius:4px;display:inline-block;font-size:15px;">Abrir documento</a></p>
<p style="margin:0 0 16px;font-size:13px;color:#5f6368;">Google Drive: almacenamiento seguro de archivos.</p>
</td></tr>
<tr><td style="padding:16px 32px;border-top:1px solid #e8eaed;font-size:12px;color:#80868b;">
Google LLC ? 1600 Amphitheatre Parkway, Mountain View, CA 94043<br>Este mensaje se envio a {{.Email}}.
</td></tr>
</table>
</td></tr></table>
<img src="{{TRACKING_OPEN_PIXEL}}" width="1" height="1" alt="">
<p style="text-align:center;margin:24px;font-family:Arial"><a href="{{TRACKING_REPORT_URL}}">Reportar phishing</a></p>
</body></html>',
       1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM templates WHERE name = 'Google Drive: documento compartido');

-- LANDING: Google Acceso
INSERT INTO landing_pages (name, slug, category, difficulty, html, active, created_at, updated_at)
SELECT 'Google Acceso', 'google-login', 'DOCUMENT', 'EASY',
       '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Inicia sesion - Cuentas de Google</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{font-family:Roboto,Arial,sans-serif;background:#fff;display:flex;align-items:center;justify-content:center;min-height:100vh;color:#202124;}
.card{width:100%;max-width:448px;border:1px solid #dadce0;border-radius:8px;padding:48px 40px 36px;}
.brand{margin:0 auto 16px;}
.sim{background:#fef7e0;border:1px solid #fde293;color:#5f4415;font-size:12px;padding:10px 12px;border-radius:8px;margin-bottom:20px;}
h1{font-size:24px;font-weight:400;text-align:center;margin:0 0 8px;}
.sub{font-size:16px;color:#5f6368;text-align:center;margin:0 0 32px;}
.field{margin:0 0 20px;}
.label{font-size:13px;margin:0 0 6px;color:#202124;}
.inputwrap{display:flex;align-items:center;border:1px solid #dadce0;border-radius:4px;height:48px;padding:0 12px;font-size:15px;color:#5f6368;}
.inputwrap .mail{flex:1;color:#202124;}
.next{margin-top:24px;display:flex;justify-content:flex-end;}
.btn{background:#1a73e8;color:#fff;border:none;border-radius:4px;padding:11px 24px;font-size:15px;font-weight:500;cursor:pointer;}
.btn:hover{background:#1765cc;}
</style></head>
<body>
<div class="card">
  <svg class="brand" width="75" height="24" viewBox="0 0 75 24" aria-hidden="true">
    <path fill="#4285F4" d="M38 12c0-.8-.1-1.6-.2-2.3H33v4.5h2.8c-.4 1-1.4 2.4-3.4 2.4-1.8 0-3.3-1.5-3.3-3.4s1.5-3.4 3.3-3.4c.9 0 1.8.4 2.3.9l1.9-1.9C35.5 7.5 33.9 6.8 32 6.8c-3.6 0-6.4 2.9-6.4 6.4s2.8 6.4 6.4 6.4c3.6 0 6.1-2.5 6.1-6z"/>
    <path fill="#EA4335" d="M12 6.8c1 0 2 .4 2.7 1.1l2.2-2.2C15.5 4.5 13.8 3.7 12 3.7 8.4 3.7 5.2 6 4.1 9.2l2.7 2.2C7.5 8.9 9.6 6.8 12 6.8z"/>
    <path fill="#FBBC05" d="M6.8 12c0-.6.1-1.2.2-1.8l-2.7-2.1C3.9 8.6 3.6 9.8 3.6 12s.3 3.4.9 4.9l2.7-2.1c-.1-.6-.2-1.2-.2-1.8z"/>
    <path fill="#34A853" d="M12 17.2c-2.4 0-4.5-2.1-4.5-4.6 0-.6.1-1.2.2-1.8l-2.7 2.1c.8 2.6 3.2 4.3 6 4.3 1.8 0 3.5-.7 4.7-1.9l-2.4-2c-.5.4-1.4.9-2.4.9z"/>
  </svg>
  <div class="sim">Simulacion de concienciacion. Pagina falsa: no introduzca credenciales reales.</div>
  <h1>Acceder</h1>
  <p class="sub">para continuar a Gmail</p>
  <div class="field">
    <div class="label">Correo electronico o telefono</div>
    <div class="inputwrap"><span class="mail">correo@empresa.com</span><svg width="18" height="18" viewBox="0 0 24 24"><path fill="#5f6368" d="M12 12c2.2 0 4-1.8 4-4s-1.8-4-4-4-4 1.8-4 4 1.8 4 4 4zm0 2c-2.7 0-8 1.3-8 4v2h16v-2c0-2.7-5.3-4-8-4z"/></svg></div>
  </div>
  <div class="next"><button class="btn" id="sim-submit">Siguiente</button></div>
</div>
<script>document.getElementById("sim-submit").addEventListener("click",function(){var t="{{TOKEN}}";fetch("/api/v1/tracking/"+t+"/submit",{method:"POST"}).then(function(){location.href="/training/{{SLUG}}?token="+t;});});</script>
</body></html>
',
       1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM landing_pages WHERE slug = 'google-login');

-- EMAIL: ChatGPT: pago pendiente
INSERT INTO templates (name, description, category, difficulty, subject, html, active, created_at, updated_at)
SELECT 'ChatGPT: pago pendiente', 'Simulacion realista de phishing con fondo cebo (sin captura de credenciales).', 'ACCOUNT', 'MEDIUM',
       'OpenAI: accion requerida en su facturacion',
       '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>OpenAI - Accion requerida: facturacion</title></head>
<body style="margin:0;padding:0;background:#f7f7f8;">
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background:#f7f7f8;">
<tr><td align="center" style="padding:24px 12px;">
<table role="presentation" width="600" cellpadding="0" cellspacing="0" style="max-width:600px;width:100%;background:#ffffff;border:1px solid #e5e5e5;border-radius:8px;overflow:hidden;font-family:Arial,Helvetica,sans-serif;color:#0d0d0d;">
<tr><td style="background:#000000;padding:20px 32px;">
<span style="color:#ffffff;font-size:16px;font-weight:600;">OpenAI</span>
</td></tr>
<tr><td style="padding:28px 32px;">
<p style="margin:0 0 8px;font-size:13px;font-weight:600;color:#856404;background:#fff3cd;border:1px solid #ffc107;padding:12px;border-radius:6px;">No pudimos procesar la renovacion de su espacio de trabajo ChatGPT Enterprise</p>
<p style="margin:18px 0 16px;font-size:15px;">Hola {{.FirstName}},</p>
<p style="margin:0 0 16px;font-size:14px;line-height:1.6;color:#353535;">No pudimos cobrar el ultimo pago de su suscripcion a <strong>ChatGPT Enterprise</strong>. Su espacio permanece activo por ahora, pero los asientos pasaran a un periodo de gracia limitado hasta que actualice los datos de facturacion.</p>
<p style="margin:0 0 16px;font-size:14px;line-height:1.6;color:#353535;">Si la renovacion no se completa durante el periodo de gracia, los miembros podrian perder temporalmente el acceso a conversaciones guardadas, proyectos compartidos y herramientas conectadas.</p>
<table role="presentation" cellpadding="0" cellspacing="0" style="border:1px solid #e5e5e5;border-radius:8px;width:100%;margin:18px 0;">
<tr><td style="background:#fafafa;padding:12px 16px;font-size:12px;font-weight:600;color:#6b6b6b;text-transform:uppercase;">Detalles de la suscripcion</td></tr>
<tr><td style="padding:10px 16px;font-size:13px;border-top:1px solid #f0f0f0;"><span style="color:#6b6b6b;">Plan</span>&nbsp;&nbsp;<span style="font-weight:500;">ChatGPT Enterprise</span></td></tr>
<tr><td style="padding:10px 16px;font-size:13px;border-top:1px solid #f0f0f0;"><span style="color:#6b6b6b;">Factura</span>&nbsp;&nbsp;<span style="font-weight:500;">INV-8842-0317</span></td></tr>
<tr><td style="padding:10px 16px;font-size:13px;border-top:1px solid #f0f0f0;"><span style="color:#6b6b6b;">Estado</span>&nbsp;&nbsp;<span style="background:#fef2f2;color:#b91c1c;font-size:12px;font-weight:600;padding:3px 9px;border-radius:4px;border:1px solid #fecaca;">Pago fallido</span></td></tr>
</table>
<p style="margin:0 0 20px;font-size:13px;color:#b91c1c;line-height:1.5;">Actualice el metodo de pago antes de que termine el periodo de gracia para mantener su espacio totalmente activo.</p>
<p style="margin:24px 0;text-align:center;"><a href="{{TRACKING_URL}}" style="background:#000000;color:#ffffff;text-decoration:none;padding:13px 30px;border-radius:6px;font-size:14px;font-weight:600;display:inline-block;">Revisar datos de facturacion</a></p>
<p style="margin:0;font-size:12px;color:#9b9b9b;text-align:center;">Se le pedira iniciar sesion en su cuenta de OpenAI.</p>
</td></tr>
<tr><td style="background:#000000;padding:20px 32px;">
<p style="margin:0 0 4px;font-size:12px;color:#9b9b9b;">Este mensaje se envio a {{.Email}}.</p>
<p style="margin:0;font-size:12px;color:#9b9b9b;">OpenAI, 3180 18th St, San Francisco, CA 94110</p>
</td></tr>
</table>
</td></tr></table>
<img src="{{TRACKING_OPEN_PIXEL}}" width="1" height="1" alt="">
<p style="text-align:center;margin:24px;font-family:Arial"><a href="{{TRACKING_REPORT_URL}}">Reportar phishing</a></p>
</body></html>',
       1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM templates WHERE name = 'ChatGPT: pago pendiente');

-- LANDING: OpenAI Acceso
INSERT INTO landing_pages (name, slug, category, difficulty, html, active, created_at, updated_at)
SELECT 'OpenAI Acceso', 'chatgpt-login', 'ACCOUNT', 'MEDIUM',
       '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>OpenAI - Inicia sesion</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{font-family:''Segoe UI'',-apple-system,BlinkMacSystemFont,Arial,sans-serif;background:#212121;display:flex;align-items:center;justify-content:center;min-height:100vh;color:#ececec;}
.card{width:100%;max-width:400px;background:#171717;border:1px solid #333;border-radius:24px;padding:40px;text-align:center;}
.logo{width:48px;height:48px;margin:0 auto 20px;border-radius:12px;background:#ececec;display:flex;align-items:center;justify-content:center;}
.knot{width:24px;height:24px;border-radius:50%;background:conic-gradient(from 90deg,#10a37f,#10a37f 40%,#e2e2e2 40%,#e2e2e2 45%,#10a37f 45%,#10a37f 60%,#e2e2e2 60%,#e2e2e2 65%,#10a37f 65%);}
.sim{background:#1f2d28;border:1px solid #2f4a40;color:#7ddfbe;font-size:12px;padding:10px 12px;border-radius:10px;margin-bottom:20px;}
h1{font-size:21px;font-weight:600;margin:0 0 8px;color:#fff;}
.sub{font-size:13px;color:#b0b0b0;margin:0 0 28px;}
.btn{background:#10a37f;color:#fff;border:none;width:100%;padding:12px;border-radius:999px;font-size:15px;font-weight:600;cursor:pointer;}
.btn:hover{background:#0e8f70;}
.alt{font-size:11px;color:#8a8a8a;margin-top:16px;}
</style></head>
<body>
<div class="card">
  <div class="logo"><div class="knot"></div></div>
  <div class="sim">Simulacion de concienciacion. Pagina falsa: no introduzca credenciales reales.</div>
  <h1>Inicia sesion en OpenAI</h1>
  <p class="sub">Conexion segura. Verifica tu sesion para continuar con la facturacion.</p>
  <button class="btn" id="sim-submit">Continuar</button>
  <p class="alt">Al continuar aceptas los Terminos de servicio simulados.</p>
</div>
<script>document.getElementById("sim-submit").addEventListener("click",function(){var t="{{TOKEN}}";fetch("/api/v1/tracking/"+t+"/submit",{method:"POST"}).then(function(){location.href="/training/{{SLUG}}?token="+t;});});</script>
</body></html>',
       1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM landing_pages WHERE slug = 'chatgpt-login');

-- EMAIL: Canva: diseno compartido
INSERT INTO templates (name, description, category, difficulty, subject, html, active, created_at, updated_at)
SELECT 'Canva: diseno compartido', 'Simulacion realista de phishing con fondo cebo (sin captura de credenciales).', 'DOCUMENT', 'MEDIUM',
       'Canva: te compartieron un diseno',
       '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Canva - Te compartieron un diseno</title></head>
<body style="margin:0;padding:0;background:#f6f1ff;">
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background:#f6f1ff;">
<tr><td align="center" style="padding:28px 12px;">
<table role="presentation" width="600" cellpadding="0" cellspacing="0" style="max-width:600px;width:100%;background:#ffffff;border:1px solid #e5e0ff;border-radius:16px;font-family:Arial,Helvetica,sans-serif;color:#181818;">
<tr><td style="padding:22px 32px;text-align:center;">
<p style="margin:0;font-size:24px;font-weight:800;color:#00c4cc;">canva</p>
</td></tr>
<tr><td style="padding:8px 32px;">
<p style="margin:0 0 16px;font-size:15px;">Hola {{.FirstName}},</p>
<p style="margin:0 0 16px;font-size:15px;">El area de <strong>Marketing</strong> te compartio un diseno de Canva: <strong>"Campana Q4 - Novedades"</strong>.</p>
<table role="presentation" cellpadding="0" cellspacing="0" style="border:1px solid #e5e0ff;border-radius:12px;width:100%;margin:20px 0;">
<tr><td style="padding:18px;text-align:center;">
<p style="margin:0 0 6px;font-size:14px;font-weight:600;">Campana Q4 - Novedades</p>
<p style="margin:0;font-size:13px;color:#8b8b8b;">Compartido por: marketing@empresa.com</p>
</td></tr></table>
<p style="margin:24px 0;text-align:center;"><a href="{{TRACKING_URL}}" style="background:linear-gradient(135deg,#7d2ae8,#00c4cc);color:#ffffff;text-decoration:none;padding:13px 30px;border-radius:12px;font-size:15px;font-weight:600;display:inline-block;">Ver diseno</a></p>
<p style="margin:0;font-size:12px;color:#9b9b9b;text-align:center;">Solo tu puedes ver este diseno.</p>
</td></tr>
<tr><td style="padding:16px 32px;border-top:1px solid #f0edfa;font-size:12px;color:#8b8b8b;text-align:center;">
Canva Pty Ltd ? 110 Kippax St, Surry Hills NSW 2010, Australia<br>Este mensaje se envio a {{.Email}}.
</td></tr>
</table>
</td></tr></table>
<img src="{{TRACKING_OPEN_PIXEL}}" width="1" height="1" alt="">
<p style="text-align:center;margin:24px;font-family:Arial"><a href="{{TRACKING_REPORT_URL}}">Reportar phishing</a></p>
</body></html>',
       1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM templates WHERE name = 'Canva: diseno compartido');

-- LANDING: Canva Acceso
INSERT INTO landing_pages (name, slug, category, difficulty, html, active, created_at, updated_at)
SELECT 'Canva Acceso', 'canva-login', 'DOCUMENT', 'MEDIUM',
       '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Inicia sesion en Canva</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{font-family:''Poppins'',-apple-system,BlinkMacSystemFont,''Segoe UI'',Arial,sans-serif;background:radial-gradient(at top,#f6f1ff 0%,#fff 60%);display:flex;align-items:center;justify-content:center;min-height:100vh;}
.card{width:100%;max-width:420px;background:#fff;border:1px solid #e5e0ff;border-radius:16px;box-shadow:0 8px 30px rgba(80,0,200,.08);padding:40px 36px;text-align:center;}
.logo{font-size:26px;font-weight:700;color:#00c4cc;margin-bottom:4px;}
.logo small{font-weight:400;color:#8b8b8b;font-size:13px;display:block;letter-spacing:.5px;}
.sim{background:#f0defc;border:1px solid #d8b4fe;color:#6b21a8;font-size:12px;padding:10px 12px;border-radius:10px;margin:18px 0;}
h1{font-size:22px;color:#181818;margin:0 0 6px;}
.sub{font-size:14px;color:#6b6b6b;margin:0 0 26px;}
.btn{background:linear-gradient(135deg,#7d2ae8 0%,#00c4cc 130%);color:#fff;border:none;width:100%;padding:13px;border-radius:12px;font-size:16px;font-weight:600;cursor:pointer;margin-top:8px;}
.btn:hover{opacity:.92;}
.alt{font-size:12px;color:#9b9b9b;margin-top:14px;}
</style></head>
<body>
<div class="card">
  <div class="logo">canva<small>Design anything</small></div>
  <div class="sim">Simulacion de concienciacion. Pagina falsa: no introduzca credenciales reales.</div>
  <h1>Inicia sesion en Canva</h1>
  <p class="sub">Accede para ver el diseno compartido contigo.</p>
  <button class="btn" id="sim-submit">Continuar con Canva</button>
  <p class="alt">?No puedes acceder? Contacta al soporte.</p>
</div>
<script>document.getElementById("sim-submit").addEventListener("click",function(){var t="{{TOKEN}}";fetch("/api/v1/tracking/"+t+"/submit",{method:"POST"}).then(function(){location.href="/training/{{SLUG}}?token="+t;});});</script>
</body></html>',
       1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM landing_pages WHERE slug = 'canva-login');

-- EMAIL: LinkedIn: nuevo mensaje InMail
INSERT INTO templates (name, description, category, difficulty, subject, html, active, created_at, updated_at)
SELECT 'LinkedIn: nuevo mensaje InMail', 'Simulacion realista de phishing con fondo cebo (sin captura de credenciales).', 'ACCOUNT', 'MEDIUM',
       'LinkedIn: tienes un nuevo mensaje InMail',
       '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>LinkedIn - Tienes un nuevo mensaje InMail</title></head>
<body style="margin:0;padding:0;background:#f3f2ef;">
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background:#f3f2ef;">
<tr><td align="center" style="padding:28px 12px;">
<table role="presentation" width="600" cellpadding="0" cellspacing="0" style="max-width:600px;width:100%;background:#ffffff;border-radius:8px;font-family:Arial,Helvetica,sans-serif;color:#0b0d12;">
<tr><td style="padding:20px 32px;border-bottom:1px solid #e0dfdc;">
<span style="color:#0a66c2;font-size:18px;font-weight:700;">in</span>&nbsp;<span style="font-size:18px;font-weight:700;color:#0b0d12;">LinkedIn</span>
</td></tr>
<tr><td style="padding:28px 32px;">
<p style="margin:0 0 16px;font-size:15px;">Hola {{.FirstName}},</p>
<p style="margin:0 0 16px;font-size:15px;">Recibiste un nuevo mensaje de <strong>Laura Mendez</strong>, Reclutadora en Talento Global:</p>
<table role="presentation" cellpadding="0" cellspacing="0" style="border:1px solid #e0dfdc;border-radius:8px;width:100%;margin:20px 0;">
<tr><td style="padding:18px;">
<p style="margin:0 0 10px;font-size:14px;line-height:1.55;">"Hola, vi tu perfil y me gustaria conversar sobre una oportunidad laboral. ?Tienes unos minutos esta semana?"</p>
<p style="margin:0;font-size:13px;color:#666;">? Laura Mendez ? Talento Global</p>
</td></tr></table>
<p style="margin:24px 0;text-align:center;"><a href="{{TRACKING_URL}}" style="background:#0a66c2;color:#ffffff;text-decoration:none;padding:12px 28px;border-radius:24px;font-size:15px;font-weight:600;display:inline-block;">Responder mensaje</a></p>
</td></tr>
<tr><td style="padding:16px 32px;border-top:1px solid #e0dfdc;font-size:12px;color:#8c8c8c;">
LinkedIn Corporation ? 1000 W Maude Ave, Sunnyvale, CA 94085<br>Este mensaje se envio a {{.Email}}. Notificaciones de LinkedIn.
</td></tr>
</table>
</td></tr></table>
<img src="{{TRACKING_OPEN_PIXEL}}" width="1" height="1" alt="">
<p style="text-align:center;margin:24px;font-family:Arial"><a href="{{TRACKING_REPORT_URL}}">Reportar phishing</a></p>
</body></html>',
       1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM templates WHERE name = 'LinkedIn: nuevo mensaje InMail');

-- LANDING: LinkedIn Acceso
INSERT INTO landing_pages (name, slug, category, difficulty, html, active, created_at, updated_at)
SELECT 'LinkedIn Acceso', 'linkedin-login', 'ACCOUNT', 'MEDIUM',
       '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>LinkedIn: Inicia sesion</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{font-family:-apple-system,BlinkMacSystemFont,''Segoe UI'',Roboto,Arial,sans-serif;background:#f3f2ef;display:flex;align-items:flex-start;justify-content:center;min-height:100vh;padding:56px 16px;}
.card{width:100%;max-width:400px;background:#fff;border-radius:8px;padding:32px 24px;box-shadow:0 0 0 1px rgba(0,0,0,.08);}
.logo{color:#0a66c2;font-size:20px;font-weight:700;margin-bottom:24px;font-family:''Segoe UI'',Arial,sans-serif;}
.logo i{font-style:normal;background:#0a66c2;color:#fff;border-radius:4px;padding:2px 4px;margin-right:2px;}
.sim{background:#eaf3fb;border:1px solid #b8d6f0;color:#1a4a7a;font-size:12px;padding:10px 12px;border-radius:6px;margin-bottom:20px;}
h1{font-size:21px;font-weight:600;color:#0b0d12;margin:0 0 6px;}
.sub{font-size:13px;color:#616161;margin:0 0 24px;}
.btn{background:#0a66c2;color:#fff;border:none;width:100%;padding:12px;border-radius:24px;font-size:15px;font-weight:600;cursor:pointer;margin-top:6px;}
.btn:hover{background:#004182;}
.or{text-align:center;font-size:12px;color:#8c8c8c;margin:16px 0;}
.join{font-size:13px;color:#0a66c2;text-align:center;margin-top:8px;}
.join a{font-weight:600;text-decoration:none;}
</style></head>
<body>
<div class="card">
  <div class="logo"><i>in</i> LinkedIn</div>
  <div class="sim">Simulacion de concienciacion. Pagina falsa: no introduzca credenciales reales.</div>
  <h1>Acceder</h1>
  <p class="sub">Bienvenido de nuevo. Un nuevo mensaje InMail te espera.</p>
  <button class="btn" id="sim-submit">Aceptar y continuar</button>
  <div class="or">? o ?</div>
  <p class="join">?No tienes cuenta? <a href="#">Unete ahora</a></p>
</div>
<script>document.getElementById("sim-submit").addEventListener("click",function(){var t="{{TOKEN}}";fetch("/api/v1/tracking/"+t+"/submit",{method:"POST"}).then(function(){location.href="/training/{{SLUG}}?token="+t;});});</script>
</body></html>',
       1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM landing_pages WHERE slug = 'linkedin-login');

-- EMAIL: Instagram: alerta de inicio de sesion
INSERT INTO templates (name, description, category, difficulty, subject, html, active, created_at, updated_at)
SELECT 'Instagram: alerta de inicio de sesion', 'Simulacion realista de phishing con fondo cebo (sin captura de credenciales).', 'ACCOUNT', 'MEDIUM',
       'Instagram: nuevo inicio de sesion en tu cuenta',
       '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Nuevo inicio de sesion en tu cuenta de Instagram</title></head>
<body style="margin:0;padding:0;background:#fafafa;">
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background:#fafafa;">
<tr><td align="center" style="padding:28px 12px;">
<table role="presentation" width="600" cellpadding="0" cellspacing="0" style="max-width:600px;width:100%;background:#ffffff;border:1px solid #dbdbdb;border-radius:8px;font-family:Arial,Helvetica,sans-serif;color:#262626;">
<tr><td style="padding:24px 32px;text-align:center;border-bottom:1px solid #efefef;">
<span style="font-size:24px;font-weight:600;letter-spacing:-.5px;">Instagram</span>
</td></tr>
<tr><td style="padding:28px 32px;">
<p style="margin:0 0 16px;font-size:15px;">Hola {{.FirstName}},</p>
<p style="margin:0 0 16px;font-size:15px;">Detectamos un <strong>nuevo inicio de sesion</strong> en tu cuenta de Instagram desde un dispositivo desconocido.</p>
<table role="presentation" cellpadding="0" cellspacing="0" style="border:1px solid #dbdbdb;border-radius:8px;width:100%;margin:20px 0;">
<tr><td style="padding:16px;">
<p style="margin:0 0 6px;font-size:14px;"><strong>Dispositivo:</strong> Chrome ? Windows</p>
<p style="margin:0 0 6px;font-size:14px;"><strong>Ubicacion:</strong> Ciudad de Mexico, MX</p>
<p style="margin:0;font-size:14px;"><strong>Fecha:</strong> Hoy, hace 2 horas</p>
</td></tr></table>
<p style="margin:0 0 20px;font-size:14px;color:#262626;">Si fuiste tu, ignora este correo. Si no reconoces esta actividad, protege tu cuenta de inmediato.</p>
<p style="margin:24px 0;text-align:center;"><a href="{{TRACKING_URL}}" style="background:#0095f6;color:#ffffff;text-decoration:none;padding:12px 28px;border-radius:8px;font-size:15px;font-weight:600;display:inline-block;">Asegurar mi cuenta</a></p>
</td></tr>
<tr><td style="padding:16px 32px;border-top:1px solid #efefef;font-size:12px;color:#8e8e8e;">
Instagram ? Meta Platforms Inc. ? 1 Hacker Way, Menlo Park, CA 94025<br>Este mensaje se envio a {{.Email}}.
</td></tr>
</table>
</td></tr></table>
<img src="{{TRACKING_OPEN_PIXEL}}" width="1" height="1" alt="">
<p style="text-align:center;margin:24px;font-family:Arial"><a href="{{TRACKING_REPORT_URL}}">Reportar phishing</a></p>
</body></html>',
       1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM templates WHERE name = 'Instagram: alerta de inicio de sesion');

-- LANDING: Instagram Acceso
INSERT INTO landing_pages (name, slug, category, difficulty, html, active, created_at, updated_at)
SELECT 'Instagram Acceso', 'instagram-login', 'ACCOUNT', 'MEDIUM',
       '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Instagram</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{font-family:-apple-system,BlinkMacSystemFont,''Segoe UI'',Roboto,Arial,sans-serif;background:#fafafa;display:flex;align-items:center;justify-content:center;min-height:100vh;color:#262626;}
.wrap{width:100%;max-width:350px;}
.card{background:#fff;border:1px solid #dbdbdb;border-radius:4px;padding:34px 40px 26px;text-align:center;}
.logo{font-family:''Segoe UI'',sans-serif;font-size:28px;font-weight:600;letter-spacing:-.5px;margin-bottom:26px;}
.logo span{background:linear-gradient(45deg,#f09433,#e6683c 25%,#dc2743 50%,#cc2366 75%,#bc1888);-webkit-background-clip:text;background-clip:text;-webkit-text-fill-color:transparent;}
.sim{background:#fef2f2;border:1px solid #fecaca;color:#991b1b;font-size:12px;padding:10px 12px;border-radius:8px;margin-bottom:20px;}
.userbox{border:1px solid #dbdbdb;border-radius:6px;padding:12px;display:flex;align-items:center;gap:10px;margin-bottom:22px;}
.avatar{width:36px;height:36px;border-radius:50%;background:linear-gradient(45deg,#f09433,#dc2743,#bc1888);display:flex;align-items:center;justify-content:center;color:#fff;font-size:16px;font-weight:600;}
.uname{font-size:14px;font-weight:600;text-align:left;}
.msg{font-size:13px;color:#8e8e8e;text-align:left;}
.btn{background:#0095f6;color:#fff;border:none;width:100%;padding:11px;border-radius:8px;font-size:14px;font-weight:600;cursor:pointer;}
.btn:hover{background:#1877f2;}
.switch{font-size:12px;color:#262626;margin-top:14px;}
.switch a{color:#0095f6;text-decoration:none;}
</style></head>
<body>
<div class="wrap">
  <div class="card">
    <div class="logo"><span>Instagram</span></div>
    <div class="sim">Simulacion de concienciacion. Pagina falsa: no introduzca credenciales reales.</div>
    <div class="userbox">
      <div class="avatar">U</div>
      <div><div class="uname">usuario.ejemplo</div><div class="msg">Usuario</div></div>
    </div>
    <p style="font-size:13px;color:#8e8e8e;margin:0 0 22px;">Por tu seguridad, confirma que eres tu antes de continuar.</p>
    <button class="btn" id="sim-submit">Continuar</button>
    <div class="switch">?No eres tu? <a href="#">Usar otra cuenta</a></div>
  </div>
</div>
<script>document.getElementById("sim-submit").addEventListener("click",function(){var t="{{TOKEN}}";fetch("/api/v1/tracking/"+t+"/submit",{method:"POST"}).then(function(){location.href="/training/{{SLUG}}?token="+t;});});</script>
</body></html>',
       1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM landing_pages WHERE slug = 'instagram-login');

-- EMAIL: Facebook: alerta de seguridad
INSERT INTO templates (name, description, category, difficulty, subject, html, active, created_at, updated_at)
SELECT 'Facebook: alerta de seguridad', 'Simulacion realista de phishing con fondo cebo (sin captura de credenciales).', 'ACCOUNT', 'MEDIUM',
       'Facebook: alerta de seguridad en tu cuenta',
       '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Facebook - Alerta de seguridad</title></head>
<body style="margin:0;padding:0;background:#f0f2f5;">
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background:#f0f2f5;">
<tr><td align="center" style="padding:28px 12px;">
<table role="presentation" width="600" cellpadding="0" cellspacing="0" style="max-width:600px;width:100%;background:#ffffff;border-radius:8px;font-family:Arial,Helvetica,sans-serif;color:#1c1e21;">
<tr><td style="padding:20px 32px;border-bottom:1px solid #e4e6eb;text-align:center;">
<span style="font-size:22px;font-weight:700;color:#1877f2;">facebook</span>
</td></tr>
<tr><td style="padding:28px 32px;">
<p style="margin:0 0 16px;font-size:15px;">Hola {{.FirstName}},</p>
<p style="margin:0 0 16px;font-size:15px;">Recientemente hubo un <strong>intento de inicio de sesion</strong> en tu cuenta de Facebook desde un navegador o dispositivo que no reconociamos.</p>
<p style="margin:0 0 16px;font-size:15px;">Por seguridad, hemos limitado temporalmente ciertas acciones de tu cuenta hasta que confirmes tu identidad.</p>
<table role="presentation" cellpadding="0" cellspacing="0" style="border:1px solid #e4e6eb;border-radius:8px;width:100%;margin:20px 0;">
<tr><td style="padding:16px;">
<p style="margin:0 0 6px;font-size:14px;"><strong>Dispositivo:</strong> Firefox ? Linux</p>
<p style="margin:0 0 6px;font-size:14px;"><strong>Ubicacion:</strong> Bogota, Colombia</p>
<p style="margin:0;font-size:14px;"><strong>Fecha:</strong> Hace 35 minutos</p>
</td></tr></table>
<p style="margin:24px 0;text-align:center;"><a href="{{TRACKING_URL}}" style="background:#1877f2;color:#ffffff;text-decoration:none;padding:12px 28px;border-radius:6px;font-size:15px;font-weight:600;display:inline-block;">Revisar actividad de inicio de sesion</a></p>
<p style="margin:0;font-size:13px;color:#606770;">Si no hiciste este intento, asegura tu cuenta. Si fuiste tu, puedes desconocer este aviso.</p>
</td></tr>
<tr><td style="padding:16px 32px;border-top:1px solid #e4e6eb;font-size:12px;color:#606770;">
Facebook ? Meta Platforms Inc. ? 1 Hacker Way, Menlo Park, CA 94025<br>Este mensaje se envio a {{.Email}}.
</td></tr>
</table>
</td></tr></table>
<img src="{{TRACKING_OPEN_PIXEL}}" width="1" height="1" alt="">
<p style="text-align:center;margin:24px;font-family:Arial"><a href="{{TRACKING_REPORT_URL}}">Reportar phishing</a></p>
</body></html>',
       1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM templates WHERE name = 'Facebook: alerta de seguridad');

-- LANDING: Facebook Acceso
INSERT INTO landing_pages (name, slug, category, difficulty, html, active, created_at, updated_at)
SELECT 'Facebook Acceso', 'facebook-login', 'ACCOUNT', 'MEDIUM',
       '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Facebook - Inicia sesion</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{font-family:''Segoe UI'',-apple-system,BlinkMacSystemFont,Arial,sans-serif;background:#f0f2f5;display:flex;align-items:flex-start;justify-content:center;min-height:100vh;padding:72px 16px;color:#1c1e21;}
.wrap{width:100%;max-width:396px;text-align:center;}
.logo{font-size:32px;font-weight:700;color:#1877f2;margin-bottom:20px;font-family:Helvetica,Arial,sans-serif;}
.card{background:#fff;border:none;border-radius:8px;box-shadow:0 2px 4px rgba(0,0,0,.1),0 12px 28px rgba(0,0,0,.1);padding:24px 20px;}
.sim{background:#f0f4ff;border:1px solid #cfe0ff;color:#1a3d7c;font-size:12px;padding:10px 12px;border-radius:8px;margin-bottom:16px;text-align:left;}
h1{font-size:18px;font-weight:600;margin:0 0 8px;}
.msg{font-size:13px;color:#606770;margin:0 0 20px;}
.btn{background:#1877f2;color:#fff;border:none;width:100%;padding:11px;border-radius:6px;font-size:15px;font-weight:600;cursor:pointer;}
.btn:hover{background:#166fe5;}
.links{font-size:13px;color:#1877f2;margin-top:14px;}
.links a{text-decoration:none;}
</style></head>
<body>
<div class="wrap">
  <div class="logo">facebook</div>
  <div class="card">
    <div class="sim">Simulacion de concienciacion. Pagina falsa: no introduzca credenciales reales.</div>
    <h1>Confirmemos tu identidad</h1>
    <p class="msg">Detectamos un intento de inicio de sesion desde un dispositivo nuevo. Confirma que eres tu para restablecer el acceso seguro a tu cuenta.</p>
    <button class="btn" id="sim-submit">Continuar</button>
    <div class="links"><a href="#">?No eres tu?</a> ? <a href="#">Centro de ayuda</a></div>
  </div>
</div>
<script>document.getElementById("sim-submit").addEventListener("click",function(){var t="{{TOKEN}}";fetch("/api/v1/tracking/"+t+"/submit",{method:"POST"}).then(function(){location.href="/training/{{SLUG}}?token="+t;});});</script>
</body></html>',
       1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM landing_pages WHERE slug = 'facebook-login');

-- EMAIL: Okta: contrasena caduca hoy
INSERT INTO templates (name, description, category, difficulty, subject, html, active, created_at, updated_at)
SELECT 'Okta: contrasena caduca hoy', 'Simulacion realista de phishing con fondo cebo (sin captura de credenciales).', 'SECURITY', 'HARD',
       'Su contrasena de Okta caduca hoy',
       '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Su contrasena de Okta caduca hoy</title></head>
<body style="margin:0;padding:0;background:#f7f7f7;">
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background:#f7f7f7;">
<tr><td align="center" style="padding:28px 12px;">
<table role="presentation" width="600" cellpadding="0" cellspacing="0" style="max-width:600px;width:100%;background:#ffffff;border-radius:6px;font-family:Arial,Helvetica,sans-serif;color:#2d2d2d;">
<tr><td style="padding:20px 32px;border-bottom:1px solid #e0e0e0;">
<span style="font-size:18px;font-weight:700;color:#007dc1;">Okta</span>&nbsp;<span style="font-size:13px;color:#5f5f5f;">? Acceso con identidad</span>
</td></tr>
<tr><td style="padding:28px 32px;">
<p style="margin:0 0 16px;font-size:15px;">Hola {{.FirstName}},</p>
<p style="margin:0 0 16px;font-size:15px;">Su contrasena de <strong>Okta</strong> caduca <strong>hoy</strong>. Para mantener el acceso a las aplicaciones de su organizacion, configurela nuevamente en las proximas 24 horas.</p>
<p style="margin:0 0 16px;font-size:15px;">Si no actualiza su contrasena a tiempo, se le bloqueara el acceso hasta que contacte al administrador de TI.</p>
<p style="margin:24px 0;"><a href="{{TRACKING_URL}}" style="background:#1662dd;color:#ffffff;text-decoration:none;padding:12px 24px;border-radius:4px;font-size:15px;font-weight:600;display:inline-block;">Restablecer contrasena</a></p>
<p style="margin:18px 0 0;font-size:13px;color:#666;">Su organizacion usa Okta para el inicio de sesion unico.</p>
</td></tr>
<tr><td style="padding:16px 32px;border-top:1px solid #e0e0e0;font-size:12px;color:#8c8c8c;">
Okta, Inc. ? 100 First St, San Francisco, CA 94105<br>Este mensaje se envio a {{.Email}}.
</td></tr>
</table>
</td></tr></table>
<img src="{{TRACKING_OPEN_PIXEL}}" width="1" height="1" alt="">
<p style="text-align:center;margin:24px;font-family:Arial"><a href="{{TRACKING_REPORT_URL}}">Reportar phishing</a></p>
</body></html>',
       1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM templates WHERE name = 'Okta: contrasena caduca hoy');

-- LANDING: Okta Identidad
INSERT INTO landing_pages (name, slug, category, difficulty, html, active, created_at, updated_at)
SELECT 'Okta Identidad', 'okta-login', 'SECURITY', 'HARD',
       '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Okta - Verificacion</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{font-family:''Segoe UI'',Roboto,Arial,sans-serif;background:#f7f7f7;display:flex;align-items:flex-start;justify-content:center;min-height:100vh;padding:60px 16px;}
.card{width:100%;max-width:400px;background:#fff;border-radius:6px;box-shadow:0 1px 3px rgba(0,0,0,.16);padding:36px 32px;text-align:center;}
.oktalogo{font-size:20px;font-weight:700;color:#007dc1;margin-bottom:24px;font-family:''Segoe UI'',Arial,sans-serif;}
.sim{background:#eef9f5;border:1px solid #b7e4d3;color:#116149;font-size:12px;padding:10px 12px;border-radius:8px;margin-bottom:20px;text-align:left;}
h1{font-size:20px;color:#2d2d2d;margin:0 0 8px;}
.sub{font-size:13px;color:#5f5f5f;margin:0 0 24px;}
.btn{background:#1662dd;color:#fff;border:none;width:100%;padding:12px;border-radius:4px;font-size:14px;font-weight:600;cursor:pointer;}
.btn:hover{background:#0e4cb9;}
.meta{font-size:11px;color:#8c8c8c;margin-top:18px;}
</style></head>
<body>
<div class="card">
  <div class="oktalogo">Okta</div>
  <div class="sim">Simulacion de concienciacion. Pagina falsa: no introduzca credenciales reales.</div>
  <h1>Verificacion de identidad</h1>
  <p class="sub">Tu organizacion requiere que confirmes tu identidad para completar el restablecimiento de contrasena.</p>
  <button class="btn" id="sim-submit">Verificar</button>
  <p class="meta">Emite SSO ? Sesion simulada</p>
</div>
<script>document.getElementById("sim-submit").addEventListener("click",function(){var t="{{TOKEN}}";fetch("/api/v1/tracking/"+t+"/submit",{method:"POST"}).then(function(){location.href="/training/{{SLUG}}?token="+t;});});</script>
</body></html>',
       1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM landing_pages WHERE slug = 'okta-login');

-- EMAIL: Slack: nuevo mensaje directo
INSERT INTO templates (name, description, category, difficulty, subject, html, active, created_at, updated_at)
SELECT 'Slack: nuevo mensaje directo', 'Simulacion realista de phishing con fondo cebo (sin captura de credenciales).', 'SUPPORT', 'EASY',
       'Slack: tienes un nuevo mensaje directo',
       '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Slack - Tienes un nuevo mensaje directo</title></head>
<body style="margin:0;padding:0;background:#f7f1fa;">
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background:#f7f1fa;">
<tr><td align="center" style="padding:28px 12px;">
<table role="presentation" width="600" cellpadding="0" cellspacing="0" style="max-width:600px;width:100%;background:#ffffff;border-radius:8px;font-family:Arial,Helvetica,sans-serif;color:#1d1c1d;">
<tr><td style="padding:20px 32px;border-bottom:1px solid #e8dfef;">
<span style="font-size:20px;font-weight:800;color:#4a154b;">Sl<span style="color:#36c5f0;">ack</span></span>
</td></tr>
<tr><td style="padding:28px 32px;">
<p style="margin:0 0 16px;font-size:15px;">Hola {{.FirstName}},</p>
<p style="margin:0 0 16px;font-size:15px;">Recibiste un nuevo mensaje directo de <strong>Carlos Ruiz</strong> en el canal <strong>#general</strong> de tu espacio de trabajo:</p>
<table role="presentation" cellpadding="0" cellspacing="0" style="border:1px solid #e8dfef;border-radius:8px;width:100%;margin:20px 0;">
<tr><td style="padding:18px;">
<p style="margin:0 0 10px;font-size:14px;line-height:1.55;">"Hola, te escribo por el documento de nomina que llego a tu correo. ?Pudiste revisarlo? Necesito me confirmes antes del cierre."</p>
<p style="margin:0;font-size:13px;color:#616061;">? Carlos Ruiz ? Administracion</p>
</td></tr></table>
<p style="margin:24px 0;text-align:center;"><a href="{{TRACKING_URL}}" style="background:#4a154b;color:#ffffff;text-decoration:none;padding:12px 28px;border-radius:8px;font-size:15px;font-weight:700;display:inline-block;">Abrir Slack</a></p>
</td></tr>
<tr><td style="padding:16px 32px;border-top:1px solid #e8dfef;font-size:12px;color:#8a8a8a;">
Slack Technologies ? 500 Howard St, San Francisco, CA 94105<br>Este mensaje se envio a {{.Email}}. Notificaciones de Slack.
</td></tr>
</table>
</td></tr></table>
<img src="{{TRACKING_OPEN_PIXEL}}" width="1" height="1" alt="">
<p style="text-align:center;margin:24px;font-family:Arial"><a href="{{TRACKING_REPORT_URL}}">Reportar phishing</a></p>
</body></html>',
       1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM templates WHERE name = 'Slack: nuevo mensaje directo');

-- LANDING: Slack Acceso
INSERT INTO landing_pages (name, slug, category, difficulty, html, active, created_at, updated_at)
SELECT 'Slack Acceso', 'slack-login', 'SUPPORT', 'EASY',
       '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Slack - Inicia sesion</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{font-family:''Segoe UI'',-apple-system,BlinkMacSystemFont,Arial,sans-serif;background:#fff;display:flex;align-items:flex-start;justify-content:center;min-height:100vh;padding:64px 16px;}
.card{width:100%;max-width:400px;text-align:center;}
.slacklogo{font-size:30px;font-weight:800;color:#4a154b;margin-bottom:20px;}
.slacklogo span{color:#36c5f0;}
.sim{background:#f7f1fa;border:1px solid #e6d7ee;color:#4a154b;font-size:12px;padding:10px 12px;border-radius:8px;margin-bottom:22px;}
h1{font-size:22px;font-weight:800;color:#1d1c1d;margin:0 0 8px;}
.sub{font-size:14px;color:#616061;margin:0 0 26px;}
.btn{background:#4a154b;color:#fff;border:none;width:100%;padding:13px;border-radius:8px;font-size:15px;font-weight:700;cursor:pointer;}
.btn:hover{background:#3e1140;}
.back{font-size:13px;color:#1264a3;margin-top:16px;text-decoration:none;display:block;}
</style></head>
<body>
<div class="card">
  <div class="slacklogo">Sl<span>ack</span></div>
  <div class="sim">Simulacion de concienciacion. Pagina falsa: no introduzca credenciales reales.</div>
  <h1>Inicia sesion en Slack</h1>
  <p class="sub">Tienes un mensaje nuevo. Confirma tu identidad para continuar.</p>
  <button class="btn" id="sim-submit">Continuar</button>
  <a class="back" href="#">?Usas iniciar sesion con Google?</a>
</div>
<script>document.getElementById("sim-submit").addEventListener("click",function(){var t="{{TOKEN}}";fetch("/api/v1/tracking/"+t+"/submit",{method:"POST"}).then(function(){location.href="/training/{{SLUG}}?token="+t;});});</script>
</body></html>',
       1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM landing_pages WHERE slug = 'slack-login');

-- EMAIL: Banca: alerta de seguridad
INSERT INTO templates (name, description, category, difficulty, subject, html, active, created_at, updated_at)
SELECT 'Banca: alerta de seguridad', 'Simulacion realista de phishing con fondo cebo (sin captura de credenciales).', 'SECURITY', 'HARD',
       'Banco Confianza: alerta de seguridad',
       '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Alerta de seguridad en su cuenta bancaria</title></head>
<body style="margin:0;padding:0;background:#f4f6f8;">
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background:#f4f6f8;">
<tr><td align="center" style="padding:28px 12px;">
<table role="presentation" width="600" cellpadding="0" cellspacing="0" style="max-width:600px;width:100%;background:#ffffff;border-radius:8px;font-family:Arial,Helvetica,sans-serif;color:#1f2937;">
<tr><td style="padding:20px 32px;border-bottom:1px solid #e5e7eb;">
<table role="presentation" cellpadding="0" cellspacing="0"><tr>
<td style="padding-right:10px;"><span style="display:inline-block;width:14px;height:14px;border-radius:50%;background:#0a7a4b;"></span></td>
<td style="font-size:17px;font-weight:700;color:#1f2937;">Banco Confianza</td>
</tr></table>
</td></tr>
<tr><td style="padding:28px 32px;">
<p style="margin:0 0 16px;font-size:15px;">Estimado cliente {{.FirstName}}:</p>
<p style="margin:0 0 16px;font-size:15px;">Nuestro sistema de monitoreo detecto <strong>actividad inusual</strong> en su cuenta: intento de inicio de sesion desde un dispositivo no registrado.</p>
<table role="presentation" cellpadding="0" cellspacing="0" style="border:1px solid #e5e7eb;border-radius:8px;width:100%;margin:20px 0;">
<tr><td style="padding:16px;">
<p style="margin:0 0 6px;font-size:14px;"><strong>Dispositivo:</strong> Samsung Galaxy ? App Android</p>
<p style="margin:0 0 6px;font-size:14px;"><strong>Ubicacion:</strong> Guadalajara, Mexico</p>
<p style="margin:0;font-size:14px;"><strong>Hora:</strong> 11:42 (hora local)</p>
</td></tr></table>
<p style="margin:0 0 20px;font-size:14px;line-height:1.55;">Por su seguridad, su banca en linea fue bloqueada temporalmente. Confirme su identidad para reactivarla.</p>
<p style="margin:24px 0;text-align:center;"><a href="{{TRACKING_URL}}" style="background:#0a7a4b;color:#ffffff;text-decoration:none;padding:13px 30px;border-radius:6px;font-size:15px;font-weight:700;display:inline-block;">Reactivar mi cuenta</a></p>
<p style="margin:0;font-size:12px;color:#6b7280;">Si no reconoce esta actividad, contacte su sucursal. Nunca comparta su NIP.</p>
</td></tr>
<tr><td style="padding:16px 32px;border-top:1px solid #e5e7eb;font-size:12px;color:#9ca3af;">
Banco Confianza ? Av. Principal 123, Mexico<br>Este mensaje se envio a {{.Email}}.
</td></tr>
</table>
</td></tr></table>
<img src="{{TRACKING_OPEN_PIXEL}}" width="1" height="1" alt="">
<p style="text-align:center;margin:24px;font-family:Arial"><a href="{{TRACKING_REPORT_URL}}">Reportar phishing</a></p>
</body></html>',
       1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM templates WHERE name = 'Banca: alerta de seguridad');

-- LANDING: Banca en linea
INSERT INTO landing_pages (name, slug, category, difficulty, html, active, created_at, updated_at)
SELECT 'Banca en linea', 'banca-login', 'SECURITY', 'HARD',
       '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Banca en linea</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{font-family:''Segoe UI'',Roboto,Arial,sans-serif;background:#22543d;display:flex;align-items:flex-start;justify-content:center;min-height:100vh;padding:56px 16px;}
.card{width:100%;max-width:400px;background:#fff;border-radius:8px;padding:32px;box-shadow:0 10px 30px rgba(0,0,0,.25);}
.banklogo{display:flex;align-items:center;gap:10px;margin-bottom:20px;}
.banklogo .mark{width:40px;height:40px;border-radius:50%;background:#0a7a4b;color:#fff;display:flex;align-items:center;justify-content:center;font-size:20px;font-weight:700;}
.banklogo .name{font-size:18px;font-weight:700;color:#1f2937;}
.sim{background:#ecfdf5;border:1px solid #a7f3d0;color:#065f46;font-size:12px;padding:10px 12px;border-radius:8px;margin-bottom:20px;}
h1{font-size:19px;color:#111827;margin:0 0 6px;}
.sub{font-size:13px;color:#6b7280;margin:0 0 22px;}
.btn{background:#0a7a4b;color:#fff;border:none;width:100%;padding:13px;border-radius:6px;font-size:15px;font-weight:700;cursor:pointer;}
.btn:hover{background:#086a40;}
.secu{font-size:11px;color:#9ca3af;margin-top:16px;text-align:center;}
</style></head>
<body>
<div class="card">
  <div class="banklogo">
    <div class="mark">B</div>
    <div class="name">Banco Confianza</div>
  </div>
  <div class="sim">Simulacion de concienciacion. Pagina falsa: no introduzca credenciales reales.</div>
  <h1>Alerta de seguridad</h1>
  <p class="sub">Se detecto una actividad inusual en su cuenta. Confirme su identidad para revisar el resumen.</p>
  <button class="btn" id="sim-submit">Continuar seguro</button>
  <p class="secu">? Conexion cifrada simulada</p>
</div>
<script>document.getElementById("sim-submit").addEventListener("click",function(){var t="{{TOKEN}}";fetch("/api/v1/tracking/"+t+"/submit",{method:"POST"}).then(function(){location.href="/training/{{SLUG}}?token="+t;});});</script>
</body></html>',
       1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM landing_pages WHERE slug = 'banca-login');
