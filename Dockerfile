ARG KAFKA_VERSION=4.0.0
ARG JAVA_VERSION=21

FROM ubuntu as downloader
RUN  apt-get update \
    && apt-get install -y wget

ENV kafka_version=4.0.0
ENV java_version=21

RUN wget https://archive.apache.org/dist/kafka/${kafka_version}/kafka_2.13-${kafka_version}.tgz
RUN tar -xvzf kafka_2.13-${kafka_version}.tgz
RUN rm -rf kafka_2.13-${kafka_version}/site-docs kafka_2.13-${kafka_version}/bin/windows
ADD ./start-kafka.sh kafka_2.13-${kafka_version}/start-kafka.sh
RUN chmod a+x kafka_2.13-${kafka_version}/start-kafka.sh

FROM eclipse-temurin:${JAVA_VERSION}-jdk-alpine

ENV kafka_version=4.0.0
ENV java_version=21

RUN apk add --upgrade --no-cache bash expat

COPY --from=downloader kafka_2.13-${kafka_version} kafka
CMD ["./kafka/start-kafka.sh"]
