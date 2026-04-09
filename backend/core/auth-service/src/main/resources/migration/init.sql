CREATE SCHEMA IF NOT EXISTS auth;
SET search_path TO auth;

CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(100) NOT NULL,
  email VARCHAR(250) NOT NULL UNIQUE,
  password_hash VARCHAR(60) NOT NULL,
  creation_date TIMESTAMP NOT NULL DEFAULT NOW()  
);

CREATE TABLE roles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(100) NOT NULL
);

CREATE TABLE user_role (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  role_id UUID NOT NULL,

  CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  CONSTRAINT fk_role FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE
);

INSERT INTO roles(name) VALUES ('CUSTOMER'), ('COMPANY'),('ADMIN')