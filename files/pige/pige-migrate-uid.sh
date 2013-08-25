#!/bin/sh

# /srv/pige/records is fixed by puppet
# let's check subdirectories too

directories=`find /srv/pige/records -maxdepth 1 -type d -not -uid 2030`

if [ -n "$directories" ]; then
    echo "Migrate pige uid"
    chown -R pige:pige /srv/pige/records
fi
