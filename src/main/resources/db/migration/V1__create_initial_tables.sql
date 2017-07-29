SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS category;
DROP TABLE IF EXISTS category_item;
DROP TABLE IF EXISTS category_item_alternative_spelling;
DROP TABLE IF EXISTS user;
DROP TABLE IF EXISTS account;
DROP TABLE IF EXISTS google_account;
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
  name VARCHAR(255) NOT NULL,
  category_id INT,
  extra_information VARCHAR(255),
  image_url VARCHAR(255),

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
  profile_picture VARCHAR(255),
  created_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE account (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  email_address VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  created_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY fk_user_id (user_id) REFERENCES user(id)
);

CREATE TABLE google_account (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  external_id VARCHAR(255) NOT NULL UNIQUE,
  created_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

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
  (2, 52, 'sarkozy'),
  (2, 53, 'hollande'),
  (2, 54, 'macron');


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
  (71, 3, 'eriksplan'),
  (71, 3, 'st eriksplan'),
  (71, 3, 'sankt eriksplan'),
  (71, 3, 'steriksplan'),
  (75, 3, 'tcentralen'),
  (75, 3, 'centralen'),
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
  (221, 6, 'tallin'),
  (248, 6, 'sanmarino'),
  (256, 6, 'kiev'),
  (258, 6, 'vatican');


INSERT INTO category SET
  id = 7,
  name = 'Nobel Prize Winners in Physics';

INSERT INTO category_item (id, category_id, name, extra_information) VALUES
  (259, 7, 'David J. Thouless', 'Year 2016'),
  (260, 7, 'F. Duncan M. Haldane', 'Year 2016'),
  (261, 7, 'J. Michael Kosterlitz', 'Year 2016'),
  (262, 7, 'Takaaki Kajita', 'Year 2015'),
  (263, 7, 'Arthur B. McDonald', 'Year 2015'),
  (264, 7, 'Isamu Akasaki', 'Year 2014'),
  (265, 7, 'Hiroshi Amano', 'Year 2014'),
  (266, 7, 'Shuji Nakamura', 'Year 2014'),
  (267, 7, 'François Englert', 'Year 2013'),
  (268, 7, 'Peter W. Higgs', 'Year 2013'),
  (269, 7, 'Serge Haroche', 'Year 2012'),
  (270, 7, 'David J. Wineland', 'Year 2012'),
  (271, 7, 'Saul Perlmutter', 'Year 2011'),
  (272, 7, 'Brian P. Schmidt', 'Year 2011'),
  (273, 7, 'Adam G. Riess', 'Year 2011'),
  (274, 7, 'Andre Geim', 'Year 2010'),
  (275, 7, 'Konstantin Novoselov', 'Year 2010'),
  (276, 7, 'Charles Kuen Kao', 'Year 2009'),
  (277, 7, 'Willard S. Boyle', 'Year 2009'),
  (278, 7, 'George E. Smith', 'Year 2009'),
  (279, 7, 'Yoichiro Nambu', 'Year 2008'),
  (280, 7, 'Makoto Kobayashi', 'Year 2008'),
  (281, 7, 'Toshihide Maskawa', 'Year 2008'),
  (282, 7, 'Albert Fert', 'Year 2007'),
  (283, 7, 'Peter Grünberg', 'Year 2007'),
  (284, 7, 'John C. Mather', 'Year 2006'),
  (285, 7, 'George F. Smoot', 'Year 2006'),
  (286, 7, 'Roy J. Glauber', 'Year 2005'),
  (287, 7, 'John L. Hall', 'Year 2005'),
  (288, 7, 'Theodor W. Hänsch', 'Year 2005'),
  (289, 7, 'David J. Gross', 'Year 2004'),
  (290, 7, 'H. David Politzer', 'Year 2004'),
  (291, 7, 'Frank Wilczek', 'Year 2004'),
  (292, 7, 'Alexei A. Abrikosov', 'Year 2003'),
  (293, 7, 'Vitaly L. Ginzburg', 'Year 2003'),
  (294, 7, 'Anthony J. Leggett', 'Year 2003'),
  (295, 7, 'Raymond Davis Jr.', 'Year 2002'),
  (296, 7, 'Masatoshi Koshiba', 'Year 2002'),
  (297, 7, 'Riccardo Giacconi', 'Year 2002'),
  (298, 7, 'Eric A. Cornell', 'Year 2001'),
  (299, 7, 'Wolfgang Ketterle', 'Year 2001'),
  (300, 7, 'Carl E. Wieman', 'Year 2001'),
  (301, 7, 'Zhores I. Alferov', 'Year 2000'),
  (302, 7, 'Herbert Kroemer', 'Year 2000'),
  (303, 7, 'Jack S. Kilby', 'Year 2000'),
  (304, 7, 'Gerardus ''t Hooft', 'Year 1999'),
  (305, 7, 'Martinus J.G. Veltman', 'Year 1999'),
  (306, 7, 'Robert B. Laughlin', 'Year 1998'),
  (307, 7, 'Horst L. Störmer', 'Year 1998'),
  (308, 7, 'Daniel C. Tsui', 'Year 1998'),
  (309, 7, 'Steven Chu', 'Year 1997'),
  (310, 7, 'Claude Cohen-Tannoudji', 'Year 1997'),
  (311, 7, 'William D. Phillips', 'Year 1997'),
  (312, 7, 'David M. Lee', 'Year 1996'),
  (313, 7, 'Douglas D. Osheroff', 'Year 1996'),
  (314, 7, 'Robert C. Richardson', 'Year 1996'),
  (315, 7, 'Martin L. Perl', 'Year 1995'),
  (316, 7, 'Frederick Reines', 'Year 1995'),
  (317, 7, 'Bertram N. Brockhouse', 'Year 1994'),
  (318, 7, 'Clifford G. Shull', 'Year 1994'),
  (319, 7, 'Russell A. Hulse', 'Year 1993'),
  (320, 7, 'Joseph H. Taylor Jr.', 'Year 1993'),
  (321, 7, 'Georges Charpak', 'Year 1992'),
  (322, 7, 'Pierre-Gilles de Gennes', 'Year 1991'),
  (323, 7, 'Jerome I. Friedman', 'Year 1990'),
  (324, 7, 'Henry W. Kendall', 'Year 1990'),
  (325, 7, 'Richard E. Taylor', 'Year 1990'),
  (326, 7, 'Norman F. Ramsey', 'Year 1989'),
  (327, 7, 'Hans G. Dehmelt', 'Year 1989'),
  (328, 7, 'Wolfgang Paul', 'Year 1989'),
  (329, 7, 'Leon M. Lederman', 'Year 1988'),
  (330, 7, 'Melvin Schwartz', 'Year 1988'),
  (331, 7, 'Jack Steinberger', 'Year 1988'),
  (332, 7, 'J. Georg Bednorz', 'Year 1987'),
  (333, 7, 'K. Alexander Müller', 'Year 1987'),
  (334, 7, 'Ernst Ruska', 'Year 1986'),
  (335, 7, 'Gerd Binnig', 'Year 1986'),
  (336, 7, 'Heinrich Rohrer', 'Year 1986'),
  (337, 7, 'Klaus von Klitzing', 'Year 1985'),
  (338, 7, 'Carlo Rubbia', 'Year 1984'),
  (339, 7, 'Simon van der Meer', 'Year 1984'),
  (340, 7, 'Subramanyan Chandrasekhar', 'Year 1983'),
  (341, 7, 'William Alfred Fowler', 'Year 1983'),
  (342, 7, 'Kenneth G. Wilson', 'Year 1982'),
  (343, 7, 'Nicolaas Bloembergen', 'Year 1981'),
  (344, 7, 'Arthur Leonard Schawlow', 'Year 1981'),
  (345, 7, 'Kai M. Siegbahn', 'Year 1981'),
  (346, 7, 'James Watson Cronin', 'Year 1980'),
  (347, 7, 'Val Logsdon Fitch', 'Year 1980'),
  (348, 7, 'Sheldon Lee Glashow', 'Year 1979'),
  (349, 7, 'Abdus Salam', 'Year 1979'),
  (350, 7, 'Steven Weinberg', 'Year 1979'),
  (351, 7, 'Pyotr Leonidovich Kapitsa', 'Year 1978'),
  (352, 7, 'Arno Allan Penzias', 'Year 1978'),
  (353, 7, 'Robert Woodrow Wilson', 'Year 1978'),
  (354, 7, 'Philip Warren Anderson', 'Year 1977'),
  (355, 7, 'Sir Nevill Francis Mott', 'Year 1977'),
  (356, 7, 'John Hasbrouck van Vleck', 'Year 1977'),
  (357, 7, 'Burton Richter', 'Year 1976'),
  (358, 7, 'Samuel Chao Chung Ting', 'Year 1976'),
  (359, 7, 'Aage Niels Bohr', 'Year 1975'),
  (360, 7, 'Ben Roy Mottelson', 'Year 1975'),
  (361, 7, 'Leo James Rainwater', 'Year 1975'),
  (362, 7, 'Sir Martin Ryle', 'Year 1974'),
  (363, 7, 'Antony Hewish', 'Year 1974'),
  (364, 7, 'Leo Esaki', 'Year 1973'),
  (365, 7, 'Ivar Giaever', 'Year 1973'),
  (366, 7, 'Brian David Josephson', 'Year 1973'),
  (368, 7, 'Leon Neil Cooper', 'Year 1972'),
  (369, 7, 'John Robert Schrieffer', 'Year 1972'),
  (370, 7, 'Dennis Gabor', 'Year 1971'),
  (371, 7, 'Hannes Olof Gösta Alfvén', 'Year 1970'),
  (372, 7, 'Louis Eugène Félix Néel', 'Year 1970'),
  (373, 7, 'Murray Gell-Mann', 'Year 1969'),
  (374, 7, 'Luis Walter Alvarez', 'Year 1968'),
  (375, 7, 'Hans Albrecht Bethe', 'Year 1967'),
  (376, 7, 'Alfred Kastler', 'Year 1966'),
  (377, 7, 'Sin-Itiro Tomonaga', 'Year 1965'),
  (378, 7, 'Julian Schwinger', 'Year 1965'),
  (379, 7, 'Richard P. Feynman', 'Year 1965'),
  (380, 7, 'Charles Hard Townes', 'Year 1964'),
  (381, 7, 'Nicolay Gennadiyevich Basov', 'Year 1964'),
  (382, 7, 'Aleksandr Mikhailovich Prokhorov', 'Year 1964'),
  (383, 7, 'Eugene Paul Wigner', 'Year 1963'),
  (384, 7, 'Maria Goeppert Mayer', 'Year 1963'),
  (385, 7, 'J. Hans D. Jensen', 'Year 1963'),
  (386, 7, 'Lev Davidovich Landau', 'Year 1962'),
  (387, 7, 'Robert Hofstadter', 'Year 1961'),
  (388, 7, 'Rudolf Ludwig Mössbauer', 'Year 1961'),
  (389, 7, 'Donald Arthur Glaser', 'Year 1960'),
  (390, 7, 'Emilio Gino Segrè', 'Year 1959'),
  (391, 7, 'Owen Chamberlain', 'Year 1959'),
  (392, 7, 'Pavel Alekseyevich Cherenkov', 'Year 1958'),
  (393, 7, 'Il´ja Mikhailovich Frank', 'Year 1958'),
  (394, 7, 'Igor Yevgenyevich Tamm', 'Year 1958'),
  (395, 7, 'Chen Ning Yang', 'Year 1957'),
  (396, 7, 'Tsung-Dao (T.D.) Lee', 'Year 1957'),
  (397, 7, 'William Bradford Shockley', 'Year 1956'),
  (398, 7, 'John Bardeen', 'Year 1956 and 1972, both named John Bardeen'),
  (399, 7, 'Walter Houser Brattain', 'Year 1956'),
  (400, 7, 'Willis Eugene Lamb', 'Year 1955'),
  (401, 7, 'Polykarp Kusch', 'Year 1955'),
  (402, 7, 'Max Born', 'Year 1954'),
  (403, 7, 'Walther Bothe', 'Year 1954'),
  (404, 7, 'Frits Zernike', 'Year 1953'),
  (405, 7, 'Felix Bloch', 'Year 1952'),
  (406, 7, 'Edward Mills Purcell', 'Year 1952'),
  (407, 7, 'Sir John Douglas Cockcroft', 'Year 1951'),
  (408, 7, 'Ernest Thomas Sinton Walton', 'Year 1951'),
  (409, 7, 'Cecil Frank Powell', 'Year 1950'),
  (410, 7, 'Hideki Yukawa', 'Year 1949'),
  (411, 7, 'Patrick Maynard Stuart Blackett', 'Year 1948'),
  (412, 7, 'Sir Edward Victor Appleton', 'Year 1947'),
  (413, 7, 'Percy Williams Bridgman', 'Year 1946'),
  (414, 7, 'Wolfgang Pauli', 'Year 1945'),
  (415, 7, 'Isidor Isaac Rabi', 'Year 1944'),
  (416, 7, 'Otto Stern', 'Year 1943'),
  (417, 7, 'Ernest Orlando Lawrence', 'Year 1939'),
  (418, 7, 'Enrico Fermi', 'Year 1938'),
  (419, 7, 'Clinton Joseph Davisson', 'Year 1937'),
  (420, 7, 'George Paget Thomson', 'Year 1937'),
  (421, 7, 'Victor Franz Hess', 'Year 1936'),
  (422, 7, 'Carl David Anderson', 'Year 1936'),
  (423, 7, 'James Chadwick', 'Year 1935'),
  (424, 7, 'Erwin Schrödinger', 'Year 1933'),
  (425, 7, 'Paul Adrien Maurice Dirac', 'Year 1933'),
  (426, 7, 'Werner Karl Heisenberg', 'Year 1932'),
  (427, 7, 'Sir Chandrasekhara Venkata Raman', 'Year 1930'),
  (428, 7, 'Prince Louis-Victor Pierre Raymond de Broglie', 'Year 1929'),
  (429, 7, 'Owen Willans Richardson', 'Year 1928'),
  (430, 7, 'Arthur Holly Compton', 'Year 1927'),
  (431, 7, 'Charles Thomson Rees Wilson', 'Year 1927'),
  (432, 7, 'Jean Baptiste Perrin', 'Year 1926'),
  (433, 7, 'James Franck', 'Year 1925'),
  (434, 7, 'Gustav Ludwig Hertz', 'Year 1925'),
  (435, 7, 'Karl Manne Georg Siegbahn', 'Year 1924'),
  (436, 7, 'Robert Andrews Millikan', 'Year 1923'),
  (437, 7, 'Niels Henrik David Bohr', 'Year 1922'),
  (438, 7, 'Albert Einstein', 'Year 1921'),
  (439, 7, 'Charles Edouard Guillaume', 'Year 1920'),
  (440, 7, 'Johannes Stark', 'Year 1919'),
  (441, 7, 'Max Karl Ernst Ludwig Planck', 'Year 1918'),
  (442, 7, 'Charles Glover Barkla', 'Year 1917'),
  (443, 7, 'Sir William Henry Bragg', 'Year 1915'),
  (444, 7, 'William Lawrence Bragg', 'Year 1915'),
  (445, 7, 'Max von Laue', 'Year 1914'),
  (446, 7, 'Heike Kamerlingh Onnes', 'Year 1913'),
  (447, 7, 'Nils Gustaf Dalén', 'Year 1912'),
  (448, 7, 'Wilhelm Wien', 'Year 1911'),
  (449, 7, 'Johannes Diderik van der Waals', 'Year 1910'),
  (450, 7, 'Guglielmo Marconi', 'Year 1909'),
  (451, 7, 'Karl Ferdinand Braun', 'Year 1909'),
  (452, 7, 'Gabriel Lippmann', 'Year 1908'),
  (453, 7, 'Albert Abraham Michelson', 'Year 1907'),
  (454, 7, 'Joseph John Thomson', 'Year 1906'),
  (455, 7, 'Philipp Eduard Anton von Lenard', 'Year 1905'),
  (456, 7, 'Lord Rayleigh (John William Strutt)', 'Year 1904'),
  (457, 7, 'Antoine Henri Becquerel', 'Year 1903'),
  (458, 7, 'Pierre Curie', 'Year 1903'),
  (459, 7, 'Marie Curie, née Sklodowska', 'Year 1903'),
  (460, 7, 'Hendrik Antoon Lorentz', 'Year 1902'),
  (461, 7, 'Pieter Zeeman', 'Year 1902'),
  (462, 7, 'Wilhelm Conrad Röntgen', 'Year 1901');

INSERT INTO category_item_alternative_spelling (category_item_id, category_id, spelling) VALUES
  (259, 7, 'david thouless'),
  (259, 7, 'thouless'),
  (260, 7, 'duncan haldane'),
  (260, 7, 'haldane'),
  (261, 7, 'michael kosterlitz'),
  (261, 7, 'kosterlitz'),
  (262, 7, 'takaaki kajita'),
  (262, 7, 'kajita'),
  (263, 7, 'arthur mcdonald'),
  (263, 7, 'mcdonald'),
  (264, 7, 'akasaki'),
  (265, 7, 'amano'),
  (266, 7, 'nakamura'),
  (267, 7, 'englert'),
  (268, 7, 'peter higgs'),
  (268, 7, 'higgs'),
  (269, 7, 'haroche'),
  (270, 7, 'david wineland'),
  (270, 7, 'wineland'),
  (271, 7, 'perlmutter'),
  (272, 7, 'brian schmidt'),
  (272, 7, 'schmidt'),
  (273, 7, 'adam riess'),
  (273, 7, 'riess'),
  (274, 7, 'geim'),
  (275, 7, 'novoselov'),
  (276, 7, 'charles kao'),
  (276, 7, 'charles kuen'),
  (276, 7, 'kuen kao'),
  (276, 7, 'kuen'),
  (276, 7, 'kao'),
  (277, 7, 'willard boyle'),
  (277, 7, 'boyle'),
  (278, 7, 'george smith'),
  (278, 7, 'smith'),
  (279, 7, 'nambu'),
  (280, 7, 'kobayashi'),
  (281, 7, 'maskawa'),
  (282, 7, 'fert'),
  (283, 7, 'grünberg'),
  (284, 7, 'john mather'),
  (284, 7, 'mather'),
  (285, 7, 'george smoot'),
  (285, 7, 'smoot'),
  (286, 7, 'roy glauber'),
  (286, 7, 'glauber'),
  (287, 7, 'john hall'),
  (287, 7, 'hall'),
  (288, 7, 'theodor hänsch'),
  (288, 7, 'hänsch'),
  (289, 7, 'david gross'),
  (289, 7, 'gross'),
  (290, 7, 'david politzer'),
  (290, 7, 'politzer'),
  (291, 7, 'wilczek'),
  (292, 7, 'alexei abrikosov'),
  (292, 7, 'abrikosov'),
  (293, 7, 'vitaly ginzburg'),
  (293, 7, 'ginzburg'),
  (294, 7, 'anthony leggett'),
  (294, 7, 'leggett'),
  (295, 7, 'raymond davis jr'),
  (295, 7, 'raymond davis junior'),
  (295, 7, 'davis jr'),
  (295, 7, 'davis junior'),
  (295, 7, 'davis'),
  (296, 7, 'koshiba'),
  (297, 7, 'giacconi'),
  (298, 7, 'eric cornell'),
  (298, 7, 'cornell'),
  (299, 7, 'ketterle'),
  (300, 7, 'carl wieman'),
  (300, 7, 'wieman'),
  (301, 7, 'zhores alferov'),
  (301, 7, 'alferov'),
  (302, 7, 'kroemer'),
  (303, 7, 'jack kilby'),
  (303, 7, 'kilby'),
  (304, 7, 'gerardus hooft'),
  (304, 7, '\'t hooft'),
  (304, 7, 't hooft'),
  (304, 7, 'hooft'),
  (305, 7, 'martinus veltman'),
  (305, 7, 'veltman'),
  (306, 7, 'robert laughlin'),
  (306, 7, 'laughlin'),
  (307, 7, 'horst störmer'),
  (307, 7, 'störmer'),
  (308, 7, 'daniel tsui'),
  (308, 7, 'tsui'),
  (309, 7, 'chu'),
  (310, 7, 'cohen-tannoudji'),
  (310, 7, 'tannoudji-cohen'),
  (310, 7, 'cohen tannoudji'),
  (310, 7, 'tannoudji cohen'),
  (310, 7, 'claude cohen tannoudji'),
  (310, 7, 'claude tannoudji cohen'),
  (310, 7, 'claude tannoudji-cohen'),
  (310, 7, 'claude cohen'),
  (310, 7, 'cohen'),
  (310, 7, 'claude tannoudji'),
  (310, 7, 'tannoudji claude'),
  (310, 7, 'tannoudji'),
  (311, 7, 'william phillips'),
  (311, 7, 'phillips'),
  (312, 7, 'david lee'),
  (312, 7, 'lee'),
  (313, 7, 'douglas osheroff'),
  (313, 7, 'osheroff'),
  (314, 7, 'robert richardson'),
  (314, 7, 'richardson'),
  (315, 7, 'martin perl'),
  (315, 7, 'perl'),
  (316, 7, 'reines'),
  (317, 7, 'bertram brockhouse'),
  (317, 7, 'brockhouse'),
  (318, 7, 'clifford shull'),
  (318, 7, 'shull'),
  (319, 7, 'russell hulse'),
  (319, 7, 'hulse'),
  (320, 7, 'joseph taylor jr.'),
  (320, 7, 'joseph taylor jr'),
  (320, 7, 'joseph taylor junior'),
  (320, 7, 'joseph taylor'),
  (320, 7, 'taylor jr.'),
  (320, 7, 'taylor jr'),
  (320, 7, 'taylor junior'),
  (321, 7, 'charpak'),
  (322, 7, 'pierre-gilles gennes'),
  (322, 7, 'pierre gilles de gennes'),
  (322, 7, 'pierre gilles gennes'),
  (322, 7, 'pierre de gennes'),
  (322, 7, 'pierre gennes'),
  (322, 7, 'gilles de gennes'),
  (322, 7, 'gilles gennes'),
  (322, 7, 'de gennes'),
  (322, 7, 'gennes'),
  (323, 7, 'jerome friedman'),
  (323, 7, 'friedman'),
  (324, 7, 'henry kendall'),
  (324, 7, 'kendall'),
  (325, 7, 'richard taylor'),
  (325, 7, 'taylor'),
  (326, 7, 'norman ramsey'),
  (326, 7, 'ramsey'),
  (327, 7, 'hans dehmelt'),
  (327, 7, 'dehmelt'),
  (328, 7, 'paul'),
  (329, 7, 'leon lederman'),
  (329, 7, 'lederman'),
  (330, 7, 'schwartz'),
  (331, 7, 'steinberger'),
  (332, 7, 'georg bednorz'),
  (332, 7, 'bednorz'),
  (333, 7, 'alexander müller'),
  (333, 7, 'müller'),
  (334, 7, 'ruska'),
  (335, 7, 'binnig'),
  (336, 7, 'rohrer'),
  (337, 7, 'klaus klitzing'),
  (337, 7, 'von klitzing'),
  (337, 7, 'klitzing'),
  (338, 7, 'rubbia'),
  (339, 7, 'simon van meer'),
  (339, 7, 'simon der meer'),
  (339, 7, 'simon meer'),
  (339, 7, 'van der meer'),
  (339, 7, 'van meer'),
  (339, 7, 'der meer'),
  (339, 7, 'meer'),
  (340, 7, 'chandrasekhar'),
  (341, 7, 'william fowler'),
  (341, 7, 'alfred fowler'),
  (341, 7, 'fowler'),
  (342, 7, 'kenneth wilson'),
  (343, 7, 'bloembergen'),
  (344, 7, 'arthur schawlow'),
  (344, 7, 'leonard schawlow'),
  (344, 7, 'schawlow'),
  (345, 7, 'kai siegbahn'),
  (345, 7, 'siegbahn'),
  (346, 7, 'james cronin'),
  (346, 7, 'watson cronin'),
  (346, 7, 'cronin'),
  (347, 7, 'val fitch'),
  (347, 7, 'logsdon fitch'),
  (347, 7, 'fitch'),
  (348, 7, 'sheldon glashow'),
  (348, 7, 'lee glashow'),
  (348, 7, 'glashow'),
  (349, 7, 'salam'),
  (350, 7, 'weinberg'),
  (351, 7, 'pyotr kapitsa'),
  (351, 7, 'leonidovich kapitsa'),
  (351, 7, 'kapitsa'),
  (352, 7, 'arno penzias'),
  (352, 7, 'allan penzias'),
  (352, 7, 'penzias'),
  (353, 7, 'robert wilson'),
  (353, 7, 'woodrow wilson'),
  (353, 7, 'wilson'),
  (354, 7, 'philip anderson'),
  (354, 7, 'warren anderson'),
  (354, 7, 'anderson'),
  (355, 7, 'sir nevill mott'),
  (355, 7, 'sir francis mott'),
  (355, 7, 'sir mott'),
  (355, 7, 'nevill francis mott'),
  (355, 7, 'nevill mott'),
  (355, 7, 'francis mott'),
  (355, 7, 'mott'),
  (356, 7, 'john hasbrouck vleck'),
  (356, 7, 'john van vleck'),
  (356, 7, 'john vleck'),
  (356, 7, 'hasbrouck van vleck'),
  (356, 7, 'van vleck'),
  (356, 7, 'vleck'),
  (356, 7, 'hasbrouck vleck'),
  (357, 7, 'richter'),
  (358, 7, 'samuel chao chung ting'),
  (358, 7, 'chung ting'),
  (358, 7, 'chao ting'),
  (358, 7, 'samuel ting'),
  (358, 7, 'ting'),
  (358, 7, 'samuel chao ting'),
  (358, 7, 'samuel chung ting'),
  (358, 7, 'chao chung ting'),
  (359, 7, 'aage bohr'),
  (360, 7, 'ben mottelson'),
  (360, 7, 'roy mottelson'),
  (360, 7, 'mottelson'),
  (361, 7, 'leo rainwater'),
  (361, 7, 'james rainwater'),
  (361, 7, 'rainwater'),
  (362, 7, 'martin ryle'),
  (362, 7, 'sir ryle'),
  (362, 7, 'ryle'),
  (363, 7, 'hewish'),
  (364, 7, 'esaki'),
  (365, 7, 'giaever'),
  (366, 7, 'brian josephson'),
  (366, 7, 'david josephson'),
  (366, 7, 'josephson'),
  (368, 7, 'leon cooper'),
  (368, 7, 'neil cooper'),
  (368, 7, 'cooper'),
  (369, 7, 'john schrieffer'),
  (369, 7, 'robert schrieffer'),
  (369, 7, 'schrieffer'),
  (370, 7, 'gabor'),
  (371, 7, 'hannes alfvén'),
  (371, 7, 'olof alfvén'),
  (371, 7, 'gösta alfvén'),
  (371, 7, 'alfvén'),
  (371, 7, 'hannes olof alfvén'),
  (371, 7, 'hannes gösta alfvén'),
  (371, 7, 'olof gösta alfvén'),
  (372, 7, 'louis néel'),
  (372, 7, 'eugène néel'),
  (372, 7, 'félix néel'),
  (372, 7, 'louis eugène néel'),
  (372, 7, 'louis félix néel'),
  (372, 7, 'eugène félix néel'),
  (372, 7, 'néel'),
  (373, 7, 'murray gell mann'),
  (373, 7, 'gell-mann'),
  (373, 7, 'murray gell'),
  (373, 7, 'murray mann'),
  (373, 7, 'gell'),
  (373, 7, 'mann'),
  (374, 7, 'luis alvarez'),
  (374, 7, 'walter alvarez'),
  (374, 7, 'alvarez'),
  (375, 7, 'hans bethe'),
  (375, 7, 'albrecht bethe'),
  (375, 7, 'bethe'),
  (376, 7, 'kastler'),
  (377, 7, 'sinitiro tomonaga'),
  (377, 7, 'sin itiro tomonaga'),
  (377, 7, 'tomonaga'),
  (378, 7, 'schwinger'),
  (379, 7, 'richard feynman'),
  (379, 7, 'feynman'),
  (380, 7, 'charles townes'),
  (380, 7, 'hard townes'),
  (380, 7, 'townes'),
  (381, 7, 'nicolay basov'),
  (381, 7, 'gennadiyevich basov'),
  (381, 7, 'basov'),
  (382, 7, 'aleksandr prokhorov'),
  (382, 7, 'mikhailovich prokhorov'),
  (382, 7, 'prokhorov'),
  (383, 7, 'paul wigner'),
  (383, 7, 'eugene wigner'),
  (383, 7, 'wigner'),
  (384, 7, 'maria mayer'),
  (384, 7, 'goeppert mayer'),
  (384, 7, 'mayer'),
  (385, 7, 'hans jensen'),
  (385, 7, 'jensen'),
  (386, 7, 'lev landau'),
  (386, 7, 'davidovich landau'),
  (386, 7, 'landau'),
  (387, 7, 'hofstadter'),
  (388, 7, 'ludwig mössbauer'),
  (388, 7, 'rudolf mössbauer'),
  (388, 7, 'mössbauer'),
  (389, 7, 'donald glaser'),
  (389, 7, 'arthur glaser'),
  (389, 7, 'glaser'),
  (390, 7, 'emilio segrè'),
  (390, 7, 'gino segrè'),
  (390, 7, 'segrè'),
  (391, 7, 'chamberlain'),
  (392, 7, 'pavel cherenkov'),
  (392, 7, 'alekseyevich cherenkov'),
  (392, 7, 'cherenkov'),
  (393, 7, 'ilja mikhailovich frank'),
  (393, 7, 'il´ja frank'),
  (393, 7, 'ilja frank'),
  (393, 7, 'mikhailovich frank'),
  (393, 7, 'frank'),
  (394, 7, 'igor tamm'),
  (394, 7, 'yevgenyevich tamm'),
  (394, 7, 'tamm'),
  (395, 7, 'chen yang'),
  (395, 7, 'ning yang'),
  (395, 7, 'yang'),
  (396, 7, 'tsung-dao lee'),
  (397, 7, 'william shockley'),
  (397, 7, 'bradford shockley'),
  (397, 7, 'shockley'),
  (398, 7, 'bardeen'),
  (399, 7, 'houser brattain'),
  (399, 7, 'walter brattain'),
  (399, 7, 'brattain'),
  (400, 7, 'willis lamb'),
  (400, 7, 'eugene lamb'),
  (400, 7, 'lamb'),
  (401, 7, 'kusch'),
  (402, 7, 'born'),
  (403, 7, 'bothe'),
  (404, 7, 'zernike'),
  (405, 7, 'bloch'),
  (406, 7, 'edward purcell'),
  (406, 7, 'mills purcell'),
  (406, 7, 'purcell'),
  (407, 7, 'sir john cockcroft'),
  (407, 7, 'sir douglas cockcroft'),
  (407, 7, 'john douglas cockcroft'),
  (407, 7, 'douglas cockcroft'),
  (407, 7, 'sir cockcroft'),
  (407, 7, 'john cockcroft'),
  (407, 7, 'cockcroft'),
  (408, 7, 'thomas sinton walton'),
  (408, 7, 'ernest sinton walton'),
  (408, 7, 'ernest thomas walton'),
  (408, 7, 'sinton walton'),
  (408, 7, 'ernest walton'),
  (408, 7, 'thomas walton'),
  (408, 7, 'walton'),
  (409, 7, 'cecil powell'),
  (409, 7, 'frank powell'),
  (409, 7, 'powell'),
  (410, 7, 'yukawa'),
  (411, 7, 'maynard stuart blackett'),
  (411, 7, 'patrick stuart blackett'),
  (411, 7, 'patrick maynard blackett'),
  (411, 7, 'stuart blackett'),
  (411, 7, 'patrick blackett'),
  (411, 7, 'maynard blackett'),
  (411, 7, 'blackett'),
  (412, 7, 'edward victor appleton'),
  (412, 7, 'sir victor appleton'),
  (412, 7, 'sir edward appleton'),
  (412, 7, 'victor appleton'),
  (412, 7, 'sir appleton'),
  (412, 7, 'edward appleton'),
  (412, 7, 'appleton'),
  (413, 7, 'percy bridgman'),
  (413, 7, 'williams bridgman'),
  (413, 7, 'bridgman'),
  (414, 7, 'pauli'),
  (415, 7, 'isidor rabi'),
  (415, 7, 'isaac rabi'),
  (415, 7, 'rabi'),
  (416, 7, 'stern'),
  (417, 7, 'ernest lawrence'),
  (417, 7, 'orlando lawrence'),
  (417, 7, 'lawrence'),
  (418, 7, 'fermi'),
  (419, 7, 'clinton davisson'),
  (419, 7, 'joseph davisson'),
  (419, 7, 'davisson'),
  (420, 7, 'george thomson'),
  (420, 7, 'paget thomson'),
  (420, 7, 'thomson'),
  (421, 7, 'victor hess'),
  (421, 7, 'franz hess'),
  (421, 7, 'hess'),
  (422, 7, 'carl anderson'),
  (422, 7, 'david anderson'),
  (423, 7, 'chadwick'),
  (424, 7, 'schrödinger'),
  (425, 7, 'adrien maurice dirac'),
  (425, 7, 'paul maurice dirac'),
  (425, 7, 'paul adrien dirac'),
  (425, 7, 'maurice dirac'),
  (425, 7, 'paul dirac'),
  (425, 7, 'adrien dirac'),
  (425, 7, 'dirac'),
  (426, 7, 'werner heisenberg'),
  (426, 7, 'karl heisenberg'),
  (426, 7, 'heisenberg'),
  (427, 7, 'chandrasekhara venkata raman'),
  (427, 7, 'sir venkata raman'),
  (427, 7, 'sir chandrasekhara raman'),
  (427, 7, 'venkata raman'),
  (427, 7, 'sir raman'),
  (427, 7, 'chandrasekhara raman'),
  (427, 7, 'raman'),
  (428, 7, 'louis-victor pierre raymond de broglie'),
  (428, 7, 'louis victor pierre raymond de broglie'),
  (428, 7, 'prince pierre raymond de broglie'),
  (428, 7, 'prince louis-victor raymond de broglie'),
  (428, 7, 'prince louis victor raymond de broglie'),
  (428, 7, 'prince louis-victor pierre de broglie'),
  (428, 7, 'prince louis victor pierre de broglie'),
  (428, 7, 'pierre raymond de broglie'),
  (428, 7, 'prince raymond de broglie'),
  (428, 7, 'prince louis-victor de broglie'),
  (428, 7, 'prince louis victor de broglie'),
  (428, 7, 'raymond de broglie'),
  (428, 7, 'louis-victor de broglie'),
  (428, 7, 'louis victor de broglie'),
  (428, 7, 'pierre de broglie'),
  (428, 7, 'prince de broglie'),
  (428, 7, 'de broglie'),
  (428, 7, 'louis-victor pierre raymond broglie'),
  (428, 7, 'louis victor pierre raymond broglie'),
  (428, 7, 'prince pierre raymond broglie'),
  (428, 7, 'prince louis-victor raymond broglie'),
  (428, 7, 'prince louis victor raymond broglie'),
  (428, 7, 'prince louis-victor pierre broglie'),
  (428, 7, 'prince louis victor pierre broglie'),
  (428, 7, 'pierre raymond broglie'),
  (428, 7, 'prince raymond broglie'),
  (428, 7, 'prince louis-victor broglie'),
  (428, 7, 'prince louis victor broglie'),
  (428, 7, 'raymond broglie'),
  (428, 7, 'louis-victor broglie'),
  (428, 7, 'louis victor broglie'),
  (428, 7, 'pierre broglie'),
  (428, 7, 'prince broglie'),
  (428, 7, 'broglie'),
  (429, 7, 'owen richardson'),
  (429, 7, 'willans richardson'),
  (430, 7, 'arthur compton'),
  (430, 7, 'holly compton'),
  (430, 7, 'compton'),
  (431, 7, 'thomson rees wilson'),
  (431, 7, 'charles rees wilson'),
  (431, 7, 'charles thomson wilson'),
  (431, 7, 'rees wilson'),
  (431, 7, 'charles wilson'),
  (431, 7, 'thomson wilson'),
  (432, 7, 'jean perrin'),
  (432, 7, 'baptiste perrin'),
  (432, 7, 'perrin'),
  (433, 7, 'franck'),
  (434, 7, 'gustav hertz'),
  (434, 7, 'ludwig hertz'),
  (434, 7, 'hertz'),
  (435, 7, 'manne georg siegbahn'),
  (435, 7, 'karl georg siegbahn'),
  (435, 7, 'karl manne siegbahn'),
  (435, 7, 'georg siegbahn'),
  (435, 7, 'karl siegbahn'),
  (435, 7, 'manne siegbahn'),
  (436, 7, 'robert millikan'),
  (436, 7, 'andrews millikan'),
  (436, 7, 'millikan'),
  (437, 7, 'henrik david bohr'),
  (437, 7, 'niels david bohr'),
  (437, 7, 'niels henrik bohr'),
  (437, 7, 'david bohr'),
  (437, 7, 'niels bohr'),
  (437, 7, 'henrik bohr'),
  (437, 7, 'bohr'),
  (438, 7, 'einstein'),
  (439, 7, 'charles guillaume'),
  (439, 7, 'edouard guillaume'),
  (439, 7, 'guillaume'),
  (440, 7, 'stark'),
  (441, 7, 'max karl ernst ludwig planck'),
  (441, 7, 'max planck'),
  (441, 7, 'planck'),
  (442, 7, 'charles barkla'),
  (442, 7, 'glover barkla'),
  (442, 7, 'barkla'),
  (443, 7, 'william henry bragg'),
  (443, 7, 'sir henry bragg'),
  (443, 7, 'sir william bragg'),
  (443, 7, 'henry bragg'),
  (443, 7, 'sir bragg'),
  (444, 7, 'william bragg'),
  (444, 7, 'lawrence bragg'),
  (444, 7, 'bragg'),
  (445, 7, 'max laue'),
  (445, 7, 'von laue'),
  (445, 7, 'laue'),
  (446, 7, 'heike onnes'),
  (446, 7, 'kamerlingh onnes'),
  (446, 7, 'onnes'),
  (447, 7, 'nils dalén'),
  (447, 7, 'gustaf dalén'),
  (447, 7, 'dalén'),
  (448, 7, 'wien'),
  (449, 7, 'johannes van der waals'),
  (449, 7, 'johannes van waals'),
  (449, 7, 'johannes der waals'),
  (449, 7, 'johannes waals'),
  (449, 7, 'diderik van der waals'),
  (449, 7, 'diderik van waals'),
  (449, 7, 'diderik der waals'),
  (449, 7, 'diderik waals'),
  (449, 7, 'van der waals'),
  (449, 7, 'van waals'),
  (449, 7, 'der waals'),
  (449, 7, 'waals'),
  (450, 7, 'marconi'),
  (451, 7, 'karl braun'),
  (451, 7, 'ferdinand braun'),
  (451, 7, 'braun'),
  (452, 7, 'lippmann'),
  (453, 7, 'albert michelson'),
  (453, 7, 'abraham michelson'),
  (453, 7, 'michelson'),
  (454, 7, 'joseph thomson'),
  (454, 7, 'john thomson'),
  (455, 7, 'philipp von lenard'),
  (455, 7, 'von lenard'),
  (455, 7, 'lenard'),
  (456, 7, 'lord rayleigh'),
  (456, 7, 'rayleigh'),
  (456, 7, 'john strutt'),
  (456, 7, 'william strutt'),
  (456, 7, 'strutt'),
  (457, 7, 'antoine becquerel'),
  (457, 7, 'henri becquerel'),
  (457, 7, 'becquerel'),
  (459, 7, 'marie curie'),
  (459, 7, 'curie'),
  (459, 7, 'marie sklodowska'),
  (459, 7, 'sklodowska'),
  (460, 7, 'hendrik lorentz'),
  (460, 7, 'antoon lorentz'),
  (460, 7, 'lorentz'),
  (461, 7, 'zeeman'),
  (462, 7, 'wilhelm röntgen'),
  (462, 7, 'conrad röntgen'),
  (462, 7, 'röntgen');

INSERT INTO category (id, name) VALUES (8, 'States of the USA');

INSERT INTO category_item (id, category_id, name) VALUES
  (463, 8, 'Alabama'),
  (464, 8, 'Alaska'),
  (465, 8, 'Arizona'),
  (466, 8, 'Arkansas'),
  (467, 8, 'California'),
  (468, 8, 'Colorado'),
  (469, 8, 'Connecticut'),
  (470, 8, 'Delaware'),
  (471, 8, 'Florida'),
  (472, 8, 'Georgia'),
  (473, 8, 'Hawaii'),
  (474, 8, 'Idaho'),
  (475, 8, 'Illinois'),
  (476, 8, 'Indiana'),
  (477, 8, 'Iowa'),
  (478, 8, 'Kansas'),
  (479, 8, 'Kentucky'),
  (480, 8, 'Louisiana'),
  (481, 8, 'Maine'),
  (482, 8, 'Maryland'),
  (483, 8, 'Massachusetts'),
  (484, 8, 'Michigan'),
  (485, 8, 'Minnesota'),
  (486, 8, 'Mississippi'),
  (487, 8, 'Missouri'),
  (488, 8, 'Montana'),
  (489, 8, 'Nebraska'),
  (490, 8, 'Nevada'),
  (491, 8, 'New Hampshire'),
  (492, 8, 'New Jersey'),
  (493, 8, 'New Mexico'),
  (494, 8, 'New York'),
  (495, 8, 'North Carolina'),
  (496, 8, 'North Dakota'),
  (497, 8, 'Ohio'),
  (498, 8, 'Oklahoma'),
  (499, 8, 'Oregon'),
  (500, 8, 'Pennsylvania'),
  (501, 8, 'Rhode Island'),
  (502, 8, 'South Carolina'),
  (503, 8, 'South Dakota'),
  (504, 8, 'Tennessee'),
  (505, 8, 'Texas'),
  (506, 8, 'Utah'),
  (507, 8, 'Vermont'),
  (508, 8, 'Virginia'),
  (509, 8, 'Washington'),
  (510, 8, 'West Virginia'),
  (511, 8, 'Wisconsin'),
  (512, 8, 'Wyoming');

INSERT INTO category SET
  id=9,
  name='Pokemons, First Generation';

INSERT INTO category_item (id, category_id, name) VALUES
  (513, 9, 'Bulbasaur'),
  (514, 9, 'Ivysaur'),
  (515, 9, 'Venusaur'),
  (516, 9, 'Charmander'),
  (517, 9, 'Charmeleon'),
  (518, 9, 'Charizard'),
  (519, 9, 'Squirtle'),
  (520, 9, 'Wartortle'),
  (521, 9, 'Blastoise'),
  (522, 9, 'Caterpie'),
  (523, 9, 'Metapod'),
  (524, 9, 'Butterfree'),
  (525, 9, 'Weedle'),
  (526, 9, 'Kakuna'),
  (527, 9, 'Beedrill'),
  (528, 9, 'Pidgey'),
  (529, 9, 'Pidgeotto'),
  (530, 9, 'Pidgeot'),
  (531, 9, 'Rattata'),
  (532, 9, 'Raticate'),
  (533, 9, 'Spearow'),
  (534, 9, 'Fearow'),
  (535, 9, 'Ekans'),
  (536, 9, 'Arbok'),
  (537, 9, 'Pikachu'),
  (538, 9, 'Raichu'),
  (539, 9, 'Sandshrew'),
  (540, 9, 'Sandslash'),
  (541, 9, 'Nidoran♀'),
  (542, 9, 'Nidorina'),
  (543, 9, 'Nidoqueen'),
  (544, 9, 'Nidoran♂'),
  (545, 9, 'Nidorino'),
  (546, 9, 'Nidoking'),
  (547, 9, 'Clefairy'),
  (548, 9, 'Clefable'),
  (549, 9, 'Vulpix'),
  (550, 9, 'Ninetales'),
  (551, 9, 'Jigglypuff'),
  (552, 9, 'Wigglytuff'),
  (553, 9, 'Zubat'),
  (554, 9, 'Golbat'),
  (555, 9, 'Oddish'),
  (556, 9, 'Gloom'),
  (557, 9, 'Vileplume'),
  (558, 9, 'Paras'),
  (559, 9, 'Parasect'),
  (560, 9, 'Venonat'),
  (561, 9, 'Venomoth'),
  (562, 9, 'Diglett'),
  (563, 9, 'Dugtrio'),
  (564, 9, 'Meowth'),
  (565, 9, 'Persian'),
  (566, 9, 'Psyduck'),
  (567, 9, 'Golduck'),
  (568, 9, 'Mankey'),
  (569, 9, 'Primeape'),
  (570, 9, 'Growlithe'),
  (571, 9, 'Arcanine'),
  (572, 9, 'Poliwag'),
  (573, 9, 'Poliwhirl'),
  (574, 9, 'Poliwrath'),
  (575, 9, 'Abra'),
  (576, 9, 'Kadabra'),
  (577, 9, 'Alakazam'),
  (578, 9, 'Machop'),
  (579, 9, 'Machoke'),
  (580, 9, 'Machamp'),
  (581, 9, 'Bellsprout'),
  (582, 9, 'Weepinbell'),
  (583, 9, 'Victreebel'),
  (584, 9, 'Tentacool'),
  (585, 9, 'Tentacruel'),
  (586, 9, 'Geodude'),
  (587, 9, 'Graveler'),
  (588, 9, 'Golem'),
  (589, 9, 'Ponyta'),
  (590, 9, 'Rapidash'),
  (591, 9, 'Slowpoke'),
  (592, 9, 'Slowbro'),
  (593, 9, 'Magnemite'),
  (594, 9, 'Magneton'),
  (595, 9, 'Farfetch\'d'),
  (596, 9, 'Doduo'),
  (597, 9, 'Dodrio'),
  (598, 9, 'Seel'),
  (599, 9, 'Dewgong'),
  (600, 9, 'Grimer'),
  (601, 9, 'Muk'),
  (602, 9, 'Shellder'),
  (603, 9, 'Cloyster'),
  (604, 9, 'Gastly'),
  (605, 9, 'Haunter'),
  (606, 9, 'Gengar'),
  (607, 9, 'Onix'),
  (608, 9, 'Drowzee'),
  (609, 9, 'Hypno'),
  (610, 9, 'Krabby'),
  (611, 9, 'Kingler'),
  (612, 9, 'Voltorb'),
  (613, 9, 'Electrode'),
  (614, 9, 'Exeggcute'),
  (615, 9, 'Exeggutor'),
  (616, 9, 'Cubone'),
  (617, 9, 'Marowak'),
  (618, 9, 'Hitmonlee'),
  (619, 9, 'Hitmonchan'),
  (620, 9, 'Lickitung'),
  (621, 9, 'Koffing'),
  (622, 9, 'Weezing'),
  (623, 9, 'Rhyhorn'),
  (624, 9, 'Rhydon'),
  (625, 9, 'Chansey'),
  (626, 9, 'Tangela'),
  (627, 9, 'Kangaskhan'),
  (628, 9, 'Horsea'),
  (629, 9, 'Seadra'),
  (630, 9, 'Goldeen'),
  (631, 9, 'Seaking'),
  (632, 9, 'Staryu'),
  (633, 9, 'Starmie'),
  (634, 9, 'Mr. Mime'),
  (635, 9, 'Scyther'),
  (636, 9, 'Jynx'),
  (637, 9, 'Electabuzz'),
  (638, 9, 'Magmar'),
  (639, 9, 'Pinsir'),
  (640, 9, 'Tauros'),
  (641, 9, 'Magikarp'),
  (642, 9, 'Gyarados'),
  (643, 9, 'Lapras'),
  (644, 9, 'Ditto'),
  (645, 9, 'Eevee'),
  (646, 9, 'Vaporeon'),
  (647, 9, 'Jolteon'),
  (648, 9, 'Flareon'),
  (649, 9, 'Porygon'),
  (650, 9, 'Omanyte'),
  (651, 9, 'Omastar'),
  (652, 9, 'Kabuto'),
  (653, 9, 'Kabutops'),
  (654, 9, 'Aerodactyl'),
  (655, 9, 'Snorlax'),
  (656, 9, 'Articuno'),
  (657, 9, 'Zapdos'),
  (658, 9, 'Moltres'),
  (659, 9, 'Dratini'),
  (660, 9, 'Dragonair'),
  (661, 9, 'Dragonite'),
  (662, 9, 'Mewtwo'),
  (663, 9, 'Mew');


INSERT INTO category SET
  id=10,
  name='Java Keywords';

INSERT INTO category_item (id, name, category_id, extra_information) VALUES
  (664, 10, 'abstract', 'Abstract is used to implement the abstraction in java. A method which doesn’t have method definition must be declared as abstract and the class containing it must be declared as abstract. You can’t instantiate abstract classes. Abstract methods must be implemented in the sub classes. You can’t use abstract keyword with variables and constructors.'),
  (665, 10, 'assert', 'Assert describes a predicate (a true–false statement) placed in a java-program to indicate that the developer thinks that the predicate is always true at that place. If an assertion evaluates to false at run-time, an assertion failure results, which typically causes execution to abort. Optionally enable by ClassLoader method.'),
  (666, 10, 'boolean', 'Defines a boolean variable for the values "true" or "false" only.'),
  (667, 10, 'break', 'Used to end the execution in the current loop body.'),
  (668, 10, 'byte', 'The byte keyword is used to declare a field that can hold an 8-bit signed two''s complement integer. This keyword is also used to declare that a method returns a value of the primitive type byte.'),
  (669, 10, 'case', 'A statement in the switch block can be labeled with one or more case or default labels. The switch statement evaluates its expression, then executes all statements that follow the matching case label; see switch.'),
  (670, 10, 'catch', 'Used in conjunction with a try block and an optional finally block. The statements in the catch block specify what to do if a specific type of exception is thrown by the try block.'),
  (671, 10, 'char', 'Defines a character variable capable of holding any character of the java source file''s character set.'),
  (672, 10, 'class', 'A type that defines the implementation of a particular kind of object. A class definition defines instance and class fields, methods, and inner classes as well as specifying the interfaces the class implements and the immediate superclass of the class. If the superclass is not explicitly specified, the superclass is implicitly Object. The class keyword can also be used in the form Class.class to get a Class object without needing an instance of that class. For example, String.class can be used instead of doing new String().getClass().'),
  (673, 10, 'continue', 'Used to resume program execution at the end of the current loop body. If followed by a label, continue resumes execution at the end of the enclosing labeled loop body.'),
  (674, 10, 'default', 'The default keyword can optionally be used in a switch statement to label a block of statements to be executed if no case matches the specified value; see switch. Alternatively, the default keyword can also be used to declare default values in a Java annotation. From Java 8 onwards, the default keyword is also used to specify that a method in an interface provides the default implementation of a method.'),
  (675, 10, 'do', 'The do keyword is used in conjunction with while to create a do-while loop, which executes a block of statements associated with the loop and then tests a boolean expression associated with the while. If the expression evaluates to true, the block is executed again; this continues until the expression evaluates to false.'),
  (676, 10, 'double', 'The double keyword is used to declare a variable that can hold a 64-bit double precision IEEE 754 floating-point number. This keyword is also used to declare that a method returns a value of the primitive type double.'),
  (677, 10, 'else', 'The else keyword is used in conjunction with if to create an if-else statement, which tests a boolean expression; if the expression evaluates to true, the block of statements associated with the if are evaluated; if it evaluates to false, the block of statements associated with the else are evaluated.'),
  (678, 10, 'enum', 'A Java keyword used to declare an enumerated type. Enumerations extend the base class Enum.'),
  (679, 10, 'extends', 'Used in a class declaration to specify the superclass; used in an interface declaration to specify one or more superinterfaces. Class X extends class Y to add functionality, either by adding fields or methods to class Y, or by overriding methods of class Y. An interface Z extends one or more interfaces by adding methods. Class X is said to be a subclass of class Y; Interface Z is said to be a subinterface of the interfaces it extends. Also used to specify an upper bound on a type parameter in Generics.'),
  (680, 10, 'final', 'Define an entity once that cannot be changed nor derived from later. More specifically: a final class cannot be subclassed, a final method cannot be overridden, and a final variable can occur at most once as a left-hand expression on an executed command. All methods in a final class are implicitly final.'),
  (681, 10, 'finally', 'Used to define a block of statements for a block defined previously by the try keyword. The finally block is executed after execution exits the try block and any associated catch clauses regardless of whether an exception was thrown or caught, or execution left method in the middle of the try or catch blocks using the return keyword.'),
  (682, 10, 'float', 'The float keyword is used to declare a variable that can hold a 32-bit single precision IEEE 754 floating-point number. This keyword is also used to declare that a method returns a value of the primitive type float.'),
  (683, 10, 'for', 'The for keyword is used to create a for loop, which specifies a variable initialization, a boolean expression, and an incrementation. The variable initialization is performed first, and then the boolean expression is evaluated. If the expression evaluates to true, the block of statements associated with the loop are executed, and then the incrementation is performed. The boolean expression is then evaluated again; this continues until the expression evaluates to false. As of J2SE 5.0, the for keyword can also be used to create a so-called "enhanced for loop", which specifies an array or Iterable object; each iteration of the loop executes the associated block of statements using a different element in the array or Iterable.'),
  (684, 10, 'if', 'The if keyword is used to create an if statement, which tests a boolean expression; if the expression evaluates to true, the block of statements associated with the if statement is executed. This keyword can also be used to create an if-else statement; see else.'),
  (685, 10, 'implements', 'Included in a class declaration to specify one or more interfaces that are implemented by the current class. A class inherits the types and abstract methods declared by the interfaces.'),
  (686, 10, 'import', 'Used at the beginning of a source file to specify classes or entire Java packages to be referred to later without including their package names in the reference. Since J2SE 5.0, import statements can import static members of a class.'),
  (687, 10, 'instanceof', 'A binary operator that takes an object reference as its first operand and a class or interface as its second operand and produces a boolean result. The instanceof operator evaluates to true if and only if the runtime type of the object is assignment compatible with the class or interface.'),
  (688, 10, 'int', 'The int keyword is used to declare a variable that can hold a 32-bit signed two''s complement integer. This keyword is also used to declare that a method returns a value of the primitive type int.'),
  (689, 10, 'interface', 'Used to declare a special type of class that only contains abstract or default methods, constant (static final) fields and static interfaces. It can later be implemented by classes that declare the interface with the implements keyword.'),
  (690, 10, 'long', 'The long keyword is used to declare a variable that can hold a 64-bit signed two''s complement integer. This keyword is also used to declare that a method returns a value of the primitive type long.'),
  (691, 10, 'native', 'Used in method declarations to specify that the method is not implemented in the same Java source file, but rather in another language.'),
  (692, 10, 'new', 'Used to create an instance of a class or array object. Using keyword for this end is not completely necessary (as exemplified by Scala), though it serves two purposes: it enables the existence of different namespace for methods and class names, it defines statically and locally that a fresh object is indeed created, and of what runtime type it is (arguably introducing dependency into the code).'),
  (693, 10, 'package', 'A group of types. Packages are declared with the package keyword.'),
  (694, 10, 'private', 'The private keyword is used in the declaration of a method, field, or inner class; private members can only be accessed by other members of their own class.'),
  (695, 10, 'protected', 'The protected keyword is used in the declaration of a method, field, or inner class; protected members can only be accessed by members of their own class, that class''s subclasses or classes from the same package.'),
  (696, 10, 'public', 'The public keyword is used in the declaration of a class, method, or field; public classes, methods, and fields can be accessed by the members of any class.'),
  (697, 10, 'return', 'Used to finish the execution of a method. It can be followed by a value required by the method definition that is returned to the caller.'),
  (698, 10, 'short', 'The short keyword is used to declare a field that can hold a 16-bit signed two''s complement integer. This keyword is also used to declare that a method returns a value of the primitive type short.'),
  (699, 10, 'static', 'Used to declare a field, method, or inner class as a class field. Classes maintain one copy of class fields regardless of how many instances exist of that class. static also is used to define a method as a class method. Class methods are bound to the class instead of to a specific instance, and can only operate on class fields. (Classes and interfaces declared as static members of another class or interface are actually top-level classes and are not inner classes.)'),
  (700, 10, 'strictfp', 'A Java keyword used to restrict the precision and rounding of floating point calculations to ensure portability.'),
  (701, 10, 'super', 'Used to access members of a class inherited by the class in which it appears. Allows a subclass to access overridden methods and hidden members of its superclass. The super keyword is also used to forward a call from a constructor to a constructor in the superclass. Also used to specify a lower bound on a type parameter in Generics.'),
  (702, 10, 'switch', 'The switch keyword is used in conjunction with case and default to create a switch statement, which evaluates a variable, matches its value to a specific case, and executes the block of statements associated with that case. If no case matches the value, the optional block labelled by default is executed, if included.'),
  (703, 10, 'synchronized', 'Used in the declaration of a method or code block to acquire the mutex lock for an object while the current thread executes the code. For static methods, the object locked is the class''s Class. Guarantees that at most one thread at a time operating on the same object executes that code. The mutex lock is automatically released when execution exits the synchronized code. Fields, classes and interfaces cannot be declared as synchronized.'),
  (704, 10, 'this', 'Used to represent an instance of the class in which it appears. this can be used to access class members and as a reference to the current instance. The this keyword is also used to forward a call from one constructor in a class to another constructor in the same class.'),
  (705, 10, 'throw', 'Causes the declared exception instance to be thrown. This causes execution to continue with the first enclosing exception handler declared by the catch keyword to handle an assignment compatible exception type. If no such exception handler is found in the current method, then the method returns and the process is repeated in the calling method. If no exception handler is found in any method call on the stack, then the exception is passed to the thread''s uncaught exception handler.'),
  (706, 10, 'throws', 'Used in method declarations to specify which exceptions are not handled within the method but rather passed to the next higher level of the program. All uncaught exceptions in a method that are not instances of RuntimeException must be declared using the throws keyword.'),
  (707, 10, 'transient', 'Declares that an instance field is not part of the default serialized form of an object. When an object is serialized, only the values of its non-transient instance fields are included in the default serial representation. When an object is deserialized, transient fields are initialized only to their default value. If the default form is not used, e.g. when a serialPersistentFields table is declared in the class hierarchy, all transient keywords are ignored.'),
  (708, 10, 'try', 'Defines a block of statements that have exception handling. If an exception is thrown inside the try block, an optional catch block can handle declared exception types. Also, an optional finally block can be declared that will be executed when execution exits the try block and catch clauses, regardless of whether an exception is thrown or not. A try block must have at least one catch clause or a finally block.'),
  (709, 10, 'void', 'The void keyword is used to declare that a method does not return any value.'),
  (710, 10, 'volatile', 'Used in field declarations to specify that the variable is modified asynchronously by concurrently running threads. Methods, classes and interfaces thus cannot be declared volatile, nor can local variables or parameters.'),
  (711, 10, 'while', 'The while keyword is used to create a while loop, which tests a boolean expression and executes the block of statements associated with the loop if the expression evaluates to true; this continues until the expression evaluates to false. This keyword can also be used to create a do-while loop; see do.'),
  (712, 10, 'true', 'A boolean literal value.'),
  (713, 10, 'null', 'A reference literal value.'),
  (714, 10, 'false', 'A boolean literal value.'),
  (715, 10, 'const', 'Although reserved as a keyword in Java, const is not used and has no function. For defining constants in Java, see the final keyword.'),
  (716, 10, 'goto', 'Although reserved as a keyword in Java, goto is not used and has no function.');


INSERT INTO category SET
  id=11,
  name='Presidents of Sweden';

INSERT INTO category_item (id, name, category_id, extra_information) VALUES
  ;

<tbody>
<tr>
<td>
<div style="position:relative;top:-{{{oTop}}}px;left:-{{{oLeft}}}px"><a href="https://commons.wikimedia.org/wiki/File:Louis_De_Geer_1818-1896_from_Hildebrand_Sveriges_historia.jpg" class="image"><img alt="Louis De Geer 1818-1896 from Hildebrand Sveriges historia.jpg" src="//upload.wikimedia.org/wikipedia/commons/thumb/2/24/Louis_De_Geer_1818-1896_from_Hildebrand_Sveriges_historia.jpg/100px-Louis_De_Geer_1818-1896_from_Hildebrand_Sveriges_historia.jpg" width="100" height="145" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/2/24/Louis_De_Geer_1818-1896_from_Hildebrand_Sveriges_historia.jpg/150px-Louis_De_Geer_1818-1896_from_Hildebrand_Sveriges_historia.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/2/24/Louis_De_Geer_1818-1896_from_Hildebrand_Sveriges_historia.jpg/200px-Louis_De_Geer_1818-1896_from_Hildebrand_Sveriges_historia.jpg 2x" data-file-width="567" data-file-height="822" class="hoverZoomLink"></a></div>
</div>
</td>
<td style="text-align:center" data-sort-value="De Geer (1818-1896)"><b><a href="/wiki/Louis_De_Geer_(1818%E2%80%931896)" title="Louis De Geer (1818–1896)">Louis De Geer d.ä.</a></b></td>
<td style="text-align:center">20 mars 1876</td>
<td style="text-align:center">19 april 1880</td>
<td style="background:#DDDDDD">&nbsp;</td>
<td style="text-align:center"><a href="/wiki/Partil%C3%B6s" title="Partilös">Partilös</a></td>
<td style="text-align:center"><a href="/wiki/Regeringen_De_Geer_d.%C3%A4._II" class="mw-redirect" title="Regeringen De Geer d.ä. II">De Geer d.ä. II</a></td>
<td style="text-align:center"><sup id="cite_ref-25" class="reference"><a href="#cite_note-25"><span class="cite-reference-link-bracket">[</span>25<span class="cite-reference-link-bracket">]</span></a></sup></td>
</tr>
<tr>
<td>
<div style="position:relative;top:-{{{oTop}}}px;left:-{{{oLeft}}}px"><a href="https://commons.wikimedia.org/wiki/File:Arvid_Posse.jpg" class="image"><img alt="Arvid Posse.jpg" src="//upload.wikimedia.org/wikipedia/commons/thumb/d/dd/Arvid_Posse.jpg/100px-Arvid_Posse.jpg" width="100" height="141" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/d/dd/Arvid_Posse.jpg/150px-Arvid_Posse.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/d/dd/Arvid_Posse.jpg 2x" data-file-width="174" data-file-height="245" class="hoverZoomLink"></a></div>
</div>
</td>
<td style="text-align:center" data-sort-value="Posse"><b><a href="/wiki/Arvid_Posse" title="Arvid Posse">Arvid Posse</a></b></td>
<td style="text-align:center">19 april 1880</td>
<td style="text-align:center">13 juni 1883</td>
<td style="background:#1B49DD">&nbsp;</td>
<td style="text-align:center"><a href="/wiki/Lantmannapartiet" title="Lantmannapartiet">Lantmannapartiet</a></td>
<td style="text-align:center"><a href="/wiki/Regeringen_Posse" title="Regeringen Posse">Posse</a></td>
<td style="text-align:center"><sup id="cite_ref-26" class="reference"><a href="#cite_note-26"><span class="cite-reference-link-bracket">[</span>26<span class="cite-reference-link-bracket">]</span></a></sup></td>
</tr>
<tr>
<td>
<div style="position:relative;top:-{{{oTop}}}px;left:-{{{oLeft}}}px"><a href="https://commons.wikimedia.org/wiki/File:Carl_Johan_Thyselius_(Hildebrand_Sveriges_historia).jpg" class="image"><img alt="Carl Johan Thyselius (Hildebrand Sveriges historia).jpg" src="//upload.wikimedia.org/wikipedia/commons/thumb/4/4d/Carl_Johan_Thyselius_%28Hildebrand_Sveriges_historia%29.jpg/100px-Carl_Johan_Thyselius_%28Hildebrand_Sveriges_historia%29.jpg" width="100" height="143" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/4/4d/Carl_Johan_Thyselius_%28Hildebrand_Sveriges_historia%29.jpg/150px-Carl_Johan_Thyselius_%28Hildebrand_Sveriges_historia%29.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/4/4d/Carl_Johan_Thyselius_%28Hildebrand_Sveriges_historia%29.jpg/200px-Carl_Johan_Thyselius_%28Hildebrand_Sveriges_historia%29.jpg 2x" data-file-width="577" data-file-height="823" class="hoverZoomLink"></a></div>
</div>
</td>
<td style="text-align:center" data-sort-value="Thyselius"><b><a href="/wiki/Carl_Johan_Thyselius" title="Carl Johan Thyselius">Carl Johan Thyselius</a></b></td>
<td style="text-align:center">13 juni 1883</td>
<td style="text-align:center">16 maj 1884</td>
<td style="background:#DDDDDD">&nbsp;</td>
<td style="text-align:center"><a href="/wiki/Partil%C3%B6s" title="Partilös">Partilös</a></td>
<td style="text-align:center"><a href="/wiki/Regeringen_Thyselius" title="Regeringen Thyselius">Thyselius</a></td>
<td style="text-align:center"><sup id="cite_ref-27" class="reference"><a href="#cite_note-27"><span class="cite-reference-link-bracket">[</span>27<span class="cite-reference-link-bracket">]</span></a></sup></td>
</tr>
<tr>
<td>
<div style="position:relative;top:-{{{oTop}}}px;left:-{{{oLeft}}}px"><a href="https://commons.wikimedia.org/wiki/File:Oscar_Robert_Themptander_(from_Hildebrand,_Sveriges_historia).jpg" class="image"><img alt="Oscar Robert Themptander (from Hildebrand, Sveriges historia).jpg" src="//upload.wikimedia.org/wikipedia/commons/thumb/2/2f/Oscar_Robert_Themptander_%28from_Hildebrand%2C_Sveriges_historia%29.jpg/100px-Oscar_Robert_Themptander_%28from_Hildebrand%2C_Sveriges_historia%29.jpg" width="100" height="144" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/2/2f/Oscar_Robert_Themptander_%28from_Hildebrand%2C_Sveriges_historia%29.jpg/150px-Oscar_Robert_Themptander_%28from_Hildebrand%2C_Sveriges_historia%29.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/2/2f/Oscar_Robert_Themptander_%28from_Hildebrand%2C_Sveriges_historia%29.jpg/200px-Oscar_Robert_Themptander_%28from_Hildebrand%2C_Sveriges_historia%29.jpg 2x" data-file-width="567" data-file-height="819" class="hoverZoomLink"></a></div>
</div>
</td>
<td style="text-align:center" data-sort-value="Themptander"><b><a href="/wiki/Robert_Themptander" title="Robert Themptander">Robert Themptander</a></b></td>
<td style="text-align:center">16 maj 1884</td>
<td style="text-align:center">6 februari 1888</td>
<td style="background:#DDDDDD">&nbsp;</td>
<td style="text-align:center"><a href="/wiki/Partil%C3%B6s" title="Partilös">Partilös</a></td>
<td style="text-align:center"><a href="/wiki/Regeringen_Themptander" title="Regeringen Themptander">Themptander</a></td>
<td style="text-align:center"><sup id="cite_ref-28" class="reference"><a href="#cite_note-28"><span class="cite-reference-link-bracket">[</span>28<span class="cite-reference-link-bracket">]</span></a></sup></td>
</tr>
<tr>
<td>
<div style="position:relative;top:-{{{oTop}}}px;left:-{{{oLeft}}}px"><a href="https://commons.wikimedia.org/wiki/File:Painting_of_Gillis_Bildt.jpg" class="image"><img alt="Painting of Gillis Bildt.jpg" src="//upload.wikimedia.org/wikipedia/commons/thumb/9/9b/Painting_of_Gillis_Bildt.jpg/100px-Painting_of_Gillis_Bildt.jpg" width="100" height="131" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/9/9b/Painting_of_Gillis_Bildt.jpg/150px-Painting_of_Gillis_Bildt.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/9/9b/Painting_of_Gillis_Bildt.jpg/200px-Painting_of_Gillis_Bildt.jpg 2x" data-file-width="228" data-file-height="298" class="hoverZoomLink"></a></div>
</div>
</td>
<td style="text-align:center" data-sort-value="Bildt"><b><a href="/wiki/Gillis_Bildt" title="Gillis Bildt">Gillis Bildt</a></b></td>
<td style="text-align:center">6 februari 1888</td>
<td style="text-align:center">12 oktober 1889</td>
<td style="background:#DDDDDD">&nbsp;</td>
<td style="text-align:center"><a href="/wiki/Partil%C3%B6s" title="Partilös">Partilös</a></td>
<td style="text-align:center"><a href="/wiki/Regeringen_Gillis_Bildt" title="Regeringen Gillis Bildt">G. Bildt</a></td>
<td style="text-align:center"><sup id="cite_ref-29" class="reference"><a href="#cite_note-29"><span class="cite-reference-link-bracket">[</span>29<span class="cite-reference-link-bracket">]</span></a></sup></td>
</tr>
<tr>
<td>
<div style="position:relative;top:-{{{oTop}}}px;left:-{{{oLeft}}}px"><a href="https://commons.wikimedia.org/wiki/File:Gustaf_%C3%85kerhielm.jpg" class="image"><img alt="Gustaf Åkerhielm.jpg" src="//upload.wikimedia.org/wikipedia/commons/thumb/a/a8/Gustaf_%C3%85kerhielm.jpg/100px-Gustaf_%C3%85kerhielm.jpg" width="100" height="124" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/a/a8/Gustaf_%C3%85kerhielm.jpg/150px-Gustaf_%C3%85kerhielm.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/a/a8/Gustaf_%C3%85kerhielm.jpg/200px-Gustaf_%C3%85kerhielm.jpg 2x" data-file-width="288" data-file-height="357" class="hoverZoomLink"></a></div>
</div>
</td>
<td style="text-align:center" data-sort-value="Åkerhielm"><b><a href="/wiki/Gustaf_%C3%85kerhielm" title="Gustaf Åkerhielm">Gustaf Åkerhielm</a></b></td>
<td style="text-align:center">12 oktober 1889</td>
<td style="text-align:center">10 juli 1891</td>
<td style="background:#1B49DD">&nbsp;</td>
<td style="text-align:center"><a href="/wiki/F%C3%B6rsta_kammarens_protektionistiska_parti" title="Första kammarens protektionistiska parti">Protektionistiska partiet</a></td>
<td style="text-align:center"><a href="/wiki/Regeringen_%C3%85kerhielm" title="Regeringen Åkerhielm">Åkerhielm</a></td>
<td style="text-align:center"><sup id="cite_ref-30" class="reference"><a href="#cite_note-30"><span class="cite-reference-link-bracket">[</span>30<span class="cite-reference-link-bracket">]</span></a></sup></td>
</tr>
<tr>
<td>
<div style="position:relative;top:-{{{oTop}}}px;left:-{{{oLeft}}}px"><a href="https://commons.wikimedia.org/wiki/File:E_G_Bostr%C3%B6m_from_Hildebrand_Sveriges_historia.jpg" class="image"><img alt="E G Boström from Hildebrand Sveriges historia.jpg" src="//upload.wikimedia.org/wikipedia/commons/thumb/1/1b/E_G_Bostr%C3%B6m_from_Hildebrand_Sveriges_historia.jpg/100px-E_G_Bostr%C3%B6m_from_Hildebrand_Sveriges_historia.jpg" width="100" height="134" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/1/1b/E_G_Bostr%C3%B6m_from_Hildebrand_Sveriges_historia.jpg/150px-E_G_Bostr%C3%B6m_from_Hildebrand_Sveriges_historia.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/1/1b/E_G_Bostr%C3%B6m_from_Hildebrand_Sveriges_historia.jpg/200px-E_G_Bostr%C3%B6m_from_Hildebrand_Sveriges_historia.jpg 2x" data-file-width="559" data-file-height="747" class="hoverZoomLink"></a></div>
</div>
</td>
<td style="text-align:center" data-sort-value="Boström"><b><a href="/wiki/Erik_Gustaf_Bostr%C3%B6m" title="Erik Gustaf Boström">Erik Gustaf Boström</a></b></td>
<td style="text-align:center">10 juli 1891</td>
<td style="text-align:center">12 september 1900</td>
<td style="background:#1B49DD">&nbsp;</td>
<td style="text-align:center"><a href="/wiki/Lantmannapartiet" title="Lantmannapartiet">Lantmannapartiet</a></td>
<td style="text-align:center"><a href="/wiki/Regeringen_Bostr%C3%B6m_I" title="Regeringen Boström I">Boström I</a></td>
<td style="text-align:center"><sup id="cite_ref-bostr.C3.B6m_31-0" class="reference"><a href="#cite_note-bostr.C3.B6m-31"><span class="cite-reference-link-bracket">[</span>31<span class="cite-reference-link-bracket">]</span></a></sup></td>
</tr>
<tr>
<td>
<div style="position:relative;top:-{{{oTop}}}px;left:-{{{oLeft}}}px"><a href="https://commons.wikimedia.org/wiki/File:Fredrik_von_Otter.jpg" class="image"><img alt="Fredrik von Otter.jpg" src="//upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Fredrik_von_Otter.jpg/100px-Fredrik_von_Otter.jpg" width="100" height="135" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Fredrik_von_Otter.jpg/150px-Fredrik_von_Otter.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Fredrik_von_Otter.jpg/200px-Fredrik_von_Otter.jpg 2x" data-file-width="351" data-file-height="474" class="hoverZoomLink"></a></div>
</div>
</td>
<td style="text-align:center" data-sort-value="Otter"><b><a href="/wiki/Fredrik_von_Otter" title="Fredrik von Otter">Fredrik von Otter</a></b></td>
<td style="text-align:center">12 september 1900</td>
<td style="text-align:center">5 juli 1902</td>
<td style="background:#DDDDDD">&nbsp;</td>
<td style="text-align:center"><a href="/wiki/Partil%C3%B6s" title="Partilös">Partilös</a></td>
<td style="text-align:center"><a href="/wiki/Regeringen_von_Otter" title="Regeringen von Otter">von Otter</a></td>
<td style="text-align:center"><sup id="cite_ref-regeringen.se_32-0" class="reference"><a href="#cite_note-regeringen.se-32"><span class="cite-reference-link-bracket">[</span>32<span class="cite-reference-link-bracket">]</span></a></sup></td>
</tr>
<tr>
<td>
<div style="position:relative;top:-{{{oTop}}}px;left:-{{{oLeft}}}px"><a href="https://commons.wikimedia.org/wiki/File:E_G_Bostr%C3%B6m_from_Hildebrand_Sveriges_historia.jpg" class="image"><img alt="E G Boström from Hildebrand Sveriges historia.jpg" src="//upload.wikimedia.org/wikipedia/commons/thumb/1/1b/E_G_Bostr%C3%B6m_from_Hildebrand_Sveriges_historia.jpg/100px-E_G_Bostr%C3%B6m_from_Hildebrand_Sveriges_historia.jpg" width="100" height="134" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/1/1b/E_G_Bostr%C3%B6m_from_Hildebrand_Sveriges_historia.jpg/150px-E_G_Bostr%C3%B6m_from_Hildebrand_Sveriges_historia.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/1/1b/E_G_Bostr%C3%B6m_from_Hildebrand_Sveriges_historia.jpg/200px-E_G_Bostr%C3%B6m_from_Hildebrand_Sveriges_historia.jpg 2x" data-file-width="559" data-file-height="747" class="hoverZoomLink"></a></div>
</div>
</td>
<td style="text-align:center" data-sort-value="Boström"><b><a href="/wiki/Erik_Gustaf_Bostr%C3%B6m" title="Erik Gustaf Boström">Erik Gustaf Boström</a></b></td>
<td style="text-align:center">5 juli 1902</td>
<td style="text-align:center">13 april 1905</td>
<td style="background:#1B49DD">&nbsp;</td>
<td style="text-align:center"><a href="/wiki/Lantmannapartiet" title="Lantmannapartiet">Lantmannapartiet</a></td>
<td style="text-align:center"><a href="/wiki/Regeringen_Bostr%C3%B6m_II" title="Regeringen Boström II">Boström II</a></td>
<td style="text-align:center"><sup id="cite_ref-bostr.C3.B6m_31-1" class="reference"><a href="#cite_note-bostr.C3.B6m-31"><span class="cite-reference-link-bracket">[</span>31<span class="cite-reference-link-bracket">]</span></a></sup><sup id="cite_ref-regeringen.se_32-1" class="reference"><a href="#cite_note-regeringen.se-32"><span class="cite-reference-link-bracket">[</span>32<span class="cite-reference-link-bracket">]</span></a></sup></td>
</tr>
<tr>
<td>
<div style="position:relative;top:-{{{oTop}}}px;left:-{{{oLeft}}}px"><a href="https://commons.wikimedia.org/wiki/File:JohanRamstedt.JPG" class="image"><img alt="JohanRamstedt.JPG" src="//upload.wikimedia.org/wikipedia/commons/thumb/e/e9/JohanRamstedt.JPG/100px-JohanRamstedt.JPG" width="100" height="143" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/e/e9/JohanRamstedt.JPG/150px-JohanRamstedt.JPG 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/e/e9/JohanRamstedt.JPG/200px-JohanRamstedt.JPG 2x" data-file-width="813" data-file-height="1159" class="hoverZoomLink"></a></div>
</div>
</td>
<td style="text-align:center" data-sort-value="Ramstedt"><b><a href="/wiki/Johan_Ramstedt" title="Johan Ramstedt">Johan Ramstedt</a></b></td>
<td style="text-align:center">13 april 1905</td>
<td style="text-align:center">2 augusti 1905</td>
<td style="background:#DDDDDD">&nbsp;</td>
<td style="text-align:center"><a href="/wiki/Partil%C3%B6s" title="Partilös">Partilös</a></td>
<td style="text-align:center"><a href="/wiki/Regeringen_Ramstedt" title="Regeringen Ramstedt">Ramstedt</a></td>
<td style="text-align:center"><sup id="cite_ref-regeringen.se_32-2" class="reference"><a href="#cite_note-regeringen.se-32"><span class="cite-reference-link-bracket">[</span>32<span class="cite-reference-link-bracket">]</span></a></sup></td>
</tr>
<tr>
<td>
<div style="position:relative;top:-{{{oTop}}}px;left:-{{{oLeft}}}px"><a href="https://commons.wikimedia.org/wiki/File:Christian_Lundeberg.jpg" class="image"><img alt="Christian Lundeberg.jpg" src="//upload.wikimedia.org/wikipedia/commons/thumb/b/be/Christian_Lundeberg.jpg/100px-Christian_Lundeberg.jpg" width="100" height="139" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/b/be/Christian_Lundeberg.jpg/150px-Christian_Lundeberg.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/b/be/Christian_Lundeberg.jpg/200px-Christian_Lundeberg.jpg 2x" data-file-width="495" data-file-height="686" class="hoverZoomLink"></a></div>
</div>
</td>
<td style="text-align:center" data-sort-value="Lundeberg"><b><a href="/wiki/Christian_Lundeberg" title="Christian Lundeberg">Christian Lundeberg</a></b></td>
<td style="text-align:center">2 augusti 1905</td>
<td style="text-align:center">7 november 1905</td>
<td style="background:#1B49DD">&nbsp;</td>
<td style="text-align:center"><a href="/wiki/F%C3%B6rsta_kammarens_protektionistiska_parti" title="Första kammarens protektionistiska parti">Protektionistiska partiet</a></td>
<td style="text-align:center"><a href="/wiki/Regeringen_Lundeberg" title="Regeringen Lundeberg">Lundeberg</a></td>
<td style="text-align:center"><sup id="cite_ref-regeringen.se_32-3" class="reference"><a href="#cite_note-regeringen.se-32"><span class="cite-reference-link-bracket">[</span>32<span class="cite-reference-link-bracket">]</span></a></sup></td>
</tr>
<tr>
<td>
<div style="position:relative;top:-{{{oTop}}}px;left:-{{{oLeft}}}px"><a href="https://commons.wikimedia.org/wiki/File:Karl_Staaff.jpg" class="image"><img alt="Karl Staaff.jpg" src="//upload.wikimedia.org/wikipedia/commons/thumb/b/b4/Karl_Staaff.jpg/100px-Karl_Staaff.jpg" width="100" height="134" srcset="//upload.wikimedia.org/wikipedia/commons/b/b4/Karl_Staaff.jpg 1.5x" data-file-width="145" data-file-height="194" class="hoverZoomLink"></a></div>
</div>
</td>
<td style="text-align:center" data-sort-value="Staaff"><b><a href="/wiki/Karl_Staaff" title="Karl Staaff">Karl Staaff</a></b></td>
<td style="text-align:center">7 november 1905</td>
<td style="text-align:center">29 maj 1906</td>
<td style="background:#3399ff">&nbsp;</td>
<td style="text-align:center"><a href="/wiki/Liberala_samlingspartiet" title="Liberala samlingspartiet">Liberala samlingspartiet</a></td>
<td style="text-align:center"><a href="/wiki/Regeringen_Staaff_I" title="Regeringen Staaff I">Staaff I</a></td>
<td style="text-align:center"><sup id="cite_ref-regeringen.se_32-4" class="reference"><a href="#cite_note-regeringen.se-32"><span class="cite-reference-link-bracket">[</span>32<span class="cite-reference-link-bracket">]</span></a></sup></td>
</tr>
<tr>
<td>
<div style="position:relative;top:-{{{oTop}}}px;left:-{{{oLeft}}}px"><a href="https://commons.wikimedia.org/wiki/File:Arvid_Lindman.jpg" class="image"><img alt="Arvid Lindman.jpg" src="//upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Arvid_Lindman.jpg/100px-Arvid_Lindman.jpg" width="100" height="132" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Arvid_Lindman.jpg/150px-Arvid_Lindman.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Arvid_Lindman.jpg/200px-Arvid_Lindman.jpg 2x" data-file-width="2058" data-file-height="2712" class="hoverZoomLink"></a></div>
</div>
</td>
<td style="text-align:center" data-sort-value="Lindman"><b><a href="/wiki/Arvid_Lindman" title="Arvid Lindman">Arvid Lindman</a></b></td>
<td style="text-align:center">29 maj 1906</td>
<td style="text-align:center">7 oktober 1911</td>
<td style="background:#ff9933">&nbsp;</td>
<td style="text-align:center"><a href="/wiki/Lantmanna-_och_borgarepartiet" class="mw-redirect" title="Lantmanna- och borgarepartiet">Lantmanna- och borgarepartiet</a></td>
<td style="text-align:center"><a href="/wiki/Regeringen_Lindman_I" title="Regeringen Lindman I">Lindman I</a></td>
<td style="text-align:center"><sup id="cite_ref-regeringen.se_32-5" class="reference"><a href="#cite_note-regeringen.se-32"><span class="cite-reference-link-bracket">[</span>32<span class="cite-reference-link-bracket">]</span></a></sup></td>
</tr>
<tr>
<td>
<div style="position:relative;top:-{{{oTop}}}px;left:-{{{oLeft}}}px"><a href="https://commons.wikimedia.org/wiki/File:Karl_Staaff.jpg" class="image"><img alt="Karl Staaff.jpg" src="//upload.wikimedia.org/wikipedia/commons/thumb/b/b4/Karl_Staaff.jpg/100px-Karl_Staaff.jpg" width="100" height="134" srcset="//upload.wikimedia.org/wikipedia/commons/b/b4/Karl_Staaff.jpg 1.5x" data-file-width="145" data-file-height="194" class="hoverZoomLink"></a></div>
</div>
</td>
<td style="text-align:center" data-sort-value="Staaff"><b><a href="/wiki/Karl_Staaff" title="Karl Staaff">Karl Staaff</a></b></td>
<td style="text-align:center">7 oktober 1911</td>
<td style="text-align:center">17 februari 1914</td>
<td style="background:#3399ff">&nbsp;</td>
<td style="text-align:center"><a href="/wiki/Liberala_samlingspartiet" title="Liberala samlingspartiet">Liberala samlingspartiet</a></td>
<td style="text-align:center"><a href="/wiki/Regeringen_Staaff_II" title="Regeringen Staaff II">Staaff II</a></td>
<td style="text-align:center"><sup id="cite_ref-regeringen.se_32-6" class="reference"><a href="#cite_note-regeringen.se-32"><span class="cite-reference-link-bracket">[</span>32<span class="cite-reference-link-bracket">]</span></a></sup></td>
</tr>
<tr>
<td>
<div style="position:relative;top:-{{{oTop}}}px;left:-{{{oLeft}}}px"><a href="https://commons.wikimedia.org/wiki/File:Hjalmar_Hammarskj%C3%B6ld.jpg" class="image"><img alt="Hjalmar Hammarskjöld.jpg" src="//upload.wikimedia.org/wikipedia/commons/thumb/6/68/Hjalmar_Hammarskj%C3%B6ld.jpg/100px-Hjalmar_Hammarskj%C3%B6ld.jpg" width="100" height="135" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/6/68/Hjalmar_Hammarskj%C3%B6ld.jpg/150px-Hjalmar_Hammarskj%C3%B6ld.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/6/68/Hjalmar_Hammarskj%C3%B6ld.jpg/200px-Hjalmar_Hammarskj%C3%B6ld.jpg 2x" data-file-width="701" data-file-height="947" class="hoverZoomLink"></a></div>
</div>
</td>
<td style="text-align:center" data-sort-value="Hammarskjöld"><b><a href="/wiki/Hjalmar_Hammarskj%C3%B6ld" title="Hjalmar Hammarskjöld">Hjalmar Hammarskjöld</a></b></td>
<td style="text-align:center">17 februari 1914</td>
<td style="text-align:center">30 mars 1917</td>
<td style="background:#DDDDDD">&nbsp;</td>
<td style="text-align:center"><a href="/wiki/Partil%C3%B6s" title="Partilös">Partilös</a></td>
<td style="text-align:center"><a href="/wiki/Regeringen_Hammarskj%C3%B6ld" title="Regeringen Hammarskjöld">Hammarskjöld</a></td>
<td style="text-align:center"><sup id="cite_ref-regeringen.se_32-7" class="reference"><a href="#cite_note-regeringen.se-32"><span class="cite-reference-link-bracket">[</span>32<span class="cite-reference-link-bracket">]</span></a></sup></td>
</tr>
<tr>
<td>
<div style="position:relative;top:-{{{oTop}}}px;left:-{{{oLeft}}}px"><a href="https://commons.wikimedia.org/wiki/File:Swartz,_Carl_i_VJ_47_1916.jpg" class="image"><img alt="Swartz, Carl i VJ 47 1916.jpg" src="//upload.wikimedia.org/wikipedia/commons/thumb/5/56/Swartz%2C_Carl_i_VJ_47_1916.jpg/100px-Swartz%2C_Carl_i_VJ_47_1916.jpg" width="100" height="125" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/5/56/Swartz%2C_Carl_i_VJ_47_1916.jpg/150px-Swartz%2C_Carl_i_VJ_47_1916.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/5/56/Swartz%2C_Carl_i_VJ_47_1916.jpg/200px-Swartz%2C_Carl_i_VJ_47_1916.jpg 2x" data-file-width="292" data-file-height="366" class="hoverZoomLink"></a></div>
</div>
</td>
<td style="text-align:center" data-sort-value="Swartz"><b><a href="/wiki/Carl_Swartz" title="Carl Swartz">Carl Swartz</a></b></td>
<td style="text-align:center">30 mars 1917</td>
<td style="text-align:center">19 oktober 1917</td>
<td style="background:#1B49DD">&nbsp;</td>
<td style="text-align:center"><a href="/wiki/F%C3%B6rsta_kammarens_nationella_parti" title="Första kammarens nationella parti">Nationella partiet</a></td>
<td style="text-align:center"><a href="/wiki/Regeringen_Swartz" title="Regeringen Swartz">Swartz</a></td>
<td style="text-align:center"><sup id="cite_ref-regeringen.se_32-8" class="reference"><a href="#cite_note-regeringen.se-32"><span class="cite-reference-link-bracket">[</span>32<span class="cite-reference-link-bracket">]</span></a></sup></td>
</tr>
<tr>
<td>
<div style="position:relative;top:-{{{oTop}}}px;left:-{{{oLeft}}}px"><a href="https://commons.wikimedia.org/wiki/File:Nils_Eden.jpg" class="image"><img alt="Nils Eden.jpg" src="//upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Nils_Eden.jpg/100px-Nils_Eden.jpg" width="100" height="129" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Nils_Eden.jpg/150px-Nils_Eden.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Nils_Eden.jpg/200px-Nils_Eden.jpg 2x" data-file-width="227" data-file-height="292" class="hoverZoomLink"></a></div>
</div>
</td>
<td style="text-align:center" data-sort-value="Edén"><b><a href="/wiki/Nils_Ed%C3%A9n" title="Nils Edén">Nils Edén</a></b></td>
<td style="text-align:center">19 oktober 1917</td>
<td style="text-align:center">10 mars 1920</td>
<td style="background:#3399ff">&nbsp;</td>
<td style="text-align:center"><a href="/wiki/Liberala_samlingspartiet" title="Liberala samlingspartiet">Liberala samlingspartiet</a></td>
<td style="text-align:center"><a href="/wiki/Regeringen_Ed%C3%A9n" title="Regeringen Edén">Edén</a></td>
<td style="text-align:center"><sup id="cite_ref-regeringen.se_32-9" class="reference"><a href="#cite_note-regeringen.se-32"><span class="cite-reference-link-bracket">[</span>32<span class="cite-reference-link-bracket">]</span></a></sup></td>
</tr>
<tr>
<td>
<div style="position:relative;top:-{{{oTop}}}px;left:-{{{oLeft}}}px"><a href="https://commons.wikimedia.org/wiki/File:Hjalmar_Branting.png" class="image"><img alt="Hjalmar Branting.png" src="//upload.wikimedia.org/wikipedia/commons/thumb/4/49/Hjalmar_Branting.png/100px-Hjalmar_Branting.png" width="100" height="141" srcset="//upload.wikimedia.org/wikipedia/commons/4/49/Hjalmar_Branting.png 1.5x" data-file-width="140" data-file-height="198" class="hoverZoomLink"></a></div>
</div>
</td>
<td style="text-align:center" data-sort-value="Branting"><b><a href="/wiki/Hjalmar_Branting" title="Hjalmar Branting">Hjalmar Branting</a></b></td>
<td style="text-align:center">10 mars 1920</td>
<td style="text-align:center">27 oktober 1920</td>
<td style="background:#EE2020">&nbsp;</td>
<td style="text-align:center"><a href="/wiki/Socialdemokraterna_(Sverige)" title="Socialdemokraterna (Sverige)">Socialdemokraterna</a></td>
<td style="text-align:center"><a href="/wiki/Regeringen_Branting_I" title="Regeringen Branting I">Branting I</a></td>
<td style="text-align:center"><sup id="cite_ref-regeringen.se_32-10" class="reference"><a href="#cite_note-regeringen.se-32"><span class="cite-reference-link-bracket">[</span>32<span class="cite-reference-link-bracket">]</span></a></sup></td>
</tr>
<tr>
<td>
<div style="position:relative;top:-{{{oTop}}}px;left:-{{{oLeft}}}px"><a href="https://commons.wikimedia.org/wiki/File:Louis_De_Geer_1854-1935.jpg" class="image"><img alt="Louis De Geer 1854-1935.jpg" src="//upload.wikimedia.org/wikipedia/commons/thumb/6/6d/Louis_De_Geer_1854-1935.jpg/100px-Louis_De_Geer_1854-1935.jpg" width="100" height="128" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/6/6d/Louis_De_Geer_1854-1935.jpg/150px-Louis_De_Geer_1854-1935.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/6/6d/Louis_De_Geer_1854-1935.jpg/200px-Louis_De_Geer_1854-1935.jpg 2x" data-file-width="320" data-file-height="410" class="hoverZoomLink"></a></div>
</div>
</td>
<td style="text-align:center" data-sort-value="De Geer (1854-1935)"><b><a href="/wiki/Louis_De_Geer_(1854%E2%80%931935)" title="Louis De Geer (1854–1935)">Louis De Geer d.y.</a></b></td>
<td style="text-align:center">27 oktober 1920</td>
<td style="text-align:center">23 februari 1921</td>
<td style="background:#DDDDDD">&nbsp;</td>
<td style="text-align:center"><a href="/wiki/Partil%C3%B6s" title="Partilös">Partilös</a></td>
<td style="text-align:center"><a href="/wiki/Regeringen_De_Geer_d.y." title="Regeringen De Geer d.y.">De Geer d.y.</a></td>
<td style="text-align:center"><sup id="cite_ref-regeringen.se_32-11" class="reference"><a href="#cite_note-regeringen.se-32"><span class="cite-reference-link-bracket">[</span>32<span class="cite-reference-link-bracket">]</span></a></sup></td>
</tr>
<tr>
<td>
<div style="position:relative;top:-{{{oTop}}}px;left:-{{{oLeft}}}px"><a href="https://commons.wikimedia.org/wiki/File:Oscar_von_Sydow,_statsminister.jpg" class="image"><img alt="Oscar von Sydow, statsminister.jpg" src="//upload.wikimedia.org/wikipedia/commons/thumb/a/a7/Oscar_von_Sydow%2C_statsminister.jpg/100px-Oscar_von_Sydow%2C_statsminister.jpg" width="100" height="125" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/a/a7/Oscar_von_Sydow%2C_statsminister.jpg/150px-Oscar_von_Sydow%2C_statsminister.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/a/a7/Oscar_von_Sydow%2C_statsminister.jpg/200px-Oscar_von_Sydow%2C_statsminister.jpg 2x" data-file-width="980" data-file-height="1229" class="hoverZoomLink"></a></div>
</div>
</td>
<td style="text-align:center" data-sort-value="Sydow"><b><a href="/wiki/Oscar_von_Sydow" title="Oscar von Sydow">Oscar von Sydow</a></b></td>
<td style="text-align:center">23 februari 1921</td>
<td style="text-align:center">13 oktober 1921</td>
<td style="background:#DDDDDD">&nbsp;</td>
<td style="text-align:center"><a href="/wiki/Partil%C3%B6s" title="Partilös">Partilös</a></td>
<td style="text-align:center"><a href="/wiki/Regeringen_von_Sydow" title="Regeringen von Sydow">von Sydow</a></td>
<td style="text-align:center"><sup id="cite_ref-regeringen.se_32-12" class="reference"><a href="#cite_note-regeringen.se-32"><span class="cite-reference-link-bracket">[</span>32<span class="cite-reference-link-bracket">]</span></a></sup></td>
</tr>
<tr>
<td>
<div style="position:relative;top:-{{{oTop}}}px;left:-{{{oLeft}}}px"><a href="https://commons.wikimedia.org/wiki/File:Hjalmar_Branting.png" class="image"><img alt="Hjalmar Branting.png" src="//upload.wikimedia.org/wikipedia/commons/thumb/4/49/Hjalmar_Branting.png/100px-Hjalmar_Branting.png" width="100" height="141" srcset="//upload.wikimedia.org/wikipedia/commons/4/49/Hjalmar_Branting.png 1.5x" data-file-width="140" data-file-height="198" class="hoverZoomLink"></a></div>
</div>
</td>
<td style="text-align:center" data-sort-value="Branting"><b><a href="/wiki/Hjalmar_Branting" title="Hjalmar Branting">Hjalmar Branting</a></b></td>
<td style="text-align:center">13 oktober 1921</td>
<td style="text-align:center">19 april 1923</td>
<td style="background:#EE2020">&nbsp;</td>
<td style="text-align:center"><a href="/wiki/Socialdemokraterna_(Sverige)" title="Socialdemokraterna (Sverige)">Socialdemokraterna</a></td>
<td style="text-align:center"><a href="/wiki/Regeringen_Branting_II" title="Regeringen Branting II">Branting II</a></td>
<td style="text-align:center"><sup id="cite_ref-regeringen.se_32-13" class="reference"><a href="#cite_note-regeringen.se-32"><span class="cite-reference-link-bracket">[</span>32<span class="cite-reference-link-bracket">]</span></a></sup></td>
</tr>
<tr>
<td>
<div style="position:relative;top:-{{{oTop}}}px;left:-{{{oLeft}}}px"><a href="https://commons.wikimedia.org/wiki/File:Ernst_Trygger_portraited_by_Ivar_Kamke.jpg" class="image"><img alt="Ernst Trygger portraited by Ivar Kamke.jpg" src="//upload.wikimedia.org/wikipedia/commons/thumb/3/35/Ernst_Trygger_portraited_by_Ivar_Kamke.jpg/100px-Ernst_Trygger_portraited_by_Ivar_Kamke.jpg" width="100" height="139" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/3/35/Ernst_Trygger_portraited_by_Ivar_Kamke.jpg/150px-Ernst_Trygger_portraited_by_Ivar_Kamke.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/3/35/Ernst_Trygger_portraited_by_Ivar_Kamke.jpg/200px-Ernst_Trygger_portraited_by_Ivar_Kamke.jpg 2x" data-file-width="876" data-file-height="1219" class="hoverZoomLink"></a></div>
</div>
</td>
<td style="text-align:center" data-sort-value="Trygger"><b><a href="/wiki/Ernst_Trygger" title="Ernst Trygger">Ernst Trygger</a></b></td>
<td style="text-align:center">19 april 1923</td>
<td style="text-align:center">18 oktober 1924</td>
<td style="background:#1B49DD">&nbsp;</td>
<td style="text-align:center"><a href="/wiki/F%C3%B6rsta_kammarens_nationella_parti" title="Första kammarens nationella parti">Nationella partiet</a></td>
<td style="text-align:center"><a href="/wiki/Regeringen_Trygger" title="Regeringen Trygger">Trygger</a></td>
<td style="text-align:center"><sup id="cite_ref-regeringen.se_32-14" class="reference"><a href="#cite_note-regeringen.se-32"><span class="cite-reference-link-bracket">[</span>32<span class="cite-reference-link-bracket">]</span></a></sup></td>
</tr>
<tr>
<td>
<div style="position:relative;top:-{{{oTop}}}px;left:-{{{oLeft}}}px"><a href="https://commons.wikimedia.org/wiki/File:Hjalmar_Branting.png" class="image"><img alt="Hjalmar Branting.png" src="//upload.wikimedia.org/wikipedia/commons/thumb/4/49/Hjalmar_Branting.png/100px-Hjalmar_Branting.png" width="100" height="141" srcset="//upload.wikimedia.org/wikipedia/commons/4/49/Hjalmar_Branting.png 1.5x" data-file-width="140" data-file-height="198" class="hoverZoomLink"></a></div>
</div>
</td>
<td style="text-align:center" data-sort-value="Branting"><b><a href="/wiki/Hjalmar_Branting" title="Hjalmar Branting">Hjalmar Branting</a></b></td>
<td style="text-align:center">18 oktober 1924</td>
<td style="text-align:center">24 januari 1925</td>
<td style="background:#EE2020">&nbsp;</td>
<td style="text-align:center"><a href="/wiki/Socialdemokraterna_(Sverige)" title="Socialdemokraterna (Sverige)">Socialdemokraterna</a></td>
<td style="text-align:center"><a href="/wiki/Regeringen_Branting_III" title="Regeringen Branting III">Branting III</a></td>
<td style="text-align:center"><sup id="cite_ref-regeringen.se_32-15" class="reference"><a href="#cite_note-regeringen.se-32"><span class="cite-reference-link-bracket">[</span>32<span class="cite-reference-link-bracket">]</span></a></sup></td>
</tr>
<tr>
<td>
<div style="position:relative;top:-{{{oTop}}}px;left:-{{{oLeft}}}px"><a href="https://commons.wikimedia.org/wiki/File:Rickard_Sandler_-_Sveriges_styresm%C3%A4n.jpg" class="image"><img alt="Rickard Sandler - Sveriges styresmän.jpg" src="//upload.wikimedia.org/wikipedia/commons/thumb/c/c4/Rickard_Sandler_-_Sveriges_styresm%C3%A4n.jpg/100px-Rickard_Sandler_-_Sveriges_styresm%C3%A4n.jpg" width="100" height="125" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/c/c4/Rickard_Sandler_-_Sveriges_styresm%C3%A4n.jpg/150px-Rickard_Sandler_-_Sveriges_styresm%C3%A4n.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/c/c4/Rickard_Sandler_-_Sveriges_styresm%C3%A4n.jpg/200px-Rickard_Sandler_-_Sveriges_styresm%C3%A4n.jpg 2x" data-file-width="902" data-file-height="1125" class="hoverZoomLink"></a></div>
</div>
</td>
<td style="text-align:center" data-sort-value="Sandler"><b><a href="/wiki/Rickard_Sandler" title="Rickard Sandler">Rickard Sandler</a></b></td>
<td style="text-align:center">24 januari 1925</td>
<td style="text-align:center">7 juni 1926</td>
<td style="background:#EE2020">&nbsp;</td>
<td style="text-align:center"><a href="/wiki/Socialdemokraterna_(Sverige)" title="Socialdemokraterna (Sverige)">Socialdemokraterna</a></td>
<td style="text-align:center"><a href="/wiki/Regeringen_Sandler" title="Regeringen Sandler">Sandler</a></td>
<td style="text-align:center"><sup id="cite_ref-regeringen.se_32-16" class="reference"><a href="#cite_note-regeringen.se-32"><span class="cite-reference-link-bracket">[</span>32<span class="cite-reference-link-bracket">]</span></a></sup></td>
</tr>
<tr>
<td>
<div style="position:relative;top:-{{{oTop}}}px;left:-{{{oLeft}}}px"><a href="https://commons.wikimedia.org/wiki/File:Carl_Gustaf_Ekman.jpg" class="image"><img alt="Carl Gustaf Ekman.jpg" src="//upload.wikimedia.org/wikipedia/commons/thumb/2/23/Carl_Gustaf_Ekman.jpg/100px-Carl_Gustaf_Ekman.jpg" width="100" height="115" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/2/23/Carl_Gustaf_Ekman.jpg/150px-Carl_Gustaf_Ekman.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/2/23/Carl_Gustaf_Ekman.jpg/200px-Carl_Gustaf_Ekman.jpg 2x" data-file-width="875" data-file-height="1010" class="hoverZoomLink"></a></div>
</div>
</td>
<td style="text-align:center" data-sort-value="Ekman"><b><a href="/wiki/Carl_Gustaf_Ekman" title="Carl Gustaf Ekman">Carl Gustaf Ekman</a></b></td>
<td style="text-align:center">7 juni 1926</td>
<td style="text-align:center">2 oktober 1928</td>
<td style="background:#64b2ff">&nbsp;</td>
<td style="text-align:center"><a href="/wiki/Frisinnade_folkpartiet" title="Frisinnade folkpartiet">Frisinnade folkpartiet</a></td>
<td style="text-align:center"><a href="/wiki/Regeringen_Ekman_I" title="Regeringen Ekman I">Ekman I</a></td>
<td style="text-align:center"><sup id="cite_ref-regeringen.se_32-17" class="reference"><a href="#cite_note-regeringen.se-32"><span class="cite-reference-link-bracket">[</span>32<span class="cite-reference-link-bracket">]</span></a></sup></td>
</tr>
<tr>
<td>
<div style="position:relative;top:-{{{oTop}}}px;left:-{{{oLeft}}}px"><a href="https://commons.wikimedia.org/wiki/File:Arvid_Lindman.jpg" class="image"><img alt="Arvid Lindman.jpg" src="//upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Arvid_Lindman.jpg/100px-Arvid_Lindman.jpg" width="100" height="132" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Arvid_Lindman.jpg/150px-Arvid_Lindman.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Arvid_Lindman.jpg/200px-Arvid_Lindman.jpg 2x" data-file-width="2058" data-file-height="2712" class="hoverZoomLink"></a></div>
</div>
</td>
<td style="text-align:center" data-sort-value="Lindman"><b><a href="/wiki/Arvid_Lindman" title="Arvid Lindman">Arvid Lindman</a></b></td>
<td style="text-align:center">2 oktober 1928</td>
<td style="text-align:center">7 juni 1930</td>
<td style="background:#ff9933">&nbsp;</td>
<td style="text-align:center"><a href="/wiki/Lantmanna-_och_borgarepartiet" class="mw-redirect" title="Lantmanna- och borgarepartiet">Lantmanna- och borgarepartiet</a></td>
<td style="text-align:center"><a href="/wiki/Regeringen_Lindman_II" title="Regeringen Lindman II">Lindman II</a></td>
<td style="text-align:center"><sup id="cite_ref-regeringen.se_32-18" class="reference"><a href="#cite_note-regeringen.se-32"><span class="cite-reference-link-bracket">[</span>32<span class="cite-reference-link-bracket">]</span></a></sup></td>
</tr>
<tr>
<td>
<div style="position:relative;top:-{{{oTop}}}px;left:-{{{oLeft}}}px"><a href="https://commons.wikimedia.org/wiki/File:Carl_Gustaf_Ekman.jpg" class="image"><img alt="Carl Gustaf Ekman.jpg" src="//upload.wikimedia.org/wikipedia/commons/thumb/2/23/Carl_Gustaf_Ekman.jpg/100px-Carl_Gustaf_Ekman.jpg" width="100" height="115" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/2/23/Carl_Gustaf_Ekman.jpg/150px-Carl_Gustaf_Ekman.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/2/23/Carl_Gustaf_Ekman.jpg/200px-Carl_Gustaf_Ekman.jpg 2x" data-file-width="875" data-file-height="1010" class="hoverZoomLink"></a></div>
</div>
</td>
<td style="text-align:center" data-sort-value="Ekman"><b><a href="/wiki/Carl_Gustaf_Ekman" title="Carl Gustaf Ekman">Carl Gustaf Ekman</a></b></td>
<td style="text-align:center">7 juni 1930</td>
<td style="text-align:center">6 augusti 1932</td>
<td style="background:#64b2ff">&nbsp;</td>
<td style="text-align:center"><a href="/wiki/Frisinnade_folkpartiet" title="Frisinnade folkpartiet">Frisinnade folkpartiet</a></td>
<td style="text-align:center"><a href="/wiki/Regeringen_Ekman_II" title="Regeringen Ekman II">Ekman II</a></td>
<td style="text-align:center"><sup id="cite_ref-regeringen.se_32-19" class="reference"><a href="#cite_note-regeringen.se-32"><span class="cite-reference-link-bracket">[</span>32<span class="cite-reference-link-bracket">]</span></a></sup></td>
</tr>
<tr>
<td>
<div style="position:relative;top:-{{{oTop}}}px;left:-{{{oLeft}}}px"><a href="https://commons.wikimedia.org/wiki/File:Felix_Hamrin_-_Sveriges_styresm%C3%A4n.jpg" class="image"><img alt="Felix Hamrin - Sveriges styresmän.jpg" src="//upload.wikimedia.org/wikipedia/commons/thumb/0/07/Felix_Hamrin_-_Sveriges_styresm%C3%A4n.jpg/100px-Felix_Hamrin_-_Sveriges_styresm%C3%A4n.jpg" width="100" height="127" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/0/07/Felix_Hamrin_-_Sveriges_styresm%C3%A4n.jpg/150px-Felix_Hamrin_-_Sveriges_styresm%C3%A4n.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/0/07/Felix_Hamrin_-_Sveriges_styresm%C3%A4n.jpg/200px-Felix_Hamrin_-_Sveriges_styresm%C3%A4n.jpg 2x" data-file-width="446" data-file-height="567" class="hoverZoomLink"></a></div>
</div>
</td>
<td style="text-align:center" data-sort-value="Hamrin"><b><a href="/wiki/Felix_Hamrin" title="Felix Hamrin">Felix Hamrin</a></b></td>
<td style="text-align:center">6 augusti 1932</td>
<td style="text-align:center">24 september 1932</td>
<td style="background:#64b2ff">&nbsp;</td>
<td style="text-align:center"><a href="/wiki/Frisinnade_folkpartiet" title="Frisinnade folkpartiet">Frisinnade folkpartiet</a></td>
<td style="text-align:center"><a href="/wiki/Regeringen_Hamrin" title="Regeringen Hamrin">Hamrin</a></td>
<td style="text-align:center"><sup id="cite_ref-regeringen.se_32-20" class="reference"><a href="#cite_note-regeringen.se-32"><span class="cite-reference-link-bracket">[</span>32<span class="cite-reference-link-bracket">]</span></a></sup></td>
</tr>
<tr>
<td>
<div style="position:relative;top:-{{{oTop}}}px;left:-{{{oLeft}}}px"><a href="https://commons.wikimedia.org/wiki/File:Per_Albin_Hansson_-_Sveriges_styresm%C3%A4n.jpg" class="image"><img alt="Per Albin Hansson - Sveriges styresmän.jpg" src="//upload.wikimedia.org/wikipedia/commons/thumb/6/6a/Per_Albin_Hansson_-_Sveriges_styresm%C3%A4n.jpg/100px-Per_Albin_Hansson_-_Sveriges_styresm%C3%A4n.jpg" width="100" height="127" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/6/6a/Per_Albin_Hansson_-_Sveriges_styresm%C3%A4n.jpg/150px-Per_Albin_Hansson_-_Sveriges_styresm%C3%A4n.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/6/6a/Per_Albin_Hansson_-_Sveriges_styresm%C3%A4n.jpg/200px-Per_Albin_Hansson_-_Sveriges_styresm%C3%A4n.jpg 2x" data-file-width="891" data-file-height="1134" class="hoverZoomLink"></a></div>
</div>
</td>
<td style="text-align:center" data-sort-value="Hansson"><b><a href="/wiki/Per_Albin_Hansson" title="Per Albin Hansson">Per Albin Hansson</a></b></td>
<td style="text-align:center">24 september 1932</td>
<td style="text-align:center">19 juni 1936</td>
<td style="background:#EE2020">&nbsp;</td>
<td style="text-align:center"><a href="/wiki/Socialdemokraterna_(Sverige)" title="Socialdemokraterna (Sverige)">Socialdemokraterna</a></td>
<td style="text-align:center"><a href="/wiki/Regeringen_Hansson_I" title="Regeringen Hansson I">Hansson I</a></td>
<td style="text-align:center"><sup id="cite_ref-regeringen.se_32-21" class="reference"><a href="#cite_note-regeringen.se-32"><span class="cite-reference-link-bracket">[</span>32<span class="cite-reference-link-bracket">]</span></a></sup></td>
</tr>
<tr>
<td>
<div style="position:relative;top:-{{{oTop}}}px;left:-{{{oLeft}}}px"><a href="https://commons.wikimedia.org/wiki/File:Axel_Pehrsson-Bramstorp,_Scanpix.jpg" class="image"><img alt="Axel Pehrsson-Bramstorp, Scanpix.jpg" src="//upload.wikimedia.org/wikipedia/commons/thumb/2/2e/Axel_Pehrsson-Bramstorp%2C_Scanpix.jpg/100px-Axel_Pehrsson-Bramstorp%2C_Scanpix.jpg" width="100" height="136" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/2/2e/Axel_Pehrsson-Bramstorp%2C_Scanpix.jpg/150px-Axel_Pehrsson-Bramstorp%2C_Scanpix.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/2/2e/Axel_Pehrsson-Bramstorp%2C_Scanpix.jpg/200px-Axel_Pehrsson-Bramstorp%2C_Scanpix.jpg 2x" data-file-width="353" data-file-height="480" class="hoverZoomLink"></a></div>
</div>
</td>
<td style="text-align:center" data-sort-value="Pehrsson-Bramstorp"><b><a href="/wiki/Axel_Pehrsson-Bramstorp" title="Axel Pehrsson-Bramstorp">Axel Pehrsson-Bramstorp</a></b></td>
<td style="text-align:center">19 juni 1936</td>
<td style="text-align:center">28 september 1936</td>
<td style="background:#009933">&nbsp;</td>
<td style="text-align:center"><a href="/wiki/Bondef%C3%B6rbundet" class="mw-redirect" title="Bondeförbundet">Bondeförbundet</a></td>
<td style="text-align:center"><a href="/wiki/Regeringen_Pehrsson-Bramstorp" title="Regeringen Pehrsson-Bramstorp">Pehrsson-Bramstorp</a></td>
<td style="text-align:center"><sup id="cite_ref-regeringen.se_32-22" class="reference"><a href="#cite_note-regeringen.se-32"><span class="cite-reference-link-bracket">[</span>32<span class="cite-reference-link-bracket">]</span></a></sup></td>
</tr>
<tr>
<td>
<div style="position:relative;top:-{{{oTop}}}px;left:-{{{oLeft}}}px"><a href="https://commons.wikimedia.org/wiki/File:Per_Albin_Hansson_-_Sveriges_styresm%C3%A4n.jpg" class="image"><img alt="Per Albin Hansson - Sveriges styresmän.jpg" src="//upload.wikimedia.org/wikipedia/commons/thumb/6/6a/Per_Albin_Hansson_-_Sveriges_styresm%C3%A4n.jpg/100px-Per_Albin_Hansson_-_Sveriges_styresm%C3%A4n.jpg" width="100" height="127" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/6/6a/Per_Albin_Hansson_-_Sveriges_styresm%C3%A4n.jpg/150px-Per_Albin_Hansson_-_Sveriges_styresm%C3%A4n.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/6/6a/Per_Albin_Hansson_-_Sveriges_styresm%C3%A4n.jpg/200px-Per_Albin_Hansson_-_Sveriges_styresm%C3%A4n.jpg 2x" data-file-width="891" data-file-height="1134" class="hoverZoomLink"></a></div>
</div>
</td>
<td style="text-align:center" data-sort-value="Hansson"><b><a href="/wiki/Per_Albin_Hansson" title="Per Albin Hansson">Per Albin Hansson</a></b></td>
<td style="text-align:center">28 september 1936</td>
<td style="text-align:center">6 oktober 1946&nbsp;†</td>
<td style="background:#EE2020">&nbsp;</td>
<td style="text-align:center"><a href="/wiki/Socialdemokraterna_(Sverige)" title="Socialdemokraterna (Sverige)">Socialdemokraterna</a></td>
<td style="text-align:center"><a href="/wiki/Regeringen_Hansson_II" title="Regeringen Hansson II">Hansson II</a>,<br>
<a href="/wiki/Regeringen_Hansson_III" title="Regeringen Hansson III">Hansson III</a>,<br>
<a href="/wiki/Regeringen_Hansson_IV" title="Regeringen Hansson IV">Hansson IV</a></td>
<td style="text-align:center"><sup id="cite_ref-regeringen.se_32-23" class="reference"><a href="#cite_note-regeringen.se-32"><span class="cite-reference-link-bracket">[</span>32<span class="cite-reference-link-bracket">]</span></a></sup></td>
</tr>
<tr>
<td>
<div style="position:relative;top:-{{{oTop}}}px;left:-{{{oLeft}}}px"><a href="https://commons.wikimedia.org/wiki/File:%C3%96sten_Und%C3%A9n_-_Sveriges_styresm%C3%A4n.jpg" class="image"><img alt="Östen Undén - Sveriges styresmän.jpg" src="//upload.wikimedia.org/wikipedia/commons/thumb/3/3c/%C3%96sten_Und%C3%A9n_-_Sveriges_styresm%C3%A4n.jpg/100px-%C3%96sten_Und%C3%A9n_-_Sveriges_styresm%C3%A4n.jpg" width="100" height="135" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/3/3c/%C3%96sten_Und%C3%A9n_-_Sveriges_styresm%C3%A4n.jpg/150px-%C3%96sten_Und%C3%A9n_-_Sveriges_styresm%C3%A4n.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/3/3c/%C3%96sten_Und%C3%A9n_-_Sveriges_styresm%C3%A4n.jpg/200px-%C3%96sten_Und%C3%A9n_-_Sveriges_styresm%C3%A4n.jpg 2x" data-file-width="261" data-file-height="352" class="hoverZoomLink"></a></div>
</div>
</td>
<td style="text-align:center" data-sort-value="Undén"><b><a href="/wiki/%C3%96sten_Und%C3%A9n" title="Östen Undén">Östen Undén</a></b>&nbsp;(tf.)<sup id="cite_ref-33" class="reference"><a href="#cite_note-33"><span class="cite-reference-link-bracket">[</span>n 1<span class="cite-reference-link-bracket">]</span></a></sup></td>
<td style="text-align:center">6 oktober 1946</td>
<td style="text-align:center">11 oktober 1946</td>
<td style="background:#EE2020">&nbsp;</td>
<td style="text-align:center"><a href="/wiki/Socialdemokraterna_(Sverige)" title="Socialdemokraterna (Sverige)">Socialdemokraterna</a></td>
<td style="text-align:center"><a href="/wiki/Regeringen_Hansson_IV" title="Regeringen Hansson IV">Hansson IV</a></td>
<td style="text-align:center">&nbsp;</td>
</tr>
<tr>
<td>
<div style="position:relative;top:-{{{oTop}}}px;left:-{{{oLeft}}}px"><a href="https://commons.wikimedia.org/wiki/File:Tage_Erlander_1952.jpg" class="image"><img alt="Tage Erlander 1952.jpg" src="//upload.wikimedia.org/wikipedia/commons/thumb/b/be/Tage_Erlander_1952.jpg/100px-Tage_Erlander_1952.jpg" width="100" height="117" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/b/be/Tage_Erlander_1952.jpg/150px-Tage_Erlander_1952.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/b/be/Tage_Erlander_1952.jpg/200px-Tage_Erlander_1952.jpg 2x" data-file-width="1636" data-file-height="1908" class="hoverZoomLink"></a></div>
</div>
</td>
<td style="text-align:center" data-sort-value="Erlander"><b><a href="/wiki/Tage_Erlander" title="Tage Erlander">Tage Erlander</a></b></td>
<td style="text-align:center">11 oktober 1946</td>
<td style="text-align:center">14 oktober 1969</td>
<td style="background:#EE2020">&nbsp;</td>
<td style="text-align:center"><a href="/wiki/Socialdemokraterna_(Sverige)" title="Socialdemokraterna (Sverige)">Socialdemokraterna</a></td>
<td style="text-align:center"><a href="/wiki/Regeringen_Erlander_I" title="Regeringen Erlander I">Erlander I</a>,<br>
<a href="/wiki/Regeringen_Erlander_II" title="Regeringen Erlander II">Erlander II</a>,<br>
<a href="/wiki/Regeringen_Erlander_III" title="Regeringen Erlander III">Erlander III</a></td>
<td style="text-align:center"><sup id="cite_ref-regeringen.se_32-24" class="reference"><a href="#cite_note-regeringen.se-32"><span class="cite-reference-link-bracket">[</span>32<span class="cite-reference-link-bracket">]</span></a></sup></td>
</tr>
<tr>
<td>
<div style="position:relative;top:-{{{oTop}}}px;left:-{{{oLeft}}}px"><a href="https://commons.wikimedia.org/wiki/File:Olof_Palme_1974_(cropped).jpg" class="image"><img alt="Olof Palme 1974 (cropped).jpg" src="//upload.wikimedia.org/wikipedia/commons/thumb/b/bc/Olof_Palme_1974_%28cropped%29.jpg/100px-Olof_Palme_1974_%28cropped%29.jpg" width="100" height="138" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/b/bc/Olof_Palme_1974_%28cropped%29.jpg/150px-Olof_Palme_1974_%28cropped%29.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/b/bc/Olof_Palme_1974_%28cropped%29.jpg/200px-Olof_Palme_1974_%28cropped%29.jpg 2x" data-file-width="285" data-file-height="393" class="hoverZoomLink"></a></div>
</div>
</td>
<td style="text-align:center" data-sort-value="Palme"><b><a href="/wiki/Olof_Palme" title="Olof Palme">Olof Palme</a></b></td>
<td style="text-align:center">14 oktober 1969</td>
<td style="text-align:center">8 oktober 1976</td>
<td style="background:#EE2020">&nbsp;</td>
<td style="text-align:center"><a href="/wiki/Socialdemokraterna_(Sverige)" title="Socialdemokraterna (Sverige)">Socialdemokraterna</a></td>
<td style="text-align:center"><a href="/wiki/Regeringen_Palme_I" title="Regeringen Palme I">Palme I</a></td>
<td style="text-align:center"><sup id="cite_ref-regeringen.se_32-25" class="reference"><a href="#cite_note-regeringen.se-32"><span class="cite-reference-link-bracket">[</span>32<span class="cite-reference-link-bracket">]</span></a></sup></td>
</tr>
<tr>
<td>
<div style="position:relative;top:-{{{oTop}}}px;left:-{{{oLeft}}}px"><a href="https://commons.wikimedia.org/wiki/File:Falldin.JPG" class="image"><img alt="Falldin.JPG" src="//upload.wikimedia.org/wikipedia/commons/thumb/0/0a/Falldin.JPG/100px-Falldin.JPG" width="100" height="119" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/0/0a/Falldin.JPG/150px-Falldin.JPG 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/0/0a/Falldin.JPG/200px-Falldin.JPG 2x" data-file-width="268" data-file-height="320" class="hoverZoomLink"></a></div>
</div>
</td>
<td style="text-align:center" data-sort-value="Fälldin"><b><a href="/wiki/Thorbj%C3%B6rn_F%C3%A4lldin" title="Thorbjörn Fälldin">Thorbjörn Fälldin</a></b></td>
<td style="text-align:center">8 oktober 1976</td>
<td style="text-align:center">18 oktober 1978</td>
<td style="background:#009933">&nbsp;</td>
<td style="text-align:center"><a href="/wiki/Centerpartiet" title="Centerpartiet">Centerpartiet</a></td>
<td style="text-align:center"><a href="/wiki/Regeringen_F%C3%A4lldin_I" title="Regeringen Fälldin I">Fälldin I</a></td>
<td style="text-align:center"><sup id="cite_ref-regeringen.se_32-26" class="reference"><a href="#cite_note-regeringen.se-32"><span class="cite-reference-link-bracket">[</span>32<span class="cite-reference-link-bracket">]</span></a></sup></td>
</tr>
<tr>
<td>
<div style="position:relative;top:-{{{oTop}}}px;left:-{{{oLeft}}}px"><a href="https://commons.wikimedia.org/wiki/File:Ola_Ullsten.JPG" class="image"><img alt="Ola Ullsten.JPG" src="//upload.wikimedia.org/wikipedia/commons/thumb/3/36/Ola_Ullsten.JPG/100px-Ola_Ullsten.JPG" width="100" height="121" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/3/36/Ola_Ullsten.JPG/150px-Ola_Ullsten.JPG 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/3/36/Ola_Ullsten.JPG/200px-Ola_Ullsten.JPG 2x" data-file-width="1000" data-file-height="1214" class="hoverZoomLink"></a></div>
</div>
</td>
<td style="text-align:center" data-sort-value="Ullsten"><b><a href="/wiki/Ola_Ullsten" title="Ola Ullsten">Ola Ullsten</a></b></td>
<td style="text-align:center">18 oktober 1978</td>
<td style="text-align:center">12 oktober 1979</td>
<td style="background:#6BB7EC">&nbsp;</td>
<td style="text-align:center"><a href="/wiki/Folkpartiet" class="mw-redirect" title="Folkpartiet">Folkpartiet</a></td>
<td style="text-align:center"><a href="/wiki/Regeringen_Ullsten" title="Regeringen Ullsten">Ullsten</a></td>
<td style="text-align:center"><sup id="cite_ref-regeringen.se_32-27" class="reference"><a href="#cite_note-regeringen.se-32"><span class="cite-reference-link-bracket">[</span>32<span class="cite-reference-link-bracket">]</span></a></sup></td>
</tr>
<tr>
<td>
<div style="position:relative;top:-{{{oTop}}}px;left:-{{{oLeft}}}px"><a href="https://commons.wikimedia.org/wiki/File:Falldin.JPG" class="image"><img alt="Falldin.JPG" src="//upload.wikimedia.org/wikipedia/commons/thumb/0/0a/Falldin.JPG/100px-Falldin.JPG" width="100" height="119" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/0/0a/Falldin.JPG/150px-Falldin.JPG 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/0/0a/Falldin.JPG/200px-Falldin.JPG 2x" data-file-width="268" data-file-height="320" class="hoverZoomLink"></a></div>
</div>
</td>
<td style="text-align:center" data-sort-value="Fälldin"><b><a href="/wiki/Thorbj%C3%B6rn_F%C3%A4lldin" title="Thorbjörn Fälldin">Thorbjörn Fälldin</a></b></td>
<td style="text-align:center">12 oktober 1979</td>
<td style="text-align:center">8 oktober 1982</td>
<td style="background:#009933">&nbsp;</td>
<td style="text-align:center"><a href="/wiki/Centerpartiet" title="Centerpartiet">Centerpartiet</a></td>
<td style="text-align:center"><a href="/wiki/Regeringen_F%C3%A4lldin_II" title="Regeringen Fälldin II">Fälldin II</a>,<br>
<a href="/wiki/Regeringen_F%C3%A4lldin_III" title="Regeringen Fälldin III">Fälldin III</a></td>
<td style="text-align:center"><sup id="cite_ref-regeringen.se_32-28" class="reference"><a href="#cite_note-regeringen.se-32"><span class="cite-reference-link-bracket">[</span>32<span class="cite-reference-link-bracket">]</span></a></sup></td>
</tr>
<tr>
<td>
<div style="position:relative;top:-{{{oTop}}}px;left:-{{{oLeft}}}px"><a href="https://commons.wikimedia.org/wiki/File:Olof_Palme_1974_(cropped).jpg" class="image"><img alt="Olof Palme 1974 (cropped).jpg" src="//upload.wikimedia.org/wikipedia/commons/thumb/b/bc/Olof_Palme_1974_%28cropped%29.jpg/100px-Olof_Palme_1974_%28cropped%29.jpg" width="100" height="138" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/b/bc/Olof_Palme_1974_%28cropped%29.jpg/150px-Olof_Palme_1974_%28cropped%29.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/b/bc/Olof_Palme_1974_%28cropped%29.jpg/200px-Olof_Palme_1974_%28cropped%29.jpg 2x" data-file-width="285" data-file-height="393" class="hoverZoomLink"></a></div>
</div>
</td>
<td style="text-align:center" data-sort-value="Palme"><b><a href="/wiki/Olof_Palme" title="Olof Palme">Olof Palme</a></b></td>
<td style="text-align:center">8 oktober 1982</td>
<td style="text-align:center">28 februari 1986&nbsp;†</td>
<td style="background:#EE2020">&nbsp;</td>
<td style="text-align:center"><a href="/wiki/Socialdemokraterna_(Sverige)" title="Socialdemokraterna (Sverige)">Socialdemokraterna</a></td>
<td style="text-align:center"><a href="/wiki/Regeringen_Palme_II" title="Regeringen Palme II">Palme II</a></td>
<td style="text-align:center"><sup id="cite_ref-regeringen.se_32-29" class="reference"><a href="#cite_note-regeringen.se-32"><span class="cite-reference-link-bracket">[</span>32<span class="cite-reference-link-bracket">]</span></a></sup></td>
</tr>
<tr>
<td>
<div style="position:relative;top:-{{{oTop}}}px;left:-{{{oLeft}}}px"><a href="https://commons.wikimedia.org/wiki/File:Ingvar_Carlsson_p%C3%A5_Idrottsgalan_2013.jpg" class="image"><img alt="Ingvar Carlsson på Idrottsgalan 2013.jpg" src="//upload.wikimedia.org/wikipedia/commons/thumb/e/e4/Ingvar_Carlsson_p%C3%A5_Idrottsgalan_2013.jpg/100px-Ingvar_Carlsson_p%C3%A5_Idrottsgalan_2013.jpg" width="100" height="128" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/e/e4/Ingvar_Carlsson_p%C3%A5_Idrottsgalan_2013.jpg/150px-Ingvar_Carlsson_p%C3%A5_Idrottsgalan_2013.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/e/e4/Ingvar_Carlsson_p%C3%A5_Idrottsgalan_2013.jpg/200px-Ingvar_Carlsson_p%C3%A5_Idrottsgalan_2013.jpg 2x" data-file-width="1409" data-file-height="1797" class="hoverZoomLink"></a></div>
</div>
</td>
<td style="text-align:center" data-sort-value="Carlsson"><b><a href="/wiki/Ingvar_Carlsson" title="Ingvar Carlsson">Ingvar Carlsson</a></b></td>
<td style="text-align:center">1 mars 1986<sup id="cite_ref-34" class="reference"><a href="#cite_note-34"><span class="cite-reference-link-bracket">[</span>n 2<span class="cite-reference-link-bracket">]</span></a></sup></td>
<td style="text-align:center">4 oktober 1991</td>
<td style="background:#EE2020">&nbsp;</td>
<td style="text-align:center"><a href="/wiki/Socialdemokraterna_(Sverige)" title="Socialdemokraterna (Sverige)">Socialdemokraterna</a></td>
<td style="text-align:center"><a href="/wiki/Regeringen_Carlsson_I" title="Regeringen Carlsson I">Carlsson I</a>,<br>
<a href="/wiki/Regeringen_Carlsson_II" title="Regeringen Carlsson II">Carlsson II</a></td>
<td style="text-align:center"><sup id="cite_ref-regeringen.se_32-30" class="reference"><a href="#cite_note-regeringen.se-32"><span class="cite-reference-link-bracket">[</span>32<span class="cite-reference-link-bracket">]</span></a></sup></td>
</tr>
<tr>
<td>
<div style="position:relative;top:-{{{oTop}}}px;left:-{{{oLeft}}}px"><a href="https://commons.wikimedia.org/wiki/File:Carl_Bildt_2001-05-15.jpg" class="image"><img alt="Carl Bildt 2001-05-15.jpg" src="//upload.wikimedia.org/wikipedia/commons/thumb/6/6a/Carl_Bildt_2001-05-15.jpg/100px-Carl_Bildt_2001-05-15.jpg" width="100" height="139" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/6/6a/Carl_Bildt_2001-05-15.jpg/150px-Carl_Bildt_2001-05-15.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/6/6a/Carl_Bildt_2001-05-15.jpg/200px-Carl_Bildt_2001-05-15.jpg 2x" data-file-width="276" data-file-height="383" class="hoverZoomLink"></a></div>
</div>
</td>
<td style="text-align:center" data-sort-value="Bildt"><b><a href="/wiki/Carl_Bildt" title="Carl Bildt">Carl Bildt</a></b></td>
<td style="text-align:center">4 oktober 1991</td>
<td style="text-align:center">7 oktober 1994</td>
<td style="background:#1B49DD">&nbsp;</td>
<td style="text-align:center"><a href="/wiki/Moderaterna" title="Moderaterna">Moderaterna</a></td>
<td style="text-align:center"><a href="/wiki/Regeringen_Carl_Bildt" title="Regeringen Carl Bildt">C. Bildt</a></td>
<td style="text-align:center"><sup id="cite_ref-regeringen.se_32-31" class="reference"><a href="#cite_note-regeringen.se-32"><span class="cite-reference-link-bracket">[</span>32<span class="cite-reference-link-bracket">]</span></a></sup></td>
</tr>
<tr>
<td>
<div style="position:relative;top:-{{{oTop}}}px;left:-{{{oLeft}}}px"><a href="https://commons.wikimedia.org/wiki/File:Ingvar_Carlsson_p%C3%A5_Idrottsgalan_2013.jpg" class="image"><img alt="Ingvar Carlsson på Idrottsgalan 2013.jpg" src="//upload.wikimedia.org/wikipedia/commons/thumb/e/e4/Ingvar_Carlsson_p%C3%A5_Idrottsgalan_2013.jpg/100px-Ingvar_Carlsson_p%C3%A5_Idrottsgalan_2013.jpg" width="100" height="128" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/e/e4/Ingvar_Carlsson_p%C3%A5_Idrottsgalan_2013.jpg/150px-Ingvar_Carlsson_p%C3%A5_Idrottsgalan_2013.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/e/e4/Ingvar_Carlsson_p%C3%A5_Idrottsgalan_2013.jpg/200px-Ingvar_Carlsson_p%C3%A5_Idrottsgalan_2013.jpg 2x" data-file-width="1409" data-file-height="1797" class="hoverZoomLink"></a></div>
</div>
</td>
<td style="text-align:center" data-sort-value="Carlsson"><b><a href="/wiki/Ingvar_Carlsson" title="Ingvar Carlsson">Ingvar Carlsson</a></b></td>
<td style="text-align:center">7 oktober 1994</td>
<td style="text-align:center">22 mars 1996</td>
<td style="background:#EE2020">&nbsp;</td>
<td style="text-align:center"><a href="/wiki/Socialdemokraterna_(Sverige)" title="Socialdemokraterna (Sverige)">Socialdemokraterna</a></td>
<td style="text-align:center"><a href="/wiki/Regeringen_Carlsson_III" title="Regeringen Carlsson III">Carlsson III</a></td>
<td style="text-align:center"><sup id="cite_ref-regeringen.se_32-32" class="reference"><a href="#cite_note-regeringen.se-32"><span class="cite-reference-link-bracket">[</span>32<span class="cite-reference-link-bracket">]</span></a></sup></td>
</tr>
<tr>
<td>
<div style="position:relative;top:-{{{oTop}}}px;left:-{{{oLeft}}}px"><a href="https://commons.wikimedia.org/wiki/File:Goran_Persson,_Sveriges_statsminister,_under_nordiskt_statsministermotet_i_Reykjavik_2005.jpg" class="image"><img alt="Goran Persson, Sveriges statsminister, under nordiskt statsministermotet i Reykjavik 2005.jpg" src="//upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Goran_Persson%2C_Sveriges_statsminister%2C_under_nordiskt_statsministermotet_i_Reykjavik_2005.jpg/100px-Goran_Persson%2C_Sveriges_statsminister%2C_under_nordiskt_statsministermotet_i_Reykjavik_2005.jpg" width="100" height="150" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Goran_Persson%2C_Sveriges_statsminister%2C_under_nordiskt_statsministermotet_i_Reykjavik_2005.jpg/150px-Goran_Persson%2C_Sveriges_statsminister%2C_under_nordiskt_statsministermotet_i_Reykjavik_2005.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Goran_Persson%2C_Sveriges_statsminister%2C_under_nordiskt_statsministermotet_i_Reykjavik_2005.jpg/200px-Goran_Persson%2C_Sveriges_statsminister%2C_under_nordiskt_statsministermotet_i_Reykjavik_2005.jpg 2x" data-file-width="2336" data-file-height="3504" class="hoverZoomLink"></a></div>
</div>
</td>
<td style="text-align:center" data-sort-value="Persson"><b><a href="/wiki/G%C3%B6ran_Persson" title="Göran Persson">Göran Persson</a></b></td>
<td style="text-align:center">22 mars 1996</td>
<td style="text-align:center">6 oktober 2006</td>
<td style="background:#EE2020">&nbsp;</td>
<td style="text-align:center"><a href="/wiki/Socialdemokraterna_(Sverige)" title="Socialdemokraterna (Sverige)">Socialdemokraterna</a></td>
<td style="text-align:center"><a href="/wiki/Regeringen_Persson" title="Regeringen Persson">Persson</a></td>
<td style="text-align:center"><sup id="cite_ref-regeringen.se_32-33" class="reference"><a href="#cite_note-regeringen.se-32"><span class="cite-reference-link-bracket">[</span>32<span class="cite-reference-link-bracket">]</span></a></sup></td>
</tr>
<tr>
<td>
<div style="position:relative;top:-{{{oTop}}}px;left:-{{{oLeft}}}px"><a href="https://commons.wikimedia.org/wiki/File:Fredrik_Reinfeldt_12_Sept_2014.jpg" class="image"><img alt="Fredrik Reinfeldt 12 Sept 2014.jpg" src="//upload.wikimedia.org/wikipedia/commons/thumb/8/81/Fredrik_Reinfeldt_12_Sept_2014.jpg/100px-Fredrik_Reinfeldt_12_Sept_2014.jpg" width="100" height="139" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/8/81/Fredrik_Reinfeldt_12_Sept_2014.jpg/150px-Fredrik_Reinfeldt_12_Sept_2014.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/8/81/Fredrik_Reinfeldt_12_Sept_2014.jpg/200px-Fredrik_Reinfeldt_12_Sept_2014.jpg 2x" data-file-width="809" data-file-height="1122" class="hoverZoomLink"></a></div>
</div>
</td>
<td style="text-align:center" data-sort-value="Reinfeldt"><b><a href="/wiki/Fredrik_Reinfeldt" title="Fredrik Reinfeldt">Fredrik Reinfeldt</a></b></td>
<td style="text-align:center">6 oktober 2006</td>
<td style="text-align:center">3 oktober 2014</td>
<td style="background:#1B49DD">&nbsp;</td>
<td style="text-align:center"><a href="/wiki/Moderaterna" title="Moderaterna">Moderaterna</a></td>
<td style="text-align:center"><a href="/wiki/Regeringen_Reinfeldt" title="Regeringen Reinfeldt">Reinfeldt</a></td>
<td style="text-align:center"><sup id="cite_ref-regeringen.se_32-34" class="reference"><a href="#cite_note-regeringen.se-32"><span class="cite-reference-link-bracket">[</span>32<span class="cite-reference-link-bracket">]</span></a></sup></td>
</tr>
<tr>
<td>
<div style="position:relative;top:-{{{oTop}}}px;left:-{{{oLeft}}}px"><a href="https://commons.wikimedia.org/wiki/File:Stefan_L%C3%B6fven_edited_and_cropped.jpg" class="image"><img alt="Stefan Löfven edited and cropped.jpg" src="//upload.wikimedia.org/wikipedia/commons/thumb/5/59/Stefan_L%C3%B6fven_edited_and_cropped.jpg/100px-Stefan_L%C3%B6fven_edited_and_cropped.jpg" width="100" height="113" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/5/59/Stefan_L%C3%B6fven_edited_and_cropped.jpg/150px-Stefan_L%C3%B6fven_edited_and_cropped.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/5/59/Stefan_L%C3%B6fven_edited_and_cropped.jpg/200px-Stefan_L%C3%B6fven_edited_and_cropped.jpg 2x" data-file-width="1507" data-file-height="1704" class="hoverZoomLink"></a></div>
</div>
</td>
<td style="text-align:center" data-sort-value="Löfven"><b><a href="/wiki/Stefan_L%C3%B6fven" title="Stefan Löfven">Stefan Löfven</a></b></td>
<td style="text-align:center">3 oktober 2014</td>
<td style="text-align:center">nuvarande</td>
<td style="background:#EE2020">&nbsp;</td>
<td style="text-align:center"><a href="/wiki/Socialdemokraterna_(Sverige)" title="Socialdemokraterna (Sverige)">Socialdemokraterna</a></td>
<td style="text-align:center"><a href="/wiki/Regeringen_L%C3%B6fven" title="Regeringen Löfven">Löfven</a></td>
<td style="text-align:center"><sup id="cite_ref-35" class="reference"><a href="#cite_note-35"><span class="cite-reference-link-bracket">[</span>33<span class="cite-reference-link-bracket">]</span></a></sup></td>
</tr>
</tbody>

#################
# Add Users
#################
INSERT INTO user SET
  id=1,
  name='Simon Olander',
  profile_picture='/images/avatars/tiger.png';

INSERT INTO account SET
  id=1,
  user_id=1,
  email_address='simon.olander@r2m.se',
  password='password';
