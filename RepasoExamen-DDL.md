# DDL

file:///usr/share/doc/postgresql-doc-12/html/ddl.html 
file:///usr/share/doc/postgresql-doc-12/html/datatype.html
file:///usr/share/doc/postgresql-doc-12/html/queries.html
file:///usr/share/doc/postgresql-doc-12/html/functions.html

# 02.04.22 - PRACTICA POSTGRESQL

```sql
CREATE TABLE keshiclientes(
    idKeshi     smallint NOT NULL PRIMARY KEY,
    nom         varchar(20),
    data        date DEFAULT current_date,
    limit_credit    numeric(8,2)
);

keshi=> INSERT INTO keshiclientes (idkeshi) VALUES (1);
INSERT 0 1

keshi=> SELECT * FROM keshiclientes;
 idkeshi | nom |    data    | limit_credit 
---------+-----+------------+--------------
       1 |     | 2022-04-02 |             
(1 row)


CREATE TABLE keshipelicula(
    codPel      smallint PRIMARY KEY,
    titol       varchar(30),
    anyProd     smallint,
    nacionalitat    varchar(30),
    director        smallint NOT NULL,
    FOREIGN KEY(director) REFERENCES keshiclientes(idKeshi)
);

SAVEPOINT A;
```

```SQL
BEGIN; 

-- CREATE TABLE CON CONSTRAINT A NIVEL DE TABLA

CREATE TABLE keshiclientes2(
    idKeshi2     smallint NOT NULL,
	jefe		smallint NOT NULL,
    nom         varchar(20),
    data        date DEFAULT current_date,
    limit_credit    numeric(8,2),
	CONSTRAINT keshiclientes2_idKeshi2_jefe_pk PRIMARY KEY (idKeshi2, jefe)
);

SAVEPOINT B;

-- Con PRIMARY KEY en el CAMPO y DOBLE Foreign Key Compuesto

CREATE TABLE keshipelicula2(
	id		SMALLINT CONSTRAINT id_pk PRIMARY KEY,
    referencia      smallint NOT NULL,
    jefe		smallint NOT NULL,
	titol       varchar(30),
    anyProd     smallint,
    nacionalitat    varchar(30),
    director        smallint NOT NULL,
    CONSTRAINT keshipelicula2_referencia_jefe_fk FOREIGN KEY(referencia, jefe) REFERENCES keshiclientes2(idKeshi2, jefe)
);

SAVEPOINT C;


-- Constraint CHECK de letra capital
ALTER TABLE keshiclientes2 
	ADD CONSTRAINT keshiclientes2_nom_check CHECK (nom = initcap(nom));


SAVEPOINT D1;

CREATE TABLE keshiadmin(
    id      smallint,
    admin       smallint,
    anyProd     smallint,
    nacionalitat    varchar(30),
	CONSTRAINT keshiadmin_id_pk PRIMARY KEY (id)
);

-- Constraint recursiva para admin

ALTER TABLE ONLY keshiadmin ADD CONSTRAINT keshiadmin_admin_fk FOREIGN KEY(admin) REFERENCES keshiadmin(id);

SAVEPOINT D2;

-- COPIA DE LA TABLA "keshiclientes" como MIRROR - INHERITS

CREATE TABLE copyKeshiclientes(punts INTEGER)INHERITS (keshiclientes);

SAVEPOINT E;

COMMIT;

-- Prueba de Datatype

BEGIN;

CREATE TABLE dataType (
	id				SMALLINT CONSTRAINT dataType_id_pk PRIMARY KEY,
	autoincr		SERIAL,
	descrip			VARCHAR(20),
	jefe			SMALLINT,
	data			DATE DEFAULT current_date,
	actiu			BOOLEAN DEFAULT 'True',
	limit_credit	NUMERIC(8,2),
	edat			SMALLINT,
	parrafo			TEXT NOT NULL,
	hora			TIMESTAMP,
	CONSTRAINT dataType_edat_ck CHECK (edat>0)
);

-- A??adimos el Alter // No hay ALTER DE CONSTRAINTS

ALTER TABLE ONLY dataType ADD CONSTRAINT dataType_jefe_fk FOREIGN KEY (jefe) REFERENCES dataType(id) ON DELETE RESTRICT ON UPDATE CASCADE;

COMMIT;
```

