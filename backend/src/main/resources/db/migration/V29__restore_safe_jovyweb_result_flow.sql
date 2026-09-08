-- V29: Remove external Jovyweb redirects and restore the safe training result.
-- Inputs remain decorative; submitted values are never stored.

UPDATE landing_pages
SET html = REPLACE(
    html,
    'https://grupocale.com/jovyweb',
    '/training/{{SLUG}}?token={{TOKEN}}'
)
WHERE slug = 'jovyweb-nueva-contrasena';

UPDATE landing_pages
SET html = REPLACE(
    html,
    'ContraseÃ±a actualizada',
    'Simulacion completada'
)
WHERE slug = 'jovyweb-nueva-contrasena';

UPDATE landing_pages
SET html = REPLACE(
    html,
    'Tu nueva contraseÃ±a se guardÃ³ correctamente.',
    'Has caido en un phishing de seguridad. Tu contrasena real no fue guardada.'
)
WHERE slug = 'jovyweb-nueva-contrasena';

UPDATE landing_pages
SET html = REPLACE(
    html,
    'SerÃ¡s redirigido a Jovyweb en unos segundos para iniciar sesiÃ³n.',
    'La simulacion termino. Revisa el entrenamiento para aprender a detectar estas senales.'
)
WHERE slug = 'jovyweb-nueva-contrasena';

UPDATE landing_pages
SET html = REPLACE(
    html,
    '</style>',
    '.pw-loading{display:flex;align-items:center;justify-content:center;gap:10px;margin:0 0 18px;color:#4b5563;font-size:14px;}.pw-spinner{width:18px;height:18px;border:3px solid #dbeafe;border-top-color:#0967c9;border-radius:50%;animation:pw-spin .8s linear infinite;}@keyframes pw-spin{to{transform:rotate(360deg);}}'
)
WHERE slug = 'jovyweb-nueva-contrasena';

UPDATE landing_pages
SET html = REPLACE(
    html,
    '<div class="pw-check">&#10003;</div>',
    '<div class="pw-loading" id="pw-loading"><span class="pw-spinner"></span><span>Cambiando contrasena, espere un momento...</span></div><div class="pw-check" style="display:none;">&#10003;</div>'
)
WHERE slug = 'jovyweb-nueva-contrasena';

UPDATE landing_pages
SET html = REPLACE(
    html,
    'showPwModal();',
    'showPwModal();setTimeout(function(){document.getElementById("pw-loading").style.display="none";document.querySelector(".pw-check").style.display="flex";},1200);'
)
WHERE slug = 'jovyweb-nueva-contrasena';
