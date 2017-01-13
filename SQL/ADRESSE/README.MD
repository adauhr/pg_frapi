#ADRESSE (API adresse.data.gouv.fr)
Ce module permet d'interroger l'api de géocodage de la base adresse nationale édité par le SGMAP (Secrétariat général pour la modernisation de l’action publique).

Pour plus de renseignements consultez la documentation de l'api https://adresse.data.gouv.fr/api/

##Fonctions et usages
###Géocodage (sortie recordset avec geometry)
```sql
frapi.adresse_search(q text --Paramètre obligatoire (recherche plain text)
[,"limit",autocomplete boolean,lon numeric,lat numeric,type text,postcode text,citycode text]) --optionnels
```
###Géocodage (sortie JSONB)
```sql
frapi.adresse_search_json(q text --Paramètre obligatoire (recherche plain text)
[,"limit",autocomplete boolean,lon numeric,lat numeric,type text,postcode text,citycode text]) --optionnels
```
###Géocodage inverse (sortie recordset avec geometry)
```sql
frapi.adresse_reverse(lon numeric, lat numeric --Paramètres obligatoire
[,"limit" integer, autocomplete boolean, type text, postcode text, citycode text]) --optionnels
```
###Géocodage inverse (sortie JSONB)
```sql
frapi.adresse_reverse_json(lon numeric, lat numeric --Paramètres obligatoire
[,"limit" integer, autocomplete boolean, type text, postcode text, citycode text]) --optionnels
```
###Conversion JSONB vers recordset
```sql
frapi.adresse_search_format(jsonb)
```
##Fair use
Frapi limite les requêtes à 10/seconde/IP, pas de politique de banissement d'IP, non-réponse en cas de flood.
Attention pour l'instant frapi ne sait pas limiter les requètes parallèle depuis un même serveur.

Voir aussi https://adresse.data.gouv.fr/cgu/
