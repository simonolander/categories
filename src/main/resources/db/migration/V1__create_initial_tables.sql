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
  name VARCHAR(255) NOT NULL,
  category_id INT,
  extra_information VARCHAR(255),

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
  (367, 7, 'John Bardeen', 'Year 1972'),
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
  (398, 7, 'John Bardeen', 'Year 1956'),
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
  (259, 7, 'David Thouless'),
  (259, 7, 'Thouless'),
  (260, 7, 'Duncan Haldane'),
  (260, 7, 'Haldane'),
  (261, 7, 'Michael Kosterlitz'),
  (261, 7, 'Kosterlitz'),
  (262, 7, 'Takaaki Kajita'),
  (262, 7, 'Kajita'),
  (263, 7, 'Arthur McDonald'),
  (263, 7, 'McDonald'),
  (264, 7, 'Akasaki'),
  (265, 7, 'Amano'),
  (266, 7, 'Nakamura'),
  (267, 7, 'Englert'),
  (268, 7, 'Peter Higgs'),
  (268, 7, 'Higgs'),
  (269, 7, 'Haroche'),
  (270, 7, 'David Wineland'),
  (270, 7, 'Wineland'),
  (271, 7, 'Perlmutter'),
  (272, 7, 'Brian Schmidt'),
  (272, 7, 'Schmidt'),
  (273, 7, 'Adam Riess'),
  (273, 7, 'Riess'),
  (274, 7, 'Geim'),
  (275, 7, 'Novoselov'),
  (276, 7, 'Charles Kao'),
  (276, 7, 'Charles Kuen'),
  (276, 7, 'Kuen Kao'),
  (276, 7, 'Kuen'),
  (276, 7, 'Kao'),
  (277, 7, 'Willard Boyle'),
  (277, 7, 'Boyle'),
  (278, 7, 'George Smith'),
  (278, 7, 'Smith'),
  (279, 7, 'Nambu'),
  (280, 7, 'Kobayashi'),
  (281, 7, 'Maskawa'),
  (282, 7, 'Fert'),
  (283, 7, 'Grünberg'),
  (284, 7, 'John Mather'),
  (284, 7, 'Mather'),
  (285, 7, 'George Smoot'),
  (285, 7, 'Smoot'),
  (286, 7, 'Roy Glauber'),
  (286, 7, 'Glauber'),
  (287, 7, 'John Hall'),
  (287, 7, 'Hall'),
  (288, 7, 'Theodor Hänsch'),
  (288, 7, 'Hänsch'),
  (289, 7, 'David Gross'),
  (289, 7, 'Gross'),
  (290, 7, 'David Politzer'),
  (290, 7, 'Politzer'),
  (291, 7, 'Wilczek'),
  (292, 7, 'Alexei Abrikosov'),
  (292, 7, 'Abrikosov'),
  (293, 7, 'Vitaly Ginzburg'),
  (293, 7, 'Ginzburg'),
  (294, 7, 'Anthony Leggett'),
  (294, 7, 'Leggett'),
  (295, 7, 'Raymond Davis Jr'),
  (295, 7, 'Raymond Davis Junior'),
  (295, 7, 'Davis Jr'),
  (295, 7, 'Davis Junior'),
  (295, 7, 'Davis'),
  (296, 7, 'Koshiba'),
  (297, 7, 'Giacconi'),
  (298, 7, 'Eric Cornell'),
  (298, 7, 'Cornell'),
  (299, 7, 'Ketterle'),
  (300, 7, 'Carl Wieman'),
  (300, 7, 'Wieman'),
  (301, 7, 'Zhores Alferov'),
  (301, 7, 'Alferov'),
  (302, 7, 'Kroemer'),
  (303, 7, 'Jack Kilby'),
  (303, 7, 'Kilby'),
  (304, 7, 'Gerardus Hooft'),
  (304, 7, '\'t Hooft'),
  (304, 7, 't Hooft'),
  (304, 7, 'Hooft'),
  (305, 7, 'Martinus Veltman'),
  (305, 7, 'Veltman'),
  (306, 7, 'Robert Laughlin'),
  (306, 7, 'Laughlin'),
  (307, 7, 'Horst Störmer'),
  (307, 7, 'Störmer'),
  (308, 7, 'Daniel Tsui'),
  (308, 7, 'Tsui'),
  (309, 7, 'Chu'),
  (310, 7, 'Cohen-Tannoudji'),
  (310, 7, 'Tannoudji-Cohen'),
  (310, 7, 'Cohen Tannoudji'),
  (310, 7, 'Tannoudji Cohen'),
  (310, 7, 'Claude Cohen Tannoudji'),
  (310, 7, 'Claude Tannoudji Cohen'),
  (310, 7, 'Claude Tannoudji-Cohen'),
  (310, 7, 'Claude Cohen'),
  (310, 7, 'Cohen'),
  (310, 7, 'Claude Tannoudji'),
  (310, 7, 'Tannoudji Claude'),
  (310, 7, 'Tannoudji'),
  (311, 7, 'William Phillips'),
  (311, 7, 'Phillips'),
  (312, 7, 'David Lee'),
  (312, 7, 'Lee'),
  (313, 7, 'Douglas Osheroff'),
  (313, 7, 'Osheroff'),
  (314, 7, 'Robert Richardson'),
  (314, 7, 'Richardson'),
  (315, 7, 'Martin Perl'),
  (315, 7, 'Perl'),
  (316, 7, 'Reines'),
  (317, 7, 'Bertram Brockhouse'),
  (317, 7, 'Brockhouse'),
  (318, 7, 'Clifford Shull'),
  (318, 7, 'Shull'),
  (319, 7, 'Russell Hulse'),
  (319, 7, 'Hulse'),
  (320, 7, 'Joseph Taylor Jr.'),
  (320, 7, 'Joseph Taylor Jr'),
  (320, 7, 'Joseph Taylor Junior'),
  (320, 7, 'Joseph Taylor'),
  (320, 7, 'Taylor Jr.'),
  (320, 7, 'Taylor Jr'),
  (320, 7, 'Taylor Junior'),
  (320, 7, 'Taylor'),
  (321, 7, 'Charpak'),
  (322, 7, 'Pierre-Gilles Gennes'),
  (322, 7, 'Pierre Gilles de Gennes'),
  (322, 7, 'Pierre Gilles Gennes'),
  (322, 7, 'Pierre de Gennes'),
  (322, 7, 'Pierre Gennes'),
  (322, 7, 'Gilles de Gennes'),
  (322, 7, 'Gilles Gennes'),
  (322, 7, 'de Gennes'),
  (322, 7, 'Gennes'),
  (323, 7, 'Jerome Friedman'),
  (323, 7, 'Friedman'),
  (324, 7, 'Henry Kendall'),
  (324, 7, 'Kendall'),
  (325, 7, 'Richard Taylor'),
  (325, 7, 'Taylor'),
  (326, 7, 'Norman Ramsey'),
  (326, 7, 'Ramsey'),
  (327, 7, 'Hans Dehmelt'),
  (327, 7, 'Dehmelt'),
  (328, 7, 'Paul'),
  (329, 7, 'Leon Lederman'),
  (329, 7, 'Lederman'),
  (330, 7, 'Schwartz'),
  (331, 7, 'Steinberger'),
  (332, 7, 'Georg Bednorz'),
  (332, 7, 'Bednorz'),
  (333, 7, 'Alexander Müller'),
  (333, 7, 'Müller'),
  (334, 7, 'Ruska'),
  (335, 7, 'Binnig'),
  (336, 7, 'Rohrer'),
  (337, 7, 'Klaus Klitzing'),
  (337, 7, 'von Klitzing'),
  (337, 7, 'Klitzing'),
  (338, 7, 'Rubbia'),
  (339, 7, 'Simon van Meer'),
  (339, 7, 'Simon der Meer'),
  (339, 7, 'Simon Meer'),
  (339, 7, 'van der Meer'),
  (339, 7, 'van Meer'),
  (339, 7, 'der Meer'),
  (339, 7, 'Meer'),
  (340, 7, 'Chandrasekhar'),
  (341, 7, 'William Fowler'),
  (341, 7, 'Alfred Fowler'),
  (341, 7, 'Fowler'),
  (342, 7, 'Kenneth Wilson'),
  (343, 7, 'Bloembergen'),
  (344, 7, 'Arthur Schawlow'),
  (344, 7, 'Leonard Schawlow'),
  (344, 7, 'Schawlow'),
  (345, 7, 'Kai Siegbahn'),
  (345, 7, 'Siegbahn'),
  (346, 7, 'James Cronin'),
  (346, 7, 'Watson Cronin'),
  (346, 7, 'Cronin'),
  (347, 7, 'Val Fitch'),
  (347, 7, 'Logsdon Fitch'),
  (347, 7, 'Fitch'),
  (348, 7, 'Sheldon Glashow'),
  (348, 7, 'Lee Glashow'),
  (348, 7, 'Glashow'),
  (349, 7, 'Salam'),
  (350, 7, 'Weinberg'),
  (351, 7, 'Pyotr Kapitsa'),
  (351, 7, 'Leonidovich Kapitsa'),
  (351, 7, 'Kapitsa'),
  (352, 7, 'Arno Penzias'),
  (352, 7, 'Allan Penzias'),
  (352, 7, 'Penzias'),
  (353, 7, 'Robert Wilson'),
  (353, 7, 'Woodrow Wilson'),
  (353, 7, 'Wilson'),
  (354, 7, 'Philip Anderson'),
  (354, 7, 'Warren Anderson'),
  (354, 7, 'Anderson'),
  (355, 7, 'Sir Nevill Mott'),
  (355, 7, 'Sir Francis Mott'),
  (355, 7, 'Sir Mott'),
  (355, 7, 'Nevill Francis Mott'),
  (355, 7, 'Nevill Mott'),
  (355, 7, 'Francis Mott'),
  (355, 7, 'Mott'),
  (356, 7, 'John Hasbrouck Vleck'),
  (356, 7, 'John van Vleck'),
  (356, 7, 'John Vleck'),
  (356, 7, 'Hasbrouck van Vleck'),
  (356, 7, 'van Vleck'),
  (356, 7, 'Vleck'),
  (356, 7, 'Hasbrouck Vleck'),
  (357, 7, 'Richter'),
  (358, 7, 'Samuel Chao Chung Ting'),
  (358, 7, 'Chung Ting'),
  (358, 7, 'Chao Ting'),
  (358, 7, 'Samuel Ting'),
  (358, 7, 'Ting'),
  (358, 7, 'Samuel Chao Ting'),
  (358, 7, 'Samuel Chung Ting'),
  (358, 7, 'Chao Chung Ting'),
  (359, 7, 'Aage Bohr'),
  (359, 7, 'Niels Bohr'),
  (359, 7, 'Bohr'),
  (360, 7, 'Ben Mottelson'),
  (360, 7, 'Roy Mottelson'),
  (360, 7, 'Mottelson'),
  (361, 7, 'Leo Rainwater'),
  (361, 7, 'James Rainwater'),
  (361, 7, 'Rainwater'),
  (362, 7, 'Martin Ryle'),
  (362, 7, 'Sir Ryle'),
  (362, 7, 'Ryle'),
  (363, 7, 'Hewish'),
  (364, 7, 'Esaki'),
  (365, 7, 'Giaever'),
  (366, 7, 'Brian Josephson'),
  (366, 7, 'David Josephson'),
  (366, 7, 'Josephson'),
  (367, 7, 'Bardeen'),
  (368, 7, 'Leon Cooper'),
  (368, 7, 'Neil Cooper'),
  (368, 7, 'Cooper'),
  (369, 7, 'John Schrieffer'),
  (369, 7, 'Robert Schrieffer'),
  (369, 7, 'Schrieffer'),
  (370, 7, 'Gabor'),
  (371, 7, 'Hannes Alfvén'),
  (371, 7, 'Olof Alfvén'),
  (371, 7, 'Gösta Alfvén'),
  (371, 7, 'Alfvén'),
  (371, 7, 'Hannes Olof Alfvén'),
  (371, 7, 'Hannes Gösta Alfvén'),
  (371, 7, 'Olof Gösta Alfvén'),
  (372, 7, 'Louis Néel'),
  (372, 7, 'Eugène Néel'),
  (372, 7, 'Félix Néel'),
  (372, 7, 'Louis Eugène Néel'),
  (372, 7, 'Louis Félix Néel'),
  (372, 7, 'Eugène Félix Néel'),
  (372, 7, 'Néel'),
  (373, 7, 'Murray Gell Mann'),
  (373, 7, 'Gell-Mann'),
  (373, 7, 'Murray Gell'),
  (373, 7, 'Murray Mann'),
  (373, 7, 'Gell'),
  (373, 7, 'Mann'),
  (373, 7, 'Murray Mann'),
  (373, 7, 'Murray Gell'),
  (374, 7, 'Luis Alvarez'),
  (374, 7, 'Walter Alvarez'),
  (374, 7, 'Alvarez'),
  (375, 7, 'Hans Bethe'),
  (375, 7, 'Albrecht Bethe'),
  (375, 7, 'Bethe'),
  (376, 7, 'Kastler'),
  (377, 7, 'SinItiro Tomonaga'),
  (377, 7, 'Sin Itiro Tomonaga'),
  (377, 7, 'Tomonaga'),
  (378, 7, 'Schwinger'),
  (379, 7, 'Richard Feynman'),
  (379, 7, 'Feynman'),
  (380, 7, 'Charles Townes'),
  (380, 7, 'Hard Townes'),
  (380, 7, 'Townes'),
  (381, 7, 'Nicolay Basov'),
  (381, 7, 'Gennadiyevich Basov'),
  (381, 7, 'Basov'),
  (382, 7, 'Aleksandr Prokhorov'),
  (382, 7, 'Mikhailovich Prokhorov'),
  (382, 7, 'Prokhorov'),
  (383, 7, 'Paul Wigner'),
  (383, 7, 'Eugene Wigner'),
  (383, 7, 'Wigner'),
  (384, 7, 'Maria Mayer'),
  (384, 7, 'Goeppert Mayer'),
  (384, 7, 'Mayer'),
  (385, 7, 'Hans Jensen'),
  (385, 7, 'Jensen'),
  (386, 7, 'Lev Landau'),
  (386, 7, 'Davidovich Landau'),
  (386, 7, 'Landau'),
  (387, 7, 'Hofstadter'),
  (388, 7, 'Ludwig Mössbauer'),
  (388, 7, 'Rudolf Mössbauer'),
  (388, 7, 'Mössbauer'),
  (389, 7, 'Donald Glaser'),
  (389, 7, 'Arthur Glaser'),
  (389, 7, 'Glaser'),
  (390, 7, 'Emilio Segrè'),
  (390, 7, 'Gino Segrè'),
  (390, 7, 'Segrè'),
  (391, 7, 'Chamberlain'),
  (392, 7, 'Pavel Cherenkov'),
  (392, 7, 'Alekseyevich Cherenkov'),
  (392, 7, 'Cherenkov'),
  (393, 7, 'Ilja Mikhailovich Frank'),
  (393, 7, 'Il´ja Frank'),
  (393, 7, 'Ilja Frank'),
  (393, 7, 'Mikhailovich Frank'),
  (393, 7, 'Frank'),
  (394, 7, 'Igor Tamm'),
  (394, 7, 'Yevgenyevich Tamm'),
  (394, 7, 'Tamm'),
  (395, 7, 'Chen Yang'),
  (395, 7, 'Ning Yang'),
  (395, 7, 'Yang'),
  (396, 7, 'Tsung-Dao Lee'),
  (396, 7, 'Lee'),
  (397, 7, 'William Shockley'),
  (397, 7, 'Bradford Shockley'),
  (397, 7, 'Shockley'),
  (398, 7, 'Bardeen'),
  (399, 7, 'Houser Brattain'),
  (399, 7, 'Walter Brattain'),
  (399, 7, 'Brattain'),
  (400, 7, 'Willis Lamb'),
  (400, 7, 'Eugene Lamb'),
  (400, 7, 'Lamb'),
  (401, 7, 'Kusch'),
  (402, 7, 'Born'),
  (403, 7, 'Bothe'),
  (404, 7, 'Zernike'),
  (405, 7, 'Bloch'),
  (406, 7, 'Edward Purcell'),
  (406, 7, 'Mills Purcell'),
  (406, 7, 'Purcell'),
  (407, 7, 'Sir John Cockcroft'),
  (407, 7, 'Sir Douglas Cockcroft'),
  (407, 7, 'John Douglas Cockcroft'),
  (407, 7, 'Douglas Cockcroft'),
  (407, 7, 'Sir Cockcroft'),
  (407, 7, 'John Cockcroft'),
  (407, 7, 'Cockcroft'),
  (408, 7, 'Thomas Sinton Walton'),
  (408, 7, 'Ernest Sinton Walton'),
  (408, 7, 'Ernest Thomas Walton'),
  (408, 7, 'Sinton Walton'),
  (408, 7, 'Ernest Walton'),
  (408, 7, 'Thomas Walton'),
  (408, 7, 'Walton'),
  (409, 7, 'Cecil Powell'),
  (409, 7, 'Frank Powell'),
  (409, 7, 'Powell'),
  (410, 7, 'Yukawa'),
  (411, 7, 'Maynard Stuart Blackett'),
  (411, 7, 'Patrick Stuart Blackett'),
  (411, 7, 'Patrick Maynard Blackett'),
  (411, 7, 'Stuart Blackett'),
  (411, 7, 'Patrick Blackett'),
  (411, 7, 'Maynard Blackett'),
  (411, 7, 'Blackett'),
  (412, 7, 'Edward Victor Appleton'),
  (412, 7, 'Sir Victor Appleton'),
  (412, 7, 'Sir Edward Appleton'),
  (412, 7, 'Victor Appleton'),
  (412, 7, 'Sir Appleton'),
  (412, 7, 'Edward Appleton'),
  (412, 7, 'Appleton'),
  (413, 7, 'Percy Bridgman'),
  (413, 7, 'Williams Bridgman'),
  (413, 7, 'Bridgman'),
  (414, 7, 'Pauli'),
  (415, 7, 'Isidor Rabi'),
  (415, 7, 'Isaac Rabi'),
  (415, 7, 'Rabi'),
  (416, 7, 'Stern'),
  (417, 7, 'Ernest Lawrence'),
  (417, 7, 'Orlando Lawrence'),
  (417, 7, 'Lawrence'),
  (418, 7, 'Fermi'),
  (419, 7, 'Clinton Davisson'),
  (419, 7, 'Joseph Davisson'),
  (419, 7, 'Davisson'),
  (420, 7, 'George Thomson'),
  (420, 7, 'Paget Thomson'),
  (420, 7, 'Thomson'),
  (421, 7, 'Victor Hess'),
  (421, 7, 'Franz Hess'),
  (421, 7, 'Hess'),
  (422, 7, 'Carl Anderson'),
  (422, 7, 'David Anderson'),
  (422, 7, 'Anderson'),
  (423, 7, 'Chadwick'),
  (424, 7, 'Schrödinger'),
  (425, 7, 'Adrien Maurice Dirac'),
  (425, 7, 'Paul Maurice Dirac'),
  (425, 7, 'Paul Adrien Dirac'),
  (425, 7, 'Maurice Dirac'),
  (425, 7, 'Paul Dirac'),
  (425, 7, 'Adrien Dirac'),
  (425, 7, 'Dirac'),
  (426, 7, 'Werner Heisenberg'),
  (426, 7, 'Karl Heisenberg'),
  (426, 7, 'Heisenberg'),
  (427, 7, 'Chandrasekhara Venkata Raman'),
  (427, 7, 'Sir Venkata Raman'),
  (427, 7, 'Sir Chandrasekhara Raman'),
  (427, 7, 'Venkata Raman'),
  (427, 7, 'Sir Raman'),
  (427, 7, 'Chandrasekhara Raman'),
  (427, 7, 'Raman'),
  (428, 7, 'Louis-Victor Pierre Raymond de Broglie'),
  (428, 7, 'Louis Victor Pierre Raymond de Broglie'),
  (428, 7, 'Prince Pierre Raymond de Broglie'),
  (428, 7, 'Prince Louis-Victor Raymond de Broglie'),
  (428, 7, 'Prince Louis Victor Raymond de Broglie'),
  (428, 7, 'Prince Louis-Victor Pierre de Broglie'),
  (428, 7, 'Prince Louis Victor Pierre de Broglie'),
  (428, 7, 'Pierre Raymond de Broglie'),
  (428, 7, 'Prince Raymond de Broglie'),
  (428, 7, 'Prince Louis-Victor de Broglie'),
  (428, 7, 'Prince Louis Victor de Broglie'),
  (428, 7, 'Raymond de Broglie'),
  (428, 7, 'Prince de Broglie'),
  (428, 7, 'Louis-Victor de Broglie'),
  (428, 7, 'Louis Victor de Broglie'),
  (428, 7, 'Pierre de Broglie'),
  (428, 7, 'Prince de Broglie'),
  (428, 7, 'de Broglie'),
  (428, 7, 'Louis-Victor Pierre Raymond Broglie'),
  (428, 7, 'Louis Victor Pierre Raymond Broglie'),
  (428, 7, 'Prince Pierre Raymond Broglie'),
  (428, 7, 'Prince Louis-Victor Raymond Broglie'),
  (428, 7, 'Prince Louis Victor Raymond Broglie'),
  (428, 7, 'Prince Louis-Victor Pierre Broglie'),
  (428, 7, 'Prince Louis Victor Pierre Broglie'),
  (428, 7, 'Pierre Raymond Broglie'),
  (428, 7, 'Prince Raymond Broglie'),
  (428, 7, 'Prince Louis-Victor Broglie'),
  (428, 7, 'Prince Louis Victor Broglie'),
  (428, 7, 'Raymond Broglie'),
  (428, 7, 'Prince Broglie'),
  (428, 7, 'Louis-Victor Broglie'),
  (428, 7, 'Louis Victor Broglie'),
  (428, 7, 'Pierre Broglie'),
  (428, 7, 'Prince Broglie'),
  (428, 7, 'Broglie'),
  (429, 7, 'Owen Richardson'),
  (429, 7, 'Willans Richardson'),
  (429, 7, 'Richardson'),
  (430, 7, 'Arthur Compton'),
  (430, 7, 'Holly Compton'),
  (430, 7, 'Compton'),
  (431, 7, 'Thomson Rees Wilson'),
  (431, 7, 'Charles Rees Wilson'),
  (431, 7, 'Charles Thomson Wilson'),
  (431, 7, 'Rees Wilson'),
  (431, 7, 'Charles Wilson'),
  (431, 7, 'Thomson Wilson'),
  (431, 7, 'Wilson'),
  (432, 7, 'Jean Perrin'),
  (432, 7, 'Baptiste Perrin'),
  (432, 7, 'Perrin'),
  (433, 7, 'Franck'),
  (434, 7, 'Gustav Hertz'),
  (434, 7, 'Ludwig Hertz'),
  (434, 7, 'Hertz'),
  (435, 7, 'Manne Georg Siegbahn'),
  (435, 7, 'Karl Georg Siegbahn'),
  (435, 7, 'Karl Manne Siegbahn'),
  (435, 7, 'Georg Siegbahn'),
  (435, 7, 'Karl Siegbahn'),
  (435, 7, 'Manne Siegbahn'),
  (435, 7, 'Siegbahn'),
  (436, 7, 'Robert Millikan'),
  (436, 7, 'Andrews Millikan'),
  (436, 7, 'Millikan'),
  (437, 7, 'Henrik David Bohr'),
  (437, 7, 'Niels David Bohr'),
  (437, 7, 'Niels Henrik Bohr'),
  (437, 7, 'David Bohr'),
  (437, 7, 'Niels Bohr'),
  (437, 7, 'Henrik Bohr'),
  (437, 7, 'Bohr'),
  (438, 7, 'Einstein'),
  (439, 7, 'Charles Guillaume'),
  (439, 7, 'Edouard Guillaume'),
  (439, 7, 'Guillaume'),
  (440, 7, 'Stark'),
  (441, 7, 'Max Karl Ernst Ludwig Planck'),
  (441, 7, 'Max Planck'),
  (441, 7, 'Planck'),
  (442, 7, 'Charles Barkla'),
  (442, 7, 'Glover Barkla'),
  (442, 7, 'Barkla'),
  (443, 7, 'William Henry Bragg'),
  (443, 7, 'Sir Henry Bragg'),
  (443, 7, 'Sir William Bragg'),
  (443, 7, 'Henry Bragg'),
  (443, 7, 'Sir Bragg'),
  (443, 7, 'William Bragg'),
  (443, 7, 'Bragg'),
  (444, 7, 'William Bragg'),
  (444, 7, 'Lawrence Bragg'),
  (444, 7, 'Bragg'),
  (445, 7, 'Max Laue'),
  (445, 7, 'von Laue'),
  (445, 7, 'Laue'),
  (446, 7, 'Heike Onnes'),
  (446, 7, 'Kamerlingh Onnes'),
  (446, 7, 'Onnes'),
  (447, 7, 'Nils Dalén'),
  (447, 7, 'Gustaf Dalén'),
  (447, 7, 'Dalén'),
  (448, 7, 'Wien'),
  (449, 7, 'Johannes van der Waals'),
  (449, 7, 'Johannes van Waals'),
  (449, 7, 'Johannes der Waals'),
  (449, 7, 'Johannes Waals'),
  (449, 7, 'Diderik van der Waals'),
  (449, 7, 'Diderik van Waals'),
  (449, 7, 'Diderik der Waals'),
  (449, 7, 'Diderik Waals'),
  (449, 7, 'van der Waals'),
  (449, 7, 'van Waals'),
  (449, 7, 'der Waals'),
  (449, 7, 'Waals'),
  (450, 7, 'Marconi'),
  (451, 7, 'Karl Braun'),
  (451, 7, 'Ferdinand Braun'),
  (451, 7, 'Braun'),
  (452, 7, 'Lippmann'),
  (453, 7, 'Albert Michelson'),
  (453, 7, 'Abraham Michelson'),
  (453, 7, 'Michelson'),
  (454, 7, 'Joseph Thomson'),
  (454, 7, 'John Thomson'),
  (454, 7, 'Thomson'),
  (455, 7, 'Philipp von Lenard'),
  (455, 7, 'von Lenard'),
  (455, 7, 'Lenard'),
  (456, 7, 'Lord Rayleigh'),
  (456, 7, 'Rayleigh'),
  (456, 7, 'John Strutt'),
  (456, 7, 'William Strutt'),
  (456, 7, 'Strutt'),
  (457, 7, 'Antoine Becquerel'),
  (457, 7, 'Henri Becquerel'),
  (457, 7, 'Becquerel'),
  (458, 7, 'Curie'),
  (459, 7, 'Marie Curie'),
  (459, 7, 'Curie'),
  (459, 7, 'Marie Sklodowska'),
  (459, 7, 'Sklodowska'),
  (460, 7, 'Hendrik Lorentz'),
  (460, 7, 'Antoon Lorentz'),
  (460, 7, 'Lorentz'),
  (461, 7, 'Zeeman'),
  (462, 7, 'Wilhelm Röntgen'),
  (462, 7, 'Conrad Röntgen'),
  (462, 7, 'Röntgen');

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
