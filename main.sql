DROP TABLE bibuses;
DROP TABLE rutas;
DROP TABLE municipios;
DROP TABLE bibliotecas;
DROP TABLE usuarios;
DROP TABLE libros;
DROP TABLE ediciones;
DROP TABLE ejemplares;
DROP TABLE prestamos;
DROP TABLE sanciones;

CREATE TABLE bibuses (
  matricula VARCHAR(10),
  estado VARCHAR(20),
  pasaporte_bibusero VARCHAR(20),
  id_ruta INT,
  PRIMARY KEY matricula,
  FOREIGN KEY (pasaporte_bibusero) REFERENCES bibuseros(pasaporte),
  FOREIGN KEY (id_ruta) REFERENCES rutas(id),
  CONSTRAINT ck_estado CHECK (estado IN ('disponible', 'en ruta', 'en revision'))
);

CREATE TABLE bibuseros (
  pasaporte VARCHAR(20)
  nombre VARCHAR(100),
  apellidos VARCHAR(100),
  email VARCHAR(100),
  telefono VARCHAR(20),
  inicio_contrato DATE,
  fin_contrato DATE,
  estado VARCHAR(20),
  matricula_bibus VARCHAR(10),
  PRIMARY KEY pasaporte,
  FOREIGN KEY (matricula_bibus) REFERENCES bibuses(matricula),
  CONSTRAINT ck_estado CHECK (estado IN ( ))
);

CREATE TABLE rutas (
  id INT AUTO_INCREMENT,
  paradas VARCHAR(200),
  PRIMARY KEY id,
);

CREATE TABLE municipios (
  nombre VARCHAR(100),
  provincia VARCHAR(100),
  poblacion INT,
  biblioteca_cif VARCHAR(20) UNIQUE,
  PRIMARY KEY nombre,
  FOREIGN KEY (biblioteca_cif) REFERENCES bibliotecas(cif)
);

CREATE TABLE bibliotecas (
  cif VARCHAR(20),
  nombre VARCHAR(150),
  fecha_fundacion DATE,
  nombre_municipio VARCHAR(100),
  direccion VARCHAR(200),
  email VARCHAR(100),
  telefono VARCHAR(20),
  PRIMARY KEY cif,
  FOREIGN KEY (nombre_municipio) REFERENCES municipios(nombre)
);

CREATE TABLE usuarios (
  pasaporte VARCHAR(20),
  nombre VARCHAR(100),
  apellidos VARCHAR(100),
  fecha_nacimiento DATE,
  nombre_municipio VARCHAR(100),
  direccion VARCHAR(200),
  email VARCHAR(100),
  telefono VARCHAR(20),
  PRIMARY KEY pasaporte,
  FOREIGN KEY (nombre_municipio) REFERENCES municipios(nombre)
);

CREATE TABLE libros (
  titulo VARCHAR(200),
  autor_principal VARCHAR(150),
  pais_publicacion VARCHAR(50),
  lengua_original VARCHAR(50),
  fecha_publicacion DATE,
  premios TEXT,
  PRIMARY KEY (titulo, autor_principal)
);

CREATE TABLE ediciones (
  isbn VARCHAR(20),
  titulo VARCHAR(200),
  autor_principal VARCHAR(150),
  lengua_principal VARCHAR(50),
  editorial VARCHAR(100),
  deposito_legal VARCHAR(50),
  PRIMARY KEY isbn,
  FOREIGN KEY (titulo, autor_principal) REFERENCES libros(titulo, autor_principal)
);

CREATE TABLE ejemplares (
  signatura VARCHAR(20),
  isbn VARCHAR(20),
  estado VARCHAR(20),
  disponible BOOLEAN,
  PRIMARY KEY signatura,
  FOREIGN KEY (isbn) REFERENCES ediciones(isbn),
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
);
