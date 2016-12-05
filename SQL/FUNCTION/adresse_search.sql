-- Function: adresse_search(text, integer, boolean, numeric, numeric, text, text, text)

-- DROP FUNCTION adresse_search(text, integer, boolean, numeric, numeric, text, text, text);

CREATE OR REPLACE FUNCTION adresse_search(
    q text,
    "limit" integer DEFAULT 1,
    autocomplete boolean DEFAULT true,
    lon numeric DEFAULT NULL::numeric,
    lat numeric DEFAULT NULL::numeric,
    type text DEFAULT NULL::text,
    postcode text DEFAULT NULL::text,
    citycode text DEFAULT NULL::text)
  RETURNS SETOF adresse_search AS
$BODY$
SELECT * FROM adresse_search_format(adresse_search_json("q","limit","autocomplete","lon","lat","type","postcode","citycode"));
$BODY$
  LANGUAGE sql VOLATILE;
