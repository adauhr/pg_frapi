-- Function: adresse_search_format(jsonb)

-- DROP FUNCTION adresse_search_format(jsonb);

CREATE OR REPLACE FUNCTION adresse_search_format(raw_result jsonb)
  RETURNS SETOF adresse_search AS
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
  LANGUAGE sql VOLATILE;