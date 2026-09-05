-- V15: Polish the seeded library and add LATAM phishing vectors.
-- 1. Fix corrupted punctuation (? ?) and restore proper Spanish accents on all
--    seeded email templates and landings (utf8mb4 storage, UTF-8 Flyway input).
-- 2. Restore real-brand, Spanish landings. V14 replaced them with fictional
--    English brands ("Northstar", "Orbit"...). Emails mention real services, so
--    landings must match. Simulation notice is kept small and out of the way so
--    the audit feels realistic while staying compliant.
-- 3. Add three LATAM-relevant pairs: SAT/CFDI, WhatsApp Business, DocuSign.
-- DECORATIVE LANDINGS ONLY: no credential capture. Submit records the event and
-- redirects to training. Placeholders: {{TRACKING_URL}}, {{TRACKING_OPEN_PIXEL}},
-- {{.FirstName}}, {{.Email}} in emails; {{TOKEN}}, {{SLUG}} in landings.

-- ============================================================
-- EMAILS: fix punctuation + accents
-- ============================================================

UPDATE templates SET
  name = 'Microsoft 365: caducidad de contraseña',
  subject = 'Su contraseña de Microsoft 365 caduca pronto',
  html = '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Su contraseña de Microsoft 365 caduca pronto</title></head>
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
<p style="margin:0 0 16px;">Su contraseña de <strong>Microsoft 365</strong> caducará en 3 días. Para evitar que se cierre su sesión en Outlook, Teams y OneDrive, conserve su contraseña actual o establezca una nueva ahora.</p>
<p style="margin:0 0 16px;">Si no realiza ninguna acción, podría perder el acceso a su correo hasta que restablezca la contraseña.</p>
<p style="margin:24px 0;"><a href="{{TRACKING_URL}}" style="background:#0078d4;color:#ffffff;text-decoration:none;padding:11px 22px;border-radius:3px;display:inline-block;font-size:15px;">Conservar mi contraseña</a></p>
<p style="margin:18px 0 0;font-size:13px;color:#777;">Administración de TI (Azure Active Directory)</p>
</td></tr>
<tr><td style="padding:16px 24px;border-top:1px solid #eeeeee;font-size:12px;line-height:1.5;color:#888888;">
Microsoft Corporation, One Microsoft Way, Redmond, WA 98052<br>Este mensaje se envió a {{.Email}}. No responda a este correo.
</td></tr>
</table>
</td></tr></table>
<img src="{{TRACKING_OPEN_PIXEL}}" width="1" height="1" alt="">
</body></html>',
  updated_at = NOW()
WHERE name = 'Microsoft 365: caducidad de contrasena';

UPDATE templates SET
  name = 'Google Drive: documento compartido',
  subject = 'Google Drive: documento compartido con usted',
  html = '<!DOCTYPE html>
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
<p style="margin:0;font-size:13px;color:#5f6368;">Compartido por: finanzas@empresa.com · Vence en 7 días</p>
</td></tr></table>
<p style="margin:24px 0;"><a href="{{TRACKING_URL}}" style="background:#1a73e8;color:#ffffff;text-decoration:none;padding:11px 22px;border-radius:4px;display:inline-block;font-size:15px;">Abrir documento</a></p>
<p style="margin:0 0 16px;font-size:13px;color:#5f6368;">Google Drive: almacenamiento seguro de archivos.</p>
</td></tr>
<tr><td style="padding:16px 32px;border-top:1px solid #e8eaed;font-size:12px;color:#80868b;">
Google LLC · 1600 Amphitheatre Parkway, Mountain View, CA 94043<br>Este mensaje se envió a {{.Email}}.
</td></tr>
</table>
</td></tr></table>
<img src="{{TRACKING_OPEN_PIXEL}}" width="1" height="1" alt="">
</body></html>',
  updated_at = NOW()
WHERE name = 'Google Drive: documento compartido';

UPDATE templates SET
  name = 'ChatGPT: pago pendiente',
  subject = 'OpenAI: acción requerida en su facturación',
  html = '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>OpenAI - Acción requerida: facturación</title></head>
<body style="margin:0;padding:0;background:#f7f7f8;">
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background:#f7f7f8;">
<tr><td align="center" style="padding:24px 12px;">
<table role="presentation" width="600" cellpadding="0" cellspacing="0" style="max-width:600px;width:100%;background:#ffffff;border:1px solid #e5e5e5;border-radius:8px;overflow:hidden;font-family:Arial,Helvetica,sans-serif;color:#0d0d0d;">
<tr><td style="background:#000000;padding:20px 32px;">
<span style="color:#ffffff;font-size:16px;font-weight:600;">OpenAI</span>
</td></tr>
<tr><td style="padding:28px 32px;">
<p style="margin:0 0 8px;font-size:13px;font-weight:600;color:#856404;background:#fff3cd;border:1px solid #ffc107;padding:12px;border-radius:6px;">No pudimos procesar la renovación de su espacio de trabajo ChatGPT Enterprise</p>
<p style="margin:18px 0 16px;font-size:15px;">Hola {{.FirstName}},</p>
<p style="margin:0 0 16px;font-size:14px;line-height:1.6;color:#353535;">No pudimos cobrar el último pago de su suscripción a <strong>ChatGPT Enterprise</strong>. Su espacio permanece activo por ahora, pero los asientos pasarán a un período de gracia limitado hasta que actualice los datos de facturación.</p>
<p style="margin:0 0 16px;font-size:14px;line-height:1.6;color:#353535;">Si la renovación no se completa durante el período de gracia, los miembros podrían perder temporalmente el acceso a conversaciones guardadas, proyectos compartidos y herramientas conectadas.</p>
<table role="presentation" cellpadding="0" cellspacing="0" style="border:1px solid #e5e5e5;border-radius:8px;width:100%;margin:18px 0;">
<tr><td style="background:#fafafa;padding:12px 16px;font-size:12px;font-weight:600;color:#6b6b6b;text-transform:uppercase;">Detalles de la suscripción</td></tr>
<tr><td style="padding:10px 16px;font-size:13px;border-top:1px solid #f0f0f0;"><span style="color:#6b6b6b;">Plan</span>&nbsp;&nbsp;<span style="font-weight:500;">ChatGPT Enterprise</span></td></tr>
<tr><td style="padding:10px 16px;font-size:13px;border-top:1px solid #f0f0f0;"><span style="color:#6b6b6b;">Factura</span>&nbsp;&nbsp;<span style="font-weight:500;">INV-8842-0317</span></td></tr>
<tr><td style="padding:10px 16px;font-size:13px;border-top:1px solid #f0f0f0;"><span style="color:#6b6b6b;">Estado</span>&nbsp;&nbsp;<span style="background:#fef2f2;color:#b91c1c;font-size:12px;font-weight:600;padding:3px 9px;border-radius:4px;border:1px solid #fecaca;">Pago fallido</span></td></tr>
</table>
<p style="margin:0 0 20px;font-size:13px;color:#b91c1c;line-height:1.5;">Actualice el método de pago antes de que termine el período de gracia para mantener su espacio totalmente activo.</p>
<p style="margin:24px 0;text-align:center;"><a href="{{TRACKING_URL}}" style="background:#000000;color:#ffffff;text-decoration:none;padding:13px 30px;border-radius:6px;font-size:14px;font-weight:600;display:inline-block;">Revisar datos de facturación</a></p>
<p style="margin:0;font-size:12px;color:#9b9b9b;text-align:center;">Se le pedirá iniciar sesión en su cuenta de OpenAI.</p>
</td></tr>
<tr><td style="background:#000000;padding:20px 32px;">
<p style="margin:0 0 4px;font-size:12px;color:#9b9b9b;">Este mensaje se envió a {{.Email}}.</p>
<p style="margin:0;font-size:12px;color:#9b9b9b;">OpenAI, 3180 18th St, San Francisco, CA 94110</p>
</td></tr>
</table>
</td></tr></table>
<img src="{{TRACKING_OPEN_PIXEL}}" width="1" height="1" alt="">
</body></html>',
  updated_at = NOW()
WHERE name = 'ChatGPT: pago pendiente';

UPDATE templates SET
  name = 'Canva: diseño compartido',
  subject = 'Canva: te compartieron un diseño',
  html = '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Canva - Te compartieron un diseño</title></head>
