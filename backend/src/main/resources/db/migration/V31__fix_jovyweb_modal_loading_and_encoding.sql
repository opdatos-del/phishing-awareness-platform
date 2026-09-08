-- V31: Finish the Jovyweb loading state and normalize modal copy.

UPDATE landing_pages
SET html = REGEXP_REPLACE(
    html,
    '<div class="pw-modal" id="pw-modal">.*</div></div>',
    '<div class="pw-modal" id="pw-modal"><div class="pw-modal-card"><button type="button" class="pw-close" id="pw-close" aria-label="Cerrar">&#10005;</button><div class="pw-loading" id="pw-loading"><span class="pw-spinner"></span><span>Cambiando contrase&#241;a, espere un momento...</span></div><div class="pw-check" style="display:none;">&#10003;</div><h2>Contrase&#241;a actualizada</h2><p>La contrase&#241;a fue actualizada correctamente.</p><p class="pw-note">Esta fue una simulaci&#243;n de phishing. Tu contrase&#241;a real no fue guardada.</p><a class="pw-btn" href="/training/{{SLUG}}?token={{TOKEN}}">Ver aprendizaje</a></div></div>'
)
WHERE slug = 'jovyweb-nueva-contrasena'
  AND html LIKE '%<div class="pw-modal" id="pw-modal">%';

UPDATE landing_pages
SET html = REPLACE(
    html,
    'document.getElementById("pw-modal").classList.add("show");',
    'document.getElementById("pw-modal").classList.add("show");setTimeout(function(){document.getElementById("pw-loading").style.display="none";document.querySelector(".pw-check").style.display="flex";},1200);'
)
WHERE slug = 'jovyweb-nueva-contrasena';
