#!/bin/bash

set -e

psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" --dbname "postgres" <<-EOSQL
    CREATE DATABASE auth;
    CREATE DATABASE model_registry;
    CREATE DATABASE prediction_orchestrator;

EOSQL