SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS category;
DROP TABLE IF EXISTS category_item;
DROP TABLE IF EXISTS category_item_alternative_spelling;
DROP TABLE IF EXISTS user;
DROP TABLE IF EXISTS account;
DROP TABLE IF EXISTS game;
DROP TABLE IF EXISTS participant;
DROP TABLE IF EXISTS guess;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE category (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL
);

CREATE TABLE category_item (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255),
  category_id INT,

  FOREIGN KEY fk_category_id (category_id) REFERENCES category(id)
);

CREATE TABLE category_item_alternative_spelling (
  id INT PRIMARY KEY AUTO_INCREMENT,
  category_id INT NOT NULL,
  category_item_id INT NOT NULL,
  spelling VARCHAR(255),

  FOREIGN KEY fk_category_id (category_id) REFERENCES category(id),
  FOREIGN KEY fk_category_item_id (category_item_id) REFERENCES category_item(id),
  UNIQUE KEY uniq__category_id__spelling (category_id, spelling)
);

CREATE TABLE user (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL DEFAULT 'Anonymous',
  created_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE account (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  email_address VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  created_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY fk_user_id (user_id) REFERENCES user(id)
);

CREATE TABLE game (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255),
  category_id INT NOT NULL,
  time_start DATETIME,
  time_end DATETIME,
  updated_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY fk_category_id (category_id) REFERENCES category(id)
);

CREATE TABLE participant (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  game_id INT NOT NULL,
  admin INT NOT NULL,
  status INT NOT NULL DEFAULT 0,
  created_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  UNIQUE KEY uniq__user_id__game_id (user_id, game_id),
  FOREIGN KEY fk_user_id (user_id) REFERENCES user(id),
  FOREIGN KEY fk_game_id (game_id) REFERENCES game(id)
);

CREATE TABLE guess (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  game_id INT NOT NULL,
  guess_raw VARCHAR(255) NOT NULL,
  category_item_id INT,
  created_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  UNIQUE KEY uniq__game_id__category_item_id (game_id, category_item_id),
  FOREIGN KEY fk_user_id (user_id) REFERENCES user(id),
  FOREIGN KEY fk_game_id (game_id) REFERENCES game(id),
  FOREIGN KEY fk_category_item_id (category_item_id) REFERENCES category_item(id)
);

#################
# Add Categories
#################
INSERT INTO category SET
  id=1,
  name='Letters in the Swedish Alphabet';

INSERT INTO category_item (id, name, category_id) VALUES
  (1, 'A', 1),
  (2, 'B', 1),
  (3, 'C', 1),
  (4, 'D', 1),
  (5, 'E', 1),
  (6, 'F', 1),
  (7, 'G', 1),
  (8, 'H', 1),
  (9, 'I', 1),
  (10, 'J', 1),
  (11, 'K', 1),
  (12, 'L', 1),
  (13, 'M', 1),
  (14, 'N', 1),
  (15, 'O', 1),
  (16, 'P', 1),
  (17, 'Q', 1),
  (18, 'R', 1),
  (19, 'S', 1),
  (20, 'T', 1),
  (21, 'U', 1),
  (22, 'V', 1),
  (23, 'W', 1),
  (24, 'X', 1),
  (25, 'Y', 1),
  (26, 'Z', 1),
  (27, 'Å', 1),
  (28, 'Ä', 1),
  (29, 'Ö', 1);


INSERT INTO category SET
  id=2,
  name='Presidents of France';

