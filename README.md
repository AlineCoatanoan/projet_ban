# **Base Adresses Nationales**

## Optimisation et modélisation de données réelles


### **Objectif :**
---
À partir d’une source de données officielle volumineuse (Base Adresse Nationale), concevoir, structurer et optimiser une base de données relationnelle cohérente et performante.


### 📌 Etapes d'installation :
---
#### Installation
PostgreSQL (version 17)
DBeaver pour accéder à la base de données
Docker 
Fichier CSV départemental contenant les adresses (ex. adresses-30.csv)

#### Création de la base PostgreSQL
Ouvrir DBeaver et se connecter à Postgres. Cocher la case permettant d'accéder à toutes les BDD si la BDD BAN a été créée via le terminal. Sinon, dans l’arborescence à gauche, clic droit sur Databases -> Create New Database.
Choisir le propriétaire (utilisateur PostgreSQL).
Clique sur Finish.

#### Créer un utilisateur / mot de passe
Dans l’arborescence -> Security -> Users
Clic droit -> Create New User
Nom, mot de passe, droits (par ex. Can create objects pour créer des tables).
Vérifier que l’utilisateur a les privilèges sur la bdd : clic droit sur la base -> Edit Privileges -> ajoute l’utilisateur.

#### Importer les CSV
On peut d'abord CREATE TABLE (data_ban) en ouvrant un nouveau script (clique droit sur la BDD -> editeur sql)
ensuite, clique droit que la table -> Import Data
Choisis le fichier CSV -> Next

### 📌 Modélisation :
---
Le fichier CSV initial dont j'ai appelé la table "data_ban" contient les attributs suivant :

id, id_fantoir, numero, rep, nom_voie, code_postal, code_insee, nom_commune,
code_insee_ancienne_commune, nom_ancienne_commune, x, y, lon, lat,
type_position, alias, nom_ld, libelle_acheminement, nom_afnor,
source_position, source_nom_voie, certification_commune, cad_parcelles

J’ai choisi de découper la table en plusieurs entités pour mieux structurer les données et éviter les répétitions. Le fichier d’origine contenait à la fois des informations sur la commune, la voie, l’adresse et les coordonnées. J’ai donc isolé chaque groupe logique. Puis "parcelles" est une entité à part, relié à adresse. Car plusieurs adresses peuvent appartenir à une même parcelle (ex. un immeuble), et une parcelle peut contenir plusieurs adresses.

#### Découpage retenu :

**Entités**
- COMMUNE -> centralise les informations relatives à la commune. ( attributs : code_insee, nom_commune, code_postal, libelle_acheminement, certification_commune, code_insee_ancienne_commune, nom_ancienne_commune)

- VOIE -> contient les informations propres à la rue. (attributs : id_fantoir, nom_voie, nom_afnor, alias, source_nom_voie, type_position, nom_ld,code_insee)

- ADRESSE -> entité centrale liée aux autres tables, et liée à la voie via id_fantoir. Comme la voie connaît sa commune via code_insee, l’adresse accède à la commune en passant par la voie. (attributs : id, numero, rep, id_fantoir, source_position, date_creation, date_modification)

- COORDONNÉES -> table dédiée aux coordonnées d'une adresse.(attributs : id_adresse,lon,lat,x,y)

- PARCELLES -> contient les identifiants des parcelles cadastrales. (attribut: id_parcelle)

- ADRESSE_PARCELLE -> table d'association pour gérer la relation n:n entre adresse et parcelles (attributs : id_adresse, id_parcelle)


Ensuite, faire une requête de creation des tables [SCRIPT création de tables](/create_table.sql) et insertion des données [SCRIPT insertion des données](/insert_into.sql)

### 📌 Exemples de requêtes :
---
📝 Lister toutes les adresses d’une commune donnée, triées par voie :

```sql
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
```

📝 Ajouter une nouvelle adresse complète :

```sql
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
```

📝 Lister les codes postaux avec plus de 10 000 adresses :

```sql
SELECT c.code_postal,
       c.nom_commune,
       COUNT(*) AS nb_adresses
FROM adresse a
JOIN voie v ON a.id_fantoir = v.id_fantoir
JOIN commune c ON v.code_insee = c.code_insee
GROUP BY c.code_postal, c.nom_commune
HAVING COUNT(*) > 10000
ORDER BY nb_adresses DESC;
```

### 📌 Observations de performance :
---
Avant la création des index, certaines requêtes sur les tables commune, voie et adresse nécessitent un scan complet de la table, ce qui est plus lent.

Création des index sur les champs les plus sollicités :

- commune(code_postal)
- adresse(id_fantoir)
- voie(code_insee)

PostgreSQL peut accéder directement aux lignes pertinentes sans parcourir toute la table.

Exemple concret :

Requête pour lister toutes les adresses d’un code postal : Execution Time passé de 0,087 ms -> 0,062 ms.

Les index permettent un gain de rapidité significatif sur les requêtes fréquentes, en particulier lorsqu’on travaille avec des tables volumineuses comme celles issues de la BAN.

### 📌 Docker-compose :

Création du fichier [docker-compose](/docker-compose.yml)
Ce fichier permet de décrire toute l’architecture du projet en un seul endroit : quels conteneurs lancer, quels ports ouvrir, quelles variables d’environnement utiliser.

Docker-compose récupère toutes les infos définies dans ce fichier.

À l’intérieur, on définit :

- L’image ou le Dockerfile à utiliser pour chaque service : Postgres, version 17
- Les ports exposés : 5432
- Les variables d’environnement : 
 -> POSTGRES_DB : nom de la base
 -> POSTGRES_USER : utilisateur
 -> POSTGRES_PASSWORD : mot de passe
- Les volumes : sauvegarde les données en dehors du conteneur, la base reste intacte même si le container est supprimé.

