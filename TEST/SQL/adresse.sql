SELECT plan(5);

PREPARE baninfo_expected AS VALUES('db','info','baninfo','baninfo','0101000020E610000000000000000000000000000000000000'::geometry);

PREPARE baninfo_adresse_search AS SELECT id,type,name,label,geom FROM frapi.adresse_search('baninfo');
SELECT results_eq('baninfo_adresse_search','baninfo_expected',
	'La fonction adresse renvoi la valeur test de Addokk');

PREPARE baninfo_adresse_reverse AS SELECT id,type,name,label,geom FROM frapi.adresse_reverse(0.,0.);
SELECT results_eq('baninfo_adresse_reverse','baninfo_expected',
	'La fonction reverse renvoi la valeur test de Addokk');

PREPARE performance_adresse_search AS SELECT * FROM frapi.adresse_search('route des anges, landéda');
SELECT performs_ok('performance_adresse_search',2000,
	'Test sans mise en cache');
SELECT performs_ok('performance_adresse_search',150,
	'Test après mise en cache');


SELECT * FROM check_test(
performs_ok('performance_adresse_search',90,'Test du paramètre wait (echec attendu)'),
    false,'Test du paramètre wait'
);

SELECT * FROM finish();
