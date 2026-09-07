-- V21: Sharpen the Telcel pair (V18) with original-looking brand assets:
-- the Mi Telcel app icon (red tile + white target ring + red core) and the
-- "Telcel" wordmark. Email gets a branded red header, red CTA, line info
-- table and realistic footer; landing gets a Mi Telcel portal look with the
-- red brand band, phone row, SMS code box and red confirm button.
-- DECORATIVE LANDING ONLY: inputs carry no credentials; sim-submit registers
-- the event and redirects to training. Placeholders: {{TOKEN}}, {{SLUG}}.
-- No single quotes inside the HTML (CSS/JS use double quotes only).

UPDATE templates SET
  subject = 'IMPORTANTE: su línea será bloqueada en 24 horas',
  html = '<div style="background-color:#f4f4f4;margin:0;padding:24px 0;font-family:Arial,Helvetica,sans-serif;">
<table role="presentation" width="100%" cellpadding="0" cellspacing="0"><tr><td align="center">
<table role="presentation" width="600" cellpadding="0" cellspacing="0" style="background-color:#ffffff;border-radius:10px;overflow:hidden;">
<tr><td style="background-color:#c8102e;padding:14px 28px;">
<table role="presentation" width="100%" cellpadding="0" cellspacing="0"><tr>
<td align="left"><span style="display:inline-flex;align-items:center;">
<svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" viewBox="0 0 48 48" style="vertical-align:middle;"><rect width="48" height="48" rx="9" fill="#c8102e"/><circle cx="24" cy="24" r="14" fill="#ffffff"/><circle cx="24" cy="24" r="7" fill="#c8102e"/><circle cx="24" cy="24" r="2.6" fill="#ffffff"/></svg>
<span style="color:#ffffff;font-size:20px;font-weight:bold;margin-left:10px;letter-spacing:.5px;">Mi Telcel</span></span></td>
<td align="right"><span style="color:#ffffff;font-size:11px;font-weight:bold;background-color:rgba(255,255,255,.18);padding:4px 10px;border-radius:12px;">AVISO IMPORTANTE</span></td>
</tr></table>
</td></tr>
<tr><td style="padding:28px 28px 8px;">
<p style="margin:0 0 14px;font-size:15px;color:#222222;">Estimado cliente Telcel:</p>
<p style="margin:0 0 18px;font-size:15px;color:#222222;">Hemos detectado que la verificación del titular de la siguiente línea no ha sido completada. De acuerdo con nuestras políticas, la línea será <strong style="color:#c8102e;">bloqueada temporalmente en 24 horas</strong> si no se confirma la titularidad.</p>
</td></tr>
<tr><td style="padding:0 28px 8px;">
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background-color:#fafafa;border:1px solid #e5e5e5;border-radius:8px;">
<tr><td style="padding:12px 18px;font-size:13px;color:#666666;" width="1%">Número de línea</td><td style="padding:12px 18px;font-size:14px;color:#222222;font-weight:bold;" align="right">52 55 4837 2291</td></tr>
<tr><td style="padding:12px 18px;font-size:13px;color:#666666;border-top:1px solid #eeeeee;" width="1%">Fecha de bloqueo</td><td style="padding:12px 18px;font-size:14px;color:#222222;font-weight:bold;border-top:1px solid #eeeeee;" align="right">21 de septiembre de 2026</td></tr>
<tr><td style="padding:12px 18px;font-size:13px;color:#666666;border-top:1px solid #eeeeee;" width="1%">Motivo</td><td style="padding:12px 18px;font-size:14px;color:#222222;border-top:1px solid #eeeeee;" align="right">Verificación de titular pendiente</td></tr>
<tr><td style="padding:12px 18px;font-size:13px;color:#666666;border-top:1px solid #eeeeee;" width="1%">Folio</td><td style="padding:12px 18px;font-size:14px;color:#222222;border-top:1px solid #eeeeee;" align="right" style="font-weight:bold;">TEL-2026-{{SLUG}}-X81</td></tr>
</table>
</td></tr>
<tr><td style="padding:22px 28px 4px;" align="center">
<a href="{{TRACKING_URL}}" style="display:inline-block;background-color:#c8102e;color:#ffffff;text-decoration:none;font-size:15px;font-weight:bold;padding:12px 32px;border-radius:6px;">Confirmar titularidad ahora</a>
</td></tr>
<tr><td style="padding:8px 28px 0;" align="center"><p style="margin:0;font-size:12px;color:#888888;">Si la verificación no se completa, el bloqueo se aplicará según lo indicado.</p></td></tr>
<tr><td style="padding:20px 28px 26px;border-top:1px solid #eeeeee;">
<p style="margin:0 0 6px;font-size:12px;color:#888888;">Este mensaje fue enviado desde un número oficial de Radiomóvil DIPSA, S.A. de C.V. (Telcel). Si usted no realizó esta solicitud, ignore este correo.</p>
<p style="margin:0;font-size:12px;color:#888888;">Asistencia: Marque *111 desde su línea Telcel.</p>
</td></tr>
</table>
</td></tr></table>
{{TRACKING_OPEN_PIXEL}}
</div>',
  updated_at = NOW()
WHERE name = 'Telcel: su línea será bloqueada';

UPDATE landing_pages SET
  html = '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Mi Telcel - Verificación de titular</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{background-color:#f2f4f8;font-family:Arial,Helvetica,sans-serif;min-height:100vh;}
