CREATE DATABASE "prueba-sql-julio-olivares";

\c "prueba-sql-julio-olivares";

-- Revisa el tipo de relación y crea el modelo correspondiente. Respeta las claves primarias, foráneas y tipos de datos.

CREATE TABLE movies (
    id INTEGER PRIMARY KEY,
    name VARCHAR(255),
    year INTEGER
);

CREATE TABLE tags (
    id INTEGER PRIMARY KEY,
    tag VARCHAR(32)
);

CREATE TABLE movies_tags (
    movie_id INTEGER REFERENCES movies (id),
    tag_id INTEGER REFERENCES tags (id),
    PRIMARY KEY (movie_id, tag_id)
);

-- Inserta 5 películas y 5 tags; la primera película debe tener 3 tags asociados, la segunda película debe tener 2 tags asociados.

INSERT INTO movies (id, name, year) VALUES
(1, 'La leyenda de la montaña', 2020),
(2, 'El viaje inesperado', 2018),
(3, 'Rescate en el Ártico', 2021),
(4, 'La casa encantada', 2022),
(5, 'Revancha final', 2019);

-- comprobamos el insert
SELECT * FROM movies;

INSERT INTO tags (id, tag) VALUES
(1, 'Aventura'),
(2, 'Terror'),
(3, 'Suspenso'),
(4, 'Comedia'),
(5, 'Ciencia Ficción');

-- comprobamos el insert
SELECT * FROM tags;

INSERT INTO movies_tags (movie_id, tag_id) VALUES
(1, 1),
(1, 3),
(1, 5),
(2, 2),
(2, 4);

-- comprobamos el insert
SELECT * FROM movies_tags;

-- 3. Cuenta la cantidad de tags que tiene cada película. Si una película no tiene tags debe mostrar 0.

SELECT m.name, COUNT(mt.tag_id) AS tags_count
FROM movies m
LEFT JOIN movies_tags mt ON m.id = mt.movie_id
GROUP BY m.name;

-- 4. Crea las tablas correspondientes respetando los nombres, tipos, claves primarias y foráneas y tipos de datos.

CREATE TABLE preguntas (
    id INTEGER PRIMARY KEY,
    pregunta VARCHAR(255),
    respuesta_correcta VARCHAR
);

CREATE TABLE usuarios (
    id INTEGER PRIMARY KEY,
    nombre VARCHAR(255),
    edad INTEGER
);

CREATE TABLE respuestas (
    id INTEGER PRIMARY KEY,
    respuesta VARCHAR(255),
    usuario_id INTEGER,
    pregunta_id INTEGER,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (pregunta_id) REFERENCES preguntas(id)
);

-- 5. Agrega 5 usuarios y 5 preguntas.
--     a. La primera pregunta debe estar respondida correctamente dos veces, por dos usuarios diferentes.
--     b. La segunda pregunta debe estar contestada correctamente solo por un usuario.
--     c. Las otras tres preguntas deben tener respuestas incorrectas.

INSERT INTO usuarios VALUES
(1, 'Carlos', 33),
(2, 'Lucía', 29),
(3, 'Esteban', 40),
(4, 'Maria', 25),
(5, 'Andrés', 37);

-- comprobamos el insert
SELECT * FROM usuarios;

INSERT INTO preguntas VALUES
(1, '¿Cuál es la capital de Argentina?', 'Buenos Aires'),
(2, '¿Cuál es el planeta más cercano al Sol?', 'Mercurio'),
(3, '¿Qué país tiene la torre Eiffel?', 'Francia'),
(4, '¿Qué animal es conocido como el rey de la selva?', 'León'),
(5, '¿Cuál es el metal más abundante en la Tierra?', 'Hierro');

-- comprobamos el insert
SELECT * FROM preguntas;

INSERT INTO respuestas VALUES
(1, 'Buenos Aires', 2, 1),
(2, 'España', 1, 3),
(3, 'Mercurio', 4, 2),
(4, 'Buenos Aires', 5, 1),
(5, 'Plata', 3, 5);

-- comprobamos el insert
SELECT * FROM respuestas;

-- 6. Cuenta la cantidad de respuestas correctas totales por usuario (independiente de la pregunta).

SELECT u.nombre, COUNT(p.respuesta_correcta) 
FROM preguntas p
RIGHT JOIN respuestas r ON p.respuesta_correcta = r.respuesta
JOIN usuarios u ON u.id = r.usuario_id
GROUP BY u.nombre;

-- 7. Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios respondieron correctamente.

SELECT p.id, p.pregunta, COUNT(r.usuario_id) AS cantidad_respuestas_correctas
FROM preguntas p LEFT JOIN respuestas r ON p.id = r.pregunta_id
AND p.respuesta_correcta=r.respuesta
GROUP BY p.pregunta, p.id 
ORDER BY p.id;

--8. Implementa un borrado en cascada de las respuestas al borrar un usuario. Prueba la implementación borrando el primer usuario.

-- implementacion de borrado en cascada
ALTER TABLE respuestas DROP CONSTRAINT respuestas_usuario_id_fkey, 
ADD FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE;
-- eliminacion de usuario
DELETE FROM usuarios WHERE id = 1;

-- comprobamos el alter
SELECT * FROM usuarios;

-- 9. Crea una restricción que impida insertar usuarios menores de 18 años en la base de datos.

ALTER TABLE usuarios ADD CHECK (edad > 18); 

--Vemos si permite ingresar usuario menor de 18 años
INSERT INTO usuarios VALUES
(6, 'Sofía', 15);

--10. Altera la tabla existente de usuarios agregando el campo email. Debe tener la restricción de ser único.

ALTER TABLE usuarios ADD email VARCHAR UNIQUE;

-- comprobamos el alter
SELECT * FROM usuarios;
