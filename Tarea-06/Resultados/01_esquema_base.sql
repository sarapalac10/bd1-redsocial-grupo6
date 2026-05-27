 CREATE OR REPLACE VIEW vista_actividad_economica AS
SELECT 
    u.id_usuario, 
    u.nombre,            -- En tu tabla es 'nombre', no 'nombre_usuario'
    u.email,             -- Usamos email como identificador adicional
    COUNT(p.id_producto) AS total_productos_venta,
    SUM(p.precio) AS monto_total_inventario
FROM usuario u
JOIN producto p ON u.id_usuario = p.id_vendedor
GROUP BY u.id_usuario, u.nombre, u.email;

-- 2.- Preparar la consulta (utilizando la vista)
-- $1: Filtro por nombre de usuario (Búsqueda parcial con LIKE)
-- $2: Filtro por monto mínimo de inventario (HAVING)
PREPARE consulta_consejo_pascualina(text, numeric) AS
SELECT * FROM vista_actividad_economica
WHERE nombre LIKE $1
GROUP BY id_usuario, nombre, email, total_productos_venta, monto_total_inventario
HAVING monto_total_inventario > $2;

-- 3.- Ejecutar 3 consultas con diferentes parámetros (EXECUTE)
-- Nota: Usamos '%' para que busque coincidencias en el nombre
EXECUTE consulta_consejo_pascualina('%Juan%', 100.00);
EXECUTE consulta_consejo_pascualina('%Maria%', 50.00);
EXECUTE consulta_consejo_pascualina('%', 10.00); -- Trae todos los que superen 10.00