INSERT INTO category_item (id, name, category_id) VALUES
  (30, 'Louis-Napoléon Bonaparte', 2),
  (31, 'Adolphe Thiers', 2),
  (32, 'Patrice de MacMahon', 2),
  (33, 'Jules Grévy', 2),
  (34, 'Marie François Sadi Carnot', 2),
  (35, 'Jean Casimir-Perier', 2),
  (36, 'Félix Faure', 2),
  (37, 'Émile Loubet', 2),
  (38, 'Armand Fallières', 2),
  (39, 'Raymond Poincaré', 2),
  (40, 'Paul Deschanel', 2),
  (41, 'Alexandre Millerand', 2),
  (42, 'Gaston Doumergue', 2),
  (43, 'Paul Doumer', 2),
  (44, 'Albert Lebrun', 2),
  (45, 'Vincent Auriol', 2),
  (46, 'René Coty', 2),
  (47, 'Charles de Gaulle', 2),
  (48, 'Georges Pompidou', 2),
  (49, 'Valéry Giscard d\'Estaing', 2),
  (50, 'François Mitterrand', 2),
  (51, 'Jacques Chirac', 2),
  (52, 'Nicolas Sarkozy', 2),
  (53, 'François Hollande', 2),
  (54, 'Emmanuel Macron', 2);

INSERT INTO category_item_alternative_spelling (category_id, category_item_id, spelling) VALUES
  (2, 30, 'napoleon'),
  (2, 30, 'bonaparte'),
  (2, 30, 'napoleon bonaparte'),
  (2, 31, 'thiers'),
  (2, 32, 'patrice macmahon'),
  (2, 32, 'de macmahon'),
  (2, 32, 'macmahon'),
  (2, 33, 'grevy'),
  (2, 34, 'carnot'),
  (2, 34, 'sadi carnot'),
  (2, 34, 'francois carnot'),
  (2, 35, 'casimir'),
  (2, 35, 'perier'),
  (2, 35, 'carimir-perier'),
  (2, 35, 'jean casimir'),
  (2, 35, 'jean perier'),
  (2, 36, 'faure'),
  (2, 37, 'loubet'),
  (2, 37, 'laubet'),
  (2, 38, 'fallieres'),
  (2, 39, 'poincare'),
  (2, 40, 'deschanel'),
  (2, 41, 'millerand'),
  (2, 42, 'doumergue'),
  (2, 43, 'doumer'),
  (2, 44, 'lebrun'),
  (2, 45, 'auriol'),
  (2, 46, 'coty'),
  (2, 47, 'de gaulle'),
  (2, 47, 'gaulle'),
  (2, 48, 'pompidou'),
  (2, 49, 'giscard'),
  (2, 49, 'd\'estaing'),
  (2, 49, 'estaing'),
  (2, 49, 'giscard d\'estaing'),
  (2, 49, 'valery giscard'),
  (2, 49, 'valery d\'estaing'),
  (2, 49, 'valery estaing'),
  (2, 49, 'valery giscard estaing'),
  (2, 50, 'mitterrand'),
  (2, 51, 'chirac'),
  (2, 51, 'chirak'),
  (2, 52, 'sarkozy'),
  (2, 52, 'sarcozy'),
  (2, 52, 'sarkosy'),
  (2, 53, 'hollande'),
  (2, 53, 'holland'),
  (2, 54, 'macron'),
  (2, 54, 'makron');


INSERT INTO category SET
  id=3,
  name='Subway Stations on the Green Line';

