# Règles de gestion

---
## Commune
- **RG1 :** Chaque commune est identifiée par un code INSEE unique et stable dans le temps.  
- **RG2 :** Chaque commune possède un nom obligatoire.  
- **RG3 :** Chaque commune possède un code postal officiel correspondant.  
- **RG4 :** Chaque commune peut avoir un ancien code INSEE si elle a été fusionnée.  
- **RG5 :** Chaque commune peut avoir un ancien nom si elle a été fusionnée.  
- **RG6 :** Chaque commune possède au moins une voie.  

---
## Voie
- **RG7 :** Chaque voie est identifiée par un id_fantoir unique et stable dans le temps.  
- **RG8 :** Chaque voie appartient à exactement une commune existante.  
- **RG9 :** Chaque voie possède un nom usuel obligatoire.  
- **RG10 :** Chaque voie peut posséder un nom normalisé (AFNOR), un ou plusieurs alias et éventuellement un lieu-dit.  
- **RG11 :** Chaque voie peut préciser sa source de nom et son type de position.  

---
## Adresse
- **RG12 :** Chaque adresse est identifiée par un identifiant unique et stable dans le temps.  
- **RG13 :** Chaque adresse appartient à exactement une voie existante.  
- **RG14 :** Chaque adresse possède un numéro obligatoire.  
- **RG15 :** Chaque adresse doit posséder une référence cadastrale (cad_parcelles).  
- **RG16 :** Chaque adresse peut posséder un complément de numéro et une source de position.  

---
## Coordonnée
- **RG17 :** Chaque adresse possède exactement une coordonnée géographique associée.  
- **RG18 :** Chaque coordonnée est composée de longitude et latitude obligatoires.  
- **RG19 :** Chaque coordonnée GPS doit correspondre à une adresse existante (intégrité référentielle).  

---
## Parcelles
- **RG20 :** Chaque parcelle est identifiée par un identifiant unique (id_parcelle).  
- **RG21 :** Une parcelle peut contenir une ou plusieurs adresses.  
- **RG22 :** Une adresse peut appartenir à une ou plusieurs parcelles (relation N:N).  
- **RG23 :** Chaque association adresse–parcelle doit référencer des adresses et des parcelles existantes.  
- **RG24 :** La combinaison dans la table de liaison doit être unique.  

---
## Règles générales pour les relations
- **RG25 :** Toute modification d’une adresse ou d’une parcelle ne doit pas invalider l’intégrité des relations N:N.  
- **RG26 :** La suppression d’une adresse ou d’une parcelle doit entraîner la suppression correspondante dans la table de liaison.  

---
## Règles générales 
- **RG27 :** Chaque identifiant d’adresse (id) doit rester stable si le lieu existe toujours.  
- **RG28 :** Chaque nouvelle adresse doit recevoir un nouvel identifiant unique.  
- **RG29 :** Chaque identifiant d’un objet détruit ne doit pas être réutilisé pour un autre objet.  
- **RG30 :** Chaque code INSEE et chaque id_fantoir doivent respecter les formats officiels fournis par la BAN.  
- **RG31 :** Chaque code postal doit correspondre à la commune de l’adresse.  
