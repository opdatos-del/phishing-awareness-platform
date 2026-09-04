package com.company.phishingawareness.shared;

import static org.assertj.core.api.Assertions.assertThat;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

@SpringBootTest
@ActiveProfiles("test")
@Transactional
class GlobalExceptionHandlerTest {

    @Autowired
    private GlobalExceptionHandler handler;

    @Test
    void notFoundException_returns404() {
        var response = handler.handleNotFound(new NotFoundException("Recipient not found with id: 999"));
        assertThat(response.getStatusCode().value()).isEqualTo(404);
        assertThat(response.getBody().error()).isEqualTo("Not found");
        assertThat(response.getBody().message()).contains("999");
    }

    @Test
    void illegalArgumentException_returns400() {
        var response = handler.handleIllegalArgument(new IllegalArgumentException("Email already exists"));
        assertThat(response.getStatusCode().value()).isEqualTo(400);
        assertThat(response.getBody().error()).isEqualTo("Bad request");
    }

    @Test
    void illegalStateException_returns400() {
        var response = handler.handleIllegalState(new IllegalStateException("Only DRAFT campaigns can be modified"));
        assertThat(response.getStatusCode().value()).isEqualTo(400);
    }

    @Test
    void generalException_returns500() {
        var response = handler.handleGeneral(new RuntimeException("Unexpected"));
        assertThat(response.getStatusCode().value()).isEqualTo(500);
    }
}
