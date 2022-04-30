#! /bin/bash

export PGPASSWORD=$DBPASSWORD
psql -h${HOST} -p ${PORT} -U${DBUSER} -d ${DB}

