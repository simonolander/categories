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
  name VARCHAR(255) NOT NULL DEFAULT 'Anonymous'
);

CREATE TABLE game (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255),
  category_id INT NOT NULL,

  FOREIGN KEY fk_category_id (category_id) REFERENCES category(id)
);

CREATE TABLE participant (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  game_id INT NOT NULL,
  admin BOOL NOT NULL,

  UNIQUE KEY uniq__user_id__game_id (user_id, game_id),
  FOREIGN KEY fk_user_id (user_id) REFERENCES user(id),
  FOREIGN KEY fk_game_id (game_id) REFERENCES game(id)
);

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

