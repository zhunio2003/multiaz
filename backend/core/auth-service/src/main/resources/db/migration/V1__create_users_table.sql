-- =============================================================
-- V1__create_users_table.sql
-- Crea la tabla principal de usuarios del sistema.
-- Gestiona exclusivamente la autenticación.
-- Requerida antes de: user_role (FK), password_reset_tokens (FK)
-- =============================================================

CREATE TABLE users (
  id            UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  name          VARCHAR(100)  NOT NULL,
  email         VARCHAR(320)  NOT NULL UNIQUE,
  password_hash VARCHAR(60)   NOT NULL,
  creation_date TIMESTAMP     NOT NULL DEFAULT NOW()
);