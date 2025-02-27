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
  matricula VARCHAR2(10) NOT NULL,
  estado VARCHAR2(20) NOT NULL,
  ultima_itv DATE NOT NULL,
  proxima_itv DATE NOT NULL,
  pasaporte_bibusero VARCHAR2(20) NOT NULL,
  PRIMARY KEY matricula,
  FOREIGN KEY (pasaporte_bibusero) REFERENCES bibuseros(pasaporte),
  CONSTRAINT ck_estado CHECK (estado IN ('disponible', 'en ruta', 'en revision'))
);

-- COMPLETADA
CREATE TABLE paradas (
  id INT AUTO_INCREMENT NOT NULL,
  matricula_bibus VARCHAR2(10) NOT NULL,
  municipio VARCHAR2(100) NOT NULL,
  poblacion VARCHAR2(100) NOT NULL,
  fecha DATE NOT NULL,
  hora TIME NOT NULL,
  direccion VARCHAR2(200) NOT NULL,
  PRIMARY KEY id,
  FOREIGN KEY (matricula_bibus) REFERENCES bibuses(matricula),
  FOREIGN KEY (municipio, poblacion) REFERENCES municipios(nombre, poblacion)
)

-- COMPLETADA
CREATE TABLE bibuseros (
  pasaporte VARCHAR(20) NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  apellidos VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL,
  telefono CHAR(9) NOT NULL,
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

-- COMPLETADA
CREATE TABLE municipios (
  nombre VARCHAR(100) NOT NULL,
  poblacion VARCHAR(100) NOT NULL,
  provincia VARCHAR2(100) NOT NULL,
  tiene_libreria CHAR(1),
  PRIMARY KEY (nombre, poblacion),
  FOREIGN KEY (biblioteca_cif) REFERENCES bibliotecas(cif),
  CONSTRAINT ck_tiene_libreria CHECK (tiene_libreria IN ('S', 'N'))
);

-- COMPLETADA
CREATE TABLE bibliotecas (
  cif VARCHAR(20) NOT NULL,
  email VARCHAR(100) NOT NULL,
  nombre VARCHAR(150) NOT NULL,
  fecha_fundacion DATE NOT NULL,
  telefono CHAR(9) NOT NULL,
  direccion VARCHAR(200) NOT NULL,
  municipio VARCHAR(100) NOT NULL,
  poblacion VARCHAR(100) NOT NULL,
  PRIMARY KEY cif,
  FOREIGN KEY (municipio, poblacion) REFERENCES municipios(nombre, poblacion)
);

--
CREATE TABLE usuarios (
  id INT AUTO_INCREMENT,
  pasaporte VARCHAR(20) NOT NULL,
  email VARCHAR(100),
  nombre VARCHAR(100) NOT NULL,
  apellido1 VARCHAR(100),
  apellido2 VARCHAR(100),
  fecha_nacimiento DATE,
  telefono CHAR(9),
  direccion VARCHAR(200),
  municipio VARCHAR(100),
  PRIMARY KEY id,
  FOREIGN KEY (municipio) REFERENCES municipios(nombre)
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
  notas_contenido VARCHAR(500),
  premios VARCHAR(200),
  mencion_autores VARCHAR(500),
  PRIMARY KEY (titulo, autor_principal)
);

-- COMPLETADA
CREATE TABLE ediciones (
  isbn VARCHAR2(20) NOT NULL,
  titulo VARCHAR2(200) NOT NULL,
  autor_principal VARCHAR2(150) NOT NULL,
  lengua_principal VARCHAR2(50) NOT NULL,
  otras_lenguas VARCHAR2(200),
  edicion VARCHAR2(20) NOT NULL,
  editorial VARCHAR2(100) NOT NULL,
  extension VARCHAR2(50) NOT NULL,
  serie VARCHAR2(100),
  deposito_legal VARCHAR2(50) NOT NULL,
  lugar_publicacion VARCHAR2(100) NOT NULL,
  dimensiones VARCHAR2(50) NOT NULL,
  otras_caracteristicas VARCHAR2(200),
  material_ajeno VARCHAR2(200),
  notas VARCHAR2(500),
  id_biblioteca_nacional CHAR(14) NOT NULL,
  url_edicion VARCHAR2(200) NOT NULL,
  PRIMARY KEY isbn,
  FOREIGN KEY (titulo, autor_principal) REFERENCES libros(titulo, autor_principal)
);

-- COMPLETADA
CREATE TABLE ejemplares (
  signatura VARCHAR(20) NOT NULL,
  titulo VARCHAR(200) NOT NULL,
  autor_principal VARCHAR(150) NOT NULL,
  isbn_edicion VARCHAR(20) NOT NULL,
  estado VARCHAR(20) NOT NULL,
  dado_de_baja CHAR(1) NOT NULL,
  fecha_baja DATE,
  comentarios_bibusero VARCHAR(500),
  PRIMARY KEY signatura,
  FOREIGN KEY (titulo, autor_principal) REFERENCES libros(titulo, autor_principal),
  FOREIGN KEY (isbn_edicion) REFERENCES ediciones(isbn),
  CONSTRAINT ck_estado CHECK (estado IN ('nuevo', 'bueno', 'gastado', 'muy usado', 'deteriorado')),
  CONSTRAINT ck_dado_de_baja CHECK (dado_de_baja IN ('S', 'N'))
);

--
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

--
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

--
CREATE TABLE sanciones (
  id INT AUTO_INCREMENT,
  usuario_pasaporte VARCHAR(20),
  fecha_inicio DATE,
  fecha_fin DATE,
  semanas_sancion INT,
  PRIMARY KEY id,
  FOREIGN KEY (usuario_pasaporte) REFERENCES usuarios(pasaporte)
)