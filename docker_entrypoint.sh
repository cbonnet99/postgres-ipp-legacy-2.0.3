#!/usr/bin/env bash
set -e

#POSTGRES_USER="docker"
#POSTGRES_PASSWORD="'docker'"

chown -R postgres:postgres /usr/local/pgsql
chmod -R 700 /usr/local/pgsql

su - postgres -c "
export PATH=$PATH:/usr/local/pgsql/bin &&\
echo \"export PATH=$PATH:/usr/local/pgsql/bin\" >> /home/postgres/.bashrc &&\
pg_ctl -w -D /usr/local/pgsql/data -l /usr/local/pgsql/data/logfile start &&\
if psql -t -c '\du' | cut -d \| -f 1 | grep -qw \"$POSTGRES_USER\"; then echo \"main db user already exists\"; else psql -h 127.0.0.1 --command \"CREATE USER $POSTGRES_USER WITH SUPERUSER PASSWORD $POSTGRES_PASSWORD;\"; fi
"

exec "$@";
