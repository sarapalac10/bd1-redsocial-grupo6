-- 1. Crear la Vista (Adaptada a tus tablas 'usuario' y 'producto')
CREATE OR REPLACE VIEW vista_actividad_economica AS
SELECT 
    u.id_usuario, 
    u.nombre, 
    u.email,
    COUNT(p.id_producto) AS total_productos,
    SUM(p.precio) AS monto_total_inventario
FROM usuario u
JOIN producto p ON u.id_usuario = p.id_vendedor
GROUP BY u.id_usuario, u.nombre, u.email;

-- 2. Preparar la consulta
PREPARE consulta_consejo_pascualina(text, numeric) AS
SELECT * FROM vista_actividad_economica
WHERE nombre LIKE $1
GROUP BY id_usuario, nombre, email, total_productos, monto_total_inventario
HAVING monto_total_inventario > $2;

-- 3. Ejecutar ejemplos
EXECUTE consulta_consejo_pascualina('%', 100.00);
EXECUTE consulta_consejo_pascualina('%A%', 500.00);