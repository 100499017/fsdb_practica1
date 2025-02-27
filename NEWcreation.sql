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
  pasaporte_bibusero VARCHAR2(20) NOT NULL,
  PRIMARY KEY matricula,
  FOREIGN KEY (pasaporte_bibusero) REFERENCES bibuseros(pasaporte) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT ck_estado CHECK (estado IN ('disponible', 'en ruta', 'en revision'))
);

-- NO MODIFICAR
CREATE TABLE paradas (
  id INT AUTO_INCREMENT NOT NULL,
  id_ruta INT NOT NULL,
  matricula_bibus VARCHAR2(10) NOT NULL,
  municipio VARCHAR2(50) NOT NULL,
  poblacion VARCHAR2(10) NOT NULL,
  fecha DATE NOT NULL,
  hora TIME NOT NULL,
  direccion VARCHAR2(100) NOT NULL,
  PRIMARY KEY id,
  FOREIGN KEY (id_ruta) REFERENCES rutas(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (matricula_bibus) REFERENCES bibuses(matricula) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (municipio, poblacion) REFERENCES municipios(nombre, poblacion)
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
  estado VARCHAR2(15) NOT NULL,
  matricula_bibus VARCHAR2(10),
  PRIMARY KEY pasaporte,
  FOREIGN KEY (matricula_bibus) REFERENCES bibuses(matricula) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT ck_estado CHECK (estado IN ('en ruta', 'en descanso', 'sin ruta'))
);

-- NO MODIFICAR
CREATE TABLE rutas (
  id CHAR(5) NOT NULL,
  fecha DATE NOT NULL,
  matricula_bibus VARCHAR(10) NOT NULL,
  PRIMARY KEY id,
  FOREIGN KEY (matricula_bibus) REFERENCES bibuses(matricula) ON DELETE CASCADE ON UPDATE CASCADE
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
  PRIMARY KEY cif,
  FOREIGN KEY (municipio, poblacion) REFERENCES municipios(nombre, poblacion) ON DELETE RESTRICT ON UPDATE CASCADE
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
  PRIMARY KEY id,
  FOREIGN KEY (municipio) REFERENCES municipios(nombre) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- NO MODIFICAR
CREATE TABLE libros (
  titulo VARCHAR2(200) NOT NULL,
  autor_principal VARCHAR2(100) NOT NULL,
  pais_publicacion VARCHAR2(50) NOT NULL,
  lengua_original VARCHAR2(50) NOT NULL,
  fecha_publicacion DATE NOT NULL,
  titulos_alternativos VARCHAR2(200),
  tema VARCHAR2(100) NOT NULL,
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
  lengua_principal VARCHAR2(50) NOT NULL,
  otras_lenguas VARCHAR2(100),
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
  id_biblioteca_nacional VARCHAR2(30) NOT NULL,
  url_edicion VARCHAR2(200) NOT NULL,
  PRIMARY KEY isbn,
  FOREIGN KEY (titulo, autor_principal) REFERENCES libros(titulo, autor_principal) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- NO MODIFICAR
CREATE TABLE ejemplares (
  signatura VARCHAR2(20) NOT NULL,
  titulo VARCHAR2(200) NOT NULL,
  autor_principal VARCHAR2(100) NOT NULL,
  isbn VARCHAR2(20) NOT NULL,
  estado VARCHAR2(20) NOT NULL,
  dado_de_baja VARCHAR2(15),
  fecha_baja DATE,
  comentarios_bibusero VARCHAR(500),
  PRIMARY KEY signatura,
  FOREIGN KEY (titulo, autor_principal) REFERENCES libros(titulo, autor_principal) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (isbn) REFERENCES ediciones(isbn) ON DELETE RESTRICT ON UPDATE CASCADE,
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
  PRIMARY KEY id,
  FOREIGN KEY (id_usuario) REFERENCES usuarios(id) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (signatura) REFERENCES ejemplares(signatura) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- NO MODIFICAR
CREATE TABLE reservas (
  id INT AUTO_INCREMENT NOT NULL,
  id_usuario INT NOT NULL,
  signatura VARCHAR2(20) NOT NULL,
  fecha_inicio DATE NOT NULL,
  fecha_fin DATE NOT NULL,
  PRIMARY KEY id,
  FOREIGN KEY (id_usuario) REFERENCES usuarios(id) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (signatura) REFERENCES ejemplares(signatura) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- NO MODIFICAR
CREATE TABLE sanciones (
  id INT AUTO_INCREMENT NOT NULL,
  id_usuario INT NOT NULL,
  fecha_inicio DATE NOT NULL,
  fecha_fin DATE NOT NULL,
  PRIMARY KEY id,
  FOREIGN KEY (id_usuario) REFERENCES usuarios(id) ON DELETE RESTRICT ON UPDATE CASCADE
)

COMMIT;