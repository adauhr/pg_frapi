-- Type: adresse_search

-- DROP TYPE @extschema@.adresse_search;

CREATE TYPE @extschema@.adresse_search AS
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
    geom geometry(Point,4326));
