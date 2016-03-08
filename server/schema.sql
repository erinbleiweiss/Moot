-- schema for the Moot game


-- DROP TABLE IF EXISTS gameuser cascade;
DROP TABLE IF EXISTS achievement cascade;
-- DROP TABLE IF EXISTS user_achievement cascade;
-- DROP TABLE IF EXISTS user_score cascade;

CREATE TABLE gameuser (
	user_id 	serial primary key,
	created_at	timestamp DEFAULT CURRENT_TIMESTAMP,
	username	varchar(80) UNIQUE NOT NULL,
	password	varchar(128) NOT NULL,
	email varchar(80) NOT NULL
);

CREATE TABLE achievement (
	achievement_id	serial primary key,
	name		varchar(80) NOT NULL,
	description	text NOT NULL
);

CREATE TABLE user_achievement (
	user_id	INTEGER references gameuser,
	achievement_id	INTEGER references achievement,
  type varchar(80) NOT NULL,
	created_at	timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_score (
	user_id	INTEGER UNIQUE references gameuser,
	score_value	INTEGER NOT NULL
);

CREATE TABLE scanned_product (
  user_id INTEGER UNIQUE REFERENCES gameuser,
  upc varchar(20) NOT NULL,
  product_name varchar(120) NOT NULL,
  color varchar(80),
  type varchar(80) NOT NULL,
  created_at timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX username ON gameuser(username);


INSERT INTO achievement VALUES (1, 'New Moot on the Block', 'Create a new Moot account');
INSERT INTO achievement VALUES (2, 'Savings Account', 'Accumulate 1000 Moot Points');
INSERT INTO achievement VALUES (3, 'Taste The Rainbow', 'Scan 7 different colored products');
INSERT INTO achievement VALUES (4, 'Easy as ABC', 'Scan products beginning with every letter of the alphabet');
INSERT INTO achievement VALUES (5, 'Overeager', 'Fuck up the waiting level a lot');
INSERT INTO achievement VALUES (6, 'Write Your Name', 'Scan all the letters of your username');
INSERT INTO achievement VALUES (6, 'Spell a color', 'Scan all the letters of your username');
