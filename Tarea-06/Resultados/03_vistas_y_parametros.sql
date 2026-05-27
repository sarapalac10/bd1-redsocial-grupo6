
-- Consulta 1: Grupos y creadores
SELECT g.id_grupo, g.nombre AS nombre_grupo, u.nombre AS creador
FROM grupo g JOIN usuario u ON g.id_creador = u.id_usuario;

-- Consulta 2: Eventos por tipo
SELECT te.descripcion_evento, COUNT(e.id_evento) AS total_eventos
FROM tipo_evento te JOIN evento e ON te.id_tipo_evento = e.id_tipo_evento
GROUP BY te.descripcion_evento;

-- Consulta 3: Estudiantes por programa
SELECT pa.nombre, COUNT(e.id_usuario) AS total_estudiantes
FROM programa_academico pa JOIN estudiante e ON pa.id_programa = e.id_programa
GROUP BY pa.nombre;

-- Consulta 4: Productos (Top 20 por precio)
SELECT nombre, precio FROM producto ORDER BY precio DESC LIMIT 20;

-- Consulta 5: Estadísticas generales de productos
SELECT COUNT(*) AS total, AVG(precio) AS promedio, MAX(precio) AS maximo FROM producto;

-- Consulta 6: Publicaciones por grupo
SELECT g.nombre, COUNT(p.id_publicacion) AS posts
FROM grupo g JOIN publicacion p ON g.id_grupo = p.id_grupo
GROUP BY g.nombre;