EXTENSION = frapi
DATA = $(wildcard *.sql)

FRAPI_SHARED := func_get_url
FRAPI_SHARED := $(addprefix SQL/SHARED/, $(addsuffix .sql, $(FRAPI_SHARED)))
FRAPI_ADRESSE := type_adresse_search func_adresse_search_format func_adresse_search_json func_adresse_reverse_json func_adresse_search func_adresse_reverse
FRAPI_ADRESSE := $(addprefix SQL/ADRESSE/, $(addsuffix .sql, $(FRAPI_ADRESSE)))

TESTS = $(wildcard TEST/SQL/*.sql)

usage:
	@echo 'pg_frapi usage : "make install" to instal the extension, "make build" to build dev version against source SQL'
	
.PHONY : build
build : frapi--dev.sql
	@echo 'Building develloper version'        

frapi--dev.sql : $(FRAPI_SHARED) $(FRAPI_ADRESSE)
	cat $(FRAPI_SHARED) > $@ && cat $(FRAPI_ADRESSE) >> $@

test:
	./bin/pg_prove --pset tuples_only=1 $(TESTS)

PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)
