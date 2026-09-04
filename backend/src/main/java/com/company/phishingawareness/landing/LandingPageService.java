package com.company.phishingawareness.landing;

import java.util.List;

import org.springframework.stereotype.Service;

import com.company.phishingawareness.shared.NotFoundException;

@Service
public class LandingPageService {

    private final LandingPageRepository repository;

    public LandingPageService(LandingPageRepository repository) {
        this.repository = repository;
    }

    public List<LandingPage> findAll() {
        return repository.findAll();
    }

    public LandingPage findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new NotFoundException("Landing page not found with id: " + id));
    }

    public LandingPage findBySlug(String slug) {
        return repository.findBySlug(slug)
                .orElseThrow(() -> new NotFoundException("Landing page not found with slug: " + slug));
    }

    public List<LandingPage> findByActiveTrue() {
        return repository.findByActiveTrue();
    }

    public LandingPage create(CreateRequest request) {
        LandingPage page = new LandingPage();
        page.setName(request.name());
        page.setSlug(request.slug());
        page.setCategory(request.category());
        page.setDifficulty(request.difficulty());
        page.setHtml(request.html());
        page.setActive(request.active() != null ? request.active() : true);
        return repository.save(page);
    }

    public LandingPage update(Long id, UpdateRequest request) {
        LandingPage page = findById(id);
        if (request.name() != null) page.setName(request.name());
        if (request.slug() != null) page.setSlug(request.slug());
        if (request.category() != null) page.setCategory(request.category());
        if (request.difficulty() != null) page.setDifficulty(request.difficulty());
        if (request.html() != null) page.setHtml(request.html());
        if (request.active() != null) page.setActive(request.active());
        return repository.save(page);
    }

    public void delete(Long id) {
        LandingPage page = findById(id);
        page.setActive(false);
        repository.save(page);
    }

    public record CreateRequest(String name, String slug, LandingPage.Category category,
                                 LandingPage.Difficulty difficulty, String html, Boolean active) {}
    public record UpdateRequest(String name, String slug, LandingPage.Category category,
                                 LandingPage.Difficulty difficulty, String html, Boolean active) {}
}