```SQL

psql training;

-- CREATE TABLE A PARTIR DE SELECT

CREATE TABLE oficines_est 
    AS (SELECT oficina, ciutat, objectiu, vendes
          FROM oficines
         WHERE regio = 'Oest');

-- CREATE TABLE TEMPORAL


CREATE LOCAL TEMPORARY TABLE table2 ...; 


```

- Ejemplos

*No se puede eliminar o modificar un c??digo "editoriales" si existen libros con dicho "c??digo"*


*??Intentamos insertar una factura con un n??mero de cliente que no existe?*

*??Borramos un cliente que tiene una factura asignada?*

ON DELETE RESTRICT - ON UPDATE CASCADE --> No se puede borrar y si se modifica se cambia tambi??n

https://e-mc2.net/blog/integridad-referencial-con-postgresql/ 

Y accion puede tener estos valores:

    NO ACTION: Produce un error indicando que un DELETE ?? UPDATE crear?? una violaci??n de la clave for??nea definida.
    RESTRICT: Produce un error indicando que un DELETE ?? UPDATE crear?? una violaci??n de la clave for??nea definida.
    CASCADE: Borra ?? actualiza autom??ticamente todas las referencias activas
    SET NULL: Define las referencias activas como NULL
    SET DEFAULT: Define las referencias activas como el valor por defecto (si est?? definido) de las mismas

En nuestro ejemplo hemos definido que ninguna columna de nuestra clave for??nea puede ser NULL, que no se pueda borrar una clave for??nea con referencias activas y que en caso de actualizar el valor de una clave for??nea, se actualicen tambien todas las referencias a la misma autom??ticamente.

* Pol??tica a l'incomplir la integritat referencial

    ON DELETE: qu?? fer si trenquem integritat referencial en esborrar una fila de la taula referenciada.

    ON UPDATE: qu?? fer si trenquem integritat referencial en modificar una fila de la taula referenciada.

+ Possibles accions:

    RESTRICT: retorna un error i no es deixa fer l'operaci??.
    CASCADE: esborra o modifica les files afectades.
    SET DEFAULT: es posa el valor per defecte.
    SET NULL: es posa el valor a NULL.

```SQL
CREATE TABLE dataType (
	id				SMALLINT CONSTRAINT dataType_id_pk PRIMARY KEY,
	autoincr		SERIAL,
	descrip			VARCHAR(20),
	jefe			SMALLINT CONSTRAINT dataType_jefe_fk REFERENCES (id),
	data			DATE DEFAULT current_date,
	actiu			BOOLEAN DEFAULT 'True',
	limit_credit	NUMERIC(8,2),
	edat			SMALLINT,
	parrafo			TEXT NOT NULL,
	hora			TIMESTAMP,
	CONSTRAINT dataType_edat_ck CHECK (edat>0)


);
```

# ALTER CON CONSTRAINTS + INTEGRIDAD

* A??ade una columna o un constraint

ALTER TABLE *nombreTabla*
ADD [COLUMN] [CONSTRAINT] *ACTION*


* Modifica una columna

ALTER TABLE *nombreTabla*
ALTER [COLUMN] *nombreColumna*

* Borra una columna o constraint

ALTER TABLE *nombreTabla*
DROP [COLUMN] [CONSTRAINT] *nombreColumna* O *nombreConstraint*

* Cambia el nombre de la columna o constraint

ALTER TABLE *nombreTabla*
RENAME [COLUMN] [CONSTRAINT] *col_name* o *constraint_name* TO

* Modifica el TIPO DE DATO de la COLUMNA
ALTER TABLE *nombreTabla*
ALTER [COLUMN] *nombreColumna* SET DATA TYPE *data_type*

