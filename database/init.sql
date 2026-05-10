-- Extensiones necesarias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Tipos ENUM para estados
CREATE TYPE account_state AS ENUM ('Activo', 'Inactivo', 'Bloqueado');
CREATE TYPE audit_state AS ENUM ('Aprobado', 'Bloqueado', 'Revision Pendiente', 'Bajo Revision');

-- Tabla de Cuentas
CREATE TABLE IF NOT EXISTS account (
    id BIGSERIAL PRIMARY KEY,
    uuid UUID DEFAULT uuid_generate_v4() NOT NULL UNIQUE,
    user_name TEXT NOT NULL UNIQUE,
    user_info JSONB NOT NULL, -- {name, dui, date_birth, house_location}
    state account_state DEFAULT 'Activo'
);

-- Tabla de Transacciones (Historial general)
CREATE TABLE IF NOT EXISTS transaction (
    id BIGSERIAL PRIMARY KEY,
    account_id BIGINT REFERENCES account(id),
    ip INET NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    country TEXT NOT NULL,
    timestamp TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Transacciones Marcadas (Para la Consola de Auditoría)
-- Cumple con el criterio de "Revisión Manual"
CREATE TABLE IF NOT EXISTS flagged_transaction (
    id BIGSERIAL PRIMARY KEY,
    transaction_id BIGINT REFERENCES transaction(id),
    amount DECIMAL(10,2) NOT NULL,
    anomaly TEXT NOT NULL, -- Ej: "Alta Frecuencia", "Monto Inusual"
    country TEXT NOT NULL,
    state audit_state DEFAULT 'Revision Pendiente',
    timestamp TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Registros de Seguridad
-- Cumple con el criterio de log de acceso no autorizado
CREATE TABLE IF NOT EXISTS security_logs (
    id BIGSERIAL PRIMARY KEY,
    ip INET NOT NULL,
    details JSONB NOT NULL, -- {attempted_user, reason}
    state TEXT NOT NULL,
    timestamp TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);