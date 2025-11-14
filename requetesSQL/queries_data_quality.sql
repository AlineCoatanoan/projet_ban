-- Détection de problèmes et qualité des données 

-- Identifier doublons exacts (mêmes numéro + nom de voie + code postal + commune).
SELECT a.numero,
       v.nom_voie,
       c.code_postal,
       c.nom_commune,
       COUNT(*) AS nb_occurrences
FROM adresse a
JOIN voie v ON a.id_fantoir = v.id_fantoir
JOIN commune c ON v.code_insee = c.code_insee
GROUP BY a.numero, v.nom_voie, c.code_postal, c.nom_commune
HAVING COUNT(*) > 1
ORDER BY nb_occurrences DESC;

-- On sélectionne les colonnes de la table adresse, de voie et de commune.
-- COUNT(*) permet de compter le nombre de lignes pour chaque groupe défini après GROUP BY
-- AS nb_occurrences est l'alias. 
-- HAVING filtre les groupes 
-- COUNT(*) > 1 : repère les groupes qui ont plus d'1 occurence et donc les doublons.

-------------------------------------------------------------------------------------------------------------------------------

-- Identifier les adresses incohérentes : dehors du département 30.
SELECT nom_commune, code_postal
FROM commune
WHERE LEFT(code_postal, 2) != '30';

-- LEFT 2 : prend les 2 premiers caractères du code postal. 
-- != différent de 30 (Gard) --> là ça ressort uniquement la commune kaamelott que j'ai créé avec un code postal 39999

-------------------------------------------------------------------------------------------------------------------------------

-- Lister les codes postaux avec plus de 10 000 adresses pour détecter les anomalies volumétriques.
SELECT c.code_postal,
       c.nom_commune,
       COUNT(*) AS nb_adresses
FROM adresse a
JOIN voie v ON a.id_fantoir = v.id_fantoir
JOIN commune c ON v.code_insee = c.code_insee
GROUP BY c.code_postal, c.nom_commune
HAVING COUNT(*) > 10000
ORDER BY nb_adresses DESC;