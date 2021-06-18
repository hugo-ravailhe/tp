SELECT DATABASE();

TRUNCATE TABLE Equipe;
TRUNCATE TABLE Player;
TRUNCATE TABLE Valheim;
TRUNCATE TABLE Geo;


/*Equipe*/
CREATE TABLE IF NOT EXISTS Equipe (ID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, NameEquipe varchar(255), PouleNbr int);

INSERT INTO Equipe (NameEquipe, PouleNbr) 
VALUES
("Team PAX", 1), ("FC Futulu", 1), ("KEK", 2),("Les SSL", 2), 
("Temp Team", 2),("Random team", 1), ("Nice Team", 2);

SELECT NameEquipe FROM Equipe;

SELECT NameEquipe FROM Equipe WHERE PouleNbr = 1 ;

DELETE FROM Equipe WHERE NameEquipe = "Temp Team";


/*Joueur*/
CREATE TABLE IF NOT EXISTS Player (ID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, Pseudo VARCHAR(255), Inscription DATETIME, Streamer BOOL,NameEquipe varchar(255));

INSERT INTO Player (Pseudo, Inscription, Streamer, NameEquipe) 
VALUES
("Sardoche","2021-04-21 23:59:42",TRUE, "FC Futulu"),
("Tititatutu","2021-04-18 07:24:36",TRUE, "FC Futulu"),
("Nykho","2021-04-18 13:25:23",TRUE, "FC Futulu"),
("Domingo","2021-04-17 15:25:39",TRUE, "Team PAX"),
("Jiraya","2021-04-17 12:25:42",TRUE, "Team PAX"),
("Xari","2021-04-17 18:25:13",TRUE, "Team PAX"),
("Khalen","2021-04-18 20:25",TRUE, "KEK"),
("Etoiles","2021-04-18 13:25:28",TRUE, "KEK"),
("KennyStream","2021-04-17 17:25:35",TRUE, "KEK"),
("Slide","2021-04-18 16:25:12",TRUE, "Les SSL"),
("Leaf","2021-04-18 14:25:52",TRUE, "Les SSL"),
("Skyyart","2021-04-18 21:43:17",TRUE, "Les SSL"),
("RandomPlayer","2021-04-18 20:25:42",FALSE, "Random team"),
("StrangerPLayer","2021-04-18 13:25:28",FALSE, "Random team"),
("UnrealPlayer","2021-04-17 17:25:35",FALSE, "Random team"),
("NicePlayer","2021-04-18 16:25:12",FALSE, "Nice Team"),
("FamousPLayer","2021-04-18 14:25:52",TRUE, "Nice Team"),
("StrongPlayer","2021-04-18 21:43:17",FALSE, "Nice Team");

UPDATE Equipe SET NameEquipe = "Titatitutu" WHERE NameEquipe = "Tititatutu";

SELECT COUNT(Pseudo) FROM Player WHERE Streamer = TRUE;

SELECT * FROM Player ORDER BY Inscription;

SELECT Pseudo, NameEquipe FROM  Player ORDER BY Inscription;

SELECT * FROM Player WHERE NameEquipe = "Nice Team";


/*Valheim*/
CREATE TABLE IF NOT EXISTS Valheim (ID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, NameEquipe varchar(255), Temps int);

INSERT INTO Valheim (NameEquipe, Temps) 
VALUES
("Team PAX", 7321),
("FC Futulu", 3797),
("KEK", 4324),
("Les SSL", 3632),
("Random team", 6456),
("Nice Team", 5932);

SELECT Temps, NameEquipe, 
RANK() OVER (ORDER BY Temps ASC) AS Rank 
FROM Valheim;

WITH val1 AS(
	SELECT v.Temps, v.NameEquipe
	FROM Valheim v
	INNER JOIN Equipe e
	on v.NameEquipe = e.NameEquipe
	WHERE PouleNbr = 1
)
SELECT val1.Temps, val1.NameEquipe,
RANK() OVER (ORDER BY val1.Temps ASC) AS Rank
FROM val1;


/*GeoGuessr*/
CREATE TABLE IF NOT EXISTS Geo (ID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, NameEquipe varchar(255), Score1 int, Score2 int, Score3 int);

INSERT INTO Geo (NameEquipe, Score1, Score2, Score3) 
VALUES
("Team PAX", 19812, 17675, 17126),
("FC Futulu", 22641, 17824, 19120),
("KEK", 24860, 25000, 24860),
("Les SSL", 23998, 20056, 18962),
("Random team", 15891, 18774, 13410),
("Nice Team", 14297, 19688, 16817);

SELECT NameEquipe, score1 + score2 + score3 FROM Geo;

WITH geo AS(
	SELECT v.NameEquipe, e.PouleNbr, score1 + score2 + score3 as summ
	FROM Geo v
	INNER JOIN Equipe e
	on v.NameEquipe = e.NameEquipe
)
SELECT NameEquipe, PouleNbr, summ,
RANK() OVER (PARTITION BY PouleNbr ORDER BY summ DESC)
FROM geo;


/*Battlerite Royale*/
CREATE TABLE IF NOT EXISTS Battle (ID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, Pseudo varchar(255), Score int);

INSERT INTO Battle (Pseudo, Score) 
VALUES
("Sardoche",270),
("Tititatutu",190),
("Nykho",150),
("Domingo",120),
("Jiraya",180),
("Xari",220),
("Khalen",190),
("Etoiles",210),
("KennyStream",250),
("Slide",240),
("Leaf",200),
("Skyyart",210),
("RandomPlayer",170),
("StrangerPLayer",80),
("UnrealPlayer",180),
("NicePlayer",180),
("FamousPLayer",130),
("StrongPlayer",130);

SELECT p.NameEquipe, sum(score) AS total,
RANK() over (order by total DESC ) AS Rank
FROM Battle b
INNER JOIN Player p
    ON b.Pseudo = p.Pseudo 
INNER JOIN Equipe e
    ON p.NameEquipe = e.NameEquipe
    GROUP BY NameEquipe
    ORDER BY RANK;

SELECT p.NameEquipe, PouleNbr, sum(score) AS total,
ROW_NUMBER() OVER (PARTITION by PouleNbr ORDER BY total desc) AS Rank
FROM Battle b
INNER JOIN Player p
    ON b.Pseudo = p.Pseudo 
INNER JOIN Equipe e
    ON p.NameEquipe = e.NameEquipe
    GROUP BY NameEquipe
ORDER BY PouleNbr ASC, Rank;

