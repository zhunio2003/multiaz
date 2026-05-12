-- =============================================================
-- V2__create_roles_table.sql
-- Crea la tabla para los roles del sistema.
-- Establece los 3 únicos roles existentes en el sistema,
-- Requerida antes de: user_role (FK).
-- =============================================================

CREATE TABLE roles (
  id    UUID            PRIMARY KEY     DEFAULT gen_random_uuid(),
  name  VARCHAR(100)    NOT NULL
);

-- Seed: 3 roles únicos
INSERT INTO roles(name) VALUES 
    ('CUSTOMER'), 
    ('COMPANY'),
    ('ADMIN');