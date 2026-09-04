package com.company.phishingawareness.landing;

import com.company.phishingawareness.shared.BaseEntity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Lob;
import jakarta.persistence.Table;

@Entity
@Table(name = "landing_pages")
public class LandingPage extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 150)
    private String name;

    @Column(nullable = false, unique = true, length = 150)
    private String slug;

    @Enumerated(EnumType.STRING)
    @Column(length = 20)
    private Category category;

    @Enumerated(EnumType.STRING)
    @Column(length = 10)
    private Difficulty difficulty;

    @Lob
    @Column(nullable = false, columnDefinition = "TEXT")
    private String html;

    @Column(nullable = false)
    private Boolean active = true;

    public enum Category {
        ACCOUNT, DOCUMENT, SECURITY, CLOUD, HR, SUPPORT, NOTIFICATION
    }

    public enum Difficulty {
        EASY, MEDIUM, HARD
    }

    // Getters and setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getSlug() { return slug; }
    public void setSlug(String slug) { this.slug = slug; }
    public Category getCategory() { return category; }
    public void setCategory(Category category) { this.category = category; }
    public Difficulty getDifficulty() { return difficulty; }
    public void setDifficulty(Difficulty difficulty) { this.difficulty = difficulty; }
    public String getHtml() { return html; }
    public void setHtml(String html) { this.html = html; }
    public Boolean getActive() { return active; }
    public void setActive(Boolean active) { this.active = active; }
}
