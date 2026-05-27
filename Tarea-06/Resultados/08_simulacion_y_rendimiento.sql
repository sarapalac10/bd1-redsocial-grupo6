-- 1. Cambiamos el procedimiento por una función
CREATE OR REPLACE FUNCTION simular_ingesta_iot_func(cantidad INT) 
RETURNS void AS $$
BEGIN
    INSERT INTO usuario_test (nombre, email, universidad, telemetria_salud)
    SELECT 'User_' || i, 'email' || i || '@test.com', 'Pascual Bravo', 
    jsonb_build_object('presion', '120/80', 'temp', 36.5, 'fecha', current_date)
    FROM generate_series(1, cantidad) AS i;
END; $$ LANGUAGE plpgsql;

-- 2. Ahora sí puedes usar EXPLAIN ANALYZE
EXPLAIN ANALYZE SELECT simular_ingesta_iot_func(1000);