package com.company.phishingawareness.landing;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/v1/landing-pages")
public class LandingPageController {

    private final LandingPageService service;

    public LandingPageController(LandingPageService service) {
        this.service = service;
    }

    @GetMapping
    public List<LandingPage> list() {
        return service.findAll();
    }

    @GetMapping("/{id}")
    public LandingPage getById(@PathVariable Long id) {
        return service.findById(id);
    }

    @PostMapping
    public ResponseEntity<LandingPage> create(@Valid @RequestBody LandingPageService.CreateRequest request) {
        LandingPage created = service.create(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }

    @PutMapping("/{id}")
    public LandingPage update(@PathVariable Long id, @Valid @RequestBody LandingPageService.UpdateRequest request) {
        return service.update(id, request);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        service.delete(id);
        return ResponseEntity.noContent().build();
    }
}