<body style="margin:0;padding:0;background:#f6f1ff;">
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background:#f6f1ff;">
<tr><td align="center" style="padding:28px 12px;">
<table role="presentation" width="600" cellpadding="0" cellspacing="0" style="max-width:600px;width:100%;background:#ffffff;border:1px solid #e5e0ff;border-radius:16px;font-family:Arial,Helvetica,sans-serif;color:#181818;">
<tr><td style="padding:22px 32px;text-align:center;">
<p style="margin:0;font-size:24px;font-weight:800;color:#00c4cc;">canva</p>
</td></tr>
<tr><td style="padding:8px 32px;">
<p style="margin:0 0 16px;font-size:15px;">Hola {{.FirstName}},</p>
<p style="margin:0 0 16px;font-size:15px;">El área de <strong>Marketing</strong> te compartió un diseño de Canva: <strong>"Campaña Q4 - Novedades"</strong>.</p>
<table role="presentation" cellpadding="0" cellspacing="0" style="border:1px solid #e5e0ff;border-radius:12px;width:100%;margin:20px 0;">
<tr><td style="padding:18px;text-align:center;">
<p style="margin:0 0 6px;font-size:14px;font-weight:600;">Campaña Q4 - Novedades</p>
<p style="margin:0;font-size:13px;color:#8b8b8b;">Compartido por: marketing@empresa.com</p>
</td></tr></table>
<p style="margin:24px 0;text-align:center;"><a href="{{TRACKING_URL}}" style="background:linear-gradient(135deg,#7d2ae8,#00c4cc);color:#ffffff;text-decoration:none;padding:13px 30px;border-radius:12px;font-size:15px;font-weight:600;display:inline-block;">Ver diseño</a></p>
<p style="margin:0;font-size:12px;color:#9b9b9b;text-align:center;">Solo tú puedes ver este diseño.</p>
</td></tr>
<tr><td style="padding:16px 32px;border-top:1px solid #f0edfa;font-size:12px;color:#8b8b8b;text-align:center;">
Canva Pty Ltd · 110 Kippax St, Surry Hills NSW 2010, Australia<br>Este mensaje se envió a {{.Email}}.
</td></tr>
</table>
</td></tr></table>
<img src="{{TRACKING_OPEN_PIXEL}}" width="1" height="1" alt="">
</body></html>',
  updated_at = NOW()
WHERE name = 'Canva: diseno compartido';

UPDATE templates SET
  name = 'LinkedIn: nuevo mensaje InMail',
  subject = 'LinkedIn: tienes un nuevo mensaje InMail',
  html = '<!DOCTYPE html>
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
<p style="margin:0 0 16px;font-size:15px;">Recibiste un nuevo mensaje de <strong>Laura Méndez</strong>, Reclutadora en Talento Global:</p>
<table role="presentation" cellpadding="0" cellspacing="0" style="border:1px solid #e0dfdc;border-radius:8px;width:100%;margin:20px 0;">
<tr><td style="padding:18px;">
<p style="margin:0 0 10px;font-size:14px;line-height:1.55;">"Hola, vi tu perfil y me gustaría conversar sobre una oportunidad laboral. ¿Tienes unos minutos esta semana?"</p>
<p style="margin:0;font-size:13px;color:#666;">· Laura Méndez · Talento Global</p>
</td></tr></table>
<p style="margin:24px 0;text-align:center;"><a href="{{TRACKING_URL}}" style="background:#0a66c2;color:#ffffff;text-decoration:none;padding:12px 28px;border-radius:24px;font-size:15px;font-weight:600;display:inline-block;">Responder mensaje</a></p>
</td></tr>
<tr><td style="padding:16px 32px;border-top:1px solid #e0dfdc;font-size:12px;color:#8c8c8c;">
LinkedIn Corporation · 1000 W Maude Ave, Sunnyvale, CA 94085<br>Este mensaje se envió a {{.Email}}. Notificaciones de LinkedIn.
</td></tr>
</table>
</td></tr></table>
<img src="{{TRACKING_OPEN_PIXEL}}" width="1" height="1" alt="">
</body></html>',
  updated_at = NOW()
WHERE name = 'LinkedIn: nuevo mensaje InMail';

UPDATE templates SET
  name = 'Instagram: alerta de inicio de sesión',
  subject = 'Instagram: nuevo inicio de sesión en tu cuenta',
  html = '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Nuevo inicio de sesión en tu cuenta de Instagram</title></head>
<body style="margin:0;padding:0;background:#fafafa;">
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background:#fafafa;">
<tr><td align="center" style="padding:28px 12px;">
<table role="presentation" width="600" cellpadding="0" cellspacing="0" style="max-width:600px;width:100%;background:#ffffff;border:1px solid #dbdbdb;border-radius:8px;font-family:Arial,Helvetica,sans-serif;color:#262626;">
<tr><td style="padding:24px 32px;text-align:center;border-bottom:1px solid #efefef;">
<span style="font-size:24px;font-weight:600;letter-spacing:-.5px;">Instagram</span>
</td></tr>
<tr><td style="padding:28px 32px;">
<p style="margin:0 0 16px;font-size:15px;">Hola {{.FirstName}},</p>
<p style="margin:0 0 16px;font-size:15px;">Detectamos un <strong>nuevo inicio de sesión</strong> en tu cuenta de Instagram desde un dispositivo desconocido.</p>
<table role="presentation" cellpadding="0" cellspacing="0" style="border:1px solid #dbdbdb;border-radius:8px;width:100%;margin:20px 0;">
<tr><td style="padding:16px;">
<p style="margin:0 0 6px;font-size:14px;"><strong>Dispositivo:</strong> Chrome · Windows</p>
<p style="margin:0 0 6px;font-size:14px;"><strong>Ubicación:</strong> Ciudad de México, MX</p>
<p style="margin:0;font-size:14px;"><strong>Fecha:</strong> Hoy, hace 2 horas</p>
</td></tr></table>
<p style="margin:0 0 20px;font-size:14px;color:#262626;">Si fuiste tú, ignora este correo. Si no reconoces esta actividad, protege tu cuenta de inmediato.</p>
<p style="margin:24px 0;text-align:center;"><a href="{{TRACKING_URL}}" style="background:#0095f6;color:#ffffff;text-decoration:none;padding:12px 28px;border-radius:8px;font-size:15px;font-weight:600;display:inline-block;">Asegurar mi cuenta</a></p>
</td></tr>
<tr><td style="padding:16px 32px;border-top:1px solid #efefef;font-size:12px;color:#8e8e8e;">
Instagram · Meta Platforms Inc. · 1 Hacker Way, Menlo Park, CA 94025<br>Este mensaje se envió a {{.Email}}.
</td></tr>
</table>
</td></tr></table>
<img src="{{TRACKING_OPEN_PIXEL}}" width="1" height="1" alt="">
</body></html>',
  updated_at = NOW()
WHERE name = 'Instagram: alerta de inicio de sesion';

UPDATE templates SET
  name = 'Facebook: alerta de seguridad',
  subject = 'Facebook: alerta de seguridad en tu cuenta',
  html = '<!DOCTYPE html>
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
<p style="margin:0 0 16px;font-size:15px;">Recientemente hubo un <strong>intento de inicio de sesión</strong> en tu cuenta de Facebook desde un navegador o dispositivo que no reconocíamos.</p>
<p style="margin:0 0 16px;font-size:15px;">Por seguridad, hemos limitado temporalmente ciertas acciones de tu cuenta hasta que confirmes tu identidad.</p>
<table role="presentation" cellpadding="0" cellspacing="0" style="border:1px solid #e4e6eb;border-radius:8px;width:100%;margin:20px 0;">
<tr><td style="padding:16px;">
<p style="margin:0 0 6px;font-size:14px;"><strong>Dispositivo:</strong> Firefox · Linux</p>
<p style="margin:0 0 6px;font-size:14px;"><strong>Ubicación:</strong> Bogotá, Colombia</p>
<p style="margin:0;font-size:14px;"><strong>Fecha:</strong> Hace 35 minutos</p>
</td></tr></table>
<p style="margin:24px 0;text-align:center;"><a href="{{TRACKING_URL}}" style="background:#1877f2;color:#ffffff;text-decoration:none;padding:12px 28px;border-radius:6px;font-size:15px;font-weight:600;display:inline-block;">Revisar actividad de inicio de sesión</a></p>
<p style="margin:0;font-size:13px;color:#606770;">Si no hiciste este intento, asegura tu cuenta. Si fuiste tú, puedes desconocer este aviso.</p>
</td></tr>
<tr><td style="padding:16px 32px;border-top:1px solid #e4e6eb;font-size:12px;color:#606770;">
Facebook · Meta Platforms Inc. · 1 Hacker Way, Menlo Park, CA 94025<br>Este mensaje se envió a {{.Email}}.
</td></tr>
</table>
</td></tr></table>
<img src="{{TRACKING_OPEN_PIXEL}}" width="1" height="1" alt="">
</body></html>',
  updated_at = NOW()
WHERE name = 'Facebook: alerta de seguridad';

