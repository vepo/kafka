# Kafka

Kafka docker image.

Any config value can be set by using the `KAFKA_` prefix.

Using with Docker Compose

```yaml
services:
  kafka:
    image: vepo/kafka:3.4.0
    ports:
     - 9092:9092
    environment:
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://kafka:9092
```