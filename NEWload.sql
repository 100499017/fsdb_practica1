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
    MIN(p.pub_country),
    MIN(p.main_language),
    MIN(TO_DATE(p.pub_date, 'YYYY')),
    MIN(p.alt_title),
    MIN(p.topic),
    MIN(p.awards),
    MIN(p.other_authors),
    MIN(p.mention_authors),
    MIN(p.content_notes)
FROM fsdb.acervus p
WHERE NOT EXISTS (
    SELECT 1 FROM libros l WHERE l.titulo = p.title AND l.autor_principal = p.main_author
)
GROUP BY p.title, p.main_author;

--Cargamos los datos de ediciones, usando la misma logica que en el caso anterior con la funcion MIN()

INSERT INTO ediciones (isbn, titulo, autor_principal, lengua_principal, otras_lenguas, edicion, editorial,
    extension, serie, deposito_legal, lugar_publicacion, dimensiones, otras_caracteristicas, material_ajeno,
    notas, id_biblioteca_nacional, url_edicion)
SELECT
    p.isbn,
    MIN(p.title),
    MIN(p.main_author),
    MIN(p.main_language),
    MIN(p.other_languages),
    MIN(p.edition),
    MIN(p.publisher),
    MIN(p.extension),
    MIN(p.series),
    MIN(p.copyright),
    MIN(p.pub_place),
    MIN(p.dimensions),
    MIN(p.physical_characteristics),
    MIN(p.attached_materials),
    MIN(p.notes),
    MIN(p.national_lib_id),
    MIN(p.url),
FROM fsdb.acervus p
WHERE NOT EXISTS (
    SELECT 1 FROM ediciones e WHERE e.isbn = p.isbn
)
GROUP BY p.isbn;

--Cargamos los datos de ejemplares, usando la misma logica que en el caso anterior con la funcion MIN()


--Cargamos los datos de los bibuseros

INSERT INTO bibuseros (pasaporte, email, nombre, apellido1, apellido2, fecha_nacimiento, telefono, direccion,
    inicio_contrato, fin_contrato, matricula_bibus)
SELECT
    p.lib_passport,
    p.lib_email,
    SUBSTR(p.lib_fullname, 1, INSTR(p.lib_fullname, ' ', -1, 2) - 1) AS nombre,
    SUBSTR(p.lib_fullname, INSTR(p.lib_fullname, ' ', -1, 2) + 1, INSTR(p.lib_fullname, ' ', -1, 1) - INSTR(p.lib_fullname, ' ', -1, 2) - 1) as apellido1,
    SUBSTR(p.lib_fullname, INSTR(p.lib_fullname, ' ', -1, 1) + 1) as apellido2,
    TO_DATE(p.lib_birthday, 'DD-MM-YYYY'),
    p.lib_phone,
    p.lib_address,
    TO_DATE(p.cont_start, 'DD.MM.YYYY'),
    TO_DATE(p.cont_end, 'DD.MM.YYYY'),
    p.plate
FROM fsdb.busstops p
GROUP BY p.lib_passport
HAVING NOT EXISTS (
    SELECT 1
    FROM bibuseros b
    WHERE b.pasaporte = p.lib_passport
);
COMMIT;