-- Function: adresse_search_json(text, integer, boolean, numeric, numeric, text, text, text)

-- DROP FUNCTION @extschema@.adresse_search_json(text, integer, boolean, numeric, numeric, text, text, text);

CREATE OR REPLACE FUNCTION @extschema@.adresse_search_json(
    q text,
    "limit" integer DEFAULT 1,
    autocomplete boolean DEFAULT true,
    lon numeric DEFAULT NULL::numeric,
    lat numeric DEFAULT NULL::numeric,
    type text DEFAULT NULL::text,
    postcode text DEFAULT NULL::text,
    citycode text DEFAULT NULL::text)
  RETURNS jsonb AS
$BODY$
DECLARE
frapi_query text;
frapi_wait numeric DEFAULT 0.1;
frapi_timeout numeric DEFAULT 10;
frapi_result jsonb;

frapi_q text DEFAULT '';
frapi_limit text DEFAULT '';
frapi_autocomplete text DEFAULT '';
frapi_lonlat text DEFAULT '';
frapi_type text DEFAULT '';
frapi_postcode text DEFAULT '';
frapi_citycode text DEFAULT '';

BEGIN


frapi_q := 'q='||"q";

IF "limit" > 0 THEN
   frapi_limit := '&limit='||"limit"::text ;
ELSE
   frapi_limit :='';
END IF;

IF "autocomplete" = false THEN
   frapi_autocomplete := '&autocomplete=0'::text ;
END IF;

IF "lat" IS NOT NULL and "lon" IS NOT NULL THEN
   frapi_lonlat := '&lon='||"lon"::text||'&lat='||"lat"::text;
END IF;

IF "type" IS NOT NULL THEN
   frapi_type := '&type='||"type"::text;
END IF;

IF "postcode" IS NOT NULL THEN
   frapi_postcode := '&postcode='||"postcode"::text;
END IF;

IF "citycode" IS NOT NULL THEN
   frapi_citycode := '&citycode='||"citycode"::text;
END IF;

frapi_query :='https://api-adresse.data.gouv.fr/search/?'||frapi_q||frapi_limit||frapi_autocomplete||frapi_lonlat||frapi_type||frapi_postcode||frapi_citycode;
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