# Kafka

Kafka docker image.

Any config value can be set by using the `KAFKA_` prefix.

Using with Docker Compose

Available versions: 4.0.0, 3.9.0, 3.8.0, 3.7.0, 3.5.0, 3.4.1, 3.4.0

```yaml
services:
  kafka:
    image: vepo/kafka:4.0.0
    ports:
     - 9092:9092
    environment:
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://kafka:9092
```