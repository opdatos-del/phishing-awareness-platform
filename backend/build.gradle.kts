plugins {
    java
    id("org.springframework.boot") version "4.1.1"
    id("io.spring.dependency-management") version "1.1.7"
    id("org.flywaydb.flyway") version "12.4.0"
}

buildscript {
    dependencies {
        classpath("org.flywaydb:flyway-mysql:12.4.0")
        classpath("com.mysql:mysql-connector-j:9.3.0")
    }
}

group = "com.company"
version = "0.1.0-SNAPSHOT"

java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(21)
    }
}

configurations {
    compileOnly {
        extendsFrom(configurations.annotationProcessor.get())
    }
}

repositories {
    mavenCentral()
}

val jjwtVersion = "0.13.0"

dependencies {
    // Spring Boot Starters
    implementation("org.springframework.boot:spring-boot-starter-web")
    implementation("org.springframework.boot:spring-boot-starter-security")
    implementation("org.springframework.boot:spring-boot-starter-data-jpa")
    implementation("org.springframework.boot:spring-boot-starter-validation")
    implementation("org.springframework.boot:spring-boot-starter-actuator")
    implementation("org.springframework.boot:spring-boot-starter-webflux")

    // Database
    runtimeOnly("com.mysql:mysql-connector-j")
    // Starter necesario en Boot 4: flyway-core solo no activa auto-config
    implementation("org.springframework.boot:spring-boot-starter-flyway")
    implementation("org.flywaydb:flyway-mysql")

    // JWT
    implementation("io.jsonwebtoken:jjwt-api:$jjwtVersion")
    runtimeOnly("io.jsonwebtoken:jjwt-impl:$jjwtVersion")
    runtimeOnly("io.jsonwebtoken:jjwt-jackson:$jjwtVersion")

    // Utilities
    implementation("org.apache.commons:commons-lang3")
    implementation("com.fasterxml.jackson.datatype:jackson-datatype-jsr310")

    // Test
    testImplementation("org.springframework.boot:spring-boot-starter-test")
    testImplementation("org.springframework.security:spring-security-test")
    testRuntimeOnly("com.h2database:h2")
}

tasks.withType<Test> {
    useJUnitPlatform()
}

// --- Flyway CLI tasks (flywayMigrate, flywayInfo, flywayRepair) ---
// Ejecutan contra MySQL del host. Credenciales desde el .env del monorepo.
fun envValue(key: String, default: String): String {
    val envFile = rootProject.file("../.env")
    if (envFile.exists()) {
        for (line in envFile.readLines()) {
            val trimmed = line.trim()
            if (trimmed.startsWith("$key=")) return trimmed.removePrefix("$key=").trim()
        }
    }
    return System.getenv(key) ?: default
}

flyway {
    url = "jdbc:mysql://${envValue("DB_HOST", "localhost")}:${envValue("DB_PORT", "3306")}/" +
        "${envValue("DB_NAME", "phishing_awareness")}?allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=UTC"
    user = envValue("DB_USERNAME", "phishing_app")
    password = envValue("DB_PASSWORD", "CHANGE_ME")
    locations = arrayOf("filesystem:src/main/resources/db/migration")
    driver = "com.mysql.cj.jdbc.Driver"
}
