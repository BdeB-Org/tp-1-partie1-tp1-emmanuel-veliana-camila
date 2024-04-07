-- TP1 fichier réponse -- Modifiez le nom du fichier en suivant les instructions
-- Votre nom:    Vrliana Miteva             Votre DA:  2374935
--ASSUREZ VOUS DE LA BONNE LISIBILITÉ DE VOS REQUÊTES  /5--

-- 1.   Rédigez la requête qui affiche la description pour les trois tables. Le nom des champs et leur type. /2
DESC OUTILS_OUTIL
DESC outils_usager
DESC outils_emprunt;

-- 2.   Rédigez la requête qui affiche la liste de tous les usagers, sous le format prénom « espace » nom de famille (indice : concaténation). /2
SELECT CONCAT(nom_famille, ', ', prenom) AS "Nom et Prenom"
FROM outils_usager;

-- 3.   Rédigez la requête qui affiche le nom des villes où habitent les usagers, en ordre alphabétique, le nom des villes va apparaître seulement une seule fois. /2
SELECT ville AS Ville
FROM outils_usager
GROUP BY ville 
ORDER BY ville ASC;

-- 4.   Rédigez la requête qui affiche toutes les informations sur tous les outils en ordre alphabétique sur le nom de l’outil puis sur le code. /2
SELECT nom AS nom,
       code_outil AS code,
       fabricant AS fabriquant,
       caracteristiques AS car,
       annee AS annee,
       prix AS prix
FROM outils_outil
ORDER BY nom, code_outil ASC;

-- 5.   Rédigez la requête qui affiche le numéro des emprunts qui n’ont pas été retournés. /2
SELECT num_emprunt AS "num emprun",
       date_retour AS "date retour"
FROM outils_emprunt
WHERE date_retour IS null;
-- 6.   Rédigez la requête qui affiche le numéro des emprunts faits avant 2014./3
SELECT num_emprunt AS "num emprun",
       EXTRACT(YEAR FROM date_emprunt) AS "date emprunt"
FROM outils_emprunt
WHERE EXTRACT(YEAR FROM date_emprunt)< 2014;

-- 7.   Rédigez la requête qui affiche le nom et le code des outils dont la couleur début par la lettre « j » (indice : utiliser UPPER() et LIKE) /3
SELECT nom AS nom,
       code_outil as code,
       caracteristiques AS car
FROM outils_outil
WHERE UPPER(caracteristiques) LIKE '%J%';
-- 8.   Rédigez la requête qui affiche le nom et le code des outils fabriqués par Stanley. /2
SELECT nom AS nom,
       code_outil as code,
       fabricant AS fabriquant
FROM outils_outil
WHERE fabricant IN('Stanley');
-- 9.   Rédigez la requête qui affiche le nom et le fabricant des outils fabriqués de 2006 à 2008 (ANNEE). /2
SELECT nom AS nom,
       fabricant AS fabriquant,
       annee AS annee
FROM outils_outil
WHERE annee BETWEEN 2006 AND 2008;
-- 10.  Rédigez la requête qui affiche le code et le nom des outils qui ne sont pas de « 20 volts ». /3
SELECT nom AS nom,
       code_outil as code,
       caracteristiques AS car
FROM outils_outil
WHERE caracteristiques NOT IN(SELECT caracteristiques FROM outils_outil WHERE caracteristiques LIKE '%20 volt%');
-- 11.  Rédigez la requête qui affiche le nombre d’outils qui n’ont pas été fabriqués par Makita. /2
--SELECT nom AS nom,
       -- code_outil as code,
        --fabricant AS fabriquant
--FROM outils_outil
--WHERE fabricant NOT IN(SELECT fabricant FROM outils_outil WHERE fabricant LIKE '%Makita%');
SELECT nom AS nom,
       code_outil AS code,
       fabricant AS fabriquant,
       (SELECT COUNT(*) FROM outils_outil) AS "nombre outils"
FROM outils_outil
WHERE fabricant NOT IN (SELECT fabricant FROM outils_outil WHERE fabricant LIKE '%Makita%');

-- 12.  Rédigez la requête qui affiche les emprunts des clients de Vancouver et Regina. Il faut afficher le nom complet de l’usager, le numéro d’emprunt, la durée de l’emprunt et le prix de l’outil (indice : n’oubliez pas de traiter le NULL possible (dans les dates et le prix) et utilisez le IN). /5
SELECT CONCAT(u.nom_famille, ', ', u.prenom) AS "Nom et Prenom",
       COALESC(o.prix,0) AS "prix outils",
           COALESCE(EXTRACT(YEAR_MONTH FROM date_emprunt)- (EXTRACT(YEAR_MONTH FROM date_retour)))  AS "date emprunt",
           e.num_emprunt AS "Num demprunt"      
FROM outils_usager u
JOIN outils_emprunt e
ON u.num_usager = e.num_usager
JOIN outils_outil o
ON o.code_outil = e.code_outil
WHERE ville IN('Vancouver','Regina');

-- 13.  Rédigez la requête qui affiche le nom et le code des outils empruntés qui n’ont pas encore été retournés. /4
SELECT 
       TO_CHAR(e.date_emprunt, 'yyyy-mm-dd') AS "date emprunt",
       TO_CHAR(e.date_retour, 'yyyy-mm-dd') AS "date retour",
       o.nom AS "nom outil",
       o.code_outil AS code
FROM outils_outil o
JOIN outils_emprunt e
ON o.code_outil = e.code_outil
WHERE e.date_retour IS NULL ;

