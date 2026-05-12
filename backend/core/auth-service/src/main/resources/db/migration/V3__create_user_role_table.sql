-- =============================================================
-- V3__create_user_role_table.sql
-- Crea la tabla de relación entre usuarios y roles.
-- Requerida después de: users (FK), roles (FK).
-- =============================================================

CREATE TABLE user_role (
  id UUID           PRIMARY KEY     DEFAULT gen_random_uuid(),
  user_id UUID      NOT NULL,
  role_id UUID      NOT NULL,
  
  CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  CONSTRAINT fk_role FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE
);