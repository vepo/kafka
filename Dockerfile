ARG KAFKA_VERSION=4.0.0
ARG JAVA_VERSION=21

FROM ubuntu as downloader
RUN  apt-get update \
    && apt-get install -y wget

ENV kafka_version=4.0.0
ENV java_version=21

RUN wget https://archive.apache.org/dist/kafka/${kafka_version}/kafka_2.13-${kafka_version}.tgz && \
    tar -xvzf kafka_2.13-${kafka_version}.tgz && \
    rm -rf kafka_2.13-${kafka_version}/site-docs kafka_2.13-${kafka_version}/bin/windows && \
    rm kafka_2.13-${kafka_version}.tgz
ADD ./start-kafka.sh kafka_2.13-${kafka_version}/start-kafka.sh
RUN chmod a+x kafka_2.13-${kafka_version}/start-kafka.sh

FROM eclipse-temurin:${JAVA_VERSION}-jdk-alpine

ENV kafka_version=4.0.0
ENV java_version=21
ENV KAFKA_HOME=/opt/kafka
ENV PATH=${KAFKA_HOME}/bin:${PATH}

RUN apk add --upgrade --no-cache bash expat snappy

WORKDIR ${KAFKA_HOME}
COPY --from=downloader kafka_2.13-${kafka_version} ${KAFKA_HOME}
CMD ["./kafka/start-kafka.sh"]
