package com.company.phishingawareness;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class PhishingAwarenessApplication {

    public static void main(String[] args) {
        SpringApplication.run(PhishingAwarenessApplication.class, args);
    }
}
