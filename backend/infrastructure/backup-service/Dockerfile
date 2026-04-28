FROM ubuntu:24.04

RUN apt-get update && apt-get install -y \
    postgresql-client \
    wget \
    gnupg \
    curl \
    cron \
  && wget -q https://fastdl.mongodb.org/tools/db/mongodb-database-tools-ubuntu2404-x86_64-100.10.0.deb \
  && apt-get install -y ./mongodb-database-tools-ubuntu2404-x86_64-100.10.0.deb \
  && rm mongodb-database-tools-ubuntu2404-x86_64-100.10.0.deb \
  && curl -L -o /usr/local/bin/mc https://dl.min.io/client/mc/release/linux-amd64/mc \
  && chmod +x /usr/local/bin/mc \
  && rm -rf  /var/lib/apt/lists/*

RUN mkdir -p /backups/tmp
COPY scripts/backup /scripts/
RUN chmod +x /scripts/*.sh

CMD ["/scripts/entrypoint.sh"]
  