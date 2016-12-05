EXTENSION = frapi
DATA = frapi--dev.sql

TYPE := adresse_search
FUNCTION := get_url adresse_search_fomat adresse_search_json adresse_reverse_json adresse_search adresse_reverse

usage:
        
.PHONY : build
build : frapi--dev.sql
        @echo 'Building dev version'        

frapi--dev.sql : $(TYPE) $(FUNCTION)
        cat $(FUNCTION) > frapi--dev.sql.sql && cat $(TYPE) >> frapi--dev.sql.sql
        
PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)
