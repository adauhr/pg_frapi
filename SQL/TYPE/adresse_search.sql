-- Type: adresse_search

-- DROP TYPE adresse_search;

CREATE TYPE adresse_search AS
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
