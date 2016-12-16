#pg_frapi

Une collection de fonctions postgresql natives qui définissent un mappage et permettent d'interroger une séléction d'API mises à disposition par les diverses administrations françaises.
Ce projet est encore en gestation et n'est pas encore stable. Nous avons cependant fait le choix de le dévelloper de manière totalement ouverte dans l'esprit de la loi sur la modernisation numérique.

##Etat d'avancement
Le projet est actuelement en phase Alpha, le code est publié pour avis, la licence reste encore à définir.
Les fonctions adresse_search() et adresse_reverse() sont cependant d'ors est déjà fonctionelles, un rapprochement avec adresse.gouv.fr et en cours pour voir si ce project respecte l'esprit et les capacité techniques de leur API.
L'installation n'a pour l'instant été testée que sous Ubuntu 14.04 et PostgreSQL 9.5.

##Objectifs
###Version 0.1
- [x] Proposer une implémentation simple pour l'API adresse.gouv.fr
  - [x] Définir les paramètres d'entrée de manière à pouvoir utiliser tous les paramètres de l'API via des fonctions PG
  - [x] Possibilité de récupérer un JSON brut ou un des lignes composites PG définie pour les résultats
  - [x] Fourniture d'une fonction de conversion entre le JSON brut et le type composite
- [x] Implémenter un système de build suffisant pour assembler les différents fichiers SQL
- [x] Choix d'une politique de tags, de versionnement et d'utilisation des branches adéquat pour les dévelopements futurs
- [x] Choix d'une licence FOSS pour le projet
- [ ] ~~Proposer une implémentation simple pour l'API ign~~ ***-->déplacé vers version 0.2***

###Version 0.2
- [ ] Commenter le code de l'API adresse.gouv.fr
- [ ] Rédiger une page de documentation utilisateur pour l'API adresse.gouv.fr
- [ ] Rédiger une page de documentation pour le systeme de build
- [ ] Proposer une implémentation simple pour l'API ign
- [ ] Stabiliser la syntaxe et la signature des différentes fonctions
- [ ] Amélioration du système de build pour générer des scripts d'update


##Prérequis
L'extension [PL/SH](https://github.com/petere/plsh) est actuellement requise puisqu'elle sert actuellemnt de passerelle pour acceder au API.
(Sur une suggestion de [Christian Quest](https://github.com/cquest) il sera necessaire d'evaluer s'il ne serait pas opportun de basculer vers l'extension [pgsql-http](https://github.com/pramsey/pgsql-http))


##Installation rapide (Testée sur Ubuntu 14.04)
1. Cloner le repo
1. Dans le shell executer `make build` (cette étape s'applique uniquement pour la version dev en attendant la premièer release)
1. Dans le shell executer `make install`
1. Dans l'interface SQL executer `CREATE EXTENSION frapi;` inside your DB

##Test rapide post-installation
* **API adresse.gouv.fr**</br>Dans l'interface SQL executer `SELECT * FROM frapi.adresse_search('8 bd du port');` cela devrait retourner des lignes postgresql calquées sur la structure de donnée de l'API décrite [ici](https://adresse.data.gouv.fr/api/)
