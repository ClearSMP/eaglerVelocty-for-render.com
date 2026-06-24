FROM eclipse-temurin:21-jre

WORKDIR /app

COPY . .

RUN chmod +x startup.sh

CMD ["bash", "startup.sh"]