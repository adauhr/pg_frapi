-- Function: geonym_json(text, integer, boolean, numeric, numeric, text, text, text)

-- DROP FUNCTION @extschema@.geonym_json(text, integer, boolean, numeric, numeric, text, text, text);

CREATE OR REPLACE FUNCTION @extschema@.geonym_json(
    geonym text DEFAULT NULL::text,
    lon numeric DEFAULT NULL::numeric,
    lat numeric DEFAULT NULL::numeric,
    x numeric DEFAULT NULL::numeric,
    y numeric DEFAULT NULL::numeric,
    adresse text DEFAULT NULL::text,
    reverse boolean DEFAULT false)
  RETURNS jsonb AS
$BODY$
DECLARE
frapi_query text;
frapi_wait numeric DEFAULT 0.1;
frapi_timeout numeric DEFAULT 10;
frapi_result jsonb;

frapi_options text DEFAULT '';
frapi_lonlat text DEFAULT '';
frapi_xy text DEFAULT '';
frapi_reverse text DEFAULT '';
frapi_adresse text DEFAULT '';

BEGIN


IF "lat" IS NOT NULL and "lon" IS NOT NULL THEN
   frapi_lonlat := '&lon='||"lon"::text||'&lat='||"lat"::text;
END IF;

IF "adresse" IS NOT NULL THEN 
frapi_adresse := 'adresse='||"adresse";
END IF;

IF "reverse" = true THEN
   frapi_reverse := '&reverse=yes'::text ;
END IF;


frapi_query :='http://api.geonym.fr/?'||frapi_lonlat||frapi_xy||frapi_reverse||frapi_adresse
RAISE DEBUG 'frapi_query : %', frapi_query;


frapi_result := @extschema@.get_url(frapi_query,frapi_wait,frapi_timeout)::jsonb;

RAISE DEBUG 'attribution : %', (SELECT frapi_result -> 'attribution');
RAISE DEBUG 'licence : %', (SELECT frapi_result -> 'licence');
RAISE DEBUG 'query : %', (SELECT frapi_result -> 'query');
RAISE DEBUG 'type : %', (SELECT frapi_result -> 'type');
RAISE DEBUG 'version : %', (SELECT frapi_result -> 'version');


RETURN frapi_result;

END
$BODY$
  LANGUAGE plpgsql STABLE COST 2000;