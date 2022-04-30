#! /bin/bash

export PGPASSWORD=$RPTDBPASSWORD
psql -h${RPTHOST} -p ${RPTDBPORT} -U${RPTDBUSER} -d ${RPTDB} 
