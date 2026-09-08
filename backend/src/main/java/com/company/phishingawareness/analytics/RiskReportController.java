package com.company.phishingawareness.analytics;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/analytics")
public class RiskReportController {

    private final RiskReportService service;

    public RiskReportController(RiskReportService service) {
        this.service = service;
    }

    @GetMapping("/risk-report")
    public List<RiskReportService.RiskReportRow> riskReport(
        @RequestParam(required = false) Integer minScore,
        @RequestParam(required = false) String level,
        @RequestParam(required = false) String search) {
        return service.findAll(minScore, level, search);
    }

    @GetMapping("/trend")
    public List<RiskReportService.TrendPoint> trend() {
        return service.trend();
    }

    @GetMapping("/risk-domains")
    public List<RiskReportService.DomainRiskRow> riskDomains() {
        return service.riskByDomain();
    }
}
