#Pg_frapi
===============

Une collection de fonction postgresql native qui définnisent un mappage et permettent d'interroger une séléction d'API mise à disposition par les diverses administration françaises.
Ce projet est encore en gestation et n'est pas encore stable ni même opérationel. Nous avons cependant fait le choix de dévelloper cette de manière totalement ouverte dans l'esprit de la loi sur la modernisation numérique.

##Objectifs
###Version 0.1
* Proposer une implémentation simple pour l'API adresse.gouv.fr
* Proposer une implémentation simple pour l'API ign
###Version 0.2
* Statbiliser la syntaxe et la signature des différentes fonctions.
* Créer des types personalisé simples pour les variable d'entrée
* Créer des types composites pour les résultats
* Evaluer les moyens de récupérer facilement des métadonées liées au requêtes


##Prérequis
L'extension [PL/SH](https://github.com/petere/plsh) est actuellement requise puisqu'elle sert actuellemnt de passerelle pour acceder au API.
(Sur une suggestion de [Christian Quest](https://github.com/cquest) il sera necessaire d'evaluer s'il ne serait pas opportun de basculer vers l'extension [pgsql-http](https://github.com/pramsey/pgsql-http))


##Installation
1. Clone the repo
1. Run `make install`
1. Execute `CREATE EXTENSION frapi;` inside your DB
1. Call `SELECT frapi.test();` this should return french sentence saying 'this is a test' as string
