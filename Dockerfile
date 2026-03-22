# ── Stage: Runtime ────────────────────────────────────────────────────────────

# Use a minimal JRE-only Alpine image — smaller attack surface than full JDK
FROM eclipse-temurin:17-jre-alpine

# Security best practice — never run containers as root
RUN addgroup -S jfroggroup && adduser -S jfroguser -G jfroggroup
USER jfroguser

# Set working directory
WORKDIR /jfrog/petclinic

# Copy the JAR built by Maven in the pipeline
COPY target/spring-petclinic-*.jar petclinic-app.jar

# Expose the default Spring Boot port
EXPOSE 8080

# Health check — Artifactory/Xray and orchestrators use this
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
  CMD wget -qO- http://localhost:8080/actuator/health || exit 1

# Run the application
ENTRYPOINT ["java", "-jar", "petclinic-app.jar"]
