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
