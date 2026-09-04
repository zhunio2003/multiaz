#!/bin/bash

# =============================================================================
# init-databases.sh
# =============================================================================
# Descripción  : Script de inicialización de bases de datos PostgreSQL
# Proyecto     : MultIAZ
# Autor        : Miguel Angel Zhunio Remache
# Versión      : 2.0.0
# =============================================================================
# IMPORTANTE: Este script se ejecuta UNA SOLA VEZ cuando el contenedor
# PostgreSQL arranca con un volumen vacío (docker-entrypoint-initdb.d/).
# Para re-ejecutarlo, elimina el volumen: docker volume rm vol-postgresql
#
# Por cada servicio <svc> se crea:
#   - base de datos  <svc>_db
#   - usuario        <svc>_user
#   - contraseña     leída de POSTGRES_<SVC>_PASS
# =============================================================================

set -euo pipefail

SERVICES=(
    "auth"
    "model_registry"
    "prediction_orchestrator"
    "scheduler"
    "dataset_management"
    "notification"
)

for svc in "${SERVICES[@]}"; do

    db="${svc}_db"
    user="${svc}_user"
    pass_var="POSTGRES_${svc^^}_PASS"   # auth -> POSTGRES_AUTH_PASS
    pass="${!pass_var}"                 # con set -u, falla si no está definida

    echo "==> Creando ${db} / ${user}"

    # Base de datos, usuario y permisos sobre la base
    psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" --dbname "postgres" \
        -v db="${db}" -v user="${user}" -v pass="${pass}" <<'EOSQL'
CREATE DATABASE :"db";
CREATE USER :"user" WITH PASSWORD :'pass';
GRANT ALL PRIVILEGES ON DATABASE :"db" TO :"user";
EOSQL

    # Permisos sobre el esquema public (necesario desde PostgreSQL 15)
    psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" --dbname "${db}" \
        -v user="${user}" <<'EOSQL'
GRANT ALL ON SCHEMA public TO :"user";
EOSQL

done

echo "==> Inicialización completada"