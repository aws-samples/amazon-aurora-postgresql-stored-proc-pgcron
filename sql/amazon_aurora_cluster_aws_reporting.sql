-- DROP DATABASE TABLES IF EXISTS
-- ==============================
\echo 
\echo "==================REPORTING DATABASE============================"
\echo Drop employee table if it exists
drop table if exists employee;

-- REPORTING DATABASE TABLES
-- Create Employee Table 
-- =====================
\echo Create Employee table in the reporting database
create table employee
(
	employee_id int not null
		constraint employee_pk
			primary key,
	first_name varchar(30) not null,
	last_name varchar(30) not null,
	dob date not null,
	badge_id varchar(11) not null,
	salary decimal(10,2),
	dept_name varchar(30) not null
);
\echo Create Stored Procedure in the reporting database - employee
-- REPORTING STORED PROCEDURES
-- Create employee stored procedure
-- ====================================
create or replace procedure employee_sp ()
language plpgsql
as $procedure$

declare

    v_sql						text;				-- Used to build sql statement
    v_message					text;				-- Postgres error message
    v_error_exception 			text;				-- Postgres exception message
    v_error_hint 				text;				-- Postgres Hint to correct the error
    v_reporting_dbuser          text;               -- Reporting DB User
    v_proc_name         		text := 'employee';

begin

    -- Perform extract, transform and load on employee
	v_sql := 'insert into employee (employee_id,first_name,last_name,dob,badge_id,salary,dept_name)
			select employee_id, first_name, last_name,dob,replace(badge_id,''-'',''''),salary, dfdw.dept_name
			from employee_fdw efdw, department_fdw dfdw
			where efdw.dept_id = dfdw.dept_id
			and efdw.first_name is not null
			and efdw.last_name is not null
			and efdw.badge_id is not null
			and dfdw.dept_name is not null
			and efdw.salary>0';

    raise notice 'SQL: %', v_sql;
    execute v_sql;

exception
when others then
	GET STACKED DIAGNOSTICS v_message = MESSAGE_TEXT, v_error_exception	= PG_EXCEPTION_DETAIL, v_error_hint = PG_EXCEPTION_HINT;
	raise notice 'TIME:  % / PROCEDURE:  % / MESSAGE:  % / EXCEPTION:  % / HINT:  %',clock_timestamp(),v_proc_name,v_message,v_error_exception,v_error_hint;
	call error_handler_sp('TIME:  '||clock_timestamp()||' / PROCEDURE:  '||v_proc_name||' / MESSAGE:  '||v_message||' / EXCEPTION:  '||v_error_exception||' / HINT:  '||v_error_hint);
end;
$procedure$
;

\echo Create Stored Procedure in the reporting database - error_handler_sp
-- Create error_handler_sp stored procedure
-- ========================================
create or replace procedure error_handler_sp(p_error text)
    language plpgsql
as
$$
declare
    v_command text;
    v_status_code numeric(10);
begin

    p_error := regexp_replace(p_error,'"', '\"','g');

    create extension if not exists aws_lambda CASCADE;

    v_command := 'SELECT status_code FROM aws_lambda.invoke(aws_commons.create_lambda_function_arn(''ExceptionLambda''),'
                 ||'''{"error": "' || p_error || '" }''::json)';

    execute v_command into v_status_code;

exception
when others then
    raise notice '% %', SQLERRM, SQLSTATE;
end;
$$;
\echo "================================================"

\echo Create Stored Procedure in the reporting database - schedule_sp_job
-- Create schedule_sp_job stored procedure
-- ========================================
create or replace procedure schedule_sp_job()
language plpgsql
as
$$

declare
    v_sql text;
begin

    -- Create pg_cron job
    create extension if not exists pg_cron;

    -- Schedule dw_load job
    v_sql := 'select cron.schedule(''Execute employee_sp'',''*/10 * * * *'',''call public.employee_sp()'')'; 
    
    execute v_sql;

    exception
    when others then
        raise notice '% %', SQLERRM, SQLSTATE;
end;
$$;
\echo "================================================"