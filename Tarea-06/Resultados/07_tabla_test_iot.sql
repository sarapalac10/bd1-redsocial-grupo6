CREATE TABLE IF NOT EXISTS usuario_test (
    id_test SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    email VARCHAR(100),
    universidad VARCHAR(100),
    telemetria_salud JSONB
);