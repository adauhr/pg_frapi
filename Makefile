EXTENSION = frapi
DATA = $(wildcard .sql)

TYPE := adresse_search
TYPE := $(addprefix SQL/TYPE/, $(addsuffix .sql, $(TYPE)))
FUNCTION := get_url adresse_search_format adresse_search_json adresse_reverse_json adresse_search adresse_reverse
FUNCTION := $(addprefix SQL/FUNCTION/, $(addsuffix .sql, $(FUNCTION)))

usage:
	@echo 'pg_frapi usage : "make install" to instal the extension, "make build" to build dev version against source SQL'
	
.PHONY : build
build : frapi--dev.sql
	@echo 'Building develloper version'        

frapi--dev.sql : $(TYPE) $(FUNCTION)
	cat $(FUNCTION) > $@ && cat $(TYPE) >> $@
	
PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)
