/* Practicas tema 10 Oracle Academy */

-- 1

CREATE TABLE DEPT (
		ID		NUMBER(7) NOT NULL,
		NAME	VARCHAR2(25),
		CONSTRAINT dept_id_id_pk PRIMARY KEY (ID)
);

DESC DEPT;

COMMIT;

-- 2

INSERT INTO DEPT (ID, NAME)
	SELECT	DEPARTMENT_ID, DEPARTMENT_NAME
	FROM	DEPARTMENTS;
	
	
COMMIT;

SELECT * FROM DEPT;

-- 3

CREATE TABLE EMP (
		ID				NUMBER(7),
		LAST_NAME		VARCHAR(25),
		FIRST_NAME		VARCHAR(25),
		DEPT_ID			NUMBER(7),
			CONSTRAINT empl_dept_fk FOREIGN KEY (DEPT_ID)
				REFERENCES DEPT(ID)
);

DESC EMP;

COMMIT;

SELECT * FROM USER_CONSTRAINTS;

SELECT * FROM USER_TABLES;

-- 4

-- Opción 1 Manual

CREATE TABLE EMPLOYEES2 (
		ID				NUMBER(6)
			CONSTRAINT empl2_id_id_pk PRIMARY KEY,
		FIRST_NAME		VARCHAR2(20),
		LAST_NAME		VARCHAR2(25),
		SALARY			NUMBER(8,2),
		DEPT_ID			NUMBER(4),
			CONSTRAINT empl2_dept_fk FOREIGN KEY (DEPT_ID)
				REFERENCES DEPARTMENTS (DEPARTMENT_ID)

);

DESC EMPLOYEES2;

SELECT * FROM USER_CONSTRAINTS;

SELECT * FROM USER_TABLES;

COMMIT;

INSERT INTO EMPLOYEES2 (ID, FIRST_NAME, LAST_NAME, SALARY, DEPT_ID)
	SELECT	EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY, DEPARTMENT_ID
	FROM	EMPLOYEES;
	
SELECT * FROM EMPLOYEES2;

COMMIT;

-- SEGUNDA OPCION (MÁS POTENTE)

CREATE TABLE EMPLOYEES2
	AS
		SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY, DEPARTMENT_ID
		FROM EMPLOYEES;
		
-- OR

CREATE TABLE EMPLOYEES2
	AS
		SELECT EMPLOYEE_ID "ID", FIRST_NAME, LAST_NAME, SALARY, DEPARTMENT_ID "DEPT_ID"
		FROM EMPLOYEES;
		
COMMIT;

ALTER TABLE EMPLOYEES2
	RENAME COLUMN EMPLOYEE_ID TO ID;
	
ALTER TABLE EMPLOYEES2
	RENAME COLUMN DEPARTMENT_ID TO DEPT_ID;
	
COMMIT;
	 

-- 5

ALTER TABLE EMPLOYEES2 READ ONLY;
		
