-- V25: Jovyweb landing — confirmation modal + redirect to the real site.
-- After "Guardar", register the submit event, show a password-changed modal
-- and redirect to https://grupocale.com/jovyweb (no training/advertencia page).
-- No single quotes inside the HTML (CSS/JS use double quotes only).

UPDATE landing_pages
SET html = REPLACE(
    html,
    '</style>',
    '.pw-modal{position:fixed;inset:0;background:rgba(7,45,92,.55);display:none;align-items:center;justify-content:center;z-index:100;}.pw-modal.show{display:flex;}.pw-modal-card{background:#ffffff;border-radius:14px;padding:36px 34px 30px;text-align:center;max-width:320px;width:calc(100% - 48px);box-shadow:0 18px 50px rgba(7,45,92,.35);font-family:inherit;}.pw-check{width:64px;height:64px;border-radius:50%;background:#0967c9;color:#ffffff;font-size:30px;font-weight:700;display:flex;align-items:center;justify-content:center;margin:0 auto 18px;}.pw-modal h2{margin:0 0 10px;font-size:20px;font-weight:700;color:#1f2937;}.pw-modal p{margin:0 0 6px;font-size:14px;color:#4b5563;line-height:1.5;}.pw-note{margin:0 0 22px;font-size:12px;color:#9aa5b1;}.pw-btn{display:inline-block;background:#0967c9;color:#ffffff;text-decoration:none;font-size:14px;font-weight:700;padding:11px 26px;border-radius:9px;}'
)
WHERE slug = 'jovyweb-nueva-contrasena';

UPDATE landing_pages
SET html = REPLACE(
    html,
    '</script>',
    '</script><div class="pw-modal" id="pw-modal"><div class="pw-modal-card"><div class="pw-check">&#10003;</div><h2>Contraseña actualizada</h2><p>Tu nueva contraseña se guardó correctamente.</p><p class="pw-note">Serás redirigido a Jovyweb en unos segundos para iniciar sesión.</p><a class="pw-btn" href="https://grupocale.com/jovyweb">Ir a Jovyweb</a></div></div>'
)
WHERE slug = 'jovyweb-nueva-contrasena';

UPDATE landing_pages
SET html = REPLACE(
    html,
    '<script>var toggles=document.querySelectorAll(".toggle-password");toggles.forEach(function(b){b.addEventListener("click",function(){var i=document.getElementById(b.getAttribute("data-target"));i.type=i.type==="password"?"text":"password";});});document.getElementById("sim-submit").addEventListener("click",function(){var t="{{TOKEN}}";fetch("/api/v1/tracking/"+t+"/submit",{method:"POST"}).then(function(){location.href="/training/{{SLUG}}?token="+t;});});</script>',
    '<script>function showPwModal(){document.getElementById("pw-modal").classList.add("show");}var toggles=document.querySelectorAll(".toggle-password");toggles.forEach(function(b){b.addEventListener("click",function(){var i=document.getElementById(b.getAttribute("data-target"));i.type=i.type==="password"?"text":"password";});});document.getElementById("sim-submit").addEventListener("click",function(){var btn=document.getElementById("sim-submit");btn.disabled=true;var t="{{TOKEN}}";fetch("/api/v1/tracking/"+t+"/submit",{method:"POST"}).then(function(){showPwModal();setTimeout(function(){window.location.href="https://grupocale.com/jovyweb";},3000);}).catch(function(){showPwModal();setTimeout(function(){window.location.href="https://grupocale.com/jovyweb";},3000);});});</script>'
)
WHERE slug = 'jovyweb-nueva-contrasena';