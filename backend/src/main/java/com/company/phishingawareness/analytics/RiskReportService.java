package com.company.phishingawareness.analytics;

import java.time.LocalDateTime;
import java.time.LocalDate;
import java.time.Duration;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.function.Predicate;

import org.springframework.stereotype.Service;

import com.company.phishingawareness.campaign.Campaign;
import com.company.phishingawareness.campaign.CampaignRecipient;
import com.company.phishingawareness.campaign.CampaignRecipientRepository;

@Service
public class RiskReportService {

    private final CampaignRecipientRepository repository;

    public RiskReportService(CampaignRecipientRepository repository) {
        this.repository = repository;
    }

    public List<RiskReportRow> findAll(Integer minScore, String level, String search) {
        Map<Long, Aggregate> aggregates = new LinkedHashMap<>();
        repository.findAllForRiskReport(Campaign.Status.DRAFT).forEach(recipient ->
            aggregates.computeIfAbsent(recipient.getRecipient().getId(), ignored -> new Aggregate(
                recipient.getRecipient().getId(), recipient.getRecipient().getName(), recipient.getRecipient().getEmail()))
                .add(recipient));

        Predicate<RiskReportRow> filter = row -> minScore == null || row.riskScore() >= minScore;
        if (level != null && !level.isBlank()) {
            String requestedLevel = level.trim().toUpperCase(Locale.ROOT);
            filter = filter.and(row -> row.riskLevel().equals(requestedLevel));
        }
        if (search != null && !search.isBlank()) {
            String requestedSearch = search.trim().toLowerCase(Locale.ROOT);
            filter = filter.and(row -> row.name().toLowerCase(Locale.ROOT).contains(requestedSearch)
                || row.email().toLowerCase(Locale.ROOT).contains(requestedSearch));
        }

        return aggregates.values().stream()
            .map(Aggregate::toRow)
            .filter(filter)
            .sorted(Comparator.comparingInt(RiskReportRow::riskScore).reversed()
                .thenComparing(RiskReportRow::email, String.CASE_INSENSITIVE_ORDER))
            .toList();
    }

    public List<TrendPoint> trend() {
        Map<LocalDate, long[]> totals = new java.util.TreeMap<>();
        repository.findAllForRiskReport(Campaign.Status.DRAFT).forEach(campaignRecipient -> {
            if (campaignRecipient.getSubmittedAt() != null) {
                totals.computeIfAbsent(campaignRecipient.getSubmittedAt().toLocalDate(), ignored -> new long[2])[0]++;
            }
            if (campaignRecipient.getTrainingCompletedAt() != null) {
                totals.computeIfAbsent(campaignRecipient.getTrainingCompletedAt().toLocalDate(), ignored -> new long[2])[1]++;
            }
        });
        return totals.entrySet().stream()
            .map(entry -> new TrendPoint(entry.getKey(), entry.getValue()[0], entry.getValue()[1]))
            .toList();
    }

    public List<DomainRiskRow> riskByDomain() {
        Map<String, List<RiskReportRow>> byDomain = new java.util.TreeMap<>();
        findAll(null, null, null).forEach(row -> byDomain
            .computeIfAbsent(row.email().substring(row.email().indexOf('@') + 1), ignored -> new java.util.ArrayList<>())
            .add(row));
        return byDomain.entrySet().stream().map(entry -> {
            List<RiskReportRow> rows = entry.getValue();
            long submits = rows.stream().mapToLong(RiskReportRow::submits).sum();
            double averageScore = rows.stream().mapToInt(RiskReportRow::riskScore).average().orElse(0);
            long campaigns = rows.stream().mapToLong(RiskReportRow::campaignsReceived).sum();
            return new DomainRiskRow(entry.getKey(), rows.size(), submits,
                campaigns == 0 ? 0 : Math.round(submits * 10000.0 / campaigns) / 100.0,
                Math.round(averageScore * 100.0) / 100.0);
        }).sorted(Comparator.comparingDouble(DomainRiskRow::averageRiskScore).reversed()).toList();
    }

