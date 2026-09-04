package com.company.phishingawareness.recipient;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.company.phishingawareness.shared.NotFoundException;

@Service
public class RecipientService {

    private final RecipientRepository repository;

    public RecipientService(RecipientRepository repository) {
        this.repository = repository;
    }

    public Page<Recipient> search(String search, Pageable pageable) {
        return repository.search(search, pageable);
    }

    public Recipient findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new NotFoundException("Recipient not found with id: " + id));
    }

    public Recipient create(CreateRequest request) {
        if (repository.existsByEmail(request.email())) {
            throw new IllegalArgumentException("Email already exists: " + request.email());
        }
        Recipient recipient = new Recipient();
        recipient.setName(request.name());
        recipient.setEmail(request.email());
        recipient.setActive(request.active() != null ? request.active() : true);
        return repository.save(recipient);
    }

    public Recipient update(Long id, UpdateRequest request) {
        Recipient recipient = findById(id);
        if (request.name() != null) recipient.setName(request.name());
        if (request.email() != null) {
            if (!recipient.getEmail().equals(request.email()) && repository.existsByEmail(request.email())) {
                throw new IllegalArgumentException("Email already exists: " + request.email());
            }
            recipient.setEmail(request.email());
        }
        if (request.active() != null) recipient.setActive(request.active());
        return repository.save(recipient);
    }

    public void delete(Long id) {
        Recipient recipient = findById(id);
        recipient.setActive(false);
        repository.save(recipient);
    }

    public record CreateRequest(String name, String email, Boolean active) {}
    public record UpdateRequest(String name, String email, Boolean active) {}
}
