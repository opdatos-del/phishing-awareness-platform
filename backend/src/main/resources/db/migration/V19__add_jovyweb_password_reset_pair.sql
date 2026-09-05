-- V19: Add internal-system pair styled after the real Jovyweb login
-- (frontend/src/app/features/login: blue #0967c9 panel, yellow #ffd400 support
-- bar, white rounded inputs). High-realism vector: targeting the company's own
-- platform. DECORATIVE LANDING ONLY: no credential capture. Submit registers
-- the event and redirects to training.
-- Placeholders: {{TRACKING_URL}}, {{TRACKING_OPEN_PIXEL}}, {{.FirstName}},
-- {{.Email}} in the email; {{TOKEN}}, {{SLUG}} in the landing.

-- EMAIL: Jovyweb — password was reset, create a new one
INSERT INTO templates (name, description, category, difficulty, subject, html, active, created_at, updated_at)
SELECT 'Jovyweb: cree una nueva contraseña', 'Simulación interna de restablecimiento de contraseña del sistema Jovyweb.', 'ACCOUNT', 'HARD',
       'Jovyweb: cree una nueva contraseña de acceso',
       '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Jovyweb - Nueva contraseña</title></head>
<body style="margin:0;padding:0;background:#eef3f9;">
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background:#eef3f9;">
<tr><td align="center" style="padding:28px 12px;">
<table role="presentation" width="600" cellpadding="0" cellspacing="0" style="max-width:600px;width:100%;background:#ffffff;border:1px solid #dbe3ed;border-radius:8px;font-family:Arial,Helvetica,sans-serif;color:#1f2937;">
<tr><td style="padding:18px 32px;border-bottom:2px solid #0967c9;">
<table role="presentation" cellpadding="0" cellspacing="0"><tr>
<td style="padding-right:10px;vertical-align:middle;"><span style="display:inline-block;width:30px;height:30px;border-radius:7px;background:#0967c9;color:#ffffff;font-size:17px;font-weight:700;line-height:30px;text-align:center;vertical-align:middle;">J</span></td>
<td style="vertical-align:middle;"><span style="font-size:18px;font-weight:700;color:#0967c9;">Jovyweb</span></td>
</tr></table>
</td></tr>
<tr><td style="padding:28px 32px;">
<p style="margin:0 0 16px;font-size:15px;">Hola {{.FirstName}},</p>
<p style="margin:0 0 16px;font-size:15px;line-height:1.6;">El administrador del sistema <strong>restableció su contraseña de acceso</strong> a Jovyweb por una solicitud de seguridad.</p>
<p style="margin:0 0 16px;font-size:15px;line-height:1.6;">Para continuar usando el sistema, cree una nueva contraseña antes de que el enlace caduque en <strong>24 horas</strong>.</p>
<p style="margin:24px 0;text-align:center;"><a href="{{TRACKING_URL}}" style="background:#0967c9;color:#ffffff;text-decoration:none;padding:13px 30px;border-radius:8px;font-size:15px;font-weight:700;display:inline-block;">Crear nueva contraseña</a></p>
<p style="margin:0 0 16px;font-size:13px;color:#6b7280;line-height:1.6;">Si usted no solicitó este cambio, póngase en contacto con el área de Soporte.</p>
</td></tr>
<tr><td style="padding:16px 32px;border-top:1px solid #e5eaf1;font-size:12px;color:#9aa5b1;">
Jovyweb · Sistema de gestión interno<br>Este mensaje se envió a {{.Email}}. No responda a este correo.
</td></tr>
</table>
</td></tr></table>
<img src="{{TRACKING_OPEN_PIXEL}}" width="1" height="1" alt="">
</body></html>',
       1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM templates WHERE name = 'Jovyweb: cree una nueva contraseña');

