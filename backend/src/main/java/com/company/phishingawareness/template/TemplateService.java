package com.company.phishingawareness.template;

import java.util.List;

import org.springframework.stereotype.Service;

import com.company.phishingawareness.shared.NotFoundException;

@Service
public class TemplateService {

    private final EmailTemplateRepository repository;

    public TemplateService(EmailTemplateRepository repository) {
        this.repository = repository;
    }

    public List<EmailTemplate> findAll() {
        return repository.findAll();
    }

    public EmailTemplate findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new NotFoundException("Template not found with id: " + id));
    }

    public List<EmailTemplate> findByActiveTrue() {
        return repository.findByActiveTrue();
    }

    public EmailTemplate create(CreateRequest request) {
        EmailTemplate template = new EmailTemplate();
        template.setName(request.name());
        template.setDescription(request.description());
        template.setCategory(request.category());
        template.setDifficulty(request.difficulty());
        template.setSubject(request.subject());
        template.setHtml(request.html());
        template.setActive(request.active() != null ? request.active() : true);
        return repository.save(template);
    }

    public EmailTemplate update(Long id, UpdateRequest request) {
        EmailTemplate template = findById(id);
        if (request.name() != null) template.setName(request.name());
        if (request.description() != null) template.setDescription(request.description());
        if (request.category() != null) template.setCategory(request.category());
        if (request.difficulty() != null) template.setDifficulty(request.difficulty());
        if (request.subject() != null) template.setSubject(request.subject());
        if (request.html() != null) template.setHtml(request.html());
        if (request.active() != null) template.setActive(request.active());
        return repository.save(template);
    }

    public void delete(Long id) {
        EmailTemplate template = findById(id);
        template.setActive(false);
        repository.save(template);
    }

    public record CreateRequest(String name, String description, EmailTemplate.Category category,
                                 EmailTemplate.Difficulty difficulty, String subject, String html, Boolean active) {}
    public record UpdateRequest(String name, String description, EmailTemplate.Category category,
                                 EmailTemplate.Difficulty difficulty, String subject, String html, Boolean active) {}
}
