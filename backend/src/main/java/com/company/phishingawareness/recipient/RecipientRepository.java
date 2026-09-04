package com.company.phishingawareness.recipient;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

public interface RecipientRepository extends JpaRepository<Recipient, Long> {
    List<Recipient> findByActiveTrue();
    boolean existsByEmail(String email);
}
