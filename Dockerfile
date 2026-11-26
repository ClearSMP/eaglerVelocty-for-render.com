FROM eclipse-temurin:17-jre

RUN apt-get update && apt-get install -y dnsutils

WORKDIR /app

COPY . .

RUN chmod +x startup.sh

CMD ["bash", "startup.sh"]