UPDATE templates SET
  name = 'Okta: contraseña caduca hoy',
  subject = 'Su contraseña de Okta caduca hoy',
  html = '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Su contraseña de Okta caduca hoy</title></head>
<body style="margin:0;padding:0;background:#f7f7f7;">
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background:#f7f7f7;">
<tr><td align="center" style="padding:28px 12px;">
<table role="presentation" width="600" cellpadding="0" cellspacing="0" style="max-width:600px;width:100%;background:#ffffff;border-radius:6px;font-family:Arial,Helvetica,sans-serif;color:#2d2d2d;">
<tr><td style="padding:20px 32px;border-bottom:1px solid #e0e0e0;">
<span style="font-size:18px;font-weight:700;color:#007dc1;">Okta</span>&nbsp;<span style="font-size:13px;color:#5f5f5f;">· Acceso con identidad</span>
</td></tr>
<tr><td style="padding:28px 32px;">
<p style="margin:0 0 16px;font-size:15px;">Hola {{.FirstName}},</p>
<p style="margin:0 0 16px;font-size:15px;">Su contraseña de <strong>Okta</strong> caduca <strong>hoy</strong>. Para mantener el acceso a las aplicaciones de su organización, configúrela nuevamente en las próximas 24 horas.</p>
<p style="margin:0 0 16px;font-size:15px;">Si no actualiza su contraseña a tiempo, se le bloqueará el acceso hasta que contacte al administrador de TI.</p>
<p style="margin:24px 0;"><a href="{{TRACKING_URL}}" style="background:#1662dd;color:#ffffff;text-decoration:none;padding:12px 24px;border-radius:4px;font-size:15px;font-weight:600;display:inline-block;">Restablecer contraseña</a></p>
<p style="margin:18px 0 0;font-size:13px;color:#666;">Su organización usa Okta para el inicio de sesión único.</p>
</td></tr>
<tr><td style="padding:16px 32px;border-top:1px solid #e0e0e0;font-size:12px;color:#8c8c8c;">
Okta, Inc. · 100 First St, San Francisco, CA 94105<br>Este mensaje se envió a {{.Email}}.
</td></tr>
</table>
</td></tr></table>
<img src="{{TRACKING_OPEN_PIXEL}}" width="1" height="1" alt="">
</body></html>',
  updated_at = NOW()
WHERE name = 'Okta: contrasena caduca hoy';

UPDATE templates SET
  name = 'Slack: nuevo mensaje directo',
  subject = 'Slack: tienes un nuevo mensaje directo',
  html = '<!DOCTYPE html>
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
<p style="margin:0 0 10px;font-size:14px;line-height:1.55;">"Hola, te escribo por el documento de nómina que llegó a tu correo. ¿Pudiste revisarlo? Necesito que me confirmes antes del cierre."</p>
<p style="margin:0;font-size:13px;color:#616061;">· Carlos Ruiz · Administración</p>
</td></tr></table>
<p style="margin:24px 0;text-align:center;"><a href="{{TRACKING_URL}}" style="background:#4a154b;color:#ffffff;text-decoration:none;padding:12px 28px;border-radius:8px;font-size:15px;font-weight:700;display:inline-block;">Abrir Slack</a></p>
</td></tr>
<tr><td style="padding:16px 32px;border-top:1px solid #e8dfef;font-size:12px;color:#8a8a8a;">
Slack Technologies · 500 Howard St, San Francisco, CA 94105<br>Este mensaje se envió a {{.Email}}. Notificaciones de Slack.
</td></tr>
</table>
</td></tr></table>
<img src="{{TRACKING_OPEN_PIXEL}}" width="1" height="1" alt="">
</body></html>',
  updated_at = NOW()
WHERE name = 'Slack: nuevo mensaje directo';

UPDATE templates SET
  name = 'Banca: alerta de seguridad',
  subject = 'Banco Confianza: alerta de seguridad',
  html = '<!DOCTYPE html>
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
<p style="margin:0 0 16px;font-size:15px;">Nuestro sistema de monitoreo detectó <strong>actividad inusual</strong> en su cuenta: intento de inicio de sesión desde un dispositivo no registrado.</p>
<table role="presentation" cellpadding="0" cellspacing="0" style="border:1px solid #e5e7eb;border-radius:8px;width:100%;margin:20px 0;">
<tr><td style="padding:16px;">
<p style="margin:0 0 6px;font-size:14px;"><strong>Dispositivo:</strong> Samsung Galaxy · App Android</p>
<p style="margin:0 0 6px;font-size:14px;"><strong>Ubicación:</strong> Guadalajara, México</p>
<p style="margin:0;font-size:14px;"><strong>Hora:</strong> 11:42 (hora local)</p>
</td></tr></table>
<p style="margin:0 0 20px;font-size:14px;line-height:1.55;">Por su seguridad, su banca en línea fue bloqueada temporalmente. Confirme su identidad para reactivarla.</p>
<p style="margin:24px 0;text-align:center;"><a href="{{TRACKING_URL}}" style="background:#0a7a4b;color:#ffffff;text-decoration:none;padding:13px 30px;border-radius:6px;font-size:15px;font-weight:700;display:inline-block;">Reactivar mi cuenta</a></p>
<p style="margin:0;font-size:12px;color:#6b7280;">Si no reconoce esta actividad, contacte su sucursal. Nunca comparta su NIP.</p>
</td></tr>
<tr><td style="padding:16px 32px;border-top:1px solid #e5e7eb;font-size:12px;color:#9ca3af;">
Banco Confianza · Av. Principal 123, México<br>Este mensaje se envió a {{.Email}}.
</td></tr>
</table>
</td></tr></table>
<img src="{{TRACKING_OPEN_PIXEL}}" width="1" height="1" alt="">
</body></html>',
  updated_at = NOW()
WHERE name = 'Banca: alerta de seguridad';

UPDATE templates SET
  name = 'Revisión de beneficios',
  subject = 'Revisa tu nuevo resumen de beneficios',
  html = '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Resumen de beneficios</title></head>
<body style="margin:0;padding:0;background:#f5f7fa;">
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background:#f5f7fa;">
<tr><td align="center" style="padding:28px 12px;">
<table role="presentation" width="560" cellpadding="0" cellspacing="0" style="max-width:560px;width:100%;background:#ffffff;border:1px solid #e2e8f0;border-radius:10px;font-family:Arial,Helvetica,sans-serif;color:#1e293b;">
<tr><td style="padding:18px 28px;border-bottom:1px solid #e2e8f0;">
<span style="font-size:15px;font-weight:700;color:#17324d;">Recursos Humanos</span>
</td></tr>
<tr><td style="padding:28px;">
<p style="margin:0 0 14px;font-size:15px;">Hola {{.FirstName}},</p>
<p style="margin:0 0 14px;font-size:15px;">Tu nuevo <strong>resumen de beneficios</strong> ya está disponible. Incluye los cambios de la temporada de inscripción y vence el <strong>28 de febrero</strong>.</p>
<p style="margin:22px 0;"><a href="{{TRACKING_URL}}" style="background:#17324d;color:#ffffff;text-decoration:none;padding:11px 22px;border-radius:6px;display:inline-block;font-size:14px;font-weight:600;">Abrir resumen</a></p>
<p style="margin:14px 0 0;font-size:12px;color:#64748b;">¿Preguntas? Contacta al equipo de beneficios: beneficios@empresa.com</p>
</td></tr>
</table>
</td></tr></table>
<img src="{{TRACKING_OPEN_PIXEL}}" width="1" height="1" alt="">
</body></html>',
  updated_at = NOW()
WHERE name = 'Revision de beneficios';

UPDATE templates SET
  name = 'Soporte: actividad inusual',
  subject = 'Nueva actividad en tu cuenta',
  html = '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Nueva actividad detectada</title></head>
<body style="margin:0;padding:0;background:#f5f7fa;">
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background:#f5f7fa;">
<tr><td align="center" style="padding:28px 12px;">
<table role="presentation" width="560" cellpadding="0" cellspacing="0" style="max-width:560px;width:100%;background:#ffffff;border:1px solid #e2e8f0;border-radius:10px;font-family:Arial,Helvetica,sans-serif;color:#1e293b;">
<tr><td style="padding:18px 28px;border-bottom:1px solid #e2e8f0;">
<span style="font-size:15px;font-weight:700;color:#b45309;">Soporte de TI</span>
</td></tr>
<tr><td style="padding:28px;">
<p style="margin:0 0 14px;font-size:15px;">Hola {{.FirstName}},</p>
<p style="margin:0 0 14px;font-size:15px;">Detectamos un <strong>inicio de sesión desde un dispositivo nuevo</strong> en tu cuenta corporativa.</p>
<table role="presentation" cellpadding="0" cellspacing="0" style="border:1px solid #e2e8f0;border-radius:8px;width:100%;margin:18px 0;">
<tr><td style="padding:14px;">
<p style="margin:0 0 6px;font-size:13px;"><strong>Dispositivo:</strong> Edge · Windows 11</p>
<p style="margin:0;font-size:13px;"><strong>Ubicación:</strong> Monterrey, México</p>
</td></tr></table>
<p style="margin:0 0 18px;font-size:14px;">Si fuiste tú, ignora este aviso. Si no reconoces esta actividad, confírmalo para proteger tu cuenta.</p>
<p style="margin:22px 0;"><a href="{{TRACKING_URL}}" style="background:#b45309;color:#ffffff;text-decoration:none;padding:11px 22px;border-radius:6px;display:inline-block;font-size:14px;font-weight:600;">Revisar actividad</a></p>
</td></tr>
</table>
</td></tr></table>
<img src="{{TRACKING_OPEN_PIXEL}}" width="1" height="1" alt="">
</body></html>',
  updated_at = NOW()
