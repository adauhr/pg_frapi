SELECT plan(5);

PREPARE search_expected AS VALUES('{"type": "FeatureCollection", "query": "baninfo", "attribution": "BAN", "features": [], "version": "draft", "limit": 1, "licence": "ODbL 1.0"}'::jsonb);
PREPARE baninfo_adresse_search AS SELECT * FROM frapi.adresse_search_json('baninfo');
SELECT results_eq('baninfo_adresse_search','search_expected',
	'La fonction adresse renvoi la valeur test de Addokk');

PREPARE reverse_expected AS VALUES('{"type": "FeatureCollection", "attribution": "BAN", "features": [], "version": "draft", "limit": 1, "licence": "ODbL 1.0"}'::jsonb);
PREPARE baninfo_adresse_reverse AS SELECT * FROM frapi.adresse_reverse_json(0.,0.);
SELECT results_eq('baninfo_adresse_reverse','reverse_expected',
	'La fonction reverse renvoi la valeur test de Addokk');

PREPARE performance_adresse_search AS SELECT * FROM frapi.adresse_search('route des anges, landéda');
SELECT performs_ok('performance_adresse_search',2000,
	'Test sans mise en cache');
SELECT performs_ok('performance_adresse_search',600,
	'Test après mise en cache');


SELECT * FROM check_test(
performs_ok('performance_adresse_search',90,'Test du paramètre wait (echec attendu)'),
    false,'Test du paramètre wait'
);

SELECT * FROM finish();
