DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS teams;
DROP TABLE IF EXISTS teammemberships;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

CREATE TABLE teams (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

CREATE TABLE team_memberships (
  id INTEGER PRIMARY KEY,
  member_id INTEGER NOT NULL,
  team_id INTEGER NOT NULL,

  FOREIGN KEY(member_id) REFERENCES user(id),
  FOREIGN KEY(team_id) REFERENCES team(id)
);

INSERT INTO
  users (name)
VALUES
  ("Liam"),
  ("Justin"),
  ("Katie"),
  ("Bob");

INSERT INTO
  teams (name)
VALUES
  ("Team Awesome"),
  ("Fantastic Three"),
  ("Manchester United"),
  ("Miami Heat");

INSERT INTO
  team_memberships (member_id, team_id)
VALUES
  ((SELECT id FROM users where name = "Liam"),
  (SELECT id FROM teams where name = "Team Awesome")),

  ((SELECT id FROM users where name = "Liam"),
  (SELECT id FROM teams where name = "Fantastic Three")),

  ((SELECT id FROM users where name = "Justin"),
  (SELECT id FROM teams where name = "Team Awesome")),

  ((SELECT id FROM users where name = "Justin"),
  (SELECT id FROM teams where name = "Fantastic Three")),

  ((SELECT id FROM users where name = "Katie"),
  (SELECT id FROM teams where name = "Fantastic Three")),

  ((SELECT id FROM users where name = "Katie"),
  (SELECT id FROM teams where name = "Manchester United")),

  ((SELECT id FROM users where name = "Bob"),
  (SELECT id FROM teams where name = "Manchester United")),

  ((SELECT id FROM users where name = "Bob"),
  (SELECT id FROM teams where name = "Miami Heat"));