```SQL
BEGIN;

ALTER TABLE datatype RENAME actiu TO hola;

ALTER TABLE datatype ALTER COLUMN hola DROP DEFAULT;

ALTER TABLE datatype ALTER COLUMN hola SET DATA TYPE varchar(20); 

-- To add a column with a non-null default:

ALTER TABLE datatype
  ADD COLUMN mtime timestamp with time zone DEFAULT now();

-- To add a column and fill it with a value different from the default to be used later:

ALTER TABLE datatype
  ADD COLUMN status varchar(30) DEFAULT 'old',
  ALTER COLUMN status SET default 'current';

ROLLBACK;
```

* To add a not-null constraint to a column:

ALTER TABLE distributors ALTER COLUMN street SET NOT NULL;

* To remove a not-null constraint from a column:

ALTER TABLE distributors ALTER COLUMN street DROP NOT NULL;

<br>
<br>

OTROS EJEMPLOS

   ADD [ COLUMN ] [ IF NOT EXISTS ] column_name data_type [ COLLATE collation ] [ column_constraint [ ... ] ]

    DROP [ COLUMN ] [ IF EXISTS ] column_name [ RESTRICT | CASCADE ]

    ALTER [ COLUMN ] column_name [ SET DATA ] TYPE data_type [ COLLATE collation ] [ USING expression ]

    ALTER [ COLUMN ] column_name SET DEFAULT expression

    ALTER [ COLUMN ] column_name DROP DEFAULT

    ALTER [ COLUMN ] column_name { SET | DROP } NOT NULL

    ALTER [ COLUMN ] column_name DROP EXPRESSION [ IF EXISTS ]

    ALTER [ COLUMN ] column_name ADD GENERATED { ALWAYS | BY DEFAULT } AS 

	IDENTITY [ ( sequence_options ) ]

    ALTER [ COLUMN ] column_name { SET GENERATED { ALWAYS | BY DEFAULT } | SET sequence_option | RESTART [ [ WITH ] restart ] } [...]

    ALTER [ COLUMN ] column_name DROP IDENTITY [ IF EXISTS ]

    ALTER [ COLUMN ] column_name SET STATISTICS integer

    ALTER [ COLUMN ] column_name SET ( attribute_option = value [, ... ] )

    ALTER [ COLUMN ] column_name RESET ( attribute_option [, ... ] )

    ALTER [ COLUMN ] column_name SET STORAGE { PLAIN | EXTERNAL | EXTENDED | MAIN }
    ALTER [ COLUMN ] column_name SET COMPRESSION compression_method
    ADD table_constraint [ NOT VALID ]
    ADD table_constraint_using_index
    ALTER CONSTRAINT constraint_name [ DEFERRABLE | NOT DEFERRABLE ] [ INITIALLY DEFERRED | INITIALLY IMMEDIATE ]
    VALIDATE CONSTRAINT constraint_name
    DROP CONSTRAINT [ IF EXISTS ]  constraint_name [ RESTRICT | CASCADE ]
    DISABLE TRIGGER [ trigger_name | ALL | USER ]
    ENABLE TRIGGER [ trigger_name | ALL | USER ]
    ENABLE REPLICA TRIGGER trigger_name
    ENABLE ALWAYS TRIGGER trigger_name
    DISABLE RULE rewrite_rule_name
    ENABLE RULE rewrite_rule_name
    ENABLE REPLICA RULE rewrite_rule_name
    ENABLE ALWAYS RULE rewrite_rule_name
    DISABLE ROW LEVEL SECURITY
    ENABLE ROW LEVEL SECURITY
    FORCE ROW LEVEL SECURITY
    NO FORCE ROW LEVEL SECURITY
    CLUSTER ON index_name
    SET WITHOUT CLUSTER
    SET WITHOUT OIDS
    SET TABLESPACE new_tablespace
    SET { LOGGED | UNLOGGED }
    SET ( storage_parameter [= value] [, ... ] )
    RESET ( storage_parameter [, ... ] )
    INHERIT parent_table
    NO INHERIT parent_table
    OF type_name
    NOT OF
    OWNER TO { new_owner | CURRENT_ROLE | CURRENT_USER | SESSION_USER }
    REPLICA IDENTITY { DEFAULT | USING INDEX index_name | FULL | NOTHING }


# CHECKS

