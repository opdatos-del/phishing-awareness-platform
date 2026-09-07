-- V27: Jovyweb landing — add "current password" field; modal redirects to the
-- real site when the user closes it (no auto-redirect timer).
-- No single quotes inside the HTML (CSS/JS use double quotes only).

UPDATE landing_pages
SET html = REPLACE(
    REPLACE(
    REPLACE(
    REPLACE(
    REPLACE(
        html,
        -- 1) current-password form group (eye toggle included)
        '<label for="pw1">Nueva contraseña</label>',
        '<label for="pw-current">Contraseña actual</label>
          <div class="password-wrapper">
            <input id="pw-current" type="password" />
            <button type="button" class="toggle-password" data-target="pw-current"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7-10-7-10-7z"/><circle cx="12" cy="12" r="3"/></svg></button>
          </div>
        </div>
        <div class="form-group">
          <label for="pw1">Nueva contraseña</label>'
    ),
        -- 2) validation includes pw-current
        'var toggles=document.querySelectorAll(".toggle-password"),pw1=document.getElementById("pw1"),pw2=document.getElementById("pw2"),submit=document.getElementById("sim-submit");function refresh(){submit.disabled=!pw1.value.trim()||!pw2.value.trim();}toggles.forEach(function(b){b.addEventListener("click",function(){var i=document.getElementById(b.getAttribute("data-target"));i.type=i.type==="password"?"text":"password";});});pw1.addEventListener("input",refresh);pw2.addEventListener("input",refresh);refresh();',
        'var toggles=document.querySelectorAll(".toggle-password"),pwcurrent=document.getElementById("pw-current"),pw1=document.getElementById("pw1"),pw2=document.getElementById("pw2"),submit=document.getElementById("sim-submit");function refresh(){submit.disabled=!pwcurrent.value.trim()||!pw1.value.trim()||!pw2.value.trim();}toggles.forEach(function(b){b.addEventListener("click",function(){var i=document.getElementById(b.getAttribute("data-target"));i.type=i.type==="password"?"text":"password";});});pwcurrent.addEventListener("input",refresh);pw1.addEventListener("input",refresh);pw2.addEventListener("input",refresh);refresh();'
    ),
        -- 3) submit -> show modal only; redirect happens on modal close
        'submit.addEventListener("click",function(){var t="{{TOKEN}}";fetch("/api/v1/tracking/"+t+"/submit",{method:"POST"}).then(function(){document.getElementById("pw-modal").classList.add("show");setTimeout(function(){window.location.href="https://grupocale.com/jovyweb";},3000);});})',
        'submit.addEventListener("click",function(){var t="{{TOKEN}}";fetch("/api/v1/tracking/"+t+"/submit",{method:"POST"}).then(function(){document.getElementById("pw-modal").classList.add("show");});});document.getElementById("pw-close").addEventListener("click",function(){window.location.href="https://grupocale.com/jovyweb";});var pwModal=document.getElementById("pw-modal");pwModal.addEventListener("click",function(e){if(e.target===pwModal){window.location.href="https://grupocale.com/jovyweb";}});'
    ),
        -- 4) close button in the modal card
        '<div class="pw-check">&#10003;</div>',
        '<button type="button" class="pw-close" id="pw-close" aria-label="Cerrar">&#10005;</button><div class="pw-check">&#10003;</div>'
    ),
        -- 5) card position + pw-close style
        '.pw-modal-card{background:#ffffff;border-radius:14px;padding:36px 34px 30px;text-align:center;max-width:320px;width:calc(100% - 48px);box-shadow:0 18px 50px rgba(7,45,92,.35);font-family:inherit;}',
        '.pw-modal-card{background:#ffffff;border-radius:14px;padding:36px 34px 30px;text-align:center;max-width:320px;width:calc(100% - 48px);box-shadow:0 18px 50px rgba(7,45,92,.35);font-family:inherit;position:relative;}.pw-close{position:absolute;top:10px;right:12px;background:none;border:none;font-size:18px;color:#9aa5b1;cursor:pointer;line-height:1;}'
    )
WHERE slug = 'jovyweb-nueva-contrasena';

UPDATE landing_pages
SET html = REPLACE(
    html,
    'Serás redirigido a Jovyweb en unos segundos para iniciar sesión.</p>',
    'Al cerrar esta ventana serás redirigido a Jovyweb para iniciar sesión.</p>'
)
WHERE slug = 'jovyweb-nueva-contrasena';