Base Adresses Nationales

Optimisation et modélisation de données réelles

----------------------------------------------------------------------------------------------------------------------------------

###### **Objectif :**


À partir d’une source de données officielle volumineuse (Base Adresse Nationale), concevoir, structurer et optimiser une base de données relationnelle cohérente et performante.

----------------------------------------------------------------------------------------------------------------------------------

###### 📌 Installation / Prérequis :


PostgreSQL installé (version 17)

DBeaver pour accéder à la base

Fichier CSV départemental (adresses-30.csv)

Docker

----------------------------------------------------------------------------------------------------------------------------------

###### 📌 Modélisation :


Le fichier CSV initial dont j'ai appelé la table "data_ban" contient les attributs suivant :

id, id_fantoir, numero, rep, nom_voie, code_postal, code_insee, nom_commune,
code_insee_ancienne_commune, nom_ancienne_commune, x, y, lon, lat,
type_position, alias, nom_ld, libelle_acheminement, nom_afnor,
source_position, source_nom_voie, certification_commune, cad_parcelles

J’ai choisi de découper la table en plusieurs entités pour mieux structurer les données et éviter les répétitions. Le fichier d’origine contenait à la fois des informations sur la commune, la voie, l’adresse et les coordonnées. J’ai donc isolé chaque groupe logique : COMMUNE pour les données administratives, VOIE pour les rues et lieux-dits, ADRESSE comme entité pivot reliant commune, voie et coordonnées, COORDONNÉES pour la géolocalisation, et PARCELLES avec une table d’association ADRESSE_PARCELLE pour représenter la relation many-to-many entre adresses et parcelles. 

Découpage retenu :

COMMUNE — centralise les informations administratives relatives à la commune.
VOIE — contient les informations propres à la rue / lieu-dit (id_fantoir, nom_voie, nom_afnor...).
ADRESSE — entité pivot qui référence numéro, rép (complément), et relie voie + commune.
COORDONNÉES — table dédiée aux coordonnées (lon, lat, x, y) liées en 1:1 à une adresse.
PARCELLES + ADRESSE_PARCELLE — table parcelles et table d'association pour gérer la relation n:n.

Par la suite, j'ai dû rajouter les colonnes date_creation et date_modification dans la table adresse pour faire des ajouts/modif
de date via trigger.

----------------------------------------------------------------------------------------------------------------------------------

###### 📌 Exemples de requêtes :


📝 Lister toutes les adresses d’une commune donnée, triées par voie :

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


📝 Ajouter une nouvelle adresse complète :

INSERT INTO commune (code_insee, nom_commune, code_postal, libelle_acheminement)
VALUES ('39999', 'Kaamelott', '39999', 'Kaamelott')
ON CONFLICT (code_insee) DO NOTHING;

INSERT INTO voie (id_fantoir, nom_voie, code_insee)
VALUES ('N0001', 'Rue Perceval', '39999')
ON CONFLICT (id_fantoir) DO NOTHING;

INSERT INTO adresse (numero, rep, id_fantoir, source_position)
VALUES ('10', NULL, 'N0001', 'BAN')
RETURNING id;

INSERT INTO coordonnee (id_adresse, lon, lat, x, y)
VALUES (currval('adresse_id_seq'), 4.350, 43.850, 654321, 123456);


📝 Lister les codes postaux avec plus de 10 000 adresses :

SELECT c.code_postal,
       c.nom_commune,
       COUNT(*) AS nb_adresses
FROM adresse a
JOIN voie v ON a.id_fantoir = v.id_fantoir
JOIN commune c ON v.code_insee = c.code_insee
GROUP BY c.code_postal, c.nom_commune
HAVING COUNT(*) > 10000
ORDER BY nb_adresses DESC;

----------------------------------------------------------------------------------------------------------------------------------

###### 📌 Observations de performance :

Avant la création des index, certaines requêtes sur les tables commune, voie et adresse nécessitaient un scan complet de la table, ce qui était plus lent.

Après création des index sur les champs les plus sollicités :

commune(code_postal)
adresse(id_fantoir)
voie(code_insee)

PostgreSQL peut accéder directement aux lignes pertinentes sans parcourir toute la table.

Exemple concret :

Requête pour lister toutes les adresses d’un code postal : Execution Time passé de 0,087 ms → 0,062 ms.

Les index permettent un gain de rapidité significatif sur les requêtes fréquentes, en particulier lorsqu’on travaille avec des tables volumineuses comme celles issues de la BAN.