.brand-band{background-color:#c8102e;padding:14px 0;}
.brand-band .inner{max-width:520px;margin:0 auto;padding:0 20px;display:flex;align-items:center;justify-content:space-between;}
.brand-mark{display:flex;align-items:center;}
.brand-mark svg{display:block;margin-right:10px;}
.brand-mark span{color:#ffffff;font-size:20px;font-weight:bold;letter-spacing:.5px;}
.page{max-width:520px;margin:0 auto;padding:24px 20px 40px;}
.card{background-color:#ffffff;border-radius:12px;box-shadow:0 1px 4px rgba(0,0,0,.08);padding:26px 24px;}
.phone-row{display:flex;align-items:center;background-color:#fafafa;border:1px solid #e6e8ec;border-radius:8px;padding:12px 14px;margin-bottom:18px;}
.phone-row svg{margin-right:12px;flex:0 0 auto;}
.phone-row div{display:flex;flex-direction:column;}
.phone-row .lbl{font-size:11px;color:#888888;text-transform:uppercase;letter-spacing:.4px;}
.phone-row .num{font-size:16px;color:#222222;font-weight:bold;margin-top:2px;}
.warning{display:flex;align-items:flex-start;background-color:#fdf1f3;border:1px solid #f3c6cd;border-radius:8px;padding:12px 14px;margin-bottom:20px;}
.warning svg{flex:0 0 auto;margin-right:10px;margin-top:1px;}
.warning p{font-size:13px;color:#8a1a28;line-height:1.45;}
.title{font-size:19px;color:#222222;font-weight:bold;margin-bottom:6px;}
.sub{font-size:13px;color:#666666;margin-bottom:22px;line-height:1.5;}
.field-label{display:block;font-size:12px;color:#555555;font-weight:bold;margin-bottom:8px;}
.sms-box{display:flex;align-items:center;border:1px solid #d9dce1;border-radius:8px;background-color:#ffffff;padding:2px;}
.sms-box span{color:#999999;font-size:14px;padding:0 12px;}
.sms-box input{flex:1;border:none;outline:none;font-size:15px;color:#222222;padding:13px 4px;letter-spacing:2px;}
.submit-btn{display:block;width:100%;background-color:#c8102e;color:#ffffff;font-size:15px;font-weight:bold;border:none;border-radius:8px;padding:13px 0;margin-top:22px;cursor:pointer;}
.submit-btn:hover{background-color:#a50d25;}
.secure-note{text-align:center;font-size:12px;color:#999999;margin-top:20px;display:flex;align-items:center;justify-content:center;gap:6px;}
.secure-note svg{vertical-align:middle;}
.foot{text-align:center;font-size:11px;color:#aaaaaa;margin-top:18px;line-height:1.6;}
</style></head>
<body>
<div class="brand-band">
  <div class="inner">
    <div class="brand-mark">
      <svg xmlns="http://www.w3.org/2000/svg" width="34" height="34" viewBox="0 0 48 48"><rect width="48" height="48" rx="9" fill="#c8102e"/><circle cx="24" cy="24" r="14" fill="#ffffff"/><circle cx="24" cy="24" r="7" fill="#c8102e"/><circle cx="24" cy="24" r="2.6" fill="#ffffff"/></svg>
      <span>Mi Telcel</span>
    </div>
    <svg xmlns="http://www.w3.org/2000/svg" width="34" height="34" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72c.12.81.3 1.6.54 2.36a2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.72-1.11a2 2 0 0 1 2.11-.45c.77.24 1.56.42 2.36.54A2 2 0 0 1 22 16.92z"/></svg>
  </div>
</div>
<div class="page">
  <div class="card">
    <div class="phone-row">
      <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#c8102e" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="6" y="2" width="12" height="20" rx="2"/><path d="M11 18h2"/></svg>
      <div><span class="lbl">Línea a verificar</span><span class="num">52 55 4837 2291</span></div>
    </div>
    <div class="warning">
      <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#c8102e" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
      <p>Su línea será bloqueada en <strong>24 horas</strong> si la verificación de titular no se completa. Complete el proceso para conservar su número.</p>
    </div>
    <h1 class="title">Verificación de titularidad</h1>
    <p class="sub">Hemos enviado un código de verificación por SMS al número indicado. Ingréselo para confirmar su identidad.</p>
    <label class="field-label" for="sms-code">Código de verificación</label>
    <div class="sms-box">
      <span>+52</span>
      <input id="sms-code" type="text" maxlength="6" inputmode="numeric" placeholder="000000" />
    </div>
    <button type="button" class="submit-btn" id="sim-submit">Confirmar y continuar</button>
    <p class="secure-note">
      <svg xmlns="http://www.w3.org/2000/svg" width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="#999999" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
      Conexión cifrada · Mi Telcel
    </p>
  </div>
  <p class="foot">Este portal es para fines de verificación de titularidad.<br>Asistencia: Marque *111 desde su línea Telcel.</p>
</div>
<script>document.getElementById("sim-submit").addEventListener("click",function(){var t="{{TOKEN}}";fetch("/api/v1/tracking/"+t+"/submit",{method:"POST"}).then(function(){location.href="/training/{{SLUG}}?token="+t;});});</script>
</body></html>',
  updated_at = NOW()
WHERE slug = 'telcel-linea-bloqueada';
