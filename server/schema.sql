-- schema for the Moot game

DROP TABLE IF EXISTS gameuser cascade;
DROP TABLE IF EXISTS achievement cascade;
DROP TABLE IF EXISTS user_achievement cascade;

CREATE TABLE gameuser (
	user_id 	serial primary key,
	created_at	timestamp DEFAULT CURRENT_TIMESTAMP,
	username	varchar(80) UNIQUE NOT NULL,
	password	varchar(128) NOT NULL,
	avatar varchar(80) NOT NULL
);

CREATE TABLE achievement (
	achievement_id	serial primary key,
	name		varchar(80) NOT NULL,
	description	text NOT NULL
);

CREATE TABLE user_achievement (
	user_id	INTEGER references gameuser,
	achievement_id	INTEGER references achievement,
	created_at	timestamp
);

CREATE INDEX username ON gameuser(username);
