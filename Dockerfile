FROM openjdk:8-jre-alpine

ARG LB_VER=3.1.1

MAINTAINER Tilikov Vyacheslav

ENV LB_DRIVER="org.postgresql.Driver" \
    LB_CLASSPATH="/liquibase/lib/postgresql-42.2.1.jar" \
    LB_URL="" \
    LB_USER="" \
    LB_PASS="" \
    LB_CHANGELOG="liquibase.xml" \
    LB_CONTEXTS="" \
    LB_OPTS=""

RUN apk add --no-cache --virtual .build-deps \
        curl \
    \
    && apk add --update bash \
    && mkdir -p /tmp/lbsrc \
    && mkdir -p /tmp/lbsrc/liquibase \
    && curl -fSL \
        https://github.com/liquibase/liquibase/releases/download/liquibase-parent-${LB_VER}/liquibase-${LB_VER}-bin.tar.gz \
        -o /tmp/lbsrc/liquibase-bin.tar.gz \
    && tar -zxC /tmp/lbsrc/liquibase -f /tmp/lbsrc/liquibase-bin.tar.gz \
    && cp -R /tmp/lbsrc/liquibase /liquibase \
    && chmod 755 /liquibase/liquibase \
    && ln -s /liquibase/liquibase /usr/local/bin/liquibase \
    \
    && curl -fSL \
        https://jdbc.postgresql.org/download/postgresql-42.2.1.jar \
        -o /liquibase/lib/postgresql-42.2.1.jar \
    \
    && rm -fr /tmp/lbsrc \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/*

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

VOLUME /migrations
WORKDIR /migrations

ENTRYPOINT ["entrypoint.sh"]
