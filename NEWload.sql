-- Vamos a cargar los datos en orden de padres a hijos, para evitar errores

-- Primero cargamos los datos de libros, luego de ediciones y luego de ejemplares

INSERT INTO libros (titulo, autor_principal, pais_publicacion, lengua_original, fecha_publicacion,
    titulos_alternativos, tema, premios, otros_autores, mencion_autores, notas_contenido)
    SELECT DISTINCT title, main_author, pub_country, main_language, pub_date, alt_title, topic,
        awards, other_authors, mention_authors, content_notes
    FROM fsdb.acervus;
