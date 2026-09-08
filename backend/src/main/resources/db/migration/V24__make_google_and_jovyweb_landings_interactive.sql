-- V24: Add realistic interaction to Google and Jovyweb landings.
-- Inputs remain decorative and are never sent or stored.

UPDATE landing_pages
SET html = '<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Inicia sesion - Cuentas de Google</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{font-family:Roboto,Arial,sans-serif;background:#fff;display:flex;align-items:center;justify-content:center;min-height:100vh;color:#202124;}
.card{width:100%;max-width:448px;border:1px solid #dadce0;border-radius:8px;padding:48px 40px 36px;}
.brand{margin:0 auto 16px;text-align:center;}
h1{font-size:24px;font-weight:400;text-align:center;margin:0 0 8px;}
.sub{font-size:16px;color:#5f6368;text-align:center;margin:0 0 32px;}
.step{display:none;}
.step.active{display:block;}
.field{margin:0 0 20px;}
.label{font-size:13px;margin:0 0 6px;color:#202124;display:block;}
.input{width:100%;height:48px;border:1px solid #dadce0;border-radius:4px;padding:0 12px;font-size:15px;color:#202124;outline:none;}
.input:focus{border:2px solid #1a73e8;padding:0 11px;}
.hint{font-size:13px;color:#5f6368;margin-top:8px;line-height:1.4;}
.next{margin-top:24px;display:flex;justify-content:flex-end;gap:10px;}
.btn{background:#1a73e8;color:#fff;border:none;border-radius:4px;padding:11px 24px;font-size:15px;font-weight:500;cursor:pointer;}
.btn:disabled{background:#a8c7fa;cursor:not-allowed;}
.back{background:transparent;color:#1a73e8;border:none;border-radius:4px;padding:11px 16px;font-size:15px;cursor:pointer;}
.account{display:inline-block;background:#f1f3f4;border-radius:18px;padding:8px 12px;margin:0 0 22px;color:#3c4043;font-size:13px;}
.foot{margin-top:30px;text-align:center;font-size:12px;color:#70757a;}
</style></head>
<body><div class="card">
  <div class="brand"><svg width="45" height="45" viewBox="0 0 48 48" aria-label="Google"><path fill="#4285F4" d="M24 9.5c3.5 0 6.7 1.2 9.2 3.5l6.9-6.9C35.9 2.3 30.4 0 24 0 14.7 0 6.7 5.3 2.7 13.1l8 6.2C12.6 13.4 17.8 9.5 24 9.5z"/><path fill="#34A853" d="M46.5 24.5c0-1.6-.1-3.1-.4-4.5H24v9h12.7c-.6 3-2.3 5.5-4.9 7.2l7.9 6.1c4.6-4.3 6.8-10.6 6.8-17.8z"/><path fill="#FBBC05" d="M10.7 28.7c-.5-1.4-.7-3-.7-4.7s.3-3.2.7-4.7l-8-6.2C.9 16.4 0 20.1 0 24s.9 7.6 2.7 10.9l8-6.2z"/><path fill="#EA4335" d="M24 48c6.4 0 11.8-2.1 15.7-5.7l-7.9-6.1c-2.1 1.4-4.7 2.3-7.8 2.3-6.2 0-11.4-4-13.3-9.4l-8 6.2C6.7 42.7 14.7 48 24 48z"/></svg></div>
  <section class="step active" id="step-email"><h1>Acceder</h1><p class="sub">para continuar a Gmail</p><div class="field"><label class="label" for="google-email">Correo electronico o telefono</label><input class="input" id="google-email" type="email" autocomplete="off" placeholder="Correo electronico o telefono"></div><div class="next"><button class="btn" id="email-next" type="button" disabled>Siguiente</button></div></section>
  <section class="step" id="step-password"><h1>Te damos la bienvenida</h1><p class="sub"><span class="account" id="account-label"></span></p><div class="field"><label class="label" for="google-password">Introduce tu contrasena</label><input class="input" id="google-password" type="password" autocomplete="off"></div><p class="hint">Usa la contrasena de tu cuenta para continuar.</p><div class="next"><button class="back" id="password-back" type="button">Atras</button><button class="btn" id="password-next" type="button" disabled>Siguiente</button></div></section>
  <section class="step" id="step-confirm"><h1>Verifica tu cuenta</h1><p class="sub">Confirma la informacion para continuar con el documento compartido.</p><div class="next"><button class="back" id="confirm-back" type="button">Atras</button><button class="btn" id="sim-submit" type="button">Continuar</button></div></section>
  <div class="foot">Ayuda · Privacidad · Terminos</div>
</div>
<script>(function(){var email=document.getElementById("google-email"),password=document.getElementById("google-password"),emailNext=document.getElementById("email-next"),passwordNext=document.getElementById("password-next"),account=document.getElementById("account-label"),emailStep=document.getElementById("step-email"),passwordStep=document.getElementById("step-password"),confirmStep=document.getElementById("step-confirm");function refresh(){emailNext.disabled=!email.value.trim();passwordNext.disabled=!password.value.trim();}function show(step){emailStep.classList.remove("active");passwordStep.classList.remove("active");confirmStep.classList.remove("active");step.classList.add("active");}email.addEventListener("input",refresh);password.addEventListener("input",refresh);emailNext.addEventListener("click",function(){account.textContent=email.value.trim();show(passwordStep);});document.getElementById("password-back").addEventListener("click",function(){show(emailStep);});passwordNext.addEventListener("click",function(){show(confirmStep);});document.getElementById("confirm-back").addEventListener("click",function(){show(passwordStep);});document.getElementById("sim-submit").addEventListener("click",function(){var t="{{TOKEN}}";fetch("/api/v1/tracking/"+t+"/submit",{method:"POST"}).then(function(){location.href="/training/{{SLUG}}?token="+t;});});refresh();})();</script>
</body></html>',
  updated_at = NOW()
WHERE slug = 'google-login';

UPDATE landing_pages
SET html = REPLACE(
    html,
    '<button type="button" class="login-button" id="sim-submit">Guardar</button>',
    '<button type="button" class="login-button" id="sim-submit" disabled>Guardar</button>'
)
WHERE slug = 'jovyweb-nueva-contrasena';

UPDATE landing_pages
SET html = REPLACE(
    html,
    '.login-button:hover{background-color:#f0f0f0;}',
    '.login-button:hover{background-color:#f0f0f0;}.login-button:disabled{background-color:#d9d9d9;color:#8a8a8a;cursor:not-allowed;}'
)
WHERE slug = 'jovyweb-nueva-contrasena';

UPDATE landing_pages
SET html = REPLACE(
    html,
    'var toggles=document.querySelectorAll(".toggle-password");toggles.forEach(function(b){b.addEventListener("click",function(){var i=document.getElementById(b.getAttribute("data-target"));i.type=i.type==="password"?"text":"password";});});document.getElementById("sim-submit").addEventListener("click",function(){',
    'var toggles=document.querySelectorAll(".toggle-password"),pw1=document.getElementById("pw1"),pw2=document.getElementById("pw2"),submit=document.getElementById("sim-submit");function refresh(){submit.disabled=!pw1.value.trim()||!pw2.value.trim();}toggles.forEach(function(b){b.addEventListener("click",function(){var i=document.getElementById(b.getAttribute("data-target"));i.type=i.type==="password"?"text":"password";});});pw1.addEventListener("input",refresh);pw2.addEventListener("input",refresh);refresh();submit.addEventListener("click",function(){'
)
WHERE slug = 'jovyweb-nueva-contrasena';
