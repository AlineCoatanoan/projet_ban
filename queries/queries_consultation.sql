-- Lister toutes les adresses d’une commune donnée, triées par numéro de voie.
SELECT a.numero,
       a.rep,
       v.nom_voie,
       c.nom_commune,
       c.code_postal
FROM adresse a
JOIN voie v ON a.id_fantoir = v.id_fantoir
JOIN commune c ON v.code_insee = c.code_insee
WHERE c.nom_commune ILIKE 'brignon'
ORDER BY v.nom_voie, a.numero;

-- On SELECTIONNE les colonnes nécessaires, on met des alias (a., v. ...), ce qui permet de rendre plus visible les requêtes.
-- dans les tables adresse, voie, commune 
-- WHERE filtre les résultats, là on veut "Brignon" ILIKE rend insensible à la casse
-- ORDER BY trie les résultats par nom de voie et numéro.

----------------------------------------------------------------------------------------------------------------------------------

-- Compter le nombre d’adresses par commune.
SELECT c.nom_commune,
       COUNT(a.id) AS nombre_adresses
FROM adresse a
JOIN voie v ON a.id_fantoir = v.id_fantoir
JOIN commune c ON v.code_insee = c.code_insee
GROUP BY c.nom_commune
ORDER BY c.nom_commune;

-- SELECT choisi les colonnes qu’on veut afficher.
-- COUNT(a.id) compte le nombre d’adresses par commune.
-- JOIN sert à relier les tables pour obtenir les infos.
-- GROUP BY regroupe par commune.
-- ORDER BY trie le résultat par ordre alphabétique de commune.

----------------------------------------------------------------------------------------------------------------------------------

-- Lister toutes les communes distinctes présentes dans le fichier.
SELECT DISTINCT nom_commune, code_insee, code_postal
FROM commune
ORDER BY nom_commune;

-- On selectionne les noms des communes, on met DICTINST pour éviter les doublons. 

----------------------------------------------------------------------------------------------------------------------------------

-- Rechercher toutes les adresses contenant un mot-clé dans le nom de voie (joie).
SELECT a.numero,
       a.rep,
       v.nom_voie,
       c.nom_commune,
       c.code_postal
FROM adresse a
JOIN voie v ON a.id_fantoir = v.id_fantoir
JOIN commune c ON v.code_insee = c.code_insee
WHERE v.nom_voie ILIKE '%joie%'
ORDER BY v.nom_voie, a.numero;

-- SELECT choisit les colonnes à afficher des tables adresse, voie et commune.
-- JOIN relie les tables voie et commune pour obtenir les infos.
-- WHERE filtre les résultats sur les noms de voies et ILIKE rend la recherche insensible à la casse.
-- Les résultats sont triés par nom de voie et numéro.

----------------------------------------------------------------------------------------------------------------------------------

-- Identifier les adresses où le code postal est vide alors que la commune est renseignée
SELECT a.numero,
       a.rep,
       v.nom_voie,
       c.nom_commune,
       c.code_postal
FROM adresse a
JOIN voie v ON a.id_fantoir = v.id_fantoir
JOIN commune c ON v.code_insee = c.code_insee
WHERE c.code_postal IS NULL
ORDER BY c.nom_commune, v.nom_voie, a.numero;

-- On sélectionne les colonnes à afficher provenant des tables adresse, voie et commune
-- JOIN relie les tables voie et commune pour obtenir les infos.
-- on filtre les codes postaux vides IS NULL. 
-- et on affiche par ordre alphabétique.