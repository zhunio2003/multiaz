#!/bin/bash

mc alias set multiaz http://minio:9000 ${MINIO_USER} ${MINIO_PASS}

mc mb --ignore-existing multiaz/backups

echo "0 0 * * * /scripts/backup-postgres.sh >> /var/log/backup.log 2>&1
0 0 * * * /scripts/backup-mongo.sh >> /var/log/backup.log 2>&1 " | crontab -

/scripts/backup-postgres.sh
/scripts/backup-mongo.sh

cron -f
