DROP TABLE IF EXISTS postulacion CASCADE;
DROP TABLE IF EXISTS oferta_laboral CASCADE;
DROP TABLE IF EXISTS empresa CASCADE;
DROP TABLE IF EXISTS intercambio CASCADE;
DROP TABLE IF EXISTS producto CASCADE;
DROP TABLE IF EXISTS asistencia_evento CASCADE;
DROP TABLE IF EXISTS evento CASCADE;
DROP TABLE IF EXISTS miembro_grupo CASCADE;
DROP TABLE IF EXISTS seguimiento CASCADE;
DROP TABLE IF EXISTS reaccion CASCADE;
DROP TABLE IF EXISTS comentario CASCADE;
DROP TABLE IF EXISTS publicacion CASCADE;
DROP TABLE IF EXISTS grupo CASCADE;
DROP TABLE IF EXISTS usuario_interes CASCADE;
DROP TABLE IF EXISTS usuario_habilidad CASCADE;
DROP TABLE IF EXISTS interes CASCADE;
DROP TABLE IF EXISTS habilidad CASCADE;
DROP TABLE IF EXISTS egresado CASCADE;
DROP TABLE IF EXISTS empleado CASCADE;
DROP TABLE IF EXISTS docente CASCADE;
DROP TABLE IF EXISTS estudiante CASCADE;
DROP TABLE IF EXISTS programa_academico CASCADE;
DROP TABLE IF EXISTS mensaje CASCADE;
DROP TABLE IF EXISTS notificacion CASCADE;
DROP TABLE IF EXISTS reporte CASCADE;
DROP TABLE IF EXISTS asignatura CASCADE;
DROP TABLE IF EXISTS usuario CASCADE;
DROP TABLE IF EXISTS publico_general CASCADE;
-- =========================
-- CREACIÓN DE TABLAS
-- =========================

-- 🔹 USUARIOS
CREATE TABLE usuario (
    id_usuario SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    contrasena VARCHAR(255),
    fecha_registro TIMESTAMP,
    foto_perfil VARCHAR(255),
    biografia TEXT,
    estado VARCHAR(20)
);

CREATE TABLE programa_academico (
    id_programa SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    facultad VARCHAR(100),
    nivel VARCHAR(50)
);

-- Subtipos
CREATE TABLE estudiante (
    id_usuario INT PRIMARY KEY,
    codigo_estudiante VARCHAR(50),
    semestre INT,
    id_programa INT,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_programa) REFERENCES programa_academico(id_programa)
);

CREATE TABLE docente (
    id_usuario INT PRIMARY KEY,
    codigo_docente VARCHAR(50),
    departamento VARCHAR(100),
    especialidad VARCHAR(100),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE
);

CREATE TABLE empleado (
    id_usuario INT PRIMARY KEY,
    codigo_empleado VARCHAR(50),
    cargo VARCHAR(100),
    dependencia VARCHAR(100),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE
);

CREATE TABLE egresado (
    id_usuario INT PRIMARY KEY,
    anio_egreso INT,
    empresa_actual VARCHAR(100),
    cargo_actual VARCHAR(100),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE
);

CREATE TABLE publico_general (
    id_usuario INT PRIMARY KEY,
    ocupacion VARCHAR(100),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE
);

-- 🔹 HABILIDADES E INTERESES
CREATE TABLE habilidad (
    id_habilidad SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    categoria VARCHAR(50)
);

CREATE TABLE interes (
    id_interes SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    categoria VARCHAR(50)
);

CREATE TABLE usuario_habilidad (
    id_usuario INT,
    id_habilidad INT,
    PRIMARY KEY (id_usuario, id_habilidad),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_habilidad) REFERENCES habilidad(id_habilidad)
);

CREATE TABLE usuario_interes (
    id_usuario INT,
    id_interes INT,
    PRIMARY KEY (id_usuario, id_interes),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_interes) REFERENCES interes(id_interes)
);

-- 🔹 SOCIAL
CREATE TABLE grupo (
    id_grupo SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    descripcion TEXT,
    fecha_creacion TIMESTAMP,
    tipo VARCHAR(50),
    visibilidad VARCHAR(20),
    id_creador INT,
    FOREIGN KEY (id_creador) REFERENCES usuario(id_usuario)
);

CREATE TABLE publicacion (
    id_publicacion SERIAL PRIMARY KEY,
    contenido_texto TEXT,
    contenido_multimedia JSONB,
    fecha_publicacion TIMESTAMP,
    tipo VARCHAR(50),
    visibilidad VARCHAR(20),
    id_usuario INT,
    id_grupo INT,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_grupo) REFERENCES grupo(id_grupo)
);

CREATE TABLE comentario (
    id_comentario SERIAL PRIMARY KEY,
    contenido TEXT,
    fecha_comentario TIMESTAMP,
    id_usuario INT,
    id_publicacion INT,
    id_padre INT,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_publicacion) REFERENCES publicacion(id_publicacion),
    FOREIGN KEY (id_padre) REFERENCES comentario(id_comentario)
);

CREATE TABLE reaccion (
    id_reaccion SERIAL PRIMARY KEY,
    tipo_reaccion VARCHAR(20),
    fecha TIMESTAMP,
    id_usuario INT,
    id_publicacion INT,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_publicacion) REFERENCES publicacion(id_publicacion),
    UNIQUE (id_usuario, id_publicacion)
);

