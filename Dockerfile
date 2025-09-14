ARG KAFKA_VERSION=4.1.0
ARG SCALA_VERSION=2.13
ARG JAVA_VERSION=21.0.8_9-jdk-alpine-3.20

FROM ubuntu as downloader

ARG KAFKA_VERSION
ARG SCALA_VERSION

RUN  apt-get update \
    && apt-get install -y wget

RUN wget https://archive.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz && \
    tar -xvzf kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz && \
    rm -rf kafka_${SCALA_VERSION}-${KAFKA_VERSION}/site-docs kafka_${SCALA_VERSION}-${KAFKA_VERSION}/bin/windows && \
    rm kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz
ADD ./start-kafka.sh kafka_${SCALA_VERSION}-${KAFKA_VERSION}/start-kafka.sh
RUN chmod a+x kafka_${SCALA_VERSION}-${KAFKA_VERSION}/start-kafka.sh

FROM eclipse-temurin:${JAVA_VERSION}

ARG KAFKA_VERSION
ARG SCALA_VERSION

ENV KAFKA_HOME=/opt/kafka
ENV PATH=${KAFKA_HOME}/bin:${PATH}

RUN apk add --upgrade --no-cache bash expat snappy

WORKDIR ${KAFKA_HOME}
COPY --from=downloader kafka_${SCALA_VERSION}-${KAFKA_VERSION} ${KAFKA_HOME}
CMD ["./start-kafka.sh"]
