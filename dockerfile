# ============================
# Stage 1 - Build
# ============================
FROM maven:3.9.11-eclipse-temurin-17 AS builder

WORKDIR /app

# pom.xml మాత్రమే copy చేసి dependencies cache చేయండి
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Source code copy చేయండి
COPY src ./src

# Tests skip చేయడం flexible గా చేయండి
ARG SKIP_TESTS=true
RUN mvn package -DskipTests=${SKIP_TESTS} -B

# ============================
# Stage 2 - Runtime
# ============================
FROM eclipse-temurin:17-jre-noble
LABEL org.opencontainers.image.authors="Sainath"
LABEL org.opencontainers.image.title="Spring PetClinic"
LABEL org.opencontainers.image.version="1.0"

WORKDIR /app

RUN groupadd -r spring && \
    useradd -r -g spring spring

COPY --from=builder \
    --chown=spring:spring \
    /app/target/spring-petclinic-*.jar \
    app.jar

USER spring

EXPOSE 8080

ENTRYPOINT ["java","-XX:MaxRAMPercentage=75.0","-jar","app.jar"]
