USE ConeSTeamDB;
GO

-- Limpieza de tablas en orden inverso respetando las FKs (de hijas a maestras)
DELETE FROM Reembolso;
DELETE FROM Detalle_Factura;
DELETE FROM Factura;
DELETE FROM Suscripcion_Mod;
DELETE FROM Carrito;
DELETE FROM Lista_Deseos;
DELETE FROM Biblioteca;
DELETE FROM Desbloqueo_Logro;
DELETE FROM Resena;
DELETE FROM Amistad_Usuario;
DELETE FROM Usuario;
DELETE FROM Mod;
DELETE FROM Producto_Etiqueta;
DELETE FROM Etiqueta_Comunidad;
DELETE FROM Soporte_Idioma;
DELETE FROM Idioma;
DELETE FROM Juego_Categoria;
DELETE FROM Categoria_Oficial;
DELETE FROM Logro;
DELETE FROM Galeria_Multimedia;
DELETE FROM Perfil_Requisito;
DELETE FROM DLC;
DELETE FROM Juego_Base;
DELETE FROM Producto_Digital;
DELETE FROM Empresa_Corporativa;
DELETE FROM Metodo_Pago;
GO
/* =====================================================================
   BLOQUE 1: Carga inicial (Lookups)
   Proyecto Fase 2 · ConeSTeam · Semestre I-2026
   Incluye las tablas base + las 4 categorías adicionales (17-20).
   ===================================================================== */

/* ------------------------- Categoria_Oficial ------------------------- */
SET IDENTITY_INSERT Categoria_Oficial ON;
INSERT INTO Categoria_Oficial (ID_Categoria, Nombre_Categoria, Descripcion_Categoria) VALUES
 (1 , 'Acción',        'Juegos centrados en combate, reflejos y desafíos físicos.'),
 (2 , 'Aventura',      'Exploración, narrativa y resolución de acertijos.'),
 (3 , 'RPG',           'Juegos de rol con progresión de personaje e historia.'),
 (4 , 'Estrategia',    'Toma de decisiones, gestión de recursos y táctica.'),
 (5 , 'Terror',        'Ambientación de horror y supervivencia.'),
 (6 , 'Deportes',      'Simulación de disciplinas deportivas.'),
 (7 , 'Carreras',      'Competencias de velocidad y conducción.'),
 (8 , 'Simulación',    'Recreación de sistemas o actividades reales.'),
 (9 , 'Indie',         'Producciones de estudios independientes.'),
 (10, 'Mundo Abierto', 'Mundos explorables sin progresión lineal.'),
 (11, 'Un Jugador',    'Experiencia individual (single-player).'),
 (12, 'Multijugador',  'Partidas en línea o local con varios jugadores.'),
 (13, 'Puzzle',        'Resolución de rompecabezas y lógica.'),
 (14, 'Plataformas',   'Saltos y desplazamiento por niveles.'),
 (15, 'Shooter',       'Disparos en primera o tercera persona.'),
 (16, 'Cooperativo',   'Juego colaborativo entre varios jugadores.'),
 (17, 'Casual',        'Juegos accesibles de partidas rápidas y mecánicas sencillas.'),
 (18, 'Supervivencia', 'Gestión de recursos extremos y resistencia en entornos hostiles.'),
 (19, 'Realidad Virtual','Experiencias inmersivas diseñadas para dispositivos VR.'),
 (20, 'Anime',         'Estética visual de animación japonesa y narrativas orientales.');
SET IDENTITY_INSERT Categoria_Oficial OFF;

/* ------------------------------- Idioma ------------------------------ */
SET IDENTITY_INSERT Idioma ON;
INSERT INTO Idioma (ID_Idioma, Nombre_Idioma) VALUES
 (1 , 'Español'),
 (2 , 'Inglés'),
 (3 , 'Francés'),
 (4 , 'Alemán'),
 (5 , 'Portugués'),
 (6 , 'Italiano'),
 (7 , 'Japonés'),
 (8 , 'Coreano'),
 (9 , 'Chino (Mandarín)'),
 (10, 'Ruso');
SET IDENTITY_INSERT Idioma OFF;

/* ----------------------------- Metodo_Pago --------------------------- */
INSERT INTO Metodo_Pago (ID_Metodo_Pago, Nombre_Metodo, Moneda, Requiere_Validacion) VALUES
 (1, 'Tarjeta de Crédito',   'USD', 1),
 (2, 'Tarjeta de Débito',    'USD', 1),
 (3, 'PayPal',               'USD', 1),
 (4, 'Zelle',                'USD', 1),
 (5, 'Pago Móvil',           'VES', 1),
 (6, 'Criptomoneda (USDT)',  'USD', 1),
 (7, 'Saldo ConeSTeam',      'USD', 0);

 /* =====================================================================
   BLOQUE 2: Empresas Corporativas (Matriz y Subsidiarias)
   Proyecto Fase 2 · ConeSTeam · Semestre I-2026
   Carga de 40 empresas corporativas con jerarquía corporativa (ID del 1 al 40).
   ===================================================================== */
DELETE FROM Empresa_Corporativa;

SET IDENTITY_INSERT Empresa_Corporativa ON;
INSERT INTO Empresa_Corporativa (ID_Empresa, Nombre, Pais_Origen, Fecha_Fundacion, ID_Empresa_Matriz_FK) VALUES
 -- 1. Grandes Matrices (Sin empresa matriz, ID_Empresa_Matriz_FK = NULL)
 (1,  'Valve Corporation',          'Estados Unidos', '1996-08-24', NULL),
 (2,  'Electronic Arts',            'Estados Unidos', '1982-05-28', NULL),
 (3,  'Sony Group Corporation',     'Japón',          '1946-05-07', NULL),
 (4,  'Microsoft Corporation',      'Estados Unidos', '1975-04-04', NULL),
 (5,  'Ubisoft Entertainment',      'Francia',        '1986-03-28', NULL),
 (6,  'Nintendo Co., Ltd.',         'Japón',          '1889-09-23', NULL),
 (7,  'Take-Two Interactive',       'Estados Unidos', '1993-09-30', NULL),
 (8,  'Embracer Group',             'Suecia',         '2008-05-15', NULL),
 (9,  'Tencent Holdings',           'China',          '1998-11-11', NULL),
 (10, 'Square Enix Holdings',       'Japón',          '1975-09-22', NULL),


 -- 11 a 40: Subsidiarias u otras empresas (al menos 8 con su ID_Empresa_Matriz_FK asignada a una matriz de arriba)
 (11, 'Valve Software Dev',         'Estados Unidos', '1996-08-24', 1),   -- Subsidiaria de Valve (1)
 (12, 'BioWare',                    'Canadá',         '1995-02-01', 2),   -- Subsidiaria de EA (2)
 (13, 'DICE',                       'Suecia',         '1992-01-01', 2),   -- Subsidiaria de EA (2)
 (14, 'Naughty Dog',                'Estados Unidos', '1984-09-14', 3),   -- Subsidiaria de Sony (3)
 (15, 'Insomniac Games',            'Estados Unidos', '1994-02-28', 3),   -- Subsidiaria de Sony (3)
 (16, 'Mojang Studios',             'Suecia',         '2009-05-17', 4),   -- Subsidiaria de Microsoft (4)
 (17, 'Obsidian Entertainment',     'Estados Unidos', '2003-06-01', 4),   -- Subsidiaria de Microsoft (4)
 (18, 'Ubisoft Montreal',           'Canadá',         '1997-04-01', 5),   -- Subsidiaria de Ubisoft (5)
 (19, 'Ubisoft Blue Byte',          'Alemania',       '1988-10-01', 5),   -- Subsidiaria de Ubisoft (5)
 (20, 'Rockstar Games',             'Estados Unidos', '1998-12-01', 7),   -- Subsidiaria de Take-Two (7)
 (21, '2K Games',                   'Estados Unidos', '2005-01-25', 7),   -- Subsidiaria de Take-Two (7)
 (22, 'THQ Nordic',                 'Suecia',         '2011-01-01', 8),   -- Subsidiaria de Embracer (8)
 (23, 'Gearbox Software',           'Estados Unidos', '1999-02-16', 8),   -- Subsidiaria de Embracer (8)
 (24, 'Riot Games',                 'Estados Unidos', '2006-09-05', 9),   -- Subsidiaria de Tencent (9)
 (25, 'Epic Games',                 'Estados Unidos', '1991-06-16', NULL),
 (26, 'CD Projekt Red',             'Polonia',        '2002-05-01', NULL),
 (27, 'FromSoftware',               'Japón',          '1986-11-01', NULL),
 (28, 'Capcom',                     'Japón',          '1979-05-30', NULL),
 (29, 'SEGA',                       'Japón',          '1960-06-03', NULL),
 (30, 'Bandai Namco Entertainment', 'Japón',          '2006-03-31', NULL),
 (31, 'Bethesda Game Studios',      'Estados Unidos', '2001-01-01', 4),   -- Subsidiaria de Microsoft (4)
 (32, 'Bungie',                     'Estados Unidos', '1991-05-01', 4),   -- Subsidiaria de Microsoft (4)
 (33, 'Santa Monica Studio',        'Estados Unidos', '1999-01-01', 3),   -- Subsidiaria de Sony (3)
 (34, 'Guerrilla Games',            'Países Bajos',   '2000-01-01', 3),   -- Subsidiaria de Sony (3)
 (35, 'Criterion Games',            'Reino Unido',    '1993-01-01', 2),   -- Subsidiaria de EA (2)
 (36, 'Respawn Entertainment',      'Estados Unidos', '2010-04-01', 2),   -- Subsidiaria de EA (2)
 (37, 'Arkane Studios',             'Francia',        '1999-10-01', 4),   -- Subsidiaria de Microsoft (4)
 (38, 'Sucker Punch Productions',   'Estados Unidos', '1997-10-01', 3),   -- Subsidiaria de Sony (3)
 (39, 'PlatinumGames',              'Japón',          '2006-08-01', NULL),
 (40, 'Supergiant Games',           'Estados Unidos', '2009-09-01', NULL),
 (41,'Electronic Arts', 'Estados Unidos', '1982-05-27', NULL);
SET IDENTITY_INSERT Empresa_Corporativa OFF;

GO
/* =====================================================================
   BLOQUE 3: Productos Digitales, Juegos Base, DLCs y Requisitos
   Proyecto Fase 2 · ConeSTeam · Semestre I-2026
   ===================================================================== */

/* ------------------------- 1. Producto_Digital ------------------------- */
-- Usamos IDENTITY ya que Producto_Digital tiene ID autoincremental
SET IDENTITY_INSERT Producto_Digital ON;

INSERT INTO Producto_Digital (ID_Producto, Titulo, Descripcion_Corta, Descripcion_Larga, Fecha_Lanzamiento, Tamano_GB, Clasificacion_Edad, Precio_Base_Actual, Tipo_Producto, Metacritic_Score) VALUES
 (1, 'Cyberpunk 2077', 'RPG de mundo abierto en Night City.', 'Sumérgete en un RPG de acción y aventura de mundo abierto ambientado en la megalópolis de Night City.', '2020-12-10', 70.00, 'M', 59.99, 'Juego_Base', 86),
 (2, 'Dark Souls Remastered', 'El clásico que inició la leyenda.', 'Regresa a Lordran y enfrenta a demonios y dioses en la versión remasterizada del aclamado RPG de acción.', '2018-05-25', 18.00, 'M', 39.99, 'Juego_Base', 84),
 (3, 'Elden Ring', 'RPG de acción en un vasto mundo de fantasía.', 'El Anillo de Elden se ha roto. Guía a tu Tarnished para reinar en las Tierras Intermedias.', '2022-02-25', 45.00, 'M', 59.99, 'Juego_Base', 96),
 (4, 'Half-Life: Alyx', 'El regreso de Valve al universo Half-Life.', 'Asume el papel de Alyx Vance en una lucha desesperada contra la Alianza en una aventura diseñada exclusivamente para Realidad Virtual.', '2020-03-23', 60.00, 'M', 59.99, 'Juego_Base', 93),
 (5, 'The Witcher 3: Wild Hunt', 'RPG de fantasía oscura y narrativa.', 'Eres Geralt de Rivia, cazador de monstruos en busca de la niña de la profecía.', '2015-05-19', 50.00, 'M', 39.99, 'Juego_Base', 93),
 (6, 'Portal 2', 'Puzles y física en laboratorios Aperture.', 'Una secuela magistral que desafía las leyes de la física con portales y humor negro.', '2011-04-19', 15.00, 'E', 9.99, 'Juego_Base', 95),
 (7, 'Grand Theft Auto V', 'Acción y crimen en Los Santos.', 'Vive historias entrelazadas en el soleado estado de San Andreas.', '2015-04-14', 105.00, 'M', 29.99, 'Juego_Base', 96),
 (8, 'Hades', 'Roguelike de acción mitológica.', 'Desafía al dios de los muertos mientras hackeas y cortas para salir del Inframundo.', '2020-09-17', 15.00, 'T', 24.99, 'Juego_Base', 93),
 (9, 'Minecraft', 'Mundo abierto de construcción y supervivencia.', 'Coloca bloques y emprende aventuras en un mundo infinito generado proceduralmente.', '2011-11-18', 1.00, 'E', 29.99, 'Juego_Base', 93),
 (10, 'Baldurs Gate 3', 'RPG clásico de D&D de nueva generación.', 'Reúne a tu grupo y regresa a los Reinos Olvidados en una historia de fellowship y traición.', '2023-08-03', 150.00, 'M', 59.99, 'Juego_Base', 96),
 (11, 'God of War Ragnarök', 'Aventura épica en la mitología nórdica.', 'Kratos y Atreus deben viajar a cada uno de los nueve reinos en busca de respuestas.', '2022-11-09', 84.00, 'M', 49.99, 'Juego_Base', 94),
 (12, 'Red Dead Redemption 2', 'Epopeya wéstern sobre el ocaso de los forajidos.', 'Vive las vivencias de Arthur Morgan y la banda de Van der Linde en 1899.', '2018-10-26', 115.00, 'M', 39.99, 'Juego_Base', 97),
 (13, 'Resident Evil 4 Remake', 'Survival horror reimaginado con acción táctica.', 'El agente Leon S. Kennedy es enviado a rescatar a la hija del presidente secuestrada.', '2023-03-24', 58.00, 'M', 39.99, 'Juego_Base', 93),
 (14, 'Monster Hunter World', 'Caza monstruos gigantescos en ecosistemas vivos.', 'Utiliza materiales de tus presas para fabricar armamento avanzado en el Nuevo Mundo.', '2018-01-26', 48.00, 'T', 29.99, 'Juego_Base', 90),
 (15, 'Hollow Knight', 'Metroidvania de acción atmosférica subterránea.', 'Desciende a un vasto reino en ruinas de insectos y héroes olvidados.', '2017-02-24', 9.00, 'E', 14.99, 'Juego_Base', 87),
 (16, 'Terraria', 'Aventura de mundo abierto en 2D con total libertad.', 'Cava, lucha, explora y construye en un mundo sandbox lleno de secretos.', '2011-05-16', 0.50, 'T', 9.99, 'Juego_Base', 83),
 (17, 'Stardew Valley', 'Simulador de vida rural y gestión de granjas.', 'Hereda la antigua parcela de tu abuelo y conviértela en un hogar próspero.', '2016-02-26', 0.75, 'E', 14.99, 'Juego_Base', 89),
 (18, 'Devil May Cry 5', 'Acción vertiginosa con cazadores de demonios.', 'El peligro de los poderes demoníacos amenaza una vez más al mundo.', '2019-03-08', 35.00, 'M', 29.99, 'Juego_Base', 88),
 (19, 'Dark Souls III', 'RPG de acción desafiante en un mundo al límite.', 'El fuego se desvanece y el mundo se hunde en ruinas con jefes colosales.', '2016-04-12', 25.00, 'M', 39.99, 'Juego_Base', 89),
 (20, 'Sekiro: Shadows Die Twice', 'Acción y sigilo samurái en el Japón feudal.', 'Toma el papel de un guerrero deshonrado rescatado al borde de la muerte.', '2019-03-22', 15.00, 'M', 59.99, 'Juego_Base', 90),
 (21, 'Grand Theft Auto IV', 'La cruda realidad del sueño americano en Liberty City.', 'Niko Bellic llega a Estados Unidos intentando escapar de su turbio pasado.', '2008-12-02', 22.00, 'M', 19.99, 'Juego_Base', 98),
 (22, 'Max Payne 3', 'Disparos en tercera persona y drama neo-noir.', 'Max Payne trabaja como seguridad privado en São Paulo protegiendo a una familia.', '2012-06-01', 30.00, 'M', 19.99, 'Juego_Base', 87),
 (23, 'L.A. Noire', 'Investigación criminal en el Los Ángeles de 1947.', 'Usa la tecnología de captura facial para interrogar sospechosos y resolver casos.', '2011-11-08', 55.00, 'M', 19.99, 'Juego_Base', 89),
 (24, 'BioShock Infinite', 'FPS narrativo ambientado en una ciudad flotante.', 'El ex-detective Booker DeWitt es enviado a rescatar a Elizabeth en Columbia.', '2013-03-26', 30.00, 'M', 29.99, 'Juego_Base', 94),
 (25, 'Doom Eternal', 'Acción frenética y visceral contra las hordas del infierno.', 'El Slayer regresa para salvar a la humanidad destruyendo ejércitos demoníacos.', '2020-03-20', 50.00, 'M', 39.99, 'Juego_Base', 88),
 (26, 'Fallout: New Vegas', 'RPG postapocalíptico en el yermo de Mojave.', 'Reparte justicia o siembra el caos en una Las Vegas devastada por la guerra nuclear.', '2010-10-22', 10.00, 'M', 9.99, 'Juego_Base', 84),
 (27, 'The Elder Scrolls V: Skyrim', 'Rol de fantasía épica en un mundo abierto helado.', 'Eres el Dovahkiin, destinado a derrotar al dragón mundial Alduin.', '2011-11-11', 12.00, 'M', 39.99, 'Juego_Base', 94),
 (28, 'Mass Effect Legendary Edition', 'Trilogía remasterizada de ópera espacial.', 'Reúne a la tripulación de la Normandy para salvar la galaxia de los Segadores.', '2021-05-14', 110.00, 'M', 59.99, 'Juego_Base', 86),
 (29, 'Dead Space Remake', 'Survival horror de ciencia ficción a bordo de la USG Ishimura.', 'Isaac Clarke debe sobrevivir a una plaga alienígena en el espacio profundo.', '2023-01-27', 32.00, 'M', 59.99, 'Juego_Base', 89),
 (30, 'Resident Evil 2 Remake', 'Clásico de terror de supervivencia reconstruido desde cero.', 'Leon y Claire luchan por sobrevivir al brote del virus T en Raccoon City.', '2019-01-25', 26.00, 'M', 39.99, 'Juego_Base', 91),
 (31, 'Resident Evil 3 Remake', 'Acción y terror en las calles de Raccoon City.', 'Jill Valentine intenta escapar de la destrucción de la ciudad y de un implacable Nemesis.', '2020-04-03', 25.00, 'M', 39.99, 'Juego_Base', 79),
 (32, 'Resident Evil 7: Biohazard', 'Terror en primera persona en una mansión rural.', 'Ethan Winters busca a su esposa desaparecida en una plantación abandonada en Luisiana.', '2017-01-24', 21.00, 'M', 19.99, 'Juego_Base', 86),
 (33, 'Resident Evil Village', 'Aventura de horror gótico en una aldea europea.', 'Ethan Winters se adentra en un misterioso pueblo nevado para rescatar a su hija.', '2021-05-07', 30.00, 'M', 39.99, 'Juego_Base', 84),
 (34, 'Monster Hunter Rise', 'Acción cooperativa de caza con cordópteros.', 'Defiende la aldea de Kamura de la catástrofe conocida como el Frenesí.', '2021-03-26', 23.00, 'T', 39.99, 'Juego_Base', 87),
 (35, 'Street Fighter 6', 'Lucha competitiva con nuevos sistemas de combate.', 'Muestra tu fuerza por todo el mundo con modos clásicos y modernos de combate.', '2023-06-02', 60.00, 'T', 59.99, 'Juego_Base', 92),
 (36, 'Dragon Dogma 2', 'RPG de acción en un mundo de fantasía profunda.', 'Vive tu propia aventura junto a tus peones en un inmenso mundo abierto dinámico.', '2024-03-22', 65.00, 'M', 69.99, 'Juego_Base', 86),
 (37, 'Ace Attorney Trilogy', 'Novela visual de juicios y misterios legales.', 'Toma el rol del abogado Phoenix Wright para demostrar la inocencia de tus clientes.', '2019-04-09', 2.00, 'T', 29.99, 'Juego_Base', 81),
 (38, 'Mega Man 11', 'Plataformas clásico de acción lateral.', 'El bombardero azul regresa con un nuevo sistema de doble engranaje.', '2018-10-02', 3.00, 'E', 29.99, 'Juego_Base', 82),
 (39, 'Devil May Cry 4 Special Edition', 'Hack and slash frenético con múltiples personajes.', 'Controla a Nero y Dante en una cruzada contra la Orden de la Espada.', '2015-06-23', 27.00, 'M', 24.99, 'Juego_Base', 78),
 (40, 'Devil May Cry 3 Special Edition', 'Los orígenes de la rivalidad entre Dante y Vergil.', 'Enfréntate a las hordas demoníacas que emergen de la torre Temen-ni-gru.', '2006-03-01', 5.00, 'M', 19.99, 'Juego_Base', 84),
 (41, 'Half-Life 2', 'Shooter clásico de ciencia ficción y revolución.', 'Gordon Freeman lidera la resistencia contra el imperio alienígena Combine.', '2004-11-16', 7.00, 'M', 9.99, 'Juego_Base', 96),
 (42, 'Left 4 Dead 2', 'Acción cooperativa de zombis en el sur de EE.UU.', 'Sobrevive junto a cuatro nuevos supervivientes a través de campañas infestadas.', '2009-11-17', 13.00, 'M', 9.99, 'Juego_Base', 89),
 (43, 'Team Fortress 2', 'Hero shooter multijugador basado en clases.', 'Elige entre nueve clases distintas y compite en dinámicos modos de juego.', '2007-10-10', 15.00, 'T', 0.00, 'Juego_Base', 92),
 (44, 'Counter-Strike 2', 'Shooter táctico competitivo por equipos.', 'Desactiva o defiende bombas en los mapas más emblemáticos del género.', '2023-09-27', 35.00, 'M', 0.00, 'Juego_Base', 82),
 (45, 'Dota 2', 'Estrategia multijugador de arena de batalla.', 'Destruye el Ancestro del equipo contrario eligiendo entre héroes únicos.', '2013-07-09', 60.00, 'T', 0.00, 'Juego_Base', 90),
 (46, 'BioShock', 'Shooter narrativo en la ciudad submarina de Rapture.', 'Descubre los restos de una utopía fallida gobernada por fanáticos y mutantes.', '2007-08-21', 25.00, 'M', 19.99, 'Juego_Base', 96),
 (47, 'BioShock 2', 'Regresa a Rapture bajo una nueva perspectiva.', 'Juega como un Big Daddy perfeccionado en busca de su Pequeña Sister.', '2010-02-09', 25.00, 'M', 19.99, 'Juego_Base', 88),
 (48, 'Borderlands 2', 'Loots shooter cooperativo en el planeta Pandora.', 'Derrota al tirano Handsome Jack junto a nuevos buscadores de la cámara.', '2012-09-18', 20.00, 'M', 19.99, 'Juego_Base', 89),
 (49, 'Borderlands 3', 'Viaja por múltiples planetas buscando cámaras.', 'Los gemelos Calypso amenazan el universo y debes detener su culto.', '2019-09-13', 75.00, 'M', 39.99, 'Juego_Base', 81),
 (50, 'Civilization VI', 'Estrategia por turnos para construir un imperio.', 'Lidera una civilización desde la edad de piedra hasta la era espacial.', '2016-10-21', 12.00, 'E', 29.99, 'Juego_Base', 88),
 (51, 'XCOM 2', 'Estrategia táctica por turnos contra la ocupación alienígena.', 'Comanda la resistencia global desde una base móvil en constante peligro.', '2016-02-05', 45.00, 'T', 39.99, 'Juego_Base', 88),
 (52, 'Mafia: Definitive Edition', 'Crimen organizado en la ciudad de Lost Heaven.', 'Tommy Angelo asciende en las filas de la mafia durante los años 30.', '2020-09-25', 45.00, 'M', 39.99, 'Juego_Base', 80),
 (53, 'Mafia II: Definitive Edition', 'Historia clásica de mafiosos en Empire Bay.', 'Vito Scaletta intenta pagar las deudas de su padre adentrándose en el bajo mundo.', '2020-05-19', 40.00, 'M', 29.99, 'Juego_Base', 74),
 (54, 'The Outer Worlds', 'RPG de acción y ciencia ficción en colonias espaciales.', 'Despierta de la hibernación en una nave perdida al borde de la galaxia.', '2019-10-25', 50.00, 'M', 29.99, 'Juego_Base', 85),
 (55, 'Pillars of Eternity', 'RPG isométrico de fantasía clásica y profunda.', 'Explora tierras donde las almas reencarnan y descubre un misterio divino.', '2015-03-26', 30.00, 'T', 29.99, 'Juego_Base', 89),
 (56, 'Tyranny', 'RPG donde los malvados ya han conquistado el mundo.', 'Trabaja como juez bajo el mandato de un tirano supremo.', '2016-11-10', 15.00, 'M', 29.99, 'Juego_Base', 80),
 (57, 'Disco Elysium', 'RPG de detectives y misterio psicológico.', 'Investiga un asesinato en una ciudad portuaria mientras lidias con tu propia amnesia.', '2019-10-15', 22.00, 'M', 39.99, 'Juego_Base', 97),
 (58, 'Subnautica', 'Supervivencia e exploración submarina en planeta alienígena.', 'Recoge recursos y construye hábitats en el vasto océano de 4546B.', '2018-01-23', 20.00, 'E', 29.99, 'Juego_Base', 87),
 (59, 'Subnautica: Below Zero', 'Expansión de supervivencia en región ártica alienígena.', 'Investiga los misterios del sector helado tras una expedición perdida.', '2021-05-14', 15.00, 'T', 29.99, 'Juego_Base', 82),
 (60, 'Cities: Skylines', 'Simulador avanzado de gestión y construcción urbana.', 'Diseña, planifica y administra la metrópolis perfecta para tus ciudadanos.', '2015-03-10', 4.00, 'E', 29.99, 'Juego_Base', 85),
 (61, 'Cities: Skylines II', 'La siguiente generación de simuladores de ciudades.', 'Construye una metrópolis desde cero y hazla crecer con una economía totalmente realista.', '2023-10-24', 50.00, 'E', 49.99, 'Juego_Base', 75),
 (62, 'Euro Truck Simulator 2', 'Simulador realista de transporte de carga por Europa.', 'Conduce camiones emblemáticos entregando mercancías a lo largo de ciudades europeas.', '2012-10-19', 15.00, 'E', 19.99, 'Juego_Base', 79),
 (63, 'American Truck Simulator', 'Explora las carreteras y autopistas de Norteamérica.', 'Transporta carga pesada a través de desiertos y grandes ciudades de Estados Unidos.', '2016-02-02', 15.00, 'E', 19.99, 'Juego_Base', 76),
 (64, 'Territory', 'Estrategia y conquista táctica global.', 'Comanda ejércitos en mapas detallados para dominar continentes enteros.', '2022-04-12', 8.00, 'T', 14.99, 'Juego_Base', 72),
 (65, 'Frostpunk', 'Supervivencia social en un mundo congelado.', 'Administra la última ciudad sobre la Tierra y toma decisiones morales extremas para sobrevivir.', '2018-04-24', 8.00, 'M', 29.99, 'Juego_Base', 84),
 (66, 'The Stanley Parable', 'Videojuego narrativo de comedia y decisiones.', 'Un juego donde sigues las reglas o rompes cada una de las indicaciones del narrador.', '2013-10-17', 5.00, 'T', 14.99, 'Juego_Base', 88),
 (67, 'Portal', 'Puzles innovadores basados en física y portales.', 'Usa la pistola de portales para escapar de los laboratorios de pruebas de Aperture Science.', '2007-10-10', 7.00, 'T', 9.99, 'Juego_Base', 90),
 (68, 'Slay the Spire', 'Constructor de mazos roguelike por turnos.', 'Crea un mazo único con cartas poderosas para escalar una torre llena de peligros.', '2019-01-23', 1.00, 'E', 24.99, 'Juego_Base', 89),
 (69, 'Dead Cells', 'Plataformas de acción roguelike vertiginosa.', 'Explora un castillo en constante cambio dominado por la corrupción.', '2018-08-07', 2.00, 'T', 24.99, 'Juego_Base', 89),
 (70, 'Risk of Rain 2', 'Shooter en tercera persona de acción cooperativa.', 'Lucha contra hordas alienígenas en un planeta extraño mientras el tiempo te desafía.', '2020-08-11', 4.00, 'T', 24.99, 'Juego_Base', 88),
 (71, 'Factorio', 'Construcción y automatización de factorías masivas.', 'Diseña cintas transportadoras, ensambladores y defiende tu base de los nativos.', '2020-08-14', 3.00, 'E', 35.00, 'Juego_Base', 90),
 (72, 'RimWorld', 'Simulador de colonia y gestión de historias espaciales.', 'Guía a tres supervivientes de un accidente estelar a construir un hogar próspero.', '2018-10-17', 1.00, 'M', 34.99, 'Juego_Base', 87),
 (73, 'Satisfactory', 'Construcción de fábricas en primera persona en 3D.', 'Explora un planeta alienígena recolectando recursos para construir complejos industriales.', '2020-06-08', 15.00, 'E', 29.99, 'Juego_Base', 90),
 (74, 'Valheim', 'Supervivencia vikinga en un mundo procedural.', 'Lucha, construye y explora en un purgatorio nórdico inspirado en la mitología.', '2021-02-02', 1.00, 'T', 19.99, 'Juego_Base', 84),
 (75, 'Palworld', 'Supervivencia, crafteo y colección de criaturas.', 'Colecciona misteriosas criaturas llamadas Pals para luchar, construir y trabajar.', '2024-01-19', 40.00, 'T', 29.99, 'Juego_Base', 72),
 (76, 'Phasmophobia', 'Terror psicológico cooperativo de investigación paranormal.', 'Entra en casas encantadas con equipo de caza de fantasmas junto a tus amigos.', '2020-09-18', 20.00, 'M', 13.99, 'Juego_Base', 83),
 (77, 'Among Us', 'Deducción social y traición en el espacio.', 'Trabaja para reparar la nave mientras descubres quiénes son los impostores.', '2018-11-16', 1.00, 'E', 4.99, 'Juego_Base', 75),
 (78, 'Fall Guys', 'Carreras de obstáculos masivas y caóticas.', 'Compite en coloridos minijuegos hasta alcanzar la corona dorada.', '2020-08-04', 2.00, 'E', 0.00, 'Juego_Base', 80),
 (79, 'Rocket League', 'Fútbol arcade con vehículos propulsados por cohetes.', 'Marca goles espectaculares en intensos partidos aéreos.', '2015-07-07', 20.00, 'E', 0.00, 'Juego_Base', 86),
 (80, 'Apex Legends', 'Battle royale de héroes con disparos tácticos.', 'Elige tu leyenda con habilidades únicas y compite por la gloria en equipo.', '2020-11-04', 75.00, 'T', 0.00, 'Juego_Base', 88),
 (81, 'Destiny 2', 'Acción multijugador masiva y saqueo espacial.', 'Defiende el sistema solar de amenazas alienígenas con superpoderes y armas.', '2019-10-01', 105.00, 'T', 0.00, 'Juego_Base', 83),
 (82, 'Warframe', 'Acción cooperativa futurista con ninjas espaciales.', 'Controla armaduras biomecánicas en misiones rápidas de saqueo y combate.', '2013-03-25', 50.00, 'M', 0.00, 'Juego_Base', 69),
 (83, 'Path of Exile', 'ARPG de acción oscura y profunda personalización.', 'Crea builds complejas con un gigantesco árbol de habilidades pasivas.', '2013-10-23', 40.00, 'M', 0.00, 'Juego_Base', 86),
 (84, 'Lost Ark', 'MMORPG de acción isométrica y mazmorras dinámicas.', 'Busca el Arca sagrada a través de combates masivos y cinemáticos.', '2022-02-11', 70.00, 'T', 0.00, 'Juego_Base', 78),
 (85, 'Guild Wars 2', 'MMORPG fantástico con mundo abierto dinámico.', 'Participa en eventos públicos masivos y batallas de mundo contra mundo.', '2012-08-28', 60.00, 'T', 0.00, 'Juego_Base', 90),
 (86, 'The Elder Scrolls Online', 'Rol multijugador masivo en Tamriel.', 'Explora las provincias del imperio junto a millones de jugadores en línea.', '2014-04-04', 85.00, 'M', 19.99, 'Juego_Base', 71),
 (87, 'Final Fantasy XIV Online', 'Aclamado MMORPG en el reino de Eorzea.', 'Lucha como un Guerrero de la Luz en una de las historias más épicas del género.', '2013-08-27', 80.00, 'T', 19.99, 'Juego_Base', 92),
 (88, 'Monster Hunter: Wilds', 'La nueva frontera de la caza de monstruos.', 'Enfréntate a ecosistemas extremos con la tecnología de caza más avanzada.', '2025-02-28', 140.00, 'T', 69.99, 'Juego_Base', 89),
 (89, 'Dragon Ball FighterZ', 'Lucha 3v3 con los icónicos personajes de Akira Toriyama.', 'Combates explosivos con animaciones que imitan fielmente el anime original.', '2018-01-26', 6.00, 'T', 59.99, 'Juego_Base', 87),
 (90, 'Dragon Ball Xenoverse 2', 'Crea tu propio patrullero del tiempo en batallas épicas.', 'Modifica la historia de Dragon Ball deteniendo alteraciones temporales.', '2016-10-27', 15.00, 'T', 49.99, 'Juego_Base', 74),
 (91, 'Tekken 8', 'Lucha visceral de nueva generación en 3D.', 'El torneo del puño de hierro regresa con un apartado visual increíble y mecánicas agresivas.', '2024-01-26', 80.00, 'T', 69.99, 'Juego_Base', 90),
 (92, 'Street Fighter V', 'Combates tácticos uno contra uno.', 'Compite en ligas mundiales con los luchadores clásicos de la saga.', '2016-02-16', 64.00, 'T', 19.99, 'Juego_Base', 77),
 (93, 'Mortal Kombat 11', 'Lucha sangrienta y personalización profunda de luchadores.', 'Controla a los protectores de la Tierra y viaja en el tiempo para reescribir el destino.', '2019-04-23', 100.00, 'M', 49.99, 'Juego_Base', 82),
 (94, 'Mortal Kombat 1', 'Un nuevo universo creado por el dios de fuego Liu Kang.', 'Disfruta de un sistema de kombatientes kameo y brutales fatalidades.', '2023-09-19', 140.00, 'M', 69.99, 'Juego_Base', 83),
 (95, 'Guilty Gear Strive', 'Lucha de precisión con gráficos en cel-shading.', 'Siente la adrenalina del rock y combates dinámicos con animaciones fluidas.', '2021-06-11', 20.00, 'T', 39.99, 'Juego_Base', 87),
 (96, 'BlazBlue: CentralFiction', 'Clímax de la saga de lucha bidimensional.', 'La batalla final por el destino del mundo arranca con mecánicas complejas.', '2016-10-06', 52.00, 'T', 29.99, 'Juego_Base', 84),
 (97, 'Persona 5 Royal', 'RPG de rol y simulación social en Tokio.', 'Vive una doble vida como estudiante de preparatoria y ladrón de corazones fantasma.', '2022-10-21', 27.00, 'M', 59.99, 'Juego_Base', 95),
 (98, 'Persona 4 Golden', 'Misterio de asesinatos en un pueblo rural japonés.', 'Descubre la verdad tras el canal de medianoche junto al grupo de investigación.', '2023-01-19', 14.00, 'M', 19.99, 'Juego_Base', 90),
 (99, 'Persona 3 Reload', 'Remake total del clásico oscuro de JRPG.', 'Enfréntate a las Sombras durante la misteriosa Hora Oscura con tus compañeros de clase.', '2024-02-02', 30.00, 'M', 69.99, 'Juego_Base', 88),
 (100, 'Shin Megami Tensei V: Vengeance', 'RPG oscuro de negociaciones con demonios.', 'Explora un Tokio postapocalíptico dividido entre ángeles y demonios.', '2024-06-14', 30.00, 'M', 59.99, 'Juego_Base', 89),
 (101, 'Yakuza 0', 'El inicio del mito en el Tokio y Osaka de los 80.', 'KAZUMA Kiryu y Goro Majima se ven envueltos en una brutal guerra de clanes mafiosos.', '2017-08-01', 26.00, 'M', 19.99, 'Juego_Base', 85),
 (102, 'Yakuza Kiwami', 'Remake del clásico origen del Dragón de Dojima.', 'Kiryu acepta una década de prisión por un crimen que no cometió para proteger a su hermano.', '2019-02-19', 20.00, 'M', 19.99, 'Juego_Base', 80),
 (103, 'Yakuza Kiwami 2', 'El choque de dos dragones en el mundo criminal.', 'Un asesinato amenaza con desatar una guerra total entre el Clan Tojo y la Alianza Omi.', '2019-05-09', 42.00, 'M', 19.99, 'Juego_Base', 85),
 (104, 'Like a Dragon: Infinite Wealth', 'RPG de turnos con Kasuga Ichiban en Hawái.', 'Una aventura masiva que cruza el océano Pacífico con combates dinámicos y humor.', '2024-01-26', 82.00, 'M', 69.99, 'Juego_Base', 89),
 (105, 'Judgement', 'Thriller de detectives y acción en Kamurocho.', 'Un ex-abogado devenido en investigador privado sigue la pista de un asesino en serie.', '2019-06-25', 40.00, 'M', 39.99, 'Juego_Base', 84);
 
 INSERT INTO Producto_Digital (ID_Producto, Titulo, Descripcion_Corta, Descripcion_Larga, Fecha_Lanzamiento, Tamano_GB, Clasificacion_Edad, Precio_Base_Actual, Tipo_Producto, Metacritic_Score) VALUES
 (106, 'Lost Judgment', 'Secuela del aclamado thriller de investigación.', 'Nuevos misterios de acoso escolar y asesinatos entrelazados en el bajo mundo japonés.', '2022-09-14', 60.00, 'M', 39.99, 'Juego_Base', 82),
 (107, 'NieR: Automata', 'Obra maestra de acción y filosofía cibernética.', 'Los androides 2B y 9S luchan por recuperar la Tierra de los invasores mecánicos.', '2017-03-17', 50.00, 'M', 39.99, 'Juego_Base', 84),
 (108, 'NieR Replicant ver.1.22474487139...', 'Precuela trágica y emotiva de acción y rol.', 'Un hermano busca desesperadamente una cura para la enfermedad letal de su hermana.', '2021-04-23', 25.00, 'M', 59.99, 'Juego_Base', 83),
 (109, 'Final Fantasy VII Remake Intergrade', 'Reimaginación profunda de la huida de Midgar.', 'Cloud Strife se une al grupo eco-terrorista Avalancha para destruir a la corporación Shinra.', '2021-06-10', 90.00, 'T', 69.99, 'Juego_Base', 87),
 (110, 'Final Fantasy XVI', 'Fantasía oscura de invocaciones y reinos en guerra.', 'Clive Rosfield busca venganza en un mundo donde los cristales madre se están marchitando.', '2023-06-22', 90.00, 'M', 69.99, 'Juego_Base', 87),
 (111, 'Octopath Traveler', 'JRPG clásico con dirección artística de alta definición.', 'Sigue las historias independientes de ocho viajeros a lo largo del continente.', '2019-06-07', 5.00, 'T', 59.99, 'Juego_Base', 83),
 (112, 'Octopath Traveler II', 'Historias cruzadas en un mundo dinámico de día y noche.', 'Otras ocho almas singulares cruzan sus destinos en una travesía inolvidable.', '2023-02-24', 8.00, 'T', 59.99, 'Juego_Base', 84),
 (113, 'Bravely Default II', 'Rol tradicional por turnos con sistema de trabajos.', 'Cuatro héroes guiados por cristales se embarcan en un viaje heróico.', '2021-09-02', 15.00, 'T', 59.99, 'Juego_Base', 76),
 (114, 'Live A Live', 'Historias paralelas a través de diferentes épocas.', 'Viaja desde la prehistoria hasta el futuro lejano descubriendo la verdad.', '2022-07-22', 5.00, 'T', 49.99, 'Juego_Base', 81),
 (115, 'Triangle Strategy', 'Estrategia táctica de decisiones morales complejas.', 'Toma bandos en una guerra por el control del hierro y la sal en el reino de Norzelia.', '2022-10-13', 10.00, 'T', 59.99, 'Juego_Base', 82),
 (116, 'Chained Echoes', 'JRPG inspirado en los clásicos de la época dorada de 16 bits.', 'Dragones, aeronaves y espadas mecánicas en un continente al borde de la guerra.', '2022-12-08', 1.00, 'T', 24.99, 'Juego_Base', 90),
 (117, 'Sea of Stars', 'Aventura de rol por turnos con combates dinámicos.', 'Los Hijos del Solsticio combinan sus poderes para derrotar a los monstruos del alquimista.', '2023-08-29', 5.00, 'E', 34.99, 'Juego_Base', 87),
 (118, 'CrossCode', 'Acción retro en un MMORPG ficticio de ciencia ficción.', 'Ayuda a una jugadora con amnesia a avanzar por un mundo virtual lleno de misterios.', '2018-09-20', 1.00, 'T', 19.99, 'Juego_Base', 86),
 (119, 'Indivisible', 'Acción de plataformas y combates por turnos.', 'Una joven rebelde descubre que puede absorber personalidades en su interior.', '2019-10-08', 6.00, 'T', 39.99, 'Juego_Base', 78),
 (120, 'Guacamelee! 2', 'Metroidvania de lucha libre mexicana y humor.', 'Juan Aguacate regresa para salvar al Mexiverso de una colisión dimensional.', '2018-08-21', 2.00, 'T', 19.99, 'Juego_Base', 86),
 (121, 'Bloodstained: Ritual of the Night', 'Metroidvania de acción con elementos de horror gótico.', 'Miriam debe explorar un castillo infestados de demonios para salvar la humanidad.', '2019-06-18', 12.00, 'T', 39.99, 'Juego_Base', 83),
 (122, 'Castlevania Advance Collection', 'Recopilación de clásicos metroidvania de GBA.', 'Revive cuatro icónicas entregas de Castlevania en un solo paquete moderno.', '2021-09-23', 3.00, 'T', 19.99, 'Juego_Base', 82),
 (123, 'Castlevania Dominus Collection', 'Colección remasterizada de títulos de DS.', 'Explora las aventuras de Shanoa, Soma y Jonathan con controles táctiles optimizados.', '2024-08-27', 4.00, 'T', 24.99, 'Juego_Base', 86),
 (124, 'Blasphemous', 'Acción y hack and slash con estética barroca oscura.', 'El Penitente debe purgar las tierras de Cvstodia de la maldición del Milagro.', '2019-09-10', 4.00, 'M', 24.99, 'Juego_Base', 77),
 (125, 'Blasphemous 2', 'Secuela del Castlevania hispano de fantasía oscura.', 'El Penitente despierta de nuevo para enfrentarse al nacimiento de un nuevo niño del Milagro.', '2023-08-24', 5.00, 'M', 29.99, 'Juego_Base', 83),
 (126, 'Ender Lilies: Quietus of the Knights', 'Metroidvania gótico de acción y espíritus.', 'Lily despierta en una iglesia para purificar a los infectados por la lluvia de la muerte.', '2021-06-21', 2.00, 'T', 24.99, 'Juego_Base', 86),
 (127, 'The Messenger', 'Acción ninja retro de 8 y 16 bits.', 'Lleva un pergamino vital a través de un mundo maldito para salvar a tu clan.', '2018-08-30', 2.00, 'T', 19.99, 'Juego_Base', 86),
 (128, 'Ori and the Blind Forest', 'Plataformas de aventura emotiva y artística.', 'Un joven espíritu huérfano explora el bosque moribundo de Nibel.', '2015-03-11', 11.00, 'E', 19.99, 'Juego_Base', 88),
 (129, 'Ori and the Will of the Wisps', 'Secuela magistral con combates y movilidad mejorada.', 'Empréndete en un viaje más allá del bosque para descubrir el verdadero destino de Ori.', '2020-03-11', 15.00, 'E', 29.99, 'Juego_Base', 90),
 (130, 'Celeste', 'Desafiante juego de plataformas sobre superación.', 'Ayuda a Madeline a sobrevivir a sus demonios internos mientras escala la montaña Celeste.', '2018-01-25', 1.50, 'E', 19.99, 'Juego_Base', 94),
 (131, 'Cuphead', 'Plataformas y jefes con estética de caricaturas de 1930.', 'Cuphead y Mugman deben saldar su deuda con el diablo derrotando peligrosos jefes.', '2017-09-29', 4.00, 'E', 19.99, 'Juego_Base', 88),
 (132, 'Super Meat Boy', 'Plataformas frenético de alta dificultad y precisión.', 'Un trozo de carne animado rescata a su novia secuestrada por un feto en un frasco.', '2010-10-20', 1.00, 'T', 14.99, 'Juego_Base', 87),
 (133, 'Katana Zero', 'Acción neo-noir rápida con manipulación del tiempo.', 'Un asesino con amnesia utiliza una droga militar para predecir el futuro y matar.', '2019-04-18', 1.00, 'M', 14.99, 'Juego_Base', 83),
 (134, 'Hotline Miami', 'Shooter cenital violento y frenético en los 80s.', 'Recibe misteriosas llamadas telefónicas y limpia instalaciones enteras de la mafia.', '2012-10-23', 1.00, 'M', 9.99, 'Juego_Base', 85),
 (135, 'Hotline Miami 2: Wrong Number', 'Conclusión sangrienta y coral de la masacre.', 'Sigue los pasos de múltiples facciones en una espiral de violencia e paranoia.', '2015-03-10', 2.00, 'M', 14.99, 'Juego_Base', 74),
 (136, 'My Friend Pedro', 'Ballet con armas de fuego y acción ralentizada.', 'Dispara a tus enemigos haciendo piruetas por orden de un plátano consciente.', '2019-06-20', 4.00, 'M', 19.99, 'Juego_Base', 81),
 (137, 'Ape Out', 'Huida salvaje con perspectiva superior y jazz libre.', 'Un gorila enojado destroza a sus captores para escapar a la libertad.', '2019-02-28', 2.00, 'M', 14.99, 'Juego_Base', 83),
 (138, 'Enter the Gungeon', 'Bullet hell roguelike en una mazmorra de armas.', 'Un grupo de desatados busca la pistola que puede matar el pasado.', '2016-04-05', 2.00, 'T', 14.99, 'Juego_Base', 84),
 (139, 'Nuclear Throne', 'Shooter postapocalíptico de acción acelerada.', 'Muta a tu personaje matando monstruos en un yermo radiactivo.', '2015-12-05', 1.00, 'T', 11.99, 'Juego_Base', 88),
 (140, 'The Binding of Isaac: Rebirth', 'Roguelike bíblico de acción e ítems aleatorios.', 'Isaac huye al sótano de su casa para escapar del sacrificio de su madre.', '2014-11-04', 1.00, 'M', 14.99, 'Juego_Base', 86),
 (141, 'Spelunky', 'Exploración procedural de celdas y tesoros.', 'Adéntrate en cavernas subterráneas llenas de trampas y criaturas agresivas.', '2013-08-08', 1.00, 'T', 14.99, 'Juego_Base', 90),
 (142, 'Spelunky 2', 'Aventura en la Luna con dinámicas de fluidos mejoradas.', 'Busca a tus padres desaparecidos en los túneles lunares cambiantes.', '2020-09-29', 1.00, 'T', 19.99, 'Juego_Base', 91),
 (143, 'Inscryption', 'Juego de cartas con misterio y terror psicológico.', 'Un siniestro juego de mesa atrapa al jugador en una cabaña en medio del bosque.', '2021-10-19', 3.00, 'M', 19.99, 'Juego_Base', 85),
 (144, 'Loop Hero', 'Estrategia y rol donde construyes la ruta del héroe.', 'Usa cartas para restaurar el mundo borrado por un lich malvado.', '2021-03-04', 1.00, 'E', 14.99, 'Juego_Base', 82),
 (145, 'Vampire Survivors', 'Acción de supervivencia donde eres el infierno de balas.', 'Sobrevive a miles de criaturas de la noche combinando armas automáticas.', '2022-10-20', 1.00, 'T', 4.99, 'Juego_Base', 86),
 (146, 'Brotato', 'Shooter de supervivencia con una patata armada.', 'Una patata alienígena combate contra oleadas de invasores en un planeta remoto.', '2023-06-23', 1.00, 'E', 4.99, 'Juego_Base', 78),
 (147, 'Deep Rock Galactic', 'FPS cooperativo con enanos mineros espaciales.', 'Explora cuevas destructibles en equipo minando minerales y matando bichos.', '2020-05-13', 3.00, 'T', 29.99, 'Juego_Base', 85),
 (148, 'Deep Rock Galactic: Survivor', 'Auto-shooter individual en las minas de Hoxxes.', 'Enfréntate a las hordas alienígenas en solitario recolectando riquezas.', '2024-02-14', 2.00, 'T', 9.99, 'Juego_Base', 79),
 (149, 'Helldivers 2', 'Shooter en tercera persona de pura libertad galáctica.', 'Únete a los Helldivers y combate por la democracia administrada en la galaxia.', '2024-02-08', 70.00, 'M', 39.99, 'Juego_Base', 82),
 (150, 'Sea of Thieves', 'Aventura pirata de mundo abierto multijugador.', 'Navega, combate, saquea y explora para convertirte en una leyenda pirata.', '2020-06-03', 100.00, 'T', 39.99, 'Juego_Base', 80),
 (151, 'Valheim: Mistlands Edition', 'Supervivencia vikinga expandida en tierras de niebla.', 'Explora biomas peligrosos y combate criaturas nórdicas en un mundo mitológico.', '2022-12-06', 2.00, 'T', 19.99, 'Juego_Base', 85),
 (152, 'Grounding: Small Big World', 'Supervivencia diminuta en el patio trasero de una casa.', 'Lucha contra hormigas y arañas gigantes tras haber sido encogido al tamaño de un insecto.', '2022-09-27', 12.00, 'T', 39.99, 'Juego_Base', 82),
 (153, 'Green Hell', 'Supervivencia extrema en la selva del Amazonas.', 'Mantén tu cordura y aprende técnicas reales de supervivencia para escapar con vida.', '2019-09-05', 8.00, 'M', 24.99, 'Juego_Base', 78),
 (154, 'The Forest', 'Terror y supervivencia tras un accidente aéreo.', 'Construye un refugio y defiéndete de una tribu de mutantes caníbales en la península.', '2018-04-30', 5.00, 'M', 19.99, 'Juego_Base', 83),
 (155, 'Sons of the Forest', 'Regresa a la isla de los caníbales con tecnología moderna.', 'Enviado a buscar a un multimillonario desaparecido en un infierno de caníbales.', '2024-02-22', 15.00, 'M', 29.99, 'Juego_Base', 86),
 (156, 'Rust', 'Supervivencia multijugador hostil sin reglas.', 'Supera el hambre, la sed y a otros jugadores implacables construyendo tu fortaleza.', '2018-02-08', 25.00, 'M', 39.99, 'Juego_Base', 69),
 (157, 'ARK: Survival Evolved', 'Domesticación de dinosaurios y tecnología en una isla.', 'Caza, cosecha, fabrica herramientas y construye refugios para sobrevivir con dinosaurios.', '2017-08-27', 60.00, 'T', 19.99, 'Juego_Base', 70),
 (158, 'ARK: Survival Ascended', 'Reconstrucción en Unreal Engine 5 de la aventura jurásica.', 'Experimenta el mundo de ARK completamente reimaginado con física de fluidos de vanguardia.', '2023-10-25', 80.00, 'T', 44.99, 'Juego_Base', 75),
 (159, 'Conan Exiles', 'Supervivencia barbárica en las tierras exiliadas.', 'Domina a tus enemigos y construye grandes ciudades en el universo salvaje de Conan.', '2018-05-08', 115.00, 'M', 39.99, 'Juego_Base', 68),
 (160, 'DayZ', 'Supervivencia zombi en una república postsoviética.', 'Sobrevive a infectados y a otros jugadores en un mapa masivo de 230 kilómetros cuadrados.', '2018-12-13', 25.00, 'M', 44.99, 'Juego_Base', 75),
 (161, 'Project Zomboid', 'Simulador realista e implacable de apocalipsis zombi.', 'Cosecha recursos, fortifica casas y gestiona tu salud física y mental hasta morir.', '2013-11-08', 5.00, 'M', 19.99, 'Juego_Base', 88),
 (162, '7 Days to Die', 'Híbrido de vóxel, supervivencia y hordas zombi.', 'Craftea y fortifica tu base para aguantar los ataques destructivos de la séptima noche.', '2024-07-25', 15.00, 'M', 44.99, 'Juego_Base', 78),
 (163, 'Don’t Starve', 'Supervivencia salvaje con estética gótica victoriana.', 'Entra en un mundo inexplorado repleto de criaturas extrañas y peligros oscuros.', '2013-04-23', 2.00, 'T', 9.99, 'Juego_Base', 79),
 (164, 'Don’t Starve Together', 'Expansión multijugador cooperativa del desierto gótico.', 'Sobrevive junto a tus amigos resolviendo misterios y combatiendo jefes de estación.', '2016-04-21', 3.00, 'T', 14.99, 'Juego_Base', 83),
 (165, 'Raft', 'Supervivencia oceánica sobre una tabla flotante.', 'Recoge escombros del mar con tu gancho para ampliar tu balsa y esquivar tiburones.', '2022-06-20', 10.00, 'T', 19.99, 'Juego_Base', 89),
 (166, 'Astroneer', 'Exploración espacial y moldeado de planetas.', 'Edifica bases en mundos distantes alterando el terreno con la herramienta de deformación.', '2019-02-06', 4.00, 'E', 29.99, 'Juego_Base', 71),
 (167, 'No Man’s Sky', 'Exploración espacial procedimental con infinitos planetas.', 'Viaja por un universo ilimitado descubriendo especies únicas y comercio estelar.', '2016-08-12', 15.00, 'T', 59.99, 'Juego_Base', 71),
 (168, 'Elite Dangerous', 'Simulador espacial épico a escala real de la Vía Láctea.', 'Toma el control de tu propia nave en una galaxia viva recortada por la guerra.', '2015-04-02', 50.00, 'T', 29.99, 'Juego_Base', 80),
 (169, 'Kerbal Space Program', 'Simulador realista de física e ingeniería espacial.', 'Construye cohetes espaciales funcionales para llevar a los Kerbals a la luna.', '2015-04-27', 4.00, 'E', 39.99, 'Juego_Base', 88),
 (170, 'Space Engineers', 'Construcción e ingeniería de naves espaciales sandbox.', 'Diseña estaciones, puestos de avanzada y explora asteroides con física realista.', '2019-02-28', 35.00, 'E', 19.99, 'Juego_Base', 73),
 (171, 'Outer Wilds', 'Misterio espacial en un bucle temporal de 22 minutos.', 'Explora un sistema solar hecho a mano antes de que la estrella central explote.', '2019-05-28', 8.00, 'E', 24.99, 'Juego_Base', 85),
 (172, 'Death Stranding Director’s Cut', 'Aventura cinemática sobre reconectar a la sociedad.', 'Sam Porter Bridges debe cruzar unos Estados Unidos devastados para salvar el futuro.', '2022-03-30', 80.00, 'M', 39.99, 'Juego_Base', 85),
 (173, 'Control Ultimate Edition', 'Acción sobrenatural en la sede del FBD.', 'Jesse Faden utiliza poderes telequinéticos para erradicar una amenaza dimensional.', '2020-08-27', 42.00, 'M', 39.99, 'Juego_Base', 82),
 (174, 'Alan Wake 2', 'Survival horror psicológico y misterio policíaco.', 'La agente Saga Anderson investiga rituales oscuros mientras Alan intenta escapar.', '2023-10-27', 90.00, 'M', 59.99, 'Juego_Base', 89),
 (175, 'Quantum Break', 'Drama temporal y disparos con control del tiempo.', 'Manipula el tiempo para sobrevivir en un mundo donde la física temporal se rompe.', '2016-09-29', 68.00, 'M', 39.99, 'Juego_Base', 77),
 (176, 'Prey', 'Sci-Fi thriller a bordo de la estación espacial Talos I.', 'Utiliza armas improvisadas e ingenio para sobrevivir a los alienígenas Tifón.', '2017-05-05', 20.00, 'M', 29.99, 'Juego_Base', 82),
 (177, 'Dishonored', 'Sigilo e inmersión táctica con habilidades místicas.', 'Corvo Attano busca limpiar su nombre tras ser acusado del asesinato de la emperatriz.', '2012-10-09', 10.00, 'M', 9.99, 'Juego_Base', 91),
 (178, 'Dishonored 2', 'Sigilo y asesinatos creativos en la costera Karnaca.', 'Elige entre Emily Kaldwin o Corvo Attano para recuperar el trono arrebatado.', '2016-11-11', 60.00, 'M', 29.99, 'Juego_Base', 86),
 (179, 'DEATHLOOP', 'Asesinatos en bucle temporal en la isla de Blackreef.', 'Colt debe eliminar a ocho objetivos principales antes de que el día se reinicie.', '2021-09-14', 30.00, 'M', 59.99, 'Juego_Base', 87),
 (180, 'Ghostwire: Tokyo', 'Acción sobrenatural en primera persona por Tokio.', 'Combina poderes elementales para erradicar a los espíritus que invadieron la ciudad.', '2022-03-25', 20.00, 'T', 59.99, 'Juego_Base', 75),
 (181, 'Hi-Fi RUSH', 'Acción y combate rítmico con estética de cómic.', 'Chai se enfrenta a una megacorporación malvada donde todo el mundo se mueve al ritmo.', '2023-01-25', 20.00, 'T', 29.99, 'Juego_Base', 89),
 (182, 'Wolfenstein: The New Order', 'FPS de historia alternativa con resistencia antinazi.', 'BJ Blazkowicz despierta en un 1960 alternativo gobernado por un régimen tiránico.', '2014-05-20', 50.00, 'M', 19.99, 'Juego_Base', 81),
 (183, 'Wolfenstein II: The New Colossus', 'La Segunda Revolución Americana en suelo estadounidense.', 'Reúne a la resistencia en EE.UU. para expulsar a las fuerzas de ocupación.', '2017-10-27', 55.00, 'M', 39.99, 'Juego_Base', 86),
 (184, 'DOOM (2016)', 'El renacimiento del rey de los shooters de acción.', 'Ábrete paso a través de las instalaciones de la UAC en Marte masacrando demonios.', '2016-05-13', 55.00, 'M', 19.99, 'Juego_Base', 85),
 (185, 'RAGE 2', 'Shooter en mundo abierto con poderes destructivos.', 'Explora un páramo sin ley destruyendo facciones sangrientas con armas pesadas.', '2019-05-14', 50.00, 'M', 39.99, 'Juego_Base', 73),
 (186, 'Metro 2033 Redux', 'Survival horror en los túneles del metro de Moscú.', 'Artyom debe viajar al corazón del sistema ferroviario para advertir a la humanidad.', '2014-08-26', 10.00, 'M', 19.99, 'Juego_Base', 90),
 (187, 'Metro: Last Light Redux', 'La lucha final bajo las ruinas de Moscú.', 'Mantén la esperanza viva enfrentándote a mutantes y facciones humanas rivales.', '2014-08-26', 10.00, 'M', 19.99, 'Juego_Base', 82),
 (188, 'Metro Exodus', 'Viaje épico a bordo del tren Aurora por Rusia.', 'Abandona el metro en busca de una nueva vida en las tierras heladas del este.', '2019-02-15', 50.00, 'M', 29.99, 'Juego_Base', 82),
 (189, 'S.T.A.L.K.E.R.: Shadow of Chernobyl', 'FPS de supervivencia en la Zona de Exclusión.', 'Sobrevive a la radiación, anomalías y mutantes buscando el secreto del C-Consciousness.', '2007-03-20', 10.00, 'M', 19.99, 'Juego_Base', 82),
 (190, 'S.T.A.L.K.E.R. 2: Heart of Chornobyl', 'Regreso a la Zona con apartado gráfico fotorrealista.', 'Toma decisiones que cambiarán el destino de la Zona en un mapa inmenso.', '2024-11-20', 150.00, 'M', 59.99, 'Juego_Base', 80),
 (191, 'Atomic Heart', 'Shooter ambientado en una utopía soviética fallida.', 'El agente P-3 debe investigar la rebelión de los robots en la Instalación 3826.', '2023-02-21', 90.00, 'M', 59.99, 'Juego_Base', 75),
 (192, 'System Shock Remake', 'Clásico RPG sci-fi reconstruido con motor moderno.', 'Enfréntate a la IA corrupta SHODAN a bordo de la estación espacial Citadel.', '2023-05-30', 10.00, 'M', 39.99, 'Juego_Base', 78),
 (193, 'Deus Ex: Human Revolution', 'RPG ciberpunk de sigilo y aumentos biomecánicos.', 'Adam Jensen investiga un ataque terrorista que cambió el rumbo de su vida.', '2011-08-23', 20.00, 'M', 19.99, 'Juego_Base', 90),
 (194, 'Deus Ex: Mankind Divided', 'La brecha humana tras el incidente de los aumentos.', 'Descubre una conspiración global en una Praga segregada y violenta.', '2016-08-23', 55.00, 'M', 29.99, 'Juego_Base', 83),
 (195, 'Sniper Elite 5', 'Disparos tácticos de precisión en la Francia de 1944.', 'Karl Fairburne debe neutralizar el proyecto secreto nazi Operación Kraken.', '2022-05-26', 85.00, 'M', 49.99, 'Juego_Base', 79),
 (196, 'Hitman World of Assassination', 'El simulador definitivo de asesinatos por encargo.', 'Conviértete en el Agente 47 ejecutando contratos a lo largo del mundo.', '2021-01-20', 70.00, 'M', 69.99, 'Juego_Base', 87),
 (197, 'Payday 2', 'Heists cooperativos y atracciones bancarias masivas.', 'Planea y ejecuta robos armados con personalización extrema de máscaras y armas.', '2013-08-13', 83.00, 'M', 9.99, 'Juego_Base', 79),
 (198, 'Payday 3', 'La cuadrilla Payday regresa para asaltar Nueva York.', 'Supera los sistemas de seguridad más modernos en robos coordinados en equipo.', '2023-09-21', 50.00, 'M', 39.99, 'Juego_Base', 67),
 (199, 'Arma 3', 'Simulación militar táctica a gran escala.', 'Comanda operaciones combinadas por tierra, mar y aire en un mapa realista.', '2013-09-12', 45.00, 'M', 29.99, 'Juego_Base', 74),
 (200, 'Squad', 'Combate bélico combinado entre facciones modernas.', 'Comunícate mediante radio de proximidad en batallas de 50 contra 50.', '2020-09-23', 55.00, 'M', 49.99, 'Juego_Base', 79),
 (201, 'Hell Let Loose', 'Guerra táctica en la Segunda Guerra Mundial.', 'Lucha en batallas emblemáticas del frente occidental con tanques y artillería.', '2021-07-27', 35.00, 'M', 44.99, 'Juego_Base', 79),
 (202, 'Insurgency: Sandstorm', 'Shooter táctico en primera persona enfocado en letalidad.', 'Siente la balística realista y el combate urbano de infantería en Oriente Medio.', '2018-12-12', 50.00, 'M', 29.99, 'Juego_Base', 78),
 (203, 'Hunt: Showdown 1896', 'Caza de recompensas PvPvE en los pantanos oscuros.', 'Elimina monstruos de pesadilla y huye con el botín antes de que otros te maten.', '2019-08-27', 40.00, 'M', 39.99, 'Juego_Base', 81),
 (204, 'Escape from Tarkov', 'Simulator de extracción hardcore e inventario realista.', 'Busca recursos y sobrevive a las incursiones en la región devastada de Norvinsk.', '2017-07-27', 40.00, 'M', 50.00, 'Juego_Base', 85),
 (205, 'Ready or Not', 'Simulador táctico policial de asalto SWAT.', 'Resuelve situaciones de rehenes y alto riesgo con estrategias de equipo metódicas.', '2023-12-13', 50.00, 'M', 49.99, 'Juego_Base', 79),
 (206, 'Six Days in Fallujah', 'Shooter táctico basado en historias reales de la infantería.', 'Experimenta la intensidad del combate urbano en Fallujah con mapas dinámicos.', '2023-06-22', 25.00, 'M', 39.99, 'Juego_Base', 77),
 (207, 'Enlisted', 'Shooter de escuadrones en campañas históricas.', 'Controla a soldados y sus escuadrones de apoyo en enormes batallas bélicas.', '2021-03-02', 40.00, 'M', 0.00, 'Juego_Base', 75),
 (208, 'War Thunder', 'Combates de vehículos blindados, aviación y buques.', 'Enfréntate en tierra, aire y mar con vehículos militares de múltiples épocas.', '2013-08-15', 95.00, 'T', 0.00, 'Juego_Base', 82),
 (209, 'World of Tanks', 'Lucha estratégica de blindados de mediados del siglo XX.', 'Comanda tanques legendarios en mapas con terrenos variados.', '2011-04-12', 60.00, 'T', 0.00, 'Juego_Base', 80),
 (210, 'World of Warships', 'Batallas navales con acorazados, destructores y portaaviones.', 'Domina los mares coordinando ataques navales con la flota militar.', '2015-09-17', 65.00, 'T', 0.00, 'Juego_Base', 81),
 (211, 'Cyberpunk 2077: Phantom Liberty', 'Expansión de espionaje en Dogtown.', 'Adéntrate en el distrito más peligroso de Night City en una misión de rescate presidencial.', '2023-09-26', 33.00, 'M', 29.99, 'DLC', 88),
 (212, 'Cyberpunk 2077: Bonus Content Pack', 'Artbook digital, avatar y wallpapers oficiales.', 'Contenido digital exclusivo para los fans de Night City.', '2020-12-10', 2.00, 'M', 0.00, 'DLC', 80), -- Gratuito 1
 (213, 'Elden Ring: Shadow of the Erdtree', 'Expansión masiva en la Land of Shadow.', 'Descubre los oscuros secretos de Miquella y enfrenta jefes desafiantes.', '2024-06-21', 20.00, 'M', 39.99, 'DLC', 94),
 (214, 'The Witcher 3: Hearts of Stone', 'Aventura en las tierras de nadie de Velen.', 'Geralt acepta un contrato para derrotar a un capitán bandido inmortal.', '2015-10-13', 10.00, 'M', 9.99, 'DLC', 90),
 (215, 'The Witcher 3: Blood and Wine', 'Expansión final en la soleada región de Toussaint.', 'Viaja a una tierra no azotada por la guerra que oculta un secreto sangriento.', '2016-05-31', 15.00, 'M', 19.99, 'DLC', 92),
 (216, 'The Witcher 3: Alternative Look Set', 'Aspectos alternativos para Yennefer, Triss y Ciri.', 'Paquete estético gratuito para personajes principales.', '2015-06-15', 0.50, 'M', 0.00, 'DLC', 85), -- Gratuito 2
 (217, 'GTA V: Criminal Enterprise Starter Pack', 'Impulso inicial para tu imperio criminal.', 'Obtén acceso a propiedades, vehículos y dinero en GTA Online.', '2017-12-14', 5.00, 'M', 9.99, 'DLC', 75);

 INSERT INTO Producto_Digital (ID_Producto, Titulo, Descripcion_Corta, Descripcion_Larga, Fecha_Lanzamiento, Tamano_GB, Clasificacion_Edad, Precio_Base_Actual, Tipo_Producto, Metacritic_Score) VALUES

 (218, 'Baldurs Gate 3: Digital Deluxe Edition DLC', 'Artículos cosméticos y banda sonora de bardos.', 'Incluye temas para el campamento y bolsa de suministros aventureros.', '2023-08-03', 3.00, 'M', 9.99, 'DLC', 88),
 (219, 'God of War Ragnarök: Valhalla', 'Epílogo roguelite en el palacio de Valhalla.', 'Kratos enfrenta pruebas físicas y mentales en un viaje de introspección.', '2023-12-12', 8.00, 'M', 0.00, 'DLC', 89), -- Gratuito 3
 (220, 'Red Dead Redemption 2: War Horse Pack', 'Caballo de guerra exclusivo y kit de supervivencia.', 'Un corcel confiable con mayor resistencia para recorrer el oeste.', '2018-10-26', 0.10, 'M', 0.00, 'DLC', 82), -- Gratuito 4
 (221, 'Resident Evil 4: Separate Ways', 'La historia no contada desde la perspectiva de Ada.', 'Sigue los pasos de Ada Wong en una misión paralela a la de Leon.', '2023-09-21', 11.00, 'M', 9.99, 'DLC', 89),
 (222, 'Resident Evil 4: Mercenaries Mode', 'Modo de juego arcade lleno de acción frenética.', 'Elimina hordas de enemigos antes de que el tiempo se agote.', '2023-04-07', 2.00, 'M', 0.00, 'DLC', 87), -- Gratuito 5
 (223, 'Monster Hunter World: Iceborne', 'Expansión de rango maestro en el Reach Escarchado.', 'Nuevas subespecies, armas e interacciones de caza en clima gélido.', '2019-09-06', 30.00, 'T', 39.99, 'DLC', 89),
 (224, 'Monster Hunter World: Handler Costume', 'Atuendo festivo para la camarada de caza.', 'Cambia la vestimenta de la encarga en la base de operaciones.', '2018-02-15', 0.20, 'T', 1.99, 'DLC', 70),
 (225, 'Hollow Knight: Godmaster', 'El capítulo final con desafíos de panteones.', 'Enfréntate a los dioses resplandecientes en el coliseo de la mente.', '2018-08-23', 0.80, 'E', 0.00, 'DLC', 92), -- Gratuito 6
 (226, 'Hollow Knight: The Grimm Troupe', 'Misterioso circo de pesadilla y nuevos talismanes.', 'Enciende los faroles para invocar al Rey Grimm al reino subterráneo.', '2017-10-26', 0.50, 'E', 0.00, 'DLC', 90), -- Gratuito 7
 (227, 'Stardew Valley: Official Soundtrack', 'Banda sonora completa en formato Lossless.', 'Disfruta de las melodías compuestas para cada estación del año.', '2016-03-05', 0.60, 'E', 4.99, 'DLC', 91),
 (228, 'Devil May Cry 5: Playable Vergil', 'Juega toda la campaña como Vergil.', 'Domina la espada Yamato y el estilo de combate de motivación pura.', '2020-12-15', 2.00, 'M', 4.99, 'DLC', 88),
 (229, 'Dark Souls III: Ashes of Ariandel', 'Mundo pintado cubierto de nieve y podredumbre.', 'Descubre el secreto que consume la pintura y enfrenta a la Hermana Friede.', '2016-10-25', 4.00, 'M', 14.99, 'DLC', 82),
 (230, 'Dark Souls III: The Ringed City', 'El viaje final al fin del mundo y de los tiempos.', 'Desciende a la ciudad anillada para encontrar la alma oscura de la humanidad.', '2017-03-28', 6.00, 'M', 14.99, 'DLC', 89),
 (231, 'Cuphead: The Delicious Last Course', 'Nueva isla con la chef Ms. Chalice y jefes.', 'Una aventura llena de armas mágicas, amuletos y sorpresas culinarias.', '2022-06-30', 3.00, 'E', 7.99, 'DLC', 88),
 (232, 'Celeste: Farewell Chapter 9', 'Más de 100 niveles finales de alta dificultad.', 'Madeline afronta el duelo en una travesía espacial dentro de sus sueños.', '2019-09-09', 0.50, 'E', 0.00, 'DLC', 95), -- Gratuito 8
 (233, 'Dead Cells: Return to Castlevania', 'Colaboración épica con la saga Castlevania.', 'Explora el castillo de Drácula junto a Richter Belmont y Alucard.', '2023-03-06', 1.50, 'T', 9.99, 'DLC', 90),
 (234, 'Dead Cells: The Bad Seed', 'Nuevos biomas de arboreto y ciénaga maldita.', 'Enfréntate a plantas carnívoras y a la gigantesca Garrapata Mamá.', '2020-02-11', 0.50, 'T', 4.99, 'DLC', 84),
 (235, 'Dead Cells: Fatal Falls', 'Islas flotantes y santuarios en las nubes.', 'Añade un nuevo camino a la mitad de la partida con un compañero espada voladora.', '2021-01-26', 0.50, 'T', 4.99, 'DLC', 85),
 (236, 'Risk of Rain 2: Survivors of the Void', 'Nuevos supervivientes y dimensión del vacío.', 'Aprovecha los ítems corruptos para desatar el caos en fases alienígenas.', '2022-03-01', 1.00, 'T', 14.99, 'DLC', 82),
 (237, 'Factorio: Space Age', 'Lleva la automatización a múltiples planetas.', 'Construye plataformas espaciales y gestiona logística interplanetaria.', '2024-10-21', 2.00, 'E', 35.00, 'DLC', 93),
 (238, 'RimWorld: Royalty', 'Títulos nobiliarios, poderes psíquicos y tecnología.', 'Interactúa con el Imperio para obtener favores reales y estructuras de lujo.', '2020-02-24', 0.20, 'M', 19.99, 'DLC', 86),
 (239, 'RimWorld: Ideology', 'Crea tu propio sistema de creencias e ideologías.', 'Define el estilo de vida de tu colonia: cultos caníbales, tecno-religiones o nómadas.', '2021-07-20', 0.20, 'M', 19.99, 'DLC', 84),
 (240, 'RimWorld: Biotech', 'Controla mecanoides, genética y crianza de niños.', 'Crea super-soldados mutantes o utiliza trabajadores robóticos automatizados.', '2022-10-21', 0.30, 'M', 24.99, 'DLC', 91),
 (241, 'Civilization VI: Gathering Storm', 'Efectos climáticos, geología y congreso mundial.', 'Afronta desastres naturales y recursos agotables en un planeta vivo.', '2019-02-14', 3.00, 'E', 39.99, 'DLC', 80),
 (242, 'Civilization VI: Rise and Fall', 'Lealtad de ciudades, edades de oro y gobernadores.', 'Guía a tu civilización a través de épocas de prosperidad o crisis sociales.', '2018-02-08', 2.50, 'E', 29.99, 'DLC', 79),
 (243, 'Civilization VI: Leader Pass Free Pack', 'Nuevas variantes de líderes históricos.', 'Accede a versiones alternativas de Lincoln, César y Cleopatra.', '2022-11-21', 1.00, 'E', 0.00, 'DLC', 85), -- Gratuito 9
 (244, 'Borderlands 2: Tiny Tina Dragon Keep', 'Aventura de rol de mesa en fantasía épica.', 'Tiny Tina actúa como Dungeon Master en una partida llena de magia y esqueletos.', '2013-06-25', 5.00, 'M', 9.99, 'DLC', 89),
 (245, 'Borderlands 2: Mechromancer Pack', 'Nueva clase jugable: Gaige la Nigromante.', 'Invoca a tu robot trampa mortal para masacrar enemigos en Pandora.', '2012-10-09', 1.00, 'M', 9.99, 'DLC', 83),
 (246, 'Borderlands 3: Moxxis Heist of Handsome Jackpot', 'Asalto al casino espacial abandonado.', 'Únete a Moxxi para arrebatarle el control del casino al difunto Handsome Jack.', '2019-12-19', 8.00, 'M', 14.99, 'DLC', 78),
 (247, 'XCOM 2: War of the Chosen', 'Resistencia expandida y la amenaza de los Elegidos.', 'Enfréntate a tres cazadores alienígenas únicos que evolucionan durante la campaña.', '2017-08-29', 30.00, 'T', 39.99, 'DLC', 88),
 (248, 'XCOM 2: Resistance Warrior Pack', 'Opciones de personalización de uniformes y cascos.', 'Equipa a tus soldados con atuendos tácticos y pintura facial de guerra.', '2016-02-05', 0.20, 'T', 0.00, 'DLC', 70), -- Gratuito 10
 (249, 'Euro Truck Simulator 2: Iberia', 'Explora la península Ibérica al completo.', 'Transporta carga por autopistas españolas y portuguesas en escenarios detallados.', '2021-04-08', 3.00, 'E', 17.99, 'DLC', 84),
 (250, 'Euro Truck Simulator 2: Paint Jobs Pack', 'Pinturas temáticas para la cabina de tu camión.', 'Personaliza tu vehículo con banderas y diseños regionales.', '2019-05-10', 0.10, 'E', 0.00, 'DLC', 75), -- Gratuito 11
 (251, 'American Truck Simulator: Texas', 'El estado de la estrella solitaria en escala masiva.', 'Conduce por las grandes ciudades y campos petroleros del estado de Texas.', '2022-11-15', 4.00, 'E', 17.99, 'DLC', 83),
 (252, 'Cities: Skylines - Mass Transit', 'Nuevos sistemas de transporte público urbano.', 'Añade monorrieles, teleféricos, ferrys y autobuses de alta capacidad a tu ciudad.', '2017-05-18', 1.00, 'E', 12.99, 'DLC', 81),
 (253, 'Cities: Skylines - Green Cities', 'Edificios ecológicos y vehículos eléctricos.', 'Construye una urbe sostenible con reciclaje y zonas de bajas emisiones.', '2017-10-19', 1.00, 'E', 12.99, 'DLC', 78),
 (254, 'Cities: Skylines - Carols, Candles and Candy', 'Pack de canciones navideñas para la emisora.', 'Disfruta de música festiva mientras planificas el tráfico de tu ciudad.', '2017-12-05', 0.10, 'E', 0.00, 'DLC', 80), -- Gratuito 12
 (255, 'Frostpunk: The Last Autumn', 'Prequela de la construcción del gran generador.', 'Administra el sitio de construcción antes de que la helada mortal consuma la Tierra.', '2020-01-21', 3.00, 'M', 16.99, 'DLC', 83), 
 (256, 'Frostpunk: On the Edge', 'Escenario posterior a la gran tormenta helada.', 'Lidera un puesto de avanzada cerca de un depósito militar tratando de independizarte.', '2020-08-20', 2.00, 'M', 12.99, 'DLC', 75),
 (257, 'Payday 2: The Point Break Heists', 'Dos robos de alto riesgo inspirados en la película.', 'Salto en paracaídas y asaltos a alta velocidad en escenarios extremos.', '2015-12-03', 3.00, 'M', 6.99, 'DLC', 80),
 (258, 'Payday 2: Hotline Miami Pack', 'Colaboración sangrienta con Hotline Miami.', 'Nuevas máscaras, armas de cuerpo a cuerpo y un asalto en un motel lleno de mafiosos.', '2014-09-30', 2.00, 'M', 6.99, 'DLC', 82),
 (259, 'Payday 2: Community Character Pack', 'Personaje jugable y armas comunitarias.', 'Accede a Aldstone y a nuevas armas secundarias de forma gratuita.', '2016-11-03', 0.50, 'M', 0.00, 'DLC', 85), -- Gratuito 13
 (260, 'Destiny 2: The Final Shape', 'La conclusión de la saga de la Luz y la Oscuridad.', 'Adéntrate en el Corazón Pálido del Viajero para derrotar al Testigo.', '2024-06-04', 35.00, 'T', 49.99, 'DLC', 89),
 (261, 'Destiny 2: Lightfall', 'Aventura en la metrópolis neón de Neomuna en Neptuno.', 'Domina la nueva subclase de Atadura y combate a la Legión de las Sombras.', '2023-02-28', 30.00, 'T', 39.99, 'DLC', 68),
 (262, 'Destiny 2: Witch Queen', 'Descubre la verdad en el Mundo Trronal de Savathûn.', 'Crea armas personalizadas y lucha contra la Camada Luciente impregnada de Luz.', '2022-02-22', 25.00, 'T', 29.99, 'DLC', 88),
 (263, 'Destiny 2: 30th Anniversary Pack', 'Mazmorra inspirada en las garras de la codicia.', 'Consigue el icónico lanzacohetes Gjallarhorn y conjuntos de armadura clásicos.', '2021-12-07', 10.00, 'T', 24.99, 'DLC', 80),
 (264, 'Warframe: Heart of Deimos', 'Mundo abierto infestados en la luna de Marte.', 'Explora el paisaje biológico cambiante de Cambion Drift con mecas Necramech.', '2020-08-25', 5.00, 'M', 0.00, 'DLC', 85), -- Gratuito 14
 (265, 'Warframe: The Duviri Paradox', 'Un paisaje mental surrealista dominado por emociones.', 'Toma el control del Nómada en una aventura roguelike dentro del Vacío.', '2023-04-26', 8.00, 'M', 0.00, 'DLC', 87), -- Gratuito 15
 (266, 'Path of Exile: Settlers of Kalguur', 'Liga de desafío con construcción de poblados.', 'Ayuda a los colonos a fundar la ciudad de Kingsmarch y establece rutas de comercio.', '2024-07-26', 4.00, 'M', 0.00, 'DLC', 88), -- Gratuito 16
 (267, 'Path of Exile: Necropolis', 'Liga con manipulación de almas y tumbas.', 'Entierra los restos de monstruos antiguos para forjar equipo con propiedades raras.', '2024-03-29', 3.00, 'M', 0.00, 'DLC', 80), -- Gratuito 17
 (268, 'Apex Legends: Champion Edition', 'Desbloquea múltiples leyendas y objetos cosméticos.', 'Incluye leyendas de temporadas pasadas y aspectos legendarios exóticos.', '2020-10-06', 0.10, 'T', 39.99, 'DLC', 82),
 (269, 'Apex Legends: Founders Pack', 'Monedas Apex y aspectos de armas exclusivos.', 'Distintivo de fundador para el banner del jugador.', '2019-02-05', 0.10, 'T', 29.99, 'DLC', 78),
 (270, 'The Elder Scrolls Online: Necrom', 'Explora la Península Telvanni y el plano de Apocrypha.', 'Domina la nueva clase Arcanista y protege los secretos prohibidos del conocimiento.', '2023-06-05', 15.00, 'M', 39.99, 'DLC', 80),
 (271, 'The Elder Scrolls Online: High Isle', 'Aventura en el archipiélago de las Islas Sistemáticas.', 'Descubre una conspiración caballeresca en una sociedad noble no tocada por la guerra.', '2022-06-06', 12.00, 'M', 29.99, 'DLC', 77),
 (272, 'Final Fantasy XIV: Dawntrail', 'Nueva travesía marina hacia el continente de Tural.', 'Participa en el rito de sucesión en un paraíso tropical con dos nuevas clases.', '2024-07-02', 25.00, 'T', 39.99, 'DLC', 82),
 (273, 'Final Fantasy XIV: Endwalker', 'Clímax de la historia del sol y la luna.', 'Viaja hasta los confines del espacio para detener el Apocalipsis anunciado.', '2021-12-07', 20.00, 'T', 39.99, 'DLC', 92),
 (274, 'Final Fantasy XIV: Shadowbringers', 'Conviértete en el Guerrero de la Oscuridad en Norvrandt.', 'Restaura la noche en un mundo consumido por la luz deslumbrante.', '2019-07-02', 18.00, 'T', 39.99, 'DLC', 91),
 (275, 'Dragon Ball FighterZ: FighterZ Pass 1', 'Añade 8 personajes icónicos a la plantilla.', 'Incluye a Broly, Bardock, Vegetto Blue, Zamasu y Goku Base.', '2018-01-26', 1.00, 'T', 34.99, 'DLC', 86),
 (276, 'Dragon Ball FighterZ: FighterZ Pass 2', 'Añade 6 luchadores adicionales.', 'Incluye a Jiren, Videl, Goku GT, Janemba, Gogeta SSGSS y Broly DBS.', '2019-01-31', 1.00, 'T', 24.99, 'DLC', 85),
 (277, 'Dragon Ball Xenoverse 2: Extra Pass', '4 paquetes de contenido con personajes de Dragon Ball Super.', 'Juega como Jiren, Fu, Android 17 y Gogeta SSGSS con nuevas misiones secundarias.', '2018-02-28', 2.00, 'T', 29.99, 'DLC', 80),
 (278, 'Dragon Ball Xenoverse 2: Legend Patrol Pack', 'Experimenta la historia del primer Xenoverse.', 'Juega las misiones principales de patrulla del tiempo del juego original.', '2022-07-07', 4.00, 'T', 9.99, 'DLC', 82),
 (279, 'Tekken 8: Year 1 Pass', 'Cuatro personajes adicionales para la plantilla.', 'Incluye a Eddy Gordo, Lidia Sobieska, Heihachi Mishima y un luchador secreto.', '2024-01-26', 1.00, 'T', 29.99, 'DLC', 84),
 (280, 'Street Fighter 6: Year 1 Character Pass', '4 personajes adicionales: Rashid, A.K.I., Ed y Akuma.', 'Añade atuendos alternativos y colores para cada personaje.', '2023-06-02', 1.00, 'T', 29.99, 'DLC', 88),
 (281, 'Mortal Kombat 1: Kombat Pack', '6 personajes jugables y 5 personajes Kameo.', 'Incluye a Omni-Man, Peacemaker, Homelander, Quan Chi, Ermac y Takeda.', '2023-09-19', 12.00, 'M', 39.99, 'DLC', 83),
 (282, 'Mortal Kombat 11: Aftermath', 'Expansión de la historia cinematográfica y nuevos luchadores.', 'Controla a Shang Tsung y Fujin para salvar las líneas temporales.', '2020-05-26', 15.00, 'M', 39.99, 'DLC', 79),
 (283, 'Persona 5 Royal: Challenge Pack', 'Combates de desafío en la Habitación Terciopelo.', 'Enfréntate a los protagonistas de Persona 3 y Persona 4.', '2022-10-21', 0.50, 'M', 0.00, 'DLC', 85), -- Gratuito 18
 (284, 'Persona 3 Reload: Expansion Pass', 'Epílogo Episode Aigis: The Answer.', 'Descubre la verdad detrás del bucle temporal del 31 de marzo con Aigis.', '2024-03-12', 8.00, 'M', 34.99, 'DLC', 81),
 (285, 'Yakuza 0: Director’s Cut Extra Outfits', 'Trajes temáticos de época para Kiryu y Majima.', 'Añade atuendos clásicos de las entregas originales.', '2017-08-01', 0.20, 'M', 0.00, 'DLC', 78), -- Gratuito 19
 (286, 'Like a Dragon Infinite Wealth: Master Vacation Bundle', 'Mazmorra final de New Game+ y vestidos de playa.', 'Accede a la mazmorra Big Swell y a trajes festivos.', '2024-01-26', 2.00, 'M', 14.99, 'DLC', 70),
 (287, 'NieR Automata: 3C3C1D119440927', 'Tres coliseos de combate con recompensas y atuendos.', 'Obtén los trajes de NieR Replicant para 2B, 9S y A2.', '2017-05-02', 2.00, 'M', 13.99, 'DLC', 84),
 (288, 'Final Fantasy VII Remake: EPISODE INTERmission', 'Campaña independiente con la ninja Yuffie Kisaragi.', 'Infíltrate en Midgar junto a Sonon para robar la materia suprema de Shinra.', '2021-06-10', 10.00, 'T', 19.99, 'DLC', 86),
 (289, 'Blasphemous: Stir of Dawn', 'Modo New Game+ con las Penitencias y nuevos jefes.', 'Enfréntate a las Amanecidas invocadas por la figura de Jibrael.', '2020-08-04', 1.00, 'M', 0.00, 'DLC', 90), -- Gratuito 20
 (290, 'Blasphemous: Wounds of Eventide', 'Capítulo final gratuito que revela el verdadero final.', 'Descubre los secretos de las Tres Angustias y el destino del Penitente.', '2021-12-09', 1.00, 'M', 0.00, 'DLC', 92), -- Gratuito 21
 (291, 'Ender Lilies: Official Artbook & OST', 'Libro de arte digital y banda sonora completa.', 'Ilustraciones de concepto de los jefes y piezas musicales de Mili.', '2021-06-21', 1.00, 'T', 9.99, 'DLC', 88),
 (292, 'Outer Wilds: Echoes of the Eye', 'Expansión de misterio y terror dentro del sistema solar.', 'Descubre una estación espacial oculta en el eclipse de la estrella.', '2021-09-28', 3.00, 'E', 14.99, 'DLC', 90),
 (293, 'Alan Wake 2: Night Springs', 'Tres episodios narrativos surrealistas e independientes.', 'Juega como la fan número uno, el actor y el ejecutor en programas de televisión.', '2024-06-08', 5.00, 'M', 19.99, 'DLC', 85),
 (294, 'Control: The Foundation', 'Explora las profundidades de la Casa Incalculable.', 'Investiga la desaparición de Helen Marshall y la amenaza al Monolito.', '2020-03-26', 4.00, 'M', 14.99, 'DLC', 80),
 (295, 'Control: AWE', 'Crossover oficial con el universo de Alan Wake.', 'Jesse investiga el Sector de Investigaciones sobre los eventos de Bright Falls.', '2020-08-27', 5.00, 'M', 14.99, 'DLC', 78),
 (296, 'Dishonored: The Knife of Dunwall', 'Toma el rol del asesino Daud.', 'Busca la redención tras asesinar a la emperatriz usando nuevas armas y habilidades.', '2013-04-16', 3.00, 'M', 9.99, 'DLC', 82),
 (297, 'Dishonored: The Brigmore Witches', 'El desenlace de la historia de Daud.', 'Enfréntate al aquelarre de brujas liderado por Delilah para evitar un golpe de estado.', '2013-08-13', 3.00, 'M', 9.99, 'DLC', 85),
 (298, 'Sniper Elite 5: Landing Force Mission', 'Misión en una isla de la costa sur de Francia.', 'Infíltrate en una base de cañones costeros nazis para asegurar el desembarco.', '2022-07-05', 4.00, 'M', 14.99, 'DLC', 76),
 (299, 'Hitman: Seven Deadly Sins Act 1 Greed', 'Desafío temático basado en el pecado de la avaricia.', 'Supera los contratos de escalada en Dubái para desbloquear el traje codicioso.', '2021-03-30', 2.00, 'M', 4.99, 'DLC', 72),
 (300, 'Hunt Showdown: Legends of the Bayou', 'Cuatro cazadores legendarios y armas exclusivas.', 'Suma a las filas de cazadores a la Médica de la Plaga y al Errante del pantano.', '2019-08-27', 1.00, 'M', 9.99, 'DLC', 80),
 (301, 'Los Sims 4', 'Crea y controla a tus propios Sims.', 'El popular simulador de vida donde puedes construir casas, crear personajes y controlar sus vidas diarias, sus relaciones y sus carreras.', '2014-09-02', 25.50, 'T', 0.00, 'Juego_Base', 70),
 (302, 'Los Sims 4: Vida en el Pueblo', 'Disfruta de la tranquilidad rural.', 'Añade un nuevo mundo rural con granjas, animales, cultivos y una comunidad muy unida.', '2025-03-15', 5.20, 'T', 19.99, 'DLC', 75),
 (303, 'Los Sims 4: Aventura Espacial', 'Explora el espacio exterior.', 'Tus Sims podrán viajar a diferentes planetas, construir bases espaciales e interactuar con aliens.', '2025-08-20', 6.80, 'T', 19.99, 'DLC', 68),
 (304, 'Los Sims 4: Moda de Alta Costura', 'Conviértete en un icono de la moda.', 'Incluye una nueva carrera como diseñador, pasarelas, ropa exclusiva y peinados nuevos.', '2025-11-10', 3.10, 'T', 9.99, 'DLC', 60),
 (305, 'Los Sims 4: Vida Submarina', 'Explora las profundidades del océano.', 'Añade la posibilidad de convertirse en sirenas, construir casas bajo el agua y nadar con delfines.', '2026-02-14', 7.50, 'T', 19.99, 'DLC', 80),
 (306, 'Los Sims 4: Fiesta en la Playa', 'Organiza las mejores fiestas.', 'Incluye nuevos objetos para exteriores, ropa de baño, música tropical y la habilidad de surfear.', '2026-05-01', 2.50, 'T', 4.99, 'DLC', 55),
 (307, 'Los Sims 4: Escuela de Magia', 'Aprende hechizos y pociones.', 'Tus Sims podrán asistir a una escuela de magia, aprender hechicería y crear pociones.', '2026-09-30', 8.00, 'T', 19.99, 'DLC', 72),
 (308, 'Los Sims 4: Vida de Lujo', 'Vive como un millonario.', 'Añade yates, autos deportivos, joyas costosas y un nuevo mundo exclusivo.', '2026-10-15', 4.00, 'T', 9.99, 'DLC', 62),
 (309, 'Overcooked', 'Cocina cooperativa caótica.', 'Un juego de cocina donde debes preparar platos con amigos en cocinas muy peligrosas.', '2016-08-03', 2.50, 'E', 14.99, 'Juego_Base', 80),
 (310, 'Cyber Rogue 2077', 'Acción y hackeo en el futuro.', 'Un juego de acción cyberpunk con toques de rogue-lite y mucho parkour.', '2026-02-15', 45.00, 'T', 39.99, 'Juego_Base', 85),
 (311, 'Mystic Farming', 'Granja y magia.', 'Simulador de granja donde cultivas plantas mágicas y haces amigos en un pueblo.', '2026-04-10', 12.50, 'E', 19.99, 'Juego_Base', 78),
 (312, 'Galactic Strategy', 'Conquista la galaxia.', 'Juego de estrategia en tiempo real por turnos con naves espaciales.', '2026-06-20', 60.00, 'T', 49.99, 'Juego_Base', 82),
 (313, 'Shadow Ninja 2D', 'Plataformas y sigilo.', 'Un juego indie de plataformas 2D pixel art con mecánicas de sigilo y combate rápido.', '2026-08-05', 3.20, 'T', 14.99, 'Juego_Base', 88),
 (314, 'Zombie Survival Coop', 'Sobrevive con amigos.', 'Juego de terror y supervivencia cooperativa en un mundo post-apocalíptico.', '2026-09-12', 30.00, 'M', 29.99, 'Juego_Base', 75),
 (315, 'Minecraft Dungeons', 'Spin-off de acción y mazmorras.', 'Explora mazmorras, lucha contra mobs y encuentra tesoros en este juego de rol de acción.', '2026-02-01', 5.00, 'E', 15.00, 'Juego_Base', 80),
 (316, 'Starfield', 'RPG de exploración espacial.', 'Explora la galaxia, construye naves y descubre planetas en este RPG de ciencia ficción.', '2026-03-01', 50.00, 'T', 40.00, 'Juego_Base', 85),
 (317, 'Uncharted 5', 'Aventura de acción.', 'Explora ruinas y busca tesoros.', '2026-04-01', 100.00, 'T', 60.00, 'Juego_Base', 92);
 SET IDENTITY_INSERT Producto_Digital OFF;


/* ------------------------------- 2. Juego_Base ------------------------------- */
-- Apunta a ID_Producto_FK de la tabla Producto_Digital
INSERT INTO Juego_Base (Motor_Grafico, Tiene_Compras_InGame, Soporta_Cloud_Saves, ID_Producto_FK, ID_Estudio_Dev_FK, ID_Publisher_FK) VALUES
 ('REDengine 4', 0, 1, 1, 1, 1),
  ('REDengine 4', 0, 1, 2, 1, 1),
 ('FromSoftware Engine', 0, 1, 3, 2, 2),
  ('REDengine 4', 0, 1, 4, 1, 1),
 ('REDengine 3', 0, 1, 5, 1, 1),
 ('Source 2', 0, 1, 6, 3, 3),
 ('RAGE', 1, 1, 7, 4, 4),
 ('Custom Engine', 0, 1, 8, 5, 5),

 ('Unreal Engine', 1, 1, 315, 16, 4),
 ('Bedrock Engine', 1, 1, 9, 16, 4),
 ('Creation Engine 2', 0, 1, 316, 31, 4),

 ('Divinity Engine 4', 0, 1, 10, 7, 7),
 ('Custom Engine', 0, 1, 11, 8, 8),
 ('RAGE', 0, 1, 12, 4, 4),
 ('RE Engine', 0, 1, 13, 9, 9),
 ('MT Framework', 0, 1, 14, 9, 9),
 ('Unity', 0, 1, 15, 10, 10),
 ('XNA Framework', 0, 1, 16, 11, 11),
 ('Custom Engine', 0, 1, 17, 12, 12),
 ('RE Engine', 0, 1, 18, 9, 9),
 ('FromSoftware Engine', 0, 1, 19, 2, 2),
 ('FromSoftware Engine', 0, 1, 20, 2, 8),
 ('RAGE', 0, 1, 21, 4, 4),
 ('RAGE', 0, 1, 22, 4, 4),
 ('Custom Engine', 0, 1, 23, 4, 4),
 ('Unreal Engine 3', 0, 1, 24, 13, 14),
 ('id Tech 7', 0, 1, 25, 15, 16),
 ('Gamebryo', 0, 1, 26, 17, 16),
 ('Creation Engine', 0, 1, 27, 18, 16),
 ('Unreal Engine 3', 0, 1, 28, 19, 20),
 ('Unreal Engine 5', 0, 1, 29, 21, 20),
 ('RE Engine', 0, 1, 30, 9, 9),
 ('RE Engine', 0, 1, 31, 9, 9),
 ('RE Engine', 0, 1, 32, 9, 9),
 ('RE Engine', 0, 1, 33, 9, 9),
 ('RE Engine', 0, 1, 34, 9, 9),
 ('RE Engine', 1, 1, 35, 9, 9),
 ('RE Engine', 0, 1, 36, 9, 9),
 ('MT Framework', 0, 1, 37, 9, 9),
 ('MT Framework', 0, 1, 38, 9, 9),
 ('MT Framework', 0, 1, 39, 9, 9),
 ('RenderWare', 0, 1, 40, 9, 9),
 ('Source', 0, 1, 41, 3, 3),
 ('Source', 0, 1, 42, 3, 3),
 ('Source', 1, 1, 43, 3, 3),
 ('Source 2', 1, 1, 44, 3, 3),
 ('Source 2', 1, 1, 45, 3, 3),
 ('Unreal Engine 3', 0, 1, 46, 22, 14),
 ('Unreal Engine 3', 0, 1, 47, 23, 14),
 ('Unreal Engine 3', 0, 1, 48, 24, 14),
 ('Unreal Engine 4', 1, 1, 49, 24, 14),
 ('Unreal Engine 4', 0, 1, 50, 25, 14),
 ('Unreal Engine 4', 0, 1, 51, 25, 14),
 ('Anvil Next', 0, 1, 52, 26, 14),
 ('Illusion Engine', 0, 1, 53, 26, 14),
 ('Unreal Engine 4', 0, 1, 54, 17, 14),
 ('Unity', 0, 1, 55, 17, 27),
 ('Tyranny Engine', 0, 1, 56, 17, 27),
 ('Source 2', 0, 1, 57, 28, 28),
 ('Unity', 0, 1, 58, 29, 29),
 ('Unity', 0, 1, 59, 29, 29),
 ('Prism3D', 0, 1, 60, 30, 27),
 ('Unity', 0, 1, 61, 30, 27),
 ('Prism3D', 0, 1, 62, 31, 31),
 ('Prism3D', 0, 1, 63, 31, 31),
 ('Unity', 0, 1, 64, 32, 32),
 ('Custom Engine', 0, 1, 65, 33, 33),
 ('Source', 0, 1, 66, 34, 34),
 ('Source', 0, 1, 67, 3, 3),
 ('Unity', 0, 1, 68, 35, 35),
 ('Unity', 0, 1, 69, 36, 36),
 ('Unity', 0, 1, 70, 37, 24),
 ('Custom Engine', 0, 1, 71, 38, 38),
 ('Unity', 0, 1, 72, 39, 39),
 ('Unreal Engine 5', 0, 1, 73, 40, 40),
 ('Unity', 0, 1, 74, 40, 40),
 ('Unreal Engine 5', 1, 1, 75, 40, 40),
 ('Unity', 0, 1, 76, 40, 40),
 ('Unity', 1, 1, 77, 40, 20),
 ('Unity', 1, 1, 78, 40, 20),
 ('Unreal Engine 4', 1, 1, 79, 40, 20),
 ('Source Engine', 1, 1, 80, 40, 20),
 ('Tiger Engine', 1, 1, 81, 40, 16),
 ('Evolution Engine', 1, 1, 82, 40, 40),
 ('Custom Engine', 1, 1, 83, 40, 40),
 ('Unreal Engine 4', 1, 1, 84, 40, 40),
 ('Guild Wars Engine', 1, 1, 85, 40, 40),
 ('HeroEngine', 1, 1, 86, 40, 16),
 ('Crystal Tools', 1, 1, 87, 40, 40),
 ('RE Engine', 0, 1, 88, 9, 9),
 ('Unreal Engine 4', 0, 1, 89, 40, 40),
 ('Unreal Engine 3', 1, 1, 90, 40, 40),
 ('Unreal Engine 5', 1, 1, 91, 40, 40),
 ('Unreal Engine 4', 0, 1, 92, 9, 9),
 ('Unreal Engine 4', 1, 1, 93, 40, 40),
 ('Unreal Engine 5', 1, 1, 94, 40, 40),
 ('Unreal Engine 4', 0, 1, 95, 40, 40),
 ('Custom Engine', 0, 1, 96, 40, 40),
 ('Proprietary Engine', 0, 1, 97, 40, 40),
 ('Proprietary Engine', 0, 1, 98, 40, 40),
 ('Unreal Engine 4', 0, 1, 99, 40, 40),
 ('Unreal Engine 5', 0, 1, 100, 40, 40),
 ('Dragon Engine', 0, 1, 101, 40, 40),
 ('Dragon Engine', 0, 1, 102, 40, 40),
 ('Dragon Engine', 0, 1, 103, 40, 40),
 ('Dragon Engine', 0, 1, 104, 40, 40),
 ('Dragon Engine', 0, 1, 105, 40, 40),
 ('Dragon Engine', 0, 1, 106, 40, 40),
 ('PlatinumEngine', 0, 1, 107, 40, 40),
 ('Unreal Engine 4', 0, 1, 108, 40, 40),
 ('Unreal Engine 4', 0, 1, 109, 40, 40),
 ('Luminous Engine', 0, 1, 110, 40, 40),
 ('Unreal Engine 4', 0, 1, 111, 40, 40),
 ('Unreal Engine 4', 0, 1, 112, 40, 40),
 ('Unreal Engine 4', 0, 1, 113, 40, 40),
 ('Unreal Engine 4', 0, 1, 114, 40, 40),
 ('Unreal Engine 4', 0, 1, 115, 40, 40),
 ('Unity', 0, 1, 116, 40, 40),
 ('Custom Engine', 0, 1, 117, 40, 40),
 ('HTML5 / Custom', 0, 1, 118, 40, 40),
 ('Z-Engine', 0, 1, 119, 40, 40),
 ('Custom Engine', 0, 1, 120, 40, 40),
 ('KAGE Engine', 0, 1, 121, 40, 40),
 ('Custom Engine', 0, 1, 122, 40, 40),
 ('Custom Engine', 0, 1, 123, 40, 40),
 ('Custom Engine', 0, 1, 124, 40, 40),
 ('Custom Engine', 0, 1, 125, 40, 40),
 ('Unity', 0, 1, 126, 40, 40),
 ('Custom Engine', 0, 1, 127, 40, 40),
 ('Unity', 0, 1, 128, 40, 40),
 ('Unity', 0, 1, 129, 40, 40),
 ('Unity', 0, 1, 130, 40, 40),
 ('Custom Engine', 0, 1, 131, 40, 40),
 ('Custom Engine', 0, 1, 132, 40, 40),
 ('Katana Engine', 0, 1, 133, 40, 40),
 ('GameMaker Studio', 0, 1, 134, 40, 40),
 ('GameMaker Studio', 0, 1, 135, 40, 40),
 ('Unity', 0, 1, 136, 40, 40),
 ('Unity', 0, 1, 137, 40, 40),
 ('Unity', 0, 1, 138, 40, 40),
 ('GameMaker Studio', 0, 1, 139, 40, 40),
 ('Custom Engine', 0, 1, 140, 40, 40),
 ('Custom Engine', 0, 1, 141, 40, 40),
 ('Custom Engine', 0, 1, 142, 40, 40),
 ('Unity', 0, 1, 143, 40, 40),
 ('Unity', 0, 1, 144, 40, 40),
 ('Unity', 1, 1, 145, 40, 40),
 ('Godot Engine', 0, 1, 146, 40, 40),
 ('Unreal Engine 4', 1, 1, 147, 40, 40),
 ('Unreal Engine 4', 0, 1, 148, 40, 40),
 ('Unreal Engine 5', 1, 1, 149, 40, 40),
 ('Unreal Engine 4', 1, 1, 150, 40, 40),
 ('Unity', 0, 1, 151, 40, 40),
 ('Unreal Engine 4', 0, 1, 152, 40, 40),
 ('Unreal Engine 4', 0, 1, 153, 40, 40),
 ('Unity', 0, 1, 154, 40, 40),
 ('Unreal Engine 5', 0, 1, 155, 40, 40),
 ('Unity', 1, 1, 156, 40, 40),
 ('Unreal Engine 4', 1, 1, 157, 40, 40),
 ('Unreal Engine 5', 1, 1, 158, 40, 40),
 ('Unreal Engine 4', 1, 1, 159, 40, 40),
 ('Enfusion Engine', 0, 1, 160, 40, 40),
 ('Custom Engine', 0, 1, 161, 40, 40),
 ('Custom Engine', 0, 1, 162, 40, 40),
 ('Custom Engine', 0, 1, 163, 40, 40),
 ('Custom Engine', 0, 1, 164, 40, 40),
 ('Unity', 0, 1, 165, 40, 40),
 ('Unity', 0, 1, 166, 40, 40),
 ('Custom Engine', 1, 1, 167, 40, 40),
 ('COBRA Engine', 1, 1, 168, 40, 40),
 ('Unity', 0, 1, 169, 40, 40),
 ('VRAGE Engine', 1, 1, 170, 40, 40),
 ('Unity', 0, 1, 171, 40, 40),
 ('Decima Engine', 0, 1, 172, 40, 40),
 ('Northlight Engine', 0, 1, 173, 40, 40),
 ('Northlight Engine', 0, 1, 174, 40, 40),
 ('Northlight Engine', 0, 1, 175, 40, 40),
 ('CryEngine 3', 0, 1, 176, 40, 40),
 ('Void Engine', 0, 1, 177, 40, 40),
 ('Void Engine', 0, 1, 178, 40, 40),
 ('Unreal Engine 4', 0, 1, 179, 40, 40),
 ('Unreal Engine 4', 0, 1, 180, 40, 40),
 ('Unreal Engine 4', 0, 1, 181, 40, 40),
 ('id Tech 5', 0, 1, 182, 40, 40),
 ('id Tech 6', 0, 1, 183, 40, 40),
 ('id Tech 6', 0, 1, 184, 40, 40),
 ('Apex Engine', 0, 1, 185, 40, 40),
 ('4A Engine', 0, 1, 186, 40, 40),
 ('4A Engine', 0, 1, 187, 40, 40),
 ('4A Engine', 0, 1, 188, 40, 40),
 ('X-Ray Engine', 0, 1, 189, 40, 40),
 ('Unreal Engine 5', 0, 1, 190, 40, 40),
 ('Unreal Engine 4', 0, 1, 191, 40, 40),
 ('KEX Engine', 0, 1, 192, 40, 40),
 ('DAWN Engine', 0, 1, 193, 40, 40),
 ('DAWN Engine', 0, 1, 194, 40, 40),
 ('Unreal Engine 4', 0, 1, 195, 40, 40),
 ('GLacier 2 Engine', 1, 1, 196, 40, 40),
 ('DIESEL Engine', 1, 1, 197, 40, 40),
 ('Unreal Engine 5', 1, 1, 198, 40, 40),
 ('Real Virtuality 4', 1, 1, 199, 40, 40),
 ('Unreal Engine 4', 0, 1, 200, 40, 40),
 ('Unreal Engine 4', 0, 1, 201, 40, 40),
 ('Unreal Engine 4', 0, 1, 202, 40, 40),
 ('CRYENGINE', 1, 1, 203, 40, 40),
 ('Custom Engine', 1, 1, 204, 40, 40),
 ('Unreal Engine 4', 0, 1, 205, 40, 40),
 ('Unreal Engine 4', 0, 1, 206, 40, 40),
 ('Dagor Engine', 1, 1, 207, 40, 40),
 ('Dagor Engine', 1, 1, 208, 40, 40),
 ('Custom Engine', 1, 1, 209, 40, 40),
 ('Custom Engine', 1, 1, 210, 40, 40),
 ('Custom Engine', 1, 1, 301, 41, 41),
 ('Unity', 0, 0, 309, 15, 15),
 ('Naughty Engine', 1, 1, 317, 14, 3);;

/* ---------------------------------- 3. DLC ----------------------------------- */
INSERT INTO DLC (Tipo_Contenido, Subtipo_Jugable, ID_Producto_FK, ID_Juego_Base_FK) VALUES
 ('Jugable', 'Modo_Juego', 211, 1),
 ('Banda_Sonora', NULL, 212, 1),
 ('Jugable', 'Mapa', 213, 3),
 ('Jugable', 'Modo_Juego', 214, 5),
 ('Jugable', 'Mapa', 215, 5),
 ('Jugable', 'Cosmetico', 216, 5),
 ('Jugable', 'Cosmetico', 217, 7),
 ('Jugable', 'Cosmetico', 218, 10),
 ('Jugable', 'Modo_Juego', 219, 11),
 ('Jugable', 'Cosmetico', 220, 12),
 ('Jugable', 'Personaje', 221, 13),
 ('Jugable', 'Modo_Juego', 222, 13),
 ('Jugable', 'Mapa', 223, 14),
 ('Jugable', 'Cosmetico', 224, 14),
 ('Jugable', 'Modo_Juego', 225, 15),
 ('Jugable', 'Modo_Juego', 226, 15),
 ('Banda_Sonora', NULL, 227, 17),
 ('Jugable', 'Personaje', 228, 18),
 ('Jugable', 'Mapa', 229, 19),
 ('Jugable', 'Mapa', 230, 19),
 ('Jugable', 'Mapa', 231, 131),
 ('Jugable', 'Mapa', 232, 130),
 ('Jugable', 'Mapa', 233, 69),
 ('Jugable', 'Mapa', 234, 69),
 ('Jugable', 'Mapa', 235, 69),
 ('Jugable', 'Personaje', 236, 70),
 ('Jugable', 'Modo_Juego', 237, 71),
 ('Jugable', 'Modo_Juego', 238, 72),
 ('Jugable', 'Modo_Juego', 239, 72),
 ('Jugable', 'Modo_Juego', 240, 72),
 ('Jugable', 'Mapa', 241, 50),
 ('Jugable', 'Modo_Juego', 242, 50),
 ('Jugable', 'Personaje', 243, 50),
 ('Jugable', 'Mapa', 244, 48),
 ('Jugable', 'Personaje', 245, 48),
 ('Jugable', 'Mapa', 246, 49),
 ('Jugable', 'Modo_Juego', 247, 51),
 ('Jugable', 'Cosmetico', 248, 51),
 ('Jugable', 'Mapa', 249, 62),
 ('Jugable', 'Cosmetico', 250, 62),
 ('Jugable', 'Mapa', 251, 63),
 ('Jugable', 'Modo_Juego', 252, 60),
 ('Jugable', 'Modo_Juego', 253, 60),
 ('Banda_Sonora', NULL, 254, 60),
 ('Jugable', 'Mapa', 255, 65),
 ('Jugable', 'Mapa', 256, 65),
 ('Jugable', 'Mapa', 257, 197),
 ('Jugable', 'Mapa', 258, 197),
 ('Jugable', 'Personaje', 259, 197),
 ('Jugable', 'Mapa', 260, 81),
 ('Jugable', 'Mapa', 261, 81),
 ('Jugable', 'Mapa', 262, 81),
 ('Jugable', 'Modo_Juego', 263, 81),
 ('Jugable', 'Mapa', 264, 82),
 ('Jugable', 'Modo_Juego', 265, 82),
 ('Jugable', 'Modo_Juego', 266, 83),
 ('Jugable', 'Modo_Juego', 267, 83),
 ('Jugable', 'Cosmetico', 268, 80),
 ('Jugable', 'Cosmetico', 269, 80),
 ('Jugable', 'Mapa', 270, 86),
 ('Jugable', 'Mapa', 271, 86),
 ('Jugable', 'Mapa', 272, 87),
 ('Jugable', 'Mapa', 273, 87),
 ('Jugable', 'Mapa', 274, 87),
 ('Jugable', 'Personaje', 275, 89),
 ('Jugable', 'Personaje', 276, 89),
 ('Jugable', 'Personaje', 277, 90),
 ('Jugable', 'Modo_Juego', 278, 90),
 ('Jugable', 'Personaje', 279, 91),
 ('Jugable', 'Personaje', 280, 35),
 ('Jugable', 'Personaje', 281, 94),
 ('Jugable', 'Mapa', 282, 93),
 ('Jugable', 'Modo_Juego', 283, 97),
 ('Jugable', 'Mapa', 284, 99),
 ('Jugable', 'Cosmetico', 285, 101),
 ('Jugable', 'Modo_Juego', 286, 104),
 ('Jugable', 'Modo_Juego', 287, 107),
 ('Jugable', 'Mapa', 288, 109),
 ('Jugable', 'Modo_Juego', 289, 124),
 ('Jugable', 'Modo_Juego', 290, 124),
 ('Banda_Sonora', NULL, 291, 126),
 ('Jugable', 'Mapa', 292, 171),
 ('Jugable', 'Mapa', 293, 174),
 ('Jugable', 'Mapa', 294, 173),
 ('Jugable', 'Mapa', 295, 173),
 ('Jugable', 'Mapa', 296, 177),
 ('Jugable', 'Mapa', 297, 177),
 ('Jugable', 'Mapa', 298, 195),
 ('Jugable', 'Mapa', 299, 196),
 ('Jugable', 'Personaje', 300, 203),
 ('Jugable', 'Mapa', 302, 301),
 ('Jugable', 'Mapa', 303, 301),
 ('Jugable', 'Cosmetico', 304, 301),
 ('Jugable', 'Modo_Juego', 305, 301),
 ('Jugable', 'Modo_Juego', 306, 301),
 ('Jugable', 'Mapa', 307, 301),
 ('Banda_Sonora', NULL, 308, 301);


/* ---------------------------- 4. Perfil_Requisito ---------------------------- */
-- Cada juego base debe tener sus perfiles 'Minimo' y 'Recomendado'


 INSERT INTO Perfil_Requisito (Tipo_Perfil, Sistema_Operativo, Procesador, Memoria_RAM, Tarjeta_Grafica, ID_Producto_FK) VALUES
('Minimo', 'Windows 10', 'Intel Core i7-6700', 12.00, 'GTX 1060 6GB', 1),
('Recomendado', 'Windows 10', 'Intel Core i7-12700', 16.00, 'RTX 2060 6GB', 1),
('Minimo', 'Windows 10', 'Intel Core i5-6600K', 8.00, 'GTX 970 4GB', 2),
('Recomendado', 'Windows 10', 'Intel Core i7-8700K', 16.00, 'RTX 2070 8GB', 2),
('Minimo', 'Windows 10', 'Intel Core i5-8400', 12.00, 'GTX 1060 3GB', 3),
('Recomendado', 'Windows 10', 'Intel Core i7-8700K', 16.00, 'GTX 1070 8GB', 3),
('Minimo', 'Windows 10', 'Intel Core i5-7500', 8.00, 'GTX 1050 Ti', 4),
('Recomendado', 'Windows 10', 'Intel Core i7-8700', 16.00, 'GTX 1060 6GB', 4),
('Minimo', 'Windows 10', 'Intel Core i5-4460', 8.00, 'GTX 960 2GB', 5),
('Recomendado', 'Windows 10', 'Intel Core i7-6700K', 16.00, 'GTX 1070 8GB', 5),
('Minimo', 'Windows 10', 'Intel Core i5-7500', 8.00, 'GTX 1060 3GB', 6),
('Recomendado', 'Windows 10', 'Intel Core i7-9700K', 16.00, 'RTX 2070 8GB', 6),
('Minimo', 'Windows 10', 'Intel Core i3-3210', 4.00, 'Intel HD 4000', 7),
('Recomendado', 'Windows 10', 'Intel Core i5-4690', 8.00, 'GeForce GTX 700', 7),
('Minimo', 'Windows 7', 'Intel Core i5-3470', 4.00, 'GeForce GTX 650', 8),
('Recomendado', 'Windows 10', 'Intel Core i5-3470', 8.00, 'GeForce GTX 660', 8),
('Minimo', 'Windows 10', 'Intel Core i5-2500K', 6.00, 'GTX 550 Ti', 9),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 8.00, 'GTX 770 2GB', 9),
('Minimo', 'Windows 7', 'Intel Core i5-2500', 4.00, 'GTX 550 Ti', 10),
('Recomendado', 'Windows 10', 'Intel Core i7', 8.00, 'GTX 770', 10),
('Minimo', 'Windows 7', '1.7 GHz Processor', 0.50, 'DirectX 8 Graphics', 11),
('Recomendado', 'Windows 10', '3.0 GHz Processor', 1.00, 'DirectX 9 Graphics', 11),
('Minimo', 'Windows 7', 'Pentium 4 3.0GHz', 2.00, 'ATI X800', 12),
('Recomendado', 'Windows 10', 'Core 2 Duo 2.4GHz', 4.00, 'NVIDIA 7600', 12),
('Minimo', 'Windows 7', 'Intel Core i5-4460', 8.00, 'GTX 760 2GB', 13),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 8.00, 'GTX 1060 6GB', 13),
('Minimo', 'Windows 10', 'Intel Core i5-4460', 8.00, 'GTX 760 2GB', 14),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 16.00, 'GTX 1060 6GB', 14),
('Minimo', 'Windows 7', 'Dual Core 2.8 GHz', 4.00, 'GeForce 8600GT', 15),
('Recomendado', 'Windows 10', 'Quad Core 3.6 GHz', 8.00, 'GTX 680 2GB', 15), ('Minimo', 'Windows 10', 'Intel Core i5-4430', 8.00, 'GTX 960 2GB', 16),
('Recomendado', 'Windows 10', 'Intel Core i7-6700', 16.00, 'GTX 1060 6GB', 16),
('Minimo', 'Windows 10', 'Intel Core i5-4430', 8.00, 'GTX 960 2GB', 17),
('Recomendado', 'Windows 10', 'Intel Core i7-6700', 16.00, 'GTX 1060 6GB', 17),
('Minimo', 'Windows 10', 'Intel Core i5-4430', 8.00, 'GTX 960 2GB', 18),
('Recomendado', 'Windows 10', 'Intel Core i7-6700', 16.00, 'GTX 1060 6GB', 18),
('Minimo', 'Windows 10', 'Intel Core i5-4430', 8.00, 'GTX 960 2GB', 19),
('Recomendado', 'Windows 10', 'Intel Core i7-6700', 16.00, 'GTX 1060 6GB', 19),
('Minimo', 'Windows 10', 'Intel Core i5-4430', 8.00, 'GTX 960 2GB', 20),
('Recomendado', 'Windows 10', 'Intel Core i7-6700', 16.00, 'GTX 1060 6GB', 20),
('Minimo', 'Windows 10', 'Intel Core i5-4430', 8.00, 'GTX 960 2GB', 21),
('Recomendado', 'Windows 10', 'Intel Core i7-6700', 16.00, 'GTX 1060 6GB', 21),
('Minimo', 'Windows 10', 'Intel Core i5-4430', 8.00, 'GTX 960 2GB', 22),
('Recomendado', 'Windows 10', 'Intel Core i7-6700', 16.00, 'GTX 1060 6GB', 22),
('Minimo', 'Windows 10', 'Intel Core i5-4430', 8.00, 'GTX 960 2GB', 23),
('Recomendado', 'Windows 10', 'Intel Core i7-6700', 16.00, 'GTX 1060 6GB', 23),
('Minimo', 'Windows 10', 'Intel Core i5-2500K', 8.00, 'GTX 670 2GB', 24),
('Recomendado', 'Windows 10', 'Intel Core i7-4770', 16.00, 'GTX 970 4GB', 24),
('Minimo', 'Windows 10', 'Intel Core i5-2400', 8.00, 'GTX 670 2GB', 25),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 8.00, 'GTX 970 4GB', 25),
('Minimo', 'Windows 10', 'Intel Core i3-2100', 4.00, 'GTX 550 Ti', 26),
('Recomendado', 'Windows 10', 'Intel Core i5-2500K', 8.00, 'GTX 680 2GB', 26),
('Minimo', 'Windows 10', 'Intel Core i5-2300', 8.00, 'GTX 550 Ti', 27),
('Recomendado', 'Windows 10', 'Intel Core i7-4790', 8.00, 'GTX 780 3GB', 27),
('Minimo', 'Windows 10', 'Intel Core i5-3570K', 8.00, 'GTX 660 2GB', 28),
('Recomendado', 'Windows 10', 'Intel Core i7-4770K', 16.00, 'GTX 980 4GB', 28),
('Minimo', 'Windows 10', 'Intel Core i5-8400', 12.00, 'GTX 1060 6GB', 29),
('Recomendado', 'Windows 10', 'Intel Core i7-10700K', 16.00, 'RTX 2070 8GB', 29),
('Minimo', 'Windows 10', 'Intel Core i5-4460', 8.00, 'GTX 760 2GB', 30),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 8.00, 'GTX 1060 6GB', 30),
('Minimo', 'Windows 10', 'Intel Core i5-4460', 8.00, 'GTX 760 2GB', 31),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 8.00, 'GTX 1060 6GB', 31),
('Minimo', 'Windows 10', 'Intel Core i5-4460', 8.00, 'GTX 760 2GB', 32),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 8.00, 'GTX 1060 6GB', 32),
('Minimo', 'Windows 10', 'Intel Core i5-4460', 8.00, 'GTX 760 2GB', 33),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 8.00, 'GTX 1060 6GB', 33),
('Minimo', 'Windows 10', 'Intel Core i5-4460', 8.00, 'GTX 760 2GB', 34),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 8.00, 'GTX 1060 6GB', 34),
('Minimo', 'Windows 10', 'Intel Core i5-4460', 8.00, 'GTX 760 2GB', 35),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 8.00, 'GTX 1060 6GB', 35),
('Minimo', 'Windows 10', 'Intel Core i5-4460', 8.00, 'GTX 760 2GB', 36),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 8.00, 'GTX 1060 6GB', 36),
('Minimo', 'Windows 10', 'Intel Core i5-4460', 8.00, 'GTX 760 2GB', 37),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 8.00, 'GTX 1060 6GB', 37),
('Minimo', 'Windows 10', 'Intel Core i5-4460', 8.00, 'GTX 760 2GB', 38),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 8.00, 'GTX 1060 6GB', 38),
('Minimo', 'Windows 10', 'Intel Core i5-4460', 8.00, 'GTX 760 2GB', 39),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 8.00, 'GTX 1060 6GB', 39),
('Minimo', 'Windows 7', 'Intel Core 2 Duo', 2.00, 'DirectX 9 Graphics', 40),
('Recomendado', 'Windows 10', 'Intel Core i3', 4.00, 'GTX 460', 40),
('Minimo', 'Windows 7', '1.7 GHz Processor', 0.50, 'DirectX 8 Graphics', 41),
('Recomendado', 'Windows 10', '3.0 GHz Processor', 1.00, 'DirectX 9 Graphics', 41),
('Minimo', 'Windows 7', '3.0 GHz Processor', 2.00, 'DirectX 9 Graphics', 42),
('Recomendado', 'Windows 10', 'Dual Core 2.0 GHz', 4.00, 'GTX 260', 42),
('Minimo', 'Windows 10', 'Intel Core i5-7500', 8.00, 'GTX 1050 Ti', 43),
('Recomendado', 'Windows 10', 'Intel Core i7-8700', 16.00, 'GTX 1060 6GB', 43),
('Minimo', 'Windows 10', 'Intel Core i5-7500', 8.00, 'GTX 1050 Ti', 44),
('Recomendado', 'Windows 10', 'Intel Core i7-8700', 16.00, 'GTX 1060 6GB', 44),
('Minimo', 'Windows 10', 'Intel Core i5-7500', 8.00, 'GTX 1050 Ti', 45),
('Recomendado', 'Windows 10', 'Intel Core i7-8700', 16.00, 'GTX 1060 6GB', 45),
('Minimo', 'Windows 10', 'Intel Core i5-2500K', 8.00, 'GTX 660 2GB', 46),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 16.00, 'GTX 970 4GB', 46),
('Minimo', 'Windows 10', 'Intel Core i5-2500K', 8.00, 'GTX 660 2GB', 47),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 16.00, 'GTX 970 4GB', 47),
('Minimo', 'Windows 10', 'Intel Core i5-2500K', 8.00, 'GTX 660 2GB', 48),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 16.00, 'GTX 970 4GB', 48),
('Minimo', 'Windows 10', 'Intel Core i5-3570', 8.00, 'GTX 760 2GB', 49),
('Recomendado', 'Windows 10', 'Intel Core i7-4770', 16.00, 'GTX 1060 6GB', 49),
('Minimo', 'Windows 10', 'Intel Core i5-2400', 8.00, 'GTX 660 2GB', 50),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 16.00, 'GTX 770 4GB', 50),
('Minimo', 'Windows 10', 'Intel Core i5-2400', 8.00, 'GTX 660 2GB', 51),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 16.00, 'GTX 770 4GB', 51),
('Minimo', 'Windows 7', 'Intel Core i5-2400', 6.00, 'GTX 660 2GB', 52),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 8.00, 'GTX 970 4GB', 52),
('Minimo', 'Windows 7', 'Intel Core i5-2500K', 6.00, 'GTX 660 2GB', 53),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 8.00, 'GTX 970 4GB', 53),
('Minimo', 'Windows 10', 'Intel Core i5-2500K', 8.00, 'GTX 760 2GB', 54),
('Recomendado', 'Windows 10', 'Intel Core i7-4770', 16.00, 'GTX 1060 6GB', 54),
('Minimo', 'Windows 7', 'Intel Core i3-2100', 4.00, 'GTS 450', 55),
('Recomendado', 'Windows 10', 'Intel Core i5-3570K', 8.00, 'GTX 570', 55),
('Minimo', 'Windows 7', 'Intel Core i3-2100', 4.00, 'GTS 450', 56),
('Recomendado', 'Windows 10', 'Intel Core i5-3570K', 8.00, 'GTX 570', 56),
('Minimo', 'Windows 10', 'Intel Core i5-7500', 8.00, 'GTX 1050 Ti', 57),
('Recomendado', 'Windows 10', 'Intel Core i7-8700', 16.00, 'GTX 1060 6GB', 57),
('Minimo', 'Windows 7', 'Dual Core 2.0 GHz', 4.00, 'DirectX 10 Graphics', 58),
('Recomendado', 'Windows 10', 'Quad Core 2.5 GHz', 8.00, 'GTX 660 2GB', 58),
('Minimo', 'Windows 7', 'Dual Core 2.0 GHz', 4.00, 'DirectX 10 Graphics', 59),
('Recomendado', 'Windows 10', 'Quad Core 2.5 GHz', 8.00, 'GTX 660 2GB', 59),
('Minimo', 'Windows 7', 'Dual Core 2.4 GHz', 4.00, 'GTS 450', 60),
('Recomendado', 'Windows 10', 'Quad Core 3.0 GHz', 6.00, 'GTX 760 2GB', 60),
('Minimo', 'Windows 7', 'Dual Core 2.4 GHz', 4.00, 'GTS 450', 61),
('Recomendado', 'Windows 10', 'Quad Core 3.0 GHz', 6.00, 'GTX 760 2GB', 61),
('Minimo', 'Windows 7', 'Dual Core 2.4 GHz', 4.00, 'GTS 450', 62),
('Recomendado', 'Windows 10', 'Quad Core 3.0 GHz', 6.00, 'GTX 760 2GB', 62),
('Minimo', 'Windows 7', 'Dual Core 2.4 GHz', 4.00, 'GTS 450', 63),
('Recomendado', 'Windows 10', 'Quad Core 3.0 GHz', 6.00, 'GTX 760 2GB', 63),
('Minimo', 'Windows 7', 'Dual Core 2.0 GHz', 2.00, 'DirectX 9 Graphics', 64),
('Recomendado', 'Windows 10', 'Dual Core 3.0 GHz', 4.00, 'GTX 550 Ti', 64),
('Minimo', 'Windows 10', 'Intel Core i5-2500K', 8.00, 'GTX 660 2GB', 65),
('Recomendado', 'Windows 10', 'Intel Core i7-4770K', 16.00, 'GTX 970 4GB', 65),
('Minimo', 'Windows 7', 'Dual Core 2.0 GHz', 2.00, 'DirectX 9 Graphics', 66),
('Recomendado', 'Windows 10', 'Dual Core 3.0 GHz', 4.00, 'GTX 460 1GB', 66),
('Minimo', 'Windows 7', '1.7 GHz Processor', 0.50, 'DirectX 8 Graphics', 67),
('Recomendado', 'Windows 10', '3.0 GHz Processor', 1.00, 'DirectX 9 Graphics', 67),
('Minimo', 'Windows 7', 'Dual Core 2.0 GHz', 4.00, 'DirectX 10 Graphics', 68),
('Recomendado', 'Windows 10', 'Quad Core 2.5 GHz', 8.00, 'GTX 660 2GB', 68),
('Minimo', 'Windows 7', 'Dual Core 2.0 GHz', 2.00, 'DirectX 9 Graphics', 69),
('Recomendado', 'Windows 10', 'Dual Core 3.0 GHz', 4.00, 'GTX 460 1GB', 69),
('Minimo', 'Windows 7', 'Dual Core 2.0 GHz', 2.00, 'DirectX 9 Graphics', 70),
('Recomendado', 'Windows 10', 'Dual Core 3.0 GHz', 4.00, 'GTX 460 1GB', 70),
('Minimo', 'Windows 10', 'Intel Core i5-3570K', 8.00, 'GTX 750 Ti 2GB', 71),
('Recomendado', 'Windows 10', 'Intel Core i7-4770K', 16.00, 'GTX 970 4GB', 71),
('Minimo', 'Windows 7', 'Intel Core i3-2100', 4.00, 'GTS 450', 72),
('Recomendado', 'Windows 10', 'Intel Core i5-3570K', 8.00, 'GTX 660 2GB', 72),
('Minimo', 'Windows 10', 'Intel Core i5-8400', 12.00, 'GTX 1060 6GB', 73),
('Recomendado', 'Windows 10', 'Intel Core i7-10700K', 16.00, 'RTX 2070 8GB', 73),
('Minimo', 'Windows 7', 'Dual Core 2.0 GHz', 4.00, 'DirectX 10 Graphics', 74),
('Recomendado', 'Windows 10', 'Quad Core 2.5 GHz', 8.00, 'GTX 660 2GB', 74),
('Minimo', 'Windows 10', 'Intel Core i5-8400', 12.00, 'GTX 1060 6GB', 75),
('Recomendado', 'Windows 10', 'Intel Core i7-10700K', 16.00, 'RTX 2070 8GB', 75),
('Minimo', 'Windows 7', 'Dual Core 2.0 GHz', 4.00, 'DirectX 10 Graphics', 76),
('Recomendado', 'Windows 10', 'Quad Core 2.5 GHz', 8.00, 'GTX 660 2GB', 76),
('Minimo', 'Windows 7', 'Dual Core 2.0 GHz', 4.00, 'DirectX 10 Graphics', 77),
('Recomendado', 'Windows 10', 'Quad Core 2.5 GHz', 8.00, 'GTX 660 2GB', 77),
('Minimo', 'Windows 7', 'Dual Core 2.0 GHz', 4.00, 'DirectX 10 Graphics', 78),
('Recomendado', 'Windows 10', 'Quad Core 2.5 GHz', 8.00, 'GTX 660 2GB', 78),
('Minimo', 'Windows 10', 'Intel Core i5-4460', 8.00, 'GTX 960 2GB', 79),
('Recomendado', 'Windows 10', 'Intel Core i7-6700', 16.00, 'GTX 1060 6GB', 79),
('Minimo', 'Windows 10', 'Intel Core i5-4460', 8.00, 'GTX 960 2GB', 80),
('Recomendado', 'Windows 10', 'Intel Core i7-6700', 16.00, 'GTX 1060 6GB', 80),
('Minimo', 'Windows 10', 'Intel Core i5-4430', 8.00, 'GTX 1050 Ti', 81),
('Recomendado', 'Windows 10', 'Intel Core i7-7700K', 16.00, 'GTX 1060 6GB', 81),
('Minimo', 'Windows 7', 'Intel Core 2 Duo', 4.00, 'GT 640', 82),
('Recomendado', 'Windows 10', 'Intel Core i5-3570', 8.00, 'GTX 960 2GB', 82),
('Minimo', 'Windows 7', 'Intel Core i3-2100', 4.00, 'GTX 460', 83),
('Recomendado', 'Windows 10', 'Intel Core i5-2500K', 8.00, 'GTX 660 2GB', 83),
('Minimo', 'Windows 10', 'Intel Core i5-3570', 8.00, 'GTX 760 2GB', 84),
('Recomendado', 'Windows 10', 'Intel Core i7-4770', 16.00, 'GTX 1060 6GB', 84),
('Minimo', 'Windows 7', 'Intel Core i3-2100', 4.00, 'GTS 450', 85),
('Recomendado', 'Windows 10', 'Intel Core i5-3570K', 8.00, 'GTX 570', 85),
('Minimo', 'Windows 7', 'Intel Core 2 Duo', 4.00, 'GTX 260', 86),
('Recomendado', 'Windows 10', 'Intel Core i5-2500K', 8.00, 'GTX 560 1GB', 86),
('Minimo', 'Windows 7', 'Intel Core i5-2400', 4.00, 'GTX 460', 87),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 8.00, 'GTX 660 2GB', 87),
('Minimo', 'Windows 10', 'Intel Core i5-4460', 8.00, 'GTX 760 2GB', 88),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 8.00, 'GTX 1060 6GB', 88),
('Minimo', 'Windows 10', 'Intel Core i5-4460', 8.00, 'GTX 760 2GB', 89),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 16.00, 'GTX 1060 6GB', 89),
('Minimo', 'Windows 10', 'Intel Core i5-4460', 8.00, 'GTX 760 2GB', 90),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 16.00, 'GTX 1060 6GB', 90),
('Minimo', 'Windows 10', 'Intel Core i5-8400', 12.00, 'GTX 1060 6GB', 91),
('Recomendado', 'Windows 10', 'Intel Core i7-10700K', 16.00, 'RTX 2070 8GB', 91),
('Minimo', 'Windows 10', 'Intel Core i5-4460', 8.00, 'GTX 760 2GB', 92),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 8.00, 'GTX 1060 6GB', 92),
('Minimo', 'Windows 10', 'Intel Core i5-4460', 8.00, 'GTX 760 2GB', 93),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 8.00, 'GTX 1060 6GB', 93),
('Minimo', 'Windows 10', 'Intel Core i5-8400', 12.00, 'GTX 1060 6GB', 94),
('Recomendado', 'Windows 10', 'Intel Core i7-10700K', 16.00, 'RTX 2070 8GB', 94),
('Minimo', 'Windows 10', 'Intel Core i5-4460', 8.00, 'GTX 760 2GB', 95),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 8.00, 'GTX 1060 6GB', 95),
('Minimo', 'Windows 7', 'Intel Core i3-2100', 4.00, 'GTS 450', 96),
('Recomendado', 'Windows 10', 'Intel Core i5-3570K', 8.00, 'GTX 570', 96),
('Minimo', 'Windows 10', 'Intel Core i5-2400', 8.00, 'GTX 650 Ti', 97),
('Recomendado', 'Windows 10', 'Intel Core i7-4790', 8.00, 'GTX 960 2GB', 97),
('Minimo', 'Windows 10', 'Intel Core i5-2300', 8.00, 'GTX 550 Ti', 98),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 8.00, 'GTX 760 2GB', 98),
('Minimo', 'Windows 10', 'Intel Core i5-5400', 8.00, 'GTX 760 2GB', 99),
('Recomendado', 'Windows 10', 'Intel Core i7-8700', 16.00, 'GTX 1060 6GB', 99),
('Minimo', 'Windows 10', 'Intel Core i5-8400', 12.00, 'GTX 1060 6GB', 100),
('Recomendado', 'Windows 10', 'Intel Core i7-10700K', 16.00, 'RTX 2070 8GB', 100),
('Minimo', 'Windows 7', 'Intel Core i5-3470', 4.00, 'GTX 560 1GB', 101),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 8.00, 'GTX 750 Ti', 101),
('Minimo', 'Windows 7', 'Intel Core i5-3470', 4.00, 'GTX 560 1GB', 102),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 8.00, 'GTX 750 Ti', 102),
('Minimo', 'Windows 7', 'Intel Core i5-3470', 4.00, 'GTX 560 1GB', 103),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 8.00, 'GTX 750 Ti', 103),
('Minimo', 'Windows 10', 'Intel Core i5-8400', 12.00, 'GTX 1060 6GB', 104),
('Recomendado', 'Windows 10', 'Intel Core i7-10700K', 16.00, 'RTX 2070 8GB', 104),
('Minimo', 'Windows 10', 'Intel Core i5-3470', 8.00, 'GTX 660 2GB', 105),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 8.00, 'GTX 970 4GB', 105),
('Minimo', 'Windows 10', 'Intel Core i5-3470', 8.00, 'GTX 660 2GB', 106),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 8.00, 'GTX 970 4GB', 106),
('Minimo', 'Windows 7', 'Intel Core i5-4460', 8.00, 'GTX 760 2GB', 107),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 8.00, 'GTX 980 4GB', 107),
('Minimo', 'Windows 10', 'Intel Core i5-3470', 8.00, 'GTX 960 2GB', 108),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 16.00, 'GTX 1060 6GB', 108),
('Minimo', 'Windows 10', 'Intel Core i5-3330', 8.00, 'GTX 780 3GB', 109),
('Recomendado', 'Windows 10', 'Intel Core i7-7700', 16.00, 'GTX 1080 8GB', 109),
('Minimo', 'Windows 10', 'Intel Core i5-8400', 16.00, 'GTX 1070 8GB', 110),
('Recomendado', 'Windows 10', 'Intel Core i7-8700K', 16.00, 'RTX 2080 8GB', 110),
('Minimo', 'Windows 7', 'Intel Core i3-3225', 4.00, 'GTX 650 Ti', 111),
('Recomendado', 'Windows 10', 'Intel Core i5-4570', 6.00, 'GTX 760 2GB', 111),
('Minimo', 'Windows 10', 'Intel Core i3-6100', 6.00, 'GTX 750 Ti', 112),
('Recomendado', 'Windows 10', 'Intel Core i5-6400', 8.00, 'GTX 1060 6GB', 112),
('Minimo', 'Windows 10', 'Intel Core i3-3225', 6.00, 'GTX 650 Ti', 113),
('Recomendado', 'Windows 10', 'Intel Core i5-6400', 8.00, 'GTX 960 2GB', 113),
('Minimo', 'Windows 10', 'Intel Core i3-3225', 6.00, 'GTX 650 Ti', 114),
('Recomendado', 'Windows 10', 'Intel Core i5-6400', 8.00, 'GTX 960 2GB', 114),
('Minimo', 'Windows 10', 'Intel Core i3-3225', 6.00, 'GTX 650 Ti', 115),
('Recomendado', 'Windows 10', 'Intel Core i5-6400', 8.00, 'GTX 960 2GB', 115),
('Minimo', 'Windows 7', 'Dual Core 2.0 GHz', 4.00, 'GTX 650', 116),
('Recomendado', 'Windows 10', 'Quad Core 2.5 GHz', 8.00, 'GTX 750 Ti', 116),
('Minimo', 'Windows 10', 'Intel Core i3-2100', 6.00, 'GTX 650 Ti', 117),
('Recomendado', 'Windows 10', 'Intel Core i5-4670', 8.00, 'GTX 760 2GB', 117),
('Minimo', 'Windows 7', 'Dual Core 2.0 GHz', 4.00, 'DirectX 10 Graphics', 118),
('Recomendado', 'Windows 10', 'Quad Core 2.5 GHz', 8.00, 'GTX 660 2GB', 118),
('Minimo', 'Windows 7', 'Intel Core i3-2100', 4.00, 'GTS 450', 119),
('Recomendado', 'Windows 10', 'Intel Core i5-3570K', 8.00, 'GTX 570', 119),
('Minimo', 'Windows 7', 'Dual Core 2.0 GHz', 4.00, 'GTX 650', 120),
('Recomendado', 'Windows 10', 'Quad Core 2.5 GHz', 8.00, 'GTX 750 Ti', 120),
('Minimo', 'Windows 7', 'Intel Core i5-750', 4.00, 'GTX 560 1GB', 121),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 8.00, 'GTX 670 2GB', 121),
('Minimo', 'Windows 10', 'Dual Core 2.0 GHz', 2.00, 'DirectX 10 Graphics', 122),
('Recomendado', 'Windows 10', 'Quad Core 2.5 GHz', 4.00, 'GTX 650', 122),
('Minimo', 'Windows 10', 'Dual Core 2.0 GHz', 2.00, 'DirectX 10 Graphics', 123),
('Recomendado', 'Windows 10', 'Quad Core 2.5 GHz', 4.00, 'GTX 650', 123),
('Minimo', 'Windows 7', 'Intel Core i5-750', 4.00, 'GTX 550 Ti', 124),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 8.00, 'GTX 770 2GB', 124),
('Minimo', 'Windows 10', 'Intel Core i5-4460', 8.00, 'GTX 960 2GB', 125),
('Recomendado', 'Windows 10', 'Intel Core i7-6700', 16.00, 'GTX 1060 6GB', 125),
('Minimo', 'Windows 8.1', 'Dual Core 2.4 GHz', 4.00, 'GTX 650 Ti', 126),
('Recomendado', 'Windows 10', 'Quad Core 3.0 GHz', 8.00, 'GTX 750 Ti', 126),
('Minimo', 'Windows 7', 'Intel Core i5-750', 4.00, 'GTX 550 Ti', 127),
('Recomendado', 'Windows 10', 'Intel Core i5-3470', 8.00, 'GTX 760 2GB', 127),
('Minimo', 'Windows 7', 'Intel Core i3-530', 4.00, 'GTX 460', 128),
('Recomendado', 'Windows 10', 'Intel Core i5-4570', 8.00, 'GTX 670 2GB', 128),
('Minimo', 'Windows 10', 'Intel Core i5-2300', 8.00, 'GTX 650 Ti', 129),
('Recomendado', 'Windows 10', 'Intel Core i5-4460', 8.00, 'GTX 960 2GB', 129),
('Minimo', 'Windows 7', 'Dual Core 2.0 GHz', 2.00, 'Intel HD 4000', 130),
('Recomendado', 'Windows 10', 'Dual Core 2.5 GHz', 4.00, 'GTX 650', 130),
('Minimo', 'Windows 7', 'Intel Core2 Duo E8400', 3.00, 'GT 9600 512MB', 131),
('Recomendado', 'Windows 10', 'Intel Core i5', 4.00, 'GTX 680 2GB', 131),
('Minimo', 'Windows XP', '1.2 GHz Processor', 1.00, 'DirectX 9 Graphics', 132),
('Recomendado', 'Windows 7', '2.0 GHz Processor', 2.00, 'DirectX 9 Graphics', 132),
('Minimo', 'Windows 7', 'Intel Core i5-3210M', 8.00, 'GTX 650 1GB', 133),
('Recomendado', 'Windows 10', 'Intel Core i5-4460', 8.00, 'GTX 960 2GB', 133),
('Minimo', 'Windows XP', 'Intel Core 2 Duo', 1.00, 'DirectX 9 Graphics', 134),
('Recomendado', 'Windows 7', 'Intel Core 2 Duo', 2.00, 'DirectX 9 Graphics', 134),
('Minimo', 'Windows 7', 'Intel Core 2 Duo', 2.00, 'DirectX 9 Graphics', 135),
('Recomendado', 'Windows 8', 'Intel Core i5', 4.00, 'GTX 660 2GB', 135), 
('Minimo', 'Windows 7', 'Dual Core 2.0 GHz', 4.00, 'DirectX 10 Graphics', 136),
('Recomendado', 'Windows 10', 'Quad Core 2.5 GHz', 8.00, 'GTX 660 2GB', 136),
('Minimo', 'Windows 7', 'Dual Core 2.0 GHz', 4.00, 'DirectX 10 Graphics', 137),
('Recomendado', 'Windows 10', 'Quad Core 2.5 GHz', 8.00, 'GTX 660 2GB', 137),
('Minimo', 'Windows 7', 'Dual Core 2.0 GHz', 4.00, 'DirectX 10 Graphics', 138),
('Recomendado', 'Windows 10', 'Quad Core 2.5 GHz', 8.00, 'GTX 660 2GB', 138),
('Minimo', 'Windows 7', 'Dual Core 2.0 GHz', 2.00, 'DirectX 9 Graphics', 139),
('Recomendado', 'Windows 10', 'Dual Core 3.0 GHz', 4.00, 'GTX 650', 139),
('Minimo', 'Windows 7', 'Dual Core 2.0 GHz', 2.00, 'DirectX 9 Graphics', 140),
('Recomendado', 'Windows 10', 'Dual Core 3.0 GHz', 4.00, 'GTX 650', 140),
('Minimo', 'Windows 7', 'Dual Core 2.0 GHz', 2.00, 'DirectX 9 Graphics', 141),
('Recomendado', 'Windows 10', 'Dual Core 3.0 GHz', 4.00, 'GTX 650', 141),
('Minimo', 'Windows 7', 'Dual Core 2.0 GHz', 2.00, 'DirectX 9 Graphics', 142),
('Recomendado', 'Windows 10', 'Dual Core 3.0 GHz', 4.00, 'GTX 650', 142),
('Minimo', 'Windows 7', 'Dual Core 2.0 GHz', 4.00, 'DirectX 10 Graphics', 143),
('Recomendado', 'Windows 10', 'Quad Core 2.5 GHz', 8.00, 'GTX 660 2GB', 143),
('Minimo', 'Windows 7', 'Dual Core 2.0 GHz', 4.00, 'DirectX 10 Graphics', 144),
('Recomendado', 'Windows 10', 'Quad Core 2.5 GHz', 8.00, 'GTX 660 2GB', 144),
('Minimo', 'Windows 10', 'Intel Core i5-4460', 8.00, 'GTX 960 2GB', 145),
('Recomendado', 'Windows 10', 'Intel Core i7-6700', 16.00, 'GTX 1060 6GB', 145),
('Minimo', 'Windows 7', 'Dual Core 2.0 GHz', 2.00, 'DirectX 9 Graphics', 146),
('Recomendado', 'Windows 10', 'Dual Core 3.0 GHz', 4.00, 'GTX 650', 146),
('Minimo', 'Windows 10', 'Intel Core i5-4460', 8.00, 'GTX 960 2GB', 147),
('Recomendado', 'Windows 10', 'Intel Core i7-6700', 16.00, 'GTX 1060 6GB', 147),
('Minimo', 'Windows 10', 'Intel Core i5-4460', 8.00, 'GTX 960 2GB', 148),
('Recomendado', 'Windows 10', 'Intel Core i7-6700', 16.00, 'GTX 1060 6GB', 148),
('Minimo', 'Windows 10', 'Intel Core i5-8400', 12.00, 'GTX 1060 6GB', 149),
('Recomendado', 'Windows 10', 'Intel Core i7-10700K', 16.00, 'RTX 2070 8GB', 149),
('Minimo', 'Windows 10', 'Intel Core i5-4460', 8.00, 'GTX 960 2GB', 150),
('Recomendado', 'Windows 10', 'Intel Core i7-6700', 16.00, 'GTX 1060 6GB', 150),
('Minimo', 'Windows 7', 'Dual Core 2.0 GHz', 4.00, 'DirectX 10 Graphics', 151),
('Recomendado', 'Windows 10', 'Quad Core 2.5 GHz', 8.00, 'GTX 660 2GB', 151),
('Minimo', 'Windows 10', 'Intel Core i5-4460', 8.00, 'GTX 960 2GB', 152),
('Recomendado', 'Windows 10', 'Intel Core i7-6700', 16.00, 'GTX 1060 6GB', 152),
('Minimo', 'Windows 10', 'Intel Core i5-4460', 8.00, 'GTX 960 2GB', 153),
('Recomendado', 'Windows 10', 'Intel Core i7-6700', 16.00, 'GTX 1060 6GB', 153),
('Minimo', 'Windows 7', 'Dual Core 2.0 GHz', 4.00, 'DirectX 10 Graphics', 154),
('Recomendado', 'Windows 10', 'Quad Core 2.5 GHz', 8.00, 'GTX 660 2GB', 154),
('Minimo', 'Windows 10', 'Intel Core i5-8400', 12.00, 'GTX 1060 6GB', 155),
('Recomendado', 'Windows 10', 'Intel Core i7-10700K', 16.00, 'RTX 2070 8GB', 155),
('Minimo', 'Windows 7', 'Dual Core 2.0 GHz', 4.00, 'DirectX 10 Graphics', 156),
('Recomendado', 'Windows 10', 'Quad Core 2.5 GHz', 8.00, 'GTX 660 2GB', 156),
('Minimo', 'Windows 10', 'Intel Core i5-4460', 8.00, 'GTX 960 2GB', 157),
('Recomendado', 'Windows 10', 'Intel Core i7-6700', 16.00, 'GTX 1060 6GB', 157),
('Minimo', 'Windows 10', 'Intel Core i5-8400', 12.00, 'GTX 1060 6GB', 158),
('Recomendado', 'Windows 10', 'Intel Core i7-10700K', 16.00, 'RTX 2070 8GB', 158),
('Minimo', 'Windows 10', 'Intel Core i5-4460', 8.00, 'GTX 960 2GB', 159),
('Recomendado', 'Windows 10', 'Intel Core i7-6700', 16.00, 'GTX 1060 6GB', 159),
('Minimo', 'Windows 10', 'Intel Core i5-4460', 8.00, 'GTX 960 2GB', 160),
('Recomendado', 'Windows 10', 'Intel Core i7-6700', 16.00, 'GTX 1060 6GB', 160),
('Minimo', 'Windows 7', 'Dual Core 2.0 GHz', 4.00, 'DirectX 10 Graphics', 161),
('Recomendado', 'Windows 10', 'Quad Core 2.5 GHz', 8.00, 'GTX 660 2GB', 161),
('Minimo', 'Windows 7', 'Dual Core 2.0 GHz', 4.00, 'DirectX 10 Graphics', 162),
('Recomendado', 'Windows 10', 'Quad Core 2.5 GHz', 8.00, 'GTX 660 2GB', 162),
('Minimo', 'Windows 7', 'Dual Core 2.0 GHz', 4.00, 'DirectX 10 Graphics', 163),
('Recomendado', 'Windows 10', 'Quad Core 2.5 GHz', 8.00, 'GTX 660 2GB', 163),
('Minimo', 'Windows 7', 'Dual Core 2.0 GHz', 4.00, 'DirectX 10 Graphics', 164),
('Recomendado', 'Windows 10', 'Quad Core 2.5 GHz', 8.00, 'GTX 660 2GB', 164),
('Minimo', 'Windows 7', 'Dual Core 2.0 GHz', 4.00, 'DirectX 10 Graphics', 165),
('Recomendado', 'Windows 10', 'Quad Core 2.5 GHz', 8.00, 'GTX 660 2GB', 165),
('Minimo', 'Windows 7', 'Dual Core 2.0 GHz', 4.00, 'DirectX 10 Graphics', 166),
('Recomendado', 'Windows 10', 'Quad Core 2.5 GHz', 8.00, 'GTX 660 2GB', 166),
('Minimo', 'Windows 10', 'Intel Core i5-4460', 8.00, 'GTX 960 2GB', 167),
('Recomendado', 'Windows 10', 'Intel Core i7-6700', 16.00, 'GTX 1060 6GB', 167),
('Minimo', 'Windows 10', 'Intel Core i5-4460', 8.00, 'GTX 960 2GB', 168),
('Recomendado', 'Windows 10', 'Intel Core i7-6700', 16.00, 'GTX 1060 6GB', 168),
('Minimo', 'Windows 7', 'Dual Core 2.0 GHz', 4.00, 'DirectX 10 Graphics', 169),
('Recomendado', 'Windows 10', 'Quad Core 2.5 GHz', 8.00, 'GTX 660 2GB', 169),
('Minimo', 'Windows 10', 'Intel Core i5-4460', 8.00, 'GTX 960 2GB', 170),
('Recomendado', 'Windows 10', 'Intel Core i7-6700', 16.00, 'GTX 1060 6GB', 170),
('Minimo', 'Windows 7', 'Dual Core 2.0 GHz', 4.00, 'DirectX 10 Graphics', 171),
('Recomendado', 'Windows 10', 'Quad Core 2.5 GHz', 8.00, 'GTX 660 2GB', 171),
('Minimo', 'Windows 10', 'Intel Core i5-4460', 8.00, 'GTX 760 2GB', 172),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 16.00, 'GTX 1060 6GB', 172),
('Minimo', 'Windows 10', 'Intel Core i5-4690', 8.00, 'GTX 780 3GB', 173),
('Recomendado', 'Windows 10', 'Intel Core i7-7700K', 16.00, 'GTX 1080 8GB', 173),
('Minimo', 'Windows 10', 'Intel Core i5-4690', 8.00, 'GTX 780 3GB', 174),
('Recomendado', 'Windows 10', 'Intel Core i7-7700K', 16.00, 'GTX 1080 8GB', 174),
('Minimo', 'Windows 10', 'Intel Core i5-4690', 8.00, 'GTX 780 3GB', 175),
('Recomendado', 'Windows 10', 'Intel Core i7-7700K', 16.00, 'GTX 1080 8GB', 175),
('Minimo', 'Windows 7', 'Intel Core 2 Duo', 4.00, 'GTX 460', 176),
('Recomendado', 'Windows 10', 'Intel Core i5-2500K', 8.00, 'GTX 660 2GB', 176),
('Minimo', 'Windows 7', 'Intel Core i5-2400', 4.00, 'GTX 640', 177),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 8.00, 'GTX 960 2GB', 177),
('Minimo', 'Windows 7', 'Intel Core i5-2400', 4.00, 'GTX 640', 178),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 8.00, 'GTX 960 2GB', 178),
('Minimo', 'Windows 10', 'Intel Core i5-4460', 8.00, 'GTX 760 2GB', 179),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 16.00, 'GTX 1060 6GB', 179),
('Minimo', 'Windows 10', 'Intel Core i5-4460', 8.00, 'GTX 760 2GB', 180),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 16.00, 'GTX 1060 6GB', 180),
('Minimo', 'Windows 10', 'Intel Core i5-4460', 8.00, 'GTX 760 2GB', 181),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 16.00, 'GTX 1060 6GB', 181),
('Minimo', 'Windows 7', 'Intel Core i3', 4.00, 'GTX 460', 182),
('Recomendado', 'Windows 10', 'Intel Core i5', 8.00, 'GTX 660 2GB', 182),
('Minimo', 'Windows 7', 'Intel Core i5-2500K', 8.00, 'GTX 660 2GB', 183),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 8.00, 'GTX 970 4GB', 183),
('Minimo', 'Windows 7', 'Intel Core i5-2500K', 8.00, 'GTX 660 2GB', 184),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 8.00, 'GTX 970 4GB', 184),
('Minimo', 'Windows 7', 'Intel Core i5-2500K', 8.00, 'GTX 660 2GB', 185),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 8.00, 'GTX 970 4GB', 185),
('Minimo', 'Windows 7', 'Intel Core i5-4460', 8.00, 'GTX 760 2GB', 186),
('Recomendado', 'Windows 10', 'Intel Core i7-4770', 16.00, 'GTX 1060 6GB', 186),
('Minimo', 'Windows 7', 'Intel Core i5-4460', 8.00, 'GTX 760 2GB', 187),
('Recomendado', 'Windows 10', 'Intel Core i7-4770', 16.00, 'GTX 1060 6GB', 187),
('Minimo', 'Windows 10', 'Intel Core i5-8400', 12.00, 'GTX 1060 6GB', 188),
('Recomendado', 'Windows 10', 'Intel Core i7-10700K', 16.00, 'RTX 2070 8GB', 188),
('Minimo', 'Windows 7', 'Intel Core 2 Duo', 4.00, 'GT 8800', 189),
('Recomendado', 'Windows 10', 'Intel Core i5-2500K', 6.00, 'GTX 660 2GB', 189),
('Minimo', 'Windows 10', 'Intel Core i5-4460', 8.00, 'GTX 960 2GB', 190),
('Recomendado', 'Windows 10', 'Intel Core i7-6700', 16.00, 'GTX 1060 6GB', 190),
('Minimo', 'Windows 10', 'Intel Core i5-4460', 8.00, 'GTX 960 2GB', 191),
('Recomendado', 'Windows 10', 'Intel Core i7-6700', 16.00, 'GTX 1060 6GB', 191),
('Minimo', 'Windows 7', 'Intel Core 2 Duo', 2.00, 'DirectX 9 Graphics', 192),
('Recomendado', 'Windows 10', 'Intel Core i5', 4.00, 'GTX 650', 192),
('Minimo', 'Windows 7', 'Intel Core i3-2100', 4.00, 'GTX 550 Ti', 193),
('Recomendado', 'Windows 10', 'Intel Core i5-3570K', 8.00, 'GTX 760 2GB', 193),
('Minimo', 'Windows 7', 'Intel Core i3-2100', 4.00, 'GTX 550 Ti', 194),
('Recomendado', 'Windows 10', 'Intel Core i5-3570K', 8.00, 'GTX 760 2GB', 194),
('Minimo', 'Windows 10', 'Intel Core i5-4460', 8.00, 'GTX 960 2GB', 195),
('Recomendado', 'Windows 10', 'Intel Core i7-6700', 16.00, 'GTX 1060 6GB', 195),
('Minimo', 'Windows 10', 'Intel Core i5-4460', 8.00, 'GTX 960 2GB', 196),
('Recomendado', 'Windows 10', 'Intel Core i7-6700', 16.00, 'GTX 1060 6GB', 196),
('Minimo', 'Windows 7', 'Intel Core i5-2500K', 6.00, 'GTX 460', 197),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 8.00, 'GTX 970 4GB', 197),
('Minimo', 'Windows 10', 'Intel Core i5-8400', 12.00, 'GTX 1060 6GB', 198),
('Recomendado', 'Windows 10', 'Intel Core i7-10700K', 16.00, 'RTX 2070 8GB', 198),
('Minimo', 'Windows 7', 'Intel Core i5-2500K', 6.00, 'GTX 560', 199),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 8.00, 'GTX 970 4GB', 199),
('Minimo', 'Windows 10', 'Intel Core i5-4460', 8.00, 'GTX 960 2GB', 200),
('Recomendado', 'Windows 10', 'Intel Core i7-6700', 16.00, 'GTX 1060 6GB', 200),
('Minimo', 'Windows 10', 'Intel Core i5-4460', 8.00, 'GTX 960 2GB', 201),
('Recomendado', 'Windows 10', 'Intel Core i7-6700', 16.00, 'GTX 1060 6GB', 201),
('Minimo', 'Windows 10', 'Intel Core i5-4460', 8.00, 'GTX 960 2GB', 202),
('Recomendado', 'Windows 10', 'Intel Core i7-6700', 16.00, 'GTX 1060 6GB', 202),
('Minimo', 'Windows 7', 'Intel Core i5-2500K', 8.00, 'GTX 660 2GB', 203),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 16.00, 'GTX 970 4GB', 203),
('Minimo', 'Windows 7', 'Dual Core 2.0 GHz', 4.00, 'DirectX 10 Graphics', 204),
('Recomendado', 'Windows 10', 'Quad Core 2.5 GHz', 8.00, 'GTX 660 2GB', 204),
('Minimo', 'Windows 10', 'Intel Core i5-4460', 8.00, 'GTX 960 2GB', 205),
('Recomendado', 'Windows 10', 'Intel Core i7-6700', 16.00, 'GTX 1060 6GB', 205),
('Minimo', 'Windows 10', 'Intel Core i5-4460', 8.00, 'GTX 960 2GB', 206),
('Recomendado', 'Windows 10', 'Intel Core i7-6700', 16.00, 'GTX 1060 6GB', 206),
('Minimo', 'Windows 7', 'Intel Core i5-2400', 4.00, 'GTX 650', 207),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 8.00, 'GTX 960 2GB', 207),
('Minimo', 'Windows 7', 'Intel Core i5-2400', 4.00, 'GTX 650', 208),
('Recomendado', 'Windows 10', 'Intel Core i7-3770', 8.00, 'GTX 960 2GB', 208),
('Minimo', 'Windows 7', 'Intel Core 2 Duo', 2.00, 'DirectX 9 Graphics', 209),
('Recomendado', 'Windows 10', 'Dual Core 3.0 GHz', 4.00, 'GTX 460', 209),
('Minimo', 'Windows 7', 'Intel Core 2 Duo', 2.00, 'DirectX 9 Graphics', 210),
('Recomendado', 'Windows 10', 'Dual Core 3.0 GHz', 4.00, 'GTX 460', 210);






/* ------------------------- 1. Soporte_Idioma ------------------------- */
 INSERT INTO Soporte_Idioma (Soporta_Interfaz, Soporta_Audio, Soporta_Subtitulos, ID_Producto_FK, ID_Idioma_FK) VALUES
-- Juego 1
(1, 1, 1, 1, 1), (1, 1, 1, 1, 2), (1, 0, 1, 1, 3), (1, 0, 1, 1, 4),
-- Juego 2
(1, 1, 1, 2, 1), (1, 1, 1, 2, 2), (1, 0, 1, 2, 3), (1, 0, 1, 2, 4),
-- Juego 3
(1, 1, 1, 3, 1), (1, 1, 1, 3, 2), (1, 0, 1, 3, 3), (1, 0, 1, 3, 4),
-- Juego 4
(1, 1, 1, 4, 1), (1, 1, 1, 4, 2), (1, 0, 1, 4, 3), (1, 0, 1, 4, 4),
-- Juego 5
(1, 1, 1, 5, 1), (1, 1, 1, 5, 2), (1, 0, 1, 5, 3), (1, 0, 1, 5, 4),
-- Juego 6
(1, 1, 1, 6, 1), (1, 1, 1, 6, 2), (1, 0, 1, 6, 3), (1, 0, 1, 6, 4),
-- Juego 7
(1, 1, 1, 7, 1), (1, 1, 1, 7, 2), (1, 0, 1, 7, 3), (1, 0, 1, 7, 4),
-- Juego 8
(1, 1, 1, 8, 1), (1, 1, 1, 8, 2), (1, 0, 1, 8, 3), (1, 0, 1, 8, 4),
-- Juego 9
(1, 1, 1, 9, 1), (1, 1, 1, 9, 2), (1, 0, 1, 9, 3), (1, 0, 1, 9, 4),
-- Juego 10
(1, 1, 1, 10, 1), (1, 1, 1, 10, 2), (1, 0, 1, 10, 3), (1, 0, 1, 10, 4),
-- Juego 11
(1, 1, 1, 11, 1), (1, 1, 1, 11, 2), (1, 0, 1, 11, 3), (1, 0, 1, 11, 4),
-- Juego 12
(1, 1, 1, 12, 1), (1, 1, 1, 12, 2), (1, 0, 1, 12, 3), (1, 0, 1, 12, 4),
-- Juego 13
(1, 1, 1, 13, 1), (1, 1, 1, 13, 2), (1, 0, 1, 13, 3), (1, 0, 1, 13, 4),
-- Juego 14
(1, 1, 1, 14, 1), (1, 1, 1, 14, 2), (1, 0, 1, 14, 3), (1, 0, 1, 14, 4),
-- Juego 15
(1, 1, 1, 15, 1), (1, 1, 1, 15, 2), (1, 0, 1, 15, 3), (1, 0, 1, 15, 4),
-- Juego 16
(1, 1, 1, 16, 1), (1, 1, 1, 16, 2), (1, 0, 1, 16, 3), (1, 0, 1, 16, 4),
-- Juego 17
(1, 1, 1, 17, 1), (1, 1, 1, 17, 2), (1, 0, 1, 17, 3), (1, 0, 1, 17, 4),
-- Juego 18
(1, 1, 1, 18, 1), (1, 1, 1, 18, 2), (1, 0, 1, 18, 3), (1, 0, 1, 18, 4),
-- Juego 19
(1, 1, 1, 19, 1), (1, 1, 1, 19, 2), (1, 0, 1, 19, 3), (1, 0, 1, 19, 4),
-- Juego 20
(1, 1, 1, 20, 1), (1, 1, 1, 20, 2), (1, 0, 1, 20, 3), (1, 0, 1, 20, 4),
-- Juego 21
(1, 1, 1, 21, 1), (1, 1, 1, 21, 2), (1, 0, 1, 21, 3), (1, 0, 1, 21, 4),
-- Juego 22
(1, 1, 1, 22, 1), (1, 1, 1, 22, 2), (1, 0, 1, 22, 3), (1, 0, 1, 22, 4),
-- Juego 23
(1, 1, 1, 23, 1), (1, 1, 1, 23, 2), (1, 0, 1, 23, 3), (1, 0, 1, 23, 4),
-- Juego 24
(1, 1, 1, 24, 1), (1, 1, 1, 24, 2), (1, 0, 1, 24, 3), (1, 0, 1, 24, 4),
-- Juego 25
(1, 1, 1, 25, 1), (1, 1, 1, 25, 2), (1, 0, 1, 25, 3), (1, 0, 1, 25, 4),
-- Juego 26
(1, 1, 1, 26, 1), (1, 1, 1, 26, 2), (1, 0, 1, 26, 3), (1, 0, 1, 26, 4),
-- Juego 27
(1, 1, 1, 27, 1), (1, 1, 1, 27, 2), (1, 0, 1, 27, 3), (1, 0, 1, 27, 4),
-- Juego 28
(1, 1, 1, 28, 1), (1, 1, 1, 28, 2), (1, 0, 1, 28, 3), (1, 0, 1, 28, 4),
-- Juego 29
(1, 1, 1, 29, 1), (1, 1, 1, 29, 2), (1, 0, 1, 29, 3), (1, 0, 1, 29, 4),
-- Juego 30
(1, 1, 1, 30, 1), (1, 1, 1, 30, 2), (1, 0, 1, 30, 3), (1, 0, 1, 30, 4),
-- Juego 31
(1, 1, 1, 31, 1), (1, 1, 1, 31, 2), (1, 0, 1, 31, 3), (1, 0, 1, 31, 4),
-- Juego 32
(1, 1, 1, 32, 1), (1, 1, 1, 32, 2), (1, 0, 1, 32, 3), (1, 0, 1, 32, 4),
-- Juego 33
(1, 1, 1, 33, 1), (1, 1, 1, 33, 2), (1, 0, 1, 33, 3), (1, 0, 1, 33, 4),
-- Juego 34
(1, 1, 1, 34, 1), (1, 1, 1, 34, 2), (1, 0, 1, 34, 3), (1, 0, 1, 34, 4),
-- Juego 35
(1, 1, 1, 35, 1), (1, 1, 1, 35, 2), (1, 0, 1, 35, 3), (1, 0, 1, 35, 4),
-- Juego 36
(1, 1, 1, 36, 1), (1, 1, 1, 36, 2), (1, 0, 1, 36, 3), (1, 0, 1, 36, 4),
-- Juego 37
(1, 1, 1, 37, 1), (1, 1, 1, 37, 2), (1, 0, 1, 37, 3), (1, 0, 1, 37, 4),
-- Juego 38
(1, 1, 1, 38, 1), (1, 1, 1, 38, 2), (1, 0, 1, 38, 3), (1, 0, 1, 38, 4),
-- Juego 39
(1, 1, 1, 39, 1), (1, 1, 1, 39, 2), (1, 0, 1, 39, 3), (1, 0, 1, 39, 4),
-- Juego 40
(1, 1, 1, 40, 1), (1, 1, 1, 40, 2), (1, 0, 1, 40, 3), (1, 0, 1, 40, 4),
-- Juego 41
(1, 1, 1, 41, 1), (1, 1, 1, 41, 2), (1, 0, 1, 41, 3), (1, 0, 1, 41, 4),
-- Juego 42
(1, 1, 1, 42, 1), (1, 1, 1, 42, 2), (1, 0, 1, 42, 3), (1, 0, 1, 42, 4),
-- Juego 43
(1, 1, 1, 43, 1), (1, 1, 1, 43, 2), (1, 0, 1, 43, 3), (1, 0, 1, 43, 4),
-- Juego 44
(1, 1, 1, 44, 1), (1, 1, 1, 44, 2), (1, 0, 1, 44, 3), (1, 0, 1, 44, 4),
-- Juego 45
(1, 1, 1, 45, 1), (1, 1, 1, 45, 2), (1, 0, 1, 45, 3), (1, 0, 1, 45, 4),
-- Juego 46
(1, 1, 1, 46, 1), (1, 1, 1, 46, 2), (1, 0, 1, 46, 3), (1, 0, 1, 46, 4),
-- Juego 47
(1, 1, 1, 47, 1), (1, 1, 1, 47, 2), (1, 0, 1, 47, 3), (1, 0, 1, 47, 4),
-- Juego 48
(1, 1, 1, 48, 1), (1, 1, 1, 48, 2), (1, 0, 1, 48, 3), (1, 0, 1, 48, 4),
-- Juego 49
(1, 1, 1, 49, 1), (1, 1, 1, 49, 2), (1, 0, 1, 49, 3), (1, 0, 1, 49, 4),
-- Juego 50
(1, 1, 1, 50, 1), (1, 1, 1, 50, 2), (1, 0, 1, 50, 3), (1, 0, 1, 50, 4),
-- Juego 51
(1, 1, 1, 51, 1), (1, 1, 1, 51, 2), (1, 0, 1, 51, 3), (1, 0, 1, 51, 4),
-- Juego 52
(1, 1, 1, 52, 1), (1, 1, 1, 52, 2), (1, 0, 1, 52, 3), (1, 0, 1, 52, 4),
-- Juego 53
(1, 1, 1, 53, 1), (1, 1, 1, 53, 2), (1, 0, 1, 53, 3), (1, 0, 1, 53, 4),
-- Juego 54
(1, 1, 1, 54, 1), (1, 1, 1, 54, 2), (1, 0, 1, 54, 3), (1, 0, 1, 54, 4),
-- Juego 55
(1, 1, 1, 55, 1), (1, 1, 1, 55, 2), (1, 0, 1, 55, 3), (1, 0, 1, 55, 4),
-- Juego 56
(1, 1, 1, 56, 1), (1, 1, 1, 56, 2), (1, 0, 1, 56, 3), (1, 0, 1, 56, 4),
-- Juego 57
(1, 1, 1, 57, 1), (1, 1, 1, 57, 2), (1, 0, 1, 57, 3), (1, 0, 1, 57, 4),
-- Juego 58
(1, 1, 1, 58, 1), (1, 1, 1, 58, 2), (1, 0, 1, 58, 3), (1, 0, 1, 58, 4),
-- Juego 59
(1, 1, 1, 59, 1), (1, 1, 1, 59, 2), (1, 0, 1, 59, 3), (1, 0, 1, 59, 4),
-- Juego 60
(1, 1, 1, 60, 1), (1, 1, 1, 60, 2), (1, 0, 1, 60, 3), (1, 0, 1, 60, 4),
-- Juego 61
(1, 1, 1, 61, 1), (1, 1, 1, 61, 2), (1, 0, 1, 61, 3), (1, 0, 1, 61, 4),
-- Juego 62
(1, 1, 1, 62, 1), (1, 1, 1, 62, 2), (1, 0, 1, 62, 3), (1, 0, 1, 62, 4),
-- Juego 63
(1, 1, 1, 63, 1), (1, 1, 1, 63, 2), (1, 0, 1, 63, 3), (1, 0, 1, 63, 4),
-- Juego 64
(1, 1, 1, 64, 1), (1, 1, 1, 64, 2), (1, 0, 1, 64, 3), (1, 0, 1, 64, 4),
-- Juego 65
(1, 1, 1, 65, 1), (1, 1, 1, 65, 2), (1, 0, 1, 65, 3), (1, 0, 1, 65, 4),
-- Juego 66
(1, 1, 1, 66, 1), (1, 1, 1, 66, 2), (1, 0, 1, 66, 3), (1, 0, 1, 66, 4),
-- Juego 67
(1, 1, 1, 67, 1), (1, 1, 1, 67, 2), (1, 0, 1, 67, 3), (1, 0, 1, 67, 4),
-- Juego 68
(1, 1, 1, 68, 1), (1, 1, 1, 68, 2), (1, 0, 1, 68, 3), (1, 0, 1, 68, 4),
-- Juego 69
(1, 1, 1, 69, 1), (1, 1, 1, 69, 2), (1, 0, 1, 69, 3), (1, 0, 1, 69, 4),
-- Juego 70
(1, 1, 1, 70, 1), (1, 1, 1, 70, 2), (1, 0, 1, 70, 3), (1, 0, 1, 70, 4),
-- Juego 71
(1, 1, 1, 71, 1), (1, 1, 1, 71, 2), (1, 0, 1, 71, 3), (1, 0, 1, 71, 4),
-- Juego 72
(1, 1, 1, 72, 1), (1, 1, 1, 72, 2), (1, 0, 1, 72, 3), (1, 0, 1, 72, 4),
-- Juego 73
(1, 1, 1, 73, 1), (1, 1, 1, 73, 2), (1, 0, 1, 73, 3), (1, 0, 1, 73, 4),
-- Juego 74
(1, 1, 1, 74, 1), (1, 1, 1, 74, 2), (1, 0, 1, 74, 3), (1, 0, 1, 74, 4),
-- Juego 75
(1, 1, 1, 75, 1), (1, 1, 1, 75, 2), (1, 0, 1, 75, 3), (1, 0, 1, 75, 4),
-- Juego 76
(1, 1, 1, 76, 1), (1, 1, 1, 76, 2), (1, 0, 1, 76, 3), (1, 0, 1, 76, 4),
-- Juego 77
(1, 1, 1, 77, 1), (1, 1, 1, 77, 2), (1, 0, 1, 77, 3), (1, 0, 1, 77, 4),
-- Juego 78
(1, 1, 1, 78, 1), (1, 1, 1, 78, 2), (1, 0, 1, 78, 3), (1, 0, 1, 78, 4),
-- Juego 79
(1, 1, 1, 79, 1), (1, 1, 1, 79, 2), (1, 0, 1, 79, 3), (1, 0, 1, 79, 4),
-- Juego 80
(1, 1, 1, 80, 1), (1, 1, 1, 80, 2), (1, 0, 1, 80, 3), (1, 0, 1, 80, 4),
-- Juego 81
(1, 1, 1, 81, 1), (1, 1, 1, 81, 2), (1, 0, 1, 81, 3), (1, 0, 1, 81, 4),
-- Juego 82
(1, 1, 1, 82, 1), (1, 1, 1, 82, 2), (1, 0, 1, 82, 3), (1, 0, 1, 82, 4),
-- Juego 83
(1, 1, 1, 83, 1), (1, 1, 1, 83, 2), (1, 0, 1, 83, 3), (1, 0, 1, 83, 4),
-- Juego 84
(1, 1, 1, 84, 1), (1, 1, 1, 84, 2), (1, 0, 1, 84, 3), (1, 0, 1, 84, 4),
-- Juego 85
(1, 1, 1, 85, 1), (1, 1, 1, 85, 2), (1, 0, 1, 85, 3), (1, 0, 1, 85, 4),
-- Juego 86
(1, 1, 1, 86, 1), (1, 1, 1, 86, 2), (1, 0, 1, 86, 3), (1, 0, 1, 86, 4),
-- Juego 87
(1, 1, 1, 87, 1), (1, 1, 1, 87, 2), (1, 0, 1, 87, 3), (1, 0, 1, 87, 4),
-- Juego 88
(1, 1, 1, 88, 1), (1, 1, 1, 88, 2), (1, 0, 1, 88, 3), (1, 0, 1, 88, 4),
-- Juego 89
(1, 1, 1, 89, 1), (1, 1, 1, 89, 2), (1, 0, 1, 89, 3), (1, 0, 1, 89, 4),
-- Juego 90
(1, 1, 1, 90, 1), (1, 1, 1, 90, 2), (1, 0, 1, 90, 3), (1, 0, 1, 90, 4),
-- Juego 91
(1, 1, 1, 91, 1), (1, 1, 1, 91, 2), (1, 0, 1, 91, 3), (1, 0, 1, 91, 4),
-- Juego 92
(1, 1, 1, 92, 1), (1, 1, 1, 92, 2), (1, 0, 1, 92, 3), (1, 0, 1, 92, 4),
-- Juego 93
(1, 1, 1, 93, 1), (1, 1, 1, 93, 2), (1, 0, 1, 93, 3), (1, 0, 1, 93, 4),
-- Juego 94
(1, 1, 1, 94, 1), (1, 1, 1, 94, 2), (1, 0, 1, 94, 3), (1, 0, 1, 94, 4),
-- Juego 95
(1, 1, 1, 95, 1), (1, 1, 1, 95, 2), (1, 0, 1, 95, 3), (1, 0, 1, 95, 4),
-- Juego 96
(1, 1, 1, 96, 1), (1, 1, 1, 96, 2), (1, 0, 1, 96, 3), (1, 0, 1, 96, 4),
-- Juego 97
(1, 1, 1, 97, 1), (1, 1, 1, 97, 2), (1, 0, 1, 97, 3), (1, 0, 1, 97, 4),
-- Juego 98
(1, 1, 1, 98, 1), (1, 1, 1, 98, 2), (1, 0, 1, 98, 3), (1, 0, 1, 98, 4),
-- Juego 99
(1, 1, 1, 99, 1), (1, 1, 1, 99, 2), (1, 0, 1, 99, 3), (1, 0, 1, 99, 4),
-- Juego 100
(1, 1, 1, 100, 1), (1, 1, 1, 100, 2), (1, 0, 1, 100, 3), (1, 0, 1, 100, 4),
-- Juego 101
(1, 1, 1, 101, 1), (1, 1, 1, 101, 2), (1, 0, 1, 101, 3), (1, 0, 1, 101, 4),
-- Juego 102
(1, 1, 1, 102, 1), (1, 1, 1, 102, 2), (1, 0, 1, 102, 3), (1, 0, 1, 102, 4),
-- Juego 103
(1, 1, 1, 103, 1), (1, 1, 1, 103, 2), (1, 0, 1, 103, 3), (1, 0, 1, 103, 4),
-- Juego 104
(1, 1, 1, 104, 1), (1, 1, 1, 104, 2), (1, 0, 1, 104, 3), (1, 0, 1, 104, 4),
-- Juego 105
(1, 1, 1, 105, 1), (1, 1, 1, 105, 2), (1, 0, 1, 105, 3), (1, 0, 1, 105, 4),
-- Juego 106
(1, 1, 1, 106, 1), (1, 1, 1, 106, 2), (1, 0, 1, 106, 3), (1, 0, 1, 106, 4),
-- Juego 107
(1, 1, 1, 107, 1), (1, 1, 1, 107, 2), (1, 0, 1, 107, 3), (1, 0, 1, 107, 4),
-- Juego 108
(1, 1, 1, 108, 1), (1, 1, 1, 108, 2), (1, 0, 1, 108, 3), (1, 0, 1, 108, 4),
-- Juego 109
(1, 1, 1, 109, 1), (1, 1, 1, 109, 2), (1, 0, 1, 109, 3), (1, 0, 1, 109, 4),
-- Juego 110
(1, 1, 1, 110, 1), (1, 1, 1, 110, 2), (1, 0, 1, 110, 3), (1, 0, 1, 110, 4),
-- Juego 111
(1, 1, 1, 111, 1), (1, 1, 1, 111, 2), (1, 0, 1, 111, 3), (1, 0, 1, 111, 4),
-- Juego 112
(1, 1, 1, 112, 1), (1, 1, 1, 112, 2), (1, 0, 1, 112, 3), (1, 0, 1, 112, 4),
-- Juego 113
(1, 1, 1, 113, 1), (1, 1, 1, 113, 2), (1, 0, 1, 113, 3), (1, 0, 1, 113, 4),
-- Juego 114
(1, 1, 1, 114, 1), (1, 1, 1, 114, 2), (1, 0, 1, 114, 3), (1, 0, 1, 114, 4),
-- Juego 115
(1, 1, 1, 115, 1), (1, 1, 1, 115, 2), (1, 0, 1, 115, 3), (1, 0, 1, 115, 4),
-- Juego 116
(1, 1, 1, 116, 1), (1, 1, 1, 116, 2), (1, 0, 1, 116, 3), (1, 0, 1, 116, 4),
-- Juego 117
(1, 1, 1, 117, 1), (1, 1, 1, 117, 2), (1, 0, 1, 117, 3), (1, 0, 1, 117, 4),
-- Juego 118
(1, 1, 1, 118, 1), (1, 1, 1, 118, 2), (1, 0, 1, 118, 3), (1, 0, 1, 118, 4),
-- Juego 119
(1, 1, 1, 119, 1), (1, 1, 1, 119, 2), (1, 0, 1, 119, 3), (1, 0, 1, 119, 4),
-- Juego 120
(1, 1, 1, 120, 1), (1, 1, 1, 120, 2), (1, 0, 1, 120, 3), (1, 0, 1, 120, 4),
-- Juego 121
(1, 1, 1, 121, 1), (1, 1, 1, 121, 2), (1, 0, 1, 121, 3), (1, 0, 1, 121, 4),
-- Juego 122
(1, 1, 1, 122, 1), (1, 1, 1, 122, 2), (1, 0, 1, 122, 3), (1, 0, 1, 122, 4),
-- Juego 123
(1, 1, 1, 123, 1), (1, 1, 1, 123, 2), (1, 0, 1, 123, 3), (1, 0, 1, 123, 4),
-- Juego 124
(1, 1, 1, 124, 1), (1, 1, 1, 124, 2), (1, 0, 1, 124, 3), (1, 0, 1, 124, 4),
-- Juego 125
(1, 1, 1, 125, 1), (1, 1, 1, 125, 2), (1, 0, 1, 125, 3), (1, 0, 1, 125, 4),
-- Juego 126
(1, 1, 1, 126, 1), (1, 1, 1, 126, 2), (1, 0, 1, 126, 3), (1, 0, 1, 126, 4),
-- Juego 127
(1, 1, 1, 127, 1), (1, 1, 1, 127, 2), (1, 0, 1, 127, 3), (1, 0, 1, 127, 4),
-- Juego 128
(1, 1, 1, 128, 1), (1, 1, 1, 128, 2), (1, 0, 1, 128, 3), (1, 0, 1, 128, 4),
-- Juego 129
(1, 1, 1, 129, 1), (1, 1, 1, 129, 2), (1, 0, 1, 129, 3), (1, 0, 1, 129, 4),
-- Juego 130
(1, 1, 1, 130, 1), (1, 1, 1, 130, 2), (1, 0, 1, 130, 3), (1, 0, 1, 130, 4),
-- Juego 131
(1, 1, 1, 131, 1), (1, 1, 1, 131, 2), (1, 0, 1, 131, 3), (1, 0, 1, 131, 4),
-- Juego 132
(1, 1, 1, 132, 1), (1, 1, 1, 132, 2), (1, 0, 1, 132, 3), (1, 0, 1, 132, 4),
-- Juego 133
(1, 1, 1, 133, 1), (1, 1, 1, 133, 2), (1, 0, 1, 133, 3), (1, 0, 1, 133, 4),
-- Juego 134
(1, 1, 1, 134, 1), (1, 1, 1, 134, 2), (1, 0, 1, 134, 3), (1, 0, 1, 134, 4),
-- Juego 135
(1, 1, 1, 135, 1), (1, 1, 1, 135, 2), (1, 0, 1, 135, 3), (1, 0, 1, 135, 4),
-- Juego 136
(1, 1, 1, 136, 1), (1, 1, 1, 136, 2), (1, 0, 1, 136, 3), (1, 0, 1, 136, 4),
-- Juego 137
(1, 1, 1, 137, 1), (1, 1, 1, 137, 2), (1, 0, 1, 137, 3), (1, 0, 1, 137, 4),
-- Juego 138
(1, 1, 1, 138, 1), (1, 1, 1, 138, 2), (1, 0, 1, 138, 3), (1, 0, 1, 138, 4),
-- Juego 139
(1, 1, 1, 139, 1), (1, 1, 1, 139, 2), (1, 0, 1, 139, 3), (1, 0, 1, 139, 4),
-- Juego 140
(1, 1, 1, 140, 1), (1, 1, 1, 140, 2), (1, 0, 1, 140, 3), (1, 0, 1, 140, 4),
-- Juego 141
(1, 1, 1, 141, 1), (1, 1, 1, 141, 2), (1, 0, 1, 141, 3), (1, 0, 1, 141, 4),
-- Juego 142
(1, 1, 1, 142, 1), (1, 1, 1, 142, 2), (1, 0, 1, 142, 3), (1, 0, 1, 142, 4),
-- Juego 143
(1, 1, 1, 143, 1), (1, 1, 1, 143, 2), (1, 0, 1, 143, 3), (1, 0, 1, 143, 4),
-- Juego 144
(1, 1, 1, 144, 1), (1, 1, 1, 144, 2), (1, 0, 1, 144, 3), (1, 0, 1, 144, 4),
-- Juego 145
(1, 1, 1, 145, 1), (1, 1, 1, 145, 2), (1, 0, 1, 145, 3), (1, 0, 1, 145, 4),
-- Juego 146
(1, 1, 1, 146, 1), (1, 1, 1, 146, 2), (1, 0, 1, 146, 3), (1, 0, 1, 146, 4),
-- Juego 147
(1, 1, 1, 147, 1), (1, 1, 1, 147, 2), (1, 0, 1, 147, 3), (1, 0, 1, 147, 4),
-- Juego 148
(1, 1, 1, 148, 1), (1, 1, 1, 148, 2), (1, 0, 1, 148, 3), (1, 0, 1, 148, 4),
-- Juego 149
(1, 1, 1, 149, 1), (1, 1, 1, 149, 2), (1, 0, 1, 149, 3), (1, 0, 1, 149, 4),
-- Juego 150
(1, 1, 1, 150, 1), (1, 1, 1, 150, 2), (1, 0, 1, 150, 3), (1, 0, 1, 150, 4),
-- Juego 151
(1, 1, 1, 151, 1), (1, 1, 1, 151, 2), (1, 0, 1, 151, 3), (1, 0, 1, 151, 4),
-- Juego 152
(1, 1, 1, 152, 1), (1, 1, 1, 152, 2), (1, 0, 1, 152, 3), (1, 0, 1, 152, 4),
-- Juego 153
(1, 1, 1, 153, 1), (1, 1, 1, 153, 2), (1, 0, 1, 153, 3), (1, 0, 1, 153, 4),
-- Juego 154
(1, 1, 1, 154, 1), (1, 1, 1, 154, 2), (1, 0, 1, 154, 3), (1, 0, 1, 154, 4),
-- Juego 155
(1, 1, 1, 155, 1), (1, 1, 1, 155, 2), (1, 0, 1, 155, 3), (1, 0, 1, 155, 4),
-- Juego 156
(1, 1, 1, 156, 1), (1, 1, 1, 156, 2), (1, 0, 1, 156, 3), (1, 0, 1, 156, 4),
-- Juego 157
(1, 1, 1, 157, 1), (1, 1, 1, 157, 2), (1, 0, 1, 157, 3), (1, 0, 1, 157, 4),
-- Juego 158
(1, 1, 1, 158, 1), (1, 1, 1, 158, 2), (1, 0, 1, 158, 3), (1, 0, 1, 158, 4),
-- Juego 159
(1, 1, 1, 159, 1), (1, 1, 1, 159, 2), (1, 0, 1, 159, 3), (1, 0, 1, 159, 4),
-- Juego 160
(1, 1, 1, 160, 1), (1, 1, 1, 160, 2), (1, 0, 1, 160, 3), (1, 0, 1, 160, 4),
-- Juego 161
(1, 1, 1, 161, 1), (1, 1, 1, 161, 2), (1, 0, 1, 161, 3), (1, 0, 1, 161, 4),
-- Juego 162
(1, 1, 1, 162, 1), (1, 1, 1, 162, 2), (1, 0, 1, 162, 3), (1, 0, 1, 162, 4),
-- Juego 163
(1, 1, 1, 163, 1), (1, 1, 1, 163, 2), (1, 0, 1, 163, 3), (1, 0, 1, 163, 4),
-- Juego 164
(1, 1, 1, 164, 1), (1, 1, 1, 164, 2), (1, 0, 1, 164, 3), (1, 0, 1, 164, 4),
-- Juego 165
(1, 1, 1, 165, 1), (1, 1, 1, 165, 2), (1, 0, 1, 165, 3), (1, 0, 1, 165, 4),
-- Juego 166
(1, 1, 1, 166, 1), (1, 1, 1, 166, 2), (1, 0, 1, 166, 3), (1, 0, 1, 166, 4),
-- Juego 167
(1, 1, 1, 167, 1), (1, 1, 1, 167, 2), (1, 0, 1, 167, 3), (1, 0, 1, 167, 4),
-- Juego 168
(1, 1, 1, 168, 1), (1, 1, 1, 168, 2), (1, 0, 1, 168, 3), (1, 0, 1, 168, 4),
-- Juego 169
(1, 1, 1, 169, 1), (1, 1, 1, 169, 2), (1, 0, 1, 169, 3), (1, 0, 1, 169, 4),
-- Juego 170
(1, 1, 1, 170, 1), (1, 1, 1, 170, 2), (1, 0, 1, 170, 3), (1, 0, 1, 170, 4),
-- Juego 171
(1, 1, 1, 171, 1), (1, 1, 1, 171, 2), (1, 0, 1, 171, 3), (1, 0, 1, 171, 4),
-- Juego 172
(1, 1, 1, 172, 1), (1, 1, 1, 172, 2), (1, 0, 1, 172, 3), (1, 0, 1, 172, 4),
-- Juego 173
(1, 1, 1, 173, 1), (1, 1, 1, 173, 2), (1, 0, 1, 173, 3), (1, 0, 1, 173, 4),
-- Juego 174
(1, 1, 1, 174, 1), (1, 1, 1, 174, 2), (1, 0, 1, 174, 3), (1, 0, 1, 174, 4),
-- Juego 175
(1, 1, 1, 175, 1), (1, 1, 1, 175, 2), (1, 0, 1, 175, 3), (1, 0, 1, 175, 4),
-- Juego 176
(1, 1, 1, 176, 1), (1, 1, 1, 176, 2), (1, 0, 1, 176, 3), (1, 0, 1, 176, 4),
-- Juego 177
(1, 1, 1, 177, 1), (1, 1, 1, 177, 2), (1, 0, 1, 177, 3), (1, 0, 1, 177, 4),
-- Juego 178
(1, 1, 1, 178, 1), (1, 1, 1, 178, 2), (1, 0, 1, 178, 3), (1, 0, 1, 178, 4),
-- Juego 179
(1, 1, 1, 179, 1), (1, 1, 1, 179, 2), (1, 0, 1, 179, 3), (1, 0, 1, 179, 4),
-- Juego 180
(1, 1, 1, 180, 1), (1, 1, 1, 180, 2), (1, 0, 1, 180, 3), (1, 0, 1, 180, 4),
-- Juego 181
(1, 1, 1, 181, 1), (1, 1, 1, 181, 2), (1, 0, 1, 181, 3), (1, 0, 1, 181, 4),
-- Juego 182
(1, 1, 1, 182, 1), (1, 1, 1, 182, 2), (1, 0, 1, 182, 3), (1, 0, 1, 182, 4),
-- Juego 183
(1, 1, 1, 183, 1), (1, 1, 1, 183, 2), (1, 0, 1, 183, 3), (1, 0, 1, 183, 4),
-- Juego 184
(1, 1, 1, 184, 1), (1, 1, 1, 184, 2), (1, 0, 1, 184, 3), (1, 0, 1, 184, 4),
-- Juego 185
(1, 1, 1, 185, 1), (1, 1, 1, 185, 2), (1, 0, 1, 185, 3), (1, 0, 1, 185, 4),
-- Juego 186
(1, 1, 1, 186, 1), (1, 1, 1, 186, 2), (1, 0, 1, 186, 3), (1, 0, 1, 186, 4),
-- Juego 187
(1, 1, 1, 187, 1), (1, 1, 1, 187, 2), (1, 0, 1, 187, 3), (1, 0, 1, 187, 4),
-- Juego 188
(1, 1, 1, 188, 1), (1, 1, 1, 188, 2), (1, 0, 1, 188, 3), (1, 0, 1, 188, 4),
-- Juego 189
(1, 1, 1, 189, 1), (1, 1, 1, 189, 2), (1, 0, 1, 189, 3), (1, 0, 1, 189, 4),
-- Juego 190
(1, 1, 1, 190, 1), (1, 1, 1, 190, 2), (1, 0, 1, 190, 3), (1, 0, 1, 190, 4),
-- Juego 191
(1, 1, 1, 191, 1), (1, 1, 1, 191, 2), (1, 0, 1, 191, 3), (1, 0, 1, 191, 4),
-- Juego 192
(1, 1, 1, 192, 1), (1, 1, 1, 192, 2), (1, 0, 1, 192, 3), (1, 0, 1, 192, 4),
-- Juego 193
(1, 1, 1, 193, 1), (1, 1, 1, 193, 2), (1, 0, 1, 193, 3), (1, 0, 1, 193, 4),
-- Juego 194
(1, 1, 1, 194, 1), (1, 1, 1, 194, 2), (1, 0, 1, 194, 3), (1, 0, 1, 194, 4),
-- Juego 195
(1, 1, 1, 195, 1), (1, 1, 1, 195, 2), (1, 0, 1, 195, 3), (1, 0, 1, 195, 4),
-- Juego 196
(1, 1, 1, 196, 1), (1, 1, 1, 196, 2), (1, 0, 1, 196, 3), (1, 0, 1, 196, 4),
-- Juego 197
(1, 1, 1, 197, 1), (1, 1, 1, 197, 2), (1, 0, 1, 197, 3), (1, 0, 1, 197, 4),
-- Juego 198
(1, 1, 1, 198, 1), (1, 1, 1, 198, 2), (1, 0, 1, 198, 3), (1, 0, 1, 198, 4),
-- Juego 199
(1, 1, 1, 199, 1), (1, 1, 1, 199, 2), (1, 0, 1, 199, 3), (1, 0, 1, 199, 4),
-- Juego 200
(1, 1, 1, 200, 1), (1, 1, 1, 200, 2), (1, 0, 1, 200, 3), (1, 0, 1, 200, 4),
-- Juego 201
(1, 1, 1, 201, 1), (1, 1, 1, 201, 2), (1, 0, 1, 201, 3), (1, 0, 1, 201, 4),
-- Juego 202
(1, 1, 1, 202, 1), (1, 1, 1, 202, 2), (1, 0, 1, 202, 3), (1, 0, 1, 202, 4),
-- Juego 203
(1, 1, 1, 203, 1), (1, 1, 1, 203, 2), (1, 0, 1, 203, 3), (1, 0, 1, 203, 4),
-- Juego 204
(1, 1, 1, 204, 1), (1, 1, 1, 204, 2), (1, 0, 1, 204, 3), (1, 0, 1, 204, 4),
-- Juego 205
(1, 1, 1, 205, 1), (1, 1, 1, 205, 2), (1, 0, 1, 205, 3), (1, 0, 1, 205, 4),
-- Juego 206
(1, 1, 1, 206, 1), (1, 1, 1, 206, 2), (1, 0, 1, 206, 3), (1, 0, 1, 206, 4),
-- Juego 207
(1, 1, 1, 207, 1), (1, 1, 1, 207, 2), (1, 0, 1, 207, 3), (1, 0, 1, 207, 4),
-- Juego 208
(1, 1, 1, 208, 1), (1, 1, 1, 208, 2), (1, 0, 1, 208, 3), (1, 0, 1, 208, 4),
-- Juego 209
(1, 1, 1, 209, 1), (1, 1, 1, 209, 2), (1, 0, 1, 209, 3), (1, 0, 1, 209, 4),
-- Juego 210
(1, 1, 1, 210, 1), (1, 1, 1, 210, 2), (1, 0, 1, 210, 3), (1, 0, 1, 210, 4);

/* ----------------------------- 2. Logro ------------------------------ */

 INSERT INTO Logro (ID_Logro, Nombre_Logro, Descripcion_Logro, Es_Secreto, ID_Juego_Base_FK) VALUES
(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 1),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 1),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 1),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 1),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 1),


(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 3),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 3),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 3),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 3),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 3),


(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 5),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 5),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 5),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 5),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 5),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 6),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 6),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 6),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 6),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 6),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 7),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 7),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 7),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 7),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 7),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 8),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 8),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 8),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 8),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 8),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 9),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 9),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 9),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 9),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 9),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 10),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 10),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 10),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 10),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 10),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 11),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 11),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 11),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 11),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 11),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 12),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 12),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 12),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 12),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 12),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 13),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 13),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 13),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 13),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 13),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 14),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 14),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 14),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 14),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 14),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 15),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 15),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 15),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 15),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 15),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 16),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 16),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 16),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 16),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 16),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 17),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 17),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 17),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 17),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 17),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 18),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 18),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 18),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 18),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 18),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 19),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 19),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 19),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 19),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 19),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 20),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 20),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 20),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 20),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 20),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 21),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 21),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 21),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 21),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 21),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 22),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 22),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 22),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 22),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 22),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 23),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 23),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 23),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 23),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 23),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 24),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 24),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 24),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 24),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 24),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 25),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 25),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 25),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 25),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 25),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 26),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 26),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 26),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 26),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 26),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 27),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 27),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 27),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 27),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 27),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 28),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 28),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 28),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 28),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 28),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 29),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 29),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 29),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 29),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 29),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 30),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 30),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 30),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 30),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 30),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 31),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 31),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 31),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 31),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 31),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 32),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 32),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 32),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 32),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 32),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 33),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 33),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 33),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 33),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 33),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 34),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 34),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 34),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 34),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 34),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 35),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 35),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 35),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 35),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 35),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 36),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 36),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 36),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 36),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 36),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 37),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 37),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 37),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 37),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 37),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 38),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 38),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 38),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 38),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 38),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 39),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 39),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 39),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 39),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 39),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 40),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 40),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 40),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 40),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 40),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 41),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 41),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 41),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 41),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 41),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 42),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 42),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 42),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 42),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 42),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 43),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 43),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 43),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 43),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 43),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 44),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 44),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 44),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 44),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 44),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 45),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 45),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 45),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 45),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 45),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 46),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 46),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 46),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 46),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 46),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 47),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 47),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 47),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 47),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 47),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 48),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 48),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 48),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 48),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 48),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 49),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 49),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 49),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 49),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 49),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 50),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 50),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 50),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 50),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 50),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 51),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 51),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 51),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 51),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 51),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 52),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 52),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 52),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 52),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 52),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 53),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 53),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 53),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 53),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 53),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 54),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 54),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 54),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 54),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 54),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 55),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 55),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 55),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 55),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 55),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 56),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 56),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 56),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 56),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 56),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 57),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 57),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 57),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 57),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 57),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 58),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 58),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 58),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 58),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 58),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 59),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 59),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 59),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 59),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 59),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 60),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 60),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 60),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 60),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 60),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 61),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 61),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 61),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 61),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 61),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 62),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 62),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 62),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 62),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 62),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 63),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 63),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 63),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 63),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 63),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 64),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 64),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 64),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 64),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 64),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 65),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 65),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 65),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 65),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 65),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 66),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 66),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 66),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 66),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 66),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 67),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 67),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 67),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 67),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 67),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 68),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 68),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 68),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 68),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 68),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 69),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 69),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 69),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 69),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 69),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 70),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 70),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 70),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 70),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 70),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 71),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 71),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 71),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 71),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 71),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 72),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 72),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 72),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 72),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 72),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 73),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 73),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 73),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 73),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 73),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 74),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 74),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 74),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 74),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 74),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 75),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 75),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 75),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 75),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 75),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 76),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 76),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 76),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 76),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 76),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 77),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 77),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 77),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 77),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 77),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 78),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 78),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 78),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 78),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 78),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 79),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 79),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 79),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 79),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 79),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 80),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 80),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 80),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 80),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 80),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 81),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 81),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 81),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 81),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 81),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 82),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 82),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 82),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 82),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 82),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 83),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 83),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 83),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 83),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 83),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 84),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 84),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 84),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 84),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 84),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 85),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 85),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 85),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 85),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 85),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 86),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 86),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 86),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 86),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 86),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 87),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 87),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 87),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 87),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 87),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 88),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 88),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 88),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 88),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 88),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 89),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 89),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 89),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 89),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 89),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 90),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 90),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 90),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 90),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 90),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 91),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 91),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 91),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 91),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 91),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 92),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 92),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 92),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 92),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 92),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 93),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 93),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 93),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 93),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 93),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 94),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 94),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 94),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 94),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 94),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 95),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 95),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 95),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 95),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 95),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 96),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 96),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 96),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 96),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 96),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 97),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 97),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 97),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 97),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 97),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 98),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 98),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 98),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 98),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 98),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 99),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 99),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 99),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 99),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 99),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 100),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 100),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 100),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 100),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 100),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 101),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 101),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 101),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 101),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 101),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 102),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 102),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 102),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 102),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 102),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 103),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 103),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 103),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 103),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 103),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 104),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 104),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 104),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 104),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 104),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 105),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 105),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 105),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 105),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 105),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 106),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 106),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 106),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 106),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 106),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 107),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 107),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 107),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 107),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 107),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 108),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 108),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 108),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 108),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 108),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 109),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 109),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 109),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 109),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 109),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 110),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 110),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 110),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 110),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 110),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 111),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 111),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 111),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 111),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 111),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 112),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 112),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 112),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 112),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 112),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 113),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 113),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 113),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 113),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 113),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 114),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 114),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 114),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 114),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 114),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 115),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 115),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 115),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 115),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 115),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 116),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 116),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 116),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 116),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 116),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 117),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 117),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 117),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 117),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 117),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 118),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 118),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 118),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 118),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 118),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 119),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 119),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 119),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 119),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 119),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 120),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 120),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 120),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 120),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 120),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 121),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 121),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 121),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 121),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 121),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 122),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 122),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 122),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 122),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 122),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 123),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 123),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 123),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 123),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 123),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 124),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 124),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 124),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 124),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 124),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 125),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 125),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 125),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 125),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 125),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 126),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 126),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 126),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 126),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 126),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 127),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 127),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 127),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 127),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 127),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 128),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 128),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 128),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 128),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 128),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 129),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 129),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 129),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 129),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 129),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 130),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 130),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 130),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 130),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 130),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 131),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 131),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 131),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 131),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 131),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 132),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 132),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 132),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 132),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 132),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 133),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 133),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 133),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 133),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 133),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 134),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 134),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 134),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 134),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 134),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 135),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 135),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 135),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 135),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 135),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 136),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 136),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 136),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 136),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 136),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 137),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 137),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 137),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 137),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 137),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 138),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 138),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 138),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 138),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 138),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 139),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 139),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 139),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 139),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 139),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 140),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 140),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 140),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 140),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 140),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 141),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 141),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 141),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 141),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 141),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 142),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 142),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 142),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 142),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 142),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 143),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 143),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 143),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 143),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 143),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 144),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 144),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 144),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 144),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 144),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 145),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 145),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 145),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 145),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 145),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 146),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 146),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 146),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 146),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 146),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 147),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 147),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 147),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 147),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 147),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 148),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 148),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 148),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 148),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 148),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 149),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 149),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 149),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 149),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 149),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 150),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 150),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 150),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 150),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 150),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 151),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 151),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 151),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 151),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 151),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 152),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 152),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 152),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 152),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 152),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 153),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 153),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 153),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 153),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 153),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 154),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 154),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 154),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 154),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 154),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 155),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 155),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 155),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 155),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 155),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 156),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 156),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 156),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 156),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 156),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 157),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 157),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 157),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 157),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 157),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 158),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 158),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 158),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 158),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 158),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 159),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 159),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 159),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 159),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 159),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 160),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 160),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 160),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 160),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 160),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 161),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 161),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 161),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 161),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 161),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 162),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 162),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 162),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 162),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 162),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 163),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 163),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 163),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 163),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 163),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 164),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 164),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 164),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 164),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 164),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 165),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 165),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 165),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 165),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 165),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 166),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 166),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 166),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 166),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 166),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 167),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 167),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 167),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 167),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 167),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 168),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 168),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 168),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 168),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 168),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 169),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 169),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 169),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 169),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 169),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 170),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 170),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 170),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 170),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 170),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 171),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 171),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 171),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 171),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 171),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 172),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 172),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 172),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 172),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 172),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 173),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 173),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 173),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 173),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 173),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 174),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 174),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 174),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 174),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 174),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 175),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 175),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 175),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 175),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 175),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 176),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 176),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 176),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 176),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 176),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 177),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 177),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 177),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 177),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 177),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 178),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 178),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 178),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 178),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 178),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 179),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 179),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 179),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 179),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 179),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 180),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 180),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 180),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 180),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 180),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 181),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 181),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 181),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 181),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 181),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 182),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 182),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 182),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 182),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 182),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 183),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 183),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 183),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 183),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 183),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 184),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 184),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 184),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 184),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 184),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 185),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 185),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 185),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 185),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 185),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 186),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 186),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 186),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 186),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 186),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 187),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 187),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 187),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 187),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 187),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 188),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 188),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 188),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 188),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 188),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 189),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 189),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 189),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 189),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 189),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 190),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 190),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 190),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 190),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 190),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 191),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 191),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 191),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 191),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 191),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 192),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 192),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 192),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 192),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 192),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 193),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 193),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 193),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 193),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 193),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 194),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 194),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 194),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 194),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 194),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 195),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 195),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 195),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 195),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 195);

 INSERT INTO Logro (ID_Logro, Nombre_Logro, Descripcion_Logro, Es_Secreto, ID_Juego_Base_FK) VALUES
(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 196),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 196),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 196),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 196),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 196),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 197),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 197),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 197),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 197),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 197),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 198),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 198),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 198),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 198),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 198),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 199),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 199),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 199),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 199),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 199),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 200),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 200),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 200),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 200),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 200),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 201),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 201),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 201),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 201),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 201),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 202),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 202),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 202),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 202),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 202),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 203),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 203),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 203),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 203),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 203),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 204),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 204),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 204),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 204),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 204),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 205),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 205),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 205),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 205),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 205),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 206),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 206),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 206),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 206),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 206),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 207),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 207),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 207),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 207),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 207),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 208),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 208),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 208),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 208),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 208),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 209),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 209),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 209),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 209),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 209),

(1, 'Primeros Pasos', 'Inicia tu aventura en el mundo digital.', 0, 210),
(2, 'Superviviente', 'Supera el primer gran desafío del juego.', 0, 210),
(3, 'Coleccionista', 'Encuentra elementos ocultos en el mapa.', 0, 210),
(4, 'Maestro Táctico', 'Derrota a un enemigo elite sin recibir daño.', 1, 210),
(5, 'Leyenda', 'Completa la campaña principal.', 1, 210),

(1, 'Primer Pedido', 'Completa el primer nivel.', 0, 309),
(2, 'Cocinero Estrella', 'Consigue 3 estrellas en 5 niveles.', 0, 309),
(3, 'Sin Quemaduras', 'Termina un nivel sin que se queme nada.', 1, 309),
(4, 'Maestro de la Cuchilla', 'Corta 100 ingredientes.', 0, 309),
(5, 'Rey de la Cocina', 'Completa el juego al 100%.', 0, 309);

/* -------------------------- Galeria_Multimedia -------------------------- */
 INSERT INTO Galeria_Multimedia (URL_Archivo, Tipo_Archivo, ID_Producto_FK) VALUES
-- Juego 1
('https://cdn.conesteam.com/media/game1_ss1.jpg', 'Foto', 1),
('https://cdn.conesteam.com/media/game1_trailer.mp4', 'Video', 1),
-- Juego 2
('https://cdn.conesteam.com/media/game2_ss1.jpg', 'Foto', 2),
('https://cdn.conesteam.com/media/game2_trailer.mp4', 'Video', 2),
-- Juego 3
('https://cdn.conesteam.com/media/game3_ss1.jpg', 'Foto', 3),
('https://cdn.conesteam.com/media/game3_trailer.mp4', 'Video', 3),
-- Juego 4
('https://cdn.conesteam.com/media/game4_ss1.jpg', 'Foto', 4),
('https://cdn.conesteam.com/media/game4_trailer.mp4', 'Video', 4),
-- Juego 5
('https://cdn.conesteam.com/media/game5_ss1.jpg', 'Foto', 5),
('https://cdn.conesteam.com/media/game5_trailer.mp4', 'Video', 5),
-- Juego 6
('https://cdn.conesteam.com/media/game6_ss1.jpg', 'Foto', 6),
('https://cdn.conesteam.com/media/game6_trailer.mp4', 'Video', 6),
-- Juego 7
('https://cdn.conesteam.com/media/game7_ss1.jpg', 'Foto', 7),
('https://cdn.conesteam.com/media/game7_trailer.mp4', 'Video', 7),
-- Juego 8
('https://cdn.conesteam.com/media/game8_ss1.jpg', 'Foto', 8),
('https://cdn.conesteam.com/media/game8_trailer.mp4', 'Video', 8),
-- Juego 9
('https://cdn.conesteam.com/media/game9_ss1.jpg', 'Foto', 9),
('https://cdn.conesteam.com/media/game9_trailer.mp4', 'Video', 9),
-- Juego 10
('https://cdn.conesteam.com/media/game10_ss1.jpg', 'Foto', 10),
('https://cdn.conesteam.com/media/game10_trailer.mp4', 'Video', 10),
-- Juego 11
('https://cdn.conesteam.com/media/game11_ss1.jpg', 'Foto', 11),
('https://cdn.conesteam.com/media/game11_trailer.mp4', 'Video', 11),
-- Juego 12
('https://cdn.conesteam.com/media/game12_ss1.jpg', 'Foto', 12),
('https://cdn.conesteam.com/media/game12_trailer.mp4', 'Video', 12),
-- Juego 13
('https://cdn.conesteam.com/media/game13_ss1.jpg', 'Foto', 13),
('https://cdn.conesteam.com/media/game13_trailer.mp4', 'Video', 13),
-- Juego 14
('https://cdn.conesteam.com/media/game14_ss1.jpg', 'Foto', 14),
('https://cdn.conesteam.com/media/game14_trailer.mp4', 'Video', 14),
-- Juego 15
('https://cdn.conesteam.com/media/game15_ss1.jpg', 'Foto', 15),
('https://cdn.conesteam.com/media/game15_trailer.mp4', 'Video', 15),
-- Juego 16
('https://cdn.conesteam.com/media/game16_ss1.jpg', 'Foto', 16),
('https://cdn.conesteam.com/media/game16_trailer.mp4', 'Video', 16),
-- Juego 17
('https://cdn.conesteam.com/media/game17_ss1.jpg', 'Foto', 17),
('https://cdn.conesteam.com/media/game17_trailer.mp4', 'Video', 17),
-- Juego 18
('https://cdn.conesteam.com/media/game18_ss1.jpg', 'Foto', 18),
('https://cdn.conesteam.com/media/game18_trailer.mp4', 'Video', 18),
-- Juego 19
('https://cdn.conesteam.com/media/game19_ss1.jpg', 'Foto', 19),
('https://cdn.conesteam.com/media/game19_trailer.mp4', 'Video', 19),
-- Juego 20
('https://cdn.conesteam.com/media/game20_ss1.jpg', 'Foto', 20),
('https://cdn.conesteam.com/media/game20_trailer.mp4', 'Video', 20),
-- Juego 21
('https://cdn.conesteam.com/media/game21_ss1.jpg', 'Foto', 21),
('https://cdn.conesteam.com/media/game21_trailer.mp4', 'Video', 21),
-- Juego 22
('https://cdn.conesteam.com/media/game22_ss1.jpg', 'Foto', 22),
('https://cdn.conesteam.com/media/game22_trailer.mp4', 'Video', 22),
-- Juego 23
('https://cdn.conesteam.com/media/game23_ss1.jpg', 'Foto', 23),
('https://cdn.conesteam.com/media/game23_trailer.mp4', 'Video', 23),
-- Juego 24
('https://cdn.conesteam.com/media/game24_ss1.jpg', 'Foto', 24),
('https://cdn.conesteam.com/media/game24_trailer.mp4', 'Video', 24),
-- Juego 25
('https://cdn.conesteam.com/media/game25_ss1.jpg', 'Foto', 25),
('https://cdn.conesteam.com/media/game25_trailer.mp4', 'Video', 25),
-- Juego 26
('https://cdn.conesteam.com/media/game26_ss1.jpg', 'Foto', 26),
('https://cdn.conesteam.com/media/game26_trailer.mp4', 'Video', 26),
-- Juego 27
('https://cdn.conesteam.com/media/game27_ss1.jpg', 'Foto', 27),
('https://cdn.conesteam.com/media/game27_trailer.mp4', 'Video', 27),
-- Juego 28
('https://cdn.conesteam.com/media/game28_ss1.jpg', 'Foto', 28),
('https://cdn.conesteam.com/media/game28_trailer.mp4', 'Video', 28),
-- Juego 29
('https://cdn.conesteam.com/media/game29_ss1.jpg', 'Foto', 29),
('https://cdn.conesteam.com/media/game29_trailer.mp4', 'Video', 29),
-- Juego 30
('https://cdn.conesteam.com/media/game30_ss1.jpg', 'Foto', 30),
('https://cdn.conesteam.com/media/game30_trailer.mp4', 'Video', 30),
-- Juego 31
('https://cdn.conesteam.com/media/game31_ss1.jpg', 'Foto', 31),
('https://cdn.conesteam.com/media/game31_trailer.mp4', 'Video', 31),
-- Juego 32
('https://cdn.conesteam.com/media/game32_ss1.jpg', 'Foto', 32),
('https://cdn.conesteam.com/media/game32_trailer.mp4', 'Video', 32),
-- Juego 33
('https://cdn.conesteam.com/media/game33_ss1.jpg', 'Foto', 33),
('https://cdn.conesteam.com/media/game33_trailer.mp4', 'Video', 33),
-- Juego 34
('https://cdn.conesteam.com/media/game34_ss1.jpg', 'Foto', 34),
('https://cdn.conesteam.com/media/game34_trailer.mp4', 'Video', 34),
-- Juego 35
('https://cdn.conesteam.com/media/game35_ss1.jpg', 'Foto', 35),
('https://cdn.conesteam.com/media/game35_trailer.mp4', 'Video', 35),
-- Juego 36
('https://cdn.conesteam.com/media/game36_ss1.jpg', 'Foto', 36),
('https://cdn.conesteam.com/media/game36_trailer.mp4', 'Video', 36),
-- Juego 37
('https://cdn.conesteam.com/media/game37_ss1.jpg', 'Foto', 37),
('https://cdn.conesteam.com/media/game37_trailer.mp4', 'Video', 37),
-- Juego 38
('https://cdn.conesteam.com/media/game38_ss1.jpg', 'Foto', 38),
('https://cdn.conesteam.com/media/game38_trailer.mp4', 'Video', 38),
-- Juego 39
('https://cdn.conesteam.com/media/game39_ss1.jpg', 'Foto', 39),
('https://cdn.conesteam.com/media/game39_trailer.mp4', 'Video', 39),
-- Juego 40
('https://cdn.conesteam.com/media/game40_ss1.jpg', 'Foto', 40),
('https://cdn.conesteam.com/media/game40_trailer.mp4', 'Video', 40),
-- Juego 41
('https://cdn.conesteam.com/media/game41_ss1.jpg', 'Foto', 41),
('https://cdn.conesteam.com/media/game41_trailer.mp4', 'Video', 41),
-- Juego 42
('https://cdn.conesteam.com/media/game42_ss1.jpg', 'Foto', 42),
('https://cdn.conesteam.com/media/game42_trailer.mp4', 'Video', 42),
-- Juego 43
('https://cdn.conesteam.com/media/game43_ss1.jpg', 'Foto', 43),
('https://cdn.conesteam.com/media/game43_trailer.mp4', 'Video', 43),
-- Juego 44
('https://cdn.conesteam.com/media/game44_ss1.jpg', 'Foto', 44),
('https://cdn.conesteam.com/media/game44_trailer.mp4', 'Video', 44),
-- Juego 45
('https://cdn.conesteam.com/media/game45_ss1.jpg', 'Foto', 45),
('https://cdn.conesteam.com/media/game45_trailer.mp4', 'Video', 45),
-- Juego 46
('https://cdn.conesteam.com/media/game46_ss1.jpg', 'Foto', 46),
('https://cdn.conesteam.com/media/game46_trailer.mp4', 'Video', 46),
-- Juego 47
('https://cdn.conesteam.com/media/game47_ss1.jpg', 'Foto', 47),
('https://cdn.conesteam.com/media/game47_trailer.mp4', 'Video', 47),
-- Juego 48
('https://cdn.conesteam.com/media/game48_ss1.jpg', 'Foto', 48),
('https://cdn.conesteam.com/media/game48_trailer.mp4', 'Video', 48),
-- Juego 49
('https://cdn.conesteam.com/media/game49_ss1.jpg', 'Foto', 49),
('https://cdn.conesteam.com/media/game49_trailer.mp4', 'Video', 49),
-- Juego 50
('https://cdn.conesteam.com/media/game50_ss1.jpg', 'Foto', 50),
('https://cdn.conesteam.com/media/game50_trailer.mp4', 'Video', 50),
-- Juego 51
('https://cdn.conesteam.com/media/game51_ss1.jpg', 'Foto', 51),
('https://cdn.conesteam.com/media/game51_trailer.mp4', 'Video', 51),
-- Juego 52
('https://cdn.conesteam.com/media/game52_ss1.jpg', 'Foto', 52),
('https://cdn.conesteam.com/media/game52_trailer.mp4', 'Video', 52),
-- Juego 53
('https://cdn.conesteam.com/media/game53_ss1.jpg', 'Foto', 53),
('https://cdn.conesteam.com/media/game53_trailer.mp4', 'Video', 53),
-- Juego 54
('https://cdn.conesteam.com/media/game54_ss1.jpg', 'Foto', 54),
('https://cdn.conesteam.com/media/game54_trailer.mp4', 'Video', 54),
-- Juego 55
('https://cdn.conesteam.com/media/game55_ss1.jpg', 'Foto', 55),
('https://cdn.conesteam.com/media/game55_trailer.mp4', 'Video', 55),
-- Juego 56
('https://cdn.conesteam.com/media/game56_ss1.jpg', 'Foto', 56),
('https://cdn.conesteam.com/media/game56_trailer.mp4', 'Video', 56),
-- Juego 57
('https://cdn.conesteam.com/media/game57_ss1.jpg', 'Foto', 57),
('https://cdn.conesteam.com/media/game57_trailer.mp4', 'Video', 57),
-- Juego 58
('https://cdn.conesteam.com/media/game58_ss1.jpg', 'Foto', 58),
('https://cdn.conesteam.com/media/game58_trailer.mp4', 'Video', 58),
-- Juego 59
('https://cdn.conesteam.com/media/game59_ss1.jpg', 'Foto', 59),
('https://cdn.conesteam.com/media/game59_trailer.mp4', 'Video', 59),
-- Juego 60
('https://cdn.conesteam.com/media/game60_ss1.jpg', 'Foto', 60),
('https://cdn.conesteam.com/media/game60_trailer.mp4', 'Video', 60),
-- Juego 61
('https://cdn.conesteam.com/media/game61_ss1.jpg', 'Foto', 61),
('https://cdn.conesteam.com/media/game61_trailer.mp4', 'Video', 61),
-- Juego 62
('https://cdn.conesteam.com/media/game62_ss1.jpg', 'Foto', 62),
('https://cdn.conesteam.com/media/game62_trailer.mp4', 'Video', 62),
-- Juego 63
('https://cdn.conesteam.com/media/game63_ss1.jpg', 'Foto', 63),
('https://cdn.conesteam.com/media/game63_trailer.mp4', 'Video', 63),
-- Juego 64
('https://cdn.conesteam.com/media/game64_ss1.jpg', 'Foto', 64),
('https://cdn.conesteam.com/media/game64_trailer.mp4', 'Video', 64),
-- Juego 65
('https://cdn.conesteam.com/media/game65_ss1.jpg', 'Foto', 65),
('https://cdn.conesteam.com/media/game65_trailer.mp4', 'Video', 65),
-- Juego 66
('https://cdn.conesteam.com/media/game66_ss1.jpg', 'Foto', 66),
('https://cdn.conesteam.com/media/game66_trailer.mp4', 'Video', 66),
-- Juego 67
('https://cdn.conesteam.com/media/game67_ss1.jpg', 'Foto', 67),
('https://cdn.conesteam.com/media/game67_trailer.mp4', 'Video', 67),
-- Juego 68
('https://cdn.conesteam.com/media/game68_ss1.jpg', 'Foto', 68),
('https://cdn.conesteam.com/media/game68_trailer.mp4', 'Video', 68),
-- Juego 69
('https://cdn.conesteam.com/media/game69_ss1.jpg', 'Foto', 69),
('https://cdn.conesteam.com/media/game69_trailer.mp4', 'Video', 69),
-- Juego 70
('https://cdn.conesteam.com/media/game70_ss1.jpg', 'Foto', 70),
('https://cdn.conesteam.com/media/game70_trailer.mp4', 'Video', 70),
-- Juego 71
('https://cdn.conesteam.com/media/game71_ss1.jpg', 'Foto', 71),
('https://cdn.conesteam.com/media/game71_trailer.mp4', 'Video', 71),
-- Juego 72
('https://cdn.conesteam.com/media/game72_ss1.jpg', 'Foto', 72),
('https://cdn.conesteam.com/media/game72_trailer.mp4', 'Video', 72),
-- Juego 73
('https://cdn.conesteam.com/media/game73_ss1.jpg', 'Foto', 73),
('https://cdn.conesteam.com/media/game73_trailer.mp4', 'Video', 73),
-- Juego 74
('https://cdn.conesteam.com/media/game74_ss1.jpg', 'Foto', 74),
('https://cdn.conesteam.com/media/game74_trailer.mp4', 'Video', 74),
-- Juego 75
('https://cdn.conesteam.com/media/game75_ss1.jpg', 'Foto', 75),
('https://cdn.conesteam.com/media/game75_trailer.mp4', 'Video', 75),
-- Juego 76
('https://cdn.conesteam.com/media/game76_ss1.jpg', 'Foto', 76),
('https://cdn.conesteam.com/media/game76_trailer.mp4', 'Video', 76),
-- Juego 77
('https://cdn.conesteam.com/media/game77_ss1.jpg', 'Foto', 77),
('https://cdn.conesteam.com/media/game77_trailer.mp4', 'Video', 77),
-- Juego 78
('https://cdn.conesteam.com/media/game78_ss1.jpg', 'Foto', 78),
('https://cdn.conesteam.com/media/game78_trailer.mp4', 'Video', 78),
-- Juego 79
('https://cdn.conesteam.com/media/game79_ss1.jpg', 'Foto', 79),
('https://cdn.conesteam.com/media/game79_trailer.mp4', 'Video', 79),
-- Juego 80
('https://cdn.conesteam.com/media/game80_ss1.jpg', 'Foto', 80),
('https://cdn.conesteam.com/media/game80_trailer.mp4', 'Video', 80),
-- Juego 81
('https://cdn.conesteam.com/media/game81_ss1.jpg', 'Foto', 81),
('https://cdn.conesteam.com/media/game81_trailer.mp4', 'Video', 81),
-- Juego 82
('https://cdn.conesteam.com/media/game82_ss1.jpg', 'Foto', 82),
('https://cdn.conesteam.com/media/game82_trailer.mp4', 'Video', 82),
-- Juego 83
('https://cdn.conesteam.com/media/game83_ss1.jpg', 'Foto', 83),
('https://cdn.conesteam.com/media/game83_trailer.mp4', 'Video', 83),
-- Juego 84
('https://cdn.conesteam.com/media/game84_ss1.jpg', 'Foto', 84),
('https://cdn.conesteam.com/media/game84_trailer.mp4', 'Video', 84),
-- Juego 85
('https://cdn.conesteam.com/media/game85_ss1.jpg', 'Foto', 85),
('https://cdn.conesteam.com/media/game85_trailer.mp4', 'Video', 85),
-- Juego 86
('https://cdn.conesteam.com/media/game86_ss1.jpg', 'Foto', 86),
('https://cdn.conesteam.com/media/game86_trailer.mp4', 'Video', 86),
-- Juego 87
('https://cdn.conesteam.com/media/game87_ss1.jpg', 'Foto', 87),
('https://cdn.conesteam.com/media/game87_trailer.mp4', 'Video', 87),
-- Juego 88
('https://cdn.conesteam.com/media/game88_ss1.jpg', 'Foto', 88),
('https://cdn.conesteam.com/media/game88_trailer.mp4', 'Video', 88),
-- Juego 89
('https://cdn.conesteam.com/media/game89_ss1.jpg', 'Foto', 89),
('https://cdn.conesteam.com/media/game89_trailer.mp4', 'Video', 89),
-- Juego 90
('https://cdn.conesteam.com/media/game90_ss1.jpg', 'Foto', 90),
('https://cdn.conesteam.com/media/game90_trailer.mp4', 'Video', 90),
-- Juego 91
('https://cdn.conesteam.com/media/game91_ss1.jpg', 'Foto', 91),
('https://cdn.conesteam.com/media/game91_trailer.mp4', 'Video', 91),
-- Juego 92
('https://cdn.conesteam.com/media/game92_ss1.jpg', 'Foto', 92),
('https://cdn.conesteam.com/media/game92_trailer.mp4', 'Video', 92),
-- Juego 93
('https://cdn.conesteam.com/media/game93_ss1.jpg', 'Foto', 93),
('https://cdn.conesteam.com/media/game93_trailer.mp4', 'Video', 93),
-- Juego 94
('https://cdn.conesteam.com/media/game94_ss1.jpg', 'Foto', 94),
('https://cdn.conesteam.com/media/game94_trailer.mp4', 'Video', 94),
-- Juego 95
('https://cdn.conesteam.com/media/game95_ss1.jpg', 'Foto', 95),
('https://cdn.conesteam.com/media/game95_trailer.mp4', 'Video', 95),
-- Juego 96
('https://cdn.conesteam.com/media/game96_ss1.jpg', 'Foto', 96),
('https://cdn.conesteam.com/media/game96_trailer.mp4', 'Video', 96),
-- Juego 97
('https://cdn.conesteam.com/media/game97_ss1.jpg', 'Foto', 97),
('https://cdn.conesteam.com/media/game97_trailer.mp4', 'Video', 97),
-- Juego 98
('https://cdn.conesteam.com/media/game98_ss1.jpg', 'Foto', 98),
('https://cdn.conesteam.com/media/game98_trailer.mp4', 'Video', 98),
-- Juego 99
('https://cdn.conesteam.com/media/game99_ss1.jpg', 'Foto', 99),
('https://cdn.conesteam.com/media/game99_trailer.mp4', 'Video', 99),
-- Juego 100
('https://cdn.conesteam.com/media/game100_ss1.jpg', 'Foto', 100),
('https://cdn.conesteam.com/media/game100_trailer.mp4', 'Video', 100),
-- Juego 101
('https://cdn.conesteam.com/media/game101_ss1.jpg', 'Foto', 101),
('https://cdn.conesteam.com/media/game101_trailer.mp4', 'Video', 101),
-- Juego 102
('https://cdn.conesteam.com/media/game102_ss1.jpg', 'Foto', 102),
('https://cdn.conesteam.com/media/game102_trailer.mp4', 'Video', 102),
-- Juego 103
('https://cdn.conesteam.com/media/game103_ss1.jpg', 'Foto', 103),
('https://cdn.conesteam.com/media/game103_trailer.mp4', 'Video', 103),
-- Juego 104
('https://cdn.conesteam.com/media/game104_ss1.jpg', 'Foto', 104),
('https://cdn.conesteam.com/media/game104_trailer.mp4', 'Video', 104),
-- Juego 105
('https://cdn.conesteam.com/media/game105_ss1.jpg', 'Foto', 105),
('https://cdn.conesteam.com/media/game105_trailer.mp4', 'Video', 105),
-- Juego 106
('https://cdn.conesteam.com/media/game106_ss1.jpg', 'Foto', 106),
('https://cdn.conesteam.com/media/game106_trailer.mp4', 'Video', 106),
-- Juego 107
('https://cdn.conesteam.com/media/game107_ss1.jpg', 'Foto', 107),
('https://cdn.conesteam.com/media/game107_trailer.mp4', 'Video', 107),
-- Juego 108
('https://cdn.conesteam.com/media/game108_ss1.jpg', 'Foto', 108),
('https://cdn.conesteam.com/media/game108_trailer.mp4', 'Video', 108),
-- Juego 109
('https://cdn.conesteam.com/media/game109_ss1.jpg', 'Foto', 109),
('https://cdn.conesteam.com/media/game109_trailer.mp4', 'Video', 109),
-- Juego 110
('https://cdn.conesteam.com/media/game110_ss1.jpg', 'Foto', 110),
('https://cdn.conesteam.com/media/game110_trailer.mp4', 'Video', 110),
-- Juego 111
('https://cdn.conesteam.com/media/game111_ss1.jpg', 'Foto', 111),
('https://cdn.conesteam.com/media/game111_trailer.mp4', 'Video', 111),
-- Juego 112
('https://cdn.conesteam.com/media/game112_ss1.jpg', 'Foto', 112),
('https://cdn.conesteam.com/media/game112_trailer.mp4', 'Video', 112),
-- Juego 113
('https://cdn.conesteam.com/media/game113_ss1.jpg', 'Foto', 113),
('https://cdn.conesteam.com/media/game113_trailer.mp4', 'Video', 113),
-- Juego 114
('https://cdn.conesteam.com/media/game114_ss1.jpg', 'Foto', 114),
('https://cdn.conesteam.com/media/game114_trailer.mp4', 'Video', 114),
-- Juego 115
('https://cdn.conesteam.com/media/game115_ss1.jpg', 'Foto', 115),
('https://cdn.conesteam.com/media/game115_trailer.mp4', 'Video', 115),
-- Juego 116
('https://cdn.conesteam.com/media/game116_ss1.jpg', 'Foto', 116),
('https://cdn.conesteam.com/media/game116_trailer.mp4', 'Video', 116),
-- Juego 117
('https://cdn.conesteam.com/media/game117_ss1.jpg', 'Foto', 117),
('https://cdn.conesteam.com/media/game117_trailer.mp4', 'Video', 117),
-- Juego 118
('https://cdn.conesteam.com/media/game118_ss1.jpg', 'Foto', 118),
('https://cdn.conesteam.com/media/game118_trailer.mp4', 'Video', 118),
-- Juego 119
('https://cdn.conesteam.com/media/game119_ss1.jpg', 'Foto', 119),
('https://cdn.conesteam.com/media/game119_trailer.mp4', 'Video', 119),
-- Juego 120
('https://cdn.conesteam.com/media/game120_ss1.jpg', 'Foto', 120),
('https://cdn.conesteam.com/media/game120_trailer.mp4', 'Video', 120),
-- Juego 121
('https://cdn.conesteam.com/media/game121_ss1.jpg', 'Foto', 121),
('https://cdn.conesteam.com/media/game121_trailer.mp4', 'Video', 121),
-- Juego 122
('https://cdn.conesteam.com/media/game122_ss1.jpg', 'Foto', 122),
('https://cdn.conesteam.com/media/game122_trailer.mp4', 'Video', 122),
-- Juego 123
('https://cdn.conesteam.com/media/game123_ss1.jpg', 'Foto', 123),
('https://cdn.conesteam.com/media/game123_trailer.mp4', 'Video', 123),
-- Juego 124
('https://cdn.conesteam.com/media/game124_ss1.jpg', 'Foto', 124),
('https://cdn.conesteam.com/media/game124_trailer.mp4', 'Video', 124),
-- Juego 125
('https://cdn.conesteam.com/media/game125_ss1.jpg', 'Foto', 125),
('https://cdn.conesteam.com/media/game125_trailer.mp4', 'Video', 125),
-- Juego 126
('https://cdn.conesteam.com/media/game126_ss1.jpg', 'Foto', 126),
('https://cdn.conesteam.com/media/game126_trailer.mp4', 'Video', 126),
-- Juego 169
('https://cdn.conesteam.com/media/game169_ss1.jpg', 'Foto', 169),
('https://cdn.conesteam.com/media/game169_trailer.mp4', 'Video', 169),
-- Juego 170
('https://cdn.conesteam.com/media/game170_ss1.jpg', 'Foto', 170),
('https://cdn.conesteam.com/media/game170_trailer.mp4', 'Video', 170),
-- Juego 171
('https://cdn.conesteam.com/media/game171_ss1.jpg', 'Foto', 171),
('https://cdn.conesteam.com/media/game171_trailer.mp4', 'Video', 171),
-- Juego 172
('https://cdn.conesteam.com/media/game172_ss1.jpg', 'Foto', 172),
('https://cdn.conesteam.com/media/game172_trailer.mp4', 'Video', 172),
-- Juego 173
('https://cdn.conesteam.com/media/game173_ss1.jpg', 'Foto', 173),
('https://cdn.conesteam.com/media/game173_trailer.mp4', 'Video', 173),
-- Juego 174
('https://cdn.conesteam.com/media/game174_ss1.jpg', 'Foto', 174),
('https://cdn.conesteam.com/media/game174_trailer.mp4', 'Video', 174),
-- Juego 175
('https://cdn.conesteam.com/media/game175_ss1.jpg', 'Foto', 175),
('https://cdn.conesteam.com/media/game175_trailer.mp4', 'Video', 175),
-- Juego 176
('https://cdn.conesteam.com/media/game176_ss1.jpg', 'Foto', 176),
('https://cdn.conesteam.com/media/game176_trailer.mp4', 'Video', 176),
-- Juego 177
('https://cdn.conesteam.com/media/game177_ss1.jpg', 'Foto', 177),
('https://cdn.conesteam.com/media/game177_trailer.mp4', 'Video', 177),
-- Juego 178
('https://cdn.conesteam.com/media/game178_ss1.jpg', 'Foto', 178),
('https://cdn.conesteam.com/media/game178_trailer.mp4', 'Video', 178),
-- Juego 179
('https://cdn.conesteam.com/media/game179_ss1.jpg', 'Foto', 179),
('https://cdn.conesteam.com/media/game179_trailer.mp4', 'Video', 179),
-- Juego 180
('https://cdn.conesteam.com/media/game180_ss1.jpg', 'Foto', 180),
('https://cdn.conesteam.com/media/game180_trailer.mp4', 'Video', 180),
-- Juego 181
('https://cdn.conesteam.com/media/game181_ss1.jpg', 'Foto', 181),
('https://cdn.conesteam.com/media/game181_trailer.mp4', 'Video', 181),
-- Juego 182
('https://cdn.conesteam.com/media/game182_ss1.jpg', 'Foto', 182),
('https://cdn.conesteam.com/media/game182_trailer.mp4', 'Video', 182),
-- Juego 183
('https://cdn.conesteam.com/media/game183_ss1.jpg', 'Foto', 183),
('https://cdn.conesteam.com/media/game183_trailer.mp4', 'Video', 183),
-- Juego 184
('https://cdn.conesteam.com/media/game184_ss1.jpg', 'Foto', 184),
('https://cdn.conesteam.com/media/game184_trailer.mp4', 'Video', 184),
-- Juego 185
('https://cdn.conesteam.com/media/game185_ss1.jpg', 'Foto', 185),
('https://cdn.conesteam.com/media/game185_trailer.mp4', 'Video', 185),
-- Juego 186
('https://cdn.conesteam.com/media/game186_ss1.jpg', 'Foto', 186),
('https://cdn.conesteam.com/media/game186_trailer.mp4', 'Video', 186),
-- Juego 187
('https://cdn.conesteam.com/media/game187_ss1.jpg', 'Foto', 187),
('https://cdn.conesteam.com/media/game187_trailer.mp4', 'Video', 187),
-- Juego 188
('https://cdn.conesteam.com/media/game188_ss1.jpg', 'Foto', 188),
('https://cdn.conesteam.com/media/game188_trailer.mp4', 'Video', 188),
-- Juego 189
('https://cdn.conesteam.com/media/game189_ss1.jpg', 'Foto', 189),
('https://cdn.conesteam.com/media/game189_trailer.mp4', 'Video', 189),
-- Juego 190
('https://cdn.conesteam.com/media/game190_ss1.jpg', 'Foto', 190),
('https://cdn.conesteam.com/media/game190_trailer.mp4', 'Video', 190),
-- Juego 191
('https://cdn.conesteam.com/media/game191_ss1.jpg', 'Foto', 191),
('https://cdn.conesteam.com/media/game191_trailer.mp4', 'Video', 191),
-- Juego 192
('https://cdn.conesteam.com/media/game192_ss1.jpg', 'Foto', 192),
('https://cdn.conesteam.com/media/game192_trailer.mp4', 'Video', 192),
-- Juego 193
('https://cdn.conesteam.com/media/game193_ss1.jpg', 'Foto', 193),
('https://cdn.conesteam.com/media/game193_trailer.mp4', 'Video', 193),
-- Juego 194
('https://cdn.conesteam.com/media/game194_ss1.jpg', 'Foto', 194),
('https://cdn.conesteam.com/media/game194_trailer.mp4', 'Video', 194),
-- Juego 195
('https://cdn.conesteam.com/media/game195_ss1.jpg', 'Foto', 195),
('https://cdn.conesteam.com/media/game195_trailer.mp4', 'Video', 195),
-- Juego 196
('https://cdn.conesteam.com/media/game196_ss1.jpg', 'Foto', 196),
('https://cdn.conesteam.com/media/game196_trailer.mp4', 'Video', 196),
-- Juego 197
('https://cdn.conesteam.com/media/game197_ss1.jpg', 'Foto', 197),
('https://cdn.conesteam.com/media/game197_trailer.mp4', 'Video', 197),
-- Juego 198
('https://cdn.conesteam.com/media/game198_ss1.jpg', 'Foto', 198),
('https://cdn.conesteam.com/media/game198_trailer.mp4', 'Video', 198),
-- Juego 199
('https://cdn.conesteam.com/media/game199_ss1.jpg', 'Foto', 199),
('https://cdn.conesteam.com/media/game199_trailer.mp4', 'Video', 199),
-- Juego 200
('https://cdn.conesteam.com/media/game200_ss1.jpg', 'Foto', 200),
('https://cdn.conesteam.com/media/game200_trailer.mp4', 'Video', 200),
-- Juego 201
('https://cdn.conesteam.com/media/game201_ss1.jpg', 'Foto', 201),
('https://cdn.conesteam.com/media/game201_trailer.mp4', 'Video', 201),
-- Juego 202
('https://cdn.conesteam.com/media/game202_ss1.jpg', 'Foto', 202),
('https://cdn.conesteam.com/media/game202_trailer.mp4', 'Video', 202),
-- Juego 203
('https://cdn.conesteam.com/media/game203_ss1.jpg', 'Foto', 203),
('https://cdn.conesteam.com/media/game203_trailer.mp4', 'Video', 203),
-- Juego 204
('https://cdn.conesteam.com/media/game204_ss1.jpg', 'Foto', 204),
('https://cdn.conesteam.com/media/game204_trailer.mp4', 'Video', 204),
-- Juego 205
('https://cdn.conesteam.com/media/game205_ss1.jpg', 'Foto', 205),
('https://cdn.conesteam.com/media/game205_trailer.mp4', 'Video', 205),
-- Juego 206
('https://cdn.conesteam.com/media/game206_ss1.jpg', 'Foto', 206),
('https://cdn.conesteam.com/media/game206_trailer.mp4', 'Video', 206),
-- Juego 207
('https://cdn.conesteam.com/media/game207_ss1.jpg', 'Foto', 207),
('https://cdn.conesteam.com/media/game207_trailer.mp4', 'Video', 207),
-- Juego 208
('https://cdn.conesteam.com/media/game208_ss1.jpg', 'Foto', 208),
('https://cdn.conesteam.com/media/game208_trailer.mp4', 'Video', 208),
-- Juego 209
('https://cdn.conesteam.com/media/game209_ss1.jpg', 'Foto', 209),
('https://cdn.conesteam.com/media/game209_trailer.mp4', 'Video', 209),
-- Juego 210
('https://cdn.conesteam.com/media/game210_ss1.jpg', 'Foto', 210),
('https://cdn.conesteam.com/media/game210_trailer.mp4', 'Video', 210);

 /* =====================================================================
   BLOQUE 5: Etiquetas de Comunidad, Producto-Etiqueta y Juego-Categoría
   Proyecto Fase 2 · ConeSTeam · Semestre I-2026
   ===================================================================== */

/* ----------------------- 1. Etiqueta_Comunidad ----------------------- */

SET IDENTITY_INSERT Etiqueta_Comunidad ON;

INSERT INTO Etiqueta_Comunidad (ID_Etiqueta, Nombre_Etiqueta) VALUES

(1, 'Acción'), (2, 'Aventura'), (3, 'RPG'), (4, 'Estrategia'), (5, 'Simulación'),
(6, 'Deportes'), (7, 'Carreras'), (8, 'Indie'), (9, 'Casual'), (10, 'Multijugador'),
(11, 'Jugador Individual'), (12, 'Cooperativo'), (13, 'Mundo Abierto'), (14, 'Supervivencia'), (15, 'Terror'),
(16, 'FPS'), (17, 'Plataformas'), (18, 'Puzzles'), (19, 'Novela Visual'), (20, 'Rogue-like'),
(21, 'Rogue-lite'), (22, 'Hack and Slash'), (23, 'Metroidvania'), (24, 'Sigilo'), (25, 'Táctico'),
(26, 'Por Turnos'), (27, 'Lógica'), (28, 'Ciencia Ficción'), (29, 'Fantasía'), (30, 'Cyberpunk'),
(31, 'Post-apocalíptico'), (32, 'Estrategia en Tiempo Real'), (33, 'MOBA'), (34, 'Battle Royale'), (35, 'Lucha'),
(36, 'Ritmo'), (37, 'Sandbox'), (38, 'Crafting'), (39, 'Pixel Art'), (40, '2D'),
(41, '3D'), (42, 'Anime'), (43, 'Comedia'), (44, 'Oscuro'), (45, 'Rico en Historia'),
(46, 'Gran Estrategia'), (47, 'Tower Defense'), (48, 'VR'), (49, 'PvP'), (50, 'PvE');


SET IDENTITY_INSERT Etiqueta_Comunidad OFF;



/* ----------------------- 2. Producto_Etiqueta ------------------------ */

 INSERT INTO Producto_Etiqueta (ID_Producto_FK, ID_Etiqueta_FK, Cantidad_Votos) VALUES
-- Juego 1 (Usa etiquetas 1 a 10)
(1, 1, 1250), (1, 2, 850), (1, 3, 1500), (1, 4, 620), (1, 5, 430),
(1, 6, 310), (1, 7, 290), (1, 8, 2100), (1, 9, 780), (1, 10, 1850),

-- Juego 2 (Usa etiquetas 11 a 20)
(2, 11, 2400), (2, 12, 920), (2, 13, 3100), (2, 14, 1150), (2, 15, 840),
(2, 16, 1750), (2, 17, 950), (2, 18, 410), (2, 19, 320), (2, 20, 1280),

-- Juego 3 (Usa etiquetas 21 a 30)
(3, 21, 1100), (3, 22, 1450), (3, 23, 980), (3, 24, 760), (3, 25, 530),
(3, 26, 610), (3, 27, 390), (3, 28, 2200), (3, 29, 1890), (3, 30, 2600),

-- Juego 4 (Usa etiquetas 31 a 40)
(4, 31, 1340), (4, 32, 720), (4, 33, 910), (4, 34, 1650), (4, 35, 870),
(4, 36, 450), (4, 37, 1980), (4, 38, 2150), (4, 39, 1420), (4, 40, 1120),

-- Juego 5 (Usa etiquetas 41 a 50)
(5, 41, 1670), (5, 42, 1230), (5, 43, 540), (5, 44, 890), (5, 45, 2450),
(5, 46, 610), (5, 47, 480), (5, 48, 750), (5, 49, 1340), (5, 50, 1560),

(310, 1, 500),   -- Acción (500 votos)
(310, 3, 150),   -- RPG (150 votos)
(310, 8, 300),   -- Indie (300 votos)

-- Juego 311 (Mystic Farming)
(311, 5, 200),   -- Simulación (200 votos)
(311, 9, 400),   -- Casual (400 votos)
(311, 12, 100),  -- Cooperativo (100 votos)

-- Juego 312 (Galactic Strategy)
(312, 4, 600),   -- Estrategia (600 votos)
(312, 28, 250),  -- Ciencia Ficción (250 votos)

-- Juego 313 (Shadow Ninja 2D)
(313, 8, 800),   -- Indie (800 votos - Sumará 300 del juego 310 = 1100 total)
(313, 17, 300),  -- Plataformas (300 votos)
(313, 39, 450),  -- Pixel Art (450 votos)
(313, 24, 100),  -- Sigilo (100 votos)

-- Juego 314 (Zombie Survival Coop)
(314, 15, 1900),  -- Terror (900 votos)
(314, 12, 700),  -- Cooperativo (700 votos - Sumará 100 del juego 311 = 800 total)
(314, 1, 400),   -- Acción (400 votos - Sumará 500 del juego 310 = 900 total)
(314, 14, 350),  -- Supervivencia (350 votos)
(314, 10, 200);  -- Multijugador (200 votos)


/* ------------------------- 3. Juego_Categoria ------------------------- */
-- Vincula los juegos base con las categorías de la tabla Categoria_Oficial
INSERT INTO Juego_Categoria (ID_Producto_FK, ID_Categoria_FK) VALUES
  (11, 3), (12, 1), (12, 2), (12, 10),(13, 1), (13, 5), (14, 1), 
 (14, 3), (15, 2), (15, 9), (15, 14), (16, 8), (16, 9), (16, 10), 
 (17, 8), (17, 9), (17, 17), (20, 4), (3,4), (4,5);
 
 


/* ----------------------------- 1. Usuario ---------------------------- */

SET IDENTITY_INSERT Usuario ON;

INSERT INTO Usuario (Id_Usuario, Nickname, Correo, Contrasena_Hash, Fecha_Nacimiento, Fecha_Registro, Pais_Residencia, Estado_Cuenta) VALUES
(1, 'ShadowGamer99', 'shadow99@gmail.com', 'e3b0c44298fc1c149afbf4c8996fb924', '1998-05-12', '2024-10-15', 'Venezuela', 'Activa'),
(2, 'PixelQueen', 'pqueen@yahoo.com', 'cf83e1357eefb8bdf1542850d66d8007', '2001-08-23', '2024-10-20', 'México', 'Activa'),
(3, 'CyberSamurai', 'samurai_c@outlook.com', '8d969eef6ecad3c29a3a629280e686cf', '1995-02-14', '2024-11-02', 'España', 'Activa'),
(4, 'DragonSlayer_VE', 'ds_ve@gmail.com', '2fd4e1c67a2d28fced849ee1bb76e739', '1999-11-30', '2024-11-10', 'Venezuela', 'Suspendida'),
(5, 'NeonValkyrie', 'neon_val@gmail.com', '6b86b273ff34fce19d6b804eff5a3f57', '2002-04-05', '2024-12-01', 'Argentina', 'Activa'),
(6, 'RoxasBlade', 'roxas99@gmail.com', 'd4735e3a265e16eee03f59718b9b5d03', '1997-07-19', '2024-12-14', 'Colombia', 'Activa'),
(7, 'AeroSniper', 'aero_sniper@outlook.com', '4e07408562bedb8b60ce05c1decfe3ad', '1996-03-22', '2025-01-05', 'Chile', 'Activa'),
(8, 'LunaStarlight', 'luna_star@gmail.com', '1d645372d83296a1fb0d31c69992d536', '2000-09-08', '2025-01-18', 'México', 'Baneada'),
(9, 'KratosFan01', 'kratos01@gmail.com', '648600843a13a0db02eb74f32a76f255', '1994-12-03', '2025-02-02', 'España', 'Activa'),
(10, 'ZeldaLover', 'zelda_fan@yahoo.com', '03ac674216f3e15c761ee1a5e255f067', '2003-06-25', '2025-02-15', 'Perú', 'Activa'),
(11, 'TurboRacer', 'turbo_r@gmail.com', '9d4e1e23bd5b727046a9e3b4b7db57bd', '1991-01-11', '2025-03-01', 'Venezuela', 'Activa'),
(12, 'GhostRider_X', 'ghost_x@gmail.com', '5d41402abc4b2a76b9719d911017c592', '1998-10-31', '2025-03-12', 'Argentina', 'Activa'),
(13, 'NightOwl', 'night_owl@outlook.com', '7d793037a0760186574b0282f2f435e7', '2000-05-17', '2025-03-25', 'México', 'Activa'),
(14, 'BitMaster', 'bit_master@gmail.com', 'c78864d4715b74c2e276f57008cb904a', '1993-08-14', '2025-04-04', 'Colombia', 'Suspendida'),
(15, 'StarGazer', 'stargazer@gmail.com', 'c1dfd96eea8cc2b62785275bca3acac2', '2004-01-20', '2025-04-19', 'España', 'Activa'),
(16, 'VortexPlayer', 'vortex@yahoo.com', '321bc355866164f9bf51c6c641655073', '1995-07-09', '2025-05-02', 'Chile', 'Activa'),
(17, 'EchoChaser', 'echo_c@gmail.com', 'b16abdb90738e4a9e9e62312d8a4369e', '1999-12-12', '2025-05-14', 'Venezuela', 'Activa'),
(18, 'FireStorm', 'fire_storm@gmail.com', '57a44ce2491a27e770334863bc434771', '1997-04-28', '2025-05-30', 'Uruguay', 'Activa'),
(19, 'IceQueen', 'ice_q@outlook.com', 'a1f795995574cc474f85e1975b9f71ee', '2001-02-15', '2025-06-10', 'México', 'Baneada'),
(20, 'ShadowRunner', 'shadow_run@gmail.com', '4297f44b13955a35284b2416ffc6f851', '1996-06-07', '2025-06-22', 'Argentina', 'Activa'),
(21, 'DarkWizard', 'dark_wiz@gmail.com', '9b74c9897bac770ffc029102a200c5de', '1992-09-18', '2025-07-05', 'España', 'Activa'),
(22, 'MegaByte', 'mega_byte@gmail.com', '2c624232cdd221771294dfbb310aca00', '1998-03-11', '2025-07-18', 'Colombia', 'Activa'),
(23, 'AlphaWolf', 'alpha_w@yahoo.com', '19202307cc7313098544c4eac6442654', '2002-11-04', '2025-07-29', 'Venezuela', 'Activa'),
(24, 'BetaTester', 'beta_test@gmail.com', '07775c97711f5fae800c14c57717be67', '1995-10-21', '2025-08-11', 'Perú', 'Activa'),
(25, 'OmegaPlayer', 'omega_p@outlook.com', '8e6bfa4728f313175217dd108170c1d6', '1990-12-25', '2025-08-20', 'Chile', 'Suspendida'),
(26, 'QuantumGamer', 'quantum_g@gmail.com', '64d8a27d21b79414e54887968c9911e2', '2000-04-14', '2025-09-02', 'México', 'Activa'),
(27, 'SolarFlare', 'solar_flare@gmail.com', '9b671a5e182281a4a499f57ef518c772', '1997-01-30', '2025-09-15', 'España', 'Activa'),
(28, 'LunarEclipse', 'lunar_e@yahoo.com', '827ccb0eea8a706c4c34a16891f84e7b', '1994-06-19', '2025-09-28', 'Argentina', 'Activa'),
(29, 'TitanGaming', 'titan_g@gmail.com', 'e16e6d7a48d8db9c8114f487e4128509', '1996-08-05', '2025-10-06', 'Venezuela', 'Activa'),
(30, 'VenomStrike', 'venom_s@outlook.com', '3b592750fa4d173426e792c30081dcf3', '1999-03-27', '2025-10-18', 'Colombia', 'Activa'),
(31, 'ApexPredator', 'apex_p@gmail.com', '6512bd43d9caa6e02c990b0a82652dca', '2001-07-12', '2025-10-30', 'México', 'Activa'),
(32, 'StormBringer', 'storm_b@gmail.com', 'c20ad4d76fe97759aa27a0c99bff6710', '1993-02-28', '2025-11-08', 'España', 'Baneada'),
(33, 'FrostByte', 'frost_byte@yahoo.com', 'c51ce410c124a10e0db5e4b97fc2af39', '1998-11-15', '2025-11-20', 'Chile', 'Activa'),
(34, 'BlazeRunner', 'blaze_r@gmail.com', '4a7d1ed414474e4033ac29ccb8653d9b', '2002-05-09', '2025-12-02', 'Venezuela', 'Activa'),
(35, 'ShadowStalker', 'shadow_s@outlook.com', '126778f237f378037b01b6580f4f9f75', '1995-09-01', '2025-12-14', 'Argentina', 'Activa'),
(36, 'PixelArtist', 'pixel_art@gmail.com', '283538676f4e13554ee59039dbbc2f40', '1997-12-18', '2025-12-28', 'Colombia', 'Activa'),
(37, 'NetRunner', 'net_runner@gmail.com', '8f81014e7a8e2cb9d750058b7654a93a', '2000-03-04', '2026-01-08', 'México', 'Activa'),
(38, 'RetroGamer', 'retro_g@yahoo.com', 'd9d4f495e875a2e075a1a4a6e1b9770f', '1991-06-22', '2026-01-19', 'España', 'Activa'),
(39, 'SpeedDemon', 'speed_d@gmail.com', '37693cfc748049e45d87b8c7d8b9bdda', '1996-10-08', '2026-02-01', 'Perú', 'Suspendida'),
(40, 'DarkKnight', 'dark_k@outlook.com', 'e317d7b56a3138b3c990234a5d852899', '1994-04-16', '2026-02-12', 'Venezuela', 'Activa'),
(41, 'IronHeart', 'iron_h@gmail.com', '98f13708210194c475687be6106a3b84', '1999-01-27', '2026-02-24', 'Argentina', 'Activa'),
(42, 'SteelGamer', 'steel_g@gmail.com', '3c59dc048e8850243be807a85c723069', '1998-08-19', '2026-03-05', 'México', 'Activa'),
(43, 'SilverFox', 'silver_f@yahoo.com', 'd67d8ab4f4c10bf22aa353e27879133c', '1992-05-11', '2026-03-18', 'España', 'Activa'),
(44, 'GoldPlayer', 'gold_p@gmail.com', '7a049d5a9fae30a501a35112f458e0a3', '2003-10-02', '2026-03-29', 'Colombia', 'Activa'),
(45, 'BronzeHero', 'bronze_h@outlook.com', '263bce650e68ab4e3b22e9c17456306e', '1995-12-07', '2026-04-07', 'Chile', 'Activa'),
(46, 'DiamondUser', 'diamond_u@gmail.com', 'd95679752134a2d4eb64b7e5ec2ab284', '2001-07-24', '2026-04-19', 'Venezuela', 'Baneada'),
(47, 'RubyPlayer', 'ruby_p@gmail.com', 'f718499c1c8cefba7300320fef968e1b', '1997-02-13', '2026-05-02', 'Argentina', 'Activa'),
(48, 'SapphireGamer', 'sapphire_g@yahoo.com', '2d2b591b29a8a70c06a392b498f39564', '1990-09-30', '2026-05-14', 'México', 'Activa'),
(49, 'EmeraldUser', 'emerald_u@gmail.com', '48cf7a57a6277259020a599187315b88', '1998-04-05', '2026-05-26', 'España', 'Activa'),
(50, 'TopazHero', 'topaz_h@gmail.com', '20d18d42399222cf648a8679f2e46f04', '1994-11-21', '2026-06-05', 'Uruguay', 'Activa'),
(51, 'AetherKnight', 'aether_k@gmail.com', '5f4dcc3b5aa765d61d8327deb882cf99', '1995-03-14', '2026-06-15', 'Venezuela', 'Activa'),
(52, 'SolarisMage', 'solaris_m@yahoo.com', '019202307cc7313098544c4eac644265', '1998-07-22', '2026-06-25', 'México', 'Activa'),
(53, 'VoidWalker', 'void_w@outlook.com', '321bc355866164f9bf51c6c641655073', '2001-11-03', '2026-07-04', 'España', 'Activa'),
(54, 'CrimsonBlade', 'crimson_b@gmail.com', 'b16abdb90738e4a9e9e62312d8a4369e', '1993-01-19', '2026-07-14', 'Argentina', 'Suspendida'),
(55, 'AzureDragon', 'azure_d@gmail.com', '57a44ce2491a27e770334863bc434771', '1999-09-08', '2026-07-22', 'Colombia', 'Activa'),
(56, 'NeonSpecter', 'neon_s@yahoo.com', 'a1f795995574cc474f85e1975b9f71ee', '2002-05-27', '2026-08-01', 'Chile', 'Activa'),
(57, 'QuantumRogue', 'quantum_r@gmail.com', '4297f44b13955a35284b2416ffc6f851', '1996-12-11', '2026-08-10', 'Venezuela', 'Activa'),
(58, 'StellarGamer', 'stellar_g@outlook.com', '9b74c9897bac770ffc029102a200c5de', '1997-04-16', '2026-08-18', 'Perú', 'Baneada'),
(59, 'CyberPunk99', 'cyber_p99@gmail.com', '2c624232cdd221771294dfbb310aca00', '2000-08-02', '2026-08-25', 'México', 'Activa'),
(60, 'PixelHero', 'pixel_h@gmail.com', '19202307cc7313098544c4eac6442654', '1994-06-30', '2026-09-02', 'España', 'Activa'),
(61, 'EchoSniper', 'echo_s@yahoo.com', '07775c97711f5fae800c14c57717be67', '1998-02-14', '2026-09-09', 'Argentina', 'Activa'),
(62, 'VortexMage', 'vortex_m@gmail.com', '8e6bfa4728f313175217dd108170c1d6', '1991-10-25', '2026-09-15', 'Venezuela', 'Activa'),
(63, 'TitanShield', 'titan_s@outlook.com', '64d8a27d21b79414e54887968c9911e2', '1995-12-08', '2026-09-20', 'Colombia', 'Activa'),
(64, 'ShadowPhantom', 'shadow_p@gmail.com', '9b671a5e182281a4a499f57ef518c772', '2003-01-17', '2026-09-25', 'Chile', 'Suspendida'),
(65, 'BlazeWarrior', 'blaze_w@yahoo.com', '827ccb0eea8a706c4c34a16891f84e7b', '1992-07-04', '2026-09-28', 'México', 'Activa'),
(66, 'FrostMage', 'frost_m@gmail.com', 'e16e6d7a48d8db9c8114f487e4128509', '1997-05-21', '2026-10-01', 'España', 'Activa'),
(67, 'StormRider', 'storm_r@outlook.com', '3b592750fa4d173426e792c30081dcf3', '2000-09-13', '2026-10-03', 'Venezuela', 'Activa'),
(68, 'VenomLord', 'venom_l@gmail.com', '6512bd43d9caa6e02c990b0a82652dca', '1996-03-29', '2026-10-05', 'Argentina', 'Activa'),
(69, 'ApexHunter', 'apex_h@yahoo.com', 'c20ad4d76fe97759aa27a0c99bff6710', '1999-11-18', '2026-10-07', 'Colombia', 'Baneada'),
(70, 'AlphaGamer', 'alpha_g@gmail.com', 'c51ce410c124a10e0db5e4b97fc2af39', '1994-08-06', '2026-10-08', 'Perú', 'Activa'),
(71, 'OmegaWarrior', 'omega_w@outlook.com', '4a7d1ed414474e4033ac29ccb8653d9b', '2001-04-12', '2026-10-09', 'Chile', 'Activa'),
(72, 'BetaGamer', 'beta_g@gmail.com', '126778f237f378037b01b6580f4f9f75', '1993-02-20', '2026-10-10', 'México', 'Activa'),
(73, 'DeltaForce', 'delta_f@yahoo.com', '283538676f4e13554ee59039dbbc2f40', '1998-06-15', '2026-10-11', 'España', 'Activa'),
(74, 'GammaRay', 'gamma_r@gmail.com', '8f81014e7a8e2cb9d750058b7654a93a', '1990-10-01', '2026-10-12', 'Venezuela', 'Activa'),
(75, 'ZetaPlayer', 'zeta_p@outlook.com', 'd9d4f495e875a2e075a1a4a6e1b9770f', '1997-12-05', '2026-10-13', 'Argentina', 'Activa'),
(76, 'SigmaKnight', 'sigma_k@gmail.com', '37693cfc748049e45d87b8c7d8b9bdda', '1995-04-22', '2026-10-14', 'Colombia', 'Suspendida'),
(77, 'KappaGamer', 'kappa_g@yahoo.com', 'e317d7b56a3138b3c990234a5d852899', '2002-08-19', '2026-10-14', 'Chile', 'Activa'),
(78, 'LambdaMage', 'lambda_m@gmail.com', '98f13708210194c475687be6106a3b84', '1996-01-30', '2026-10-15', 'México', 'Activa'),
(79, 'ThetaRogue', 'theta_r@outlook.com', '3c59dc048e8850243be807a85c723069', '1999-07-11', '2026-10-15', 'España', 'Activa'),
(80, 'RhoSniper', 'rho_s@gmail.com', 'd67d8ab4f4c10bf22aa353e27879133c', '1993-11-24', '2026-10-15', 'Venezuela', 'Activa'),
(81, 'PixelKnight', 'pixel_k@yahoo.com', '7a049d5a9fae30a501a35112f458e0a3', '1998-03-08', '2026-10-16', 'Argentina', 'Activa'),
(82, 'CyberMage', 'cyber_m@gmail.com', '263bce650e68ab4e3b22e9c17456306e', '2000-09-16', '2026-10-16', 'Colombia', 'Baneada'),
(83, 'NetWarrior', 'net_w@outlook.com', 'd95679752134a2d4eb64b7e5ec2ab284', '1994-05-02', '2026-10-16', 'Perú', 'Activa'),
(84, 'BitRogue', 'bit_r@gmail.com', 'f718499c1c8cefba7300320fef968e1b', '1997-10-21', '2026-10-16', 'Chile', 'Activa'),
(85, 'ByteSniper', 'byte_s@yahoo.com', '2d2b591b29a8a70c06a392b498f39564', '1991-12-14', '2026-10-16', 'México', 'Activa'),
(86, 'DataKnight', 'data_k@gmail.com', '48cf7a57a6277259020a599187315b88', '1996-02-27', '2026-10-16', 'España', 'Activa'),
(87, 'CodeMage', 'code_m@outlook.com', '20d18d42399222cf648a8679f2e46f04', '1999-08-09', '2026-10-16', 'Venezuela', 'Activa'),
(88, 'ScriptRogue', 'script_r@gmail.com', '5f4dcc3b5aa765d61d8327deb882cf99', '1995-06-18', '2026-10-16', 'Argentina', 'Activa'),
(89, 'QuerySniper', 'query_s@yahoo.com', '019202307cc7313098544c4eac644265', '2001-01-04', '2026-10-16', 'Colombia', 'Suspendida'),
(90, 'TableKnight', 'table_k@gmail.com', '321bc355866164f9bf51c6c641655073', '1992-09-22', '2026-10-16', 'Chile', 'Activa'),
(91, 'IndexMage', 'index_m@outlook.com', 'b16abdb90738e4a9e9e62312d8a4369e', '1998-04-13', '2026-10-16', 'México', 'Activa'),
(92, 'BufferRogue', 'buffer_r@gmail.com', '57a44ce2491a27e770334863bc434771', '1996-11-28', '2026-10-16', 'España', 'Activa'),
(93, 'CacheSniper', 'cache_s@yahoo.com', 'a1f795995574cc474f85e1975b9f71ee', '2000-07-07', '2026-10-16', 'Venezuela', 'Activa'),
(94, 'CoreKnight', 'core_k@gmail.com', '4297f44b13955a35284b2416ffc6f851', '1993-03-19', '2026-10-16', 'Argentina', 'Activa'),
(95, 'ThreadMage', 'thread_m@outlook.com', '9b74c9897bac770ffc029102a200c5de', '1997-08-25', '2026-10-16', 'Colombia', 'Baneada'),
(96, 'ProcessRogue', 'process_r@gmail.com', '2c624232cdd221771294dfbb310aca00', '1995-12-31', '2026-10-16', 'Perú', 'Activa'),
(97, 'SocketSniper', 'socket_s@yahoo.com', '19202307cc7313098544c4eac6442654', '1999-05-14', '2026-10-16', 'Chile', 'Activa'),
(98, 'PortKnight', 'port_k@gmail.com', '07775c97711f5fae800c14c57717be67', '1991-10-09', '2026-10-16', 'México', 'Activa'),
(99, 'PacketMage', 'packet_m@outlook.com', '8e6bfa4728f313175217dd108170c1d6', '1998-02-23', '2026-10-16', 'España', 'Activa'),
(100, 'RouterRogue', 'router_r@gmail.com', '64d8a27d21b79414e54887968c9911e2', '1994-07-12', '2026-10-16', 'Venezuela', 'Activa'),
(101, 'FireBlade101', 'fire_b101@gmail.com', '4a7d1ed414474e4033ac29ccb8653d9b', '1996-01-11', '2024-11-15', 'Venezuela', 'Activa'),
(102, 'IceShield102', 'ice_s102@yahoo.com', '126778f237f378037b01b6580f4f9f75', '1999-04-20', '2024-11-28', 'México', 'Activa'),
(103, 'ThunderMage103', 'tmage103@outlook.com', '283538676f4e13554ee59039dbbc2f40', '1994-08-05', '2024-12-05', 'España', 'Activa'),
(104, 'ShadowRogue104', 'srogue104@gmail.com', '8f81014e7a8e2cb9d750058b7654a93a', '2001-12-14', '2024-12-19', 'Argentina', 'Suspendida'),
(105, 'LightKnight105', 'lknight105@gmail.com', 'd9d4f495e875a2e075a1a4a6e1b9770f', '1997-03-30', '2025-01-08', 'Colombia', 'Activa'),
(106, 'DarkHunter106', 'dhunter106@yahoo.com', '37693cfc748049e45d87b8c7d8b9bdda', '2002-06-17', '2025-01-22', 'Chile', 'Activa'),
(107, 'SolarArcher107', 'sarcher107@gmail.com', 'e317d7b56a3138b3c990234a5d852899', '1995-10-09', '2025-02-04', 'Venezuela', 'Activa'),
(108, 'LunarPriest108', 'lpriest108@outlook.com', '98f13708210194c475687be6106a3b84', '1998-02-28', '2025-02-18', 'Perú', 'Baneada'),
(109, 'AstralMonk109', 'amonk109@gmail.com', '3c59dc048e8850243be807a85c723069', '1993-07-14', '2025-03-02', 'México', 'Activa'),
(110, 'VoidDruid110', 'vdruid110@gmail.com', 'd67d8ab4f4c10bf22aa353e27879133c', '2000-09-21', '2025-03-16', 'España', 'Activa'),
(111, 'StormBard111', 'sbard111@yahoo.com', '7a049d5a9fae30a501a35112f458e0a3', '1996-05-03', '2025-03-29', 'Argentina', 'Activa'),
(112, 'FrostPaladin112', 'fpaladin112@gmail.com', '263bce650e68ab4e3b22e9c17456306e', '1999-11-12', '2025-04-10', 'Venezuela', 'Activa'),
(113, 'VenomNinja113', 'vninja113@outlook.com', 'd95679752134a2d4eb64b7e5ec2ab284', '1994-01-25', '2025-04-24', 'Colombia', 'Activa'),
(114, 'BlazeSamurai114', 'bsamurai114@gmail.com', 'f718499c1c8cefba7300320fef968e1b', '2003-04-08', '2025-05-06', 'Chile', 'Suspendida'),
(115, 'EchoValkyrie115', 'evalkyrie115@yahoo.com', '2d2b591b29a8a70c06a392b498f39564', '1997-08-19', '2025-05-18', 'México', 'Activa'),
(116, 'QuantumTitan116', 'qtitan116@gmail.com', '48cf7a57a6277259020a599187315b88', '1992-10-31', '2025-06-01', 'España', 'Activa'),
(117, 'CyberSpecter117', 'cspecter117@outlook.com', '20d18d42399222cf648a8679f2e46f04', '1998-03-15', '2025-06-14', 'Venezuela', 'Activa'),
(118, 'NeonGhost118', 'nghost118@gmail.com', '5f4dcc3b5aa765d61d8327deb882cf99', '2001-07-02', '2025-06-27', 'Argentina', 'Activa'),
(119, 'PixelWizard119', 'pwizard119@yahoo.com', '019202307cc7313098544c4eac644265', '1995-09-24', '2025-07-09', 'Colombia', 'Baneada'),
(120, 'RetroWarrior120', 'rwarrior120@gmail.com', '321bc355866164f9bf51c6c641655073', '1991-11-06', '2025-07-21', 'Perú', 'Activa'),
(121, 'AetherRider121', 'arider121@outlook.com', 'b16abdb90738e4a9e9e62312d8a4369e', '1999-02-17', '2025-08-03', 'Chile', 'Activa'),
(122, 'CrimsonSniper122', 'csniper122@gmail.com', '57a44ce2491a27e770334863bc434771', '1996-06-28', '2025-08-16', 'México', 'Activa'),
(123, 'AzureMage123', 'amage123@yahoo.com', 'a1f795995574cc474f85e1975b9f71ee', '2002-01-09', '2025-08-29', 'España', 'Activa'),
(124, 'VortexKnight124', 'vknight124@gmail.com', '4297f44b13955a35284b2416ffc6f851', '1994-04-14', '2025-09-10', 'Venezuela', 'Activa'),
(125, 'StellarRogue125', 'srogue125@outlook.com', '9b74c9897bac770ffc029102a200c5de', '1997-12-01', '2025-09-22', 'Argentina', 'Suspendida'),
(126, 'TitanHunter126', 'thunter126@gmail.com', '2c624232cdd221771294dfbb310aca00', '2000-05-18', '2025-10-04', 'Colombia', 'Activa'),
(127, 'OmegaPaladin127', 'opaladin127@yahoo.com', '19202307cc7313098544c4eac6442654', '1993-08-27', '2025-10-17', 'Chile', 'Activa'),
(128, 'AlphaMonk128', 'amonk128@gmail.com', '07775c97711f5fae800c14c57717be67', '1998-10-05', '2025-10-30', 'México', 'Activa'),
(129, 'BetaDruid129', 'bdruid129@outlook.com', '8e6bfa4728f313175217dd108170c1d6', '1995-03-22', '2025-11-12', 'España', 'Activa'),
(130, 'GammaBard130', 'gbard130@gmail.com', '64d8a27d21b79414e54887968c9911e2', '2001-01-13', '2025-11-25', 'Venezuela', 'Activa'),
(131, 'DeltaNinja131', 'dninja131@yahoo.com', '9b671a5e182281a4a499f57ef518c772', '1996-07-07', '2025-12-08', 'Argentina', 'Baneada'),
(132, 'ZetaSamurai132', 'zsamurai132@gmail.com', '827ccb0eea8a706c4c34a16891f84e7b', '1999-09-19', '2025-12-20', 'Colombia', 'Activa'),
(133, 'SigmaValkyrie133', 'svalkyrie133@outlook.com', 'e16e6d7a48d8db9c8114f487e4128509', '1992-12-30', '2026-01-04', 'Perú', 'Activa'),
(134, 'KappaTitan134', 'ktitan134@gmail.com', '3b592750fa4d173426e792c30081dcf3', '1997-04-11', '2026-01-17', 'Chile', 'Activa'),
(135, 'LambdaSpecter135', 'lspecter135@yahoo.com', '6512bd43d9caa6e02c990b0a82652dca', '2003-02-26', '2026-01-30', 'México', 'Activa'),
(136, 'ThetaGhost136', 'tghost136@gmail.com', 'c20ad4d76fe97759aa27a0c99bff6710', '1994-06-08', '2026-02-11', 'España', 'Suspendida'),
(137, 'RhoWizard137', 'rwizard137@outlook.com', 'c51ce410c124a10e0db5e4b97fc2af39', '1998-08-21', '2026-02-23', 'Venezuela', 'Activa'),
(138, 'PixelRider138', 'prider138@gmail.com', '4a7d1ed414474e4033ac29ccb8653d9b', '2000-11-15', '2026-03-08', 'Argentina', 'Activa'),
(139, 'CyberArcher139', 'carcher139@yahoo.com', '126778f237f378037b01b6580f4f9f75', '1995-01-03', '2026-03-20', 'Colombia', 'Activa'),
(140, 'NetPriest140', 'npriest140@gmail.com', '283538676f4e13554ee59039dbbc2f40', '2002-05-29', '2026-04-02', 'Chile', 'Activa'),
(141, 'BitMonk141', 'bmonk141@outlook.com', '8f81014e7a8e2cb9d750058b7654a93a', '1993-09-12', '2026-04-15', 'México', 'Activa'),
(142, 'ByteDruid142', 'bdruid142@gmail.com', 'd9d4f495e875a2e075a1a4a6e1b9770f', '1997-11-04', '2026-04-28', 'España', 'Baneada'),
(143, 'DataBard143', 'dbard143@yahoo.com', '37693cfc748049e45d87b8c7d8b9bdda', '1991-04-17', '2026-05-10', 'Venezuela', 'Activa'),
(144, 'CodeNinja144', 'cninja144@gmail.com', 'e317d7b56a3138b3c990234a5d852899', '1999-08-23', '2026-05-22', 'Argentina', 'Activa'),
(145, 'ScriptPaladin145', 'spaladin145@outlook.com', '98f13708210194c475687be6106a3b84', '1996-12-09', '2026-06-03', 'Colombia', 'Activa'),
(146, 'QuerySamurai146', 'qsamurai146@gmail.com', '3c59dc048e8850243be807a85c723069', '2001-03-18', '2026-06-16', 'Perú', 'Activa'),
(147, 'TableValkyrie147', 'tvalkyrie147@yahoo.com', 'd67d8ab4f4c10bf22aa353e27879133c', '1994-07-01', '2026-06-28', 'Chile', 'Suspendida'),
(148, 'IndexTitan148', 'ititan148@gmail.com', '7a049d5a9fae30a501a35112f458e0a3', '1998-10-14', '2026-07-10', 'México', 'Activa'),
(149, 'BufferSpecter149', 'bspecter149@outlook.com', '263bce650e68ab4e3b22e9c17456306e', '1993-02-05', '2026-07-23', 'España', 'Activa'),
(150, 'CacheGhost150', 'cghost150@gmail.com', 'd95679752134a2d4eb64b7e5ec2ab284', '2000-06-27', '2026-08-05', 'Venezuela', 'Activa'),
(151, 'VortexGamer151', 'vortex151@gmail.com', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', '1998-02-14', '2025-01-10', 'Venezuela', 'Activa'),
(152, 'ShadowStrike152', 'shadowstrike@yahoo.com', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', '1995-08-22', '2025-01-12', 'México', 'Activa'),
(153, 'FrostBite153', 'frost_bite@outlook.com', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', '2000-11-05', '2025-01-15', 'España', 'Activa'),
(154, 'BlazeFury154', 'blazefury99@gmail.com', '2fd4e1c67a2d28fced849ee1bb76e7391b93eb12efbc74b9bf0f4d2a5b6e59c4', '1993-05-30', '2025-01-18', 'Argentina', 'Suspendida'),
(155, 'NightHawk155', 'nighthawk_ve@hotmail.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', '1999-12-12', '2025-01-20', 'Colombia', 'Activa'),
(156, 'ThunderGod156', 'thundergod@gmail.com', '3c59dc048e8850243be807a85c723069c6cbfd4a5d9f0b3b5b6e8a64c1c7a2e9', '1997-07-07', '2025-01-22', 'Chile', 'Activa'),
(157, 'SilverArrow157', 'silverarrow@yahoo.com', 'd4735e3a265e16eee03f59718b9b5d030bd9696d9e8a1a0e2d3c4b5a6f7e8d9c', '1994-03-19', '2025-01-25', 'Perú', 'Activa'),
(158, 'CyberWolf158', 'cyberwolf_88@outlook.com', '4e07408562bedb8b60ce05c1decfe3ad16b72230967de01f640b7e4729b49fce', '2001-09-08', '2025-01-28', 'Uruguay', 'Activa'),
(159, 'PixelMaster159', 'pixelmaster@gmail.com', '6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b', '1996-01-25', '2025-02-01', 'Venezuela', 'Activa'),
(160, 'GhostReaper160', 'ghostreaper@yahoo.com', '1d645372d83296a1fb0d31c69992d536c4b8e4f2f2b3a4c5d6e7f8091a2b3c4d', '1992-06-11', '2025-02-03', 'México', 'Baneada'),
(161, 'IronFist161', 'ironfist_ve@hotmail.com', 'c1dfd96eea8cc2b62785275bca3acac2a7f3e1d2c3b4a5968778695a4b3c2d1e', '1998-10-30', '2025-02-05', 'España', 'Activa'),
(162, 'StormBreaker162', 'stormbreaker@gmail.com', '9b74c9897bac770ffc029102a200c5de2e8f3c1d0b9a887766554433221100ff', '1995-04-14', '2025-02-08', 'Argentina', 'Activa'),
(163, 'DarkPhoenix163', 'darkphoenix@outlook.com', '8e6bfa4728f313175217dd108170c1d6c3b2a1908f7e6d5c4b3a2918070605040', '2000-08-21', '2025-02-10', 'Colombia', 'Activa'),
(164, 'LightBringer164', 'lightbringer@yahoo.com', '07775c97711f5fae800c14c57717be67f8e7d6c5b4a39281706f5e4d3c2b1a09', '1993-12-03', '2025-02-12', 'Chile', 'Activa'),
(165, 'VoidWalker165', 'voidwalker@gmail.com', '64d8a27d21b79414e54887968c9911e2a1b2c3d4e5f60718293a4b5c6d7e8f90', '1997-02-17', '2025-02-15', 'Perú', 'Suspendida'),
(166, 'CrimsonTide166', 'crimsontide@outlook.com', '57a44ce2491a27e770334863bc4347719a8b7c6d5e4f302132435465768798a9b', '1999-07-09', '2025-02-18', 'Uruguay', 'Activa'),
(167, 'AzureDragon167', 'azuredragon@gmail.com', 'e16e6d7a48d8db9c8114f487e4128509f1e2d3c4b5a69788776655443322110f', '1991-11-27', '2025-02-20', 'Venezuela', 'Activa'),
(168, 'NeonSpecter168', 'neonspecter@yahoo.com', '3b592750fa4d173426e792c30081dcf3a4b5c6d7e8f90123456789abcdef01234', '1996-05-05', '2025-02-22', 'México', 'Activa'),
(169, 'QuantumRogue169', 'quantumrogue@hotmail.com', '6512bd43d9caa6e02c990b0a82652dca5e4d3c2b1a0987654321fedcba987654', '2002-09-19', '2025-02-25', 'España', 'Activa'),
(170, 'StellarKnight170', 'stellarknight@gmail.com', 'c20ad4d76fe97759aa27a0c99bff6710d1c2b3a49586776859403a2b1c0d9e8f', '1994-01-08', '2025-02-28', 'Argentina', 'Baneada'),
(171, 'EmberSpirit171', 'emberspirit@yahoo.com', 'c51ce410c124a10e0db5e4b97fc2af39e8d7c6b5a4938271605f4e3d2c1b0a99', '1998-06-23', '2025-03-02', 'Colombia', 'Activa'),
(172, 'LunarWolf172', 'lunarwolf@gmail.com', '4a7d1ed414474e4033ac29ccb8653d9b1a2b3c4d5e6f708192a3b4c5d6e7f809', '1995-10-15', '2025-03-05', 'Chile', 'Activa'),
(173, 'SolarFlare173', 'solarflare@outlook.com', '126778f237f378037b01b6580f4f9f75c9d8e7f6a5b4c3d2e1f0a9b8c7d6e5f4', '2001-03-30', '2025-03-08', 'Perú', 'Activa'),
(174, 'TitanSlayer174', 'titanslayer@gmail.com', '283538676f4e13554ee59039dbbc2f40a2b3c4d5e6f7081928374655647382910', '1992-08-12', '2025-03-10', 'Uruguay', 'Activa'),
(175, 'FrostGiant175', 'frostgiant@yahoo.com', '8f81014e7a8e2cb9d750058b7654a93a7e6d5c4b3a2918070605040302010f9e', '1997-12-25', '2025-03-12', 'Venezuela', 'Suspendida'),
(176, 'BladeRunner176', 'bladerunner@gmail.com', 'd9d4f495e875a2e075a1a4a6e1b9770f9e8d7c6b5a4938271605f4e3d2c1b0a9', '1999-04-07', '2025-03-15', 'México', 'Activa'),
(177, 'EchoStrike177', 'echostrike@outlook.com', '37693cfc748049e45d87b8c7d8b9bdda3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b', '1993-09-18', '2025-03-18', 'España', 'Activa'),
(178, 'OmegaKnight178', 'omegaknight@gmail.com', 'e317d7b56a3138b3c990234a5d852899c4b5a69788776655443322110ffeeddcc', '1996-02-02', '2025-03-20', 'Argentina', 'Activa'),
(179, 'AlphaWolf179', 'alphawolf@yahoo.com', '98f13708210194c475687be6106a3b84d5e4f3a2b1c0d9e8f7a6b5c4d3e2f1a09', '2000-07-14', '2025-03-22', 'Colombia', 'Activa'),
(180, 'BetaTester180', 'betatester@gmail.com', '3c59dc048e8850243be807a85c723069a1b2c3d4e5f60718293a4b5c6d7e8f90', '1991-11-11', '2025-03-25', 'Chile', 'Baneada'),
(181, 'GammaRay181', 'gammaray@outlook.com', 'd67d8ab4f4c10bf22aa353e27879133c9f8e7d6c5b4a39281706f5e4d3c2b1a0', '1998-03-29', '2025-03-28', 'Perú', 'Activa'),
(182, 'DeltaForce182', 'deltaforce@gmail.com', '7a049d5a9fae30a501a35112f458e0a3e1f2a3b4c5d6e7f8091a2b3c4d5e6f70', '1994-08-05', '2025-03-30', 'Uruguay', 'Activa'),
(183, 'ZetaWarrior183', 'zetawarrior@yahoo.com', '263bce650e68ab4e3b22e9c17456306e2a3b4c5d6e7f8091a2b3c4d5e6f70819', '1997-01-17', '2025-04-02', 'Venezuela', 'Activa'),
(184, 'SigmaHunter184', 'sigmahunter@gmail.com', 'd95679752134a2d4eb64b7e5ec2ab2843c4d5e6f708192a3b4c5d6e7f8091a2b3', '2001-06-08', '2025-04-05', 'México', 'Suspendida'),
(185, 'KappaMage185', 'kappamage@outlook.com', 'f718499c1c8cefba7300320fef968e1b4d5e6f708192a3b4c5d6e7f8091a2b3c4', '1995-10-27', '2025-04-08', 'España', 'Activa'),
(186, 'LambdaRogue186', 'lambdarogue@gmail.com', '2d2b591b29a8a70c06a392b498f395645e6f708192a3b4c5d6e7f8091a2b3c4d5', '1999-12-30', '2025-04-10', 'Argentina', 'Activa'),
(187, 'ThetaSniper187', 'thetasniper@yahoo.com', '48cf7a57a6277259020a599187315b886f708192a3b4c5d6e7f8091a2b3c4d5e6f7', '1992-05-06', '2025-04-12', 'Colombia', 'Activa'),
(188, 'RhoPaladin188', 'rhopaladin@gmail.com', '20d18d42399222cf648a8679f2e46f04708192a3b4c5d6e7f8091a2b3c4d5e6f708', '1998-09-13', '2025-04-15', 'Chile', 'Activa'),
(189, 'PixelKnight189', 'pixelknight@outlook.com', '5f4dcc3b5aa765d61d8327deb882cf998192a3b4c5d6e7f8091a2b3c4d5e6f70819', '1996-04-22', '2025-04-18', 'Perú', 'Baneada'),
(190, 'CyberMage190', 'cybermage@gmail.com', '019202307cc7313098544c4eac64426592a3b4c5d6e7f8091a2b3c4d5e6f708192a', '1994-11-09', '2025-04-20', 'Uruguay', 'Activa'),
(191, 'NetWarrior191', 'netwarrior@yahoo.com', '321bc355866164f9bf51c6c641655073a3b4c5d6e7f8091a2b3c4d5e6f708192a3b', '2000-03-15', '2025-04-22', 'Venezuela', 'Activa'),
(192, 'BitRogue192', 'bitrogue@gmail.com', 'b16abdb90738e4a9e9e62312d8a4369eb4c5d6e7f8091a2b3c4d5e6f708192a3b4c', '1997-08-28', '2025-04-25', 'México', 'Activa'),
(193, 'ByteSniper193', 'bytesniper@outlook.com', '57a44ce2491a27e770334863bc434771c5d6e7f8091a2b3c4d5e6f708192a3b4c5d6', '1993-01-04', '2025-04-28', 'España', 'Suspendida'),
(194, 'DataKnight194', 'dataknight@gmail.com', 'a1f795995574cc474f85e1975b9f71eed6e7f8091a2b3c4d5e6f708192a3b4c5d6e7', '1998-07-20', '2025-04-30', 'Argentina', 'Activa'),
(195, 'CodeMage195', 'codemage@yahoo.com', '4297f44b13955a35284b2416ffc6f851e7f8091a2b3c4d5e6f708192a3b4c5d6e7f8', '2001-12-02', '2025-05-02', 'Colombia', 'Activa'),
(196, 'ScriptRogue196', 'scriptrogue@gmail.com', '9b74c9897bac770ffc029102a200c5def8091a2b3c4d5e6f708192a3b4c5d6e7f809', '1995-06-16', '2025-05-05', 'Chile', 'Activa'),
(197, 'QuerySniper197', 'querysniper@outlook.com', '2c624232cdd221771294dfbb310aca00091a2b3c4d5e6f708192a3b4c5d6e7f8091a', '1999-10-08', '2025-05-08', 'Perú', 'Activa'),
(198, 'TableKnight198', 'tableknight@gmail.com', '19202307cc7313098544c4eac64426541a2b3c4d5e6f708192a3b4c5d6e7f8091a2b', '1991-04-30', '2025-05-10', 'Uruguay', 'Baneada'),
(199, 'IndexMage199', 'indexmage@yahoo.com', '07775c97711f5fae800c14c57717be672a3b4c5d6e7f8091a2b3c4d5e6f708192a3b4', '1997-09-21', '2025-05-12', 'Venezuela', 'Activa'),
(200, 'BufferRogue200', 'bufferrogue@gmail.com', '8e6bfa4728f313175217dd108170c1d63b4c5d6e7f8091a2b3c4d5e6f708192a3b4c5', '1994-02-11', '2025-05-15', 'México', 'Activa'),
(201, 'QueryDruid201', 'qdruid201@yahoo.com', 'a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6', '1996-03-01', '2025-05-16', 'Venezuela', 'Activa'),
(202, 'TableBard202', 'tbard202@gmail.com', 'q1w2e3r4t5y6u7i8o9p0a1s2d3f4g5h6', '1997-04-02', '2025-05-17', 'México', 'Activa'),
(203, 'IndexPaladin203', 'ipaladin203@outlook.com', 'z1x2c3v4b5n6m7q8w9e0r1t2y3u4i5o6', '1998-05-03', '2025-05-18', 'España', 'Suspendida'),
(204, 'BufferNinja204', 'bninja204@yahoo.com', 'p1o2i3u4y5t6r7e8w9q0a1s2d3f4g5h', '1999-06-04', '2025-05-19', 'Argentina', 'Activa'),
(205, 'CacheSamurai205', 'csamurai205@gmail.com', 'l1k2j3h4g5f6d7s8a9p0o1i2u3y4t5r', '2000-07-05', '2025-05-20', 'Colombia', 'Activa'),
(206, 'CoreValkyrie206', 'cvalkyrie206@outlook.com', 'm1n2b3v4c5x6z7l8k9j0h1g2f3d4s5a', '1995-08-06', '2025-05-21', 'Chile', 'Activa'),
(207, 'ThreadTitan207', 'ttitan207@gmail.com', 'q1w2e3r4t5y6u7i8o9p0a1s2d3f4g5h6', '1996-09-07', '2025-05-22', 'Perú', 'Baneada'),
(208, 'ProcessSpecter208', 'pspecter208@yahoo.com', 'z1x2c3v4b5n6m7q8w9e0r1t2y3u4i5o6', '1997-10-08', '2025-05-23', 'Uruguay', 'Activa'),
(209, 'SocketGhost209', 'sghost209@gmail.com', 'p1o2i3u4y5t6r7e8w9q0a1s2d3f4g5h', '1998-11-09', '2025-05-24', 'Venezuela', 'Activa'),
(210, 'PortWizard210', 'pwizard210@outlook.com', 'l1k2j3h4g5f6d7s8a9p0o1i2u3y4t5r', '1999-12-10', '2025-05-25', 'México', 'Activa'),
(211, 'PacketRider211', 'prider211@gmail.com', 'm1n2b3v4c5x6z7l8k9j0h1g2f3d4s5a', '2000-01-11', '2025-05-26', 'España', 'Activa'),
(212, 'RouterArcher212', 'rarcher212@yahoo.com', 'q1w2e3r4t5y6u7i8o9p0a1s2d3f4g5h6', '2001-02-12', '2025-05-27', 'Argentina', 'Suspendida'),
(213, 'SwitchPriest213', 'spriest213@gmail.com', 'z1x2c3v4b5n6m7q8w9e0r1t2y3u4i5o6', '1994-03-13', '2025-05-28', 'Colombia', 'Activa'),
(214, 'BridgeMonk214', 'bmonk214@outlook.com', 'p1o2i3u4y5t6r7e8w9q0a1s2d3f4g5h', '1995-04-14', '2025-05-29', 'Chile', 'Activa'),
(215, 'GatewayDruid215', 'gdruid215@gmail.com', 'l1k2j3h4g5f6d7s8a9p0o1i2u3y4t5r', '1996-05-15', '2025-05-30', 'Perú', 'Activa'),
(216, 'ProxyBard216', 'pbard216@yahoo.com', 'm1n2b3v4c5x6z7l8k9j0h1g2f3d4s5a', '1997-06-16', '2025-05-31', 'Uruguay', 'Baneada'),
(217, 'SubnetPaladin217', 'spaladin217@outlook.com', 'q1w2e3r4t5y6u7i8o9p0a1s2d3f4g5h6', '1998-07-17', '2025-06-01', 'Venezuela', 'Activa'),
(218, 'MaskNinja218', 'mninja218@gmail.com', 'z1x2c3v4b5n6m7q8w9e0r1t2y3u4i5o6', '1999-08-18', '2025-06-02', 'México', 'Activa'),
(219, 'DNS_Samurai219', 'dns_s219@yahoo.com', 'p1o2i3u4y5t6r7e8w9q0a1s2d3f4g5h', '2000-09-19', '2025-06-03', 'España', 'Activa'),
(220, 'DHCP_Valkyrie220', 'dhcp_v220@gmail.com', 'l1k2j3h4g5f6d7s8a9p0o1i2u3y4t5r', '2001-10-20', '2025-06-04', 'Argentina', 'Activa'),
(221, 'HTTP_Titan221', 'http_t221@outlook.com', 'm1n2b3v4c5x6z7l8k9j0h1g2f3d4s5a', '1994-11-21', '2025-06-05', 'Colombia', 'Suspendida'),
(222, 'FTP_Specter222', 'ftp_s222@gmail.com', 'q1w2e3r4t5y6u7i8o9p0a1s2d3f4g5h6', '1995-12-22', '2025-06-06', 'Chile', 'Activa'),
(223, 'SSH_Ghost223', 'ssh_g223@yahoo.com', 'z1x2c3v4b5n6m7q8w9e0r1t2y3u4i5o6', '1996-01-23', '2025-06-07', 'Perú', 'Activa'),
(224, 'TCP_Wizard224', 'tcp_w224@outlook.com', 'p1o2i3u4y5t6r7e8w9q0a1s2d3f4g5h', '1997-02-24', '2025-06-08', 'Uruguay', 'Activa'),
(225, 'UDP_Rider225', 'udp_r225@gmail.com', 'l1k2j3h4g5f6d7s8a9p0o1i2u3y4t5r', '1998-03-25', '2025-06-09', 'Venezuela', 'Baneada'),
(226, 'IP_Archer226', 'ip_a226@yahoo.com', 'm1n2b3v4c5x6z7l8k9j0h1g2f3d4s5a', '1999-04-26', '2025-06-10', 'México', 'Activa'),
(227, 'MAC_Priest227', 'mac_p227@outlook.com', 'q1w2e3r4t5y6u7i8o9p0a1s2d3f4g5h6', '2000-05-27', '2025-06-11', 'España', 'Activa'),
(228, 'ARP_Monk228', 'arp_m228@gmail.com', 'z1x2c3v4b5n6m7q8w9e0r1t2y3u4i5o6', '2001-06-28', '2025-06-12', 'Argentina', 'Activa'),
(229, 'ICMP_Druid229', 'icmp_d229@yahoo.com', 'p1o2i3u4y5t6r7e8w9q0a1s2d3f4g5h', '1994-07-29', '2025-06-13', 'Colombia', 'Activa'),
(230, 'VPN_Bard230', 'vpn_b230@outlook.com', 'l1k2j3h4g5f6d7s8a9p0o1i2u3y4t5r', '1995-08-30', '2025-06-14', 'Chile', 'Activa'),
(231, 'VLAN_Paladin231', 'vlan_p231@gmail.com', 'm1n2b3v4c5x6z7l8k9j0h1g2f3d4s5a', '1996-09-01', '2025-06-15', 'Perú', 'Suspendida'),
(232, 'NAT_Ninja232', 'nat_n232@yahoo.com', 'q1w2e3r4t5y6u7i8o9p0a1s2d3f4g5h6', '1997-10-02', '2025-06-16', 'Uruguay', 'Activa'),
(233, 'DMZ_Samurai233', 'dmz_s233@outlook.com', 'z1x2c3v4b5n6m7q8w9e0r1t2y3u4i5o6', '1998-11-03', '2025-06-17', 'Venezuela', 'Activa'),
(234, 'SQL_Valkyrie234', 'sql_v234@gmail.com', 'p1o2i3u4y5t6r7e8w9q0a1s2d3f4g5h', '1999-12-04', '2025-06-18', 'México', 'Activa'),
(235, 'NOSQL_Titan235', 'nosql_t235@yahoo.com', 'l1k2j3h4g5f6d7s8a9p0o1i2u3y4t5r', '2000-01-05', '2025-06-19', 'España', 'Baneada'),
(236, 'CRUD_Specter236', 'crud_s236@outlook.com', 'm1n2b3v4c5x6z7l8k9j0h1g2f3d4s5a', '2001-02-06', '2025-06-20', 'Argentina', 'Activa'),
(237, 'ACID_Ghost237', 'acid_g237@gmail.com', 'q1w2e3r4t5y6u7i8o9p0a1s2d3f4g5h6', '1994-03-07', '2025-06-21', 'Colombia', 'Activa'),
(238, 'BASE_Wizard238', 'base_w238@yahoo.com', 'z1x2c3v4b5n6m7q8w9e0r1t2y3u4i5o6', '1995-04-08', '2025-06-22', 'Chile', 'Activa'),
(239, 'REST_Rider239', 'rest_r239@outlook.com', 'p1o2i3u4y5t6r7e8w9q0a1s2d3f4g5h', '1996-05-09', '2025-06-23', 'Perú', 'Suspendida'),
(240, 'SOAP_Archer240', 'soap_a240@gmail.com', 'l1k2j3h4g5f6d7s8a9p0o1i2u3y4t5r', '1997-06-10', '2025-06-24', 'Uruguay', 'Activa'),
(241, 'JSON_Priest241', 'json_p241@yahoo.com', 'm1n2b3v4c5x6z7l8k9j0h1g2f3d4s5a', '1998-07-11', '2025-06-25', 'Venezuela', 'Activa'),
(242, 'XML_Monk242', 'xml_m242@outlook.com', 'q1w2e3r4t5y6u7i8o9p0a1s2d3f4g5h6', '1999-08-12', '2025-06-26', 'México', 'Activa'),
(243, 'YAML_Druid243', 'yaml_d243@gmail.com', 'z1x2c3v4b5n6m7q8w9e0r1t2y3u4i5o6', '2000-09-13', '2025-06-27', 'España', 'Baneada'),
(244, 'CSV_Bard244', 'csv_b244@yahoo.com', 'p1o2i3u4y5t6r7e8w9q0a1s2d3f4g5h', '2001-10-14', '2025-06-28', 'Argentina', 'Activa'),
(245, 'BLOB_Paladin245', 'blob_p245@outlook.com', 'l1k2j3h4g5f6d7s8a9p0o1i2u3y4t5r', '1994-11-15', '2025-06-29', 'Colombia', 'Activa'),
(246, 'CLOB_Ninja246', 'clob_n246@gmail.com', 'm1n2b3v4c5x6z7l8k9j0h1g2f3d4s5a', '1995-12-16', '2025-06-30', 'Chile', 'Activa'),
(247, 'UUID_Samurai247', 'uuid_s247@yahoo.com', 'q1w2e3r4t5y6u7i8o9p0a1s2d3f4g5h6', '1996-01-17', '2025-07-01', 'Perú', 'Suspendida'),
(248, 'GUID_Valkyrie248', 'guid_v248@outlook.com', 'z1x2c3v4b5n6m7q8w9e0r1t2y3u4i5o6', '1997-02-18', '2025-07-02', 'Uruguay', 'Activa'),
(249, 'NULL_Titan249', 'null_t249@gmail.com', 'p1o2i3u4y5t6r7e8w9q0a1s2d3f4g5h', '1998-03-19', '2025-07-03', 'Venezuela', 'Activa'),
(250, 'TrueGamer250', 'truegamer250@yahoo.com', 'l1k2j3h4g5f6d7s8a9p0o1i2u3y4t5r', '1999-04-20', '2025-07-04', 'México', 'Activa'),
(251,'diego154', 'diego154@email.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', '2002-05-15', '2024-01-10 14:30:00', 'Venezuela', 'Activa'),
(252, 'teladou', 'teladou@email.com', 'b3a8e0e1f9ab1bfe3a36f231f676f78bb30a519d2b21e6c530c0eee8ebb4a5d0', '1998-11-20', '2024-02-01 10:15:00', 'Venezuela', 'Activa');

 SET IDENTITY_INSERT Usuario OFF;

/* -------------------------- 2. Amistad_Usuario ----------------------- */
-- Relaciona solicitudes de amistad entre usuarios con sus respectivos estados
 INSERT INTO Amistad_Usuario (ID_Usuario_Solicitante_FK, ID_Usuario_Receptor_FK, Fecha_Amistad, Estado_Amistad) VALUES


(2, 1, '2024-10-21', 'Aceptada'), (3, 1, '2024-10-21', 'Aceptada'), (3, 2, '2024-10-21', 'Aceptada'),


(1, 2, '2024-10-21', 'Aceptada'), (1, 3, '2024-11-05', 'Aceptada'), (1, 4, '2024-11-12', 'Aceptada'), (1, 10, '2025-01-02', 'Aceptada'),
(2, 3, '2024-11-03', 'Aceptada'), (2, 5, '2024-12-02', 'Pendiente'), (2, 11, '2025-01-15', 'Aceptada'),
(3, 6, '2024-12-15', 'Aceptada'), (3, 7, '2025-01-08', 'Pendiente'), (3, 12, '2025-02-01', 'Aceptada'),
(4, 5, '2024-12-05', 'Aceptada'), (4, 8, '2025-01-20', 'Bloqueada'), (4, 13, '2025-02-10', 'Aceptada'),
(5, 6, '2024-12-20', 'Aceptada'), (5, 9, '2025-01-25', 'Aceptada'), (5, 14, '2025-03-01', 'Pendiente'),

(6, 7, '2025-01-10', 'Aceptada'), (6, 15, '2025-03-05', 'Aceptada'), (6, 20, '2025-04-01', 'Aceptada'),
(7, 8, '2025-01-22', 'Aceptada'), (7, 16, '2025-03-12', 'Pendiente'), (7, 21, '2025-04-10', 'Aceptada'),
(8, 9, '2025-01-30', 'Aceptada'), (8, 17, '2025-03-20', 'Aceptada'), (8, 22, '2025-04-15', 'Pendiente'),
(9, 10, '2025-02-05', 'Aceptada'), (9, 18, '2025-03-25', 'Aceptada'), (9, 23, '2025-04-20', 'Aceptada'),
(10, 11, '2025-02-18', 'Aceptada'), (10, 19, '2025-04-02', 'Aceptada'), (10, 24, '2025-05-01', 'Aceptada'),

(11, 12, '2025-02-20', 'Aceptada'), (11, 25, '2025-05-05', 'Pendiente'), (11, 30, '2025-06-01', 'Aceptada'),
(12, 13, '2025-03-02', 'Aceptada'), (12, 26, '2025-05-10', 'Aceptada'), (12, 31, '2025-06-10', 'Aceptada'),
(13, 14, '2025-03-15', 'Pendiente'), (13, 27, '2025-05-15', 'Aceptada'), (13, 32, '2025-06-15', 'Bloqueada'),
(14, 15, '2025-03-28', 'Aceptada'), (14, 28, '2025-05-20', 'Aceptada'), (14, 33, '2025-06-20', 'Aceptada'),
(15, 16, '2025-04-05', 'Aceptada'), (15, 29, '2025-05-25', 'Aceptada'), (15, 34, '2025-06-25', 'Pendiente'),

(16, 17, '2025-04-12', 'Aceptada'), (16, 35, '2025-07-01', 'Aceptada'), (16, 40, '2025-08-01', 'Aceptada'),
(17, 18, '2025-04-22', 'Aceptada'), (17, 36, '2025-07-05', 'Pendiente'), (17, 41, '2025-08-05', 'Aceptada'),
(18, 19, '2025-05-01', 'Aceptada'), (18, 37, '2025-07-10', 'Aceptada'), (18, 42, '2025-08-10', 'Aceptada'),
(19, 20, '2025-05-08', 'Aceptada'), (19, 38, '2025-07-15', 'Aceptada'), (19, 43, '2025-08-15', 'Pendiente'),
(20, 21, '2025-05-18', 'Aceptada'), (20, 39, '2025-07-20', 'Bloqueada'), (20, 44, '2025-08-20', 'Aceptada'),

(21, 22, '2025-05-28', 'Aceptada'), (21, 45, '2025-08-25', 'Aceptada'), (21, 50, '2025-09-01', 'Aceptada'),
(22, 23, '2025-06-05', 'Aceptada'), (22, 46, '2025-08-28', 'Aceptada'), (22, 51, '2025-09-05', 'Pendiente'),
(23, 24, '2025-06-12', 'Aceptada'), (23, 47, '2025-09-02', 'Pendiente'), (23, 52, '2025-09-10', 'Aceptada'),
(24, 25, '2025-06-22', 'Aceptada'), (24, 48, '2025-09-08', 'Aceptada'), (24, 53, '2025-09-15', 'Aceptada'),
(25, 26, '2025-07-02', 'Aceptada'), (25, 49, '2025-09-12', 'Aceptada'), (25, 54, '2025-09-20', 'Aceptada'),

(26, 27, '2025-07-10', 'Aceptada'), (26, 55, '2025-09-22', 'Aceptada'), (26, 60, '2025-10-01', 'Pendiente'),
(27, 28, '2025-07-18', 'Aceptada'), (27, 56, '2025-09-25', 'Pendiente'), (27, 61, '2025-10-05', 'Aceptada'),
(28, 29, '2025-07-25', 'Aceptada'), (28, 57, '2025-09-28', 'Aceptada'), (28, 62, '2025-10-10', 'Aceptada'),
(29, 30, '2025-08-02', 'Aceptada'), (29, 58, '2025-10-02', 'Aceptada'), (29, 63, '2025-10-12', 'Bloqueada'),
(30, 31, '2025-08-11', 'Aceptada'), (30, 59, '2025-10-04', 'Aceptada'), (30, 64, '2025-10-15', 'Aceptada'),

(31, 32, '2025-08-18', 'Aceptada'), (31, 65, '2025-10-18', 'Aceptada'), (31, 70, '2025-11-01', 'Aceptada'),
(32, 33, '2025-08-24', 'Aceptada'), (32, 66, '2025-10-22', 'Pendiente'), (32, 71, '2025-11-05', 'Aceptada'),
(33, 34, '2025-09-01', 'Aceptada'), (33, 67, '2025-10-25', 'Aceptada'), (33, 72, '2025-11-10', 'Pendiente'),
(34, 35, '2025-09-10', 'Aceptada'), (34, 68, '2025-10-28', 'Aceptada'), (34, 73, '2025-11-15', 'Aceptada'),
(35, 36, '2025-09-15', 'Aceptada'), (35, 69, '2025-10-31', 'Aceptada'), (35, 74, '2025-11-20', 'Aceptada'),

(36, 37, '2025-09-20', 'Aceptada'), (36, 75, '2025-11-22', 'Aceptada'), (36, 80, '2025-12-01', 'Aceptada'),
(37, 38, '2025-09-25', 'Aceptada'), (37, 76, '2025-11-25', 'Pendiente'), (37, 81, '2025-12-05', 'Pendiente'),
(38, 39, '2025-10-01', 'Aceptada'), (38, 77, '2025-11-28', 'Aceptada'), (38, 82, '2025-12-10', 'Aceptada'),
(39, 40, '2025-10-05', 'Aceptada'), (39, 78, '2025-12-01', 'Aceptada'), (39, 83, '2025-12-15', 'Aceptada'),
(40, 41, '2025-10-10', 'Aceptada'), (40, 79, '2025-12-03', 'Bloqueada'), (40, 84, '2025-12-20', 'Aceptada'),

(41, 42, '2025-10-15', 'Aceptada'), (41, 85, '2025-12-22', 'Aceptada'), (41, 90, '2026-01-05', 'Aceptada'),
(42, 43, '2025-10-20', 'Aceptada'), (42, 86, '2025-12-25', 'Pendiente'), (42, 91, '2026-01-08', 'Aceptada'),
(43, 44, '2025-10-25', 'Aceptada'), (43, 87, '2025-12-28', 'Aceptada'), (43, 92, '2026-01-12', 'Pendiente'),
(44, 45, '2025-11-01', 'Aceptada'), (44, 88, '2026-01-02', 'Aceptada'), (44, 93, '2026-01-15', 'Aceptada'),
(45, 46, '2025-11-05', 'Aceptada'), (45, 89, '2026-01-04', 'Aceptada'), (45, 94, '2026-01-20', 'Aceptada'),

(46, 47, '2025-11-10', 'Aceptada'), (46, 95, '2026-01-22', 'Aceptada'), (46, 100, '2026-02-01', 'Pendiente'),
(47, 48, '2025-11-15', 'Aceptada'), (47, 96, '2026-01-25', 'Pendiente'), (47, 101, '2026-02-05', 'Aceptada'),
(48, 49, '2025-11-20', 'Aceptada'), (48, 97, '2026-01-28', 'Aceptada'), (48, 102, '2026-02-08', 'Aceptada'),
(49, 50, '2025-11-25', 'Aceptada'), (49, 98, '2026-01-30', 'Aceptada'), (49, 103, '2026-02-12', 'Bloqueada'),
(50, 51, '2025-12-01', 'Aceptada'), (50, 99, '2026-02-02', 'Aceptada'), (50, 104, '2026-02-15', 'Aceptada'),

(51, 52, '2025-12-05', 'Aceptada'), (51, 105, '2026-02-18', 'Aceptada'), (51, 110, '2026-03-01', 'Aceptada'),
(52, 53, '2025-12-10', 'Aceptada'), (52, 106, '2026-02-20', 'Pendiente'), (52, 111, '2026-03-05', 'Aceptada'),
(53, 54, '2025-12-15', 'Aceptada'), (53, 107, '2026-02-22', 'Aceptada'), (53, 112, '2026-03-08', 'Pendiente'),
(54, 55, '2025-12-20', 'Aceptada'), (54, 108, '2026-02-25', 'Aceptada'), (54, 113, '2026-03-12', 'Aceptada'),
(55, 56, '2025-12-28', 'Aceptada'), (55, 109, '2026-02-28', 'Aceptada'), (55, 114, '2026-03-15', 'Aceptada'),

(56, 57, '2026-01-02', 'Aceptada'), (56, 115, '2026-03-18', 'Aceptada'), (56, 120, '2026-04-01', 'Pendiente'),
(57, 58, '2026-01-05', 'Aceptada'), (57, 116, '2026-03-20', 'Pendiente'), (57, 121, '2026-04-05', 'Aceptada'),
(58, 59, '2026-01-10', 'Aceptada'), (58, 117, '2026-03-22', 'Aceptada'), (58, 122, '2026-04-08', 'Aceptada'),
(59, 60, '2026-01-15', 'Aceptada'), (59, 118, '2026-03-25', 'Aceptada'), (59, 123, '2026-04-12', 'Bloqueada'),
(60, 61, '2026-01-20', 'Aceptada'), (60, 119, '2026-03-28', 'Aceptada'), (60, 124, '2026-04-15', 'Aceptada'),

(61, 62, '2026-01-25', 'Aceptada'), (61, 125, '2026-04-18', 'Aceptada'), (61, 130, '2026-05-01', 'Aceptada'),
(62, 63, '2026-01-28', 'Aceptada'), (62, 126, '2026-04-20', 'Pendiente'), (62, 131, '2026-05-04', 'Aceptada'),
(63, 64, '2026-02-02', 'Aceptada'), (63, 127, '2026-04-22', 'Aceptada'), (63, 132, '2026-05-08', 'Pendiente'),
(64, 65, '2026-02-06', 'Aceptada'), (64, 128, '2026-04-25', 'Aceptada'), (64, 133, '2026-05-12', 'Aceptada'),
(65, 66, '2026-02-10', 'Aceptada'), (65, 129, '2026-04-28', 'Aceptada'), (65, 134, '2026-05-15', 'Aceptada'),

(66, 67, '2026-02-14', 'Aceptada'), (66, 135, '2026-05-18', 'Aceptada'), (66, 140, '2026-06-01', 'Aceptada'),
(67, 68, '2026-02-18', 'Aceptada'), (67, 136, '2026-05-20', 'Pendiente'), (67, 141, '2026-06-05', 'Pendiente'),
(68, 69, '2026-02-22', 'Aceptada'), (68, 137, '2026-05-22', 'Aceptada'), (68, 142, '2026-06-08', 'Aceptada'),
(69, 70, '2026-02-25', 'Aceptada'), (69, 138, '2026-05-25', 'Aceptada'), (69, 143, '2026-06-12', 'Aceptada'),
(70, 71, '2026-03-01', 'Aceptada'), (70, 139, '2026-05-28', 'Bloqueada'), (70, 144, '2026-06-15', 'Aceptada'),
(71, 72, '2026-03-05', 'Aceptada'), (71, 145, '2026-06-18', 'Aceptada'), (71, 150, '2026-07-01', 'Aceptada'),
(72, 73, '2026-03-08', 'Aceptada'), (72, 146, '2026-06-20', 'Pendiente'), (72, 151, '2026-07-05', 'Aceptada'),
(73, 74, '2026-03-12', 'Aceptada'), (73, 147, '2026-06-22', 'Aceptada'), (73, 152, '2026-07-08', 'Pendiente'),
(74, 75, '2026-03-15', 'Aceptada'), (74, 148, '2026-06-25', 'Aceptada'), (74, 153, '2026-07-12', 'Aceptada'),
(75, 76, '2026-03-20', 'Aceptada'), (75, 149, '2026-06-28', 'Aceptada'), (75, 154, '2026-07-15', 'Aceptada'),

(76, 77, '2026-03-25', 'Aceptada'), (76, 155, '2026-07-18', 'Aceptada'), (76, 160, '2026-08-01', 'Pendiente'),
(77, 78, '2026-03-28', 'Aceptada'), (77, 156, '2026-07-20', 'Pendiente'), (77, 161, '2026-08-05', 'Aceptada'),
(78, 79, '2026-04-02', 'Aceptada'), (78, 157, '2026-07-22', 'Aceptada'), (78, 162, '2026-08-08', 'Aceptada'),
(79, 80, '2026-04-05', 'Aceptada'), (79, 158, '2026-07-25', 'Aceptada'), (79, 163, '2026-08-12', 'Bloqueada'),
(80, 81, '2026-04-10', 'Aceptada'), (80, 159, '2026-07-28', 'Aceptada'), (80, 164, '2026-08-15', 'Aceptada'),

(81, 82, '2026-04-15', 'Aceptada'), (81, 165, '2026-08-18', 'Aceptada'), (81, 170, '2026-09-01', 'Aceptada'),
(82, 83, '2026-04-18', 'Aceptada'), (82, 166, '2026-08-20', 'Pendiente'), (82, 171, '2026-09-04', 'Aceptada'),
(83, 84, '2026-04-22', 'Aceptada'), (83, 167, '2026-08-22', 'Aceptada'), (83, 172, '2026-09-08', 'Pendiente'),
(84, 85, '2026-04-25', 'Aceptada'), (84, 168, '2026-08-25', 'Aceptada'), (84, 173, '2026-09-12', 'Aceptada'),
(85, 86, '2026-04-28', 'Aceptada'), (85, 169, '2026-08-28', 'Aceptada'), (85, 174, '2026-09-15', 'Aceptada'),

(86, 87, '2026-05-02', 'Aceptada'), (86, 175, '2026-09-18', 'Aceptada'), (86, 180, '2026-10-01', 'Aceptada'),
(87, 88, '2026-05-05', 'Aceptada'), (87, 176, '2026-09-20', 'Pendiente'), (87, 181, '2026-10-03', 'Pendiente'),
(88, 89, '2026-05-10', 'Aceptada'), (88, 177, '2026-09-22', 'Aceptada'), (88, 182, '2026-10-05', 'Aceptada'),
(89, 90, '2026-05-15', 'Aceptada'), (89, 178, '2026-09-25', 'Aceptada'), (89, 183, '2026-10-07', 'Aceptada'),
(90, 91, '2026-05-18', 'Aceptada'), (90, 179, '2026-09-28', 'Bloqueada'), (90, 184, '2026-10-08', 'Aceptada'),

(91, 92, '2026-05-22', 'Aceptada'), (91, 185, '2026-10-09', 'Aceptada'), (91, 190, '2026-10-12', 'Aceptada'),
(92, 93, '2026-05-25', 'Aceptada'), (92, 186, '2026-10-10', 'Pendiente'), (92, 191, '2026-10-12', 'Aceptada'),
(93, 94, '2026-05-28', 'Aceptada'), (93, 187, '2026-10-10', 'Aceptada'), (93, 192, '2026-10-13', 'Pendiente'),
(94, 95, '2026-06-01', 'Aceptada'), (94, 188, '2026-10-11', 'Aceptada'), (94, 193, '2026-10-13', 'Aceptada'),
(95, 96, '2026-06-05', 'Aceptada'), (95, 189, '2026-10-11', 'Aceptada'), (95, 194, '2026-10-13', 'Aceptada'),

(96, 97, '2026-06-08', 'Aceptada'), (96, 195, '2026-10-12', 'Aceptada'), (96, 200, '2026-10-14', 'Pendiente'),
(97, 98, '2026-06-12', 'Aceptada'), (97, 196, '2026-10-12', 'Pendiente'), (97, 201, '2026-10-14', 'Aceptada'),
(98, 99, '2026-06-15', 'Aceptada'), (98, 197, '2026-10-13', 'Aceptada'), (98, 202, '2026-10-14', 'Aceptada'),
(99, 100, '2026-06-18', 'Aceptada'), (99, 198, '2026-10-13', 'Aceptada'), (99, 203, '2026-10-15', 'Bloqueada'),
(100, 101, '2026-06-22', 'Aceptada'), (100, 199, '2026-10-13', 'Aceptada'), (100, 204, '2026-10-15', 'Aceptada'),

(101, 205, '2026-10-15', 'Aceptada'), (102, 206, '2026-10-15', 'Aceptada'), (103, 207, '2026-10-15', 'Pendiente'),
(104, 208, '2026-10-15', 'Aceptada'), (105, 209, '2026-10-15', 'Aceptada'), (106, 210, '2026-10-15', 'Aceptada'),
(107, 211, '2026-10-15', 'Pendiente'), (108, 212, '2026-10-15', 'Aceptada'), (109, 213, '2026-10-15', 'Aceptada'),
(110, 214, '2026-10-15', 'Aceptada'), (111, 215, '2026-10-15', 'Aceptada'), (112, 216, '2026-10-15', 'Pendiente'),
(113, 217, '2026-10-15', 'Aceptada'), (114, 218, '2026-10-15', 'Aceptada'), (115, 219, '2026-10-15', 'Bloqueada'),
(116, 220, '2026-10-15', 'Aceptada'), (117, 221, '2026-10-15', 'Aceptada'), (118, 222, '2026-10-15', 'Aceptada'),
(119, 223, '2026-10-15', 'Aceptada'), (120, 224, '2026-10-15', 'Aceptada'), (121, 225, '2026-10-16', 'Pendiente'),
(122, 226, '2026-10-16', 'Aceptada'), (123, 227, '2026-10-16', 'Aceptada'), (124, 228, '2026-10-16', 'Pendiente'),
(125, 229, '2026-10-16', 'Aceptada'), (126, 230, '2026-10-16', 'Aceptada'), (127, 231, '2026-10-16', 'Aceptada'),
(128, 232, '2026-10-16', 'Aceptada'), (129, 233, '2026-10-16', 'Pendiente'), (130, 234, '2026-10-16', 'Aceptada'),
(131, 235, '2026-10-16', 'Aceptada'), (132, 236, '2026-10-16', 'Aceptada'), (133, 237, '2026-10-16', 'Bloqueada'),
(134, 238, '2026-10-16', 'Aceptada'), (135, 239, '2026-10-16', 'Aceptada'), (136, 240, '2026-10-16', 'Aceptada'),
(137, 241, '2026-10-16', 'Aceptada'), (138, 242, '2026-10-16', 'Aceptada'), (139, 243, '2026-10-16', 'Pendiente'),
(140, 244, '2026-10-16', 'Aceptada'), (141, 245, '2026-10-16', 'Pendiente'), (142, 246, '2026-10-16', 'Aceptada'),
(143, 247, '2026-10-16', 'Aceptada'), (144, 248, '2026-10-16', 'Aceptada'), (145, 249, '2026-10-16', 'Aceptada'),
(146, 250, '2026-10-16', 'Aceptada');
 /* =====================================================================
   BLOQUE 7: Librería, Lista de Deseos, Carrito y Reseñas
   Proyecto Fase 2 · ConeSTeam · Semestre I-2026
   ===================================================================== */

/* ---------------------------- 1. Biblioteca -------------------------- */
-- Juegos que poseen los usuarios en su biblioteca digital

INSERT INTO Biblioteca (Horas_Jugadas, Fecha_Ultima_Sesion, ID_Usuario_FK, ID_Producto_FK) VALUES
(13, '2026-05-11', 1, 309 ),
(13, '2026-05-11', 2, 309 ),
(13, '2026-05-11', 3, 309 ),
(13, '2026-05-11', 251, 2 ),
(11, '2026-05-14', 252, 1 ),
(120, '2026-05-10', 1, 1),  
(45,  '2026-06-12', 1, 3), 
(45,  '2026-06-13', 1, 4),
(45,  '2026-06-11', 1, 7),
(210, '2026-07-01', 2, 5),
(21, '2026-09-01', 2, 3), 
(41, '2026-09-01', 2, 4),  
(15,  '2026-08-15', 2, 6),   
(350, '2026-09-02', 3, 7),  
(80,  '2026-09-10', 3, 8),   
(500, '2026-10-01', 4, 9),   
(65,  '2026-08-20', 5, 10),  
(90,  '2026-09-05', 6, 11), 
(300, '2026-10-05', 7, 12), 
(150, '2026-10-15', 1, 301),
(45,  '2026-10-10', 2, 301),
(320, '2026-10-17', 3, 301),
(12,  '2026-09-28', 4, 301),
(88,  '2026-10-16', 5, 301),
(210, '2026-10-01', 6, 301),
(5,   '2026-08-20', 7, 301);

INSERT INTO Biblioteca (Horas_Jugadas, Fecha_Ultima_Sesion, ID_Usuario_FK, ID_Producto_FK) 
VALUES (50, '2026-10-01', 4, 310); 

INSERT INTO Biblioteca (Horas_Jugadas, Fecha_Ultima_Sesion, ID_Usuario_FK, ID_Producto_FK) 
VALUES (20, '2026-10-02', 6, 311); 

INSERT INTO Biblioteca (Horas_Jugadas, Fecha_Ultima_Sesion, ID_Usuario_FK, ID_Producto_FK) 
VALUES (80, '2026-10-03', 9, 312); 

INSERT INTO Biblioteca (Horas_Jugadas, Fecha_Ultima_Sesion, ID_Usuario_FK, ID_Producto_FK) 
VALUES (10, '2026-10-04', 13, 313); 

INSERT INTO Biblioteca (Horas_Jugadas, Fecha_Ultima_Sesion, ID_Usuario_FK, ID_Producto_FK) 
VALUES (100, '2026-10-05', 20, 314); 
/* --------------------------- 2. Lista_Deseos ------------------------- */

INSERT INTO Lista_Deseos (Fecha_Agregado, Notificar_Descuento, ID_Usuario_FK, ID_Producto_FK)
SELECT TOP 350
    DATEADD(day, - (ABS(CHECKSUM(NEWID())) % 400), '2026-10-01'),
    ABS(CHECKSUM(NEWID())) % 2,
    u.Id_Usuario,
    p.ID_Producto
FROM (SELECT TOP 10 Id_Usuario FROM Usuario ORDER BY NEWID()) u
CROSS JOIN (SELECT TOP 50 ID_Producto FROM Producto_Digital ORDER BY NEWID()) p;

/* ----------------------------- 3. Carrito ---------------------------- */

INSERT INTO Carrito (Fecha_Agregado, ID_Usuario_FK, ID_Producto_FK)
SELECT TOP 180
    DATEADD(day, - (ABS(CHECKSUM(NEWID())) % 15), '2026-10-16'),
    u.Id_Usuario,
    p.ID_Producto
FROM (SELECT TOP 6 Id_Usuario FROM Usuario ORDER BY NEWID()) u
CROSS JOIN (SELECT TOP 30 ID_Producto FROM Producto_Digital ORDER BY NEWID()) p;



/* ------------------------------ HISTORIAL_DESCUENTO -------------------*/
INSERT INTO Historial_Descuento (Fecha_Inicio, Fecha_Fin, Porcentaje_Descuento, Nombre_Evento, ID_Producto_FK)
SELECT 
    c.Fecha_Inicio, 
    c.Fecha_Fin, 
    c.Porcentaje_Descuento, 
    c.Nombre_Evento,
    p.ID_Producto
FROM (
    VALUES 
        ('2024-06-25', '2024-07-09', 25.00, 'Steam Summer Sale 2024'),
        ('2024-10-25', '2024-11-01', 15.00, 'Halloween Fest 2024'),
        ('2024-12-20', '2025-01-03', 30.00, 'Winter Sale 2024'),
        ('2025-03-15', '2025-03-22', 20.00, 'Spring Kickoff 2025'),
        ('2025-06-24', '2025-07-08', 25.00, 'Steam Summer Sale 2025'),
        ('2025-11-20', '2025-11-28', 40.00, 'Black Friday 2025'),
        ('2025-12-19', '2026-01-02', 30.00, 'Winter Sale 2025'),
        ('2026-06-23', '2026-07-07', 25.00, 'Steam Summer Sale 2026')
) AS c(Fecha_Inicio, Fecha_Fin, Porcentaje_Descuento, Nombre_Evento)
CROSS JOIN (SELECT TOP 50 ID_Producto FROM Producto_Digital ORDER BY ID_Producto) p;


/* ------------------------------ REGISTRO_CONCURRECIA ---------------------------- */

INSERT INTO Registro_Concurrencia (Fecha_Registro, Pico_Maximo_Jugadores, ID_Producto_FK)
SELECT 
    DATEADD(day, -n.num, '2026-10-16'),
    ABS(CHECKSUM(NEWID())) % 15000 + 200,
    p.ID_Producto
FROM (
    SELECT TOP 30 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 AS num FROM sys.objects
) n
CROSS JOIN (SELECT TOP 50 ID_Producto FROM Producto_Digital ORDER BY ID_Producto) p;



/* ------------------------------ 4. Resena ---------------------------- */
-- Reseñas y calificaciones de los usuarios sobre los productos
INSERT INTO Resena (Texto_Resena, Calificacion_1_10, Fecha_Publicacion, Es_Critica_Especializada, ID_Usuario_FK, ID_Producto_FK) VALUES
 ('Una obra maestra visual y narrativa, a pesar de sus bugs iniciales.', 9, '2023-02-01', 0, 1, 1),
 ('Desafiante, hermoso y completamente adictivo. De lo mejor de FromSoftware.', 10, '2023-03-10', 0, 1, 3),
 ('Juego legendario, las historias secundarias superan a la principal.', 10, '2023-04-05', 1, 3, 5),
 ('La mejor experiencia de puzles cooperativos jamás creada.', 10, '2023-05-12', 0, 3, 6);
 /* =====================================================================
   BLOQUE 8: Facturas, Detalles de Factura y Reembolsos
   Proyecto Fase 2 · ConeSTeam · Semestre I-2026
   ===================================================================== */

/* ----------------------------- 1. Factura ---------------------------- */

SET IDENTITY_INSERT Factura ON;

INSERT INTO Factura (ID_Factura, Codigo_Transaccion, Fecha_Hora_Emision, Sub_Total, Monto_Descuento, Monto_Impuesto, Total_Pagado, ID_Usuario_FK, ID_Metodo_Pago_FK) VALUES
(1, 98001, '2024-10-18 14:30:00', 59.99, 0.00, 9.60, 69.59, 1, 1),
(2, 98002, '2024-10-22 19:15:00', 39.98, 5.00, 5.59, 40.57, 2, 2),
(3, 98003, '2024-11-05 10:45:00', 19.99, 0.00, 3.20, 23.19, 3, 3),
(4, 98004, '2024-11-12 16:20:00', 89.97, 15.00, 12.00, 86.97, 4, 1),
(5, 98005, '2024-11-20 21:10:00', 29.99, 5.00, 4.00, 28.99, 5, 4),
(6, 98006, '2024-12-02 12:00:00', 49.99, 10.00, 6.40, 46.39, 6, 2),
(7, 98007, '2024-12-10 18:30:00', 119.96, 20.00, 15.99, 115.95, 7, 1),
(8, 98008, '2024-12-18 15:45:00', 14.99, 0.00, 2.40, 17.39, 8, 5),
(9, 98009, '2024-12-25 09:30:00', 69.98, 10.00, 9.60, 69.58, 9, 3),
(10, 98010, '2025-01-05 22:10:00', 39.99, 0.00, 6.40, 46.39, 10, 1),
(11, 98011, '2025-01-12 14:00:00', 79.98, 15.00, 10.40, 75.38, 11, 2),
(12, 98012, '2025-01-20 17:50:00', 19.99, 0.00, 3.20, 23.19, 12, 4),
(13, 98013, '2025-01-28 11:15:00', 59.99, 10.00, 8.00, 57.99, 13, 1),
(14, 98014, '2025-02-04 16:40:00', 99.95, 25.00, 12.00, 86.95, 14, 3),
(15, 98015, '2025-02-12 20:30:00', 24.99, 0.00, 4.00, 28.99, 15, 2),
(16, 98016, '2025-02-19 13:20:00', 49.99, 5.00, 7.20, 52.19, 16, 5),
(17, 98017, '2025-02-27 15:10:00', 34.99, 0.00, 5.60, 40.59, 17, 1),
(18, 98018, '2025-03-05 18:00:00', 129.97, 30.00, 16.00, 115.97, 18, 2),
(19, 98019, '2025-03-12 21:40:00', 19.99, 0.00, 3.20, 23.19, 19, 3),
(20, 98020, '2025-03-19 10:15:00', 59.99, 10.00, 8.00, 57.99, 20, 4),
(21, 98021, '2025-03-26 14:50:00', 44.98, 5.00, 6.40, 46.38, 21, 1),
(22, 98022, '2025-04-02 19:25:00', 89.99, 20.00, 11.20, 81.19, 22, 2),
(23, 98023, '2025-04-10 11:10:00', 15.99, 0.00, 2.56, 18.55, 23, 3),
(24, 98024, '2025-04-18 16:35:00', 69.98, 15.00, 8.80, 63.78, 24, 1),
(25, 98025, '2025-04-25 22:00:00', 29.99, 0.00, 4.80, 34.79, 25, 5),
(26, 98026, '2025-05-02 13:15:00', 59.99, 10.00, 8.00, 57.99, 26, 2),
(27, 98027, '2025-05-10 17:40:00', 109.96, 25.00, 13.60, 98.56, 27, 1),
(28, 98028, '2025-05-18 20:10:00', 19.99, 0.00, 3.20, 23.19, 28, 3),
(29, 98029, '2025-05-25 15:20:00', 49.99, 5.00, 7.20, 52.19, 29, 4),
(30, 98030, '2025-06-02 11:45:00', 79.98, 20.00, 9.60, 69.58, 30, 1),
(31, 98031, '2025-06-10 16:30:00', 39.99, 0.00, 6.40, 46.39, 31, 2),
(32, 98032, '2025-06-18 19:15:00', 89.97, 15.00, 12.00, 86.97, 32, 5),
(33, 98033, '2025-06-25 12:10:00', 14.99, 0.00, 2.40, 17.39, 33, 1),
(34, 98034, '2025-07-03 15:50:00', 59.99, 10.00, 8.00, 57.99, 34, 3),
(35, 98035, '2025-07-11 21:20:00', 69.98, 15.00, 8.80, 63.78, 35, 2),
(36, 98036, '2025-07-19 14:00:00', 29.99, 0.00, 4.80, 34.79, 36, 4),
(37, 98037, '2025-07-27 18:35:00', 99.95, 30.00, 11.20, 81.15, 37, 1),
(38, 98038, '2025-08-04 10:25:00', 19.99, 0.00, 3.20, 23.19, 38, 2),
(39, 98039, '2025-08-12 16:15:00', 49.99, 5.00, 7.20, 52.19, 39, 3),
(40, 98040, '2025-08-20 20:50:00', 79.98, 20.00, 9.60, 69.58, 40, 1),
(41, 98041, '2025-08-28 13:40:00', 39.99, 0.00, 6.40, 46.39, 41, 5),
(42, 98042, '2025-09-05 17:00:00', 59.99, 10.00, 8.00, 57.99, 42, 2),
(43, 98043, '2025-09-13 11:30:00', 119.96, 35.00, 13.60, 98.56, 43, 1),
(44, 98044, '2025-09-21 15:10:00', 24.99, 0.00, 4.00, 28.99, 44, 3),
(45, 98045, '2025-09-29 19:45:00', 69.98, 15.00, 8.80, 63.78, 45, 4),
(46, 98046, '2025-10-06 12:20:00', 49.99, 5.00, 7.20, 52.19, 46, 1),
(47, 98047, '2025-10-14 16:00:00', 89.99, 20.00, 11.20, 81.19, 47, 2),
(48, 98048, '2025-10-22 21:15:00', 19.99, 0.00, 3.20, 23.19, 48, 3),
(49, 98049, '2025-10-30 14:30:00', 59.99, 10.00, 8.00, 57.99, 49, 1),
(50, 98050, '2025-11-07 18:10:00', 129.97, 40.00, 14.40, 104.37, 50, 5),
(51, 98051, '2025-11-15 14:20:00', 49.99, 5.00, 7.20, 52.19, 51, 1),
(52, 98052, '2025-11-22 18:40:00', 79.98, 15.00, 10.40, 75.38, 52, 2),
(53, 98053, '2025-11-30 11:10:00', 19.99, 0.00, 3.20, 23.19, 53, 3),
(54, 98054, '2025-12-08 16:30:00', 99.96, 20.00, 12.80, 92.76, 54, 1),
(55, 98055, '2025-12-14 20:15:00', 34.99, 0.00, 5.60, 40.59, 55, 4),
(56, 98056, '2025-12-21 12:50:00', 59.99, 10.00, 8.00, 57.99, 56, 2),
(57, 98057, '2025-12-28 17:00:00', 89.97, 15.00, 12.00, 86.97, 57, 1),
(58, 98058, '2026-01-04 15:30:00', 14.99, 0.00, 2.40, 17.39, 58, 5),
(59, 98059, '2026-01-11 10:20:00', 69.98, 10.00, 9.60, 69.58, 59, 3),
(60, 98060, '2026-01-18 21:40:00', 49.99, 0.00, 8.00, 57.99, 60, 1),
(61, 98061, '2026-01-25 13:10:00', 79.98, 15.00, 10.40, 75.38, 61, 2),
(62, 98062, '2026-02-02 16:50:00', 29.99, 0.00, 4.80, 34.79, 62, 4),
(63, 98063, '2026-02-09 11:30:00', 59.99, 10.00, 8.00, 57.99, 63, 1),
(64, 98064, '2026-02-16 19:20:00', 109.95, 25.00, 13.60, 98.55, 64, 3),
(65, 98065, '2026-02-23 14:15:00', 24.99, 0.00, 4.00, 28.99, 65, 2),
(66, 98066, '2026-03-02 17:45:00', 49.99, 5.00, 7.20, 52.19, 66, 5),
(67, 98067, '2026-03-09 12:00:00', 39.99, 0.00, 6.40, 46.39, 67, 1),
(68, 98068, '2026-03-16 18:30:00', 119.97, 30.00, 14.40, 104.37, 68, 2),
(69, 98069, '2026-03-23 15:10:00', 19.99, 0.00, 3.20, 23.19, 69, 3),
(70, 98070, '2026-03-30 20:00:00', 59.99, 10.00, 8.00, 57.99, 70, 4),
(71, 98071, '2026-04-06 13:25:00', 44.98, 5.00, 6.40, 46.38, 71, 1),
(72, 98072, '2026-04-13 17:15:00', 89.99, 20.00, 11.20, 81.19, 72, 2),
(73, 98073, '2026-04-20 11:40:00', 15.99, 0.00, 2.56, 18.55, 73, 3),
(74, 98074, '2026-04-27 16:50:00', 69.98, 15.00, 8.80, 63.78, 74, 1),
(75, 98075, '2026-05-04 21:10:00', 39.99, 0.00, 6.40, 46.39, 75, 5),
(76, 98076, '2026-05-11 14:30:00', 59.99, 10.00, 8.00, 57.99, 76, 2),
(77, 98077, '2026-05-18 18:20:00', 99.96, 20.00, 12.80, 92.76, 77, 1),
(78, 98078, '2026-05-25 10:15:00', 19.99, 0.00, 3.20, 23.19, 78, 3),
(79, 98079, '2026-06-01 15:45:00', 49.99, 5.00, 7.20, 52.19, 79, 4),
(80, 98080, '2026-06-08 19:55:00', 79.98, 20.00, 9.60, 69.58, 80, 1),
(81, 98081, '2026-06-15 12:10:00', 39.99, 0.00, 6.40, 46.39, 81, 2),
(82, 98082, '2026-06-22 16:40:00', 89.97, 15.00, 12.00, 86.97, 82, 5),
(83, 98083, '2026-06-29 11:20:00', 14.99, 0.00, 2.40, 17.39, 83, 1),
(84, 98084, '2026-07-06 15:00:00', 59.99, 10.00, 8.00, 57.99, 84, 3),
(85, 98085, '2026-07-13 20:30:00', 69.98, 15.00, 8.80, 63.78, 85, 2),
(86, 98086, '2026-07-20 13:15:00', 29.99, 0.00, 4.80, 34.79, 86, 4),
(87, 98087, '2026-07-27 17:50:00', 99.95, 30.00, 11.20, 81.15, 87, 1),
(88, 98088, '2026-08-03 09:40:00', 19.99, 0.00, 3.20, 23.19, 88, 2),
(89, 98089, '2026-08-10 14:25:00', 49.99, 5.00, 7.20, 52.19, 89, 3),
(90, 98090, '2026-08-17 19:10:00', 79.98, 20.00, 9.60, 69.58, 90, 1),
(91, 98091, '2026-08-24 12:00:00', 39.99, 0.00, 6.40, 46.39, 91, 5),
(92, 98092, '2026-08-31 16:30:00', 59.99, 10.00, 8.00, 57.99, 92, 2),
(93, 98093, '2026-09-07 11:15:00', 119.96, 35.00, 13.60, 98.56, 93, 1),
(94, 98094, '2026-09-14 15:40:00', 24.99, 0.00, 4.00, 28.99, 94, 3),
(95, 98095, '2026-09-21 20:10:00', 69.98, 15.00, 8.80, 63.78, 95, 4),
(96, 98096, '2026-09-28 13:00:00', 49.99, 5.00, 7.20, 52.19, 96, 1),
(97, 98097, '2026-10-02 16:45:00', 89.99, 20.00, 11.20, 81.19, 97, 2),
(98, 98098, '2026-10-08 21:00:00', 19.99, 0.00, 3.20, 23.19, 98, 3),
(99, 98099, '2026-10-12 14:20:00', 59.99, 10.00, 8.00, 57.99, 99, 1),
(100, 98100, '2026-10-15 18:30:00', 129.97, 40.00, 14.40, 104.37, 100, 5),
(101, 98101, '2026-10-13 10:15:00', 49.99, 5.00, 7.20, 52.19, 101, 1),
(102, 98102, '2026-10-13 11:30:00', 79.98, 15.00, 10.40, 75.38, 102, 2),
(103, 98103, '2026-10-13 12:45:00', 19.99, 0.00, 3.20, 23.19, 103, 3),
(104, 98104, '2026-10-13 14:00:00', 99.96, 20.00, 12.80, 92.76, 104, 1),
(105, 98105, '2026-10-13 15:15:00', 34.99, 0.00, 5.60, 40.59, 105, 4),
(106, 98106, '2026-10-13 16:30:00', 59.99, 10.00, 8.00, 57.99, 106, 2),
(107, 98107, '2026-10-13 17:45:00', 89.97, 15.00, 12.00, 86.97, 107, 1),
(108, 98108, '2026-10-13 19:00:00', 14.99, 0.00, 2.40, 17.39, 108, 5),
(109, 98109, '2026-10-13 20:15:00', 69.98, 10.00, 9.60, 69.58, 109, 3),
(110, 98110, '2026-10-13 21:30:00', 49.99, 0.00, 8.00, 57.99, 110, 1),
(111, 98111, '2026-10-14 09:15:00', 79.98, 15.00, 10.40, 75.38, 111, 2),
(112, 98112, '2026-10-14 10:30:00', 29.99, 0.00, 4.80, 34.79, 112, 4),
(113, 98113, '2026-10-14 11:45:00', 59.99, 10.00, 8.00, 57.99, 113, 1),
(114, 98114, '2026-10-14 13:00:00', 109.95, 25.00, 13.60, 98.55, 114, 3),
(115, 98115, '2026-10-14 14:15:00', 24.99, 0.00, 4.00, 28.99, 115, 2),
(116, 98116, '2026-10-14 15:30:00', 49.99, 5.00, 7.20, 52.19, 116, 5),
(117, 98117, '2026-10-14 16:45:00', 39.99, 0.00, 6.40, 46.39, 117, 1),
(118, 98118, '2026-10-14 18:00:00', 119.97, 30.00, 14.40, 104.37, 118, 2),
(119, 98119, '2026-10-14 19:15:00', 19.99, 0.00, 3.20, 23.19, 119, 3),
(120, 98120, '2026-10-14 20:30:00', 59.99, 10.00, 8.00, 57.99, 120, 4),
(121, 98121, '2026-10-15 09:30:00', 44.98, 5.00, 6.40, 46.38, 121, 1),
(122, 98122, '2026-10-15 10:45:00', 89.99, 20.00, 11.20, 81.19, 122, 2),
(123, 98123, '2026-10-15 12:00:00', 15.99, 0.00, 2.56, 18.55, 123, 3),
(124, 98124, '2026-10-15 13:15:00', 69.98, 15.00, 8.80, 63.78, 124, 1),
(125, 98125, '2026-10-15 14:30:00', 39.99, 0.00, 6.40, 46.39, 125, 5),
(126, 98126, '2026-10-15 15:45:00', 59.99, 10.00, 8.00, 57.99, 126, 2),
(127, 98127, '2026-10-15 17:00:00', 99.96, 20.00, 12.80, 92.76, 127, 1),
(128, 98128, '2026-10-15 18:15:00', 19.99, 0.00, 3.20, 23.19, 128, 3),
(129, 98129, '2026-10-15 19:30:00', 49.99, 5.00, 7.20, 52.19, 129, 4),
(130, 98130, '2026-10-15 20:45:00', 79.98, 20.00, 9.60, 69.58, 130, 1),
(131, 98131, '2026-10-16 09:00:00', 39.99, 0.00, 6.40, 46.39, 131, 2),
(132, 98132, '2026-10-16 10:15:00', 89.97, 15.00, 12.00, 86.97, 132, 5),
(133, 98133, '2026-10-16 11:30:00', 14.99, 0.00, 2.40, 17.39, 133, 1),
(134, 98134, '2026-10-16 12:45:00', 59.99, 10.00, 8.00, 57.99, 134, 3),
(135, 98135, '2026-10-16 14:00:00', 69.98, 15.00, 8.80, 63.78, 135, 2),
(136, 98136, '2026-10-16 15:15:00', 29.99, 0.00, 4.80, 34.79, 136, 4),
(137, 98137, '2026-10-16 16:30:00', 99.95, 30.00, 11.20, 81.15, 137, 1),
(138, 98138, '2026-10-16 17:45:00', 19.99, 0.00, 3.20, 23.19, 138, 2),
(139, 98139, '2026-10-16 19:00:00', 49.99, 5.00, 7.20, 52.19, 139, 3),
(140, 98140, '2026-10-16 20:00:00', 79.98, 20.00, 9.60, 69.58, 140, 1),
(141, 98141, '2026-10-16 20:15:00', 39.99, 0.00, 6.40, 46.39, 141, 5),
(142, 98142, '2026-10-16 20:30:00', 59.99, 10.00, 8.00, 57.99, 142, 2),
(143, 98143, '2026-10-16 20:45:00', 119.96, 35.00, 13.60, 98.56, 143, 1),
(144, 98144, '2026-10-16 21:00:00', 24.99, 0.00, 4.00, 28.99, 144, 3),
(145, 98145, '2026-10-16 21:15:00', 69.98, 15.00, 8.80, 63.78, 145, 4),
(146, 98146, '2026-10-16 21:30:00', 49.99, 5.00, 7.20, 52.19, 146, 1),
(147, 98147, '2026-10-16 21:45:00', 89.99, 20.00, 11.20, 81.19, 147, 2),
(148, 98148, '2026-10-16 22:00:00', 19.99, 0.00, 3.20, 23.19, 148, 3),
(149, 98149, '2026-10-16 22:15:00', 59.99, 10.00, 8.00, 57.99, 149, 1),
(150, 98150, '2026-10-16 22:30:00', 129.97, 40.00, 14.40, 104.37, 150, 5),
(151, 98151, '2024-11-02 10:15:00', 49.99, 5.00, 7.20, 52.19, 151, 1),
(152, 98152, '2024-11-15 14:30:00', 79.98, 15.00, 10.40, 75.38, 152, 2),
(153, 98153, '2024-11-28 11:45:00', 19.99, 0.00, 3.20, 23.19, 153, 3),
(154, 98154, '2024-12-10 16:20:00', 99.96, 20.00, 12.80, 92.76, 154, 1),
(155, 98155, '2024-12-22 20:00:00', 34.99, 0.00, 5.60, 40.59, 155, 4),
(156, 98156, '2025-01-08 12:10:00', 59.99, 10.00, 8.00, 57.99, 156, 2),
(157, 98157, '2025-01-21 17:35:00', 89.97, 15.00, 12.00, 86.97, 157, 1),
(158, 98158, '2025-02-03 15:50:00', 14.99, 0.00, 2.40, 17.39, 158, 5),
(159, 98159, '2025-02-16 10:25:00', 69.98, 10.00, 9.60, 69.58, 159, 3),
(160, 98160, '2025-03-01 21:15:00', 49.99, 0.00, 8.00, 57.99, 160, 1),
(161, 98161, '2025-03-14 13:40:00', 79.98, 15.00, 10.40, 75.38, 161, 2),
(162, 98162, '2025-03-27 16:05:00', 29.99, 0.00, 4.80, 34.79, 162, 4),
(163, 98163, '2025-04-09 11:30:00', 59.99, 10.00, 8.00, 57.99, 163, 1),
(164, 98164, '2025-04-22 19:45:00', 109.95, 25.00, 13.60, 98.55, 164, 3),
(165, 98165, '2025-05-05 14:20:00', 24.99, 0.00, 4.00, 28.99, 165, 2),
(166, 98166, '2025-05-18 18:10:00', 49.99, 5.00, 7.20, 52.19, 166, 5),
(167, 98167, '2025-05-31 12:00:00', 39.99, 0.00, 6.40, 46.39, 167, 1),
(168, 98168, '2025-06-13 18:25:00', 119.97, 30.00, 14.40, 104.37, 168, 2),
(169, 98169, '2025-06-26 15:10:00', 19.99, 0.00, 3.20, 23.19, 169, 3),
(170, 98170, '2025-07-09 20:30:00', 59.99, 10.00, 8.00, 57.99, 170, 4),
(171, 98171, '2025-07-22 09:45:00', 44.98, 5.00, 6.40, 46.38, 171, 1),
(172, 98172, '2025-08-04 10:50:00', 89.99, 20.00, 11.20, 81.19, 172, 2),
(173, 98173, '2025-08-17 12:15:00', 15.99, 0.00, 2.56, 18.55, 173, 3),
(174, 98174, '2025-08-30 13:40:00', 69.98, 15.00, 8.80, 63.78, 174, 1),
(175, 98175, '2025-09-12 14:55:00', 39.99, 0.00, 6.40, 46.39, 175, 5),
(176, 98176, '2025-09-25 15:30:00', 59.99, 10.00, 8.00, 57.99, 176, 2),
(177, 98177, '2025-10-08 17:10:00', 99.96, 20.00, 12.80, 92.76, 177, 1),
(178, 98178, '2025-10-21 18:25:00', 19.99, 0.00, 3.20, 23.19, 178, 3),
(179, 98179, '2025-11-03 19:40:00', 49.99, 5.00, 7.20, 52.19, 179, 4),
(180, 98180, '2025-11-16 20:50:00', 79.98, 20.00, 9.60, 69.58, 180, 1),
(181, 98181, '2025-11-29 09:10:00', 39.99, 0.00, 6.40, 46.39, 181, 2),
(182, 98182, '2025-12-12 10:20:00', 89.97, 15.00, 12.00, 86.97, 182, 5),
(183, 98183, '2025-12-25 11:35:00', 14.99, 0.00, 2.40, 17.39, 183, 1),
(184, 98184, '2026-01-07 12:50:00', 59.99, 10.00, 8.00, 57.99, 184, 3),
(185, 98185, '2026-01-20 14:05:00', 69.98, 15.00, 8.80, 63.78, 185, 2),
(186, 98186, '2026-02-02 15:20:00', 29.99, 0.00, 4.80, 34.79, 186, 4),
(187, 98187, '2026-02-15 16:35:00', 99.95, 30.00, 11.20, 81.15, 187, 1),
(188, 98188, '2026-02-28 17:50:00', 19.99, 0.00, 3.20, 23.19, 188, 2),
(189, 98189, '2026-03-13 19:00:00', 49.99, 5.00, 7.20, 52.19, 189, 3),
(190, 98190, '2026-03-26 20:15:00', 79.98, 20.00, 9.60, 69.58, 190, 1),
(191, 98191, '2026-04-08 10:30:00', 39.99, 0.00, 6.40, 46.39, 191, 5),
(192, 98192, '2026-04-21 11:45:00', 59.99, 10.00, 8.00, 57.99, 192, 2),
(193, 98193, '2026-05-04 13:00:00', 119.96, 35.00, 13.60, 98.56, 193, 1),
(194, 98194, '2026-05-17 14:15:00', 24.99, 0.00, 4.00, 28.99, 194, 3),
(195, 98195, '2026-05-30 15:30:00', 69.98, 15.00, 8.80, 63.78, 195, 4),
(196, 98196, '2026-06-12 16:45:00', 49.99, 5.00, 7.20, 52.19, 196, 1),
(197, 98197, '2026-06-25 18:00:00', 89.99, 20.00, 11.20, 81.19, 197, 2),
(198, 98198, '2026-07-08 19:15:00', 19.99, 0.00, 3.20, 23.19, 198, 3),
(199, 98199, '2026-07-21 20:30:00', 59.99, 10.00, 8.00, 57.99, 199, 1),
(200, 98200, '2026-08-03 21:45:00', 129.97, 40.00, 14.40, 104.37, 200, 5),
(201, 98201, '2024-11-10 10:30:00', 49.99, 5.00, 7.20, 52.19, 201, 1),
(202, 98202, '2024-11-22 14:15:00', 79.98, 15.00, 10.40, 75.38, 202, 2),
(203, 98203, '2024-12-05 11:50:00', 19.99, 0.00, 3.20, 23.19, 203, 3),
(204, 98204, '2024-12-18 16:40:00', 99.96, 20.00, 12.80, 92.76, 204, 1),
(205, 98205, '2024-12-30 20:10:00', 34.99, 0.00, 5.60, 40.59, 205, 4),
(206, 98206, '2025-01-12 12:25:00', 59.99, 10.00, 8.00, 57.99, 206, 2),
(207, 98207, '2025-01-25 17:40:00', 89.97, 15.00, 12.00, 86.97, 207, 1),
(208, 98208, '2025-02-07 15:15:00', 14.99, 0.00, 2.40, 17.39, 208, 5),
(209, 98209, '2025-02-20 10:30:00', 69.98, 10.00, 9.60, 69.58, 209, 3),
(210, 98210, '2025-03-05 21:20:00', 49.99, 0.00, 8.00, 57.99, 210, 1),
(211, 98211, '2025-03-18 13:45:00', 79.98, 15.00, 10.40, 75.38, 211, 2),
(212, 98212, '2025-03-31 16:10:00', 29.99, 0.00, 4.80, 34.79, 212, 4),
(213, 98213, '2025-04-13 11:35:00', 59.99, 10.00, 8.00, 57.99, 213, 1),
(214, 98214, '2025-04-26 19:50:00', 109.95, 25.00, 13.60, 98.55, 214, 3),
(215, 98215, '2025-05-09 14:25:00', 24.99, 0.00, 4.00, 28.99, 215, 2),
(216, 98216, '2025-05-22 18:15:00', 49.99, 5.00, 7.20, 52.19, 216, 5),
(217, 98217, '2025-06-04 12:05:00', 39.99, 0.00, 6.40, 46.39, 217, 1),
(218, 98218, '2025-06-17 18:30:00', 119.97, 30.00, 14.40, 104.37, 218, 2),
(219, 98219, '2025-06-30 15:15:00', 19.99, 0.00, 3.20, 23.19, 219, 3),
(220, 98220, '2025-07-13 20:35:00', 59.99, 10.00, 8.00, 57.99, 220, 4),
(221, 98221, '2025-07-26 09:50:00', 44.98, 5.00, 6.40, 46.38, 221, 1),
(222, 98222, '2025-08-08 10:55:00', 89.99, 20.00, 11.20, 81.19, 222, 2),
(223, 98223, '2025-08-21 12:20:00', 15.99, 0.00, 2.56, 18.55, 223, 3),
(224, 98224, '2025-09-03 13:45:00', 69.98, 15.00, 8.80, 63.78, 224, 1),
(225, 98225, '2025-09-16 15:00:00', 39.99, 0.00, 6.40, 46.39, 225, 5),
(226, 98226, '2025-09-29 15:35:00', 59.99, 10.00, 8.00, 57.99, 226, 2),
(227, 98227, '2025-10-12 17:15:00', 99.96, 20.00, 12.80, 92.76, 227, 1),
(228, 98228, '2025-10-25 18:30:00', 19.99, 0.00, 3.20, 23.19, 228, 3),
(229, 98229, '2025-11-07 19:45:00', 49.99, 5.00, 7.20, 52.19, 229, 4),
(230, 98230, '2025-11-20 20:55:00', 79.98, 20.00, 9.60, 69.58, 230, 1),
(231, 98231, '2025-12-03 09:15:00', 39.99, 0.00, 6.40, 46.39, 231, 2),
(232, 98232, '2025-12-16 10:25:00', 89.97, 15.00, 12.00, 86.97, 232, 5),
(233, 98233, '2025-12-29 11:40:00', 14.99, 0.00, 2.40, 17.39, 233, 1),
(234, 98234, '2026-01-11 12:55:00', 59.99, 10.00, 8.00, 57.99, 234, 3),
(235, 98235, '2026-01-24 14:10:00', 69.98, 15.00, 8.80, 63.78, 235, 2),
(236, 98236, '2026-02-06 15:25:00', 29.99, 0.00, 4.80, 34.79, 236, 4),
(237, 98237, '2026-02-19 16:40:00', 99.95, 30.00, 11.20, 81.15, 237, 1),
(238, 98238, '2026-03-04 17:55:00', 19.99, 0.00, 3.20, 23.19, 238, 2),
(239, 98239, '2026-03-17 19:05:00', 49.99, 5.00, 7.20, 52.19, 239, 3),
(240, 98240, '2026-03-30 20:20:00', 79.98, 20.00, 9.60, 69.58, 240, 1),
(241, 98241, '2026-04-12 10:35:00', 39.99, 0.00, 6.40, 46.39, 241, 5),
(242, 98242, '2026-04-25 11:50:00', 59.99, 10.00, 8.00, 57.99, 242, 2),
(243, 98243, '2026-05-08 13:05:00', 119.96, 35.00, 13.60, 98.56, 243, 1),
(244, 98244, '2026-05-21 14:20:00', 24.99, 0.00, 4.00, 28.99, 244, 3),
(245, 98245, '2026-06-03 15:35:00', 69.98, 15.00, 8.80, 63.78, 245, 4),
(246, 98246, '2026-06-16 16:50:00', 49.99, 5.00, 7.20, 52.19, 246, 1),
(247, 98247, '2026-06-29 18:05:00', 89.99, 20.00, 11.20, 81.19, 247, 2),
(248, 98248, '2026-07-12 19:20:00', 19.99, 0.00, 3.20, 23.19, 248, 3),
(249, 98249, '2026-07-25 20:35:00', 59.99, 10.00, 8.00, 57.99, 249, 1),
(250, 98250, '2026-08-07 21:50:00', 129.97, 40.00, 14.40, 104.37, 250, 5),
(251, 98251, '2024-11-18 10:15:00', 49.99, 5.00, 7.20, 52.19, 1, 1),
(252, 98252, '2024-11-29 14:30:00', 79.98, 15.00, 10.40, 75.38, 2, 2),
(253, 98253, '2024-12-12 11:45:00', 19.99, 0.00, 3.20, 23.19, 3, 3),
(254, 98254, '2024-12-24 16:20:00', 99.96, 20.00, 12.80, 92.76, 4, 1),
(255, 98255, '2025-01-05 20:00:00', 34.99, 0.00, 5.60, 40.59, 5, 4),
(256, 98256, '2025-01-18 12:10:00', 59.99, 10.00, 8.00, 57.99, 6, 2),
(257, 98257, '2025-01-31 17:35:00', 89.97, 15.00, 12.00, 86.97, 7, 1),
(258, 98258, '2025-02-12 15:50:00', 14.99, 0.00, 2.40, 17.39, 8, 5),
(259, 98259, '2025-02-25 10:25:00', 69.98, 10.00, 9.60, 69.58, 9, 3),
(260, 98260, '2025-03-08 21:15:00', 49.99, 0.00, 8.00, 57.99, 10, 1),
(261, 98261, '2025-03-21 13:40:00', 79.98, 15.00, 10.40, 75.38, 11, 2),
(262, 98262, '2025-04-03 16:05:00', 29.99, 0.00, 4.80, 34.79, 12, 4),
(263, 98263, '2025-04-16 11:30:00', 59.99, 10.00, 8.00, 57.99, 13, 1),
(264, 98264, '2025-04-29 19:45:00', 109.95, 25.00, 13.60, 98.55, 14, 3),
(265, 98265, '2025-05-12 14:20:00', 24.99, 0.00, 4.00, 28.99, 15, 2),
(266, 98266, '2025-05-25 18:10:00', 49.99, 5.00, 7.20, 52.19, 16, 5),
(267, 98267, '2025-06-07 12:00:00', 39.99, 0.00, 6.40, 46.39, 17, 1),
(268, 98268, '2025-06-20 18:25:00', 119.97, 30.00, 14.40, 104.37, 18, 2),
(269, 98269, '2025-07-03 15:10:00', 19.99, 0.00, 3.20, 23.19, 19, 3),
(270, 98270, '2025-07-16 20:30:00', 59.99, 10.00, 8.00, 57.99, 20, 4),
(271, 98271, '2025-07-29 09:45:00', 44.98, 5.00, 6.40, 46.38, 21, 1),
(272, 98272, '2025-08-11 10:50:00', 89.99, 20.00, 11.20, 81.19, 22, 2),
(273, 98273, '2025-08-24 12:15:00', 15.99, 0.00, 2.56, 18.55, 23, 3),
(274, 98274, '2025-09-06 13:40:00', 69.98, 15.00, 8.80, 63.78, 24, 1),
(275, 98275, '2025-09-19 14:55:00', 39.99, 0.00, 6.40, 46.39, 25, 5),
(276, 98276, '2025-10-02 15:30:00', 59.99, 10.00, 8.00, 57.99, 26, 2),
(277, 98277, '2025-10-15 17:10:00', 99.96, 20.00, 12.80, 92.76, 27, 1),
(278, 98278, '2025-10-28 18:25:00', 19.99, 0.00, 3.20, 23.19, 28, 3),
(279, 98279, '2025-11-10 19:40:00', 49.99, 5.00, 7.20, 52.19, 29, 4),
(280, 98280, '2025-11-23 20:50:00', 79.98, 20.00, 9.60, 69.58, 30, 1),
(281, 98281, '2025-12-06 09:10:00', 39.99, 0.00, 6.40, 46.39, 31, 2),
(282, 98282, '2025-12-19 10:20:00', 89.97, 15.00, 12.00, 86.97, 32, 5),
(283, 98283, '2026-01-01 11:35:00', 14.99, 0.00, 2.40, 17.39, 33, 1),
(284, 98284, '2026-01-14 12:50:00', 59.99, 10.00, 8.00, 57.99, 34, 3),
(285, 98285, '2026-01-27 14:05:00', 69.98, 15.00, 8.80, 63.78, 35, 2),
(286, 98286, '2026-02-09 15:20:00', 29.99, 0.00, 4.80, 34.79, 36, 4),
(287, 98287, '2026-02-22 16:35:00', 99.95, 30.00, 11.20, 81.15, 37, 1),
(288, 98288, '2026-03-07 17:50:00', 19.99, 0.00, 3.20, 23.19, 38, 2),
(289, 98289, '2026-03-20 19:00:00', 49.99, 5.00, 7.20, 52.19, 39, 3),
(290, 98290, '2026-04-02 20:15:00', 79.98, 20.00, 9.60, 69.58, 40, 1),
(291, 98291, '2026-04-15 10:30:00', 39.99, 0.00, 6.40, 46.39, 41, 5),
(292, 98292, '2026-04-28 11:45:00', 59.99, 10.00, 8.00, 57.99, 42, 2),
(293, 98293, '2026-05-11 13:00:00', 119.96, 35.00, 13.60, 98.56, 43, 1),
(294, 98294, '2026-05-24 14:15:00', 24.99, 0.00, 4.00, 28.99, 44, 3),
(295, 98295, '2026-06-06 15:30:00', 69.98, 15.00, 8.80, 63.78, 45, 4),
(296, 98296, '2026-06-19 16:45:00', 49.99, 5.00, 7.20, 52.19, 46, 1),
(297, 98297, '2026-07-02 18:00:00', 89.99, 20.00, 11.20, 81.19, 47, 2),
(298, 98298, '2026-07-15 19:15:00', 19.99, 0.00, 3.20, 23.19, 48, 3),
(299, 98299, '2026-07-28 20:30:00', 59.99, 10.00, 8.00, 57.99, 49, 1),
(300, 98300, '2026-08-10 21:45:00', 129.97, 40.00, 14.40, 104.37, 50, 5),
(301, 98301, '2024-11-20 10:15:00', 49.99, 5.00, 7.20, 52.19, 51, 1),
(302, 98302, '2024-12-01 14:30:00', 79.98, 15.00, 10.40, 75.38, 52, 2),
(303, 98303, '2024-12-14 11:45:00', 19.99, 0.00, 3.20, 23.19, 53, 3),
(304, 98304, '2024-12-26 16:20:00', 99.96, 20.00, 12.80, 92.76, 54, 1),
(305, 98305, '2025-01-08 20:00:00', 34.99, 0.00, 5.60, 40.59, 55, 4),
(306, 98306, '2025-01-20 12:10:00', 59.99, 10.00, 8.00, 57.99, 56, 2),
(307, 98307, '2025-02-02 17:35:00', 89.97, 15.00, 12.00, 86.97, 57, 1),
(308, 98308, '2025-02-15 15:50:00', 14.99, 0.00, 2.40, 17.39, 58, 5),
(309, 98309, '2025-02-28 10:25:00', 69.98, 10.00, 9.60, 69.58, 59, 3),
(310, 98310, '2025-03-12 21:15:00', 49.99, 0.00, 8.00, 57.99, 60, 1),
(311, 98311, '2025-03-25 13:40:00', 79.98, 15.00, 10.40, 75.38, 61, 2),
(312, 98312, '2025-04-07 16:05:00', 29.99, 0.00, 4.80, 34.79, 62, 4),
(313, 98313, '2025-04-20 11:30:00', 59.99, 10.00, 8.00, 57.99, 63, 1),
(314, 98314, '2025-05-03 19:45:00', 109.95, 25.00, 13.60, 98.55, 64, 3),
(315, 98315, '2025-05-16 14:20:00', 24.99, 0.00, 4.00, 28.99, 65, 2),
(316, 98316, '2025-05-29 18:10:00', 49.99, 5.00, 7.20, 52.19, 66, 5),
(317, 98317, '2025-06-11 12:00:00', 39.99, 0.00, 6.40, 46.39, 67, 1),
(318, 98318, '2025-06-24 18:25:00', 119.97, 30.00, 14.40, 104.37, 68, 2),
(319, 98319, '2025-07-07 15:10:00', 19.99, 0.00, 3.20, 23.19, 69, 3),
(320, 98320, '2025-07-20 20:30:00', 59.99, 10.00, 8.00, 57.99, 70, 4),
(321, 98321, '2025-08-02 09:45:00', 44.98, 5.00, 6.40, 46.38, 71, 1),
(322, 98322, '2025-08-15 10:50:00', 89.99, 20.00, 11.20, 81.19, 72, 2),
(323, 98323, '2025-08-28 12:15:00', 15.99, 0.00, 2.56, 18.55, 73, 3),
(324, 98324, '2025-09-10 13:40:00', 69.98, 15.00, 8.80, 63.78, 74, 1),
(325, 98325, '2025-09-23 14:55:00', 39.99, 0.00, 6.40, 46.39, 75, 5),
(326, 98326, '2025-10-06 15:30:00', 59.99, 10.00, 8.00, 57.99, 76, 2),
(327, 98327, '2025-10-19 17:10:00', 99.96, 20.00, 12.80, 92.76, 77, 1),
(328, 98328, '2025-11-01 18:25:00', 19.99, 0.00, 3.20, 23.19, 78, 3),
(329, 98329, '2025-11-14 19:40:00', 49.99, 5.00, 7.20, 52.19, 79, 4),
(330, 98330, '2025-11-27 20:50:00', 79.98, 20.00, 9.60, 69.58, 80, 1),
(331, 98331, '2025-12-10 09:10:00', 39.99, 0.00, 6.40, 46.39, 81, 2),
(332, 98332, '2025-12-23 10:20:00', 89.97, 15.00, 12.00, 86.97, 82, 5),
(333, 98333, '2026-01-05 11:35:00', 14.99, 0.00, 2.40, 17.39, 83, 1),
(334, 98334, '2026-01-18 12:50:00', 59.99, 10.00, 8.00, 57.99, 84, 3),
(335, 98335, '2026-01-31 14:05:00', 69.98, 15.00, 8.80, 63.78, 85, 2),
(336, 98336, '2026-02-13 15:20:00', 29.99, 0.00, 4.80, 34.79, 86, 4),
(337, 98337, '2026-02-26 16:35:00', 99.95, 30.00, 11.20, 81.15, 87, 1),
(338, 98338, '2026-03-11 17:50:00', 19.99, 0.00, 3.20, 23.19, 88, 2),
(339, 98339, '2026-03-24 19:00:00', 49.99, 5.00, 7.20, 52.19, 89, 3),
(340, 98340, '2026-04-06 20:15:00', 79.98, 20.00, 9.60, 69.58, 90, 1),
(341, 98341, '2026-04-19 10:30:00', 39.99, 0.00, 6.40, 46.39, 91, 5),
(342, 98342, '2026-05-02 11:45:00', 59.99, 10.00, 8.00, 57.99, 92, 2),
(343, 98343, '2026-05-15 13:00:00', 119.96, 35.00, 13.60, 98.56, 93, 1),
(344, 98344, '2026-05-28 14:15:00', 24.99, 0.00, 4.00, 28.99, 94, 3),
(345, 98345, '2026-06-10 15:30:00', 69.98, 15.00, 8.80, 63.78, 95, 4),
(346, 98346, '2026-06-23 16:45:00', 49.99, 5.00, 7.20, 52.19, 96, 1),
(347, 98347, '2026-07-06 18:00:00', 89.99, 20.00, 11.20, 81.19, 97, 2),
(348, 98348, '2026-07-19 19:15:00', 19.99, 0.00, 3.20, 23.19, 98, 3),
(349, 98349, '2026-08-01 20:30:00', 59.99, 10.00, 8.00, 57.99, 99, 1),
(350, 98350, '2026-08-14 21:45:00', 129.97, 40.00, 14.40, 104.37, 100, 5),
(351, 98351, '2024-11-22 10:15:00', 49.99, 5.00, 7.20, 52.19, 101, 1),
(352, 98352, '2024-12-04 14:30:00', 79.98, 15.00, 10.40, 75.38, 102, 2),
(353, 98353, '2024-12-16 11:45:00', 19.99, 0.00, 3.20, 23.19, 103, 3),
(354, 98354, '2024-12-28 16:20:00', 99.96, 20.00, 12.80, 92.76, 104, 1),
(355, 98355, '2025-01-10 20:00:00', 34.99, 0.00, 5.60, 40.59, 105, 4),
(356, 98356, '2025-01-22 12:10:00', 59.99, 10.00, 8.00, 57.99, 106, 2),
(357, 98357, '2025-02-04 17:35:00', 89.97, 15.00, 12.00, 86.97, 107, 1),
(358, 98358, '2025-02-17 15:50:00', 14.99, 0.00, 2.40, 17.39, 108, 5),
(359, 98359, '2025-03-02 10:25:00', 69.98, 10.00, 9.60, 69.58, 109, 3),
(360, 98360, '2025-03-15 21:15:00', 49.99, 0.00, 8.00, 57.99, 110, 1),
(361, 98361, '2025-03-28 13:40:00', 79.98, 15.00, 10.40, 75.38, 111, 2),
(362, 98362, '2025-04-10 16:05:00', 29.99, 0.00, 4.80, 34.79, 112, 4),
(363, 98363, '2025-04-23 11:30:00', 59.99, 10.00, 8.00, 57.99, 113, 1),
(364, 98364, '2025-05-06 19:45:00', 109.95, 25.00, 13.60, 98.55, 114, 3),
(365, 98365, '2025-05-19 14:20:00', 24.99, 0.00, 4.00, 28.99, 115, 2),
(366, 98366, '2025-06-01 18:10:00', 49.99, 5.00, 7.20, 52.19, 116, 5),
(367, 98367, '2025-06-14 12:00:00', 39.99, 0.00, 6.40, 46.39, 117, 1),
(368, 98368, '2025-06-27 18:25:00', 119.97, 30.00, 14.40, 104.37, 118, 2),
(369, 98369, '2025-07-10 15:10:00', 19.99, 0.00, 3.20, 23.19, 119, 3),
(370, 98370, '2025-07-23 20:30:00', 59.99, 10.00, 8.00, 57.99, 120, 4),
(371, 98371, '2025-08-05 09:45:00', 44.98, 5.00, 6.40, 46.38, 121, 1),
(372, 98372, '2025-08-18 10:50:00', 89.99, 20.00, 11.20, 81.19, 122, 2),
(373, 98373, '2025-08-31 12:15:00', 15.99, 0.00, 2.56, 18.55, 123, 3),
(374, 98374, '2025-09-13 13:40:00', 69.98, 15.00, 8.80, 63.78, 124, 1),
(375, 98375, '2025-09-26 14:55:00', 39.99, 0.00, 6.40, 46.39, 125, 5),
(376, 98376, '2025-10-09 15:30:00', 59.99, 10.00, 8.00, 57.99, 126, 2),
(377, 98377, '2025-10-22 17:10:00', 99.96, 20.00, 12.80, 92.76, 127, 1),
(378, 98378, '2025-11-04 18:25:00', 19.99, 0.00, 3.20, 23.19, 128, 3),
(379, 98379, '2025-11-17 19:40:00', 49.99, 5.00, 7.20, 52.19, 129, 4),
(380, 98380, '2025-11-30 20:50:00', 79.98, 20.00, 9.60, 69.58, 130, 1),
(381, 98381, '2025-12-13 09:10:00', 39.99, 0.00, 6.40, 46.39, 131, 2),
(382, 98382, '2025-12-26 10:20:00', 89.97, 15.00, 12.00, 86.97, 132, 5),
(383, 98383, '2026-01-08 11:35:00', 14.99, 0.00, 2.40, 17.39, 133, 1),
(384, 98384, '2026-01-21 12:50:00', 59.99, 10.00, 8.00, 57.99, 134, 3),
(385, 98385, '2026-02-03 14:05:00', 69.98, 15.00, 8.80, 63.78, 135, 2),
(386, 98386, '2026-02-16 15:20:00', 29.99, 0.00, 4.80, 34.79, 136, 4),
(387, 98387, '2026-03-01 16:35:00', 99.95, 30.00, 11.20, 81.15, 137, 1),
(388, 98388, '2026-03-14 17:50:00', 19.99, 0.00, 3.20, 23.19, 138, 2),
(389, 98389, '2026-03-27 19:00:00', 49.99, 5.00, 7.20, 52.19, 139, 3),
(390, 98390, '2026-04-09 20:15:00', 79.98, 20.00, 9.60, 69.58, 140, 1),
(391, 98391, '2026-04-22 10:30:00', 39.99, 0.00, 6.40, 46.39, 141, 5),
(392, 98392, '2026-05-05 11:45:00', 59.99, 10.00, 8.00, 57.99, 142, 2),
(393, 98393, '2026-05-18 13:00:00', 119.96, 35.00, 13.60, 98.56, 143, 1),
(394, 98394, '2026-05-31 14:15:00', 24.99, 0.00, 4.00, 28.99, 144, 3),
(395, 98395, '2026-06-13 15:30:00', 69.98, 15.00, 8.80, 63.78, 145, 4),
(396, 98396, '2026-06-26 16:45:00', 49.99, 5.00, 7.20, 52.19, 146, 1),
(397, 98397, '2026-07-09 18:00:00', 89.99, 20.00, 11.20, 81.19, 147, 2),
(398, 98398, '2026-07-22 19:15:00', 19.99, 0.00, 3.20, 23.19, 148, 3),
(399, 98399, '2026-08-04 20:30:00', 59.99, 10.00, 8.00, 57.99, 149, 1),
(400, 98400, '2026-08-17 21:45:00', 129.97, 40.00, 14.40, 104.37, 150, 5),
(401, 98401, '2024-11-25 10:15:00', 49.99, 5.00, 7.20, 52.19, 151, 1),
(402, 98402, '2024-12-08 14:30:00', 79.98, 15.00, 10.40, 75.38, 152, 2),
(403, 98403, '2024-12-20 11:45:00', 19.99, 0.00, 3.20, 23.19, 153, 3),
(404, 98404, '2025-01-02 16:20:00', 99.96, 20.00, 12.80, 92.76, 154, 1),
(405, 98405, '2025-01-15 20:00:00', 34.99, 0.00, 5.60, 40.59, 155, 4),
(406, 98406, '2025-01-28 12:10:00', 59.99, 10.00, 8.00, 57.99, 156, 2),
(407, 98407, '2025-02-10 17:35:00', 89.97, 15.00, 12.00, 86.97, 157, 1),
(408, 98408, '2025-02-23 15:50:00', 14.99, 0.00, 2.40, 17.39, 158, 5),
(409, 98409, '2025-03-08 10:25:00', 69.98, 10.00, 9.60, 69.58, 159, 3),
(410, 98410, '2025-03-21 21:15:00', 49.99, 0.00, 8.00, 57.99, 160, 1),
(411, 98411, '2025-04-03 13:40:00', 79.98, 15.00, 10.40, 75.38, 161, 2),
(412, 98412, '2025-04-16 16:05:00', 29.99, 0.00, 4.80, 34.79, 162, 4),
(413, 98413, '2025-04-29 11:30:00', 59.99, 10.00, 8.00, 57.99, 163, 1),
(414, 98414, '2025-05-12 19:45:00', 109.95, 25.00, 13.60, 98.55, 164, 3),
(415, 98415, '2025-05-25 14:20:00', 24.99, 0.00, 4.00, 28.99, 165, 2),
(416, 98416, '2025-06-07 18:10:00', 49.99, 5.00, 7.20, 52.19, 166, 5),
(417, 98417, '2025-06-20 12:00:00', 39.99, 0.00, 6.40, 46.39, 167, 1),
(418, 98418, '2025-07-03 18:25:00', 119.97, 30.00, 14.40, 104.37, 168, 2),
(419, 98419, '2025-07-16 15:10:00', 19.99, 0.00, 3.20, 23.19, 169, 3),
(420, 98420, '2025-07-29 20:30:00', 59.99, 10.00, 8.00, 57.99, 170, 4),
(421, 98421, '2025-08-11 09:45:00', 44.98, 5.00, 6.40, 46.38, 171, 1),
(422, 98422, '2025-08-24 10:50:00', 89.99, 20.00, 11.20, 81.19, 172, 2),
(423, 98423, '2025-09-06 12:15:00', 15.99, 0.00, 2.56, 18.55, 173, 3),
(424, 98424, '2025-09-19 13:40:00', 69.98, 15.00, 8.80, 63.78, 174, 1),
(425, 98425, '2025-10-02 14:55:00', 39.99, 0.00, 6.40, 46.39, 175, 5),
(426, 98426, '2025-10-15 15:30:00', 59.99, 10.00, 8.00, 57.99, 176, 2),
(427, 98427, '2025-10-28 17:10:00', 99.96, 20.00, 12.80, 92.76, 177, 1),
(428, 98428, '2025-11-10 18:25:00', 19.99, 0.00, 3.20, 23.19, 178, 3),
(429, 98429, '2025-11-23 19:40:00', 49.99, 5.00, 7.20, 52.19, 179, 4),
(430, 98430, '2025-12-06 20:50:00', 79.98, 20.00, 9.60, 69.58, 180, 1),
(431, 98431, '2025-12-19 09:10:00', 39.99, 0.00, 6.40, 46.39, 181, 2),
(432, 98432, '2026-01-01 10:20:00', 89.97, 15.00, 12.00, 86.97, 182, 5),
(433, 98433, '2026-01-14 11:35:00', 14.99, 0.00, 2.40, 17.39, 183, 1),
(434, 98434, '2026-01-27 12:50:00', 59.99, 10.00, 8.00, 57.99, 184, 3),
(435, 98435, '2026-02-09 14:05:00', 69.98, 15.00, 8.80, 63.78, 185, 2),
(436, 98436, '2026-02-22 15:20:00', 29.99, 0.00, 4.80, 34.79, 186, 4),
(437, 98437, '2026-03-07 16:35:00', 99.95, 30.00, 11.20, 81.15, 187, 1),
(438, 98438, '2026-03-20 17:50:00', 19.99, 0.00, 3.20, 23.19, 188, 2),
(439, 98439, '2026-04-02 19:00:00', 49.99, 5.00, 7.20, 52.19, 189, 3),
(440, 98440, '2026-04-15 20:15:00', 79.98, 20.00, 9.60, 69.58, 190, 1),
(441, 98441, '2026-04-28 10:30:00', 39.99, 0.00, 6.40, 46.39, 191, 5),
(442, 98442, '2026-05-11 11:45:00', 59.99, 10.00, 8.00, 57.99, 192, 2),
(443, 98443, '2026-05-24 13:00:00', 119.96, 35.00, 13.60, 98.56, 193, 1),
(444, 98444, '2026-06-06 14:15:00', 24.99, 0.00, 4.00, 28.99, 194, 3),
(445, 98445, '2026-06-19 15:30:00', 69.98, 15.00, 8.80, 63.78, 195, 4),
(446, 98446, '2026-07-02 16:45:00', 49.99, 5.00, 7.20, 52.19, 196, 1),
(447, 98447, '2026-07-15 18:00:00', 89.99, 20.00, 11.20, 81.19, 197, 2),
(448, 98448, '2026-07-28 19:15:00', 19.99, 0.00, 3.20, 23.19, 198, 3),
(449, 98449, '2026-08-10 20:30:00', 59.99, 10.00, 8.00, 57.99, 199, 1),
(450, 98450, '2026-08-23 21:45:00', 129.97, 40.00, 14.40, 104.37, 200, 5),
(451, 98451, '2024-11-28 10:15:00', 49.99, 5.00, 7.20, 52.19, 201, 1),
(452, 98452, '2024-12-10 14:30:00', 79.98, 15.00, 10.40, 75.38, 202, 2),
(453, 98453, '2024-12-22 11:45:00', 19.99, 0.00, 3.20, 23.19, 203, 3),
(454, 98454, '2025-01-05 16:20:00', 99.96, 20.00, 12.80, 92.76, 204, 1),
(455, 98455, '2025-01-18 20:00:00', 34.99, 0.00, 5.60, 40.59, 205, 4),
(456, 98456, '2025-01-31 12:10:00', 59.99, 10.00, 8.00, 57.99, 206, 2),
(457, 98457, '2025-02-12 17:35:00', 89.97, 15.00, 12.00, 86.97, 207, 1),
(458, 98458, '2025-02-25 15:50:00', 14.99, 0.00, 2.40, 17.39, 208, 5),
(459, 98459, '2025-03-10 10:25:00', 69.98, 10.00, 9.60, 69.58, 209, 3),
(460, 98460, '2025-03-23 21:15:00', 49.99, 0.00, 8.00, 57.99, 210, 1),
(461, 98461, '2025-04-05 13:40:00', 79.98, 15.00, 10.40, 75.38, 211, 2),
(462, 98462, '2025-04-18 16:05:00', 29.99, 0.00, 4.80, 34.79, 212, 4),
(463, 98463, '2025-05-01 11:30:00', 59.99, 10.00, 8.00, 57.99, 213, 1),
(464, 98464, '2025-05-14 19:45:00', 109.95, 25.00, 13.60, 98.55, 214, 3),
(465, 98465, '2025-05-27 14:20:00', 24.99, 0.00, 4.00, 28.99, 215, 2),
(466, 98466, '2025-06-09 18:10:00', 49.99, 5.00, 7.20, 52.19, 216, 5),
(467, 98467, '2025-06-22 12:00:00', 39.99, 0.00, 6.40, 46.39, 217, 1),
(468, 98468, '2025-07-05 18:25:00', 119.97, 30.00, 14.40, 104.37, 218, 2),
(469, 98469, '2025-07-18 15:10:00', 19.99, 0.00, 3.20, 23.19, 219, 3),
(470, 98470, '2025-07-31 20:30:00', 59.99, 10.00, 8.00, 57.99, 220, 4),
(471, 98471, '2025-08-13 09:45:00', 44.98, 5.00, 6.40, 46.38, 221, 1),
(472, 98472, '2025-08-26 10:50:00', 89.99, 20.00, 11.20, 81.19, 222, 2),
(473, 98473, '2025-09-08 12:15:00', 15.99, 0.00, 2.56, 18.55, 223, 3),
(474, 98474, '2025-09-21 13:40:00', 69.98, 15.00, 8.80, 63.78, 224, 1),
(475, 98475, '2025-10-04 14:55:00', 39.99, 0.00, 6.40, 46.39, 225, 5),
(476, 98476, '2025-10-17 15:30:00', 59.99, 10.00, 8.00, 57.99, 226, 2),
(477, 98477, '2025-10-30 17:10:00', 99.96, 20.00, 12.80, 92.76, 227, 1),
(478, 98478, '2025-11-12 18:25:00', 19.99, 0.00, 3.20, 23.19, 228, 3),
(479, 98479, '2025-11-25 19:40:00', 49.99, 5.00, 7.20, 52.19, 229, 4),
(480, 98480, '2025-12-08 20:50:00', 79.98, 20.00, 9.60, 69.58, 230, 1),
(481, 98481, '2025-12-21 09:10:00', 39.99, 0.00, 6.40, 46.39, 231, 2),
(482, 98482, '2026-01-03 10:20:00', 89.97, 15.00, 12.00, 86.97, 232, 5),
(483, 98483, '2026-01-16 11:35:00', 14.99, 0.00, 2.40, 17.39, 233, 1),
(484, 98484, '2026-01-29 12:50:00', 59.99, 10.00, 8.00, 57.99, 234, 3),
(485, 98485, '2026-02-11 14:05:00', 69.98, 15.00, 8.80, 63.78, 235, 2),
(486, 98486, '2026-02-24 15:20:00', 29.99, 0.00, 4.80, 34.79, 236, 4),
(487, 98487, '2026-03-09 16:35:00', 99.95, 30.00, 11.20, 81.15, 237, 1),
(488, 98488, '2026-03-22 17:50:00', 19.99, 0.00, 3.20, 23.19, 238, 2),
(489, 98489, '2026-04-04 19:00:00', 49.99, 5.00, 7.20, 52.19, 239, 3),
(490, 98490, '2026-04-17 20:15:00', 79.98, 20.00, 9.60, 69.58, 240, 1),
(491, 98491, '2026-04-30 10:30:00', 39.99, 0.00, 6.40, 46.39, 241, 5),
(492, 98492, '2026-05-13 11:45:00', 59.99, 10.00, 8.00, 57.99, 242, 2),
(493, 98493, '2026-05-26 13:00:00', 119.96, 35.00, 13.60, 98.56, 243, 1),
(494, 98494, '2026-06-08 14:15:00', 24.99, 0.00, 4.00, 28.99, 244, 3),
(495, 98495, '2026-06-21 15:30:00', 69.98, 15.00, 8.80, 63.78, 245, 4),
(496, 98496, '2026-07-04 16:45:00', 49.99, 5.00, 7.20, 52.19, 246, 1),
(497, 98497, '2026-07-17 18:00:00', 89.99, 20.00, 11.20, 81.19, 247, 2),
(498, 98498, '2026-07-30 19:15:00', 19.99, 0.00, 3.20, 23.19, 248, 3),
(499, 98499, '2026-08-12 20:30:00', 59.99, 10.00, 8.00, 57.99, 249, 1),
(500, 98500, '2026-08-25 21:45:00', 129.97, 40.00, 14.40, 104.37, 250, 5),
(501, 98501, '2026-10-01 10:00:00', 104.93, 0.00, 0.00, 104.93, 1, 1),
(502, 98502, '2026-10-02 15:30:00', 74.95, 0.00, 0.00, 74.95, 2, 1),
(601, 98601, '2026-10-20 10:00:00', 40.00, 0.00, 0.00, 40.00, 8, 1),
(602, 98602, '2026-10-21 15:30:00', 40.00, 0.00, 0.00, 40.00, 9, 1),
(603, 98603, '2026-10-25 10:00:00', 120.00, 0.00, 0.00, 120.00, 10, 1),
(604, 98604, '2026-10-26 11:00:00', 60.00, 0.00, 0.00, 60.00, 11, 1);

INSERT INTO Factura (ID_Factura, Codigo_Transaccion, Fecha_Hora_Emision, Sub_Total, Monto_Descuento, Monto_Impuesto, Total_Pagado, ID_Usuario_FK, ID_Metodo_Pago_FK) VALUES
-- 51 Facturas para el Producto 36 (IDs 1001 a 1051)
(1001, '99001', '2026-01-01 10:00:00', 59.99, 0.00, 0.00, 59.99, 1, 1),
(1002, '99002', '2026-01-02 10:15:00', 59.99, 0.00, 0.00, 59.99, 2, 1),
(1003, '99003', '2026-01-03 10:30:00', 59.99, 0.00, 0.00, 59.99, 3, 1),
(1004, '99004', '2026-01-04 10:45:00', 59.99, 0.00, 0.00, 59.99, 4, 1),
(1005, '99005', '2026-01-05 11:00:00', 59.99, 0.00, 0.00, 59.99, 5, 1),
(1006, '99006', '2026-01-06 11:15:00', 59.99, 0.00, 0.00, 59.99, 6, 1),
(1007, '99007', '2026-01-07 11:30:00', 59.99, 0.00, 0.00, 59.99, 7, 1),
(1008, '99008', '2026-01-08 11:45:00', 59.99, 0.00, 0.00, 59.99, 8, 1),
(1009, '99009', '2026-01-09 12:00:00', 59.99, 0.00, 0.00, 59.99, 9, 1),
(1010, '99010', '2026-01-10 12:15:00', 59.99, 0.00, 0.00, 59.99, 10, 1),
(1011, '99011', '2026-01-11 12:30:00', 59.99, 0.00, 0.00, 59.99, 1, 1),
(1012, '99012', '2026-01-12 12:45:00', 59.99, 0.00, 0.00, 59.99, 2, 1),
(1013, '99013', '2026-01-13 13:00:00', 59.99, 0.00, 0.00, 59.99, 3, 1),
(1014, '99014', '2026-01-14 13:15:00', 59.99, 0.00, 0.00, 59.99, 4, 1),
(1015, '99015', '2026-01-15 13:30:00', 59.99, 0.00, 0.00, 59.99, 5, 1),
(1016, '99016', '2026-01-16 13:45:00', 59.99, 0.00, 0.00, 59.99, 6, 1),
(1017, '99017', '2026-01-17 14:00:00', 59.99, 0.00, 0.00, 59.99, 7, 1),
(1018, '99018', '2026-01-18 14:15:00', 59.99, 0.00, 0.00, 59.99, 8, 1),
(1019, '99019', '2026-01-19 14:30:00', 59.99, 0.00, 0.00, 59.99, 9, 1),
(1020, '99020', '2026-01-20 14:45:00', 59.99, 0.00, 0.00, 59.99, 10, 1),
(1021, '99021', '2026-01-21 15:00:00', 59.99, 0.00, 0.00, 59.99, 1, 1),
(1022, '99022', '2026-01-22 15:15:00', 59.99, 0.00, 0.00, 59.99, 2, 1),
(1023, '99023', '2026-01-23 15:30:00', 59.99, 0.00, 0.00, 59.99, 3, 1),
(1024, '99024', '2026-01-24 15:45:00', 59.99, 0.00, 0.00, 59.99, 4, 1),
(1025, '99025', '2026-01-25 16:00:00', 59.99, 0.00, 0.00, 59.99, 5, 1),
(1026, '99026', '2026-01-26 16:15:00', 59.99, 0.00, 0.00, 59.99, 6, 1),
(1027, '99027', '2026-01-27 16:30:00', 59.99, 0.00, 0.00, 59.99, 7, 1),
(1028, '99028', '2026-01-28 16:45:00', 59.99, 0.00, 0.00, 59.99, 8, 1),
(1029, '99029', '2026-01-29 17:00:00', 59.99, 0.00, 0.00, 59.99, 9, 1),
(1030, '99030', '2026-01-30 17:15:00', 59.99, 0.00, 0.00, 59.99, 10, 1),
(1031, '99031', '2026-01-31 17:30:00', 59.99, 0.00, 0.00, 59.99, 1, 1),
(1032, '99032', '2026-02-01 17:45:00', 59.99, 0.00, 0.00, 59.99, 2, 1),
(1033, '99033', '2026-02-02 18:00:00', 59.99, 0.00, 0.00, 59.99, 3, 1),
(1034, '99034', '2026-02-03 18:15:00', 59.99, 0.00, 0.00, 59.99, 4, 1),
(1035, '99035', '2026-02-04 18:30:00', 59.99, 0.00, 0.00, 59.99, 5, 1),
(1036, '99036', '2026-02-05 18:45:00', 59.99, 0.00, 0.00, 59.99, 6, 1),
(1037, '99037', '2026-02-06 19:00:00', 59.99, 0.00, 0.00, 59.99, 7, 1),
(1038, '99038', '2026-02-07 19:15:00', 59.99, 0.00, 0.00, 59.99, 8, 1),
(1039, '99039', '2026-02-08 19:30:00', 59.99, 0.00, 0.00, 59.99, 9, 1),
(1040, '99040', '2026-02-09 19:45:00', 59.99, 0.00, 0.00, 59.99, 10, 1),
(1041, '99041', '2026-02-10 20:00:00', 59.99, 0.00, 0.00, 59.99, 1, 1),
(1042, '99042', '2026-02-11 20:15:00', 59.99, 0.00, 0.00, 59.99, 2, 1),
(1043, '99043', '2026-02-12 20:30:00', 59.99, 0.00, 0.00, 59.99, 3, 1),
(1044, '99044', '2026-02-13 20:45:00', 59.99, 0.00, 0.00, 59.99, 4, 1),
(1045, '99045', '2026-02-14 21:00:00', 59.99, 0.00, 0.00, 59.99, 5, 1),
(1046, '99046', '2026-02-15 21:15:00', 59.99, 0.00, 0.00, 59.99, 6, 1),
(1047, '99047', '2026-02-16 21:30:00', 59.99, 0.00, 0.00, 59.99, 7, 1),
(1048, '99048', '2026-02-17 21:45:00', 59.99, 0.00, 0.00, 59.99, 8, 1),
(1049, '99049', '2026-02-18 22:00:00', 59.99, 0.00, 0.00, 59.99, 9, 1),
(1050, '99050', '2026-02-19 22:15:00', 59.99, 0.00, 0.00, 59.99, 10, 1),
(1051, '99051', '2026-02-20 22:30:00', 59.99, 0.00, 0.00, 59.99, 1, 1),

-- 51 Facturas para el Producto 88 (IDs 1052 a 1102)
(1052, '99052', '2026-03-01 10:00:00', 69.99, 0.00, 0.00, 69.99, 1, 1),
(1053, '99053', '2026-03-02 10:15:00', 69.99, 0.00, 0.00, 69.99, 2, 1),
(1054, '99054', '2026-03-03 10:30:00', 69.99, 0.00, 0.00, 69.99, 3, 1),
(1055, '99055', '2026-03-04 10:45:00', 69.99, 0.00, 0.00, 69.99, 4, 1),
(1056, '99056', '2026-03-05 11:00:00', 69.99, 0.00, 0.00, 69.99, 5, 1),
(1057, '99057', '2026-03-06 11:15:00', 69.99, 0.00, 0.00, 69.99, 6, 1),
(1058, '99058', '2026-03-07 11:30:00', 69.99, 0.00, 0.00, 69.99, 7, 1),
(1059, '99059', '2026-03-08 11:45:00', 69.99, 0.00, 0.00, 69.99, 8, 1),
(1060, '99060', '2026-03-09 12:00:00', 69.99, 0.00, 0.00, 69.99, 9, 1),
(1061, '99061', '2026-03-10 12:15:00', 69.99, 0.00, 0.00, 69.99, 10, 1),
(1062, '99062', '2026-03-11 12:30:00', 69.99, 0.00, 0.00, 69.99, 1, 1),
(1063, '99063', '2026-03-12 12:45:00', 69.99, 0.00, 0.00, 69.99, 2, 1),
(1064, '99064', '2026-03-13 13:00:00', 69.99, 0.00, 0.00, 69.99, 3, 1),
(1065, '99065', '2026-03-14 13:15:00', 69.99, 0.00, 0.00, 69.99, 4, 1),
(1066, '99066', '2026-03-15 13:30:00', 69.99, 0.00, 0.00, 69.99, 5, 1),
(1067, '99067', '2026-03-16 13:45:00', 69.99, 0.00, 0.00, 69.99, 6, 1),
(1068, '99068', '2026-03-17 14:00:00', 69.99, 0.00, 0.00, 69.99, 7, 1),
(1069, '99069', '2026-03-18 14:15:00', 69.99, 0.00, 0.00, 69.99, 8, 1),
(1070, '99070', '2026-03-19 14:30:00', 69.99, 0.00, 0.00, 69.99, 9, 1),
(1071, '99071', '2026-03-20 14:45:00', 69.99, 0.00, 0.00, 69.99, 10, 1),
(1072, '99072', '2026-03-21 15:00:00', 69.99, 0.00, 0.00, 69.99, 1, 1),
(1073, '99073', '2026-03-22 15:15:00', 69.99, 0.00, 0.00, 69.99, 2, 1),
(1074, '99074', '2026-03-23 15:30:00', 69.99, 0.00, 0.00, 69.99, 3, 1),
(1075, '99075', '2026-03-24 15:45:00', 69.99, 0.00, 0.00, 69.99, 4, 1),
(1076, '99076', '2026-03-25 16:00:00', 69.99, 0.00, 0.00, 69.99, 5, 1),
(1077, '99077', '2026-03-26 16:15:00', 69.99, 0.00, 0.00, 69.99, 6, 1),
(1078, '99078', '2026-03-27 16:30:00', 69.99, 0.00, 0.00, 69.99, 7, 1),
(1079, '99079', '2026-03-28 16:45:00', 69.99, 0.00, 0.00, 69.99, 8, 1),
(1080, '99080', '2026-03-29 17:00:00', 69.99, 0.00, 0.00, 69.99, 9, 1),
(1081, '99081', '2026-03-30 17:15:00', 69.99, 0.00, 0.00, 69.99, 10, 1),
(1082, '99082', '2026-03-31 17:30:00', 69.99, 0.00, 0.00, 69.99, 1, 1),
(1083, '99083', '2026-04-01 17:45:00', 69.99, 0.00, 0.00, 69.99, 2, 1),
(1084, '99084', '2026-04-02 18:00:00', 69.99, 0.00, 0.00, 69.99, 3, 1),
(1085, '99085', '2026-04-03 18:15:00', 69.99, 0.00, 0.00, 69.99, 4, 1),
(1086, '99086', '2026-04-04 18:30:00', 69.99, 0.00, 0.00, 69.99, 5, 1),
(1087, '99087', '2026-04-05 18:45:00', 69.99, 0.00, 0.00, 69.99, 6, 1),
(1088, '99088', '2026-04-06 19:00:00', 69.99, 0.00, 0.00, 69.99, 7, 1),
(1089, '99089', '2026-04-07 19:15:00', 69.99, 0.00, 0.00, 69.99, 8, 1),
(1090, '99090', '2026-04-08 19:30:00', 69.99, 0.00, 0.00, 69.99, 9, 1),
(1091, '99091', '2026-04-09 19:45:00', 69.99, 0.00, 0.00, 69.99, 10, 1),
(1092, '99092', '2026-04-10 20:00:00', 69.99, 0.00, 0.00, 69.99, 1, 1),
(1093, '99093', '2026-04-11 20:15:00', 69.99, 0.00, 0.00, 69.99, 2, 1),
(1094, '99094', '2026-04-12 20:30:00', 69.99, 0.00, 0.00, 69.99, 3, 1),
(1095, '99095', '2026-04-13 20:45:00', 69.99, 0.00, 0.00, 69.99, 4, 1),
(1096, '99096', '2026-04-14 21:00:00', 69.99, 0.00, 0.00, 69.99, 5, 1),
(1097, '99097', '2026-04-15 21:15:00', 69.99, 0.00, 0.00, 69.99, 6, 1),
(1098, '99098', '2026-04-16 21:30:00', 69.99, 0.00, 0.00, 69.99, 7, 1),
(1099, '99099', '2026-04-17 21:45:00', 69.99, 0.00, 0.00, 69.99, 8, 1),
(1100, '99100', '2026-04-18 22:00:00', 69.99, 0.00, 0.00, 69.99, 9, 1),
(1101, '99101', '2026-04-19 22:15:00', 69.99, 0.00, 0.00, 69.99, 10, 1),
(1102, '99102', '2026-04-20 22:30:00', 69.99, 0.00, 0.00, 69.99, 1, 1);


SET IDENTITY_INSERT Factura OFF;


/* -------------------------- 2. Detalle_Factura ----------------------- */

INSERT INTO Detalle_Factura (Precio_Venta_Historico, Descuento_Aplicado_Pct, ID_Factura_FK, ID_Producto_FK) VALUES
-- Factura 1 (2 productos)
(59.99, 0.00, 1, 12), (19.99, 0.00, 1, 45),
-- Factura 2 (2 productos)
(19.99, 10.00, 2, 8), (19.99, 15.00, 2, 23),
-- Factura 3 (1 producto)
(19.99, 0.00, 3, 55),
-- Factura 4 (3 productos)
(49.99, 10.00, 4, 3), (29.99, 20.00, 4, 14), (9.99, 0.00, 4, 72),
-- Factura 5 (1 producto)
(29.99, 15.00, 5, 88),
-- Factura 6 (2 productos)
(39.99, 10.00, 6, 19), (10.00, 0.00, 6, 91),
-- Factura 7 (3 productos)
(59.99, 0.00, 7, 5), (39.99, 20.00, 7, 33), (19.98, 10.00, 7, 102),
-- Factura 8 (1 producto)
(14.99, 0.00, 8, 41),
-- Factura 9 (2 productos)
(39.99, 15.00, 9, 2), (29.99, 10.00, 9, 66),
-- Factura 10 (1 producto)
(39.99, 0.00, 10, 110),
-- Factura 11 (2 productos)
(49.99, 10.00, 11, 25), (29.99, 15.00, 11, 78),
-- Factura 12 (1 producto)
(19.99, 0.00, 12, 134),
-- Factura 13 (2 productos)
(39.99, 10.00, 13, 11), (20.00, 20.00, 13, 89),
-- Factura 14 (3 productos)
(49.99, 25.00, 14, 4), (29.99, 10.00, 14, 52), (19.97, 15.00, 14, 115),
-- Factura 15 (1 producto)
(24.99, 0.00, 15, 60),
-- Factura 16 (2 productos)
(29.99, 0.00, 16, 18), (20.00, 10.00, 16, 95),
-- Factura 17 (1 producto)
(34.99, 0.00, 17, 122),
-- Factura 18 (3 productos)
(59.99, 20.00, 18, 7), (39.99, 10.00, 18, 44), (29.99, 15.00, 18, 150),
-- Factura 19 (1 producto)
(19.99, 0.00, 19, 31),
-- Factura 20 (2 productos)
(39.99, 10.00, 20, 15), (20.00, 10.00, 20, 77),
-- Factura 21 (2 productos)
(24.99, 0.00, 21, 84), (19.99, 10.00, 21, 106),
-- Factura 22 (2 productos)
(59.99, 20.00, 22, 1), (30.00, 10.00, 22, 49),
-- Factura 23 (1 producto)
(15.99, 0.00, 23, 140),
-- Factura 24 (2 productos)
(39.99, 10.00, 24, 21), (29.99, 20.00, 24, 93),
-- Factura 25 (1 producto)
(29.99, 0.00, 25, 118),
-- Factura 26 (2 productos)
(39.99, 10.00, 26, 36), (20.00, 0.00, 26, 81),
-- Factura 27 (3 productos)
(49.99, 15.00, 27, 9), (39.99, 10.00, 27, 57), (19.98, 20.00, 27, 162),
-- Factura 28 (1 producto)
(19.99, 0.00, 28, 175),
-- Factura 29 (2 productos)
(29.99, 0.00, 29, 43), (20.00, 10.00, 29, 104),
-- Factura 30 (2 productos)
(49.99, 20.00, 30, 13), (29.99, 10.00, 30, 68),
-- Factura 31 (1 producto)
(39.99, 0.00, 31, 126),
-- Factura 32 (3 productos)
(39.99, 10.00, 32, 27), (29.99, 20.00, 32, 74), (19.99, 0.00, 32, 182),
-- Factura 33 (1 producto)
(14.99, 0.00, 33, 99),
-- Factura 34 (2 productos)
(39.99, 10.00, 34, 39), (20.00, 10.00, 34, 111),
-- Factura 35 (2 productos)
(39.99, 10.00, 35, 16), (29.99, 15.00, 35, 85),
-- Factura 36 (1 producto)
(29.99, 0.00, 36, 145),
-- Factura 37 (3 productos)
(49.99, 20.00, 37, 6), (29.99, 10.00, 37, 50), (19.97, 20.00, 37, 190),
-- Factura 38 (1 producto)
(19.99, 0.00, 38, 158),
-- Factura 39 (2 productos)
(29.99, 0.00, 39, 48), (20.00, 10.00, 39, 120),
-- Factura 40 (2 productos)
(49.99, 20.00, 40, 22), (29.99, 0.00, 40, 92),
-- Factura 41 (1 producto)
(39.99, 0.00, 41, 165),
-- Factura 42 (2 productos)
(39.99, 10.00, 42, 34), (20.00, 0.00, 42, 101),
-- Factura 43 (3 productos)
(49.99, 15.00, 43, 10), (39.99, 10.00, 43, 62), (29.98, 20.00, 43, 200),
-- Factura 44 (1 producto)
(24.99, 0.00, 44, 137),
-- Factura 45 (2 productos)
(39.99, 10.00, 45, 29), (29.99, 15.00, 45, 87),
-- Factura 46 (1 producto)
(49.99, 10.00, 46, 53),
-- Factura 47 (2 productos)
(59.99, 10.00, 47, 24), (29.00, 20.00, 47, 114),
-- Factura 48 (1 producto)
(19.99, 0.00, 48, 179),
-- Factura 49 (2 productos)
(39.99, 10.00, 49, 42), (20.00, 0.00, 49, 128),
-- Factura 50 (3 productos)
(59.99, 20.00, 50, 4), (39.99, 10.00, 50, 58), (29.99, 20.00, 50, 168),
-- Factura 51 (2 productos)
(29.99, 10.00, 51, 14), (20.00, 10.00, 51, 65),
-- Factura 52 (2 productos)
(39.99, 15.00, 52, 28), (39.99, 15.00, 52, 79),
-- Factura 53 (1 producto)
(19.99, 0.00, 53, 105),
-- Factura 54 (3 productos)
(49.99, 10.00, 54, 7), (29.99, 20.00, 54, 46), (19.98, 10.00, 54, 131),
-- Factura 55 (1 producto)
(34.99, 0.00, 55, 142),
-- Factura 56 (2 productos)
(39.99, 10.00, 56, 33), (20.00, 0.00, 56, 94),
-- Factura 57 (3 productos)
(49.99, 15.00, 57, 19), (29.99, 10.00, 57, 61), (19.99, 20.00, 57, 152),
-- Factura 58 (1 producto)
(14.99, 0.00, 58, 82),
-- Factura 59 (2 productos)
(39.99, 10.00, 59, 25), (29.99, 15.00, 59, 112),
-- Factura 60 (1 producto)
(49.99, 0.00, 60, 129),
-- Factura 61 (2 productos)
(49.99, 10.00, 61, 38), (29.99, 15.00, 61, 98),
-- Factura 62 (1 producto)
(29.99, 0.00, 62, 161),
-- Factura 63 (2 productos)
(39.99, 10.00, 63, 12), (20.00, 20.00, 63, 73),
-- Factura 64 (3 productos)
(49.99, 20.00, 64, 5), (39.99, 10.00, 64, 40), (19.97, 15.00, 64, 185),
-- Factura 65 (1 producto)
(24.99, 0.00, 65, 119),
-- Factura 66 (2 productos)
(29.99, 0.00, 66, 22), (20.00, 10.00, 66, 88),
-- Factura 67 (1 producto)
(39.99, 0.00, 67, 147),
-- Factura 68 (3 productos)
(59.99, 20.00, 68, 9), (39.99, 10.00, 68, 51), (19.99, 15.00, 68, 198),
-- Factura 69 (1 producto)
(19.99, 0.00, 69, 133),
-- Factura 70 (2 productos)
(39.99, 10.00, 70, 31), (20.00, 10.00, 70, 84),
-- Factura 71 (2 productos)
(24.99, 0.00, 71, 76), (19.99, 10.00, 71, 103),
-- Factura 72 (2 productos)
(59.99, 20.00, 72, 3), (30.00, 10.00, 72, 59),
-- Factura 73 (1 producto)
(15.99, 0.00, 73, 167),
-- Factura 74 (2 productos)
(39.99, 10.00, 74, 17), (29.99, 20.00, 74, 96),
-- Factura 75 (1 producto)
(39.99, 0.00, 75, 138),
-- Factura 76 (2 productos)
(39.99, 10.00, 76, 45), (20.00, 0.00, 76, 116),
-- Factura 77 (3 productos)
(49.99, 15.00, 77, 11), (29.99, 10.00, 77, 66), (19.98, 20.00, 77, 172),
-- Factura 78 (1 producto)
(19.99, 0.00, 78, 191),
-- Factura 79 (2 productos)
(29.99, 0.00, 79, 37), (20.00, 10.00, 79, 123),
-- Factura 80 (2 productos)
(49.99, 20.00, 80, 21), (29.99, 10.00, 80, 70),
-- Factura 81 (1 producto)
(39.99, 0.00, 81, 155),
-- Factura 82 (3 productos)
(39.99, 10.00, 82, 29), (29.99, 20.00, 82, 83), (19.99, 0.00, 82, 204),
-- Factura 83 (1 producto)
(14.99, 0.00, 83, 114),
-- Factura 84 (2 productos)
(39.99, 10.00, 84, 43), (20.00, 10.00, 84, 125),
-- Factura 85 (2 productos)
(39.99, 10.00, 85, 18), (29.99, 15.00, 85, 99),
-- Factura 86 (1 producto)
(29.99, 0.00, 86, 169),
-- Factura 87 (3 productos)
(49.99, 20.00, 87, 8), (29.99, 10.00, 87, 56), (19.97, 20.00, 87, 210),
-- Factura 88 (1 producto)
(19.99, 0.00, 88, 177),
-- Factura 89 (2 productos)
(29.99, 0.00, 89, 52), (20.00, 10.00, 89, 141),
-- Factura 90 (2 productos)
(49.99, 20.00, 90, 26), (29.99, 0.00, 90, 108),
-- Factura 91 (1 producto)
(39.99, 0.00, 91, 183),
-- Factura 92 (2 productos)
(39.99, 10.00, 92, 35), (20.00, 0.00, 92, 117),
-- Factura 93 (3 productos)
(49.99, 15.00, 93, 15), (39.99, 10.00, 93, 68), (29.98, 20.00, 93, 207),
-- Factura 94 (1 producto)
(24.99, 0.00, 94, 159),
-- Factura 95 (2 productos)
(39.99, 10.00, 95, 32), (29.99, 15.00, 95, 101),
-- Factura 96 (1 producto)
(49.99, 10.00, 96, 64),
-- Factura 97 (2 productos)
(59.99, 10.00, 97, 23), (29.00, 20.00, 97, 136),
-- Factura 98 (1 producto)
(19.99, 0.00, 98, 196),
-- Factura 99 (2 productos)
(39.99, 10.00, 99, 47), (20.00, 0.00, 99, 148),
-- Factura 100 (3 productos)
(59.99, 20.00, 100, 6), (39.99, 10.00, 100, 63), (29.99, 20.00, 100, 189),
-- Factura 101 (2 productos)
(29.99, 10.00, 101, 13), (20.00, 10.00, 101, 75),
-- Factura 102 (2 productos)
(39.99, 15.00, 102, 34), (39.99, 15.00, 102, 88),
-- Factura 103 (1 producto)
(19.99, 0.00, 103, 112),
-- Factura 104 (3 productos)
(49.99, 10.00, 104, 15), (29.99, 20.00, 104, 55), (19.98, 10.00, 104, 140),
-- Factura 105 (1 producto)
(34.99, 0.00, 105, 153),
-- Factura 106 (2 productos)
(39.99, 10.00, 106, 42), (20.00, 0.00, 106, 102),
-- Factura 107 (3 productos)
(49.99, 15.00, 107, 28), (29.99, 10.00, 107, 71), (19.99, 20.00, 107, 163),
-- Factura 108 (1 producto)
(14.99, 0.00, 108, 91),
-- Factura 109 (2 productos)
(39.99, 10.00, 109, 30), (29.99, 15.00, 109, 120),
-- Factura 110 (1 producto)
(49.99, 0.00, 110, 135),
-- Factura 111 (2 productos)
(49.99, 10.00, 111, 44), (29.99, 15.00, 111, 108),
-- Factura 112 (1 producto)
(29.99, 0.00, 112, 170),
-- Factura 113 (2 productos)
(39.99, 10.00, 113, 22), (20.00, 20.00, 113, 81),
-- Factura 114 (3 productos)
(49.99, 20.00, 114, 12), (39.99, 10.00, 114, 49), (19.97, 15.00, 114, 192),
-- Factura 115 (1 producto)
(24.99, 0.00, 115, 128),
-- Factura 116 (2 productos)
(29.99, 0.00, 116, 31), (20.00, 10.00, 116, 95),
-- Factura 117 (1 producto)
(39.99, 0.00, 117, 156),
-- Factura 118 (3 productos)
(59.99, 20.00, 118, 18), (39.99, 10.00, 118, 60), (19.99, 15.00, 118, 205),
-- Factura 119 (1 producto)
(19.99, 0.00, 119, 142),
-- Factura 120 (2 productos)
(39.99, 10.00, 120, 39), (20.00, 10.00, 120, 93),
-- Factura 121 (2 productos)
(24.99, 0.00, 121, 85), (19.99, 10.00, 121, 111),
-- Factura 122 (2 productos)
(59.99, 20.00, 122, 10), (30.00, 10.00, 122, 67),
-- Factura 123 (1 producto)
(15.99, 0.00, 123, 176),
-- Factura 124 (2 productos)
(39.99, 10.00, 124, 26), (29.99, 20.00, 124, 104),
-- Factura 125 (1 producto)
(39.99, 0.00, 125, 146),
-- Factura 126 (2 productos)
(39.99, 10.00, 126, 52), (20.00, 0.00, 126, 124),
-- Factura 127 (3 productos)
(49.99, 15.00, 127, 20), (29.99, 10.00, 127, 74), (19.98, 20.00, 127, 181),
-- Factura 128 (1 producto)
(19.99, 0.00, 128, 199),
-- Factura 129 (2 productos)
(29.99, 0.00, 129, 45), (20.00, 10.00, 129, 130),
-- Factura 130 (2 productos)
(49.99, 20.00, 130, 29), (29.99, 10.00, 130, 78),
-- Factura 131 (1 producto)
(39.99, 0.00, 131, 164),
-- Factura 132 (3 productos)
(39.99, 10.00, 132, 37), (29.99, 20.00, 132, 90), (19.99, 0.00, 132, 208),
-- Factura 133 (1 producto)
(14.99, 0.00, 133, 121),
-- Factura 134 (2 productos)
(39.99, 10.00, 134, 50), (20.00, 10.00, 134, 133),
-- Factura 135 (2 productos)
(39.99, 10.00, 135, 25), (29.99, 15.00, 135, 107),
-- Factura 136 (1 producto)
(29.99, 0.00, 136, 178),
-- Factura 137 (3 productos)
(49.99, 20.00, 137, 16), (29.99, 10.00, 137, 63), (19.97, 20.00, 137, 210),
-- Factura 138 (1 producto)
(19.99, 0.00, 138, 186),
-- Factura 139 (2 productos)
(29.99, 0.00, 139, 58), (20.00, 10.00, 139, 149),
-- Factura 140 (2 productos)
(49.99, 20.00, 140, 33), (29.99, 0.00, 140, 115),
-- Factura 141 (1 producto)
(39.99, 0.00, 141, 191),
-- Factura 142 (2 productos)
(39.99, 10.00, 142, 43), (20.00, 0.00, 142, 126),
-- Factura 143 (3 productos)
(49.99, 15.00, 143, 21), (39.99, 10.00, 143, 76), (29.98, 20.00, 143, 202),
-- Factura 144 (1 producto)
(24.99, 0.00, 144, 168),
-- Factura 145 (2 productos)
(39.99, 10.00, 145, 36), (29.99, 15.00, 145, 109),
-- Factura 146 (1 producto)
(49.99, 10.00, 146, 72),
-- Factura 147 (2 productos)
(59.99, 10.00, 147, 27), (29.00, 20.00, 147, 144),
-- Factura 148 (1 producto)
(19.99, 0.00, 148, 203),
-- Factura 149 (2 productos)
(39.99, 10.00, 149, 54), (20.00, 0.00, 149, 157),
-- Factura 150 (3 productos)
(59.99, 20.00, 150, 8), (39.99, 10.00, 150, 70), (29.99, 20.00, 150, 197),
-- Factura 151 (2 productos)
(29.99, 10.00, 151, 16), (20.00, 10.00, 151, 82),
-- Factura 152 (2 productos)
(39.99, 15.00, 152, 41), (39.99, 15.00, 152, 95),
-- Factura 153 (1 producto)
(19.99, 0.00, 153, 118),
-- Factura 154 (3 productos)
(49.99, 10.00, 154, 22), (29.99, 20.00, 154, 62), (19.98, 10.00, 154, 147),
-- Factura 155 (1 producto)
(34.99, 0.00, 155, 160),
-- Factura 156 (2 productos)
(39.99, 10.00, 156, 49), (20.00, 0.00, 156, 109),
-- Factura 157 (3 productos)
(49.99, 15.00, 157, 35), (29.99, 10.00, 157, 78), (19.99, 20.00, 157, 170),
-- Factura 158 (1 producto)
(14.99, 0.00, 158, 98),
-- Factura 159 (2 productos)
(39.99, 10.00, 159, 37), (29.99, 15.00, 159, 127),
-- Factura 160 (1 producto)
(49.99, 0.00, 160, 142),
-- Factura 161 (2 productos)
(49.99, 10.00, 161, 51), (29.99, 15.00, 161, 115),
-- Factura 162 (1 producto)
(29.99, 0.00, 162, 177),
-- Factura 163 (2 productos)
(39.99, 10.00, 163, 29), (20.00, 20.00, 163, 88),
-- Factura 164 (3 productos)
(49.99, 20.00, 164, 19), (39.99, 10.00, 164, 56), (19.97, 15.00, 164, 199),
-- Factura 165 (1 producto)
(24.99, 0.00, 165, 135),
-- Factura 166 (2 productos)
(29.99, 0.00, 166, 38), (20.00, 10.00, 166, 102),
-- Factura 167 (1 producto)
(39.99, 0.00, 167, 163),
-- Factura 168 (3 productos)
(59.99, 20.00, 168, 25), (39.99, 10.00, 168, 67), (19.99, 15.00, 168, 209),
-- Factura 169 (1 producto)
(19.99, 0.00, 169, 149),
-- Factura 170 (2 productos)
(39.99, 10.00, 170, 46), (20.00, 10.00, 170, 100),
-- Factura 171 (2 productos)
(24.99, 0.00, 171, 92), (19.99, 10.00, 171, 118),
-- Factura 172 (2 productos)
(59.99, 20.00, 172, 17), (30.00, 10.00, 172, 74),
-- Factura 173 (1 producto)
(15.99, 0.00, 173, 183),
-- Factura 174 (2 productos)
(39.99, 10.00, 174, 33), (29.99, 20.00, 174, 111),
-- Factura 175 (1 producto)
(39.99, 0.00, 175, 153),
-- Factura 176 (2 productos)
(39.99, 10.00, 176, 59), (20.00, 0.00, 176, 131),
-- Factura 177 (3 productos)
(49.99, 15.00, 177, 27), (29.99, 10.00, 177, 81), (19.98, 20.00, 177, 188),
-- Factura 178 (1 producto)
(19.99, 0.00, 178, 206),
-- Factura 179 (2 productos)
(29.99, 0.00, 179, 52), (20.00, 10.00, 179, 137),
-- Factura 180 (2 productos)
(49.99, 20.00, 180, 36), (29.99, 10.00, 180, 85),
-- Factura 181 (1 producto)
(39.99, 0.00, 181, 171),
-- Factura 182 (3 productos)
(39.99, 10.00, 182, 44), (29.99, 20.00, 182, 97), (19.99, 0.00, 182, 201),
-- Factura 183 (1 producto)
(14.99, 0.00, 183, 128),
-- Factura 184 (2 productos)
(39.99, 10.00, 184, 57), (20.00, 10.00, 184, 140),
-- Factura 185 (2 productos)
(39.99, 10.00, 185, 32), (29.99, 15.00, 185, 114),
-- Factura 186 (1 producto)
(29.99, 0.00, 186, 185),
-- Factura 187 (3 productos)
(49.99, 20.00, 187, 23), (29.99, 10.00, 187, 70), (19.97, 20.00, 187, 207),
-- Factura 188 (1 producto)
(19.99, 0.00, 188, 193),
-- Factura 189 (2 productos)
(29.99, 0.00, 189, 65), (20.00, 10.00, 189, 156),
-- Factura 190 (2 productos)
(49.99, 20.00, 190, 40), (29.99, 0.00, 190, 122),
-- Factura 191 (1 producto)
(39.99, 0.00, 191, 198),
-- Factura 192 (2 productos)
(39.99, 10.00, 192, 50), (20.00, 0.00, 192, 133),
-- Factura 193 (3 productos)
(49.99, 15.00, 193, 28), (39.99, 10.00, 193, 83), (29.98, 20.00, 193, 204),
-- Factura 194 (1 producto)
(24.99, 0.00, 194, 175),
-- Factura 195 (2 productos)
(39.99, 10.00, 195, 43), (29.99, 15.00, 195, 116),
-- Factura 196 (1 producto)
(49.99, 10.00, 196, 79),
-- Factura 197 (2 productos)
(59.99, 10.00, 197, 34), (29.00, 20.00, 197, 151),
-- Factura 198 (1 producto)
(19.99, 0.00, 198, 210),
-- Factura 199 (2 productos)
(39.99, 10.00, 199, 61), (20.00, 0.00, 199, 164),
-- Factura 200 (3 productos)
(59.99, 20.00, 200, 15), (39.99, 10.00, 200, 77), (29.99, 20.00, 200, 200),
-- Factura 201 (2 productos)
(29.99, 10.00, 201, 18), (20.00, 10.00, 201, 84),
-- Factura 202 (2 productos)
(39.99, 15.00, 202, 43), (39.99, 15.00, 202, 97),
-- Factura 203 (1 producto)
(19.99, 0.00, 203, 120),
-- Factura 204 (3 productos)
(49.99, 10.00, 204, 24), (29.99, 20.00, 204, 64), (19.98, 10.00, 204, 149),
-- Factura 205 (1 producto)
(34.99, 0.00, 205, 162),
-- Factura 206 (2 productos)
(39.99, 10.00, 206, 51), (20.00, 0.00, 206, 111),
-- Factura 207 (3 productos)
(49.99, 15.00, 207, 37), (29.99, 10.00, 207, 80), (19.99, 20.00, 207, 172),
-- Factura 208 (1 producto)
(14.99, 0.00, 208, 100),
-- Factura 209 (2 productos)
(39.99, 10.00, 209, 39), (29.99, 15.00, 209, 129),
-- Factura 210 (1 producto)
(49.99, 0.00, 210, 144),
-- Factura 211 (2 productos)
(49.99, 10.00, 211, 53), (29.99, 15.00, 211, 117),
-- Factura 212 (1 producto)
(29.99, 0.00, 212, 179),
-- Factura 213 (2 productos)
(39.99, 10.00, 213, 31), (20.00, 20.00, 213, 90),
-- Factura 214 (3 productos)
(49.99, 20.00, 214, 21), (39.99, 10.00, 214, 58), (19.97, 15.00, 214, 201),
-- Factura 215 (1 producto)
(24.99, 0.00, 215, 137),
-- Factura 216 (2 productos)
(29.99, 0.00, 216, 40), (20.00, 10.00, 216, 104),
-- Factura 217 (1 producto)
(39.99, 0.00, 217, 165),
-- Factura 218 (3 productos)
(59.99, 20.00, 218, 27), (39.99, 10.00, 218, 69), (19.99, 15.00, 218, 208),
-- Factura 219 (1 producto)
(19.99, 0.00, 219, 151),
-- Factura 220 (2 productos)
(39.99, 10.00, 220, 48), (20.00, 10.00, 220, 102),
-- Factura 221 (2 productos)
(24.99, 0.00, 221, 94), (19.99, 10.00, 221, 120),
-- Factura 222 (2 productos)
(59.99, 20.00, 222, 19), (30.00, 10.00, 222, 76),
-- Factura 223 (1 producto)
(15.99, 0.00, 223, 185),
-- Factura 224 (2 productos)
(39.99, 10.00, 224, 35), (29.99, 20.00, 224, 113),
-- Factura 225 (1 producto)
(39.99, 0.00, 225, 155),
-- Factura 226 (2 productos)
(39.99, 10.00, 226, 61), (20.00, 0.00, 226, 133),
-- Factura 227 (3 productos)
(49.99, 15.00, 227, 29), (29.99, 10.00, 227, 83), (19.98, 20.00, 227, 190),
-- Factura 228 (1 producto)
(19.99, 0.00, 228, 207),
-- Factura 229 (2 productos)
(29.99, 0.00, 229, 54), (20.00, 10.00, 229, 139),
-- Factura 230 (2 productos)
(49.99, 20.00, 230, 38), (29.99, 10.00, 230, 87),
-- Factura 231 (1 producto)
(39.99, 0.00, 231, 173),
-- Factura 232 (3 productos)
(39.99, 10.00, 232, 46), (29.99, 20.00, 232, 99), (19.99, 0.00, 232, 203),
-- Factura 233 (1 producto)
(14.99, 0.00, 233, 130),
-- Factura 234 (2 productos)
(39.99, 10.00, 234, 59), (20.00, 10.00, 234, 142),
-- Factura 235 (2 productos)
(39.99, 10.00, 235, 34), (29.99, 15.00, 235, 116),
-- Factura 236 (1 producto)
(29.99, 0.00, 236, 187),
-- Factura 237 (3 productos)
(49.99, 20.00, 237, 25), (29.99, 10.00, 237, 72), (19.97, 20.00, 237, 209),
-- Factura 238 (1 producto)
(19.99, 0.00, 238, 195),
-- Factura 239 (2 productos)
(29.99, 0.00, 239, 67), (20.00, 10.00, 239, 158),
-- Factura 240 (2 productos)
(49.99, 20.00, 240, 42), (29.99, 0.00, 240, 124),
-- Factura 241 (1 producto)
(39.99, 0.00, 241, 200),
-- Factura 242 (2 productos)
(39.99, 10.00, 242, 52), (20.00, 0.00, 242, 135),
-- Factura 243 (3 productos)
(49.99, 15.00, 243, 30), (39.99, 10.00, 243, 85), (29.98, 20.00, 243, 206),
-- Factura 244 (1 producto)
(24.99, 0.00, 244, 177),
-- Factura 245 (2 productos)
(39.99, 10.00, 245, 45), (29.99, 15.00, 245, 118),
-- Factura 246 (1 producto)
(49.99, 10.00, 246, 81),
-- Factura 247 (2 productos)
(59.99, 10.00, 247, 36), (29.00, 20.00, 247, 153),
-- Factura 248 (1 producto)
(19.99, 0.00, 248, 208),
-- Factura 249 (2 productos)
(39.99, 10.00, 249, 63), (20.00, 0.00, 249, 166),
-- Factura 250 (3 productos)
(59.99, 20.00, 250, 17), (39.99, 10.00, 250, 79), (29.99, 20.00, 250, 202),
-- Factura 251 (2 productos)
(29.99, 10.00, 251, 20), (20.00, 10.00, 251, 86),
-- Factura 252 (2 productos)
(39.99, 15.00, 252, 45), (39.99, 15.00, 252, 99),
-- Factura 253 (1 producto)
(19.99, 0.00, 253, 122),
-- Factura 254 (3 productos)
(49.99, 10.00, 254, 26), (29.99, 20.00, 254, 66), (19.98, 10.00, 254, 151),
-- Factura 255 (1 producto)
(34.99, 0.00, 255, 164),
-- Factura 256 (2 productos)
(39.99, 10.00, 256, 53), (20.00, 0.00, 256, 113),
-- Factura 257 (3 productos)
(49.99, 15.00, 257, 39), (29.99, 10.00, 257, 82), (19.99, 20.00, 257, 174),
-- Factura 258 (1 producto)
(14.99, 0.00, 258, 102),
-- Factura 259 (2 productos)
(39.99, 10.00, 259, 41), (29.99, 15.00, 259, 131),
-- Factura 260 (1 producto)
(49.99, 0.00, 260, 146),
-- Factura 261 (2 productos)
(49.99, 10.00, 261, 55), (29.99, 15.00, 261, 119),
-- Factura 262 (1 producto)
(29.99, 0.00, 262, 181),
-- Factura 263 (2 productos)
(39.99, 10.00, 263, 33), (20.00, 20.00, 263, 92),
-- Factura 264 (3 productos)
(49.99, 20.00, 264, 23), (39.99, 10.00, 264, 60), (19.97, 15.00, 264, 203),
-- Factura 265 (1 producto)
(24.99, 0.00, 265, 139),
-- Factura 266 (2 productos)
(29.99, 0.00, 266, 42), (20.00, 10.00, 266, 106),
-- Factura 267 (1 producto)
(39.99, 0.00, 267, 167),
-- Factura 268 (3 productos)
(59.99, 20.00, 268, 29), (39.99, 10.00, 268, 71), (19.99, 15.00, 268, 210),
-- Factura 269 (1 producto)
(19.99, 0.00, 269, 153),
-- Factura 270 (2 productos)
(39.99, 10.00, 270, 50), (20.00, 10.00, 270, 104),
-- Factura 271 (2 productos)
(24.99, 0.00, 271, 96), (19.99, 10.00, 271, 122),
-- Factura 272 (2 productos)
(59.99, 20.00, 272, 21), (30.00, 10.00, 272, 78),
-- Factura 273 (1 producto)
(15.99, 0.00, 273, 187),
-- Factura 274 (2 productos)
(39.99, 10.00, 274, 37), (29.99, 20.00, 274, 115),
-- Factura 275 (1 producto)
(39.99, 0.00, 275, 157),
-- Factura 276 (2 productos)
(39.99, 10.00, 276, 63), (20.00, 0.00, 276, 135),
-- Factura 277 (3 productos)
(49.99, 15.00, 277, 31), (29.99, 10.00, 277, 85), (19.98, 20.00, 277, 192),
-- Factura 278 (1 producto)
(19.99, 0.00, 278, 209),
-- Factura 279 (2 productos)
(29.99, 0.00, 279, 56), (20.00, 10.00, 279, 141),
-- Factura 280 (2 productos)
(49.99, 20.00, 280, 40), (29.99, 10.00, 280, 89),
-- Factura 281 (1 producto)
(39.99, 0.00, 281, 175),
-- Factura 282 (3 productos)
(39.99, 10.00, 282, 48), (29.99, 20.00, 282, 101), (19.99, 0.00, 282, 205),
-- Factura 283 (1 producto)
(14.99, 0.00, 283, 132),
-- Factura 284 (2 productos)
(39.99, 10.00, 284, 61), (20.00, 10.00, 284, 144),
-- Factura 285 (2 productos)
(39.99, 10.00, 285, 36), (29.99, 15.00, 285, 118),
-- Factura 286 (1 producto)
(29.99, 0.00, 286, 189),
-- Factura 287 (3 productos)
(49.99, 20.00, 287, 27), (29.99, 10.00, 287, 74), (19.97, 20.00, 287, 201),
-- Factura 288 (1 producto)
(19.99, 0.00, 288, 197),
-- Factura 289 (2 productos)
(29.99, 0.00, 289, 69), (20.00, 10.00, 289, 160),
-- Factura 290 (2 productos)
(49.99, 20.00, 290, 44), (29.99, 0.00, 290, 126),
-- Factura 291 (1 producto)
(39.99, 0.00, 291, 202),
-- Factura 292 (2 productos)
(39.99, 10.00, 292, 54), (20.00, 0.00, 292, 137),
-- Factura 293 (3 productos)
(49.99, 15.00, 293, 32), (39.99, 10.00, 293, 87), (29.98, 20.00, 293, 208),
-- Factura 294 (1 producto)
(24.99, 0.00, 294, 179),
-- Factura 295 (2 productos)
(39.99, 10.00, 295, 47), (29.99, 15.00, 295, 120),
-- Factura 296 (1 producto)
(49.99, 10.00, 296, 83),
-- Factura 297 (2 productos)
(59.99, 10.00, 297, 38), (29.00, 20.00, 297, 155),
-- Factura 298 (1 producto)
(19.99, 0.00, 298, 210),
-- Factura 299 (2 productos)
(39.99, 10.00, 299, 65), (20.00, 0.00, 299, 168),
-- Factura 300 (3 productos)
(59.99, 20.00, 300, 19), (39.99, 10.00, 300, 81), (29.99, 20.00, 300, 204),
-- Factura 301 (2 productos)
(29.99, 10.00, 301, 22), (20.00, 10.00, 301, 88),
-- Factura 302 (2 productos)
(39.99, 15.00, 302, 47), (39.99, 15.00, 302, 101),
-- Factura 303 (1 producto)
(19.99, 0.00, 303, 124),
-- Factura 304 (3 productos)
(49.99, 10.00, 304, 28), (29.99, 20.00, 304, 68), (19.98, 10.00, 304, 153),
-- Factura 305 (1 producto)
(34.99, 0.00, 305, 166),
-- Factura 306 (2 productos)
(39.99, 10.00, 306, 55), (20.00, 0.00, 306, 115),
-- Factura 307 (3 productos)
(49.99, 15.00, 307, 41), (29.99, 10.00, 307, 84), (19.99, 20.00, 307, 176),
-- Factura 308 (1 producto)
(14.99, 0.00, 308, 104),
-- Factura 309 (2 productos)
(39.99, 10.00, 309, 43), (29.99, 15.00, 309, 133),
-- Factura 310 (1 producto)
(49.99, 0.00, 310, 148),
-- Factura 311 (2 productos)
(49.99, 10.00, 311, 57), (29.99, 15.00, 311, 121),
-- Factura 312 (1 producto)
(29.99, 0.00, 312, 183),
-- Factura 313 (2 productos)
(39.99, 10.00, 313, 35), (20.00, 20.00, 313, 94),
-- Factura 314 (3 productos)
(49.99, 20.00, 314, 25), (39.99, 10.00, 314, 62), (19.97, 15.00, 314, 205),
-- Factura 315 (1 producto)
(24.99, 0.00, 315, 141),
-- Factura 316 (2 productos)
(29.99, 0.00, 316, 44), (20.00, 10.00, 316, 108),
-- Factura 317 (1 producto)
(39.99, 0.00, 317, 169),
-- Factura 318 (3 productos)
(59.99, 20.00, 318, 31), (39.99, 10.00, 318, 73), (19.99, 15.00, 318, 210),
-- Factura 319 (1 producto)
(19.99, 0.00, 319, 155),
-- Factura 320 (2 productos)
(39.99, 10.00, 320, 52), (20.00, 10.00, 320, 106),
-- Factura 321 (2 productos)
(24.99, 0.00, 321, 98), (19.99, 10.00, 321, 124),
-- Factura 322 (2 productos)
(59.99, 20.00, 322, 23), (30.00, 10.00, 322, 80),
-- Factura 323 (1 producto)
(15.99, 0.00, 323, 189),
-- Factura 324 (2 productos)
(39.99, 10.00, 324, 39), (29.99, 20.00, 324, 117),
-- Factura 325 (1 producto)
(39.99, 0.00, 325, 159),
-- Factura 326 (2 productos)
(39.99, 10.00, 326, 65), (20.00, 0.00, 326, 137),
-- Factura 327 (3 productos)
(49.99, 15.00, 327, 33), (29.99, 10.00, 327, 87), (19.98, 20.00, 327, 194),
-- Factura 328 (1 producto)
(19.99, 0.00, 328, 209),
-- Factura 329 (2 productos)
(29.99, 0.00, 329, 58), (20.00, 10.00, 329, 143),
-- Factura 330 (2 productos)
(49.99, 20.00, 330, 42), (29.99, 10.00, 330, 91),
-- Factura 331 (1 producto)
(39.99, 0.00, 331, 177),
-- Factura 332 (3 productos)
(39.99, 10.00, 332, 50), (29.99, 20.00, 332, 103), (19.99, 0.00, 332, 207),
-- Factura 333 (1 producto)
(14.99, 0.00, 333, 134),
-- Factura 334 (2 productos)
(39.99, 10.00, 334, 63), (20.00, 10.00, 334, 146),
-- Factura 335 (2 productos)
(39.99, 10.00, 335, 38), (29.99, 15.00, 335, 120),
-- Factura 336 (1 producto)
(29.99, 0.00, 336, 191),
-- Factura 337 (3 productos)
(49.99, 20.00, 337, 29), (29.99, 10.00, 337, 76), (19.97, 20.00, 337, 203),
-- Factura 338 (1 producto)
(19.99, 0.00, 338, 199),
-- Factura 339 (2 productos)
(29.99, 0.00, 339, 71), (20.00, 10.00, 339, 162),
-- Factura 340 (2 productos)
(49.99, 20.00, 340, 46), (29.99, 0.00, 340, 128),
-- Factura 341 (1 producto)
(39.99, 0.00, 341, 204),
-- Factura 342 (2 productos)
(39.99, 10.00, 342, 56), (20.00, 0.00, 342, 139),
-- Factura 343 (3 productos)
(49.99, 15.00, 343, 34), (39.99, 10.00, 343, 89), (29.98, 20.00, 343, 208),
-- Factura 344 (1 producto)
(24.99, 0.00, 344, 181),
-- Factura 345 (2 productos)
(39.99, 10.00, 345, 49), (29.99, 15.00, 345, 122),
-- Factura 346 (1 producto)
(49.99, 10.00, 346, 85),
-- Factura 347 (2 productos)
(59.99, 10.00, 347, 40), (29.00, 20.00, 347, 157),
-- Factura 348 (1 producto)
(19.99, 0.00, 348, 208),
-- Factura 349 (2 productos)
(39.99, 10.00, 349, 67), (20.00, 0.00, 349, 170),
-- Factura 350 (3 productos)
(59.99, 20.00, 350, 21), (39.99, 10.00, 350, 83), (29.99, 20.00, 350, 206),
-- Factura 351 (2 productos)
(29.99, 10.00, 351, 24), (20.00, 10.00, 351, 90),
-- Factura 352 (2 productos)
(39.99, 15.00, 352, 49), (39.99, 15.00, 352, 103),
-- Factura 353 (1 producto)
(19.99, 0.00, 353, 126),
-- Factura 354 (3 productos)
(49.99, 10.00, 354, 30), (29.99, 20.00, 354, 70), (19.98, 10.00, 354, 155),
-- Factura 355 (1 producto)
(34.99, 0.00, 355, 168),
-- Factura 356 (2 productos)
(39.99, 10.00, 356, 57), (20.00, 0.00, 356, 117),
-- Factura 357 (3 productos)
(49.99, 15.00, 357, 43), (29.99, 10.00, 357, 86), (19.99, 20.00, 357, 178),
-- Factura 358 (1 producto)
(14.99, 0.00, 358, 106),
-- Factura 359 (2 productos)
(39.99, 10.00, 359, 45), (29.99, 15.00, 359, 135),
-- Factura 360 (1 producto)
(49.99, 0.00, 360, 150),
-- Factura 361 (2 productos)
(49.99, 10.00, 361, 59), (29.99, 15.00, 361, 123),
-- Factura 362 (1 producto)
(29.99, 0.00, 362, 185),
-- Factura 363 (2 productos)
(39.99, 10.00, 363, 37), (20.00, 20.00, 363, 96),
-- Factura 364 (3 productos)
(49.99, 20.00, 364, 27), (39.99, 10.00, 364, 64), (19.97, 15.00, 364, 207),
-- Factura 365 (1 producto)
(24.99, 0.00, 365, 143),
-- Factura 366 (2 productos)
(29.99, 0.00, 366, 46), (20.00, 10.00, 366, 110),
-- Factura 367 (1 producto)
(39.99, 0.00, 367, 171),
-- Factura 368 (3 productos)
(59.99, 20.00, 368, 33), (39.99, 10.00, 368, 75), (19.99, 15.00, 368, 208),
-- Factura 369 (1 producto)
(19.99, 0.00, 369, 157),
-- Factura 370 (2 productos)
(39.99, 10.00, 370, 54), (20.00, 10.00, 370, 108),
-- Factura 371 (2 productos)
(24.99, 0.00, 371, 100), (19.99, 10.00, 371, 126),
-- Factura 372 (2 productos)
(59.99, 20.00, 372, 25), (30.00, 10.00, 372, 82),
-- Factura 373 (1 producto)
(15.99, 0.00, 373, 191),
-- Factura 374 (2 productos)
(39.99, 10.00, 374, 41), (29.99, 20.00, 374, 119),
-- Factura 375 (1 producto)
(39.99, 0.00, 375, 161),
-- Factura 376 (2 productos)
(39.99, 10.00, 376, 67), (20.00, 0.00, 376, 139),
-- Factura 377 (3 productos)
(49.99, 15.00, 377, 35), (29.99, 10.00, 377, 89), (19.98, 20.00, 377, 196),
-- Factura 378 (1 producto)
(19.99, 0.00, 378, 201),
-- Factura 379 (2 productos)
(29.99, 0.00, 379, 60), (20.00, 10.00, 379, 145),
-- Factura 380 (2 productos)
(49.99, 20.00, 380, 44), (29.99, 10.00, 380, 93),
-- Factura 381 (1 producto)
(39.99, 0.00, 381, 179),
-- Factura 382 (3 productos)
(39.99, 10.00, 382, 52), (29.99, 20.00, 382, 105), (19.99, 0.00, 382, 209),
-- Factura 383 (1 producto)
(14.99, 0.00, 383, 136),
-- Factura 384 (2 productos)
(39.99, 10.00, 384, 65), (20.00, 10.00, 384, 148),
-- Factura 385 (2 productos)
(39.99, 10.00, 385, 40), (29.99, 15.00, 385, 122),
-- Factura 386 (1 producto)
(29.99, 0.00, 386, 193),
-- Factura 387 (3 productos)
(49.99, 20.00, 387, 31), (29.99, 10.00, 387, 78), (19.97, 20.00, 387, 205),
-- Factura 388 (1 producto)
(19.99, 0.00, 388, 201),
-- Factura 389 (2 productos)
(29.99, 0.00, 389, 73), (20.00, 10.00, 389, 164),
-- Factura 390 (2 productos)
(49.99, 20.00, 390, 48), (29.99, 0.00, 390, 130),
-- Factura 391 (1 producto)
(39.99, 0.00, 391, 206),
-- Factura 392 (2 productos)
(39.99, 10.00, 392, 58), (20.00, 0.00, 392, 141),
-- Factura 393 (3 productos)
(49.99, 15.00, 393, 36), (39.99, 10.00, 393, 91), (29.98, 20.00, 393, 210),
-- Factura 394 (1 producto)
(24.99, 0.00, 394, 183),
-- Factura 395 (2 productos)
(39.99, 10.00, 395, 51), (29.99, 15.00, 395, 124),
-- Factura 396 (1 producto)
(49.99, 10.00, 396, 87),
-- Factura 397 (2 productos)
(59.99, 10.00, 397, 42), (29.00, 20.00, 397, 159),
-- Factura 398 (1 producto)
(19.99, 0.00, 398, 210),
-- Factura 399 (2 productos)
(39.99, 10.00, 399, 69), (20.00, 0.00, 399, 172),
-- Factura 400 (3 productos)
(59.99, 20.00, 400, 23), (39.99, 10.00, 400, 85), (29.99, 20.00, 400, 208),
-- Factura 401 (2 productos)
(29.99, 10.00, 401, 26), (20.00, 10.00, 401, 92),
-- Factura 402 (2 productos)
(39.99, 15.00, 402, 51), (39.99, 15.00, 402, 105),
-- Factura 403 (1 producto)
(19.99, 0.00, 403, 128),
-- Factura 404 (3 productos)
(49.99, 10.00, 404, 32), (29.99, 20.00, 404, 72), (19.98, 10.00, 404, 157),
-- Factura 405 (1 producto)
(34.99, 0.00, 405, 170),
-- Factura 406 (2 productos)
(39.99, 10.00, 406, 59), (20.00, 0.00, 406, 119),
-- Factura 407 (3 productos)
(49.99, 15.00, 407, 45), (29.99, 10.00, 407, 88), (19.99, 20.00, 407, 180),
-- Factura 408 (1 producto)
(14.99, 0.00, 408, 108),
-- Factura 409 (2 productos)
(39.99, 10.00, 409, 47), (29.99, 15.00, 409, 137),
-- Factura 410 (1 producto)
(49.99, 0.00, 410, 152),
-- Factura 411 (2 productos)
(49.99, 10.00, 411, 61), (29.99, 15.00, 411, 125),
-- Factura 412 (1 producto)
(29.99, 0.00, 412, 187),
-- Factura 413 (2 productos)
(39.99, 10.00, 413, 39), (20.00, 20.00, 413, 98),
-- Factura 414 (3 productos)
(49.99, 20.00, 414, 29), (39.99, 10.00, 414, 66), (19.97, 15.00, 414, 209),
-- Factura 415 (1 producto)
(24.99, 0.00, 415, 145),
-- Factura 416 (2 productos)
(29.99, 0.00, 416, 48), (20.00, 10.00, 416, 112),
-- Factura 417 (1 producto)
(39.99, 0.00, 417, 173),
-- Factura 418 (3 productos)
(59.99, 20.00, 418, 35), (39.99, 10.00, 418, 77), (19.99, 15.00, 418, 208),
-- Factura 419 (1 producto)
(19.99, 0.00, 419, 159),
-- Factura 420 (2 productos)
(39.99, 10.00, 420, 56), (20.00, 10.00, 420, 110),
-- Factura 421 (2 productos)
(24.99, 0.00, 421, 102), (19.99, 10.00, 421, 128),
-- Factura 422 (2 productos)
(59.99, 20.00, 422, 27), (30.00, 10.00, 422, 84),
-- Factura 423 (1 producto)
(15.99, 0.00, 423, 193),
-- Factura 424 (2 productos)
(39.99, 10.00, 424, 43), (29.99, 20.00, 424, 121),
-- Factura 425 (1 producto)
(39.99, 0.00, 425, 163),
-- Factura 426 (2 productos)
(39.99, 10.00, 426, 69), (20.00, 0.00, 426, 141),
-- Factura 427 (3 productos)
(49.99, 15.00, 427, 37), (29.99, 10.00, 427, 91), (19.98, 20.00, 427, 198),
-- Factura 428 (1 producto)
(19.99, 0.00, 428, 203),
-- Factura 429 (2 productos)
(29.99, 0.00, 429, 62), (20.00, 10.00, 429, 147),
-- Factura 430 (2 productos)
(49.99, 20.00, 430, 46), (29.99, 10.00, 430, 95),
-- Factura 431 (1 producto)
(39.99, 0.00, 431, 181),
-- Factura 432 (3 productos)
(39.99, 10.00, 432, 54), (29.99, 20.00, 432, 107), (19.99, 0.00, 432, 210),
-- Factura 433 (1 producto)
(14.99, 0.00, 433, 138),
-- Factura 434 (2 productos)
(39.99, 10.00, 434, 67), (20.00, 10.00, 434, 150),
-- Factura 435 (2 productos)
(39.99, 10.00, 435, 42), (29.99, 15.00, 435, 124),
-- Factura 436 (1 producto)
(29.99, 0.00, 436, 195),
-- Factura 437 (3 productos)
(49.99, 20.00, 437, 33), (29.99, 10.00, 437, 80), (19.97, 20.00, 437, 207),
-- Factura 438 (1 producto)
(19.99, 0.00, 438, 203),
-- Factura 439 (2 productos)
(29.99, 0.00, 439, 75), (20.00, 10.00, 439, 166),
-- Factura 440 (2 productos)
(49.99, 20.00, 440, 50), (29.99, 0.00, 440, 132),
-- Factura 441 (1 producto)
(39.99, 0.00, 441, 208),
-- Factura 442 (2 productos)
(39.99, 10.00, 442, 60), (20.00, 0.00, 442, 143),
-- Factura 443 (3 productos)
(49.99, 15.00, 443, 38), (39.99, 10.00, 443, 93), (29.98, 20.00, 443, 210),
-- Factura 444 (1 producto)
(24.99, 0.00, 444, 185),
-- Factura 445 (2 productos)
(39.99, 10.00, 445, 53), (29.99, 15.00, 445, 126),
-- Factura 446 (1 producto)
(49.99, 10.00, 446, 89),
-- Factura 447 (2 productos)
(59.99, 10.00, 447, 44), (29.00, 20.00, 447, 161),
-- Factura 448 (1 producto)
(19.99, 0.00, 448, 210),
-- Factura 449 (2 productos)
(39.99, 10.00, 449, 71), (20.00, 0.00, 449, 174),
-- Factura 450 (3 productos)
(59.99, 20.00, 450, 25), (39.99, 10.00, 450, 87), (29.99, 20.00, 450, 208),
-- Factura 451 (2 productos)
(29.99, 10.00, 451, 28), (20.00, 10.00, 451, 94),
-- Factura 452 (2 productos)
(39.99, 15.00, 452, 53), (39.99, 15.00, 452, 107),
-- Factura 453 (1 producto)
(19.99, 0.00, 453, 130),
-- Factura 454 (3 productos)
(49.99, 10.00, 454, 34), (29.99, 20.00, 454, 74), (19.98, 10.00, 454, 159),
-- Factura 455 (1 producto)
(34.99, 0.00, 455, 172),
-- Factura 456 (2 productos)
(39.99, 10.00, 456, 61), (20.00, 0.00, 456, 121),
-- Factura 457 (3 productos)
(49.99, 15.00, 457, 47), (29.99, 10.00, 457, 90), (19.99, 20.00, 457, 182),
-- Factura 458 (1 producto)
(14.99, 0.00, 458, 110),
-- Factura 459 (2 productos)
(39.99, 10.00, 459, 49), (29.99, 15.00, 459, 139),
-- Factura 460 (1 producto)
(49.99, 0.00, 460, 154),
-- Factura 461 (2 productos)
(49.99, 10.00, 461, 63), (29.99, 15.00, 461, 127),
-- Factura 462 (1 producto)
(29.99, 0.00, 462, 189),
-- Factura 463 (2 productos)
(39.99, 10.00, 463, 41), (20.00, 20.00, 463, 100),
-- Factura 464 (3 productos)
(49.99, 20.00, 464, 31), (39.99, 10.00, 464, 68), (19.97, 15.00, 464, 210),
-- Factura 465 (1 producto)
(24.99, 0.00, 465, 147),
-- Factura 466 (2 productos)
(29.99, 0.00, 466, 50), (20.00, 10.00, 466, 114),
-- Factura 467 (1 producto)
(39.99, 0.00, 467, 175),
-- Factura 468 (3 productos)
(59.99, 20.00, 468, 37), (39.99, 10.00, 468, 79), (19.99, 15.00, 468, 206),
-- Factura 469 (1 producto)
(19.99, 0.00, 469, 161),
-- Factura 470 (2 productos)
(39.99, 10.00, 470, 58), (20.00, 10.00, 470, 112),
-- Factura 471 (2 productos)
(24.99, 0.00, 471, 104), (19.99, 10.00, 471, 130),
-- Factura 472 (2 productos)
(59.99, 20.00, 472, 29), (30.00, 10.00, 472, 86),
-- Factura 473 (1 producto)
(15.99, 0.00, 473, 195),
-- Factura 474 (2 productos)
(39.99, 10.00, 474, 45), (29.99, 20.00, 474, 123),
-- Factura 475 (1 producto)
(39.99, 0.00, 475, 165),
-- Factura 476 (2 productos)
(39.99, 10.00, 476, 71), (20.00, 0.00, 476, 143),
-- Factura 477 (3 productos)
(49.99, 15.00, 477, 39), (29.99, 10.00, 477, 93), (19.98, 20.00, 477, 200),
-- Factura 478 (1 producto)
(19.99, 0.00, 478, 205),
-- Factura 479 (2 productos)
(29.99, 0.00, 479, 64), (20.00, 10.00, 479, 149),
-- Factura 480 (2 productos)
(49.99, 20.00, 480, 48), (29.99, 10.00, 480, 97),
-- Factura 481 (1 producto)
(39.99, 0.00, 481, 183),
-- Factura 482 (3 productos)
(39.99, 10.00, 482, 56), (29.99, 20.00, 482, 109), (19.99, 0.00, 482, 208),
-- Factura 483 (1 producto)
(14.99, 0.00, 483, 140),
-- Factura 484 (2 productos)
(39.99, 10.00, 484, 69), (20.00, 10.00, 484, 152),
-- Factura 485 (2 productos)
(39.99, 10.00, 485, 44), (29.99, 15.00, 485, 126),
-- Factura 486 (1 producto)
(29.99, 0.00, 486, 197),
-- Factura 487 (3 productos)
(49.99, 20.00, 487, 35), (29.99, 10.00, 487, 82), (19.97, 20.00, 487, 209),
-- Factura 488 (1 producto)
(19.99, 0.00, 488, 205),
-- Factura 489 (2 productos)
(29.99, 0.00, 489, 77), (20.00, 10.00, 489, 168),
-- Factura 490 (2 productos)
(49.99, 20.00, 490, 52), (29.99, 0.00, 490, 134),
-- Factura 491 (1 producto)
(39.99, 0.00, 491, 210),
-- Factura 492 (2 productos)
(39.99, 10.00, 492, 62), (20.00, 0.00, 492, 145),
-- Factura 493 (3 productos)
(49.99, 15.00, 493, 40), (39.99, 10.00, 493, 95), (29.98, 20.00, 493, 208),
-- Factura 494 (1 producto)
(24.99, 0.00, 494, 187),
-- Factura 495 (2 productos)
(39.99, 10.00, 495, 55), (29.99, 15.00, 495, 128),
-- Factura 496 (1 producto)
(49.99, 10.00, 496, 91),
-- Factura 497 (2 productos)
(59.99, 10.00, 497, 46), (29.00, 20.00, 497, 163),
-- Factura 498 (1 producto)
(19.99, 0.00, 498, 207),
-- Factura 499 (2 productos)
(39.99, 10.00, 499, 73), (20.00, 0.00, 499, 176),
-- Factura 500 (3 productos)
(59.99, 20.00, 500, 27), (39.99, 10.00, 500, 89), (29.99, 20.00, 500, 206),

(0.00, 0.00, 501, 301),  
(19.99, 0.00, 501, 302),
(19.99, 0.00, 501, 303),
(9.99, 0.00, 501, 304),
(19.99, 0.00, 501, 305),
(4.99, 0.00, 501, 306),
(19.99, 0.00, 501, 307),
(9.99, 0.00, 501, 308),

(0.00, 0.00, 502, 301), 
(19.99, 0.00, 502, 302),
(19.99, 0.00, 502, 303),
(9.99, 0.00, 502, 304),
(19.99, 0.00, 502, 305),
(4.99, 0.00, 502, 306),
(25.00, 0.00, 601, 9),   
(15.00, 0.00, 601, 315),
(40.00, 0.00, 602, 316),

(60.00, 0.00, 603, 317),
(60.00, 0.00, 604, 317);


INSERT INTO Detalle_Factura (Precio_Venta_Historico, Descuento_Aplicado_Pct, ID_Factura_FK, ID_Producto_FK) VALUES
-- 51 Detalles para Producto 36
(59.99, 0, 1001, 36), (59.99, 0, 1002, 36), (59.99, 0, 1003, 36), (59.99, 0, 1004, 36), (59.99, 0, 1005, 36),
(59.99, 0, 1006, 36), (59.99, 0, 1007, 36), (59.99, 0, 1008, 36), (59.99, 0, 1009, 36), (59.99, 0, 1010, 36),
(59.99, 0, 1011, 36), (59.99, 0, 1012, 36), (59.99, 0, 1013, 36), (59.99, 0, 1014, 36), (59.99, 0, 1015, 36),
(59.99, 0, 1016, 36), (59.99, 0, 1017, 36), (59.99, 0, 1018, 36), (59.99, 0, 1019, 36), (59.99, 0, 1020, 36),
(59.99, 0, 1021, 36), (59.99, 0, 1022, 36), (59.99, 0, 1023, 36), (59.99, 0, 1024, 36), (59.99, 0, 1025, 36),
(59.99, 0, 1026, 36), (59.99, 0, 1027, 36), (59.99, 0, 1028, 36), (59.99, 0, 1029, 36), (59.99, 0, 1030, 36),
(59.99, 0, 1031, 36), (59.99, 0, 1032, 36), (59.99, 0, 1033, 36), (59.99, 0, 1034, 36), (59.99, 0, 1035, 36),
(59.99, 0, 1036, 36), (59.99, 0, 1037, 36), (59.99, 0, 1038, 36), (59.99, 0, 1039, 36), (59.99, 0, 1040, 36),
(59.99, 0, 1041, 36), (59.99, 0, 1042, 36), (59.99, 0, 1043, 36), (59.99, 0, 1044, 36), (59.99, 0, 1045, 36),
(59.99, 0, 1046, 36), (59.99, 0, 1047, 36), (59.99, 0, 1048, 36), (59.99, 0, 1049, 36), (59.99, 0, 1050, 36),
(59.99, 0, 1051, 36),

-- 51 Detalles para Producto 88
(69.99, 0, 1052, 88), (69.99, 0, 1053, 88), (69.99, 0, 1054, 88), (69.99, 0, 1055, 88), (69.99, 0, 1056, 88),
(69.99, 0, 1057, 88), (69.99, 0, 1058, 88), (69.99, 0, 1059, 88), (69.99, 0, 1060, 88), (69.99, 0, 1061, 88),
(69.99, 0, 1062, 88), (69.99, 0, 1063, 88), (69.99, 0, 1064, 88), (69.99, 0, 1065, 88), (69.99, 0, 1066, 88),
(69.99, 0, 1067, 88), (69.99, 0, 1068, 88), (69.99, 0, 1069, 88), (69.99, 0, 1070, 88), (69.99, 0, 1071, 88),
(69.99, 0, 1072, 88), (69.99, 0, 1073, 88), (69.99, 0, 1074, 88), (69.99, 0, 1075, 88), (69.99, 0, 1076, 88),
(69.99, 0, 1077, 88), (69.99, 0, 1078, 88), (69.99, 0, 1079, 88), (69.99, 0, 1080, 88), (69.99, 0, 1081, 88),
(69.99, 0, 1082, 88), (69.99, 0, 1083, 88), (69.99, 0, 1084, 88), (69.99, 0, 1085, 88), (69.99, 0, 1086, 88),
(69.99, 0, 1087, 88), (69.99, 0, 1088, 88), (69.99, 0, 1089, 88), (69.99, 0, 1090, 88), (69.99, 0, 1091, 88),
(69.99, 0, 1092, 88), (69.99, 0, 1093, 88), (69.99, 0, 1094, 88), (69.99, 0, 1095, 88), (69.99, 0, 1096, 88),
(69.99, 0, 1097, 88), (69.99, 0, 1098, 88), (69.99, 0, 1099, 88), (69.99, 0, 1100, 88), (69.99, 0, 1101, 88),
(69.99, 0, 1102, 88);



/* ---------------------------- 3. Reembolso --------------------------- */
SET IDENTITY_INSERT Reembolso ON;

INSERT INTO Reembolso (ID_Reembolso, Fecha_Reembolso, Monto_Reembolsado, Motivo, ID_Factura_FK, ID_Producto_FK) VALUES
-- Reembolsos asociados a facturas de los primeros usuarios
(1, '2024-10-20', 59.99, 'Problemas graves de rendimiento en el equipo del usuario.', 1, 12),
(2, '2024-10-25', 19.99, 'El juego no cumple con las expectativas prometidas.', 2, 8),
(3, '2024-11-08', 19.99, 'Error de compra accidental.', 3, 55),
(4, '2024-11-15', 49.99, 'Incompatibilidad con el sistema operativo.', 4, 3),
(5, '2024-11-25', 29.99, 'El usuario experimentó mareos por movimiento.', 5, 88),
(6, '2024-12-05', 39.99, 'El juego presenta bugs que impiden el progreso.', 6, 19),
(7, '2024-12-15', 59.99, 'Compra duplicada por error.', 7, 5),
(8, '2024-12-20', 14.99, 'El juego no es compatible con el mando del usuario.', 8, 41),
(9, '2024-12-28', 39.99, 'La historia no era lo que esperaba.', 9, 2),
(10, '2025-01-08', 39.99, 'Problemas de conexión en el modo multijugador.', 10, 110),
(11, '2025-01-15', 49.99, 'El rendimiento en PC es muy bajo.', 11, 25),
(12, '2025-01-25', 19.99, 'El usuario compró el juego equivocado.', 12, 134),
(13, '2025-02-01', 39.99, 'El juego no inicia después de la instalación.', 13, 11),
(14, '2025-02-10', 49.99, 'Los gráficos no coinciden con la publicidad.', 14, 4),
(15, '2025-02-15', 24.99, 'El juego es demasiado corto para el precio.', 15, 60),
(16, '2025-02-22', 29.99, 'Problemas de guardado corrupto.', 16, 18),
(17, '2025-03-01', 34.99, 'El usuario no puede jugar por falta de tiempo.', 17, 122),
(18, '2025-03-08', 59.99, 'El juego no es apto para la edad del usuario.', 18, 7),
(19, '2025-03-15', 19.99, 'Error en la compra, el usuario ya tenía el juego.', 19, 31),
(20, '2025-03-22', 39.99, 'El juego tiene problemas de audio.', 20, 15),
(21, '2025-03-28', 24.99, 'El usuario encontró una mejor oferta en otra tienda.', 21, 84),
(22, '2025-04-05', 59.99, 'El juego no es compatible con la tarjeta gráfica.', 22, 1),
(23, '2025-04-12', 15.99, 'El usuario no puede ejecutar el juego en su PC.', 23, 140),
(24, '2025-04-20', 39.99, 'Problemas de rendimiento en el modo ventana.', 24, 21),
(25, '2025-04-28', 29.99, 'El juego no tiene el idioma español.', 25, 118),
(26, '2025-05-05', 39.99, 'El usuario se arrepintió de la compra.', 26, 36),
(27, '2025-05-12', 49.99, 'El juego no funciona con el sistema operativo.', 27, 9),
(28, '2025-05-20', 19.99, 'El usuario no tiene suficiente espacio en disco.', 28, 175),
(29, '2025-05-28', 29.99, 'El juego tiene problemas de compatibilidad con mods.', 29, 43),
(30, '2025-06-05', 49.99, 'El usuario no puede acceder al contenido adicional.', 30, 13),
(31, '2026-10-05', 9.99, 'El DLC no era compatible con mi mod', 501, 304),
(41, '2026-10-22', 25.00, 'El juego no cumple con los requisitos mínimos', 601, 9),
(42, '2026-10-23', 40.00, 'El juego tiene muchos bugs', 602, 316);



SET IDENTITY_INSERT Reembolso OFF;


GO




/* -------------------- MOD -------------------------*/

INSERT INTO Mod (ID_Producto_FK, ID_Mod, Nombre_Mod, Descripcion_Mod, Tamano_MB) VALUES

-- ==================== Mods para Cyberpunk 2077 (ID_Producto = 1) ====================
(1, 1, 'Cyber Engine Tweaks', 'Framework de scripting en Lua para mods avanzados y consola de comandos.', 15.00),
(1, 2, 'Redscript', 'Compilador de scripts que permite modificar la lógica interna del juego.', 8.00),
(1, 3, 'Better Vehicle Handling', 'Mejora la física y el manejo de todos los vehículos del juego.', 2.50),
(1, 4, 'Immersive First Person', 'Añade balanceo de cámara y cuerpo visible en primera persona.', 5.00),
(1, 5, 'Night City ReShade', 'Preset de ReShade para gráficos ultra realistas y cinematográficos.', 1.00),

-- ==================== Mods para Elden Ring (ID_Producto = 3) ====================
(3, 1, 'Seamless Co-op', 'Permite jugar toda la campaña en cooperativo sin invasiones ni interrupciones.', 3.00),
(3, 2, 'Easy Mode', 'Reduce la dificultad de los enemigos y jefes para jugadores casuales.', 1.50),
(3, 3, 'Map for Goblins', 'Añade marcadores de todos los objetos importantes al mapa.', 2.00),
(3, 4, 'Ultrawide Fix', 'Soporte nativo para monitores ultrapanorámicos 21:9 y 32:9.', 0.50),
(3, 5, 'Item Randomizer', 'Aleatoriza enemigos, objetos y jefes en cada nueva partida.', 4.00),

-- ==================== Mods para The Witcher 3 (ID_Producto = 5) ====================
(5, 1, 'HD Reworked Project', 'Texturas en alta resolución para todo el juego, desde paisajes hasta NPCs.', 800.00),
(5, 2, 'Fast Travel from Anywhere', 'Permite viajar rápido desde cualquier punto del mapa sin necesidad de postes.', 1.00),
(5, 3, 'Over 9000 Weight Limit', 'Aumenta el límite de peso del inventario a 9000 unidades.', 0.50),
(5, 4, 'AutoLoot', 'Recoge automáticamente todos los objetos del suelo al acercarte.', 1.20),
(5, 5, 'Friendly HUD', 'Interfaz más limpia, configurable y con menos elementos invasivos.', 3.50),

-- ==================== Mods para Minecraft (ID_Producto = 9) ====================
(9, 1, 'OptiFine', 'Optimización gráfica avanzada y soporte completo para shaders.', 25.00),
(9, 2, 'JourneyMap', 'Minimapa y mapa mundial en tiempo real con marcadores personalizados.', 12.00),
(9, 3, 'JEI (Just Enough Items)', 'Consulta recetas de crafteo y usos de cualquier objeto del juego.', 8.00),
(9, 4, 'Biomes O Plenty', 'Añade más de 80 biomas nuevos con flora y fauna únicas.', 150.00),
(9, 5, 'Create', 'Mod de automatización y ingeniería mecánica con engranajes y cintas.', 200.00),

-- ==================== Mods para Skyrim (ID_Producto = 27) ====================
(27, 1, 'SkyUI', 'Interfaz de usuario mejorada y optimizada para PC.', 5.00),
(27, 2, 'Unofficial Skyrim Patch', 'Corrige cientos de bugs del juego base y sus DLCs.', 20.00),
(27, 3, 'Alternate Start', 'Comienza el juego en diferentes situaciones sin la intro del carro.', 15.00),
(27, 4, 'Immersive Armors', 'Añade más de 50 armaduras lore-friendly al juego.', 300.00),
(27, 5, 'Frostfall', 'Sistema de supervivencia por frío, clima y exposición ambiental.', 18.00),

-- ==================== Mods para Stardew Valley (ID_Producto = 17) ====================
(17, 1, 'Stardew Valley Expanded', 'Expansión masiva con nuevos NPCs, mapas, eventos y romance.', 250.00),
(17, 2, 'Automate', 'Automatiza cofres y máquinas de procesamiento para producción pasiva.', 10.00),
(17, 3, 'Tractor Mod', 'Añade un tractor para acelerar tareas agrícolas y de recolección.', 5.00),
(17, 4, 'Lookup Anything', 'Consulta información detallada de cualquier objeto con una tecla.', 2.00),
(17, 5, 'NPC Map Locations', 'Muestra la ubicación de todos los NPCs en el minimapa.', 3.00),

-- ==================== Mods para Baldurs Gate 3 (ID_Producto = 10) ====================
(10, 1, 'Improved UI', 'Mejora la interfaz de inventario, hechizos y hojas de personaje.', 8.00),
(10, 2, 'Party Limit Begone', 'Permite tener hasta 8 miembros en el grupo activo.', 2.00),
(10, 3, '5e Spells', 'Añade hechizos adicionales del manual de D&D 5e.', 15.00),
(10, 4, 'Basket Full of Equipment', 'Añade cientos de piezas de equipo y armaduras nuevas.', 120.00),
(10, 5, 'WASD Character Movement', 'Permite mover al personaje con WASD en lugar de click.', 4.00),

-- ==================== Mods para Hollow Knight (ID_Producto = 15) ====================
(15, 1, 'Randomizer', 'Aleatoriza objetos, habilidades y jefes en cada partida.', 3.00),
(15, 2, 'Benchwarp', 'Teletransporte instantáneo entre bancos guardados.', 1.50),
(15, 3, 'Debug Mod', 'Herramientas de depuración para speedrunners y modders.', 2.00),
(15, 4, 'Custom Knight', 'Personalización visual completa del Caballero.', 5.00),

-- ==================== Mods para Terraria (ID_Producto = 16) ====================
(16, 1, 'Calamity Mod', 'Expansión masiva con nuevos jefes, biomas, armas y progresión.', 500.00),
(16, 2, 'Thorium Mod', 'Añade nuevas clases, armas, jefes y contenido de pesca.', 200.00),
(16, 3, 'Recipe Browser', 'Consulta todas las recetas de crafteo del juego y mods.', 4.00),
(16, 4, 'Boss Checklist', 'Lista de todos los jefes y su orden recomendado de progresión.', 2.00),

-- ==================== Mods para Cities: Skylines (ID_Producto = 60) ====================
(60, 1, 'Traffic Manager: President Edition', 'Control total del tráfico, semáforos y carriles.', 12.00),
(60, 2, 'Move It', 'Mueve y edita cualquier objeto o edificio del mapa.', 5.00),
(60, 3, '81 Tiles', 'Desbloquea las 81 casillas del mapa para construir.', 3.00),

-- ==================== Mods para RimWorld (ID_Producto = 72) ====================
(72, 1, 'Prepare Carefully', 'Personaliza a tus colonos antes de empezar la partida.', 4.00),
(72, 2, 'Hospitality', 'Permite recibir visitantes y huéspedes en tu colonia.', 8.00),
(72, 3, 'EdB Prepare Carefully', 'Edición avanzada de colonos con puntos y habilidades.', 6.00),

-- ==================== Mods para Factorio (ID_Producto = 71) ====================
(71, 1, 'Bob''s Mods', 'Conjunto de mods que expanden la industria y la logística.', 150.00),
(71, 2, 'Angel''s Mods', 'Refinería y petroquímica avanzada con cadenas de producción.', 200.00),
(71, 3, 'Space Exploration', 'Expansión espacial con múltiples planetas y logística interplanetaria.', 80.00),

(301, 1, 'Sims 4: Mod de Embarazo Realista', 'Añade un sistema completo de embarazo con ecografías, antojos, partos en el hospital y genética mejorada para los bebés.', 15.50);






/* -------------------- SUSCRIPCION_MOD -------------------------*/


INSERT INTO Suscripcion_Mod (ID_Usuario_FK, ID_Producto_Base_FK, ID_Mod_FK, Fecha_Suscripcion) VALUES

-- ==================== Usuario 1 (ShadowGamer99) — Cyberpunk 2077 (1) ====================
(1, 1, 1, '2024-10-25'),   -- Cyber Engine Tweaks
(1, 1, 3, '2024-10-26'),   -- Better Vehicle Handling
(1, 1, 5, '2024-11-01'),   -- Night City ReShade

-- ==================== Usuario 2 (PixelQueen) — Stardew Valley (17) ====================
(2, 17, 1, '2024-10-28'),  -- Stardew Valley Expanded
(2, 17, 2, '2024-11-02'),  -- Automate
(2, 17, 5, '2024-11-05'),  -- NPC Map Locations

-- ==================== Usuario 3 (CyberSamurai) — Elden Ring (3) ====================
(3, 3, 1, '2024-11-10'),   -- Seamless Co-op
(3, 3, 3, '2024-11-12'),   -- Map for Goblins
(3, 3, 4, '2024-11-15'),   -- Ultrawide Fix

-- ==================== Usuario 4 (DragonSlayer_VE) — Skyrim (27) ====================
(4, 27, 1, '2024-11-15'),  -- SkyUI
(4, 27, 2, '2024-11-18'),  -- Unofficial Skyrim Patch
(4, 27, 4, '2024-11-20'),  -- Immersive Armors

-- ==================== Usuario 5 (NeonValkyrie) — Minecraft (9) ====================
(5, 9, 1, '2024-12-05'),   -- OptiFine
(5, 9, 3, '2024-12-08'),   -- JEI

-- ==================== Usuario 6 (RoxasBlade) — Terraria (16) ====================
(6, 16, 1, '2024-12-18'),  -- Calamity Mod
(6, 16, 2, '2024-12-20'),  -- Thorium Mod

-- ==================== Usuario 7 (AeroSniper) — The Witcher 3 (5) ====================
(7, 5, 1, '2025-01-10'),   -- HD Reworked Project
(7, 5, 4, '2025-01-12'),   -- AutoLoot

-- ==================== Usuario 8 (LunaStarlight) — Cities: Skylines (60) ====================
(8, 60, 1, '2025-01-22'),  -- Traffic Manager
(8, 60, 2, '2025-01-25'),  -- Move It

-- ==================== Usuario 9 (KratosFan01) — Baldurs Gate 3 (10) ====================
(9, 10, 1, '2025-02-05'),  -- Improved UI
(9, 10, 2, '2025-02-08'),  -- Party Limit Begone

-- ==================== Usuario 10 (ZeldaLover) — Hollow Knight (15) ====================
(10, 15, 1, '2025-02-18'), -- Randomizer
(10, 15, 2, '2025-02-20'), -- Benchwarp

-- ==================== Suscripciones variadas (usuarios 11-40) ====================
(11, 1, 2, '2025-03-05'),   -- Usuario 11 → Redscript (Cyberpunk)
(12, 3, 2, '2025-03-15'),   -- Usuario 12 → Easy Mode (Elden Ring)
(13, 5, 2, '2025-03-25'),   -- Usuario 13 → Fast Travel (Witcher 3)
(14, 9, 2, '2025-04-05'),   -- Usuario 14 → JourneyMap (Minecraft)
(15, 27, 3, '2025-04-15'),  -- Usuario 15 → Alternate Start (Skyrim)
(16, 17, 3, '2025-04-25'),  -- Usuario 16 → Tractor Mod (Stardew)
(17, 71, 1, '2025-05-05'),  -- Usuario 17 → Bob's Mods (Factorio)
(18, 72, 1, '2025-05-15'),  -- Usuario 18 → Prepare Carefully (RimWorld)
(19, 60, 1, '2025-05-25'),  -- Usuario 19 → Traffic Manager (Cities)
(20, 16, 1, '2025-06-05'),  -- Usuario 20 → Calamity Mod (Terraria)
(21, 1, 4, '2025-06-15'),   -- Usuario 21 → Immersive First Person
(22, 3, 5, '2025-06-25'),   -- Usuario 22 → Item Randomizer
(23, 5, 3, '2025-07-05'),   -- Usuario 23 → Weight Limit
(24, 9, 4, '2025-07-15'),   -- Usuario 24 → Biomes O Plenty
(25, 27, 5, '2025-07-25'),  -- Usuario 25 → Frostfall
(26, 17, 4, '2025-08-05'),  -- Usuario 26 → Lookup Anything
(27, 10, 3, '2025-08-15'),  -- Usuario 27 → 5e Spells
(28, 15, 3, '2025-08-25'),  -- Usuario 28 → Debug Mod
(29, 71, 2, '2025-09-05'),  -- Usuario 29 → Angel's Mods
(30, 72, 2, '2025-09-15'),  -- Usuario 30 → Hospitality
(31, 1, 1, '2025-09-25'),   -- Usuario 31 → Cyber Engine Tweaks
(32, 3, 1, '2025-10-05'),   -- Usuario 32 → Seamless Co-op
(33, 5, 1, '2025-10-10'),   -- Usuario 33 → HD Reworked
(34, 9, 1, '2025-10-12'),   -- Usuario 34 → OptiFine
(35, 27, 1, '2025-10-14'),  -- Usuario 35 → SkyUI
(36, 16, 2, '2025-10-15'),  -- Usuario 36 → Thorium Mod
(37, 60, 3, '2025-10-15'),  -- Usuario 37 → 81 Tiles
(38, 17, 1, '2025-10-16'),  -- Usuario 38 → Stardew Expanded
(39, 10, 1, '2025-10-16'),  -- Usuario 39 → Improved UI
(40, 71, 3, '2026-01-10'),  -- Usuario 40 → Space Exploration

-- ==================== Más suscripciones (usuarios 41-60) ====================
(41, 1, 5, '2026-02-15'),   -- Usuario 41 → Night City ReShade
(42, 3, 3, '2026-03-20'),   -- Usuario 42 → Map for Goblins
(43, 5, 5, '2026-04-25'),   -- Usuario 43 → Friendly HUD
(44, 9, 5, '2026-05-30'),   -- Usuario 44 → Create
(45, 27, 2, '2026-06-05'),  -- Usuario 45 → Unofficial Patch
(46, 17, 2, '2026-07-10'),  -- Usuario 46 → Automate
(47, 15, 4, '2026-08-15'),  -- Usuario 47 → Custom Knight
(48, 16, 3, '2026-09-20'),  -- Usuario 48 → Recipe Browser
(49, 72, 3, '2026-10-01'),  -- Usuario 49 → EdB Prepare Carefully
(50, 60, 2, '2026-10-10'),  -- Usuario 50 → Move It

-- ==================== Relleno final para llegar a 60 suscripciones ====================
(51, 1, 2, '2026-10-11'),   -- Usuario 51 → Redscript
(52, 3, 2, '2026-10-11'),   -- Usuario 52 → Easy Mode
(53, 5, 2, '2026-10-12'),   -- Usuario 53 → Fast Travel
(54, 9, 2, '2026-10-12'),   -- Usuario 54 → JourneyMap
(55, 27, 3, '2026-10-13'),  -- Usuario 55 → Alternate Start
(56, 17, 3, '2026-10-13'),  -- Usuario 56 → Tractor Mod
(57, 10, 2, '2026-10-14'),  -- Usuario 57 → Party Limit Begone
(58, 15, 1, '2026-10-14'),  -- Usuario 58 → Randomizer
(59, 71, 1, '2026-10-15'),  -- Usuario 59 → Bob's Mods
(60, 72, 1, '2026-10-15'),  -- Usuario 60 → Prepare Carefully

(1, 301, 1, '2026-10-18'),
(2, 301, 1, '2026-10-18'),
(3, 301, 1, '2026-10-18'),
(4, 301, 1, '2026-10-18'),
(5, 301, 1, '2026-10-18'),
(6, 301, 1, '2026-10-18'),
(7, 301, 1, '2026-10-18');

/* --------------------------- RESENAS ------------------------------*/

INSERT INTO Resena (Texto_Resena, Calificacion_1_10, Fecha_Publicacion, Es_Critica_Especializada, ID_Usuario_FK, ID_Producto_FK)
SELECT TOP 800
    CASE ABS(CHECKSUM(NEWID())) % 10
        WHEN 0 THEN 'Una experiencia increíble, lo recomiendo totalmente.'
        WHEN 1 THEN 'Buen juego, aunque tiene algunos bugs menores.'
        WHEN 2 THEN 'No cumplió mis expectativas, esperaba más.'
        WHEN 3 THEN 'Obra maestra, de lo mejor que he jugado.'
        WHEN 4 THEN 'Entretenido pero olvidable, esperaba más contenido.'
        WHEN 5 THEN 'Los gráficos son espectaculares, la historia regular.'
        WHEN 6 THEN 'Adictivo, no puedo dejar de jugarlo.'
        WHEN 7 THEN 'Demasiado corto para el precio que tiene.'
        WHEN 8 THEN 'Perfecto para jugar con amigos, muy divertido.'
        WHEN 9 THEN 'Tiene potencial pero le faltan pulir muchas cosas.'
    END,
    ABS(CHECKSUM(NEWID())) % 10 + 1, 
    DATEADD(day, - (ABS(CHECKSUM(NEWID())) % 600), '2026-10-16'), 
    CASE WHEN ABS(CHECKSUM(NEWID())) % 10 = 0 THEN 1 ELSE 0 END, 
    u.Id_Usuario,
    p.ID_Producto
FROM 
    (SELECT TOP 80 Id_Usuario FROM Usuario ORDER BY NEWID()) u
CROSS JOIN 
    (SELECT TOP 10 ID_Producto FROM Producto_Digital ORDER BY NEWID()) p;

INSERT INTO Resena (Texto_Resena, Calificacion_1_10, Fecha_Publicacion, Es_Critica_Especializada, ID_Usuario_FK, ID_Producto_FK) 
VALUES ('No me gustó nada, muy aburrido.', 2, '2026-10-11', 0, 3, 309);


INSERT INTO Resena (Texto_Resena, Calificacion_1_10, Fecha_Publicacion, Es_Critica_Especializada, ID_Usuario_FK, ID_Producto_FK) 
VALUES 
-- Reseñas del Usuario 1 (5 reseñas)
('Me encanta construir casas.', 9, '2026-10-01', 0, 1, 301),
('Muy buen juego.', 10, '2026-10-02', 0, 1, 301),
('Mis Sims viven mejor que yo.', 9, '2026-10-03', 0, 1, 301),
('El mejor simulador.', 10, '2026-10-04', 0, 1, 301),
('Adictivo.', 8, '2026-10-05', 0, 1, 301),

-- Reseñas del Usuario 2 (4 reseñas)
('Buenísimo.', 9, '2026-10-06', 0, 2, 301),
('Me gusta el nuevo DLC.', 10, '2026-10-07', 0, 2, 301),
('Muy completo.', 9, '2026-10-08', 0, 2, 301),
('Entretenido.', 8, '2026-10-09', 0, 2, 301),

-- Reseñas del Usuario 3 (4 reseñas)
('Horas y horas de diversión.', 9, '2026-10-10', 0, 3, 301),
('El motor gráfico está bien.', 8, '2026-10-11', 0, 3, 301),
('Buenos gráficos.', 9, '2026-10-12', 0, 3, 301),
('Muy buen juego base.', 10, '2026-10-13', 0, 3, 301),

-- Reseñas del Usuario 4 (4 reseñas)
('No me aburre nunca.', 9, '2026-10-14', 0, 4, 301),
('Buen simulador.', 8, '2026-10-15', 0, 4, 301),
('Recomendado.', 9, '2026-10-16', 0, 4, 301),
('Buena experiencia.', 9, '2026-10-17', 0, 4, 301),

-- Reseñas del Usuario 5 (4 reseñas)
('Un clásico.', 10, '2026-10-18', 0, 5, 301),
('Mejor que antes.', 9, '2026-10-19', 0, 5, 301),
('Muy divertido.', 8, '2026-10-20', 0, 5, 301),
('Buen juego.', 9, '2026-10-21', 0, 5, 301);


/* --------------------------- LOGROS_DESBLOQUEADOS ------------------------------*/

INSERT INTO Desbloqueo_Logro (ID_Usuario_FK, ID_Juego_Base_FK, ID_Logro_FK, Fecha_Desbloqueo) VALUES
(1, 1, 1, '2024-10-20'), (1, 1, 2, '2024-10-25'), (1, 1, 3, '2024-11-01'), (1, 1, 4, '2024-11-10'), (1, 1, 5, '2024-11-20');

INSERT INTO Desbloqueo_Logro (ID_Usuario_FK, ID_Juego_Base_FK, ID_Logro_FK, Fecha_Desbloqueo) VALUES
(2, 3, 1, '2024-10-28'), (2, 3, 2, '2024-11-05'), (2, 3, 3, '2024-11-15'), (2, 3, 4, '2024-11-25'), (2, 3, 5, '2024-12-05');

INSERT INTO Desbloqueo_Logro (ID_Usuario_FK, ID_Juego_Base_FK, ID_Logro_FK, Fecha_Desbloqueo) VALUES
(3, 5, 1, '2024-11-15'), (3, 5, 2, '2024-11-20'), (3, 5, 3, '2024-11-28'), (3, 5, 4, '2024-12-08'), (3, 5, 5, '2024-12-18');

INSERT INTO Desbloqueo_Logro (ID_Usuario_FK, ID_Juego_Base_FK, ID_Logro_FK, Fecha_Desbloqueo) VALUES
(4, 9, 1, '2024-11-20'), (4, 9, 2, '2024-11-25'), (4, 9, 3, '2024-12-01'), (4, 9, 4, '2024-12-10'), (4, 9, 5, '2024-12-20');

INSERT INTO Desbloqueo_Logro (ID_Usuario_FK, ID_Juego_Base_FK, ID_Logro_FK, Fecha_Desbloqueo) 
VALUES 
(1, 309, 1, '2026-10-01'), (1, 309, 2, '2026-10-02'), (1, 309, 3, '2026-10-03');

INSERT INTO Desbloqueo_Logro (ID_Usuario_FK, ID_Juego_Base_FK, ID_Logro_FK, Fecha_Desbloqueo) VALUES
(5, 1, 1, '2024-12-20'), (5, 1, 2, '2024-12-28'),
(6, 3, 1, '2025-01-15'), (6, 3, 2, '2025-01-25'), (6, 3, 3, '2025-02-05'),
(7, 5, 1, '2025-02-01'), 
(8, 9, 1, '2025-02-10'), (8, 9, 2, '2025-02-20'),
(9, 27, 1, '2025-02-25'), (9, 27, 2, '2025-03-05'), (9, 27, 3, '2025-03-15'),
(10, 1, 1, '2025-03-20'),
(11, 3, 1, '2025-04-01'),
(12, 5, 1, '2025-04-10'),
(13, 9, 1, '2025-04-20'),
(14, 27, 1, '2025-05-01'),
(15, 1, 1, '2025-05-10'), (15, 1, 2, '2025-05-20');