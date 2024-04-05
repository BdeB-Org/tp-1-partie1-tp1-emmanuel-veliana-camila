-- TP1 fichier réponse -- Modifiez le nom du fichier en suivant les instructions
-- Votre nom: Emmanuel El-Agha             Votre DA: 2278542
--ASSUREZ VOUS DE LA BONNE LISIBILITÉ DE VOS REQUÊTES  /5--

-- 1.   Rédigez la requête qui affiche la description pour les trois tables. Le nom des champs et leur type. /2
DESC OUTILS_OUTIL;
DESC OUTILS_EMPRUNT;
DESC OUTILS_USAGER;

-- 2.   Rédigez la requête qui affiche la liste de tous les usagers, sous le format prénom « espace » nom de famille (indice : concaténation). /2
SELECT CONCAT(PRENOM, ' ', NOM_FAMILLE) AS "Nom complet"
FROM OUTILS_USAGER;

-- 3.   Rédigez la requête qui affiche le nom des villes où habitent les usagers, en ordre alphabétique, le nom des villes va apparaître seulement une seule fois. /2
SELECT DISTINCT VILLE AS "Nom des villes"
FROM OUTILS_USAGER
ORDER BY VILLE;

-- 4.   Rédigez la requête qui affiche toutes les informations sur tous les outils en ordre alphabétique sur le nom de l’outil puis sur le code. /2
--ORDRE SUR LE NOM DE L'OUTIL
SELECT  CODE_OUTIL AS "Numéro de code",
        NOM AS "Nom de l'outil",
        FABRICANT AS "Marque de fabricant",
        CARACTERISTIQUES AS "Caractéristiques",
        ANNEE AS "Année",
        PRIX AS "Prix de l'outil"
FROM OUTILS_OUTIL
ORDER BY NOM;

--ORDRE SUR LE CODE DE L'OUTIL
SELECT  CODE_OUTIL AS "Numéro de code",
        NOM AS "Nom de l'outil",
        FABRICANT AS "Marque de fabricant",
        CARACTERISTIQUES AS "Caractéristiques",
        ANNEE AS "Année",
        PRIX AS "Prix de l'outil"
FROM OUTILS_OUTIL
ORDER BY CODE_OUTIL;

-- 5.   Rédigez la requête qui affiche le numéro des emprunts qui n’ont pas été retournés. /2
SELECT NUM_EMPRUNT AS "Numéro d'emprunt"
FROM OUTILS_EMPRUNT
WHERE DATE_RETOUR IS NULL;

-- 6.   Rédigez la requête qui affiche le numéro des emprunts faits avant 2014./3
SELECT NUM_EMPRUNT AS "Numéro d'emprunt"
FROM OUTILS_EMPRUNT
WHERE EXTRACT(YEAR FROM DATE_EMPRUNT) < 2014;

-- 7.   Rédigez la requête qui affiche le nom et le code des outils dont la couleur début par la lettre « j » (indice : utiliser UPPER() et LIKE) /3
SELECT  NOM AS "Nom de l'outil",
        CODE_OUTIL AS "Code de l'outil"
FROM OUTILS_OUTIL
WHERE UPPER(CARACTERISTIQUES) LIKE '%J%';

-- 8.   Rédigez la requête qui affiche le nom et le code des outils fabriqués par Stanley. /2
SELECT  NOM AS "Nom de l'outil",
        CODE_OUTIL AS "Code de l'outil"
FROM OUTILS_OUTIL
WHERE UPPER(FABRICANT) = 'STANLEY';

-- 9.   Rédigez la requête qui affiche le nom et le fabricant des outils fabriqués de 2006 à 2008 (ANNEE). /2
SELECT  NOM AS "Nom de l'outil",
        FABRICANT AS "Nom du fabricant"
FROM OUTILS_OUTIL 
WHERE ANNEE BETWEEN 2006 AND 2008;

-- 10.  Rédigez la requête qui affiche le code et le nom des outils qui ne sont pas de « 20 volts ». /3
SELECT  CODE_OUTIL AS "Code de l'outil",
        NOM AS "Nom de l'outil"
FROM OUTILS_OUTIL
WHERE UPPER(CARACTERISTIQUES) NOT LIKE '%20 VOLT%';