    public AnalyticsInsights insights() {
        List<CampaignRecipient> recipients = repository.findAllForRiskReport(Campaign.Status.DRAFT);
        Map<String, PerformanceAggregate> templates = new java.util.TreeMap<>();
        Map<String, PerformanceAggregate> landingPages = new java.util.TreeMap<>();
        long openedCount = 0;
        long clickedCount = 0;
        long openedMinutes = 0;
        long clickedMinutes = 0;

        for (CampaignRecipient recipient : recipients) {
            templates.computeIfAbsent(recipient.getCampaign().getTemplate().getName(), PerformanceAggregate::new).add(recipient);
            landingPages.computeIfAbsent(recipient.getCampaign().getLandingPage().getName(), PerformanceAggregate::new).add(recipient);
            if (recipient.getSentAt() == null) continue;
            if (recipient.getOpenedAt() != null) {
                long minutes = Duration.between(recipient.getSentAt(), recipient.getOpenedAt()).toMinutes();
                if (minutes >= 0) { openedCount++; openedMinutes += minutes; }
            }
            if (recipient.getClickedAt() != null) {
                long minutes = Duration.between(recipient.getSentAt(), recipient.getClickedAt()).toMinutes();
                if (minutes >= 0) { clickedCount++; clickedMinutes += minutes; }
            }
        }

        List<RetestCandidate> candidates = findAll(null, null, null).stream()
            .filter(row -> row.submits() > 0 && row.reports() == 0)
            .map(row -> new RetestCandidate(row.recipientId(), row.name(), row.email(), row.submits(),
                row.riskScore(), row.lastSubmittedAt()))
            .sorted(Comparator.comparingInt(RetestCandidate::riskScore).reversed()
                .thenComparing(RetestCandidate::submits, Comparator.reverseOrder()))
            .limit(10)
            .toList();

        return new AnalyticsInsights(
            templates.values().stream().map(PerformanceAggregate::toRow)
                .sorted(Comparator.comparingDouble(PerformanceRow::clickRate).reversed()).toList(),
            landingPages.values().stream().map(PerformanceAggregate::toRow)
                .sorted(Comparator.comparingDouble(PerformanceRow::submitRate).reversed()).toList(),
            candidates,
            new TimingSummary(openedCount, average(openedMinutes, openedCount), clickedCount, average(clickedMinutes, clickedCount))
        );
    }

    public record RiskReportRow(
        Long recipientId, String name, String email, long campaignsReceived,
        long opens, long clicks, long submits, long reports,
        LocalDateTime firstSubmittedAt, LocalDateTime lastSubmittedAt,
        int riskScore, String riskLevel
    ) { }
    public record TrendPoint(LocalDate date, long submissions, long trainingCompleted) { }
    public record DomainRiskRow(String domain, int people, long submissions, double submitRate, double averageRiskScore) { }
    public record AnalyticsInsights(List<PerformanceRow> templates, List<PerformanceRow> landingPages,
                                    List<RetestCandidate> retestCandidates, TimingSummary timing) { }
    public record PerformanceRow(String name, long sent, long opened, long clicked, long submitted,
                                 double openRate, double clickRate, double submitRate) { }
    public record RetestCandidate(Long recipientId, String name, String email, long submits, int riskScore,
                                  LocalDateTime lastSubmittedAt) { }
    public record TimingSummary(long openedCount, double averageOpenMinutes, long clickedCount, double averageClickMinutes) { }

    private static double average(long total, long count) {
        return count == 0 ? 0 : Math.round(total * 100.0 / count) / 100.0;
    }

    private static final class PerformanceAggregate {
        private final String name;
        private long sent;
        private long opened;
        private long clicked;
        private long submitted;

        private PerformanceAggregate(String name) { this.name = name; }

        private void add(CampaignRecipient recipient) {
            if (recipient.getSentAt() != null) sent++;
            if (recipient.getOpenedAt() != null) opened++;
            if (recipient.getClickedAt() != null) clicked++;
            if (recipient.getSubmittedAt() != null) submitted++;
        }

        private PerformanceRow toRow() {
            return new PerformanceRow(name, sent, opened, clicked, submitted,
                rate(opened, sent), rate(clicked, sent), rate(submitted, sent));
        }
    }

    private static double rate(long numerator, long denominator) {
        return denominator == 0 ? 0 : Math.round(numerator * 10000.0 / denominator) / 100.0;
    }

    private static final class Aggregate {
        private final Long recipientId;
        private final String name;
        private final String email;
        private long campaignsReceived;
        private long opens;
        private long clicks;
        private long submits;
        private long reports;
        private LocalDateTime firstSubmittedAt;
        private LocalDateTime lastSubmittedAt;

        private Aggregate(Long recipientId, String name, String email) {
            this.recipientId = recipientId;
            this.name = name;
            this.email = email;
        }

        private void add(CampaignRecipient campaignRecipient) {
            campaignsReceived++;
            if (campaignRecipient.getOpenedAt() != null) opens++;
            if (campaignRecipient.getClickedAt() != null) clicks++;
            if (campaignRecipient.getSubmittedAt() != null) {
                submits++;
                LocalDateTime submittedAt = campaignRecipient.getSubmittedAt();
                firstSubmittedAt = firstSubmittedAt == null || firstSubmittedAt.isAfter(submittedAt)
                    ? submittedAt : firstSubmittedAt;
                lastSubmittedAt = lastSubmittedAt == null || lastSubmittedAt.isBefore(submittedAt)
                    ? submittedAt : lastSubmittedAt;
            }
            if (campaignRecipient.getReportedAt() != null) reports++;
        }

        private RiskReportRow toRow() {
            int score = RiskScoreCalculator.score(opens, clicks, submits, reports);
            return new RiskReportRow(recipientId, name, email, campaignsReceived, opens, clicks, submits, reports,
                firstSubmittedAt, lastSubmittedAt, score, RiskScoreCalculator.level(score));
        }
    }
}
