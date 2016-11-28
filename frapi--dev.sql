CREATE FUNCTION test() RETURNS text as
$$
SELECT 'Ceci est un test'::text
$$
LANGUAGE SQL;