-- 11.  Rédigez la requête qui affiche le nombre d’outils qui n’ont pas été fabriqués par Makita. /2
SELECT COUNT(*) AS "Nombre d'outils (autre que Makita)"
FROM OUTILS_OUTIL
WHERE FABRICANT NOT LIKE '%Makita%';

-- 12.  Rédigez la requête qui affiche les emprunts des clients de Vancouver et Regina. Il faut afficher le nom complet de l’usager, le numéro d’emprunt, la durée de l’emprunt et le prix de l’outil (indice : n’oubliez pas de traiter le NULL possible (dans les dates et le prix) et utilisez le IN). /5
SELECT  CONCAT(u.PRENOM, ' ', u.NOM_FAMILLE) AS "Nom complet de l'usager",
        e.NUM_EMPRUNT AS "Numéro d'emprunt",
        COALESCE(TO_CHAR(TO_DATE(e.DATE_RETOUR, 'DD-MM-YY') - (TO_DATE(e.DATE_EMPRUNT,'DD-MM-YY'))), 'Non retourné') AS "Durée de l'emprunt (jours)",
        COALESCE(o.PRIX, 0) AS "Prix des outils"
FROM OUTILS_USAGER u
JOIN OUTILS_EMPRUNT e
ON U.NUM_USAGER = e.NUM_USAGER
JOIN OUTILS_OUTIL o
ON e.CODE_OUTIL = o.CODE_OUTIL
WHERE u.VILLE IN ('Vancouver','Regina');

-- 13.  Rédigez la requête qui affiche le nom et le code des outils empruntés qui n’ont pas encore été retournés. /4
SELECT  o.NOM As "Nom de l'outil",
        o.CODE_OUTIL AS "Code de l'outil"
FROM OUTILS_OUTIL o
JOIN OUTILS_EMPRUNT e
ON o.CODE_OUTIL = e.CODE_OUTIL
WHERE e.DATE_RETOUR IS NULL;

-- 14.  Rédigez la requête qui affiche le nom et le courriel des usagers qui n’ont jamais fait d’emprunts. (indice : IN avec sous-requête) /3
SELECT  CONCAT(u.PRENOM, ' ', u.NOM_FAMILLE) AS "Nom complet de l'usager",
        u.COURRIEL AS "Courriel"
FROM OUTILS_USAGER u
WHERE u.NUM_USAGER NOT IN (
    SELECT e.NUM_USAGER 
    FROM OUTILS_EMPRUNT e
    );

-- 15.  Rédigez la requête qui affiche le code et la valeur des outils qui n’ont pas été empruntés. (indice : utiliser une jointure externe – LEFT OUTER, aucun NULL dans les nombres) /4
SELECT  o.CODE_OUTIL AS "Code outil",
        COALESCE(o.prix,0) AS "Prix"
FROM OUTILS_OUTIL o
LEFT OUTER JOIN OUTILS_EMPRUNT e
ON o.CODE_OUTIL = e.CODE_OUTIL
WHERE e.DATE_EMPRUNT IS NULL;

-- 16.  Rédigez la requête qui affiche la liste des outils (nom et prix) qui sont de marque Makita et dont le prix est supérieur à la moyenne des prix de tous les outils. Remplacer les valeurs absentes par la moyenne de tous les autres outils. /4
SELECT  o.NOM AS "Nom de l'objet",
        COALESCE(o.PRIX,0) AS "Prix"
FROM OUTILS_OUTIL o
INNER JOIN OUTILS_EMPRUNT e
ON o.CODE_OUTIL = e.CODE_OUTIL
WHERE o.PRIX > (SELECT AVG(o.prix) FROM OUTILS_OUTIL o)
AND o.FABRICANT = 'Makita';

-- 17.  Rédigez la requête qui affiche le nom, le prénom et l’adresse des usagers et le nom et le code des outils qu’ils ont empruntés après 2014. Triés par nom de famille. /4
SELECT  u.NOM_FAMILLE AS "Nom de famille",
        u.PRENOM AS "Prénom",
        u.ADRESSE AS "Adresse du client",
        o.NOM AS "Nom de l'outil",
        o.CODE_OUTIL AS "Code de l'outil"
