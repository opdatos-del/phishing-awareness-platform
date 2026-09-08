package com.company.phishingawareness.gophish;

import java.time.Duration;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;

import com.company.phishingawareness.campaign.Campaign;
import com.company.phishingawareness.campaign.CampaignRecipient;

/** Small synchronous adapter around the GoPhish REST API.
 *
 * Provisioning is intentionally explicit: local entities remain the source of
 * truth and GoPhish is only used as the delivery engine.
 */
@Component
public class GophishClient {

    private final WebClient webClient;
    private final String apiKey;
    private final String gophishUrl;
    private final String publicUrl;
    private final String smtpHost;
    private final String smtpPort;
    private final String fromAddress;

    public GophishClient(@Value("${gophish.api-url:http://localhost:3333}") String apiUrl,
                         @Value("${gophish.api-key:}") String apiKey,
                         @Value("${gophish.url:http://localhost:8081}") String gophishUrl,
                         @Value("${tracking.public-url:http://localhost}") String publicUrl,
                         @Value("${smtp.host:localhost}") String smtpHost,
                         @Value("${smtp.port:1025}") String smtpPort,
                         @Value("${gophish.from-address:avisos@jovycandy.com}") String fromAddress) {
        this.webClient = WebClient.builder().baseUrl(apiUrl).build();
        this.apiKey = apiKey;
        this.gophishUrl = trimTrailingSlash(gophishUrl);
        this.publicUrl = trimTrailingSlash(publicUrl);
        this.smtpHost = smtpHost;
        this.smtpPort = smtpPort;
        this.fromAddress = fromAddress;
    }

    public boolean isConfigured() {
        return apiKey != null && !apiKey.isBlank() && !"CHANGE_ME".equalsIgnoreCase(apiKey.trim());
    }

    public ProvisionedCampaign provision(Campaign campaign, List<CampaignRecipient> recipients,
                                         java.time.LocalDateTime scheduledAt, Integer durationMinutes) {
        requireConfigured();

        String suffix = "paware-" + campaign.getId();
        String gophishHtml = toGophishTemplate(campaign.getTemplate().getHtml());
        Map<String, Object> template = post("/api/templates/", Map.of(
                "name", suffix + "-template",
                "subject", campaign.getTemplate().getSubject(),
                "html", gophishHtml,
                "text", stripHtml(gophishHtml)
        ));

        String pageHtml = "<!doctype html><html><body><p>Loading...</p><script>"
                + "window.location.replace(\"" + htmlAttr(publicUrl) + "/landing/"
                + htmlAttr(campaign.getLandingPage().getSlug())
                + "?token={{.Position}}\");</script></body></html>";
        Map<String, Object> page = post("/api/pages/", Map.of(
                "name", suffix + "-page",
                "html", pageHtml,
                "capture_credentials", false,
                "capture_passwords", false
        ));

        Map<String, Object> smtp = post("/api/smtp/", Map.of(
                "name", suffix + "-smtp",
                "host", smtpHost + ":" + smtpPort,
                "from_address", fromAddress,
                "interface_type", "SMTP",
                "ignore_cert_errors", true
        ));

        List<Map<String, Object>> targets = recipients.stream().map(cr -> {
            String[] name = splitName(cr.getRecipient().getName());
            Map<String, Object> target = new java.util.HashMap<>();
            target.put("first_name", name[0]);
            target.put("last_name", name[1]);
            target.put("email", cr.getRecipient().getEmail());
            // Position is a supported target field and gives the page
            // a stable local token without sending credentials anywhere.
            target.put("position", cr.getTrackingToken());
            return target;
        }).toList();
        Map<String, Object> group = post("/api/groups/", Map.of(
                "name", suffix + "-group",
                "targets", targets
        ));

        Map<String, Object> campaignPayload = new java.util.HashMap<>();
        campaignPayload.put("name", campaign.getName() + " (Paware)");
        campaignPayload.put("template", Map.of("name", template.get("name")));
        campaignPayload.put("page", Map.of("name", page.get("name")));
        campaignPayload.put("smtp", Map.of("name", smtp.get("name")));
        campaignPayload.put("groups", List.of(Map.of("name", group.get("name"))));
        campaignPayload.put("url", gophishUrl);
        if (scheduledAt != null && scheduledAt.isAfter(java.time.LocalDateTime.now())) {
            campaignPayload.put("launch_date", goPhishDate(scheduledAt));
        }
        if (durationMinutes != null) {
            java.time.LocalDateTime launchAt = scheduledAt != null && scheduledAt.isAfter(java.time.LocalDateTime.now())
                    ? scheduledAt : java.time.LocalDateTime.now().plusSeconds(5);
            campaignPayload.put("launch_date", goPhishDate(launchAt));
            campaignPayload.put("send_by_date", goPhishDate(launchAt.plusMinutes(durationMinutes)));
        }
        Map<String, Object> gophishCampaign = post("/api/campaigns/", campaignPayload);

        return new ProvisionedCampaign(asLong(gophishCampaign.get("id")));
    }