CREATE TABLE seguimiento (
    id_seguidor INT,
    id_seguido INT,
    fecha_seguimiento TIMESTAMP,
    PRIMARY KEY (id_seguidor, id_seguido),
    FOREIGN KEY (id_seguidor) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_seguido) REFERENCES usuario(id_usuario)
);

-- 🔹 COMUNIDADES
CREATE TABLE miembro_grupo (
    id_usuario INT,
    id_grupo INT,
    rol VARCHAR(20),
    fecha_ingreso TIMESTAMP,
    PRIMARY KEY (id_usuario, id_grupo),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_grupo) REFERENCES grupo(id_grupo)
);

CREATE TABLE evento (
    id_evento SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    descripcion TEXT,
    fecha_inicio TIMESTAMP,
    fecha_fin TIMESTAMP,
    ubicacion VARCHAR(255),
    tipo VARCHAR(50),
    capacidad_maxima INT,
    id_grupo INT,
    FOREIGN KEY (id_grupo) REFERENCES grupo(id_grupo)
);

CREATE TABLE asistencia_evento (
    id_usuario INT,
    id_evento INT,
    estado VARCHAR(20),
    fecha_registro TIMESTAMP,
    PRIMARY KEY (id_usuario, id_evento),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_evento) REFERENCES evento(id_evento)
);

-- 🔹 MARKETPLACE
CREATE TABLE producto (
    id_producto SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    descripcion TEXT,
    categoria VARCHAR(50),
    estado VARCHAR(20),
    tipo_intercambio VARCHAR(20),
    precio DECIMAL(10,2),
    fecha_publicacion TIMESTAMP,
    fotos JSONB,
    id_vendedor INT,
    FOREIGN KEY (id_vendedor) REFERENCES usuario(id_usuario)
);

CREATE TABLE intercambio (
    id_intercambio SERIAL PRIMARY KEY,
    id_producto INT,
    id_comprador INT,
    fecha TIMESTAMP,
    estado VARCHAR(20),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
    FOREIGN KEY (id_comprador) REFERENCES usuario(id_usuario)
);

-- 🔹 EMPLEO
CREATE TABLE empresa (
    id_empresa SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    sector VARCHAR(100),
    descripcion TEXT,
    sitio_web VARCHAR(255),
    contacto VARCHAR(100)
);

CREATE TABLE oferta_laboral (
    id_oferta SERIAL PRIMARY KEY,
    titulo VARCHAR(100),
    descripcion TEXT,
    requisitos JSONB,
    salario DECIMAL(10,2),
    modalidad VARCHAR(50),
    fecha_publicacion TIMESTAMP,
    fecha_cierre TIMESTAMP,
    id_empresa INT,
    FOREIGN KEY (id_empresa) REFERENCES empresa(id_empresa)
);

CREATE TABLE postulacion (
    id_usuario INT,
    id_oferta INT,
    fecha_postulacion TIMESTAMP,
    estado VARCHAR(20),
    cv_adjunto VARCHAR(255),
    PRIMARY KEY (id_usuario, id_oferta),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_oferta) REFERENCES oferta_laboral(id_oferta)
);

-- 🔹 COMUNICACIÓN
CREATE TABLE mensaje (
    id_mensaje SERIAL PRIMARY KEY,
    contenido TEXT,
    fecha_envio TIMESTAMP,
    leido BOOLEAN,
    id_emisor INT,
    id_receptor INT,
    FOREIGN KEY (id_emisor) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_receptor) REFERENCES usuario(id_usuario)
);

CREATE TABLE notificacion (
    id_notificacion SERIAL PRIMARY KEY,
    tipo VARCHAR(50),
    contenido TEXT,
    fecha TIMESTAMP,
    leida BOOLEAN,
    id_usuario INT,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

CREATE TABLE reporte (
    id_reporte SERIAL PRIMARY KEY,
    motivo VARCHAR(50),
    descripcion TEXT,
    fecha TIMESTAMP,
    estado VARCHAR(20),
    id_reportante INT,
    FOREIGN KEY (id_reportante) REFERENCES usuario(id_usuario)
);

-- =========================
-- MODIFICACIONES (DDL)
-- =========================

ALTER TABLE usuario ADD COLUMN telefono VARCHAR(20);
ALTER TABLE usuario ALTER COLUMN nombre TYPE VARCHAR(150);

CREATE TABLE curso (
    id_curso SERIAL PRIMARY KEY
);

ALTER TABLE curso
ADD COLUMN nombre VARCHAR(100),
ADD COLUMN creditos INT,
ADD COLUMN descripcion TEXT;

ALTER TABLE curso DROP COLUMN descripcion;
ALTER TABLE curso RENAME TO asignatura;

ALTER TABLE asignatura
ADD COLUMN codigo VARCHAR(20) UNIQUE;

ALTER TABLE asignatura
ADD COLUMN fecha_inicio DATE,
ADD COLUMN fecha_fin DATE,
ADD CONSTRAINT chk_fechas CHECK (fecha_fin >= fecha_inicio);

ALTER TABLE asignatura
ADD COLUMN cupos INT,
ADD CONSTRAINT chk_cupos CHECK (cupos >= 0);

ALTER TABLE asignatura
ALTER COLUMN nombre TYPE VARCHAR(200);

ALTER TABLE asignatura
ADD CONSTRAINT chk_creditos CHECK (creditos BETWEEN 1 AND 10);

CREATE INDEX idx_nombre_asignatura ON asignatura(nombre);

ALTER TABLE asignatura DROP COLUMN fecha_fin;

TRUNCATE TABLE asignatura;