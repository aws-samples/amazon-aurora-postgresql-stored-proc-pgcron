#! /bin/bash

export PGPASSWORD=$RPTDBPASSWORD
psql -h${RPTHOST} -p ${RPTDBPORT} -U${RPTDBUSER} -d ${RPTDB} <<EOF
    call schedule_sp_job()
EOF
