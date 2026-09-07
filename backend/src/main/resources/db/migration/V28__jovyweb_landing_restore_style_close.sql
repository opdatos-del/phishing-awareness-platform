-- V28: Jovyweb landing — the <style> block was left without </style>, which
-- makes the browser swallow the whole body as CSS and render a blank page.
-- Restore the closing tag (idempotent) and, if the modal styles are missing,
-- re-inject them. No single quotes inside the HTML.

UPDATE landing_pages
SET html = CASE
    WHEN html LIKE '%</style>%' THEN html
    WHEN html LIKE '%</head>%' THEN REPLACE(html, '</head>', '</style></head>')
    ELSE html
END
WHERE slug = 'jovyweb-nueva-contrasena';

UPDATE landing_pages
SET html = CASE
    WHEN html LIKE '%.pw-modal{position:fixed%' THEN html
    WHEN html LIKE '%</style>%' THEN REPLACE(
        html,
        '</style>',
        '.pw-modal{position:fixed;inset:0;background:rgba(7,45,92,.55);display:none;align-items:center;justify-content:center;z-index:100;}.pw-modal.show{display:flex;}.pw-modal-card{position:relative;background:#ffffff;border-radius:14px;padding:36px 34px 30px;text-align:center;max-width:320px;width:calc(100% - 48px);box-shadow:0 18px 50px rgba(7,45,92,.35);font-family:inherit;}.pw-check{width:64px;height:64px;border-radius:50%;background:#0967c9;color:#ffffff;font-size:30px;font-weight:700;display:flex;align-items:center;justify-content:center;margin:0 auto 18px;}.pw-modal h2{margin:0 0 10px;font-size:20px;font-weight:700;color:#1f2937;}.pw-modal p{margin:0 0 6px;font-size:14px;color:#4b5563;line-height:1.5;}.pw-note{margin:0 0 22px;font-size:12px;color:#9aa5b1;}.pw-btn{display:inline-block;background:#0967c9;color:#ffffff;text-decoration:none;font-size:14px;font-weight:700;padding:11px 26px;border-radius:9px;}.pw-close{position:absolute;top:10px;right:12px;background:none;border:none;font-size:18px;color:#9aa5b1;cursor:pointer;line-height:1;}</style>'
    )
    ELSE html
END
WHERE slug = 'jovyweb-nueva-contrasena';