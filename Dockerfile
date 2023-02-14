FROM ubuntu as downloader
RUN  apt-get update \
    && apt-get install -y wget

RUN wget https://dlcdn.apache.org/kafka/3.4.0/kafka_2.13-3.4.0.tgz

RUN tar -xvzf kafka_2.13-3.4.0.tgz
RUN rm -rf kafka_2.13-3.4.0/site-docs kafka_2.13-3.4.0/bin/windows
ADD ./start-kafka.sh kafka_2.13-3.4.0/start-kafka.sh
RUN chmod a+x kafka_2.13-3.4.0/start-kafka.sh

FROM eclipse-temurin:8-jdk-alpine
RUN apk add --no-cache bash
COPY --from=downloader kafka_2.13-3.4.0 kafka
CMD ["./kafka/start-kafka.sh"]