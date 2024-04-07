-- TP1 fichier réponse -- Modifiez le nom du fichier en suivant les instructions
-- Votre nom:                         Votre DA: 
             Maria Camila Gomez Reina          6226142
--ASSUREZ VOUS DE LA BONNE LISIBILITÉ DE VOS REQUÊTES  /5--

-- 1.   Rédigez la requête qui affiche la description pour les trois tables. Le nom des champs et leur type. /2
DESC OUTILS_OUTIL;
DESC OUTILS_EMPRUNT;
DESC OUTILS_USAGER;

-- 2.   Rédigez la requête qui affiche la liste de tous les usagers, sous le format prénom « espace » nom de famille (indice : concaténation). /2
SELECT CONCAT(PRENOM, ' ', NOM_FAMILLE) AS "NOM COMPLET"
FROM OUTILS_USAGER;

-- 3.   Rédigez la requête qui affiche le nom des villes où habitent les usagers, en ordre alphabétique, le nom des villes va apparaître seulement une seule fois. /2
SELECT VILLE AS "Ville"
FROM OUTILS_USAGER
GROUP BY VILLE
ORDER BY VILLE ASC;

-- 4.   Rédigez la requête qui affiche toutes les informations sur tous les outils en ordre alphabétique sur le nom de l’outil puis sur le code. /2
SELECT *
FROM OUTILS_OUTIL
ORDER BY NOM ASC, CODE_OUTIL ASC;

-- 5.   Rédigez la requête qui affiche le numéro des emprunts qui n’ont pas été retournés. /2
SELECT NUM_EMPRUNT AS "NUMERO EMPRUNT"
FROM OUTILS_EMPRUNT
WHERE DATE_RETOUR IS null;

-- 6.   Rédigez la requête qui affiche le numéro des emprunts faits avant 2014./3
SELECT NUM_EMPRUNT AS "Numero Emprunt" ,
TO_CHAR (DATE_EMPRUNT, 'YYYY-MM-DD') AS "Date emprunt"
FROM OUTILS_EMPRUNT
WHERE TO_CHAR(DATE_EMPRUNT, 'YYYY-MM-DD') < '2014-01-01';

-- 7.   Rédigez la requête qui affiche le nom et le code des outils dont la couleur début par la lettre « j » (indice : utiliser UPPER() et LIKE) /3
SELECT NOM AS "NOM", CODE_OUTIL AS "CODE",
UPPER(CARACTERISTIQUES)AS "CARACTERISTIQUES"
FROM OUTILS_OUTIL
WHERE CARACTERISTIQUES LIKE '%J';

-- 8.   Rédigez la requête qui affiche le nom et le code des outils fabriqués par Stanley. /2
SELECT NOM, CODE_OUTIL AS "CODE"
FROM OUTILS_OUTIL
WHERE FABRICANT = 'Stanley';

-- 9.   Rédigez la requête qui affiche le nom et le fabricant des outils fabriqués de 2006 à 2008 (ANNEE). /2
SELECT NOM, FABRICANT
FROM OUTILS_OUTIL
WHERE ANNEE BETWEEN 2006 AND 2008;

-- 10.  Rédigez la requête qui affiche le code et le nom des outils qui ne sont pas de « 20 volts ». /3
SELECT NOM, CODE_OUTIL AS "CODE"
FROM OUTILS_OUTIL
WHERE CARACTERISTIQUES NOT LIKE '%20 volt%';

-- 11.  Rédigez la requête qui affiche le nombre d’outils qui n’ont pas été fabriqués par Makita. /2
SELECT COUNT(*) AS "NB OUTILS NON CREES PAR MAKITA"
FROM OUTILS_OUTIL
WHERE FABRICANT != 'Makita';

-- 12.  Rédigez la requête qui affiche les emprunts des clients de Vancouver et Regina. Il faut afficher le nom complet de l’usager, le numéro d’emprunt, la durée de l’emprunt et le prix de l’outil (indice : n’oubliez pas de traiter le NULL possible (dans les dates et le prix) et utilisez le IN). /5
SELECT u.NUM_USAGER,
e.NUM_EMPRUNT,
ROUND(NVL(DATE_RETOUR,CURRENT_DATE)- DATE_EMPRUNT) AS "DUREE EMPRUNT",
o.PRIX
FROM OUTILS_OUTIL o
JOIN OUTILS_EMPRUNT e
ON o.CODE_OUTIL = e.CODE_OUTIL
JOIN OUTILS_USAGER u
ON u.NUM_USAGER=e.NUM_USAGER
WHERE u.VILLE IN ('Vancouver','Regina') AND prix IS NOT NULL;
-- 13.  Rédigez la requête qui affiche le nom et le code des outils empruntés qui n’ont pas encore été retournés. /4
SELECT o.NOM AS "NOM", o.CODE_OUTIL AS "CODE"
FROM OUTILS_EMPRUNT e
INNER JOIN OUTILS_OUTIL o
ON o.CODE_OUTIL = e.CODE_OUTIL
WHERE e.DATE_RETOUR IS NULL;

-- 14.  Rédigez la requête qui affiche le nom et le courriel des usagers qui n’ont jamais fait d’emprunts. (indice : IN avec sous-requête) /3
SELECT CONCAT(PRENOM, ' ', NOM_FAMILLE) AS "NOM COMPLET", COURRIEL
FROM OUTILS_USAGER
WHERE NUM_USAGER NOT IN (SELECT NUM_USAGER FROM OUTILS_EMPRUNT);