INSERT INTO category_item (id, category_id, name) VALUES
  (55, 3, 'Hässelby strand'),
  (56, 3, 'Hässelby gård'),
  (57, 3, 'Johannelund'),
  (58, 3, 'Vällingby'),
  (59, 3, 'Råcksta'),
  (60, 3, 'Blackeberg'),
  (61, 3, 'Islandstorget'),
  (62, 3, 'Ängbyplan'),
  (63, 3, 'Åkeshov'),
  (64, 3, 'Brommaplan'),
  (65, 3, 'Abrahamsberg'),
  (66, 3, 'Stora mossen'),
  (67, 3, 'Alvik'),
  (68, 3, 'Kristineberg'),
  (69, 3, 'Thorildsplan'),
  (70, 3, 'Fridhemsplan'),
  (71, 3, 'S:t Eriksplan'),
  (72, 3, 'Odenplan'),
  (73, 3, 'Rådmansgatan'),
  (74, 3, 'Hötorget'),
  (75, 3, 'T-Centralen'),
  (76, 3, 'Gamla stan'),
  (77, 3, 'Slussen'),
  (78, 3, 'Medborgarplatsen'),
  (79, 3, 'Skanstull'),
  (80, 3, 'Gullmarsplan'),
  (81, 3, 'Globen'),
  (82, 3, 'Enskede gård'),
  (83, 3, 'Sockenplan'),
  (84, 3, 'Svedmyra'),
  (85, 3, 'Stureby'),
  (86, 3, 'Bandhagen'),
  (87, 3, 'Högdalen'),
  (88, 3, 'Rågsved'),
  (89, 3, 'Hagsätra'),
  (90, 3, 'Skärmarbrink'),
  (91, 3, 'Blåsut'),
  (92, 3, 'Sandsborg'),
  (93, 3, 'Skogskyrkogården'),
  (94, 3, 'Tallkrogen'),
  (95, 3, 'Gubbängen'),
  (96, 3, 'Hökarängen'),
  (97, 3, 'Farsta'),
  (98, 3, 'Farsta strand'),
  (99, 3, 'Hammarbyhöjden'),
  (100, 3, 'Björkhagen'),
  (101, 3, 'Kärrtorp'),
  (102, 3, 'Bagarmossen'),
  (103, 3, 'Skarpnäck');

INSERT INTO category_item_alternative_spelling (category_item_id, category_id, spelling) VALUES
  (55, 3, 'hässelbystrand'),
  (56, 3, 'hässelbygård'),
  (66, 3, 'storamossen'),
  (69, 3, 'thorildsplan'),
  (69, 3, 'torildsplan'),
  (71, 3, 'st eriksplan'),
  (71, 3, 'sankt eriksplan'),
  (71, 3, 'steriksplan'),
  (75, 3, 'tcentralen'),
  (75, 3, 't centralen'),
  (76, 3, 'gamlastan'),
  (77, 3, 'slussen'),
  (82, 3, 'enskedegård'),
  (98, 3, 'farstastrand');


INSERT INTO category SET
  id=4,
  name='Countries in Africa';

INSERT INTO category_item (id, category_id, name) VALUES
  (104, 4, 'Algeria'),
  (105, 4, 'Angola'),
  (106, 4, 'Benin'),
  (107, 4, 'Botswana'),
  (108, 4, 'Burkina Faso'),
  (109, 4, 'Burundi'),
  (110, 4, 'Cabo Verde'),
  (111, 4, 'Cameroon'),
  (112, 4, 'Central African Republic'),
  (113, 4, 'Chad'),
  (114, 4, 'Comoros'),
  (115, 4, 'Democratic Republic of the Congo'),
  (116, 4, 'Cote d\'Ivoire'),
  (117, 4, 'Djibouti'),
  (118, 4, 'Egypt'),
  (119, 4, 'Equatorial Guinea'),
  (120, 4, 'Eritrea'),
  (121, 4, 'Ethiopia'),
  (122, 4, 'Gabon'),
  (123, 4, 'Gambia'),
  (124, 4, 'Ghana'),
  (125, 4, 'Republic of Guinea'),
  (126, 4, 'Guinea-Bissau'),
  (127, 4, 'Kenya'),
  (128, 4, 'Lesotho'),
  (129, 4, 'Liberia'),
  (130, 4, 'Libya'),
  (131, 4, 'Madagascar'),
  (132, 4, 'Malawi'),
  (133, 4, 'Mali'),
  (134, 4, 'Mauritania'),
  (135, 4, 'Mauritius'),
  (136, 4, 'Morocco'),
  (137, 4, 'Mozambique'),
  (138, 4, 'Namibia'),
  (139, 4, 'Niger'),
  (140, 4, 'Nigeria'),
  (141, 4, 'Rwanda'),
  (142, 4, 'Democratic Republic of São Tomé and Príncipe'),
  (143, 4, 'Senegal'),
  (144, 4, 'Seychelles'),
  (145, 4, 'Sierra Leone'),
  (146, 4, 'Somalia'),
  (147, 4, 'South Africa'),
  (148, 4, 'South Sudan'),
  (149, 4, 'Sudan'),
  (150, 4, 'Swaziland'),
  (151, 4, 'Tanzania'),
  (152, 4, 'Togo'),
  (153, 4, 'Tunisia'),
  (154, 4, 'Uganda'),
  (155, 4, 'Zambia'),
  (156, 4, 'Zimbabwe');

