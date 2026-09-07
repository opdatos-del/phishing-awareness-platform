package com.company.phishingawareness.analytics;

import static org.assertj.core.api.Assertions.assertThat;

import org.junit.jupiter.api.Test;

class RiskScoreCalculatorTest {

    @Test
    void calculatesScoreAndClampsAtZero() {
        assertThat(RiskScoreCalculator.score(2, 3, 1, 1)).isEqualTo(10);
        assertThat(RiskScoreCalculator.score(0, 0, 0, 2)).isZero();
    }

    @Test
    void mapsRiskLevels() {
        assertThat(RiskScoreCalculator.level(2)).isEqualTo("BAJO");
        assertThat(RiskScoreCalculator.level(3)).isEqualTo("MEDIO");
        assertThat(RiskScoreCalculator.level(6)).isEqualTo("ALTO");
        assertThat(RiskScoreCalculator.level(10)).isEqualTo("CRITICO");
    }
}
