-- Remove legacy report-link blocks from already-seeded email HTML.  The
-- tracking report endpoints remain available for integrations that call them.
UPDATE templates
SET html = REGEXP_REPLACE(
        html,
        '<p[^>]*>[[:space:]]*<a[^>]*\\{\\{TRACKING_REPORT_URL\\}\\}[^>]*>[^<]*</a>[[:space:]]*</p>[[:space:]]*',
        ''
    )
WHERE html LIKE '%{{TRACKING_REPORT_URL}}%';

-- Ensure an old custom template can never expose the removed placeholder.
UPDATE templates
SET html = REPLACE(html, '{{TRACKING_REPORT_URL}}', '')
WHERE html LIKE '%{{TRACKING_REPORT_URL}}%';
