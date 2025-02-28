-- Vamos a cargar los datos en orden de padres a hijos, para evitar errores

-- Primero cargamos los datos de libros, luego de ediciones y luego de ejemplares

--Cargamos los datos de libros. Usamos la funcion MIN() para que tome el primer valor no nulo que encuentre
--en cada columna. De esta forma, si hay multiples filas con el mismo titulo y autor pero con valores diferentes en
--otras columnas, se insertara una fila en la tabla libros con los valores de la primera fila que encuentre.

INSERT INTO libros (titulo, autor_principal, pais_publicacion, lengua_original, fecha_publicacion,
    titulos_alternativos, tema, premios, otros_autores, mencion_autores, notas_contenido)
SELECT 
    p.title,
    p.main_author,
    MIN(p.pub_country) AS pub_country,  -- Selecciona el primer valor (no NULL) de pub_country
    MIN(p.main_language) AS main_language,  -- Selecciona el primer valor (no NULL) de main_language
    TO_DATE(MIN(p.pub_date), 'YYYY') AS pub_date,  -- Elige la fecha más antigua (mínima)
    MIN(p.alt_title) AS alt_title,  -- Selecciona el primer valor de alt_title
    MIN(p.topic) AS topic,  -- Selecciona el primer valor de topic
    MIN(p.awards) AS awards,  -- Selecciona el primer valor de awards
    MIN(p.other_authors) AS other_authors,  -- Selecciona el primer valor de other_authors
    MIN(p.mention_authors) AS mention_authors,  -- Selecciona el primer valor de mention_authors
    MIN(p.content_notes) AS content_notes  -- Selecciona el primer valor de content_notes
FROM fsdb.acervus p
GROUP BY p.title, p.main_author
HAVING NOT EXISTS (
    SELECT 1
    FROM libros l
    WHERE l.titulo = p.title
    AND l.autor_principal = p.main_author
);

COMMIT;
