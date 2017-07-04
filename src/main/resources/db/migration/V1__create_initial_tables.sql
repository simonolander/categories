SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS category;
DROP TABLE IF EXISTS category_item;
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

CREATE TABLE user (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL DEFAULT 'Anonymous',
  created_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE account (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL REFERENCES user(id),
  email_address VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  created_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
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
  name='Letters in the Alphabet';

INSERT INTO category_item (name, category_id) VALUES
  ('A', 1),
  ('B', 1),
  ('C', 1),
  ('D', 1),
  ('E', 1),
  ('F', 1),
  ('G', 1),
  ('H', 1),
  ('I', 1),
  ('J', 1),
  ('K', 1),
  ('L', 1),
  ('M', 1),
  ('N', 1),
  ('O', 1),
  ('P', 1),
  ('Q', 1),
  ('R', 1),
  ('S', 1),
  ('T', 1),
  ('U', 1),
  ('V', 1),
  ('W', 1),
  ('X', 1),
  ('Y', 1),
  ('Z', 1),
  ('Å', 1),
  ('Ä', 1),
  ('Ö', 1);

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
