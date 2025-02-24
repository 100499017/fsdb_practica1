CREATE TABLE bibliobuses (
  id INT,
  matricula VARCHAR(10) UNIQUE,
  estado VARCHAR(20),
  CONSTRAINT ck_estado CHECK (estado IN ('disponible', 'en ruta', 'en revision'))
)

CREATE TABLE rutas (
  id INT PRIMARY KEY,
  fecha DATE,
  bibud_id INT,
  FOREIGN KEY (bibus_id) REFERENCES bibliobuses(id)
)

CREATE TABLE municipios (
  nombre VARCHAR(100),
  provincia VARCHAR(100),
  poblacion INT,
  biblioteca_cif VARCHAR(20) UNIQUE,
  FOREIGN KEY (biblioteca_cif REFERENCES bibliotecas(cif)
)

CREATE TABLE bibliotecas (

)

CREATE TABLE usuarios (

)

CREATE TABLE libros (

)

CREATE TABLE ediciones (

)

CREATE TABLE ejemplares (

)

CREATE TABLE prestamos (

)

CREATE TABLE sanciones (

)
