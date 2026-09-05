-- V20: Rebuild the Jovyweb landing as a faithful clone of the real login at
-- jovyweb/frontend/src/app/features/login (login.component.html + .css).
-- Real assets (login-background.webp, nino-jovy.webp) are served from
-- /assets/images/ via frontend/public. Adapted text: two password fields and
-- "Cree su nueva contraseña" instead of username/password + "Ingrese".
-- DECORATIVE LANDING ONLY: no credential capture. Guard button registers the
-- submit event and redirects to training. Placeholders: {{TOKEN}}, {{SLUG}}.
-- No single quotes inside the HTML (CSS/JS use double quotes only).

UPDATE landing_pages SET
  html = '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;700&display=swap" rel="stylesheet">
<title>Jovyweb - Cree su nueva contraseña</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
.login-page{position:relative;width:100vw;height:100vh;overflow:hidden;font-family:"Montserrat",Arial,Helvetica,sans-serif;background-image:url("/assets/images/login-background.webp");background-size:cover;background-position:center;background-repeat:no-repeat;}
.login-panel{position:absolute;top:0;right:35px;width:410px;height:100vh;background-color:#0967c9;border-radius:0;box-shadow:none;display:flex;flex-direction:column;align-items:center;}
.login-content{display:flex;flex-direction:column;align-items:center;width:100%;padding-bottom:90px;}
.welcome-title{margin:42px 0 0;color:#ffffff;font-size:29px;font-weight:700;text-align:center;}
.mascot{width:200px;height:auto;object-fit:contain;margin-top:18px;}
.login-title{margin:18px 0 0;color:#ffffff;font-size:24px;font-weight:700;text-align:center;}
.login-form{display:flex;flex-direction:column;align-items:center;width:220px;margin-top:24px;}
.form-group{display:flex;flex-direction:column;align-items:center;width:220px;margin-bottom:18px;}
.form-group label{display:block;color:#ffffff;font-size:14px;font-weight:700;text-align:center;margin-bottom:8px;}
.form-group input{box-sizing:border-box;width:220px;height:39px;padding:0 12px;background:#ffffff;color:#333333;font-size:13px;border:none;border-radius:9px;outline:none;}
.form-group input:focus{outline:2px solid #4da3ff;}
.password-wrapper{position:relative;width:220px;}
.password-wrapper input{padding-right:34px;}
.toggle-password{position:absolute;top:50%;right:9px;transform:translateY(-50%);display:flex;align-items:center;justify-content:center;padding:0;margin:0;background:none;border:none;cursor:pointer;color:#8a8a8a;}
.toggle-password svg{width:18px;height:18px;display:block;}
.login-button{width:90px;height:37px;margin-top:22px;background:#ffffff;color:#333333;font-size:14px;font-weight:600;border:none;border-radius:9px;cursor:pointer;transition:background-color .15s ease;}
.login-button:hover{background-color:#f0f0f0;}
.copyright{margin:40px 0 0;color:#ffffff;font-size:12px;font-weight:700;text-align:center;}
.support-bar{position:absolute;bottom:0;left:0;width:100%;height:78px;background-color:#ffd400;border-radius:0;display:flex;align-items:center;}
.support-icon{margin-left:56px;width:34px;height:34px;color:#000000;display:flex;align-items:center;justify-content:center;}
.support-bar span{margin:0 auto;color:#ffffff;font-size:18px;font-weight:600;}
@media(max-width:1024px){.login-panel{width:380px;right:0;}}
@media(max-width:768px){.login-panel{width:100%;right:0;}.welcome-title{margin-top:30px;font-size:26px;}.mascot{width:150px;margin-top:14px;}.login-title{font-size:22px;}.support-bar{height:72px;}}
@media(max-height:700px){.welcome-title{margin-top:16px;font-size:24px;}.mascot{width:110px;margin-top:8px;}.login-title{font-size:20px;margin-top:8px;}.login-form{margin-top:12px;}.form-group{margin-bottom:10px;}.login-button{margin-top:10px;}.copyright{margin-top:18px;}}
</style></head>
<body>
<div class="login-page">
  <div class="login-panel">
    <div class="login-content">
      <h1 class="welcome-title">Bienvenidos</h1>
      <img src="/assets/images/nino-jovy.webp" class="mascot" alt="Bienvenido" />
      <h2 class="login-title">Cree su nueva contraseña</h2>
      <form class="login-form" onsubmit="return false;">
        <div class="form-group">
          <label for="pw1">Nueva contraseña</label>
          <div class="password-wrapper">
            <input id="pw1" type="password" />
            <button type="button" class="toggle-password" data-target="pw1"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7-10-7-10-7z"/><circle cx="12" cy="12" r="3"/></svg></button>
          </div>
        </div>
        <div class="form-group">
          <label for="pw2">Confirmar contraseña</label>
          <div class="password-wrapper">
            <input id="pw2" type="password" />
            <button type="button" class="toggle-password" data-target="pw2"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7-10-7-10-7z"/><circle cx="12" cy="12" r="3"/></svg></button>
          </div>
        </div>
        <button type="button" class="login-button" id="sim-submit">Guardar</button>
      </form>
      <p class="copyright">Todos los derechos son reservados.</p>
    </div>
    <div class="support-bar">
      <svg class="support-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 13a8 8 0 0 1 16 0"/><path d="M2 19h4l2-4 1 5 2-3h7"/><circle cx="18" cy="15" r="1"/><circle cx="15" cy="17" r="1"/></svg>
      <span>Soporte</span>
    </div>
  </div>
</div>
<script>var toggles=document.querySelectorAll(".toggle-password");toggles.forEach(function(b){b.addEventListener("click",function(){var i=document.getElementById(b.getAttribute("data-target"));i.type=i.type==="password"?"text":"password";});});document.getElementById("sim-submit").addEventListener("click",function(){var t="{{TOKEN}}";fetch("/api/v1/tracking/"+t+"/submit",{method:"POST"}).then(function(){location.href="/training/{{SLUG}}?token="+t;});});</script>
</body></html>',
  updated_at = NOW()
WHERE slug = 'jovyweb-nueva-contrasena';