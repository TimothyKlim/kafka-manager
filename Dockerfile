FROM fcomb/jdk8-sbt-alpine
MAINTAINER Timothy Klim <github@timothyklim.com>

USER root

ENV ZK_HOSTS localhost:2181
ENV WORKDIR /home/java/project
ENV VERSION 1.3.1.8
ENV APP "/kafka-manager-${VERSION}"

RUN adduser -D -g '' -h ${APP} -H kafka

COPY . ${WORKDIR}
WORKDIR ${WORKDIR}

RUN chown -R java:java ${WORKDIR} && \
    su java -c "/home/java/bin/sbt dist" && \
    unzip ${WORKDIR}/target/universal/kafka-manager-1.3.1.8.zip -q -d / && \
    deluser --remove-home java && \
    rm -rf /var/cache/apk/* ${WORKDIR}

EXPOSE 9000

USER kafka

WORKDIR ${APP}
CMD ${APP}/bin/kafka-manager
