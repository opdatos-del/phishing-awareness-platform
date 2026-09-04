package com.company.phishingawareness.template;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

public interface EmailTemplateRepository extends JpaRepository<EmailTemplate, Long> {
    List<EmailTemplate> findByActiveTrue();
    List<EmailTemplate> findByCategoryAndActiveTrue(EmailTemplate.Category category);
}