-- 14.  Rédigez la requête qui affiche le nom et le courriel des usagers qui n’ont jamais fait d’emprunts. (indice : IN avec sous-requête) /3
SELECT CONCAT(u.nom_famille, ', ', u.prenom) AS "Nom et Prenom",
       u.courriel AS courriel,
       e.num_usager as "id usager"
FROM outils_usager u
JOIN outils_emprunt e
ON u.num_usager=e.num_usager
WHERE  u.num_usager  NOT IN(SELECT e.num_usager FROM outils_emprunt);

-- 15.  Rédigez la requête qui affiche le code et la valeur des outils qui n’ont pas été empruntés. (indice : utiliser une jointure externe – LEFT OUTER, aucun NULL dans les nombres) /4
SELECT o.code_outil AS code,
       COALESCe(o.prix,0) AS prix
FROM outils_outil o
LEFT OUTER JOIN outils_emprunt e
ON o.code_outil=e.code_outil
WHERE e.DATE_EMPRUNT IS NULL;

-- 16.  Rédigez la requête qui affiche la liste des outils (nom et prix) qui sont de marque Makita et dont le prix est supérieur à la moyenne des prix de tous les outils. Remplacer les valeurs absentes par la moyenne de tous les autres outils. /4

SELECT o.nom AS Nom,
    round(COALESCE(SELECT AVG(o.prix,0) FROM outils_outil)) AS Prix,
    o.fabricant AS marque
FROM outils_outil 
INNER JOIN outils_emprunt e
ON o.code_outil=e.code_outil
WHERE o.fabricant = 'Makita'
  AND (prix > (SELECT AVG(o.prix) FROM outils_outil));
  
-- 17.  Rédigez la requête qui affiche le nom, le prénom et l’adresse des usagers et le nom et le code des outils qu’ils ont empruntés après 2014. Triés par nom de famille. /4
SELECT u.nom_famille AS nom,
       u.prenom AS prenom,
       u.adresse AS couriel,
       u.num_usager AS "id pers",
       o.nom AS "nom outil",
       o.code_outil AS "id outils",
       EXTRACT( YEAR FROM e.date_emprunt) AS "date emprunt"
FROM  outils_emprunt e
JOIN  outils_outil o
ON  o.code_outil=e.code_outil
JOIN outils_usager u
ON u.num_usager=e.num_usager
WHERE o.code_outil IN(SELECT o.code_outil FROM outils_outil WHERE  EXTRACT( YEAR FROM e.date_emprunt)>2014)
ORDER BY nom_famille ASC;

-- 18.  Rédigez la requête qui affiche le nom et le prix des outils qui ont été empruntés plus qu’une fois. /4
SELECT nom AS Nom,
       COALESCE(prix,0) AS Prix
FROM outils_outil
WHERE code_outil IN ( SELECT code_outil FROM outils_emprunt GROUP BY code_outil
HAVING COUNT(DISTINCT num_emprunt) > 1);

-- 19.  Rédigez la requête qui affiche le nom, l’adresse et la ville de tous les usagers qui ont fait des emprunts en utilisant : /6
--  Une jointure
SELECT  u.nom_famille AS Nom,
        u.adresse AS Adresse,
         u.ville AS Ville
FROM outils_usager u
JOIN outils_emprunt e
ON u.num_usager=e.num_usager;
--  IN
SELECT
    u.nom_famille AS Nom,
    u.adresse AS Adresse,
    u.ville AS Ville
FROM outils_usager u
WHERE u.num_usager IN (
    SELECT u.num_usager
    FROM outils_emprunt e
    WHERE e.num_usager = u.num_usager );

--  EXISTS
SELECT
    u.nom_famille AS Nom,
    u.adresse AS Adresse,
    u.ville AS Ville
FROM outils_usager u
WHERE EXISTS (
    SELECT e.num_usager
    FROM outils_emprunt e
    WHERE e.num_usager = u.num_usager );

-- 20.  Rédigez la requête qui affiche la moyenne du prix des outils par marque. /3
SELECT
    fabricant AS Marque,
    AVG(prix) AS "Moyenne prix"
FROM outils_outil
GROUP BY fabricant;

-- 21.  Rédigez la requête qui affiche la somme des prix des outils empruntés par ville, en ordre décroissant de valeur. /4
SELECT u.ville AS "Ville",
       SUM(o.prix) AS "Somme des prix"
FROM outils_usager u
JOIN outils_emprunt e 
ON u.num_usager = e.num_usager
JOIN outils_outil o 
ON e.code_outil = o.code_outil
GROUP BY u.ville
ORDER BY SUM(o.prix) DESC;

-- 22.  Rédigez la requête pour insérer un nouvel outil en donnant une valeur pour chacun des attributs. /2
INSERT INTO outils_outil (code_outil, nom, fabricant,caracteristiques,annee, prix)
VALUES ('LP438','Marteau','Dewalt','long',2005,60);

-- 23.  Rédigez la requête pour insérer un nouvel outil en indiquant seulement son nom, son code et son année. /2
INSERT INTO outils_outil (code_outil, nom, annee)
VALUES ('LD970','Vis',1965);
-- 24.  Rédigez la requête pour effacer les deux outils que vous venez d’insérer dans la table. /2
DELETE FROM outils_outil 
WHERE code_outil IN('LD970','LP438');
-- 25.  Rédigez la requête pour modifier le nom de famille des usagers afin qu’ils soient tous en majuscules. /2
UPDATE outils_usager
SET nom_famille=UPPER(nom_famille);

SELECT *
FROM outils_usager;