-- LANDING: Jovyweb "create new password" replica (blue panel right, yellow support bar)
INSERT INTO landing_pages (name, slug, category, difficulty, html, active, created_at, updated_at)
SELECT 'Jovyweb Nueva Contraseña', 'jovyweb-nueva-contrasena', 'ACCOUNT', 'HARD',
       '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Jovyweb - Cree su nueva contraseña</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{font-family:"Montserrat",Arial,Helvetica,sans-serif;background:#dde7f2;min-height:100vh;display:flex;align-items:stretch;position:relative;overflow:hidden;}
.bg{position:absolute;inset:0;background:linear-gradient(135deg,#b6cbe4 0%,#dde7f2 45%,#eef3f9 100%);}
.panel{position:absolute;top:0;right:0;width:410px;height:100%;background:#0967c9;display:flex;flex-direction:column;align-items:center;}
@media(max-width:768px){.panel{width:100%;}}
.content{display:flex;flex-direction:column;align-items:center;width:100%;padding-bottom:90px;}
.welcome{margin:42px 0 0;color:#ffffff;font-size:29px;font-weight:700;text-align:center;}
.avatar{width:110px;height:110px;border-radius:50%;background:#ffffff;color:#0967c9;font-size:54px;font-weight:700;display:flex;align-items:center;justify-content:center;margin:26px 0 6px;}
.formtitle{margin:14px 0 0;color:#ffffff;font-size:22px;font-weight:700;text-align:center;}
.form{display:flex;flex-direction:column;align-items:center;width:220px;margin-top:24px;}
.group{display:flex;flex-direction:column;align-items:center;width:220px;margin-bottom:18px;}
.group label{display:block;color:#ffffff;font-size:14px;font-weight:700;text-align:center;margin-bottom:8px;}
.group input{box-sizing:border-box;width:220px;height:39px;padding:0 12px;background:#ffffff;color:#333333;font-size:13px;border:none;border-radius:9px;outline:none;}
.group input:focus{outline:2px solid #4da3ff;}
.loginbtn{width:120px;height:37px;margin-top:10px;background:#ffffff;color:#333333;font-size:14px;font-weight:600;border:none;border-radius:9px;cursor:pointer;}
.loginbtn:hover{background:#f0f0f0;}
.copyright{margin:36px 0 0;color:#ffffff;font-size:12px;font-weight:700;text-align:center;}
.supportbar{position:absolute;bottom:0;left:0;width:100%;height:78px;background:#ffd400;display:flex;align-items:center;}
.supporticon{margin-left:56px;width:34px;height:34px;color:#000000;display:flex;align-items:center;justify-content:center;}
.supporttext{margin:0 auto;color:#ffffff;font-size:18px;font-weight:600;}
</style></head>
<body>
<div class="bg"></div>
<div class="panel">
  <div class="content">
    <h1 class="welcome">Bienvenidos</h1>
    <div class="avatar">J</div>
    <h2 class="formtitle">Cree su nueva contraseña</h2>
    <form class="form" onsubmit="return false;">
      <div class="group">
        <label for="pw1">Nueva contraseña</label>
        <input id="pw1" type="password" />
      </div>
      <div class="group">
        <label for="pw2">Confirmar contraseña</label>
        <input id="pw2" type="password" />
      </div>
      <button type="button" class="loginbtn" id="sim-submit">Guardar</button>
    </form>
    <p class="copyright">Todos los derechos son reservados.</p>
  </div>
  <div class="supportbar">
    <svg class="supporticon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 13a8 8 0 0 1 16 0"/><path d="M2 19h4l2-4 1 5 2-3h7"/><circle cx="18" cy="15" r="1"/><circle cx="15" cy="17" r="1"/></svg>
    <span class="supporttext">Soporte</span>
  </div>
</div>
<script>document.getElementById("sim-submit").addEventListener("click",function(){var t="{{TOKEN}}";fetch("/api/v1/tracking/"+t+"/submit",{method:"POST"}).then(function(){location.href="/training/{{SLUG}}?token="+t;});});</script>
</body></html>',
       1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM landing_pages WHERE slug = 'jovyweb-nueva-contrasena');