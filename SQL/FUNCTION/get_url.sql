-- Function: get_url(text, numeric, numeric, integer)

-- DROP FUNCTION get_url(text, numeric, numeric, integer);

CREATE OR REPLACE FUNCTION get_url(
    url text,
    wait numeric,
    timeout numeric,
    tries integer DEFAULT 3)
  RETURNS text AS
$BODY$
#!/bin/sh
sleep $2 & wget -T $3 -t $4 -qO- "$1" & wait
$BODY$
  LANGUAGE plsh VOLATILE;
