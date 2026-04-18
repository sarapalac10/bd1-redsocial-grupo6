  USE master;
GO

IF DB_ID('pascualina_db') IS NOT NULL
BEGIN
    ALTER DATABASE pascualina_db SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE pascualina_db;
END
GO

CREATE DATABASE pascualina_db;
GO

USE pascualina_db;
GO



-- ======================
-- TABLAS PRINCIPALES
-- ======================

CREATE TABLE usuario (
  id_usuario INT IDENTITY(1,1) PRIMARY KEY,
  nombre NVARCHAR(100),
  apellido NVARCHAR(100),
  email NVARCHAR(100) UNIQUE,
  contrasena NVARCHAR(255),
  fecha_registro DATETIME,
  foto_perfil NVARCHAR(255),
  biografia NVARCHAR(MAX),
  estado NVARCHAR(20)
);

CREATE TABLE programa_academico (
  id_programa INT IDENTITY(1,1) PRIMARY KEY,
  nombre NVARCHAR(100),
  facultad NVARCHAR(100),
  nivel NVARCHAR(50)
);

-- ======================
-- SUBTIPOS
-- ======================

CREATE TABLE estudiante (
  id_usuario INT PRIMARY KEY,
  codigo_estudiante NVARCHAR(50),
  semestre INT,
  id_programa INT,
  CONSTRAINT FK_estudiante_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE,
  CONSTRAINT FK_estudiante_programa FOREIGN KEY (id_programa) REFERENCES programa_academico(id_programa)
);

CREATE TABLE docente (
  id_usuario INT PRIMARY KEY,
  codigo_docente NVARCHAR(50),
  departamento NVARCHAR(100),
  especialidad NVARCHAR(100),
  CONSTRAINT FK_docente_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE
);

CREATE TABLE empleado (
  id_usuario INT PRIMARY KEY,
  codigo_empleado NVARCHAR(50),
  cargo NVARCHAR(100),
  dependencia NVARCHAR(100),
  CONSTRAINT FK_empleado_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE
);

CREATE TABLE egresado (
  id_usuario INT PRIMARY KEY,
  anio_egreso INT,
  empresa_actual NVARCHAR(100),
  cargo_actual NVARCHAR(100),
  CONSTRAINT FK_egresado_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE
);

CREATE TABLE publico_general (
  id_usuario INT PRIMARY KEY,
  ocupacion NVARCHAR(100),
  CONSTRAINT FK_publico_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE
);

-- ======================
-- HABILIDADES E INTERESES
-- ======================

CREATE TABLE habilidad (
  id_habilidad INT IDENTITY(1,1) PRIMARY KEY,
  nombre NVARCHAR(100),
  categoria NVARCHAR(50)
);

