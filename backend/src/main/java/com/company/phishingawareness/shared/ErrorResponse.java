package com.company.phishingawareness.shared;

import java.time.LocalDateTime;
import java.util.List;

public record ErrorResponse(
    int status,
    String error,
    String message,
    LocalDateTime timestamp,
    List<FieldError> details
) {
    public record FieldError(String field, String message) {}

    public static ErrorResponse of(int status, String error, String message) {
        return new ErrorResponse(status, error, message, LocalDateTime.now(), List.of());
    }

    public static ErrorResponse of(int status, String error, String message, List<FieldError> details) {
        return new ErrorResponse(status, error, message, LocalDateTime.now(), details);
    }
}
