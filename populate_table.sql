BEGIN;

INSERT INTO commune (
    code_insee,
    nom_commune,
    code_postal,
    libelle_acheminement,
    certification_commune,
    code_insee_ancienne_commune,
    nom_ancienne_commune
)
SELECT DISTINCT
    code_insee,
    nom_commune,
    code_postal,
    libelle_acheminement,
    certification_commune,
    code_insee_ancienne_commune,
    nom_ancienne_commune
FROM data_ban
WHERE code_insee IS NOT NULL
ON CONFLICT (code_insee) DO NOTHING;

INSERT INTO voie (
    id_fantoir,
    nom_voie,
    nom_afnor,
    alias,
    source_nom_voie,
    type_position,
    nom_ld,
    code_insee
)
SELECT DISTINCT
    id_fantoir,
    nom_voie,
    nom_afnor,
    alias,
    source_nom_voie,
    type_position,
    nom_ld,
    code_insee
FROM data_ban
WHERE id_fantoir IS NOT NULL
ON CONFLICT (id_fantoir) DO NOTHING;

INSERT INTO adresse (
    numero,
    rep,
    id_fantoir,
    source_position
)
SELECT
    numero,
    rep,
    id_fantoir,
    source_position
FROM data_ban
WHERE id_fantoir IS NOT NULL
ON CONFLICT DO NOTHING;

INSERT INTO coordonnee (
    id_adresse,
    lon,
    lat,
    x,
    y
)
SELECT
    a.id,
    d.lon,
    d.lat,
    d.x,
    d.y
FROM adresse a
JOIN data_ban d
    ON a.id_fantoir = d.id_fantoir
   AND a.numero = d.numero
   AND COALESCE(a.rep,'') = COALESCE(d.rep,'')
ON CONFLICT (id_adresse) DO NOTHING;

INSERT INTO parcelles (id_parcelle)
SELECT DISTINCT TRIM(p) AS id_parcelle
FROM data_ban,
     UNNEST(STRING_TO_ARRAY(cad_parcelles, ',')) AS p
WHERE cad_parcelles IS NOT NULL AND cad_parcelles <> ''
ON CONFLICT (id_parcelle) DO NOTHING;

INSERT INTO adresse_parcelle (id_adresse, id_parcelle)
SELECT
    a.id,
    TRIM(p) AS id_parcelle
FROM adresse a
JOIN data_ban d
    ON a.id_fantoir = d.id_fantoir
   AND a.numero = d.numero
   AND COALESCE(a.rep,'') = COALESCE(d.rep,'')
JOIN LATERAL UNNEST(STRING_TO_ARRAY(d.cad_parcelles, ',')) AS p(id_parcelle) ON TRUE
WHERE d.cad_parcelles IS NOT NULL AND d.cad_parcelles <> ''
ON CONFLICT (id_adresse, id_parcelle) DO NOTHING;

COMMIT;
