Base Adresses Nationales



Optimisation et modélisation de données réelles



###### **Objectif :**



À partir d’une source de données officielle volumineuse (Base Adresse Nationale), concevoir, structurer et optimiser une base de données relationnelle cohérente et performante.



###### 📌 Installation / Prérequis :



PostgreSQL installé (version 17)

DBeaver pour accéder à la base

Fichier CSV départemental (adresses-30.csv)

Docker



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




###### 📌 Exemples de requêtes :

Pour les requêtes, j'ai fais du pseudo-code à chaque fois pour bien comprendre comment elles étaient traitées. 







###### 📌 Observations de performance :