-- 15.  Rédigez la requête qui affiche le code et la valeur des outils qui n’ont pas été empruntés. (indice : utiliser une jointure externe – LEFT OUTER, aucun NULL dans les nombres) /4
SELECT o.CODE_OUTIL AS "CODE", o.PRIX
FROM OUTILS_OUTIL o
LEFT OUTER JOIN OUTILS_EMPRUNT e
ON o.CODE_OUTIL = e.CODE_OUTIL
WHERE e.CODE_OUTIL IS NULL
AND o.PRIX IS NOT NULL
AND o.CODE_OUTIL IS NOT NULL;

-- 16.  Rédigez la requête qui affiche la liste des outils (nom et prix) qui sont de marque Makita et dont le prix est supérieur à la moyenne des prix de tous les outils. Remplacer les valeurs absentes par la moyenne de tous les autres outils. /4
SELECT o.NOM AS "NOM"
COALESCE(o.PRIX,0)AS "PRIX"
FROM OUTILS_OUTIL o
INNER JOIN OUTILS_EMPRUNT e 
ON o.CODE_OUTIL=e.CODE_OUTIL
WHERE o.PRIX > (SELECT AVG(o.PRIX)FROM OUTILS_OUTIL o)
AND o.FABRICANT ='Makita'
-- 17.  Rédigez la requête qui affiche le nom, le prénom et l’adresse des usagers et le nom et le code des outils qu’ils ont empruntés après 2014. Triés par nom de famille. /4
SELECT CONCAT(u.PRENOM, ' ', u.NOM_FAMILLE) AS "NOM COMPLET" , u.ADRESSE, o.NOM, o.CODE_OUTIL
FROM OUTILS_USAGER u
JOIN OUTILS_EMPRUNT e ON u.NUM_USAGER = e.NUM_USAGER
JOIN OUTILS_OUTIL o ON e.CODE_OUTIL = o.CODE_OUTIL
WHERE e.DATE_EMPRUNT > '2014-01-01'
ORDER BY u.NOM_FAMILLE;


-- 18.  Rédigez la requête qui affiche le nom et le prix des outils qui ont été empruntés plus qu’une fois. /4
SELECT o.NOM, o.PRIX
FROM OUTILS_OUTIL o
JOIN OUTILS_EMPRUNT e ON o.CODE_OUTIL = e.CODE_OUTIL
GROUP BY o.NOM, o.PRIX
HAVING COUNT(e.CODE_OUTIL) > 1;

-- 19.  Rédigez la requête qui affiche le nom, l’adresse et la ville de tous les usagers qui ont fait des emprunts en utilisant : /6

--  Une jointure

--  IN

--  EXISTS
SELECT u.PRENOM,u.NOM_FAMILLE, u.ADRESSE, u.VILLE
FROM OUTILS_USAGER u
WHERE u.NUM_USAGER IN (
    SELECT e.NUM_USAGER
    FROM OUTILS_EMPRUNT e
)
AND EXISTS (
    SELECT 1
    FROM OUTILS_EMPRUNT e2
    WHERE e2.NUM_USAGER = u.NUM_USAGER
);

-- 20.  Rédigez la requête qui affiche la moyenne du prix des outils par marque. /3
SELECT FABRICANT AS "MARQUE", AVG(PRIX) AS "MOYENNE PRIX"
FROM OUTILS_OUTIL
GROUP BY FABRICANT;


-- 21.  Rédigez la requête qui affiche la somme des prix des outils empruntés par ville, en ordre décroissant de valeur. /4
SELECT u.VILLE, SUM(o.PRIX) AS "SOMME PRIX"
FROM OUTILS_USAGER u
JOIN OUTILS_EMPRUNT e ON u.NUM_USAGER = e.NUM_USAGER
JOIN OUTILS_OUTIL o ON e.CODE_OUTIL = o.CODE_OUTIL
GROUP BY u.VILLE
ORDER BY SUM(o.PRIX) DESC;

-- 22.  Rédigez la requête pour insérer un nouvel outil en donnant une valeur pour chacun des attributs. /2
INSERT INTO OUTILS_OUTIL (CODE_OUTIL, NOM, FABRICANT, CARACTERISTIQUES, ANNEE, PRIX)
VALUES ('CA1234', 'TELEPHONE', 'Camila', '100 wats, rouge, nouveau', '2024', '100');

-- 23.  Rédigez la requête pour insérer un nouvel outil en indiquant seulement son nom, son code et son année. /2
INSERT INTO OUTILS_OUTIL (CODE_OUTIL, NOM, ANNEE)
VALUES ('RI0704', 'elastique', '2023');

-- 24.  Rédigez la requête pour effacer les deux outils que vous venez d’insérer dans la table. /2
DELETE FROM OUTILS_OUTIL
WHERE (CODE_OUTIL) IN (('CA1234'), ('RI0704'));
-- 25.  Rédigez la requête pour modifier le nom de famille des usagers afin qu’ils soient tous en majuscules. /2
UPDATE OUTILS_USAGER
SET NOM_FAMILLE = UPPER(NOM_FAMILLE);
