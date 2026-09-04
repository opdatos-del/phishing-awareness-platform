# Multi-stage build for Spring Boot
# --- Build stage ---
FROM eclipse-temurin:21-jdk AS build
WORKDIR /app

# Cache Maven dependencies
COPY pom.xml .
RUN --mount=type=cache,target=/root/.m2 \
    mvn dependency:go-offline -B

# Build application
COPY src ./src
RUN --mount=type=cache,target=/root/.m2 \
    mvn package -DskipTests -B

# --- Runtime stage ---
FROM eclipse-temurin:21-jre
WORKDIR /app

RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
