CREATE OR REPLACE FUNCTION frapi.get_url(
    url text,
    wait numeric,
	timeout numeric,
	tries integer DEFAULT 3)
  RETURNS text AS
$BODY$
#!/bin/sh
sleep $2 & wget -T $2 -t $4 -qO- "$1" & wait
$BODY$
LANGUAGE plsh VOLATILE;

CREATE TYPE frapi.adresse_search AS
   (id text,
    type text,
    score numeric,
    housenumber text,
    name text,
    postcode text,
    citycode text,
    city text,
    context text,
    label text,
    geom geometry(Point,4326)
);

CREATE OR REPLACE FUNCTION frapi.adresse_search_format(raw_result jsonb)
  RETURNS SETOF frapi.adresse_search AS
$BODY$
WITH result_array as (SELECT jsonb_array_elements_text( raw_result -> 'features')::jsonb f )

SELECT
(f #>> '{properties,id}')::text as adresse_id,
(f #>> '{properties,type}')::text as adresse_type,
(f #>> '{properties,score}')::numeric as adresse_score,
(f #>> '{properties,housenumber}')::text as adresse_housenumber,
(f #>> '{properties,name}')::text as adresse_name,
(f #>> '{properties,postcode}')::text as adresse_postcode,
(f #>> '{properties,citycode}')::text as adresse_citycode,
(f #>> '{properties,city}')::text as adresse_city,
(f #>> '{properties,context}')::text as adresse_context,
(f #>> '{properties,label}')::text as adresse_label,
ST_SetSRID(ST_GeomFromGeoJSON((f->'geometry')::text),4326)::geometry(Point,4326) as adresse_geom
FROM result_array;
$BODY$
LANGUAGE sql VOLATILE
  COST 120;

-- Function: frapi.adresse_search(text, integer, boolean, numeric, numeric, text, text, text)

-- DROP FUNCTION frapi.adresse_search(text, integer, boolean, numeric, numeric, text, text, text);

CREATE OR REPLACE FUNCTION frapi.adresse_search(q text, "limit" integer DEFAULT 1, autocomplete boolean DEFAULT true, lon numeric DEFAULT NULL::numeric, lat numeric DEFAULT NULL::numeric, type text DEFAULT NULL::text, postcode text DEFAULT NULL::text, citycode text DEFAULT NULL::text)
RETURNS SETOF frapi.adresse_search AS
$BODY$
DECLARE
frapi_query text;
frapi_wait numeric DEFAULT 0.1;
frapi_timeout numeric DEFAULT 3;
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

frapi_query :='http://api-adresse.data.gouv.fr/search/?'||frapi_q||frapi_limit||frapi_autocomplete||frapi_lonlat||frapi_type||frapi_postcode||frapi_citycode;
RAISE DEBUG 'frapi_query : %', frapi_query;


frapi_result := frapi.get_url(frapi_query,frapi_wait,frapi_timeout)::jsonb;

RAISE DEBUG 'attribution : %', (SELECT frapi_result -> 'attribution');
RAISE DEBUG 'licence : %', (SELECT frapi_result -> 'licence');
RAISE DEBUG 'query : %', (SELECT frapi_result -> 'query');
RAISE DEBUG 'type : %', (SELECT frapi_result -> 'type');
RAISE DEBUG 'version : %', (SELECT frapi_result -> 'version');


RETURN QUERY SELECT * FROM frapi.adresse_search_format(frapi_result);

END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 120;

CREATE OR REPLACE FUNCTION frapi.adresse_reverse( lon numeric, lat numeric, "limit" integer DEFAULT 1,  autocomplete boolean DEFAULT true,  type text DEFAULT NULL::text,  postcode text DEFAULT NULL::text,  citycode text DEFAULT NULL::text)
RETURNS SETOF frapi.adresse_search AS
$BODY$
DECLARE
frapi_query text;
frapi_wait numeric DEFAULT 0.1;
frapi_timeout numeric DEFAULT 3;
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


frapi_result := frapi.get_url(frapi_query,frapi_wait,frapi_timeout)::jsonb;

RAISE DEBUG 'attribution : %', (SELECT frapi_result -> 'attribution');
RAISE DEBUG 'licence : %', (SELECT frapi_result -> 'licence');
RAISE DEBUG 'query : %', (SELECT frapi_result -> 'query');
RAISE DEBUG 'type : %', (SELECT frapi_result -> 'type');
RAISE DEBUG 'version : %', (SELECT frapi_result -> 'version');


RETURN QUERY SELECT * FROM frapi.adresse_search_format(frapi_result);

END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 120;
  