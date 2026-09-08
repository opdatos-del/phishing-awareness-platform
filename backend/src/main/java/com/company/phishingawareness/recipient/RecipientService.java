package com.company.phishingawareness.recipient;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Set;
import java.util.regex.Pattern;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.company.phishingawareness.shared.NotFoundException;

@Service
public class RecipientService {

    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$");

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

    @Transactional
    public BatchImportResponse importBatch(BatchImportRequest request) {
        List<BatchImportFailure> failedItems = new ArrayList<>();
        Set<String> emailsInFile = new HashSet<>();
        int createdCount = 0;
        int updatedCount = 0;

        List<BatchRecipientRequest> items = request == null || request.items() == null ? List.of() : request.items();
        for (BatchRecipientRequest item : items) {
            String name = item.name() == null ? "" : item.name().trim();
            String email = item.email() == null ? "" : item.email().trim().toLowerCase(Locale.ROOT);
            String error = validationError(name, email);
            if (error != null) {
                failedItems.add(new BatchImportFailure(item.row(), item.name(), item.email(), error));
                continue;
            }
            if (!emailsInFile.add(email)) {
                failedItems.add(new BatchImportFailure(item.row(), item.name(), item.email(), "Email repetido en el archivo"));
                continue;
            }

            Recipient recipient = repository.findByEmailIgnoreCase(email).orElse(null);
            if (recipient == null) {
                recipient = new Recipient();
                recipient.setName(name);
                recipient.setEmail(email);
                recipient.setActive(true);
                repository.save(recipient);
                createdCount++;
            } else {
                recipient.setName(name);
                recipient.setActive(true);
                repository.save(recipient);
                updatedCount++;
            }
        }

        return new BatchImportResponse(createdCount + updatedCount, createdCount, updatedCount, failedItems);
    }

    private static String validationError(String name, String email) {
        if (name.isBlank()) return "Nombre requerido";
        if (email.isBlank()) return "Email requerido";
        if (!EMAIL_PATTERN.matcher(email).matches()) return "Email inválido";
        return null;
    }

    public record CreateRequest(String name, String email, Boolean active) {}
    public record UpdateRequest(String name, String email, Boolean active) {}
    public record BatchRecipientRequest(int row, String name, String email) {}
    public record BatchImportRequest(List<BatchRecipientRequest> items) {}
    public record BatchImportFailure(int row, String name, String email, String reason) {}
    public record BatchImportResponse(int successCount, int createdCount, int updatedCount,
                                      List<BatchImportFailure> failedItems) {}
}
