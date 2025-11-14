# Découverte de la donnée

**Téléchargement du fichier CSV départemental :** `adresses-30.csv`

---

## Colonnes du fichier CSV

- id  
- id_fantoir  
- numero  
- rep  
- nom_voie  
- code_postal  
- code_insee  
- nom_commune  
- code_insee_ancienne_commune  
- nom_ancienne_commune  
- x  
- y  
- lon  
- lat  
- type_position  
- alias  
- nom_ld  
- libelle_acheminement  
- nom_afnor  
- source_position  
- source_nom_voie  
- certification_commune  
- cad_parcelles  

---

## Identifier les entités logiques et relations potentielles

### 1. Adresse
- id  
- numero  
- rep  
- nom_voie  
- code_postal  
- code_insee  

### 2. Voie / Rue
- nom_voie  
- nom_afnor  
- alias  
- source_nom_voie  
- id_fantoir  

### 3. Commune
- nom_commune  
- code_insee  
- libelle_acheminement  
- certification_commune  
- nom_ancienne_commune  
- code_insee_ancienne_commune  

### 4. Coordonnée
- lon  
- lat  
- x  
- y  
- source_position  

### 5. Parcelle cadastrale
- cad_parcelles  

---

## Relations potentielles

- Adresse → Parcelles
