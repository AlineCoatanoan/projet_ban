EXPLAIN ANALYZE
SELECT a.numero, v.nom_voie, c.nom_commune
FROM adresse a
JOIN voie v ON a.id_fantoir = v.id_fantoir
JOIN commune c ON v.code_insee = c.code_insee
WHERE c.code_postal = '30117';

CREATE INDEX idx_commune_code_postal ON commune(code_postal);
CREATE INDEX idx_adresse_id_fantoir ON adresse(id_fantoir);
CREATE INDEX idx_voie_code_insee ON voie(code_insee);

-- les index permettent à PostgreSQL de trouver plus vite les lignes pertinentes sans lire toute la table.
-- index choisis : 
--code_postal dans la table commune
--On cherche souvent toutes les adresses d’un même code postal.

-- id_fantoir dans adresse
-- il y a beaucoup de jointures avec voie, donc l’index permet de trouver vite les adresses liées à une voie.

-- code_insee dans voie 
-- on cherche toutes les voies dans une commune.

--ce sont les colonnes les plus utilisées pour filtrer ou faire des jointures.


-- résultat avant création des index :
-- Nested Loop  (cost=8.80..699.86 rows=872 width=36) (actual time=0.062..0.064 rows=0 loops=1)
--  -> Hash Join  (cost=8.38..620.19 rows=68 width=43) (actual time=0.062..0.063 rows=0 loops=1)
--        Hash Cond: (v.code_insee = c.code_insee)
--        -> Seq Scan on voie v  (cost=0.00..548.67 rows=23767 width=36) (actual time=0.016..0.016 rows=1 loops=1)
--        -> Hash  (cost=8.36..8.36 rows=1 width=19) (actual time=0.042..0.043 rows=0 loops=1)
--              Buckets: 1024  Batches: 1  Memory Usage: 8kB
--              -> Seq Scan on commune c  (cost=0.00..8.36 rows=1 width=19) (actual time=0.042..0.042 rows=0 loops=1)
--                    Filter: (code_postal = '30117'::bpchar)
--                    Rows Removed by Filter: 349
--  -> Index Only Scan using unique_adresse on adresse a  (cost=0.42..0.99 rows=18 width=15) (never executed)
--        Index Cond: (id_fantoir = v.id_fantoir)
--        Heap Fetches: 0
-- Planning Time: 2.216 ms
-- Execution Time: 0.087 ms


-- résultat après création des index :
-- Nested Loop  (cost=5.43..269.07 rows=872 width=36) (actual time=0.025..0.026 rows=0 loops=1)
--  ->  Nested Loop  (cost=5.01..189.40 rows=68 width=43) (actual time=0.025..0.026 rows=0 loops=1)
--        ->  Index Scan using idx_commune_code_postal on commune c  (cost=0.15..8.17 rows=1 width=19) (actual time=0.025..0.025 rows=0 loops=1)
--              Index Cond: (code_postal = '30117'::bpchar)
--        ->  Bitmap Heap Scan on voie v  (cost=4.86..180.49 rows=74 width=36) (never executed)
--              Recheck Cond: (code_insee = c.code_insee)
--              ->  Bitmap Index Scan on idx_voie_code_insee  (cost=0.00..4.84 rows=74 width=0) (never executed)
--                    Index Cond: (code_insee = c.code_insee)
--  ->  Index Only Scan using unique_adresse on adresse a  (cost=0.42..0.99 rows=18 width=15) (never executed)
--        Index Cond: (id_fantoir = v.id_fantoir)
--        Heap Fetches: 0
-- Planning Time: 4.505 ms
-- Execution Time: 0.062 ms

-- Planning Time : temps que PostgreSQL met pour calculer le plan d’exécution de la requête.
-- Execution Time : temps que PostgreSQL met pour exécuter la requête et renvoyer les résultats.
-- Temps d’exécution réduit : de 0.087 ms → 0.062 ms
-- PostgreSQL n’explore que les lignes pertinentes au lieu de toute la table.
-- "Never executed" veut dire que le chemin n’a pas été utilisé sur les données actuelles
-- planning time augmente après création de l'index car le temps de réflexion sur les index est plus long.



