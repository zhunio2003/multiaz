#!/bin/bash

# =============================================================================
# init-databases.sh
# =============================================================================
# Descripción  : Script de inicialización de bases de datos PostgreSQL
# Proyecto     : MultIAZ
# Autor        : Miguel Angel Zhunio Remache
# Versión      : 1.2.0
# =============================================================================
# IMPORTANTE: Este script se ejecuta UNA SOLA VEZ cuando el contenedor
# PostgreSQL arranca con un volumen vacío (docker-entrypoint-initdb.d/).
# Para re-ejecutarlo, elimina el volumen: docker volume rm vol-postgresql
# =============================================================================

set -e

psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" --dbname "postgres" <<-EOSQL

    -- ==========================================
    -- Databases
    -- ==========================================
    CREATE DATABASE auth_db;
    CREATE DATABASE model_registry_db;
    CREATE DATABASE prediction_orchestrator_db;
    CREATE DATABASE scheduler_db;
    CREATE DATABASE dataset_management_db;
    CREATE DATABASE notification_db;

    -- ==========================================
    -- Users  
    -- ==========================================
    CREATE USER auth_user WITH PASSWORD '${POSTGRES_AUTH_PASS}';
    CREATE USER model_registry_user WITH PASSWORD '${POSTGRES_MODEL_REGISTRY_PASS}';
    CREATE USER prediction_orchestrator_user WITH PASSWORD '${POSTGRES_PREDICTION_ORCHESTRATOR_PASS}';
    CREATE USER scheduler_user WITH PASSWORD '${POSTGRES_SCHEDULER_PASS}';
    CREATE USER dataset_management_user WITH PASSWORD '${POSTGRES_DATASET_MANAGEMENT_PASS}';
    CREATE USER notification_user WITH PASSWORD '${POSTGRES_NOTIFICATION_PASS}';

    -- ==========================================
    -- Grants
    -- ==========================================
    GRANT ALL PRIVILEGES ON DATABASE auth_db TO auth_user;
    GRANT ALL PRIVILEGES ON DATABASE model_registry_db TO model_registry_user;
    GRANT ALL PRIVILEGES ON DATABASE prediction_orchestrator_db TO prediction_orchestrator_user;
    GRANT ALL PRIVILEGES ON DATABASE scheduler_db TO scheduler_user;
    GRANT ALL PRIVILEGES ON DATABASE dataset_management_db TO dataset_management_user;
    GRANT ALL PRIVILEGES ON DATABASE notification_db TO notification_user;

EOSQL

## ==========================================
## Grants all on schema public
## ==========================================

psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" --dbname "auth_db" <<-EOSQL
    GRANT ALL ON SCHEMA public TO auth_user;
EOSQL

psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" --dbname "model_registry_db" <<-EOSQL
    GRANT ALL ON SCHEMA public TO model_registry_user;
EOSQL

psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" --dbname "prediction_orchestrator_db" <<-EOSQL
    GRANT ALL ON SCHEMA public TO prediction_orchestrator_user;
EOSQL

psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" --dbname "scheduler_db" <<-EOSQL
    GRANT ALL ON SCHEMA public TO scheduler_user;
EOSQL

psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" --dbname "dataset_management_db" <<-EOSQL
    GRANT ALL ON SCHEMA public TO dataset_management_user;
EOSQL

psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" --dbname "notification_db" <<-EOSQL
    GRANT ALL ON SCHEMA public TO notification_user;
EOSQL