WHERE name = 'Soporte: actividad inusual';

-- ============================================================
-- LANDINGS: restore real-brand Spanish pages (V14 replaced them
-- with fictional English brands that contradict the email copy)
-- ============================================================

UPDATE landing_pages SET
  name = 'Microsoft 365 login',
  html = '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Iniciar sesión - Microsoft 365</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{font-family:"Segoe UI",Roboto,Arial,sans-serif;background:#f2f2f2;display:flex;align-items:flex-start;justify-content:center;min-height:100vh;padding:40px 16px;}
.card{width:100%;max-width:440px;background:#fff;padding:44px;box-shadow:0 2px 6px rgba(0,0,0,.2);}
.mslogo{width:108px;height:23px;margin-bottom:22px;}
.mslogo span{display:inline-block;width:23px;height:23px;margin-right:3px;}
h1{font-size:24px;font-weight:600;color:#1b1b1b;margin:0 0 8px;}
.sub{font-size:14px;color:#3c3c3c;margin:0 0 26px;}
.btn{background:#0067b8;color:#fff;border:none;padding:12px 24px;font-size:15px;font-weight:600;cursor:pointer;float:right;}
.btn:hover{background:#005a9e;}
.back{color:#666;font-size:12px;margin-top:16px;}
.foot{margin-top:34px;border-top:1px solid #efefef;padding-top:14px;font-size:11px;color:#999;}
.foot a{color:#0067b8;text-decoration:none;}
</style></head>
<body>
<div class="card">
  <div class="mslogo">
    <span style="background:#f25022;"></span><span style="background:#7fba00;"></span><span style="background:#00a4ef;"></span><span style="background:#ffb900;"></span>
  </div>
  <h1>Iniciar sesión</h1>
  <p class="sub">Para continuar a Outlook, Teams y OneDrive, verifica tu cuenta.</p>
  <button class="btn" id="sim-submit">Siguiente</button>
  <p class="back"><a href="#" style="color:#0067b8;text-decoration:none;">¿No puedes acceder a tu cuenta?</a></p>
  <div class="foot">Términos de uso · Privacidad y cookies<br>Simulación de entrenamiento de seguridad</div>
</div>
<script>document.getElementById("sim-submit").addEventListener("click",function(){var t="{{TOKEN}}";fetch("/api/v1/tracking/"+t+"/submit",{method:"POST"}).then(function(){location.href="/training/{{SLUG}}?token="+t;});});</script>
</body></html>',
  updated_at = NOW()
WHERE slug = 'm365-login';

UPDATE landing_pages SET
  name = 'Google Acceso',
  html = '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Inicia sesión - Cuentas de Google</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{font-family:Roboto,Arial,sans-serif;background:#fff;display:flex;align-items:center;justify-content:center;min-height:100vh;color:#202124;}
.card{width:100%;max-width:448px;border:1px solid #dadce0;border-radius:8px;padding:48px 40px 36px;}
.brand{margin:0 auto 16px;}
h1{font-size:24px;font-weight:400;text-align:center;margin:0 0 8px;}
.sub{font-size:16px;color:#5f6368;text-align:center;margin:0 0 32px;}
.field{margin:0 0 20px;}
.label{font-size:13px;margin:0 0 6px;color:#202124;}
.inputwrap{display:flex;align-items:center;border:1px solid #dadce0;border-radius:4px;height:48px;padding:0 12px;font-size:15px;color:#5f6368;}
.inputwrap .mail{flex:1;color:#202124;}
.next{margin-top:24px;display:flex;justify-content:flex-end;}
.btn{background:#1a73e8;color:#fff;border:none;border-radius:4px;padding:11px 24px;font-size:15px;font-weight:500;cursor:pointer;}
.btn:hover{background:#1765cc;}
.foot{margin-top:30px;text-align:center;font-size:12px;color:#70757a;}
.foot a{color:#1a73e8;text-decoration:none;}
</style></head>
<body>
<div class="card">
  <h1>Acceder</h1>
  <p class="sub">para continuar a Gmail</p>
  <div class="field">
    <div class="label">Correo electrónico o teléfono</div>
    <div class="inputwrap"><span class="mail">correo@empresa.com</span></div>
  </div>
  <div class="next"><button class="btn" id="sim-submit">Siguiente</button></div>
  <div class="foot"><a href="#">¿Olvidaste tu correo electrónico?</a><br>Ayuda · Privacidad · Términos</div>
</div>
<script>document.getElementById("sim-submit").addEventListener("click",function(){var t="{{TOKEN}}";fetch("/api/v1/tracking/"+t+"/submit",{method:"POST"}).then(function(){location.href="/training/{{SLUG}}?token="+t;});});</script>
</body></html>',
  updated_at = NOW()
WHERE slug = 'google-login';

UPDATE landing_pages SET
  name = 'OpenAI Acceso',
  html = '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>OpenAI - Inicia sesión</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{font-family:"Segoe UI",-apple-system,BlinkMacSystemFont,Arial,sans-serif;background:#212121;display:flex;align-items:center;justify-content:center;min-height:100vh;color:#ececec;}
.card{width:100%;max-width:400px;background:#171717;border:1px solid #333;border-radius:24px;padding:40px;text-align:center;}
.logo{width:48px;height:48px;margin:0 auto 20px;border-radius:12px;background:#ececec;display:flex;align-items:center;justify-content:center;}
.knot{width:24px;height:24px;border-radius:50%;background:conic-gradient(from 90deg,#10a37f,#10a37f 40%,#e2e2e2 40%,#e2e2e2 45%,#10a37f 45%,#10a37f 60%,#e2e2e2 60%,#e2e2e2 65%,#10a37f 65%);}
h1{font-size:21px;font-weight:600;margin:0 0 8px;color:#fff;}
.sub{font-size:13px;color:#b0b0b0;margin:0 0 28px;}
.btn{background:#10a37f;color:#fff;border:none;width:100%;padding:12px;border-radius:999px;font-size:15px;font-weight:600;cursor:pointer;}
.btn:hover{background:#0e8f70;}
.alt{font-size:11px;color:#8a8a8a;margin-top:16px;}
.foot{margin-top:22px;font-size:11px;color:#666;}
</style></head>
<body>
<div class="card">
  <div class="logo"><div class="knot"></div></div>
  <h1>Inicia sesión en OpenAI</h1>
  <p class="sub">Conexión segura. Verifica tu sesión para continuar con la facturación.</p>
  <button class="btn" id="sim-submit">Continuar</button>
  <p class="alt">Al continuar aceptas los Términos de servicio simulados.</p>
  <div class="foot">Simulación de entrenamiento de seguridad</div>
</div>
<script>document.getElementById("sim-submit").addEventListener("click",function(){var t="{{TOKEN}}";fetch("/api/v1/tracking/"+t+"/submit",{method:"POST"}).then(function(){location.href="/training/{{SLUG}}?token="+t;});});</script>
</body></html>',
  updated_at = NOW()
WHERE slug = 'chatgpt-login';

UPDATE landing_pages SET
  name = 'Canva Acceso',
  html = '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Inicia sesión en Canva</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{font-family:"Poppins",-apple-system,BlinkMacSystemFont,"Segoe UI",Arial,sans-serif;background:radial-gradient(at top,#f6f1ff 0%,#fff 60%);display:flex;align-items:center;justify-content:center;min-height:100vh;}
.card{width:100%;max-width:420px;background:#fff;border:1px solid #e5e0ff;border-radius:16px;box-shadow:0 8px 30px rgba(80,0,200,.08);padding:40px 36px;text-align:center;}
.logo{font-size:26px;font-weight:700;color:#00c4cc;margin-bottom:4px;}
.logo small{font-weight:400;color:#8b8b8b;font-size:13px;display:block;letter-spacing:.5px;}
h1{font-size:22px;color:#181818;margin:22px 0 6px;}
.sub{font-size:14px;color:#6b6b6b;margin:0 0 26px;}
.btn{background:linear-gradient(135deg,#7d2ae8 0%,#00c4cc 130%);color:#fff;border:none;width:100%;padding:13px;border-radius:12px;font-size:16px;font-weight:600;cursor:pointer;margin-top:8px;}
.btn:hover{opacity:.92;}
.alt{font-size:12px;color:#9b9b9b;margin-top:14px;}
.foot{margin-top:24px;font-size:11px;color:#b5aac9;}
</style></head>
<body>
<div class="card">
  <div class="logo">canva<small>Design anything</small></div>
  <h1>Inicia sesión en Canva</h1>
  <p class="sub">Accede para ver el diseño compartido contigo.</p>
  <button class="btn" id="sim-submit">Continuar con Canva</button>
  <p class="alt">¿No puedes acceder? Contacta al soporte.</p>
  <div class="foot">Simulación de entrenamiento de seguridad</div>
</div>
<script>document.getElementById("sim-submit").addEventListener("click",function(){var t="{{TOKEN}}";fetch("/api/v1/tracking/"+t+"/submit",{method:"POST"}).then(function(){location.href="/training/{{SLUG}}?token="+t;});});</script>
</body></html>',
  updated_at = NOW()
WHERE slug = 'canva-login';

UPDATE landing_pages SET
  name = 'LinkedIn Acceso',
  html = '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>LinkedIn: Inicia sesión</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Arial,sans-serif;background:#f3f2ef;display:flex;align-items:flex-start;justify-content:center;min-height:100vh;padding:56px 16px;}
.card{width:100%;max-width:400px;background:#fff;border-radius:8px;padding:32px 24px;box-shadow:0 0 0 1px rgba(0,0,0,.08);}
.logo{color:#0a66c2;font-size:20px;font-weight:700;margin-bottom:24px;}
.logo i{font-style:normal;background:#0a66c2;color:#fff;border-radius:4px;padding:2px 4px;margin-right:2px;}
h1{font-size:21px;font-weight:600;color:#0b0d12;margin:0 0 6px;}
.sub{font-size:13px;color:#616161;margin:0 0 24px;}
.btn{background:#0a66c2;color:#fff;border:none;width:100%;padding:12px;border-radius:24px;font-size:15px;font-weight:600;cursor:pointer;margin-top:6px;}
.btn:hover{background:#004182;}
.or{text-align:center;font-size:12px;color:#8c8c8c;margin:16px 0;}
.join{font-size:13px;color:#0a66c2;text-align:center;margin-top:8px;}
.foot{margin-top:26px;border-top:1px solid #efefef;padding-top:12px;font-size:11px;color:#8c8c8c;text-align:center;}
</style></head>
<body>
<div class="card">
  <div class="logo"><i>in</i> LinkedIn</div>
  <h1>Acceder</h1>
  <p class="sub">Bienvenido de nuevo. Un nuevo mensaje InMail te espera.</p>
  <button class="btn" id="sim-submit">Aceptar y continuar</button>
  <div class="or">o</div>
  <p class="join"><a href="#" style="color:#0a66c2;">¿No tienes cuenta? Únete ahora</a></p>
  <div class="foot">Simulación de entrenamiento de seguridad</div>
</div>
<script>document.getElementById("sim-submit").addEventListener("click",function(){var t="{{TOKEN}}";fetch("/api/v1/tracking/"+t+"/submit",{method:"POST"}).then(function(){location.href="/training/{{SLUG}}?token="+t;});});</script>
</body></html>',
  updated_at = NOW()
WHERE slug = 'linkedin-login';

UPDATE landing_pages SET
  name = 'Instagram Acceso',
  html = '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Instagram</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Arial,sans-serif;background:#fafafa;display:flex;align-items:center;justify-content:center;min-height:100vh;color:#262626;}
.wrap{width:100%;max-width:350px;}
.card{background:#fff;border:1px solid #dbdbdb;border-radius:4px;padding:34px 40px 26px;text-align:center;}
.logo{font-family:"Segoe UI",sans-serif;font-size:28px;font-weight:600;letter-spacing:-.5px;margin-bottom:26px;}
.logo span{background:linear-gradient(45deg,#f09433,#e6683c 25%,#dc2743 50%,#cc2366 75%,#bc1888);-webkit-background-clip:text;background-clip:text;-webkit-text-fill-color:transparent;}
.userbox{border:1px solid #dbdbdb;border-radius:6px;padding:12px;display:flex;align-items:center;gap:10px;margin-bottom:22px;}
.avatar{width:36px;height:36px;border-radius:50%;background:linear-gradient(45deg,#f09433,#dc2743,#bc1888);display:flex;align-items:center;justify-content:center;color:#fff;font-size:16px;font-weight:600;}
.uname{font-size:14px;font-weight:600;text-align:left;}
.msg{font-size:13px;color:#8e8e8e;text-align:left;}
.extra{font-size:13px;color:#8e8e8e;margin:0 0 22px;}
.btn{background:#0095f6;color:#fff;border:none;width:100%;padding:11px;border-radius:8px;font-size:14px;font-weight:600;cursor:pointer;}
.btn:hover{background:#1877f2;}
.switch{font-size:12px;color:#262626;margin-top:14px;}
.switch a{color:#0095f6;text-decoration:none;}
.foot{margin-top:22px;font-size:10px;color:#c7c7c7;}
</style></head>
<body>
<div class="wrap">
  <div class="card">
    <div class="logo"><span>Instagram</span></div>
    <div class="userbox">
      <div class="avatar">U</div>
      <div><div class="uname">usuario.ejemplo</div><div class="msg">Usuario</div></div>
    </div>
    <p class="extra">Por tu seguridad, confirma que eres tú antes de continuar.</p>
    <button class="btn" id="sim-submit">Continuar</button>
    <div class="switch">¿No eres tú? <a href="#">Usar otra cuenta</a></div>
    <div class="foot">Simulación de entrenamiento de seguridad</div>
  </div>
</div>
<script>document.getElementById("sim-submit").addEventListener("click",function(){var t="{{TOKEN}}";fetch("/api/v1/tracking/"+t+"/submit",{method:"POST"}).then(function(){location.href="/training/{{SLUG}}?token="+t;});});</script>
</body></html>',
  updated_at = NOW()
WHERE slug = 'instagram-login';

UPDATE landing_pages SET
  name = 'Facebook Acceso',
  html = '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Facebook - Inicia sesión</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{font-family:"Segoe UI",-apple-system,BlinkMacSystemFont,Arial,sans-serif;background:#f0f2f5;display:flex;align-items:flex-start;justify-content:center;min-height:100vh;padding:72px 16px;color:#1c1e21;}
.wrap{width:100%;max-width:396px;text-align:center;}
.logo{font-size:32px;font-weight:700;color:#1877f2;margin-bottom:20px;font-family:Helvetica,Arial,sans-serif;}
.card{background:#fff;border:none;border-radius:8px;box-shadow:0 2px 4px rgba(0,0,0,.1),0 12px 28px rgba(0,0,0,.1);padding:24px 20px;}
h1{font-size:18px;font-weight:600;margin:0 0 8px;}
.msg{font-size:13px;color:#606770;margin:0 0 20px;}
.btn{background:#1877f2;color:#fff;border:none;width:100%;padding:11px;border-radius:6px;font-size:15px;font-weight:600;cursor:pointer;}
.btn:hover{background:#166fe5;}
.links{font-size:13px;color:#1877f2;margin-top:14px;}
.links a{text-decoration:none;}
.foot{margin-top:26px;font-size:11px;color:#8a8d91;}
</style></head>
<body>
<div class="wrap">
  <div class="logo">facebook</div>
  <div class="card">
    <h1>Confirmemos tu identidad</h1>
    <p class="msg">Detectamos un intento de inicio de sesión desde un dispositivo nuevo. Confirma que eres tú para restablecer el acceso seguro a tu cuenta.</p>
    <button class="btn" id="sim-submit">Continuar</button>
    <div class="links"><a href="#">¿No eres tú?</a> · <a href="#">Centro de ayuda</a></div>
  </div>
  <div class="foot">Simulación de entrenamiento de seguridad</div>
</div>
<script>document.getElementById("sim-submit").addEventListener("click",function(){var t="{{TOKEN}}";fetch("/api/v1/tracking/"+t+"/submit",{method:"POST"}).then(function(){location.href="/training/{{SLUG}}?token="+t;});});</script>
</body></html>',
  updated_at = NOW()
WHERE slug = 'facebook-login';

UPDATE landing_pages SET
  name = 'Okta Identidad',
  html = '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Okta - Verificación</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{font-family:"Segoe UI",Roboto,Arial,sans-serif;background:#f7f7f7;display:flex;align-items:flex-start;justify-content:center;min-height:100vh;padding:60px 16px;}
.card{width:100%;max-width:400px;background:#fff;border-radius:6px;box-shadow:0 1px 3px rgba(0,0,0,.16);padding:36px 32px;text-align:center;}
.oktalogo{font-size:20px;font-weight:700;color:#007dc1;margin-bottom:24px;}
h1{font-size:20px;color:#2d2d2d;margin:0 0 8px;}
.sub{font-size:13px;color:#5f5f5f;margin:0 0 24px;}
.field{text-align:left;border:1px solid #d9d9d9;border-radius:4px;padding:12px 14px;margin-bottom:22px;color:#8c8c8c;font-size:14px;}
.btn{background:#1662dd;color:#fff;border:none;width:100%;padding:12px;border-radius:4px;font-size:14px;font-weight:600;cursor:pointer;}
.btn:hover{background:#0e4cb9;}
.meta{font-size:11px;color:#8c8c8c;margin-top:18px;}
.foot{margin-top:16px;font-size:11px;color:#b0b0b0;}
</style></head>
<body>
<div class="card">
  <div class="oktalogo">Okta</div>
  <h1>Verificación de identidad</h1>
  <p class="sub">Tu organización requiere que confirmes tu identidad para completar el restablecimiento de contraseña.</p>
  <div class="field">Correo electrónico de la organización</div>
  <button class="btn" id="sim-submit">Siguiente</button>
  <p class="meta">SSO · Acceso con identidad</p>
  <div class="foot">Simulación de entrenamiento de seguridad</div>
</div>
<script>document.getElementById("sim-submit").addEventListener("click",function(){var t="{{TOKEN}}";fetch("/api/v1/tracking/"+t+"/submit",{method:"POST"}).then(function(){location.href="/training/{{SLUG}}?token="+t;});});</script>
</body></html>',
  updated_at = NOW()
WHERE slug = 'okta-login';

UPDATE landing_pages SET
  name = 'Slack Acceso',
  html = '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Slack - Inicia sesión</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{font-family:"Segoe UI",-apple-system,BlinkMacSystemFont,Arial,sans-serif;background:#fff;display:flex;align-items:flex-start;justify-content:center;min-height:100vh;padding:64px 16px;}
.card{width:100%;max-width:400px;text-align:center;}
.slacklogo{font-size:30px;font-weight:800;color:#4a154b;margin-bottom:20px;}
.slacklogo span{color:#36c5f0;}
h1{font-size:22px;font-weight:800;color:#1d1c1d;margin:0 0 8px;}
.sub{font-size:14px;color:#616061;margin:0 0 26px;}
.btn{background:#4a154b;color:#fff;border:none;width:100%;padding:13px;border-radius:8px;font-size:15px;font-weight:700;cursor:pointer;}
.btn:hover{background:#3e1140;}
.back{font-size:13px;color:#1264a3;margin-top:16px;text-decoration:none;display:block;}
.foot{margin-top:26px;font-size:11px;color:#c5c5c5;}
</style></head>
<body>
<div class="card">
  <div class="slacklogo">Sl<span>ack</span></div>
  <h1>Inicia sesión en Slack</h1>
  <p class="sub">Tienes un mensaje nuevo. Confirma tu identidad para continuar.</p>
  <button class="btn" id="sim-submit">Continuar</button>
  <a class="back" href="#">¿Usas iniciar sesión con Google?</a>
  <div class="foot">Simulación de entrenamiento de seguridad</div>
</div>
<script>document.getElementById("sim-submit").addEventListener("click",function(){var t="{{TOKEN}}";fetch("/api/v1/tracking/"+t+"/submit",{method:"POST"}).then(function(){location.href="/training/{{SLUG}}?token="+t;});});</script>
</body></html>',
  updated_at = NOW()
WHERE slug = 'slack-login';

UPDATE landing_pages SET
  name = 'Banca en línea',
  html = '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Banca en línea</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{font-family:"Segoe UI",Roboto,Arial,sans-serif;background:#22543d;display:flex;align-items:flex-start;justify-content:center;min-height:100vh;padding:56px 16px;}
.card{width:100%;max-width:400px;background:#fff;border-radius:8px;padding:32px;box-shadow:0 10px 30px rgba(0,0,0,.25);}
.banklogo{display:flex;align-items:center;gap:10px;margin-bottom:20px;}
.banklogo .mark{width:40px;height:40px;border-radius:50%;background:#0a7a4b;color:#fff;display:flex;align-items:center;justify-content:center;font-size:20px;font-weight:700;}
.banklogo .name{font-size:18px;font-weight:700;color:#1f2937;}
h1{font-size:19px;color:#111827;margin:0 0 6px;}
.sub{font-size:13px;color:#6b7280;margin:0 0 22px;}
.btn{background:#0a7a4b;color:#fff;border:none;width:100%;padding:13px;border-radius:6px;font-size:15px;font-weight:700;cursor:pointer;}
.btn:hover{background:#086a40;}
.secu{font-size:11px;color:#9ca3af;margin-top:16px;text-align:center;}
.foot{margin-top:14px;font-size:11px;color:#b8c4bb;}
</style></head>
<body>
<div class="card">
  <div class="banklogo">
    <div class="mark">B</div>
    <div class="name">Banco Confianza</div>
  </div>
  <h1>Alerta de seguridad</h1>
  <p class="sub">Se detectó una actividad inusual en su cuenta. Confirme su identidad para revisar el resumen.</p>
  <button class="btn" id="sim-submit">Continuar seguro</button>
  <p class="secu">· Conexión cifrada · Nunca comparta su NIP</p>
  <div class="foot">Simulación de entrenamiento de seguridad</div>
</div>
<script>document.getElementById("sim-submit").addEventListener("click",function(){var t="{{TOKEN}}";fetch("/api/v1/tracking/"+t+"/submit",{method:"POST"}).then(function(){location.href="/training/{{SLUG}}?token="+t;});});</script>
</body></html>',
  updated_at = NOW()
WHERE slug = 'banca-login';

UPDATE landing_pages SET
  name = 'Revisión de beneficios',
  html = '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Resumen de beneficios</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{font-family:"Segoe UI",Arial,sans-serif;background:#f5f7fa;display:flex;align-items:center;justify-content:center;min-height:100vh;color:#1e293b;}
.card{width:100%;max-width:460px;background:#fff;border:1px solid #e2e8f0;border-radius:12px;padding:40px;}
.brand{color:#17324d;font-size:15px;font-weight:700;margin-bottom:22px;}
h1{font-size:22px;margin:0 0 8px;}
.sub{font-size:14px;color:#64748b;margin:0 0 26px;}
.btn{background:#17324d;color:#fff;border:none;padding:12px 22px;border-radius:6px;font-size:14px;font-weight:600;cursor:pointer;}
.btn:hover{background:#10273c;}
.foot{margin-top:28px;font-size:11px;color:#b0b8c4;}
</style></head>
<body>
<div class="card">
  <div class="brand">Recursos Humanos</div>
  <h1>Resumen de beneficios</h1>
  <p class="sub">Revisa tu nuevo resumen de la temporada de inscripción.</p>
  <button class="btn" id="sim-submit">Abrir resumen</button>
  <div class="foot">Simulación de entrenamiento de seguridad</div>
</div>
<script>document.getElementById("sim-submit").addEventListener("click",function(){var t="{{TOKEN}}";fetch("/api/v1/tracking/"+t+"/submit",{method:"POST"}).then(function(){location.href="/training/{{SLUG}}?token="+t;});});</script>
</body></html>',
  updated_at = NOW()
WHERE slug = 'benefits-review';

UPDATE landing_pages SET
  name = 'Nueva actividad',
  html = '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Nueva actividad detectada</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{font-family:"Segoe UI",Arial,sans-serif;background:#f5f7fa;display:flex;align-items:center;justify-content:center;min-height:100vh;color:#1e293b;}
.card{width:100%;max-width:460px;background:#fff;border:1px solid #e2e8f0;border-radius:12px;padding:40px;}
.brand{color:#b45309;font-size:15px;font-weight:700;margin-bottom:22px;}
h1{font-size:22px;margin:0 0 8px;}
.sub{font-size:14px;color:#64748b;margin:0 0 26px;}
.btn{background:#b45309;color:#fff;border:none;padding:12px 22px;border-radius:6px;font-size:14px;font-weight:600;cursor:pointer;}
.btn:hover{background:#9a4508;}
.foot{margin-top:28px;font-size:11px;color:#b0b8c4;}
</style></head>
<body>
<div class="card">
  <div class="brand">Soporte de TI</div>
  <h1>Nueva actividad detectada</h1>
  <p class="sub">Confirma si reconoces un inicio de sesión desde un dispositivo nuevo.</p>
  <button class="btn" id="sim-submit">Revisar actividad</button>
  <div class="foot">Simulación de entrenamiento de seguridad</div>
</div>
<script>document.getElementById("sim-submit").addEventListener("click",function(){var t="{{TOKEN}}";fetch("/api/v1/tracking/"+t+"/submit",{method:"POST"}).then(function(){location.href="/training/{{SLUG}}?token="+t;});});</script>
</body></html>',
  updated_at = NOW()
WHERE slug = 'new-activity';

-- ============================================================
-- NEW LATAM VECTORS
-- ============================================================

-- SAT/CFDI: comprobante fiscal pendiente
INSERT INTO templates (name, description, category, difficulty, subject, html, active, created_at, updated_at)
SELECT 'SAT: comprobante fiscal pendiente de verificación', 'Aviso fiscal realista (SAT) para LATAM.', 'SECURITY', 'HARD',
       'SAT: su comprobante fiscal requiere verificación',
       '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>SAT - Verificación de comprobante fiscal</title></head>
<body style="margin:0;padding:0;background:#f2f5f9;">
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background:#f2f5f9;">
<tr><td align="center" style="padding:28px 12px;">
<table role="presentation" width="600" cellpadding="0" cellspacing="0" style="max-width:600px;width:100%;background:#ffffff;border:1px solid #dbe2ea;border-radius:6px;font-family:Arial,Helvetica,sans-serif;color:#1f2937;">
<tr><td style="padding:18px 32px;border-bottom:3px solid #1a7a4c;">
<p style="margin:0;font-size:16px;font-weight:700;color:#1a7a4c;">Servicio de Administración Tributaria</p>
<p style="margin:0;font-size:11px;color:#6b7280;">Gobierno de México · SAT</p>
</td></tr>
<tr><td style="padding:28px 32px;">
<p style="margin:0 0 16px;font-size:15px;">Estimado contribuyente {{.FirstName}}:</p>
<p style="margin:0 0 16px;font-size:14px;line-height:1.6;">Le informamos que el <strong>comprobante fiscal digital por Internet (CFDI)</strong> con folio <strong>7C8F-4E2A-9B1D-3F6A</strong> no pudo ser verificado en el padrón del SAT y <strong>no es válido para efectos fiscales</strong>.</p>
<table role="presentation" cellpadding="0" cellspacing="0" style="border:1px solid #e5e7eb;border-radius:6px;width:100%;margin:18px 0;">
<tr><td style="padding:12px 16px;font-size:13px;border-bottom:1px solid #f0f0f0;"><span style="color:#6b7280;">RFC</span>&nbsp;&nbsp;<strong>XAXX010101000</strong></td></tr>
<tr><td style="padding:12px 16px;font-size:13px;border-bottom:1px solid #f0f0f0;"><span style="color:#6b7280;">Emisor</span>&nbsp;&nbsp;<strong>Comercializadora del Bajío S.A.</strong></td></tr>
<tr><td style="padding:12px 16px;font-size:13px;"><span style="color:#6b7280;">Importe</span>&nbsp;&nbsp;<strong>$ 48,750.00 MXN</strong></td></tr>
</table>
<p style="margin:0 0 16px;font-size:14px;line-height:1.6;">Para evitar la cancelación del comprobante y multas asociadas, realice la verificación en las próximas <strong>72 horas</strong>.</p>
<p style="margin:24px 0;text-align:center;"><a href="{{TRACKING_URL}}" style="background:#1a7a4c;color:#ffffff;text-decoration:none;padding:13px 30px;border-radius:4px;font-size:14px;font-weight:600;display:inline-block;">Verificar comprobante</a></p>
<p style="margin:0;font-size:12px;color:#6b7280;">Atentamente,<br>Administración Central de Servicios al Contribuyente</p>
</td></tr>
<tr><td style="padding:16px 32px;border-top:1px solid #e5e7eb;font-size:12px;color:#9ca3af;">
Servicio de Administración Tributaria · Av. Hidalgo 77, Col. Guerrero, Ciudad de México<br>Este mensaje se envió a {{.Email}}.
</td></tr>
</table>
</td></tr></table>
<img src="{{TRACKING_OPEN_PIXEL}}" width="1" height="1" alt="">
</body></html>',
       1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM templates WHERE name = 'SAT: comprobante fiscal pendiente de verificación');

INSERT INTO landing_pages (name, slug, category, difficulty, html, active, created_at, updated_at)
SELECT 'SAT Verificación', 'sat-verificacion', 'SECURITY', 'HARD',
       '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>SAT - Verificación de CFDI</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{font-family:"Segoe UI",Arial,sans-serif;background:#f2f5f9;display:flex;align-items:flex-start;justify-content:center;min-height:100vh;padding:48px 16px;}
.card{width:100%;max-width:440px;background:#fff;border:1px solid #dbe2ea;border-radius:6px;box-shadow:0 6px 24px rgba(0,0,0,.08);padding:36px 32px;}
.gov{width:40px;height:40px;border-radius:50%;background:#1a7a4c;display:flex;align-items:center;justify-content:center;color:#fff;font-size:18px;font-weight:700;margin-bottom:14px;}
.brand{font-size:15px;font-weight:700;color:#1a7a4c;}
.brand small{display:block;font-size:11px;color:#6b7280;font-weight:400;}
h1{font-size:21px;color:#111827;margin:24px 0 8px;}
.sub{font-size:13px;color:#6b7280;margin:0 0 24px;line-height:1.55;}
.field{border:1px solid #d1d5db;border-radius:4px;padding:13px 14px;color:#4b5563;font-size:14px;margin-bottom:18px;}
.btn{background:#1a7a4c;color:#fff;border:none;width:100%;padding:13px;border-radius:4px;font-size:15px;font-weight:600;cursor:pointer;}
.btn:hover{background:#14653f;}
.secu{font-size:11px;color:#9ca3af;margin-top:16px;text-align:center;}
</style></head>
<body>
<div class="card">
  <div class="gov">M</div>
  <div class="brand">Servicio de Administración Tributaria<small>Gobierno de México</small></div>
  <h1>Verificación de CFDI</h1>
  <p class="sub">Confirme sus datos para validar el comprobante fiscal pendiente de verificación.</p>
  <div class="field">RFC: XAXX010101000</div>
  <button class="btn" id="sim-submit">Verificar</button>
  <p class="secu">· Conexión cifrada · Gob.mx</p>
</div>
<script>document.getElementById("sim-submit").addEventListener("click",function(){var t="{{TOKEN}}";fetch("/api/v1/tracking/"+t+"/submit",{method:"POST"}).then(function(){location.href="/training/{{SLUG}}?token="+t;});});</script>
</body></html>',
       1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM landing_pages WHERE slug = 'sat-verificacion');

-- WhatsApp Business: verificación de cuenta
INSERT INTO templates (name, description, category, difficulty, subject, html, active, created_at, updated_at)
SELECT 'WhatsApp Business: verificación de cuenta', 'Alerta de suspensión de WhatsApp Business para LATAM.', 'ACCOUNT', 'HARD',
       'WhatsApp: acción requerida en su cuenta de negocio',
       '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>WhatsApp Business - Verificación requerida</title></head>
<body style="margin:0;padding:0;background:#f0f7f4;">
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background:#f0f7f4;">
<tr><td align="center" style="padding:28px 12px;">
<table role="presentation" width="560" cellpadding="0" cellspacing="0" style="max-width:560px;width:100%;background:#ffffff;border:1px solid #d6e8df;border-radius:10px;font-family:Arial,Helvetica,sans-serif;color:#1f2937;">
<tr><td style="padding:20px 28px;border-bottom:1px solid #e8f0ec;">
<span style="display:inline-block;width:34px;height:34px;border-radius:50%;background:#25d366;vertical-align:middle;"></span>&nbsp;<span style="font-size:17px;font-weight:700;color:#075e54;vertical-align:middle;">WhatsApp Business</span>
</td></tr>
<tr><td style="padding:28px;">
<p style="margin:0 0 16px;font-size:15px;">Hola {{.FirstName}},</p>
<p style="margin:0 0 16px;font-size:14px;line-height:1.6;">Detectamos actividad inusual en el número asociado a tu cuenta de <strong>WhatsApp Business</strong>. Según nuestros términos, las cuentas con actividad sospechosa deben verificar su número para continuar operando.</p>
<table role="presentation" cellpadding="0" cellspacing="0" style="border:1px solid #e5e7eb;border-radius:8px;width:100%;margin:18px 0;">
<tr><td style="padding:12px 16px;font-size:13px;border-bottom:1px solid #f0f0f0;"><span style="color:#6b7280;">Número</span>&nbsp;&nbsp;<strong>+52 55 1234 5678</strong></td></tr>
<tr><td style="padding:12px 16px;font-size:13px;border-bottom:1px solid #f0f0f0;"><span style="color:#6b7280;">Estado</span>&nbsp;&nbsp;<span style="background:#fef2f2;color:#b91c1c;font-size:12px;font-weight:600;padding:3px 9px;border-radius:4px;">En revisión</span></td></tr>
<tr><td style="padding:12px 16px;font-size:13px;"><span style="color:#6b7280;">Fecha límite</span>&nbsp;&nbsp;<strong>Mañana, 11:59 p. m.</strong></td></tr>
</table>
<p style="margin:0 0 18px;font-size:14px;line-height:1.6;">Si no completas la verificación, tu cuenta será <strong>suspendida temporalmente</strong> y perderás acceso a tus chats, catálogo y listas de difusión.</p>
<p style="margin:24px 0;text-align:center;"><a href="{{TRACKING_URL}}" style="background:#25d366;color:#075e54;text-decoration:none;padding:13px 30px;border-radius:8px;font-size:15px;font-weight:700;display:inline-block;">Verificar mi número</a></p>
<p style="margin:0;font-size:12px;color:#6b7280;">WhatsApp Ireland Limited · Este mensaje se envió a {{.Email}}.</p>
</td></tr>
</table>
</td></tr></table>
<img src="{{TRACKING_OPEN_PIXEL}}" width="1" height="1" alt="">
</body></html>',
       1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM templates WHERE name = 'WhatsApp Business: verificación de cuenta');

INSERT INTO landing_pages (name, slug, category, difficulty, html, active, created_at, updated_at)
SELECT 'WhatsApp Verificación', 'whatsapp-verificacion', 'ACCOUNT', 'HARD',
       '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>WhatsApp Business</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{font-family:"Segoe UI",Roboto,Arial,sans-serif;background:#075e54;display:flex;align-items:center;justify-content:center;min-height:100vh;color:#1f2937;}
.card{width:100%;max-width:400px;background:#fff;border-radius:12px;padding:36px 32px;box-shadow:0 14px 40px rgba(0,0,0,.25);text-align:center;}
.logo{width:56px;height:56px;border-radius:50%;background:#25d366;margin:0 auto 20px;display:flex;align-items:center;justify-content:center;}
.logo i{font-style:normal;color:#075e54;font-size:26px;font-weight:800;}
h1{font-size:22px;margin:0 0 8px;}
.sub{font-size:13px;color:#6b7280;margin:0 0 24px;line-height:1.55;}
.field{border:1px solid #d1d5db;border-radius:8px;padding:13px 14px;color:#4b5563;font-size:14px;margin-bottom:18px;text-align:left;}
.btn{background:#25d366;color:#075e54;border:none;width:100%;padding:13px;border-radius:8px;font-size:15px;font-weight:700;cursor:pointer;}
.btn:hover{background:#1fb85a;}
.alt{font-size:12px;color:#0b7a63;margin-top:14px;}
</style></head>
<body>
<div class="card">
  <div class="logo"><i>&#10003;</i></div>
  <h1>Confirma tu número</h1>
  <p class="sub">Te enviamos un código de verificación por SMS. Escríbelo para confirmar que la cuenta es tuya.</p>
  <div class="field">+52 55 1234 5678</div>
  <div class="field">Código de 6 dígitos</div>
  <button class="btn" id="sim-submit">Continuar</button>
  <p class="alt">¿No es tu número? Cambiar</p>
</div>
<script>document.getElementById("sim-submit").addEventListener("click",function(){var t="{{TOKEN}}";fetch("/api/v1/tracking/"+t+"/submit",{method:"POST"}).then(function(){location.href="/training/{{SLUG}}?token="+t;});});</script>
</body></html>',
       1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM landing_pages WHERE slug = 'whatsapp-verificacion');

-- DocuSign: documento para firma
INSERT INTO templates (name, description, category, difficulty, subject, html, active, created_at, updated_at)
SELECT 'DocuSign: documento para firma', 'Documento compartido para firma electrónica (DocuSign).', 'DOCUMENT', 'EASY',
       'DocuSign: documento compartido para su firma',
       '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>DocuSign - Documento para firma</title></head>
<body style="margin:0;padding:0;background:#f4f6fa;">
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background:#f4f6fa;">
<tr><td align="center" style="padding:28px 12px;">
<table role="presentation" width="600" cellpadding="0" cellspacing="0" style="max-width:600px;width:100%;background:#ffffff;border:1px solid #dde3ee;border-radius:8px;font-family:Arial,Helvetica,sans-serif;color:#001845;">
<tr><td style="padding:20px 32px;border-bottom:1px solid #e8ecf5;">
<span style="font-size:19px;font-weight:800;color:#142c8e;">DocuSign</span>
</td></tr>
<tr><td style="padding:28px 32px;">
<p style="margin:0 0 16px;font-size:15px;">Hola {{.FirstName}},</p>
<p style="margin:0 0 16px;font-size:15px;">Recursos Humanos le compartió un documento para su <strong>firma electrónica</strong>:</p>
<table role="presentation" cellpadding="0" cellspacing="0" style="border:1px solid #dde3ee;border-radius:8px;width:100%;margin:20px 0;">
<tr><td style="padding:16px;" align="center">
<p style="margin:0 0 6px;font-size:14px;font-weight:600;">Convenio de Confidencialidad (NDA)</p>
<p style="margin:0;font-size:13px;color:#64748b;">Enviado por: rh@empresa.com · Vence en 15 días</p>
</td></tr></table>
<p style="margin:24px 0;text-align:center;"><a href="{{TRACKING_URL}}" style="background:#142c8e;color:#ffffff;text-decoration:none;padding:13px 30px;border-radius:6px;font-size:15px;font-weight:600;display:inline-block;">Revisar documento</a></p>
<p style="margin:0;font-size:12px;color:#64748b;text-align:center;">Al firmar electrónicamente, su firma será válida según la legislación aplicable.</p>
</td></tr>
<tr><td style="padding:16px 32px;border-top:1px solid #e8ecf5;font-size:12px;color:#8a94ad;">
DocuSign, Inc. · 221 Main St, Suite 1550, San Francisco, CA 94105<br>Este mensaje se envió a {{.Email}}.
</td></tr>
</table>
</td></tr></table>
<img src="{{TRACKING_OPEN_PIXEL}}" width="1" height="1" alt="">
</body></html>',
       1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM templates WHERE name = 'DocuSign: documento para firma');

INSERT INTO landing_pages (name, slug, category, difficulty, html, active, created_at, updated_at)
SELECT 'DocuSign Acceso', 'docusign-firma', 'DOCUMENT', 'EASY',
       '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>DocuSign - Inicia sesión</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{font-family:"Segoe UI",-apple-system,BlinkMacSystemFont,Arial,sans-serif;background:#142c8e;display:flex;align-items:flex-start;justify-content:center;min-height:100vh;padding:60px 16px;}
.card{width:100%;max-width:420px;background:#fff;border-radius:8px;padding:36px 32px;box-shadow:0 12px 34px rgba(0,0,0,.3);text-align:center;}
.brand{font-size:22px;font-weight:800;color:#142c8e;}
.brand span{color:#b0b7ff;}
h1{font-size:21px;color:#001845;margin:26px 0 8px;}
.sub{font-size:13px;color:#64748b;margin:0 0 24px;line-height:1.55;}
.field{border:1px solid #d1d8e8;border-radius:6px;padding:13px 14px;color:#64748b;font-size:14px;margin-bottom:14px;text-align:left;}
.btn{background:#142c8e;color:#fff;border:none;width:100%;padding:13px;border-radius:6px;font-size:15px;font-weight:600;cursor:pointer;}
.btn:hover{background:#0f216d;}
.alt{font-size:12px;color:#64748b;margin-top:14px;}
</style></head>
<body>
<div class="card">
  <div class="brand">Docu<span>Sign</span></div>
  <h1>Firma electrónica</h1>
  <p class="sub">Revise y firme el documento enviado por Recursos Humanos.</p>
  <div class="field">Correo electrónico</div>
  <button class="btn" id="sim-submit">Iniciar sesión y revisar</button>
  <p class="alt">¿No es tu documento? No hacer caso</p>
</div>
<script>document.getElementById("sim-submit").addEventListener("click",function(){var t="{{TOKEN}}";fetch("/api/v1/tracking/"+t+"/submit",{method:"POST"}).then(function(){location.href="/training/{{SLUG}}?token="+t;});});</script>
</body></html>',
       1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM landing_pages WHERE slug = 'docusign-firma');