INSERT INTO category_item_alternative_spelling (category_item_id, category_id, spelling) VALUES
  (108, 4, 'burkinafaso'),
  (110, 4, 'caboverde'),
  (112, 4, 'central africa'),
  (115, 4, 'democratic republic of congo'),
  (115, 4, 'republic of congo'),
  (115, 4, 'congo'),
  (116, 4, 'cote divoire'),
  (116, 4, 'cote ivoire'),
  (116, 4, 'ivory coast'),
  (125, 4, 'guinea'),
  (126, 4, 'guinea bissau'),
  (126, 4, 'bissau'),
  (142, 4, 'sao tome and principe'),
  (142, 4, 'sao tome principe'),
  (142, 4, 'sao tome'),
  (142, 4, 'saotome'),
  (142, 4, 'santome'),
  (142, 4, 'principe'),
  (142, 4, 'principe and sao tome'),
  (142, 4, 'democratic republic of principe and sao tome'),
  (145, 4, 'sierraleone');


INSERT INTO category SET
  id=5,
  name='Countries in Europe';

INSERT INTO category_item (id, category_id, name) VALUES
  (157, 5, 'Albania'),
  (158, 5, 'Andorra'),
  (159, 5, 'Armenia'),
  (160, 5, 'Austria'),
  (161, 5, 'Azerbaijan'),
  (162, 5, 'Belarus'),
  (163, 5, 'Belgium'),
  (164, 5, 'Bosnia and Herzegovina'),
  (165, 5, 'Bulgaria'),
  (166, 5, 'Croatia'),
  (167, 5, 'Cyprus'),
  (168, 5, 'Czech Republic'),
  (169, 5, 'Denmark'),
  (170, 5, 'Estonia'),
  (171, 5, 'Finland'),
  (172, 5, 'France'),
  (173, 5, 'Georgia'),
  (174, 5, 'Germany'),
  (175, 5, 'Greece'),
  (176, 5, 'Hungary'),
  (177, 5, 'Iceland'),
  (178, 5, 'Ireland'),
  (179, 5, 'Italy'),
  (180, 5, 'Kazakhstan'),
  (181, 5, 'Kosovo'),
  (182, 5, 'Latvia'),
  (183, 5, 'Liechtenstein'),
  (184, 5, 'Lithuania'),
  (185, 5, 'Luxembourg'),
  (186, 5, 'Macedonia'),
  (187, 5, 'Malta'),
  (188, 5, 'Moldova'),
  (189, 5, 'Monaco'),
  (190, 5, 'Montenegro'),
  (191, 5, 'Netherlands'),
  (192, 5, 'Norway'),
  (193, 5, 'Poland'),
  (194, 5, 'Portugal'),
  (195, 5, 'Romania'),
  (196, 5, 'Russia'),
  (197, 5, 'San Marino'),
  (198, 5, 'Serbia'),
  (199, 5, 'Slovakia'),
  (200, 5, 'Slovenia'),
  (201, 5, 'Spain'),
  (202, 5, 'Sweden'),
  (203, 5, 'Switzerland'),
  (204, 5, 'Turkey'),
  (205, 5, 'Ukraine'),
  (206, 5, 'United Kingdom'),
  (207, 5, 'Vatican City (Holy See)');

