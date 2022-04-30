#! /bin/bash

export PGPASSWORD=$DBPASSWORD
psql -h${HOST} -p ${PORT} -U${DBUSER} -d ${DB} -f ../sql/amazon_aurora_cluster_aws_source.sql

export PGPASSWORD=$RPTDBPASSWORD
psql -h${RPTHOST} -p ${RPTDBPORT} -U${RPTDBUSER} -d ${RPTDB} -f ../sql/amazon_aurora_cluster_aws_reporting.sql

export PGPASSWORD=$RPTDBPASSWORD
psql -h${RPTHOST} -p ${RPTDBPORT} -U${RPTDBUSER} -d ${RPTDB} <<EOF
    create extension if not exists postgres_fdw;
    create server if not exists source_server foreign data wrapper postgres_fdw options (host '$HOST', port '$PORT', dbname '$DB');
    create foreign table if not exists employee_fdw (
                    employee_id integer ,
                    first_name text,
                    last_name text,
                    dob date ,
                    badge_id text,
                    salary numeric(10,2),
                    dept_id integer
                ) server source_server options (schema_name 'public', table_name 'employee');
    create foreign table if not exists department_fdw (
                dept_id integer,
                dept_name text
                ) server source_server options (schema_name 'public', table_name 'department');
    create user mapping if not exists for $RPTDBUSER
              server source_server
              options (user '$DBUSER', password '$DBPASSWORD');                
EOF

echo "================================================"