CREATE TABLE interes (
  id_interes INT IDENTITY(1,1) PRIMARY KEY,
  nombre NVARCHAR(100),
  categoria NVARCHAR(50)
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

-- ======================
-- SOCIAL
-- ======================

CREATE TABLE grupo (
  id_grupo INT IDENTITY(1,1) PRIMARY KEY,
  nombre NVARCHAR(100),
  descripcion NVARCHAR(MAX),
  fecha_creacion DATETIME,
  tipo NVARCHAR(50),
  visibilidad NVARCHAR(20),
  id_creador INT,
  FOREIGN KEY (id_creador) REFERENCES usuario(id_usuario)
);

CREATE TABLE publicacion (
  id_publicacion INT IDENTITY(1,1) PRIMARY KEY,
  contenido_texto NVARCHAR(MAX),
  contenido_multimedia NVARCHAR(MAX), -- Almacena JSON como texto
  fecha_publicacion DATETIME,
  tipo NVARCHAR(50),
  visibilidad NVARCHAR(20),
  id_usuario INT,
  id_grupo INT,
  FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
  FOREIGN KEY (id_grupo) REFERENCES grupo(id_grupo)
);

CREATE TABLE comentario (
  id_comentario INT IDENTITY(1,1) PRIMARY KEY,
  contenido NVARCHAR(MAX),
  fecha_comentario DATETIME,
  id_usuario INT,
  id_publicacion INT,
  id_padre INT,
  FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
  FOREIGN KEY (id_publicacion) REFERENCES publicacion(id_publicacion),
  -- Nota: No se puede usar ON DELETE CASCADE aquí por referencias circulares en SQL Server
  FOREIGN KEY (id_padre) REFERENCES comentario(id_comentario)
);

CREATE TABLE reaccion (
  id_reaccion INT IDENTITY(1,1) PRIMARY KEY,
  tipo_reaccion NVARCHAR(20),
  fecha DATETIME,
  id_usuario INT,
  id_publicacion INT,
  FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
  FOREIGN KEY (id_publicacion) REFERENCES publicacion(id_publicacion),
  CONSTRAINT UC_usuario_publicacion UNIQUE (id_usuario, id_publicacion)
);

CREATE TABLE seguimiento (
  id_seguidor INT,
  id_seguido INT,
  fecha_seguimiento DATETIME,
  PRIMARY KEY (id_seguidor, id_seguido),
  FOREIGN KEY (id_seguidor) REFERENCES usuario(id_usuario),
  FOREIGN KEY (id_seguido) REFERENCES usuario(id_usuario)
);

-- ======================
-- COMUNIDADES
-- ======================

CREATE TABLE miembro_grupo (
  id_usuario INT,
  id_grupo INT,
  rol NVARCHAR(20),
  fecha_ingreso DATETIME,
  PRIMARY KEY (id_usuario, id_grupo),
  FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
  FOREIGN KEY (id_grupo) REFERENCES grupo(id_grupo)
);

CREATE TABLE evento (
  id_evento INT IDENTITY(1,1) PRIMARY KEY,
  nombre NVARCHAR(100),
  descripcion NVARCHAR(MAX),
  fecha_inicio DATETIME,
  fecha_fin DATETIME,
  ubicacion NVARCHAR(255),
  tipo NVARCHAR(50),
  capacidad_maxima INT,
  id_grupo INT,
  FOREIGN KEY (id_grupo) REFERENCES grupo(id_grupo)
);

CREATE TABLE asistencia_evento (
  id_usuario INT,
  id_evento INT,
  estado NVARCHAR(20),
  fecha_registro DATETIME,
  PRIMARY KEY (id_usuario, id_evento),
  FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
  FOREIGN KEY (id_evento) REFERENCES evento(id_evento)
);

-- ======================
-- MARKETPLACE
-- ======================

CREATE TABLE producto (
  id_producto INT IDENTITY(1,1) PRIMARY KEY,
  nombre NVARCHAR(100),
  descripcion NVARCHAR(MAX),
  categoria NVARCHAR(50),
  estado NVARCHAR(20),
  tipo_intercambio NVARCHAR(20),
  precio DECIMAL(10,2),
  fecha_publicacion DATETIME,
  fotos NVARCHAR(MAX), -- JSON
  id_vendedor INT,
  FOREIGN KEY (id_vendedor) REFERENCES usuario(id_usuario)
);

CREATE TABLE intercambio (
  id_intercambio INT IDENTITY(1,1) PRIMARY KEY,
  id_producto INT,
  id_comprador INT,
  fecha DATETIME,
  estado NVARCHAR(20),
  FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
  FOREIGN KEY (id_comprador) REFERENCES usuario(id_usuario)
);

-- ======================
-- EMPLEO
-- ======================

CREATE TABLE empresa (
  id_empresa INT IDENTITY(1,1) PRIMARY KEY,
  nombre NVARCHAR(100),
  sector NVARCHAR(100),
  descripcion NVARCHAR(MAX),
  sitio_web NVARCHAR(255),
  contacto NVARCHAR(100)
);

CREATE TABLE oferta_laboral (
  id_oferta INT IDENTITY(1,1) PRIMARY KEY,
  titulo NVARCHAR(100),
  descripcion NVARCHAR(MAX),
  requisitos NVARCHAR(MAX), -- JSON
  salario DECIMAL(10,2),
  modalidad NVARCHAR(50),
  fecha_publicacion DATETIME,
  fecha_cierre DATETIME,
  id_empresa INT,
  FOREIGN KEY (id_empresa) REFERENCES empresa(id_empresa)
);

CREATE TABLE postulacion (
  id_usuario INT,
  id_oferta INT,
  fecha_postulacion DATETIME,
  estado NVARCHAR(20),
  cv_adjunto NVARCHAR(255),
  PRIMARY KEY (id_usuario, id_oferta),
  FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
  FOREIGN KEY (id_oferta) REFERENCES oferta_laboral(id_oferta)
);

-- ======================
-- COMUNICACIÓN
-- ======================

CREATE TABLE mensaje (
  id_mensaje INT IDENTITY(1,1) PRIMARY KEY,
  contenido NVARCHAR(MAX),
  fecha_envio DATETIME,
  leido BIT, -- SQL Server usa BIT para Boolean
  id_emisor INT,
  id_receptor INT,
  FOREIGN KEY (id_emisor) REFERENCES usuario(id_usuario),
  FOREIGN KEY (id_receptor) REFERENCES usuario(id_usuario)
);

CREATE TABLE notificacion (
  id_notificacion INT IDENTITY(1,1) PRIMARY KEY,
  tipo NVARCHAR(50),
  contenido NVARCHAR(MAX),
  fecha DATETIME,
  leida BIT,
  id_usuario INT,
  FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

CREATE TABLE reporte (
  id_reporte INT IDENTITY(1,1) PRIMARY KEY,
  motivo NVARCHAR(50),
  descripcion NVARCHAR(MAX),
  fecha DATETIME,
  estado NVARCHAR(20),
  id_reportante INT,
  FOREIGN KEY (id_reportante) REFERENCES usuario(id_usuario)
);
GO