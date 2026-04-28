#!/bin/bash

mc alias set multiaz http://minio:9000 ${MINIO_USER} ${MINIO_PASS}

/scripts/backup-postgres.sh
/scripts/backup-mongo.sh

mc cp /backups/*.sql.gz multiaz/backups/
mc cp /backups/*.tar.gz multiaz/backups/

rm -f /backups/*.sql.gz 
rm -f /backups/*.tar.gz 
