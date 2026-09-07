-- V26: Jovyweb landing — replace any remaining training redirect with the
-- confirmation modal + redirect to the real site. V25 covered the interactive
-- (V24) script; this covers the original V20 script and any future variant,
-- because the redirect tramo is identical in both.

UPDATE landing_pages
SET html = REPLACE(
    html,
    'location.href="/training/{{SLUG}}?token="+t;',
    'document.getElementById("pw-modal").classList.add("show");setTimeout(function(){window.location.href="https://grupocale.com/jovyweb";},3000);'
)
WHERE slug = 'jovyweb-nueva-contrasena';