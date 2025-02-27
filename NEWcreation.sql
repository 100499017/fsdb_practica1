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

-- NO MODIFICAR
CREATE TABLE bibuses (
  matricula VARCHAR2(10) NOT NULL,
  estado VARCHAR2(20) NOT NULL,
  ultima_itv DATE NOT NULL,
  proxima_itv DATE NOT NULL,
  PRIMARY KEY (matricula),
  CONSTRAINT ck_estado CHECK (estado IN ('disponible', 'en ruta', 'en revision'))
);

-- NO MODIFICAR
CREATE TABLE paradas (
  id INT AUTO_INCREMENT NOT NULL,
  id_ruta VARCHAR2(10) NOT NULL,
  matricula_bibus VARCHAR2(10) NOT NULL,
  municipio VARCHAR2(50) NOT NULL,
  poblacion VARCHAR2(10) NOT NULL,
  fecha DATE NOT NULL,
  hora TIME NOT NULL,
  direccion VARCHAR2(100) NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk_ruta
    FOREIGN KEY (id_ruta)
    REFERENCES rutas(id)
    ON DELETE CASCADE,
  CONSTRAINT fk_bibus
    FOREIGN KEY (matricula_bibus)
    REFERENCES bibuses(matricula)
    ON DELETE CASCADE,
  CONSTRAINT fk_municipio
    FOREIGN KEY (municipio, poblacion)
    REFERENCES municipios(nombre, poblacion)
    ON DELETE CASCADE
)

-- NO MODIFICAR
CREATE TABLE bibuseros (
  pasaporte VARCHAR2(20) NOT NULL,
  email VARCHAR(50) NOT NULL,
  nombre VARCHAR2(20) NOT NULL,
  apellido1 VARCHAR2(20) NOT NULL,
  apellido2 VARCHAR2(20),
  fecha_nacimiento DATE NOT NULL,
  telefono CHAR(9) NOT NULL,
  direccion VARCHAR2(100) NOT NULL,
  inicio_contrato DATE NOT NULL,
  fin_contrato DATE,
  estado VARCHAR2(15) NOT NULL DEFAULT 'en descanso',
  matricula_bibus VARCHAR2(10),
  PRIMARY KEY (pasaporte),
  CONSTRAINT fk_bibus
    FOREIGN KEY (matricula_bibus)
    REFERENCES bibuses(matricula)
    ON DELETE SET NULL
  CONSTRAINT ck_estado CHECK (estado IN ('en ruta', 'en descanso', 'sin ruta'))
);

-- NO MODIFICAR
CREATE TABLE rutas (
  id VARCHAR2(10) NOT NULL,
  fecha DATE NOT NULL,
  matricula_bibus VARCHAR(10) NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk_bibus
    FOREIGN KEY (matricula_bibus)
    REFERENCES bibuses(matricula)
    ON DELETE CASCADE
);

-- NO MODIFICAR
CREATE TABLE municipios (
  nombre VARCHAR(50) NOT NULL,
  poblacion VARCHAR2(20) NOT NULL,
  provincia VARCHAR2(30) NOT NULL,
  tiene_libreria VARCHAR2(15),
  PRIMARY KEY (nombre, poblacion),
  CONSTRAINT ck_tiene_libreria CHECK (tiene_libreria IN ('S', 'N'))
);

-- NO MODIFICAR
CREATE TABLE bibliotecas (
  cif VARCHAR(20) NOT NULL,
  email VARCHAR(100) NOT NULL,
  nombre VARCHAR(150) NOT NULL,
  fecha_fundacion DATE NOT NULL,
  telefono CHAR(9) NOT NULL,
  direccion VARCHAR(200) NOT NULL,
  municipio VARCHAR(100) NOT NULL,
  poblacion VARCHAR(100) NOT NULL,
  PRIMARY KEY (cif),
  CONSTRAINT fk_municipio
    FOREIGN KEY (municipio, poblacion)
    REFERENCES municipios(nombre, poblacion)
    ON UPDATE CASCADE
);

-- NO MODIFICAR
CREATE TABLE usuarios (
  id INT AUTO_INCREMENT NOT NULL,
  pasaporte VARCHAR2(20) NOT NULL,
  email VARCHAR2(100),
  nombre VARCHAR2(100) NOT NULL,
  apellido1 VARCHAR2(100) NOT NULL,
  apellido2 VARCHAR2(100),
  fecha_nacimiento DATE NOT NULL,
  telefono CHAR(9) NOT NULL,
  direccion VARCHAR2(200) NOT NULL,
  municipio VARCHAR2(100) NOT NULL,
  poblacion VARCHAR2(100) NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk_municipio
    FOREIGN KEY (municipio, poblacion)
    REFERENCES municipios(nombre, poblacion)
    ON UPDATE CASCADE
);

