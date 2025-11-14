
-- Nombre moyen d’adresses par commune et par voie.

-- A voir : Pour l'instant c'est un peu compliqué

-----------------------------------------------------------------------------------------------------

-- Top 10 des communes avec le plus d’adresses.
SELECT 
    c.nom_commune,
    COUNT(a.id) AS nb_adresses
FROM adresse a
JOIN voie v ON a.id_fantoir = v.id_fantoir
JOIN commune c ON v.code_insee = c.code_insee
GROUP BY c.nom_commune
ORDER BY nb_adresses DESC
LIMIT 10;

-----------------------------------------------------------------------------------------------------

-- Vérifier la complétude des champs essentiels (numéro, voie, code postal, commune).
SELECT 
    a.id AS id_adresse,
    a.numero,
    v.nom_voie,
    c.nom_commune,
    c.code_postal
FROM adresse a
LEFT JOIN voie v ON a.id_fantoir = v.id_fantoir
LEFT JOIN commune c ON v.code_insee = c.code_insee
WHERE a.numero IS NULL                
   OR v.nom_voie IS NULL 
   OR v.nom_voie = ''
   OR c.code_postal IS NULL              
   OR c.nom_commune IS NULL
   OR c.nom_commune = '';