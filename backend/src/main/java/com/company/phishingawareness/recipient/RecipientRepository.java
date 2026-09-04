package com.company.phishingawareness.recipient;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface RecipientRepository extends JpaRepository<Recipient, Long> {
    List<Recipient> findByActiveTrue();

    boolean existsByEmail(String email);

    @Query("SELECT r FROM Recipient r WHERE " +
           "(:search IS NULL OR :search = '' OR " +
           "LOWER(r.name) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
           "LOWER(r.email) LIKE LOWER(CONCAT('%', :search, '%')))")
    Page<Recipient> search(@Param("search") String search, Pageable pageable);
}