```sql

-- Crear constraints con CHECK

-- Constraint de Check de Nombre empieza por Nombre Capital
CONSTRAINT CK_REP_VENDES_NOM CHECK(NOM = INITCAP(NOM)),

-- Constraint de CHECK de EDAT sea mayor que 0
CONSTRAINT CK_REP_VENDES_EDAT CHECK(EDAT>0),

-- Constraint de CHECK de Ventas sean mayor que 0
CONSTRAINT CK_REP_VENDES_VENDES CHECK(VENDES>0),

-- Constraint de CHECK de Cuota sean mayor que 0
CONSTRAINT CK_REP_VENDES_QUOTA CHECK(QUOTA>0),
```

# Primary Key

### SIMPLE
```sql
	CREATE TABLE dept (
		deptno	SMALLINT CONSTRAINT dept_deptno_pk PRIMARY KEY,
		dname		VARCHAR(14),
		loc		VARCHAR(13)
	);
```
```sql
	CREATE TABLE dept (
		PRIMARY KEY(deptno),
        deptno	SMALLINT,
		dname		VARCHAR(14),
		loc		VARCHAR(13)
	);
```
```sql
	CREATE TABLE dept (
		deptno	SMALLINT,
		dname		VARCHAR(14),
		loc		VARCHAR(13),
        CONSTRAINT dept_deptno_pk PRIMARY KEY (deptno)
    );
```

- Les sent??ncies SQL que usarem s??n:

	+ CREATE (crea)
	+ DROP (esborra)
	+ ALTER (modifica)

### COMPUESTA
```sql
	CREATE TABLE dept (
		deptno	SMALLINT,
        deptno2 SMALLINT,
		dname		VARCHAR(14),
		loc		VARCHAR(13)
        CONSTRAINT dept_deptno_pk_pk PRIMARY KEY (deptno, deptno2)
    );
```
# FOREIGN KEY

### SIMPLE a nivel de columna
```sql
	CREATE TABLE emp (
		PRIMARY KEY(empno),
		empno		SMALLINT,
		ename		VARCHAR(10),
		job		VARCHAR(9),
		mgr		SMALLINT,
		hiredate	DATE,
		sal		NUMERIC(7, 2),
		comm		NUMERIC(7, 2),
		deptno	SMALLINT		REFERENCES dept
	);
```
### SIMPLE a nivel de tabla with CONSTRAINT
```sql
	CREATE TABLE emp (
		PRIMARY KEY(empno),
		empno 	SMALLINT,
		ename 	VARCHAR(10),
		job 		VARCHAR(9),
		mgr 		SMALLINT,
		hiredate	DATE,
		sal 		NUMERIC(7, 2),
		comm 		NUMERIC(7, 2),
		deptno	SMALLINT,
 				CONSTRAINT emp_deptno_fk REFERENCES dept(deptno)
	);
```

### COMPUESTA

```sql
  ADD CONSTRAINT producte_del_pedido 
      FOREIGN KEY (fabricant, producte) REFERENCES productes(id_fabricant, id_producte)
```

* Si tenemos error

```sql
ALTER TABLE  emp
ADD CONSTRAINT emp_mgr_fk FOREIGN KEY (mgr) REFERENCES emp(empno);
```

# Pol??tica a l'incomplir la integritat referencial


* ON DELETE: qu?? fer si trenquem integritat referencial en esborrar una fila de la taula referenciada.

    Permite que se borre todo - ON DELETE CASCADE

    No permite que se borre todo - ON DELETE RESTRICT

* ON UPDATE: qu?? fer si trenquem integritat referencial en modificar una fila de la taula referenciada.

    Permite que se modifique todo - ON UPDATE CASCADE

    No permite que se modifique todo - ON UPDATE RESTRICT

Possibles accions:

* RESTRICT: retorna un error i no es deixa fer l'operaci??.

* CASCADE: esborra o modifica les files afectades.

* SET DEFAULT: es posa el valor per defecte.

* SET NULL: es posa el valor a NULL.

