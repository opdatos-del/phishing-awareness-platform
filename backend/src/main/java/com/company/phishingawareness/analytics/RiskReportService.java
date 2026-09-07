package com.company.phishingawareness.analytics;

import java.time.LocalDateTime;
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

    public record RiskReportRow(
        Long recipientId, String name, String email, long campaignsReceived,
        long opens, long clicks, long submits, long reports,
        LocalDateTime firstSubmittedAt, LocalDateTime lastSubmittedAt,
        int riskScore, String riskLevel
    ) { }

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
