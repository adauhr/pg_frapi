-- Function: adresse_reverse_json(numeric, numeric, integer, boolean, text, text, text)

-- DROP FUNCTION adresse_reverse_json(numeric, numeric, integer, boolean, text, text, text);

CREATE OR REPLACE FUNCTION adresse_reverse_json(
    lon numeric,
    lat numeric,
    "limit" integer DEFAULT 1,
    autocomplete boolean DEFAULT true,
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

frapi_lonlat text DEFAULT '';
frapi_limit text DEFAULT '';
frapi_autocomplete text DEFAULT '';
frapi_type text DEFAULT '';
frapi_postcode text DEFAULT '';
frapi_citycode text DEFAULT '';

BEGIN

IF "lat" IS NOT NULL and "lon" IS NOT NULL THEN
   frapi_lonlat := 'lon='||"lon"::text||'&lat='||"lat"::text;
ELSE
   RAISE EXCEPTION  'Les arguments lat et lon sont obligatoires pour le reverse geocoding';
END IF;

IF "limit" > 0 THEN
   frapi_limit := '&limit='||"limit"::text ;
ELSE
   frapi_limit :='';
END IF;

IF "autocomplete" = false THEN
   frapi_autocomplete := '&autocomplete=0'::text ;
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

frapi_query :='http://api-adresse.data.gouv.fr/reverse/?'||frapi_lonlat||frapi_limit||frapi_autocomplete||frapi_type||frapi_postcode||frapi_citycode;
RAISE DEBUG 'frapi_query : %', frapi_query;


frapi_result := get_url(frapi_query,frapi_wait,frapi_timeout)::jsonb;

RAISE DEBUG 'attribution : %', (SELECT frapi_result -> 'attribution');
RAISE DEBUG 'licence : %', (SELECT frapi_result -> 'licence');
RAISE DEBUG 'query : %', (SELECT frapi_result -> 'query');
RAISE DEBUG 'type : %', (SELECT frapi_result -> 'type');
RAISE DEBUG 'version : %', (SELECT frapi_result -> 'version');


RETURN frapi_result;

END
$BODY$
  LANGUAGE plpgsql VOLATILE;