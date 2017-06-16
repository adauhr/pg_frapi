#!/bin/bash
#Variation of pg-travis-test-sh by Peter Eisentraut to only install required packages and set up the db
#See : https://gist.github.com/petere/6023944#file-pg-travis-test-sh
set -eux

sudo apt-get update

packages="postgresql-$PGVERSION postgresql-server-dev-$PGVERSION postgresql-common postgresql-$PGVERSION-postgis-$POSTGISVERSION postgresql-$PGVERSION-pgtap postgresql-$PGVERSION-plsh libtap-parser-sourcehandler-pgtap-perl"

# bug: http://www.postgresql.org/message-id/20130508192711.GA9243@msgid.df7cb.de
sudo update-alternatives --remove-all postmaster.1.gz

# stop all existing instances (because of https://github.com/travis-ci/travis-cookbooks/pull/221)
sudo service postgresql stop
# and make sure they don't come back
echo 'exit 0' | sudo tee /etc/init.d/postgresql
sudo chmod a+x /etc/init.d/postgresql

sudo apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install $packages

status=0
sudo pg_createcluster --start $PGVERSION test -p 55435 -- -A trust