    public void launch(ProvisionedCampaign campaign, java.time.LocalDateTime scheduledAt) {
        requireConfigured();
        // GoPhish launches on create. A scheduled campaign is created with a
        // launch date by the caller in production; this method is retained for
        // API symmetry and future providers.
        if (campaign.id() == null) {
            throw new IllegalStateException("GoPhish did not return a campaign id");
        }
    }

    /** Returns the raw results list for a GoPhish campaign id.
     *
     *  Results carry open/click timestamps that GoPhish does not push via
     *  webhooks; a scheduled poller uses this to fill the local funnel.
     */
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> campaignResults(Long gophishCampaignId) {
        requireConfigured();
        Map<String, Object> body = webClient.get()
                .uri(uri -> uri.path("/api/campaigns/" + gophishCampaignId).queryParam("api_key", apiKey).build())
                .header("Authorization", apiKey)
                .retrieve()
                .bodyToMono(Map.class)
                .block(Duration.ofSeconds(20));
        if (body == null) throw new IllegalStateException("Empty response from GoPhish at /api/campaigns/" + gophishCampaignId);
        Object results = body.get("results");
        if (!(results instanceof List<?> list)) return List.of();
        return (List<Map<String, Object>>) (List<?>) list;
    }

    public void deleteCampaign(Long gophishCampaignId) {
        if (!isConfigured() || gophishCampaignId == null) return;
        webClient.delete()
                .uri(uri -> uri.path("/api/campaigns/" + gophishCampaignId).queryParam("api_key", apiKey).build())
                .header("Authorization", apiKey)
                .retrieve()
                .toBodilessEntity()
                .block(Duration.ofSeconds(20));
    }

    private Map<String, Object> post(String path, Object payload) {
        Map<?, ?> body = webClient.post()
                .uri(uri -> uri.path(path).queryParam("api_key", apiKey).build())
                .header("Authorization", apiKey)
                .contentType(MediaType.APPLICATION_JSON)
                .bodyValue(payload)
                .retrieve()
                .bodyToMono(Map.class)
                .block(Duration.ofSeconds(20));
        if (body == null) throw new IllegalStateException("Empty response from GoPhish at " + path);
        @SuppressWarnings("unchecked") Map<String, Object> result = (Map<String, Object>) body;
        return result;
    }

    private void requireConfigured() {
        if (!isConfigured()) {
            throw new IllegalStateException("GoPhish integration is not configured. Set GOPHISH_API_KEY first.");
        }
    }

    private String toGophishTemplate(String html) {
        // Point tracking at the local funnel: target position carries the
        // local tracking token, so opens/clicks are recorded in our DB even
        // though this GoPhish build does not expose result-reading endpoints.
        return html.replace("{{TRACKING_URL}}", publicUrl + "/t/{{.Position}}")
                .replace("{{TRACKING_OPEN_PIXEL}}", publicUrl + "/api/v1/tracking/{{.Position}}/open")
                // Landing-only placeholders must never reach GoPhish's template parser.
                .replace("{{TOKEN}}", "")
                .replace("{{SLUG}}", "");
    }

    private static String[] splitName(String fullName) {
        String value = fullName == null ? "Employee" : fullName.trim();
        int space = value.indexOf(' ');
        return space < 0 ? new String[] {value, ""}
                : new String[] {value.substring(0, space), value.substring(space + 1)};
    }

    private static String trimTrailingSlash(String value) {
        return value == null ? "" : value.replaceFirst("/$", "");
    }

    private static String htmlAttr(String value) {
        return value.replace("&", "&amp;").replace("\"", "&quot;");
    }

    /** Strip HTML tags to produce a rough plain-text version for multipart emails. */
    private static String stripHtml(String html) {
        if (html == null) return "";
        return html.replaceAll("<style[\\s\\S]*?</style>", "")
                   .replaceAll("<script[\\s\\S]*?</script>", "")
                   .replaceAll("<[^>]+>", " ")
                   .replaceAll("&nbsp;", " ")
                   .replaceAll("&amp;", "&")
                   .replaceAll("\\s+", " ")
                   .trim();
    }

    private static Long asLong(Object value) {
        if (value instanceof Number number) return number.longValue();
        return value == null ? null : Long.valueOf(value.toString());
    }

    private static String goPhishDate(java.time.LocalDateTime value) {
        return value.atOffset(ZoneOffset.UTC).format(DateTimeFormatter.ISO_OFFSET_DATE_TIME);
    }

    public record ProvisionedCampaign(Long id) {}
}
