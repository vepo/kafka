FROM ubuntu as downloader
RUN  apt-get update \
    && apt-get install -y wget

RUN wget https://archive.apache.org/dist/kafka/3.4.1/kafka_2.13-3.4.1.tgz

RUN tar -xvzf kafka_2.13-3.4.1.tgz
RUN rm -rf kafka_2.13-3.4.1/site-docs kafka_2.13-3.4.1/bin/windows
ADD ./start-kafka.sh kafka_2.13-3.4.1/start-kafka.sh
RUN chmod a+x kafka_2.13-3.4.1/start-kafka.sh

FROM eclipse-temurin:8-jdk-alpine
RUN apk add --no-cache bash
COPY --from=downloader kafka_2.13-3.4.1 kafka
CMD ["./kafka/start-kafka.sh"]