# HERENCIA
```sql
keshi=> CREATE TABLE keshiclientesVIP (
keshi(>    punts INTEGER
keshi(> )INHERITS(keshiclientes);
CREATE TABLE
```
# Creaci?? d'una taula a partir d'una consulta 
```sql
CREATE TABLE oficines_est 
    AS (SELECT oficina, ciutat, objectiu, vendes
          FROM oficines
         WHERE regio = 'Oest');
```

# Creaci?? d'una taula temporal

```sql
CREATE LOCAL TEMPORARY TABLE table2 ...;
```

# Eliminaci?? de taules

```sql
DROP TABLE taula
```

# Eliminaci?? de taules de forma efica??

```sql
TRUNCATE TABLE taula
```

# ALTER

### A??ADIR UN CAMPO
```sql
ALTER TABLE oficines 
  ADD telefon varchar(9);

### MODIFICAR UN CAMPO
```sql
ALTER TABLE oficines 
ALTER telefon varchar(20);
```

### BORRAR UN CAMPO
```sql
ALTER TABLE oficines 
 DROP telefon;
```

### A??ADIR UN CONSTRAINT
```sql
ALTER TABLE oficines
  ADD CHECK(ciutat <> 'Barcelona')
```
O amb nom:
```sql
ALTER TABLE oficines
  ADD CONSTRAINT oficines_ciutat_ck CHECK(ciutat <> 'Badalona')
```
### RENAME COLUMNA
```sql
ALTER TABLE table_name 
RENAME COLUMN column_name 
TO new_column_name;
```

### To change a default value of the column, you use ALTER TABLE ALTER COLUMN SET DEFAULT or  DROP DEFAULT:
```sql
ALTER TABLE table_name 
ALTER COLUMN column_name 
[SET DEFAULT value | DROP DEFAULT];
```
### To change the NOT NULL constraint, you use ALTER TABLE ALTER COLUMN statement:
```sql
ALTER TABLE table_name 
ALTER COLUMN column_name 
[SET NOT NULL| DROP NOT NULL];
```
### To add a CHECK constraint, you use ALTER TABLE ADD CHECK statement:
```sql
ALTER TABLE table_name 
ADD CHECK expression;
```
### Generailly, to add a constraint to a table, you use ALTER TABLE ADD CONSTRAINT statement:
```sql
ALTER TABLE table_name 
ADD CONSTRAINT constraint_name constraint_definition;
```
### To rename a table you use ALTER TABLE RENAME TO statement:
```sql
ALTER TABLE table_name 
RENAME TO new_table_name;
```

### PostgreSQL ALTER TABLE examples

```sql
DROP TABLE IF EXISTS links;

