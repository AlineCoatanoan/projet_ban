-- CREATE TABLE 
-- j'ai repris les données du MPD

CREATE TABLE commune (
    code_insee CHAR(5) PRIMARY KEY,
    nom_commune VARCHAR(100) NOT NULL,
    code_postal CHAR(5) NOT NULL,
    libelle_acheminement VARCHAR(100),
    certification_commune VARCHAR(20),
    code_insee_ancienne_commune CHAR(5),
    nom_ancienne_commune VARCHAR(100)
);

CREATE TABLE voie (
    id_fantoir CHAR(10) PRIMARY KEY,
    nom_voie VARCHAR(150) NOT NULL,
    nom_afnor VARCHAR(150),
    alias VARCHAR(150),
    source_nom_voie VARCHAR(50),
    type_position VARCHAR(30),
    nom_ld VARCHAR(150),
    code_insee CHAR(5) NOT NULL,
    FOREIGN KEY (code_insee) REFERENCES commune(code_insee)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE adresse (
    id SERIAL PRIMARY KEY,
    numero INTEGER NOT NULL,
    rep VARCHAR(10),
    id_fantoir CHAR(10) NOT NULL,
    source_position VARCHAR(50),
    FOREIGN KEY (id_fantoir) REFERENCES voie(id_fantoir)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE coordonnee (
    id_adresse INTEGER PRIMARY KEY,
    lon NUMERIC(9,6) NOT NULL,
    lat NUMERIC(9,6) NOT NULL,
    x NUMERIC(10,2),
    y NUMERIC(10,2),
    FOREIGN KEY (id_adresse) REFERENCES adresse(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE parcelles (
    id_parcelle VARCHAR PRIMARY KEY
);

CREATE TABLE adresse_parcelle (
    id_adresse INTEGER NOT NULL,
    id_parcelle VARCHAR NOT NULL,
    PRIMARY KEY (id_adresse, id_parcelle),
    FOREIGN KEY (id_adresse) REFERENCES adresse(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_parcelle) REFERENCES parcelles(id_parcelle)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- JEU D’ESSAI

INSERT INTO commune (code_insee, nom_commune, code_postal, libelle_acheminement, certification_commune)
VALUES
('30002','Aigremont','30350','AIGREMONT','commune');

INSERT INTO voie (id_fantoir, nom_voie, code_insee)
VALUES
('30002_0001','La Viste','30002'),
('30002_0002','La Placette','30002'),
('30002_0003','La Traverse','30002');

INSERT INTO adresse (numero, rep, id_fantoir, source_position)
VALUES
(1, NULL, '30002_0001', 'entrée'),
(2, NULL, '30002_0002', 'entrée'),
(3, NULL, '30002_0002', 'entrée'),
(4, NULL, '30002_0003', 'entrée'),
(5, NULL, '30002_0003', 'entrée');

INSERT INTO coordonnee (id_adresse, lon, lat, x, y)
VALUES
(1, 4.099483, 43.95617, 788250.3, 6318077.5),
(2, 4.122214, 43.96548, 790060.0, 6319137.5),
(3, 4.122406, 43.96542, 790075.5, 6319131.0),
(4, 4.133274, 43.968758, 790942.3, 6319514.5),
(5, 4.134247, 43.968697, 791020.5, 6319508.5);

INSERT INTO parcelles (id_parcelle)
VALUES
('P001'),
('P002'),
('P003');

INSERT INTO adresse_parcelle (id_adresse, id_parcelle)
VALUES
(1,'P001'),
(2,'P002'),
(3,'P002'),
(4,'P003'),
(5,'P003');