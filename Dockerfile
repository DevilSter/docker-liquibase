FROM openjdk:11-jre-slim-buster

ARG LIQUIBASE_VERSION=3.10.3
ARG LB_SHA256=b34b0dbf35fba557d8f3cbf9ae08e0027e288ef2a35c6fa9dbe16536d070f7a8
ARG PG_DRIVER_VERSION=42.2.18

LABEL maintainer="Devil.Ster.1"
LABEL version="1.0.3"

ENV LB_DRIVER="org.postgresql.Driver" \
    LB_CLASSPATH="/liquibase/lib/postgresql.jar" \
    LB_URL="" \
    LB_USER="" \
    LB_PASS="" \
    LB_CHANGELOG="liquibase.xml" \
    LB_CONTEXTS="" \
    LB_OPTS="" \
    LB_LOGLEVEL="info"

# Install GPG for package vefification
RUN apt-get update \
	&& apt-get -y install gnupg wget

# Add the liquibase user and step in the directory
RUN addgroup --gid 1001 liquibase
RUN adduser --disabled-password --uid 1001 --ingroup liquibase liquibase

# Make /liquibase directory and change owner to liquibase
RUN mkdir /liquibase && chown liquibase /liquibase
WORKDIR /liquibase

# Change to the liquibase user
USER liquibase

# Download, verify, extract
RUN set -x \
  && wget -O liquibase-${LIQUIBASE_VERSION}.tar.gz "https://github.com/liquibase/liquibase/releases/download/v${LIQUIBASE_VERSION}/liquibase-${LIQUIBASE_VERSION}.tar.gz" \
  && echo "${LB_SHA256}  liquibase-${LIQUIBASE_VERSION}.tar.gz" | sha256sum -c - \
  && tar -xzf liquibase-${LIQUIBASE_VERSION}.tar.gz

# Setup GPG
RUN GNUPGHOME="$(mktemp -d)" 

# Download JDBC library, verify
RUN wget -O /liquibase/lib/postgresql.jar https://repo1.maven.org/maven2/org/postgresql/postgresql/${PG_DRIVER_VERSION}/postgresql-${PG_DRIVER_VERSION}.jar \
	&& wget -O /liquibase/lib/postgresql.jar.asc https://repo1.maven.org/maven2/org/postgresql/postgresql/${PG_DRIVER_VERSION}/postgresql-${PG_DRIVER_VERSION}.jar.asc \
    && gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys 307A96FBA0292109 \
    && gpg --batch --verify -fSLo /liquibase/lib/postgresql.jar.asc /liquibase/lib/postgresql.jar

USER root

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

VOLUME /migrations
WORKDIR /migrations

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
