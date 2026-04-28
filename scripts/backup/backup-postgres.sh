#!/bin/bash

PG_HOST="postgresql"
PG_USER=${POSTGRESQL_USER}
PG_PASSWORD=${POSTGRESQL_PASS}

DATABASES=("auth" "model-registry" "scheduler" "prediction-storage" "dataset-management" "notification")

FECHA=$(date +%Y%m%d_%H%M%S)


for DB in "${DATABASES[@]}"; do
  PGPASSWORD=$PG_PASSWORD pg_dump -h $PG_HOST -U $PG_USER -d $DB | gzip > /backups/${DB}_${FECHA}.sql.gz
  if [ ${PIPESTATUS[0]} -ne 0 ]; then 
    echo "ERROR backup de $DB FALLO"
  else 
    echo "Backup de  $DB completado: /backups/${DB}_${FECHA}.sql.gz"
  fi
done