INSERT INTO category_item_alternative_spelling (category_item_id, category_id, spelling) VALUES
  (164, 5, 'bosnia'),
  (164, 5, 'bosnia herzegovina'),
  (164, 5, 'herzegovina'),
  (164, 5, 'herzegovina and bosnia'),
  (168, 5, 'republic of czech'),
  (168, 5, 'czech'),
  (197, 5, 'sanmarino'),
  (206, 5, 'united kingdom'),
  (206, 5, 'uk'),
  (206, 5, 'england'),
  (206, 5, 'scotland'),
  (206, 5, 'wales'),
  (206, 5, 'north ireland'),
  (207, 5, 'holy vatican see'),
  (207, 5, 'holy vatican city'),
  (207, 5, 'vatican'),
  (207, 5, 'vatican city'),
  (207, 5, 'holy see');


INSERT INTO category SET
  id=6,
  name='Capitals of Europe';

INSERT INTO category_item (id, category_id, name) VALUES
  (208, 6, 'Tirana'),
  (209, 6, 'Andorra la Vella'),
  (210, 6, 'Yerevan'),
  (211, 6, 'Vienna'),
  (212, 6, 'Baku'),
  (213, 6, 'Minsk'),
  (214, 6, 'Brussels'),
  (215, 6, 'Sarajevo'),
  (216, 6, 'Sofia'),
  (217, 6, 'Zagreb'),
  (218, 6, 'Nicosia'),
  (219, 6, 'Prague'),
  (220, 6, 'Copenhagen'),
  (221, 6, 'Tallinn'),
  (222, 6, 'Helsinki'),
  (223, 6, 'Paris'),
  (224, 6, 'Tbilisi'),
  (225, 6, 'Berlin'),
  (226, 6, 'Athens'),
  (227, 6, 'Budapest'),
  (228, 6, 'Reykjavik'),
  (229, 6, 'Dublin'),
  (230, 6, 'Rome'),
  (231, 6, 'Astana'),
  (232, 6, 'Pristina'),
  (233, 6, 'Riga'),
  (234, 6, 'Vaduz'),
  (235, 6, 'Vilnius'),
  (236, 6, 'Luxembourg'),
  (237, 6, 'Skopje'),
  (238, 6, 'Valletta'),
  (239, 6, 'Chisinau'),
  (240, 6, 'Monaco'),
  (241, 6, 'Podgorica'),
  (242, 6, 'Amsterdam'),
  (243, 6, 'Oslo'),
  (244, 6, 'Warsaw'),
  (245, 6, 'Lisbon'),
  (246, 6, 'Bucharest'),
  (247, 6, 'Moscow'),
  (248, 6, 'San Marino'),
  (249, 6, 'Belgrade'),
  (250, 6, 'Bratislava'),
  (251, 6, 'Ljubljana'),
  (252, 6, 'Madrid'),
  (253, 6, 'Stockholm'),
  (254, 6, 'Bern'),
  (255, 6, 'Ankara'),
  (256, 6, 'Kyiv'),
  (257, 6, 'London'),
  (258, 6, 'Vatican City');

INSERT INTO category_item_alternative_spelling (category_item_id, category_id, spelling) VALUES
  (209, 6, 'andorra vella'),
  (209, 6, 'lavella'),
  (209, 6, 'la vella'),
  (209, 6, 'andorra'),
  (243, 6, 'olso'),
  (248, 6, 'sanmarino'),
  (256, 6, 'kyiv'),
  (256, 6, 'kiev'),
  (258, 6, 'vatican');

#################
# Add Users
#################
INSERT INTO user SET
  id=1,
  name='Simon Olander';

INSERT INTO account SET
  id=1,
  user_id=1,
  email_address='simon.olander@r2m.se',
  password='password';