CREATE TABLE links (
   link_id serial PRIMARY KEY,
   title VARCHAR (512) NOT NULL,
   url VARCHAR (1024) NOT NULL
);
```

### To add a new column named active, you use the following statement:

```sql
ALTER TABLE links
ADD COLUMN active boolean;
```

### The following statement removes the activecolumn from the linkstable:

```sql
ALTER TABLE links 
DROP COLUMN active;
```

### To change the name of the title column to link_title, you use the following statement:

```sql
ALTER TABLE links 
RENAME COLUMN title TO link_title;
```

### The following statement adds a new column named targetto the linkstable:

```sql
ALTER TABLE links 
ADD COLUMN target VARCHAR(10);
```

### To set _blank as the default value for the targetcolumn in the linkstable, you use the following statement:

```sql
ALTER TABLE links 
ALTER COLUMN target
SET DEFAULT '_blank';
```


# EJERCICIOS


Crear una base de dades anomenada "biblioteca". Dins aquesta base de dades:

crear una taula anomenada llibres amb els camps seg??ents:



"ref": clau primaria num??rica que identifica els llibres i s'ha d'assignar autom??ticament.

"titol": t??tol del llibre.

"editorial": nom de l'editorial.

"autor": identificador de l'autor, clau forana, per defecte ha de

referenciar a primer valor de la taula autors que simbolitzar l'autor "An??nim".

Crear la taula LLIBRE

```sql
CREATE TABLE llibres (
    ref         SERIAL,
    titol       VARCHAR(100)    NOT NULL,
    editorial   VARCHAR(50),
    autor       INT             NOT NULL    
                                DEFAULT 1,
    CONSTRAINT ref_pk PRIMARY KEY (ref),
    CONSTRAINT autor_fk FOREIGN KEY (autor) REFERENCES autors(autor) ON DELETE SET DEFAULT ON UPDATE RESTRICT
);
```

### Exercici 5

* A la base de dades training crear una taula temporal que substitueixi la taula "clients" per?? nom??s ha de contenir aquells clients que no han fet comandes i tenen assignat un representant de vendes amb unes vendes inferiors al 110% de la seva quota.

```sql
CREATE LOCAL TEMPORARY TABLE clients2 AS (
	SELECT num_clie FROM clients 
	WHERE num_clie NOT IN (
		SELECT clie
		FROM comandes
		) AND rep_clie = ANY (
				SELECT num_empl 
				FROM rep_vendes 
				WHERE vendes < (quota*1.1)
			)	
);
SELECT 4
```

* v2

```sql
CREATE LOCAL TEMPORARY TABLE clients AS (
    SELECT * 
      FROM clients
     WHERE num_clie NOT IN
           (SELECT clie 
              FROM comandes)
       AND rep_clie IN
           (SELECT num_empl 
              FROM rep_vendes 
             WHERE vendes < 1.1 * quota)
);
```



* Escriu les sent??ncies necess??ries per a crear l'estructura de l'esquema proporcionat de la base de dades training. Justifica les accions a realitzar en modificar/actualitzar les claus prim??ries.

```sql
CREATE TABLE clients (
	PRIMARY KEY(num_clie),
	num_clie        SMALLINT,
	empresa         VARCHAR(20)		NOT NULL,
	rep_clie        SMALLINT		NOT NULL DEFAULT 106, -- entenem que Sam Clark ??s el cap de l'empresa
	limit_credit    NUMERIC(8,2)
);
```



```sql
CREATE TABLE oficines (
	PRIMARY KEY(oficina),
	oficina     SMALLINT,
	ciutat      VARCHAR(15)		NOT NULL,
	regio       VARCHAR(10)		NOT NULL,
	director    SMALLINT,
	objectiu    NUMERIC(9,2),
	vendes      NUMERIC(9,2)	NOT NULL
);
```

```sql
CREATE TABLE comandes (
	PRIMARY KEY(num_comanda),
	num_comanda     INTEGER,
	data            DATE            NOT NULL,
	clie            SMALLINT        NOT NULL,
	rep             SMALLINT,
	fabricant       CHARACTER(3)    NOT NULL,
	producte        CHARACTER(5)    NOT NULL,
	quantitat       SMALLINT        NOT NULL,
	import          NUMERIC(7,2)    NOT NULL
);
```



```sql
CREATE TABLE productes (
	PRIMARY KEY(id_fabricant, id_producte),
	id_fabricant	CHARACTER(3),
	id_producte		CHARACTER(5),
	descripcion		CHARACTER varying(20)   NOT NULL,
	preu			NUMERIC(7,2)            NOT NULL,
	estoc			INTEGER                 NOT NULL
);
```

```sql
CREATE TABLE rep_vendes (
	PRIMARY KEY(num_empl),
	num_empl        SMALLINT,
	nom             VARCHAR(15)     NOT NULL,
	edat            SMALLINT,
	oficina_rep     SMALLINT,
	carrec          VARCHAR(10),
	data_contracte  DATE            NOT NULL,
	cap             SMALLINT        DEFAULT 106,
	quota           NUMERIC(8,2),
	vendes          NUMERIC(8,2)    NOT NULL
);
```

### ALTERS

```sql
ALTER TABLE clients
  ADD CONSTRAINT representant_del_client 
      FOREIGN KEY (rep_clie) REFERENCES rep_vendes(num_empl)
      ON DELETE SET DEFAULT -- Si un representant desapareix, el client tindr?? assignat el representant per defecte que ??s el cap de l'empresa (que en teoria mai desapareixer?? :D)
      ON UPDATE CASCADE; -- Si un representant canvia de codi, canviarem tamb?? el codi en el client
