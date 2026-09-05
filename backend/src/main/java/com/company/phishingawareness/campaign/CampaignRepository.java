package com.company.phishingawareness.campaign;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface CampaignRepository extends JpaRepository<Campaign, Long> {
    List<Campaign> findByStatus(Campaign.Status status);

    @Query("SELECT DISTINCT c FROM Campaign c LEFT JOIN FETCH c.template LEFT JOIN FETCH c.landingPage WHERE " +
           "(:search IS NULL OR :search = '' OR " +
           "LOWER(c.name) LIKE LOWER(CONCAT('%', :search, '%')))")
    Page<Campaign> search(@Param("search") String search, Pageable pageable);

    @Query("SELECT DISTINCT c FROM Campaign c LEFT JOIN FETCH c.template LEFT JOIN FETCH c.landingPage WHERE c.id = :id")
    java.util.Optional<Campaign> findDetailedById(@Param("id") Long id);
    long countByStatus(Campaign.Status status);
    List<Campaign> findTop5ByOrderByCreatedAtDesc();
    List<Campaign> findByStatusAndScheduledAtLessThanEqual(Campaign.Status status, java.time.LocalDateTime at);
    List<Campaign> findByGophishCampaignIdIsNotNull();
}
