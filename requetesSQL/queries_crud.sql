
-- Ajouter une nouvelle adresse complète dans les tables finales.
INSERT INTO commune (code_insee, nom_commune, code_postal, libelle_acheminement)
VALUES ('39999', 'Kaamelott', '39999', 'Kaamelott')
ON CONFLICT (code_insee) DO NOTHING;

INSERT INTO voie (id_fantoir, nom_voie, code_insee)
VALUES ('N0001', 'Rue Perceval', '39999')
ON CONFLICT (id_fantoir) DO NOTHING;

INSERT INTO adresse (numero, rep, id_fantoir, source_position)
VALUES ('10', NULL, 'N0001', 'Ban')
RETURNING id;

INSERT INTO coordonnee (id_adresse, lon, lat, x, y)
VALUES (currval('adresse_id_seq'), 4.350, 43.850, 654321, 123456);

-- INSERT INTO sert à ajouter des données dans la table commune (précision des colonnes)
-- VALUES sont les valeurs ajoutées en fonction des colonnes.
-- ON CONFLICT ... DO NOTHING, signifie que si un enregistrement avec ce code_insee existe déjà, alors il ne se passe rien
-- dans l'insertion des données dans la table adresse, on créer un ID d'où RETURNING id,
-- toutes les valeurs pour cette requêtes sont inventées.

-------------------------------------------------------------------------------------------------------------------------------

-- Mettre à jour le nom d’une voie pour une adresse spécifique.
UPDATE voie
SET nom_voie = 'Rue Arthur'
WHERE id_fantoir = (
    SELECT v.id_fantoir
    FROM adresse a
    JOIN voie v ON a.id_fantoir = v.id_fantoir
    JOIN commune c ON v.code_insee = c.code_insee
    WHERE c.nom_commune = 'Kaamelott'
      AND a.numero = '10'
      AND v.nom_voie = 'Rue Perceval'
);

-- UPDATE modifie le nom_voie dans la table voie.
-- SET indique la nouvelle valeur.
-- WHERE filtre sur l'id_fantoir qui va sélectionner la voie et la commune de la table adresse et de nouveau filtrer pour retrouver
-- la bonne adresse à modifier. 
-- En soit, on filtre dans une requête qui est elle même imbriquée dans le filtre de la requête principale.

-------------------------------------------------------------------------------------------------------------------------------

-- Supprimer toutes les adresses avec un champ manquant critique (id_fantoir).
SELECT a.id AS id_adresse,
       a.numero,
       a.rep,
       a.id_fantoir
FROM adresse a
WHERE a.id_fantoir IS NULL
   OR TRIM(a.id_fantoir) = '';

DELETE FROM adresse
WHERE id_fantoir IS NULL
   OR TRIM(id_fantoir) = '';

-- on selectionne les lignes de la table adresse où (WHERE) id_fantoir est null 
-- ou (OR) TRIM qui enlève tous les espaces au début et à la fin de la valeur, et donc si id_fantoir est vide.
-- DELETE, on supprime de la table adresse les infos sélectionnées précédemment.
