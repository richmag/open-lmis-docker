#!/bin/sh

if [ -r open_lmis.custom ];
then
    echo "Loading open_lmis database..."
    dropdb -U postgres -h localhost open_lmis
    createdb -U postgres -h localhost open_lmis
    pg_restore --no-owner --no-acl open_lmis.custom | psql -U postgres -h localhost open_lmis -f -
    echo "... db loaded"
else
    echo "No database found to load, using default open_lmis"
fi
