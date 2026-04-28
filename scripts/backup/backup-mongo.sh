#!/bin/bash

MG_HOST="mongodb"
MG_USER=${MONGODB_USER}
MG_PASSWORD=${MONGODB_PASS}

DATABASES=("prediction-storage-details" "training" "logging-monitoring")

FECHA=$(date +%Y%m%d_%H%M%S)

for DB in "${DATABASES[@]}"; do
  
  mongodump --host $MG_HOST --username $MG_USER --password $MG_PASSWORD \
    --authenticationDatabase admin \
    --db $DB --out /backups/tmp/${DB}_${FECHA}

  if [ $? -ne 0 ] || [ ! -d "/backups/tmp/${DB}_${FECHA}" ] || [ -z "$(ls -A /backups/tmp/${DB}_${FECHA})" ] ; then
    echo "ERROR backup de $DB FALLO"
  else
    tar -czf /backups/${DB}_${FECHA}.tar.gz -C /backups/tmp ${DB}_${FECHA}
    rm -rf /backups/tmp/${DB}_${FECHA}
    echo "Backup de  $DB completado: /backups/${DB}_${FECHA}.tar.gz"
  fi
done

mc cp /backups/*.tar.gz multiaz/backups/

rm -f /backups/*.tar.gz 
