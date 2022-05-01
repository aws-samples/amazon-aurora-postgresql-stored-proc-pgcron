-- DROP DATABASE TABLES IF EXISTS
-- ==============================
\echo 
\echo "==================SOURCE DATABASE=============================="
\echo Drop employee and department tables if they exists
drop table if exists employee;
drop table if exists department;

-- SOURCE DATABASE TABLES
-- Create Employee Table
-- =====================
\echo Create Employee table in the source database
create table employee
(
	employee_id int,
	first_name varchar(30),
	last_name varchar(30),
	dob date,
	badge_id varchar(11),
	salary decimal(10,2),
	dept_id numeric(2)
);

-- Create Department Table
-- =======================

\echo Create Department table in the source database
create table department
(
	dept_id int not null
		constraint department_pk
			primary key,
	dept_name varchar(30)
);

-- Insert Records in the source tables
-- ===================================
\echo 
\echo Inserting records into <source> employee table BEGIN
INSERT INTO public.employee (employee_id, first_name, last_name, dob, badge_id, salary, dept_id) VALUES (1, 'John', 'Bosco', '1976-10-10', '891-90-9087', 9000.00, 1);
INSERT INTO public.employee (employee_id, first_name, last_name, dob, badge_id, salary, dept_id) VALUES (2, 'Steve', 'Farnham', '1972-10-11', '691-90-9987', 7000.00, 2);
INSERT INTO public.employee (employee_id, first_name, last_name, dob, badge_id, salary, dept_id) VALUES (3, 'David', 'Hudson', '1969-10-01', '707-90-1098', 12000.00, 1);
INSERT INTO public.employee (employee_id, first_name, last_name, dob, badge_id, salary, dept_id) VALUES (4, 'Vishwanath Prathap', 'Singh', '1991-11-01', '907-99-7012', 14000.00, 3);
INSERT INTO public.employee (employee_id, first_name, last_name, dob, badge_id, salary, dept_id) VALUES (5, 'Ceti', 'Jose', '1980-10-12', '190-99-7012', 15000.00, 1);
INSERT INTO public.employee (employee_id, first_name, last_name, dob, badge_id, salary, dept_id) VALUES (6, 'Bob', null, null, '190-99-7012', 15000.00, 1);
\echo Inserting records into <source> employee table END

\echo Inserting records into  <source> department table BEGIN
INSERT INTO public.department (dept_id, dept_name) VALUES (1, 'Information Technology');
INSERT INTO public.department (dept_id, dept_name) VALUES (2, 'Human Resources');
INSERT INTO public.department (dept_id, dept_name) VALUES (3, 'Finance');
\echo Inserting records into  <source> department table END