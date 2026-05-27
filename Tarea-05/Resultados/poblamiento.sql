-- Llenado de datos
INSERT INTO rol (nombre_rol) VALUES ('administrador'), ('miembro');
INSERT INTO tipo_usuario (nombre_tipo) VALUES ('estudiante'), ('docente');

INSERT INTO usuario (nombre, apellido, email, id_rol, id_tipo_usuario, perfil_usuario)
VALUES ('Andres', 'Bravo', 'andres@pascual.edu.co', 1, 1, '{"intereses": ["Postgres", "IA"]}');

INSERT INTO perfil (id_usuario, biografia) VALUES (1, 'Usuario de prueba final.');