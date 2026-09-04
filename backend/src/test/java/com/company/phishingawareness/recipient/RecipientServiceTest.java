package com.company.phishingawareness.recipient;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import java.util.List;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

@SpringBootTest
@ActiveProfiles("test")
@Transactional
class RecipientServiceTest {

    @Autowired
    private RecipientService recipientService;

    @Autowired
    private RecipientRepository recipientRepository;

    @Test
    void createRecipient_success() {
        var request = new RecipientService.CreateRequest("Test User", "test@example.com", true);
        var result = recipientService.create(request);

        assertThat(result.getId()).isNotNull();
        assertThat(result.getName()).isEqualTo("Test User");
        assertThat(result.getEmail()).isEqualTo("test@example.com");
        assertThat(result.getActive()).isTrue();
    }

    @Test
    void createRecipient_duplicateEmail_throws() {
        var request = new RecipientService.CreateRequest("User 1", "dup@example.com", true);
        recipientService.create(request);

        var dupRequest = new RecipientService.CreateRequest("User 2", "dup@example.com", true);
        assertThatThrownBy(() -> recipientService.create(dupRequest))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("already exists");
    }

    @Test
    void findById_found() {
        var created = recipientService.create(new RecipientService.CreateRequest("Find Me", "find@test.com", true));
        var found = recipientService.findById(created.getId());

        assertThat(found.getName()).isEqualTo("Find Me");
    }

    @Test
    void findById_notFound_throws() {
        assertThatThrownBy(() -> recipientService.findById(99999L))
                .isInstanceOf(com.company.phishingawareness.shared.NotFoundException.class);
    }

    @Test
    void updateRecipient_success() {
        var created = recipientService.create(new RecipientService.CreateRequest("Old Name", "old@test.com", true));
        var updated = recipientService.update(created.getId(), new RecipientService.UpdateRequest("New Name", null, null));

        assertThat(updated.getName()).isEqualTo("New Name");
        assertThat(updated.getEmail()).isEqualTo("old@test.com");
    }

    @Test
    void deleteRecipient_softDelete() {
        var created = recipientService.create(new RecipientService.CreateRequest("Delete Me", "del@test.com", true));
        recipientService.delete(created.getId());

        var found = recipientService.findById(created.getId());
        assertThat(found.getActive()).isFalse();
    }

    @Test
    void searchByName_returnsResults() {
        recipientService.create(new RecipientService.CreateRequest("Alice Smith", "alice@test.com", true));
        recipientService.create(new RecipientService.CreateRequest("Bob Jones", "bob@test.com", true));
        recipientService.create(new RecipientService.CreateRequest("Alice Johnson", "alicej@test.com", true));

        var page = recipientService.search("alice",
                org.springframework.data.domain.PageRequest.of(0, 10));

        assertThat(page.getTotalElements()).isEqualTo(2);
    }
}
