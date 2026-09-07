package com.company.phishingawareness.analytics;

public final class RiskScoreCalculator {

    private RiskScoreCalculator() {
    }

    public static int score(long opens, long clicks, long submits, long reports) {
        return Math.max(0, Math.toIntExact(opens + (clicks * 2) + (submits * 5) - (reports * 3)));
    }

    public static String level(int score) {
        if (score >= 10) return "CRITICO";
        if (score >= 6) return "ALTO";
        if (score >= 3) return "MEDIO";
        return "BAJO";
    }
}
