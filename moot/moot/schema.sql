-- schema for the Moot game


DROP TABLE IF EXISTS gameuser cascade;
DROP TABLE IF EXISTS achievement cascade;
DROP TABLE IF EXISTS user_achievement cascade;
DROP TABLE IF EXISTS user_score cascade;
DROP TABLE IF EXISTS points_earned cascade;
DROP TABLE IF EXISTS scanned_product cascade;


CREATE TABLE gameuser (
	user_id 	varchar(80) primary key NOT NULL,
	created_at	timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE achievement (
	achievement_id	serial primary key,
	name		varchar(80) NOT NULL,
	description	text NOT NULL
);

CREATE TABLE user_achievement (
	user_id	varchar(80) references gameuser,
	achievement_id	INTEGER references achievement,
  type varchar(80),
	created_at	timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_score (
	user_id	varchar(80) UNIQUE references gameuser,
	score_value	INTEGER NOT NULL
);

CREATE TABLE points_earned (
	user_id varchar(80) references gameuser,
	score_value INTEGER NOT NULL,
	date timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE scanned_product (
  user_id varchar(80) REFERENCES gameuser,
  upc varchar(20) NOT NULL,
  product_name varchar(120) NOT NULL,
  color varchar(80),
  type varchar(80) NOT NULL,
  date timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX user_id ON gameuser(user_id);


INSERT INTO achievement (name, description) VALUES ('New Moot on the Block', 'Create a new Moot account');
INSERT INTO achievement (name, description) VALUES ('Savings Account', 'Accumulate 1000 Moot Points');
INSERT INTO achievement (name, description) VALUES ('Taste The Rainbow', 'Scan 8 different colored products');
INSERT INTO achievement (name, description) VALUES ('Easy as ABC', 'Scan products beginning with every letter of the alphabet');
INSERT INTO achievement (name, description) VALUES ('Overeager', 'Mess up the waiting level a lot');


