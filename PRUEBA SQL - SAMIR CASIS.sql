/* 
1) Revisa el tipo de relación y crea el modelo correspondiente. 
Respeta las claves primarias, foráneas y tipos de datos
*/

CREATE TABLE Peliculas (
id 			INT,
nombre		VARCHAR(255) 	NOT NULL,
anno		INT				NOT NULL,
PRIMARY KEY (id)
);

CREATE TABLE Tags (
id 		INT,
tag		varchar(32),
primary key (id)
);

CREATE TABLE peliculas_tags (
peliculas_id 	INT,
tags_id 		INT,
FOREIGN KEY (peliculas_id) REFERENCES Peliculas (id),
FOREIGN KEY (tags_id) REFERENCES Tags (id)
);

SELECT * FROM PELICULAS;
SELECT * FROM tags;
SELECT * FROM peliculas_tags;

/*
2) Inserta 5 películas y 5 tags; la primera película debe tener 3 tags asociados, 
la segunda película debe tener 2 tags asociados.
*/

INSERT INTO peliculas (id, nombre, anno) VALUES 
(1, 'Jurassic Park', 1993),
(2, 'Pulp Fiction', 1994),
(3, 'The Matrix', 1999),
(4, 'Terminator 2: Judgment Day', 1991),
(5, 'Forrest Gump', 1994);

INSERT INTO Tags (id, tag) VALUES 
(1, 'Aventura'),
(2, 'Ciencia ficción'),
(3, 'Drama'),
(4, 'Acción'),
(5, 'Fantasía');

INSERT INTO peliculas_tags (peliculas_id, tags_id) VALUES
(1, 1),
(1, 2),
(1, 4),
(2, 2),
(2, 3),
(3, NULL),
(4, NULL),
(5, NULL);

/*
3) Cuenta la cantidad de tags que tiene cada película. 
Si una película no tiene tags debe mostrar 0.
*/

SELECT p.nombre AS "Nombre de la pelicula", 
COUNT(P_Tags.tags_id) AS "Tags por pelicula"
FROM peliculas AS p
INNER JOIN peliculas_tags AS P_Tags ON p.id = P_Tags.peliculas_id
GROUP BY p.nombre
ORDER BY "Tags por pelicula" DESC;


-------------------------------------------------------------------------------------------------------------------

/*
4)Crea las tablas correspondientes respetando los nombres, tipos, 
claves primarias y foráneas y tipos de datos.
*/

CREATE TABLE Preguntas (
id 						INT,
pregunta				VARCHAR(255) 	NOT NULL,
respuesta_correcta		VARCHAR			NOT NULL,
PRIMARY KEY (id)
);

CREATE TABLE Usuarios (
id 			INT,
nombre		VARCHAR(255) 	NOT NULL,
edad		INT				NOT NULL,
PRIMARY KEY (id)
);

CREATE TABLE Respuestas (
id 				INT,
respuesta 		VARCHAR(255),
usuario_id 		INT,
pregunta_id 	INT,
PRIMARY KEY (id),
FOREIGN KEY (usuario_id) REFERENCES Usuarios (id),
FOREIGN KEY (pregunta_id) REFERENCES Preguntas (id)
);

SELECT * FROM Usuarios;
SELECT * FROM Preguntas;
SELECT * FROM Respuestas;

-- 5) Agrega 5 usuarios y 5 preguntas

INSERT INTO Usuarios (id, nombre, edad) VALUES
(1, 'Joaquín', 30),
(2, 'Valentina', 25),
(3, 'Matías', 35),
(4, 'Isidora', 28),
(5, 'Antonia', 33);

INSERT INTO Preguntas (id, pregunta, respuesta_correcta) VALUES
(1, '¿Qué color se forma al mezclar amarillo y azul?', 'Verde'),
(2, '¿Qué color se forma al mezclar rojo y azul?', 'Morado'),
(3, '¿Qué color se forma al mezclar amarillo y rojo?', 'Naranjo'),
(4, '¿Qué color se forma al mezclar rojo y blanco?', 'Rosa'),
(5, '¿Qué color se forma al mezclar blanco y negro?', 'Gris');

-- 1ERA PREGUNTA RESPONDIDA CORRECTAMENTE DOS VECES POR DOS USUARIOS DIFERENTES
INSERT INTO Respuestas (id, respuesta, usuario_id, pregunta_id) VALUES
(1, 'Verde', 1, 1), 
(2, 'Verde', 2, 1); 

-- 2DA PREGUNTA CONTESTADA POR UN USUARIO
INSERT INTO Respuestas (id, respuesta, usuario_id, pregunta_id) VALUES
(3, 'Morado', 3, 2); 

-- LAS OTRAS 3 PREGUNTAS CON RESPUESTAS INCORRECTAS
INSERT INTO Respuestas (id, respuesta, usuario_id, pregunta_id) VALUES
(4, 'Azul', 4, 3),  
(5, 'Negro', 5, 4), 
(6, 'Dorado', 1, 5);


----------------------------------------------------------------------------------------------------------------
/* 
6) Cuenta la cantidad de respuestas correctas totales por usuario 
(independiente de la pregunta).
*/

SELECT u.nombre, COUNT(r.id) AS "Respuestas correctas por usuario"
FROM Usuarios AS u
INNER JOIN Respuestas AS r ON u.id = r.usuario_id
INNER JOIN Preguntas AS p ON r.pregunta_id = p.id
WHERE r.respuesta = p.respuesta_correcta
GROUP BY u.nombre;

/* 
7) Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios
respondieron correctamente.
*/

SELECT p.pregunta, COUNT(DISTINCT r.usuario_id) AS "N° usuarios que respondieron bien"
FROM Preguntas AS p
LEFT JOIN Respuestas AS r ON p.id = r.pregunta_id AND r.respuesta = p.respuesta_correcta
GROUP BY p.pregunta
ORDER BY "N° usuarios que respondieron bien" DESC;

/* 
8) Implementa un borrado en cascada de las respuestas al borrar un usuario. 
Prueba la implementación borrando el primer usuario. 
*/

ALTER TABLE Respuestas 
DROP CONSTRAINT respuestas_usuario_id_fkey;

ALTER TABLE Respuestas
ADD CONSTRAINT respuestas_usuario_id_fkey
FOREIGN KEY (usuario_id) REFERENCES Usuarios(id)
ON DELETE CASCADE;

DELETE FROM usuarios WHERE id = 1;

SELECT * FROM usuarios;
SELECT * FROM preguntas;
SELECT * FROM respuestas;

/*
9) Crea una restricción que impida insertar usuarios menores de 18 años
en la base de datos.
*/

ALTER TABLE Usuarios
ADD CONSTRAINT edad_mayor_de_18
CHECK (edad >= 18);

INSERT INTO Usuarios (id, nombre, edad) VALUES (6, 'Pedro', 16);


/* 
10) Altera la tabla existente de usuarios agregando el campo email. 
Debe tener la restricción de ser único.
*/

ALTER TABLE Usuarios
ADD COLUMN email VARCHAR(255) UNIQUE;

SELECT * FROM Usuarios;

UPDATE Usuarios
SET email = 'prueba02@gmail.com'
WHERE id = 2;

UPDATE Usuarios
SET email = 'prueba02@gmail.com'
WHERE id = 3;

SELECT * FROM Usuarios;




