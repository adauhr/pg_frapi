-- Function: adresse_reverse(numeric, numeric, integer, boolean, text, text, text)

-- DROP FUNCTION adresse_reverse(numeric, numeric, integer, boolean, text, text, text);

CREATE OR REPLACE FUNCTION adresse_reverse(
    lon numeric,
    lat numeric,
    "limit" integer DEFAULT 1,
    autocomplete boolean DEFAULT true,
    type text DEFAULT NULL::text,
    postcode text DEFAULT NULL::text,
    citycode text DEFAULT NULL::text)
  RETURNS SETOF adresse_search AS
$BODY$
SELECT * FROM adresse_search_format(adresse_reverse_json("lon","lat","limit","autocomplete","type","postcode","citycode"));
$BODY$
  LANGUAGE sql VOLATILE;