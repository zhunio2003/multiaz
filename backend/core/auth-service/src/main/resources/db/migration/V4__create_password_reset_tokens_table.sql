-- =============================================================
-- V4__create_password_reset_tokens_table.sql
-- Crea la tabla de tokens para recuperación de contraseña.
-- Requerida después de: users (FK).
-- =============================================================

CREATE TABLE password_reset_tokens (
  token_hash  VARCHAR(64)   NOT NULL PRIMARY KEY,
  user_id     UUID          NOT NULL,
  expiration  TIMESTAMP     NOT NULL,
  used        BOOLEAN       NOT NULL DEFAULT false,
  CONSTRAINT fk_user_refresh_token FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);