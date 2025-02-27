-- Vamos a cargar los datos en orden de padres a hijos, para evitar errores

-- Primero cargamos los datos de libros, luego de ediciones y luego de ejemplares

INSERT INTO libros (titulo, autor_principal, pais_publicacion, lengua_original, fecha_publicacion,
    titulos_alternativos, tema, premios, otros_autores, mencion_autores, notas_contenido)
SELECT DISTINCT p.title,
                p.main_author,
                p.pub_country,
                p.main_language,
                p.pub_date,
                p.alt_title,
                p.topic,
                p.awards,
                p.other_authors,
                p.mention_authors,
                p.content_notes
FROM fsdb.acervus p
WHERE p.title IS NOT NULL
AND p.main_author IS NOT NULL
AND NOT EXISTS (
    SELECT 1
    FROM libros l
    WHERE l.titulo = p.title
    AND l.autor_principal = p.main_author
);
