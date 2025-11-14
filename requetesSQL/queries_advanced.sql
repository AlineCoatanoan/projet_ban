-- Créer une procédure stockée pour insérer ou mettre à jour une adresse selon qu’elle existe déjà.
CREATE OR REPLACE PROCEDURE upsert_adresse_procedure(
    p_numero INTEGER,
    p_rep VARCHAR,
    p_id_fantoir CHAR(10),
    p_source_position VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO adresse (numero, rep, id_fantoir, source_position)
    VALUES (p_numero, p_rep, p_id_fantoir, p_source_position)
    ON CONFLICT (id_fantoir, numero, rep)
    DO UPDATE SET
        source_position = EXCLUDED.source_position;
END;
$$;

-- ensuite on call
CALL upsert_adresse_procedure(
    10,
    'bis',
    'N0001',
    'GPS'
);
-- on créer une procédure avec des paramètres qu'on veut insérer ou mettre à jour dans la table adresse
-- il faut préciser le langage utilisé (ici plpgsql)
-- Les $$ délimitent le corps de la procédure
-- on utilise INSERT INTO avec ON CONFLICT pour gérer l'insertion
-- et DO UPDATE SET met à jour si ça existe déjà

-- Ensuite on appelle la procédure avec CALL. On met les valeurs qu'on veut insérer ou mettre à jour.

-----------------------------------------------------------------------------------------------------------------------------------

-- Créer un trigger qui vérifie, avant insertion, que les coordonnées GPS sont valides (lat entre -90 et 90, lon entre -180 et 180)
-- et que le code postal est bien au format 5 chiffres

CREATE OR REPLACE FUNCTION verif_coordonnees_et_cp()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.lat < -90 OR NEW.lat > 90 THEN
        RAISE EXCEPTION 'Latitude % invalide', NEW.lat;
    END IF;

    -- if ... then est une condition
    -- RAISE EXCEPTION permet de lever une erreur avec un message personnalisé
    -- NEW.lat : c’est la valeur de la colonne lat

    IF NEW.lon < -180 OR NEW.lon > 180 THEN
        RAISE EXCEPTION 'Longitude % invalide', NEW.lon;
    END IF;

    IF NEW.code_postal !~ '^\d{5}$' THEN
        RAISE EXCEPTION 'Code postal % invalide', NEW.code_postal;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trig_verif_gps_et_cp
BEFORE INSERT OR UPDATE ON coordonnee
FOR EACH ROW
EXECUTE FUNCTION verif_coordonnees_et_cp();

-- On crée un trigger nommé trig_verif_gps_et_cp.
-- BEFORE INSERT OR UPDATE, le trigger se déclenche avant d’insérer ou de mettre à jour une ligne.
-- ON coordonnee, le trigger agit sur la table coordonnee.
-- FOR EACH ROW, s'exécute pour chaque ligne insérée ou mise à jour.
-- EXECUTE FUNCTION verif_coordonnees_et_cp() créée précédemment et vérifie.

-- test
INSERT INTO coordonnee (id_adresse, lon, lat, x, y)
VALUES (1, 4.123456, 100, 654321, 123456);
-- ça renvoie bien une erreur


-----------------------------------------------------------------------------------------------------------------------------------


-- Ajouter automatiquement une date de création / mise à jour à chaque modification via trigger.