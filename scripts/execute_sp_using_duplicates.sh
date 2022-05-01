
export PGPASSWORD=$DBPASSWORD

psql -h${HOST} -p ${PORT} -U${DBUSER} -d ${DB} <<EOF
INSERT INTO public.employee (employee_id, first_name, last_name, dob, badge_id, salary, dept_id) 
            VALUES (1, 'DUP-John', 'Bosco', '1976-10-10', '891-90-9087', 9000.00, 1);
EOF

sh execute_sp.sh

psql -h${HOST} -p ${PORT} -U${DBUSER} -d ${DB} <<EOF
DELETE FROM public.employee WHERE first_name = 'DUP-John';
EOF
