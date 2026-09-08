-- V30: Close the style tag added by V29 so the Jovyweb body renders.

UPDATE landing_pages
SET html = REPLACE(
    html,
    '@keyframes pw-spin{to{transform:rotate(360deg);}}',
    '@keyframes pw-spin{to{transform:rotate(360deg);}}</style>'
)
WHERE slug = 'jovyweb-nueva-contrasena'
  AND html LIKE '%@keyframes pw-spin%'
  AND html NOT LIKE '%</style>%';
