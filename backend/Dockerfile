# Multi-stage build for Spring Boot (Gradle)
# --- Build stage ---
FROM eclipse-temurin:25-jdk AS build
WORKDIR /app

# Cache Gradle dependencies
COPY gradle/ gradle/
COPY gradlew build.gradle.kts settings.gradle.kts ./
RUN --mount=type=cache,target=/root/.gradle \
    chmod +x gradlew && ./gradlew dependencies --no-daemon

# Build application
COPY src ./src
RUN --mount=type=cache,target=/root/.gradle \
    ./gradlew bootJar --no-daemon -x test

# --- Runtime stage ---
FROM eclipse-temurin:25-jre
WORKDIR /app

RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

COPY --from=build /app/build/libs/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
