
-- PRIMERO: Creamos los datos base
INSERT INTO rol (nombre_rol) VALUES ('Usuario Estándar');
INSERT INTO tipo_usuario (nombre_tipo) VALUES ('Estudiante');

-- SEGUNDO: Creamos al usuario
INSERT INTO usuario (nombre, apellido, email, id_rol, id_tipo_usuario) 
VALUES ('Pascual', 'Bravo', 'pascual@correo.com', 1, 1);

-- TERCERO: Creamos el perfil (Sin esto, el código JSON sale en 0)
INSERT INTO perfil (id_usuario, biografia) 
VALUES (1, 'Estudiante de la Red Social Pascualina');