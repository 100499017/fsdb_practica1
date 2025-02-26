DROP TABLE bibuses;
DROP TABLE bibuseros;
DROP TABLE rutas;
DROP TABLE municipios;
DROP TABLE bibliotecas;
DROP TABLE usuarios;
DROP TABLE libros;
DROP TABLE ediciones;
DROP TABLE ejemplares;
DROP TABLE prestamos;
DROP TABLE reservas;
DROP TABLE sanciones;

-- COMPLETADA
CREATE TABLE bibuses (
  matricula VARCHAR(10) NOT NULL,
  estado VARCHAR(20) NOT NULL,
  pasaporte_bibusero VARCHAR(20) NOT NULL,
  PRIMARY KEY matricula,
  FOREIGN KEY (pasaporte_bibusero) REFERENCES bibuseros(pasaporte),
  CONSTRAINT ck_estado CHECK (estado IN ('disponible', 'en ruta', 'en revision'))
);

CREATE TABLE paradas (
  id INT AUTO_INCREMENT,
  PRIMARY KEY id
)

-- COMPLETADA
CREATE TABLE bibuseros (
  pasaporte VARCHAR(20) NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  apellidos VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL,
  telefono VARCHAR(20) NOT NULL,
  inicio_contrato DATE NOT NULL,
  fin_contrato DATE,
  estado VARCHAR(20) NOT NULL,
  matricula_bibus VARCHAR(10),
  PRIMARY KEY pasaporte,
  FOREIGN KEY (matricula_bibus) REFERENCES bibuses(matricula),
  CONSTRAINT ck_estado CHECK (estado IN ('en ruta', 'en descanso', 'sin ruta'))
);

-- COMPLETADA
CREATE TABLE rutas (
  id INT AUTO_INCREMENT NOT NULL,
  paradas VARCHAR(200) NOT NULL,
  fecha DATE NOT NULL,
  matricula_bibus VARCHAR(10) NOT NULL,
  PRIMARY KEY id,
  FOREIGN KEY (matricula_bibus) REFERENCES bibuses(matricula)
);

CREATE TABLE municipios (
  nombre VARCHAR(100) NOT NULL,
  poblacion VARCHAR(100) NOT NULL,
  biblioteca_cif VARCHAR(20) UNIQUE,
  PRIMARY KEY (nombre, poblacion),
  FOREIGN KEY (biblioteca_cif) REFERENCES bibliotecas(cif)
);

-- COMPLETADA
CREATE TABLE bibliotecas (
  cif VARCHAR(20) NOT NULL,
  nombre VARCHAR(150) NOT NULL,
  fecha_fundacion DATE NOT NULL,
  nombre_municipio VARCHAR(100) NOT NULL,
  poblacion_municipio VARCHAR(100) NOT NULL,
  direccion VARCHAR(200) NOT NULL,
  email VARCHAR(100) NOT NULL,
  telefono VARCHAR(20) NOT NULL,
  PRIMARY KEY cif,
  FOREIGN KEY (nombre_municipio, poblacion_municipio) REFERENCES municipios(nombre, poblacion)
);

CREATE TABLE usuarios (
  pasaporte VARCHAR(20) NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  apellidos VARCHAR(100),
  fecha_nacimiento DATE,
  nombre_municipio VARCHAR(100),
  direccion VARCHAR(200),
  email VARCHAR(100),
  telefono VARCHAR(20),
  PRIMARY KEY pasaporte,
  FOREIGN KEY (nombre_municipio) REFERENCES municipios(nombre)
);

-- COMPLETADA
CREATE TABLE libros (
  titulo VARCHAR(200) NOT NULL,
  autor_principal VARCHAR(150) NOT NULL,
  pais_publicacion VARCHAR(50) NOT NULL,
  lengua_original VARCHAR(50) NOT NULL,
  fecha_publicacion DATE NOT NULL,
  titulos_alternativos VARCHAR(200),
  tema VARCHAR(100),
  nota_contenido VARCHAR(500),
  premios VARCHAR(200),
  mencion_autores VARCHAR(500),
  PRIMARY KEY (titulo, autor_principal)
);

CREATE TABLE ediciones (
  isbn VARCHAR(20) NOT NULL,
  titulo VARCHAR(200) NOT NULL,
  autor_principal VARCHAR(150) NOT NULL,
  lengua_principal VARCHAR(50) NOT NULL,
  otras_lenguas VARCHAR(200),
  edicion INT NOT NULL NOT NULL,
  editorial VARCHAR(100) NOT NULL,
  deposito_legal VARCHAR(50) NOT NULL,
  lugar_publicacion VARCHAR(100) NOT NULL,
  dimensiones VARCHAR(50) NOT NULL,
  id_biblioteca_nacional INT NOT NULL,
  url_edicion VARCHAR(200) NOT NULL,
  PRIMARY KEY isbn,
  FOREIGN KEY (titulo, autor_principal) REFERENCES libros(titulo, autor_principal)
);

-- COMPLETADA
CREATE TABLE ejemplares (
  signatura VARCHAR(20) NOT NULL,
  isbn_edicion VARCHAR(20) NOT NULL,
  estado VARCHAR(20) NOT NULL,
  disponible BOOLEAN NOT NULL,
  comentarios_bibusero VARCHAR(500),
  PRIMARY KEY signatura,
  FOREIGN KEY (isbn_edicion) REFERENCES ediciones(isbn),
  CONSTRAINT ck_estado CHECK (estado IN ('nuevo', 'bueno', 'gastado', 'muy usado', 'deteriorado'))
);

CREATE TABLE prestamos (
  id INT AUTO_INCREMENT,
  pasaporte_usuario VARCHAR(20),
  signatura VARCHAR(20),
  fecha_prestamo DATE,
  fecha_devolucion DATE,
  estado VARCHAR(20),
  PRIMARY KEY id,
  FOREIGN KEY (pasaporte_usuario) REFERENCES usuarios(pasaporte),
  FOREIGN KEY (signatura) REFERENCES ejemplares(signatura)
);

CREATE TABLE reservas (
  id INT AUTO_INCREMENT,
  pasaporte_usuario VARCHAR(20),
  signatura VARCHAR(20),
  fecha_inicio DATE,
  fecha_fin DATE,
  PRIMARY KEY id,
  FOREIGN KEY (pasaporte_usuario) REFERENCES usuarios(pasaporte),
  FOREIGN KEY (signatura) REFERENCES ejemplares(signatura)
);

CREATE TABLE sanciones (
  id INT AUTO_INCREMENT,
  usuario_pasaporte VARCHAR(20),
  fecha_inicio DATE,
  fecha_fin DATE,
  semanas_sancion INT,
  PRIMARY KEY id,
  FOREIGN KEY (usuario_pasaporte) REFERENCES usuarios(pasaporte)
)