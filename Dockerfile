FROM eclipse-temurin:21-jre

WORKDIR /app

COPY server.jar server.jar
COPY plugins ./plugins

EXPOSE 25565

CMD ["java", "-jar", "server.jar"]