FROM OUTILS_EMPRUNT e
JOIN OUTILS_USAGER u
ON e.NUM_USAGER = u.NUM_USAGER
JOIN OUTILS_OUTIL o
ON e.CODE_OUTIL = o.CODE_OUTIL
WHERE EXTRACT(YEAR FROM e.DATE_EMPRUNT) > 2014
ORDER BY u.NOM_FAMILLE;

-- 18.  Rédigez la requête qui affiche le nom et le prix des outils qui ont été empruntés plus qu’une fois. /4
SELECT  o.NOM AS "Nom de l'outil",
        COALESCE(o.PRIX,0) AS "Prix de l'outil"
FROM OUTILS_OUTIL o
JOIN OUTILS_EMPRUNT e
ON o.CODE_OUTIL = e.CODE_OUTIL
WHERE o.CODE_OUTIL IN (
    SELECT e.CODE_OUTIL
    FROM OUTILS_EMPRUNT e
    GROUP BY e.CODE_OUTIL
    HAVING COUNT(e.CODE_OUTIL) > 1
);

-- 19.  Rédigez la requête qui affiche le nom, l’adresse et la ville de tous les usagers qui ont fait des emprunts en utilisant : /6

--  Une jointure
SELECT  DISTINCT u.NOM_FAMILLE AS "Nom de famille",
        u.ADRESSE AS "Adresse",
        u.VILLE AS "Ville"
FROM OUTILS_USAGER u
JOIN OUTILS_EMPRUNT e
ON u.NUM_USAGER = e.NUM_USAGER;

--  IN
SELECT  DISTINCT u.NOM_FAMILLE AS "Nom de famille",
        u.ADRESSE AS "Adresse",
        u.VILLE AS "Ville"
FROM OUTILS_USAGER u
WHERE u.NUM_USAGER IN (
    SELECT e.NUM_USAGER
    FROM OUTILS_EMPRUNT e
);

--  EXISTS
SELECT  DISTINCT u.NOM_FAMILLE AS "Nom de famille",
        u.ADRESSE AS "Adresse",
        u.VILLE AS "Ville"
FROM OUTILS_USAGER u
WHERE EXISTS (
    SELECT e.NUM_USAGER
    FROM OUTILS_EMPRUNT e
    WHERE u.NUM_USAGER = e.NUM_USAGER
);

-- 20.  Rédigez la requête qui affiche la moyenne du prix des outils par marque. /3
SELECT  FABRICANT AS "Marque de l'outil",
        AVG(PRIX) AS "Moyenne du prix"
FROM OUTILS_OUTIL
GROUP BY FABRICANT; 

-- 21.  Rédigez la requête qui affiche la somme des prix des outils empruntés par ville, en ordre décroissant de valeur. /4
SELECT  u.VILLE AS "Ville",
        SUM(o.PRIX) AS "Somme des prix des outils empruntés"
FROM OUTILS_EMPRUNT e
JOIN OUTILS_USAGER u
ON e.NUM_USAGER = u.NUM_USAGER
JOIN OUTILS_OUTIL o
ON e.CODE_OUTIL = o.CODE_OUTIL
GROUP BY u.VILLE
ORDER BY SUM(o.prix) DESC;

-- 22.  Rédigez la requête pour insérer un nouvel outil en donnant une valeur pour chacun des attributs. /2
INSERT INTO OUTILS_OUTIL (CODE_OUTIL,NOM,FABRICANT,CARACTERISTIQUES,ANNEE,PRIX) 
VALUES ('NO321','Outil','Home depot','rouge, 25 volt, efficace','2024','450');

-- 23.  Rédigez la requête pour insérer un nouvel outil en indiquant seulement son nom, son code et son année. /2
INSERT INTO OUTILS_OUTIL (CODE_OUTIL,NOM,ANNEE) 
VALUES ('KJ456','Outil2','2024');

-- 24.  Rédigez la requête pour effacer les deux outils que vous venez d’insérer dans la table. /2
DELETE FROM OUTILS_OUTIL
WHERE NOM IN ('Outil','Outil2');

-- 25.  Rédigez la requête pour modifier le nom de famille des usagers afin qu’ils soient tous en majuscules. /2
UPDATE OUTILS_USAGER
SET NOM_FAMILLE = UPPER(NOM_FAMILLE);
