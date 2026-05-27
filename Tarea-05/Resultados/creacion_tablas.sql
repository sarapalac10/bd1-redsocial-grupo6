-- ==========================================
-- 1. LIMPIEZA TOTAL (DROP)
-- Borramos de las más "pequeñas" a las más "grandes" por las llaves foráneas
-- ==========================================
DROP TABLE IF EXISTS producto, evento, publicacion, grupo CASCADE;
DROP TABLE IF EXISTS estudiante, programa_academico, perfil CASCADE;
DROP TABLE IF EXISTS usuario, tipo_evento, tipo_usuario, rol CASCADE;

-- ==========================================
-- 2. TABLAS DE CATÁLOGO (OBLIGATORIAS)
-- ==========================================
CREATE TABLE rol (
    id_rol SERIAL PRIMARY KEY,
    nombre_rol VARCHAR(50) NOT NULL
);

CREATE TABLE tipo_usuario (
    id_tipo_usuario SERIAL PRIMARY KEY,
    nombre_tipo VARCHAR(50) NOT NULL
);

CREATE TABLE tipo_evento (
    id_tipo_evento SERIAL PRIMARY KEY,
    descripcion_evento VARCHAR(100) NOT NULL
);

-- ==========================================
-- 3. ENTIDAD PRINCIPAL: USUARIO
-- ==========================================
CREATE TABLE usuario (
    id_usuario SERIAL PRIMARY KEY,
    nombre VARCHAR(150),
    apellido VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    contrasena VARCHAR(255),
    id_rol INT REFERENCES rol(id_rol), 
    id_tipo_usuario INT REFERENCES tipo_usuario(id_tipo_usuario),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    foto_perfil VARCHAR(255),
    biografia TEXT,
    estado VARCHAR(20),
    telefono VARCHAR(20),
    perfil_usuario JSONB -- Requisito Big Data
);

-- (Aquí sigues con el resto de tus tablas: perfil, programa, estudiante, etc.)

-- 4. TABLA PERFIL (REQUISITO GUÍA)
CREATE TABLE perfil (
    id_perfil SERIAL PRIMARY KEY,
    id_usuario INT REFERENCES usuario(id_usuario) ON DELETE CASCADE,
    biografia TEXT,
    preferencias JSONB,
    ultima_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. ACADEMIA Y SUBTIPOS
CREATE TABLE programa_academico (
    id_programa SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    facultad VARCHAR(100),
    nivel VARCHAR(50)
);

CREATE TABLE estudiante (
    id_usuario INT PRIMARY KEY REFERENCES usuario(id_usuario) ON DELETE CASCADE,
    codigo_estudiante VARCHAR(50),
    semestre INT,
    id_programa INT REFERENCES programa_academico(id_programa)
);

-- (Aquí sigues con Docente, Empleado, etc., usando la misma lógica de REFERENCES)

-- 6. SOCIAL Y COMUNIDADES
CREATE TABLE grupo (
    id_grupo SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    descripcion TEXT,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_creador INT REFERENCES usuario(id_usuario)
);

CREATE TABLE publicacion (
    id_publicacion SERIAL PRIMARY KEY,
    contenido_texto TEXT,
    contenido_multimedia JSONB,
    fecha_publicacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_usuario INT REFERENCES usuario(id_usuario),
    id_grupo INT REFERENCES grupo(id_grupo)
);

-- 7. EVENTOS
CREATE TABLE evento (
    id_evento SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    id_tipo_evento INT REFERENCES tipo_evento(id_tipo_evento),
    fecha_inicio TIMESTAMP,
    ubicacion VARCHAR(255),
    id_grupo INT REFERENCES grupo(id_grupo)
);

-- 8. MARKETPLACE
CREATE TABLE producto (
    id_producto SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    precio DECIMAL(10,2),
    especificaciones JSONB, -- Requisito Big Data
    id_vendedor INT REFERENCES usuario(id_usuario)
);