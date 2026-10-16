FROM eclipse-temurin:21-jre-noble

LABEL org.opencontainers.image.authors="Sainath"
LABEL org.opencontainers.image.title="Spring PetClinic"
LABEL org.opencontainers.image.version="1.0"

WORKDIR /app

RUN groupadd -r spring && \
    useradd -r -g spring spring

COPY --chown=spring:spring target/spring-petclinic-*.jar app.jar

USER spring

EXPOSE 8080

ENTRYPOINT ["java","-XX:MaxRAMPercentage=75.0","-jar","app.jar"]