```

```sql
ALTER TABLE oficines
  ADD CONSTRAINT director_de_l_oficina 
      FOREIGN KEY (director) REFERENCES rep_vendes(num_empl)
      ON DELETE SET NULL -- Si un representant desapareix, l'oficina quedar?? temporalment sense director
      ON UPDATE CASCADE; -- Si un representant canvia de codi, canviarem tamb?? el codi a l'oficina
```



```sql
ALTER TABLE comandes
  ADD CONSTRAINT client_que_ha_fet_comanda 
      FOREIGN KEY (clie) REFERENCES clients(num_clie)
      ON DELETE CASCADE -- Si s'esborra un client, esborrem totes les seves comandes
      ON UPDATE CASCADE, -- Si un client canvia de codi, canviarem tamb?? el codi en la comanda
  ADD CONSTRAINT representant_que_ha_ates_comanda 
      FOREIGN KEY (rep) REFERENCES rep_vendes(num_empl)
      ON DELETE SET NULL -- Si s'esborra un representant, posarem les comandes que va fer a NULL, per tal de no perdre la comanda
      ON UPDATE CASCADE, -- Si un representant canvia de codi, canviarem tamb?? el codi en la comanda
  ADD CONSTRAINT producte_del_pedido 
      FOREIGN KEY (fabricant, producte) REFERENCES productes(id_fabricant, id_producte)
      ON DELETE CASCADE -- Si s'esborra el producte, esborrem les comandes amb aquest producte
      ON UPDATE CASCADE; -- Si un producte canvia de codi, canviarem tamb?? el codi en la comanda

-- Atenci??, aquesta sent??ncia donar?? error perqu?? hi ha una comanda que trenca la integritat referencial.

```

```sql
ALTER TABLE rep_vendes
  ADD CONSTRAINT oficina_on_treballa_representant 
      FOREIGN KEY (oficina_rep) REFERENCES oficines(oficina)
      ON DELETE SET NULL -- Si s'esborra l'oficina, el representant es queda temporalment sense oficina assignada
      ON UPDATE CASCADE, -- Si l'oficina canvia de codi, canviarem tamb?? el codi al representant
  ADD CONSTRAINT cap_del_representant
      FOREIGN KEY (cap) REFERENCES rep_vendes(num_empl)
      ON DELETE SET DEFAULT -- Si s'esborra el cap s'assignaicina, el representant es queda temporalment sense oficina assignada
      ON UPDATE CASCADE; -- Si l'oficina canvia de codi, canviarem tamb?? el codi al representant
```


### Exercici 7

* Escriu una sent??ncia que permeti modificar la base de dades training proporcionada. Cal que afegeixi un camp anomenat "nif" a la taula "clients" que permeti emmagatzemar el NIF de cada client. Tamb?? s'ha de procurar que el NIF de cada client sigui ??nic.

```sql
ALTER TABLE clients 
  ADD nif VARCHAR(9) UNIQUE;
```



```sql
ALTER TABLE clients
  ADD nif CHAR(9) UNIQUE CHECK (nif LIKE '_________'); -- hi ha 9 underscores
```

* Escriu les sent??ncies necess??ries per modificar la base de dades training proporcionada. Cal que s'impedeixi que els noms dels representants de vendes i els noms dels clients estiguin buits, ??s a dir que ni siguin nuls ni continguin la cadena buida.

```sql
ALTER TABLE rep_vendes 
  ADD constraint rep_nom_ck CHECK (nom <> '' OR nom IS NOT NULL);
```



```sql
ALTER TABLE clients 
  ADD constraint cli_empresa_ck CHECK (empresa <> '' OR empresa IS NOT NULL);
```

* Escriu una sent??ncia que permeti modificar la base de dades training proporcionada. Cal que esborri el camp "carrec" de la taula "rep_vendes" esborrant tamb?? les possibles restriccions i refer??ncies que tingui.

```sql
ALTER TABLE rep_vendes 
  DROP carrec CASCADE;
```

```sql

```



```sql

```



```sql

```

```sql

```


```sql

```



```sql

```

```sql

```