-- NO MODIFICAR
CREATE TABLE libros (
  titulo VARCHAR2(200) NOT NULL,
  autor_principal VARCHAR2(100) NOT NULL,
  pais_publicacion VARCHAR2(50) NOT NULL,
  lengua_original VARCHAR2(50),
  fecha_publicacion DATE NOT NULL,
  titulos_alternativos VARCHAR2(200),
  tema VARCHAR2(100),
  premios VARCHAR2(200),
  otros_autores VARCHAR2(200),
  mencion_autores VARCHAR2(200),
  notas_contenido VARCHAR2(500),
  PRIMARY KEY (titulo, autor_principal)
);

-- NO MODIFICAR
CREATE TABLE ediciones (
  isbn VARCHAR2(20) NOT NULL,
  titulo VARCHAR2(200) NOT NULL,
  autor_principal VARCHAR2(100) NOT NULL,
  lengua_principal VARCHAR2(50),
  otras_lenguas VARCHAR2(100),
  edicion VARCHAR2(20),
  editorial VARCHAR2(100) NOT NULL,
  extension VARCHAR2(50) NOT NULL,
  serie VARCHAR2(100),
  deposito_legal VARCHAR2(50),
  lugar_publicacion VARCHAR2(100) NOT NULL,
  dimensiones VARCHAR2(50),
  otras_caracteristicas VARCHAR2(200),
  material_ajeno VARCHAR2(200),
  notas VARCHAR2(500),
  id_biblioteca_nacional VARCHAR2(30) NOT NULL,
  url_edicion VARCHAR2(200),
  PRIMARY KEY (isbn),
  CONSTRAINT fk_libro
    FOREIGN KEY (titulo, autor_principal)
    REFERENCES libros(titulo, autor_principal)
    ON UPDATE CASCADE
);

-- NO MODIFICAR
CREATE TABLE ejemplares (
  signatura VARCHAR2(20) NOT NULL,
  titulo VARCHAR2(200) NOT NULL,
  autor_principal VARCHAR2(100) NOT NULL,
  isbn VARCHAR2(20) NOT NULL,
  estado VARCHAR2(20) NOT NULL DEFAULT 'nuevo',
  dado_de_baja VARCHAR2(15) DEFAULT 'N',
  fecha_baja DATE,
  comentarios_bibusero VARCHAR(500),
  PRIMARY KEY (signatura),
  CONSTRAINT fk_libro
    FOREIGN KEY (titulo, autor_principal)
    REFERENCES libros(titulo, autor_principal),
  CONSTRAINT fk_edicion
    FOREIGN KEY (isbn)
    REFERENCES ediciones(isbn),
  CONSTRAINT ck_estado CHECK (estado IN ('nuevo', 'bueno', 'gastado', 'muy usado', 'deteriorado')),
  CONSTRAINT ck_dado_de_baja CHECK (dado_de_baja IN ('S', 'N'))
);

-- NO MODIFICAR
CREATE TABLE prestamos (
  id INT AUTO_INCREMENT NOT NULL,
  id_usuario INT NOT NULL,
  signatura VARCHAR2(20),
  fecha_prestamo DATE,
  fecha_devolucion DATE,
  fecha_comentario DATE,
  comentario VARCHAR2(2000),
  PRIMARY KEY (id),
  CONSTRAINT fk_usuario
    FOREIGN KEY (id_usuario)
    REFERENCES usuarios(id),
  CONSTRAINT fk_ejemplar
    FOREIGN KEY (signatura)
    REFERENCES ejemplares(signatura)
);

-- NO MODIFICAR
CREATE TABLE reservas (
  id INT AUTO_INCREMENT NOT NULL,
  id_usuario INT NOT NULL,
  signatura VARCHAR2(20) NOT NULL,
  fecha_inicio DATE NOT NULL,
  fecha_fin DATE NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk_usuario
    FOREIGN KEY (id_usuario)
    REFERENCES usuarios(id),
  CONSTRAINT fk_ejemplar
    FOREIGN KEY (signatura)
    REFERENCES ejemplares(signatura)
);

-- NO MODIFICAR
CREATE TABLE sanciones (
  id INT AUTO_INCREMENT NOT NULL,
  id_usuario INT NOT NULL,
  fecha_inicio DATE NOT NULL,
  fecha_fin DATE NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk_usuario
    FOREIGN KEY (id_usuario)
    REFERENCES usuarios(id)
)

COMMIT;

/**
ERRORES

1. En las claves foraneas dio error porque no declaramos un constraint antes de poner las restricciones
   semanticas para mantener la integridad de los datos. Despues de poner CONSTRAINT en todas las claves
   foraneas, dejo de dar error.
**/