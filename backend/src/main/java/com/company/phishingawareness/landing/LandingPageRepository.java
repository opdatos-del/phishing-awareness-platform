package com.company.phishingawareness.landing;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

public interface LandingPageRepository extends JpaRepository<LandingPage, Long> {
    List<LandingPage> findByActiveTrue();
    Optional<LandingPage> findBySlug(String slug);
}
