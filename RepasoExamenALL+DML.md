# Subconsultas

IN = a alguno de los valores que hay alguna lista. True si es igual.

El operador **IN** es equivalente a **= ANY**

ANY --> Compara los valores y si alguno es true, la comparación es true.

ALL

### Empleats que son cap


```sql
select nom
	from rep_vendes rv 
	where num_empl in 
		(select cap from rep_vendes rv2);
```


### Empleats que NO son cap


```sql
select nom
	from rep_vendes rv 
	where num_empl not in 
		(select cap from rep_vendes rv2);
```


# Consultas simples

# Alias AS o "alias"

# Concatenación con || || ||


```sql
SQL> SELECT ename ||' '||'is a'||' '||job
AS “Detall d’empleats"
FROM emp;
```

# EXTRACT


```sql
SELECT nom, data_contracte
FROM rep_vendes
WHERE extract(year from data_contracte) < 1988;
```


# DATE PART


```sql
SELECT nom, data_contracte 
FROM rep_vendes 
WHERE date_part('year', data_contracte) < 1988;
```


# LIKE

* Identificador del fabricant, identificador del producte i descripció del producte d'aquells productes que el seu identificador de fabricant acabi amb la lletra i.


```sql
SELECT id_fabricant, id_producte, descripcio
FROM productes
WHERE id_fabricant LIKE '%i';
```


* Fabricant, producte i preu dels productes on el seu identificador comenci per 4 acabi per 3 i contingui tres caracters entre mig.


```sql
SELECT id_fabricant, id_producte, preu
FROM productes 
WHERE id_producte like '4___3';
```


* Identificador dels clients, el nom dels quals no conté la cadena " Mfg." o " Inc." o " Corp." i que tingui crèdit major a 30000.


```sql
SELECT num_clie,empresa FROM clientes 
WHERE (empresa NOT LIKE '%Corp.%' AND empresa NOT LIKE '%Inc.%' AND empresa NOT LIKE '%Mfg.%') AND limite_credito > 30000;
```


# IN

* Identificador i nom dels venedors que treballen a les oficines 11 o 13.


```sql
SELECT num_empl, nom
FROM rep_vendes
WHERE oficina_rep IN(11,13);
```


o


```sql
SELECT num_empl, nom
FROM rep_vendes
WHERE oficina_rep = 11 OR oficina_rep = 13;
```


# Operadores lógicos

* Identificadors i noms dels venedors amb vendes entre el 80% i el 120% de llur quota.


```sql
SELECT num_empl,nom
FROM rep_vendes
WHERE vendes > 80 * quota / 100 AND vendes < 120 * quota / 100;
```


# FETCH ES COMO LIMIT


* Codi i nom dels tres venedors que tinguin unes vendes superiors.

```sql
SELECT num_empl,nom
FROM rep_vendes
ORDER BY vendes DESC
FETCH FIRST 3 ROWS ONLY;
```

```sql
SELECT num_empl,nom
FROM rep_vendes
ORDER BY vendes DESC
LIMIT 3;
```

# Between

* Excloent els extrems no podem fer servir BETWEEN:

```sql
SELECT num_comanda, data, fabricant,producte, import
FROM comandes
WHERE data BETWEEN '1989-09-01' AND '1989-12-31';

```

```sql
SELECT num_comanda, data, fabricant,producte, import
FROM comandes
WHERE data > '1989-09-01' AND  data < '1989-12-31';
```


# Ejercicios varios

* Identificador i descripció dels productes del fabricant identificat per imm dels quals hi hagi estoc superior o igual a 200, també del fabricant bic amb estoc superior o igual a 50.


```sql
SELECT id_fabricant, id_producte, descripcio, estoc FROM productes WHERE id_fabricant = 'imm' AND estoc >= 200 OR id_fabricant = 'bic' AND estoc >= 50;
```


* Identificador i nom dels venedors que treballen a les oficines 11, 12 o 22 i compleixen algun dels següents supòsits:

    han estat contractats a partir de juny del 1988 i no tenen cap

    estan per sobre la quota però tenen vendes de 600000 o menors.


```sql
SELECT num_empl, nom, oficina_rep, data_contracte, cap, quota, vendes
FROM rep_vendes
WHERE oficina_rep IN(22,11,12)
AND ( data_contracte >= '1988-6-1' AND cap IS NULL 
OR
vendes > quota AND vendes <= 600000);
```






# UNON

* Elimina las filas duplicadas

* Puede servir para 2 o más consultas.

* Tienen que tener el mismo numero de columnas en la consulta.

* Los datos introducidos en cada UNION tienen que ser la **MISMA**.

```sql
SELECT id_fabricant, id_producte
FROM productes
WHERE preu < 70
UNION
SELECT  DISTINCT fabricant, producte
FROM comandes
WHERE import > 20000 order by 1 DESC, 2 ;
```



* Feu una consulta que mostri les oficines que tinguin un treballador que sigui director de vendes i les oficines que siguin de la regió Est i ordenat.

```sql
SELECT DISTINCT oficina_rep 
FROM rep_vendes
WHERE carrec = 'Dir Vendes'
UNION
SELECT oficina
FROM oficines
WHERE regio = 'Est' order by 1;


```sql
 oficina_rep 
-------------
          11
          12
          13
          21
(4 rows)
```

# UNION ALL

* No elimina las filas duplicadas



# Examen consultas simples

* Llisteu la descripció i l'estoc dels productes amb un preu superior a 100 i que compleixin tots els següents supòsits:

    L'identificador del fabricant comenci per la lletra q o bé l'estoc sigui inferior o igual a 100.

    L'estoc sigui superior a 100 o bé la descripció del producte acabi amb les lletres Tm.


```sql
	SELECT descripcio, estoc
	  FROM productes
	 WHERE preu > 100
	   AND ( id_fabricant LIKE 'q%' OR estoc <= 100)
	   AND ( estoc > 100 OR descripcio LIKE '%Tm');
```


* Llisteu l'identificador, la data i l'import de les comandes anteriors a l'11 de gener de 1990 i que compleixin algun dels següents supòsits:

    La quantitat de la comanda sigui superior o igual a 20 i l'identificador del fabricant sigui aci.

    L'import de la comanda sigui superior a 10000 i sigui del client número 2114.


```sql
	SELECT num_comanda, data, import
	  FROM comandes
	 WHERE data < '1990-01-11'
	   AND ( quantitat >= 20 AND fabricant = 'aci' OR import > 10000 AND clie = 2114 ); 
```



* Llisteu l'identificador i el nom dels representants de vendes que no tinguin un director assignat o que no tinguin una quota assignada. 

* També s'han de llistar aquells que les seves vendes no hagin superat la seva quota.

```sql
SELECT num_empl, nom
  FROM rep_vendes
 WHERE cap IS NULL
    OR quota IS NULL
    OR vendes <= quota;
```


# JOIN

* 

    Utilitzem la clàusula JOIN per a consultar dades que es troben en més d’una taula.

    És una reunió o composició de les files d’una taula amb les d’una altra.


```sql
SELECT taula1.columna1, taula2.columna2
FROM taula1 [INNER] JOIN taula2
ON taula1.clau_forana = taula2.clau_primaria;
```

# CROSS JOIN 

* CROSS JOIN

    Producto cartesiano - Forma explícita o implícita

    Se unen campos de dos tablas o más tablas.


```sql

```

# INNER JOIN O WHERE

* INNER JOIN O WHERE

    JOIN sólo se produce cuando las filas cumplen con la clausula ON

FORMA EXPLÍCITA

```sql
SELECT * FROM propietaris INNER JOIN gats 
ON gats.propietari = propietaris.id;
```

FORMA EMPLÍCITA

```sql
SELECT * FROM propietaris, gats WHERE gats.propietari = propietaris.id;
```

# ALIAS

    Ayudan a simplificar


```sql
SELECT e.empno, e.ename, e.deptno,
d.deptno, d.loc
FROM emp e JOIN dept d
ON e.deptno = d.deptno;
```


# OUTER JOIN

* S’utilitza per afegir, al resultat, les files de la taula que vulguem (left, right o les dues) que NO acompleixen la condició del JOIN. ● Left join ● Rigth join* ● Full join



```sql
SELECT taula1.columna1, taula2.columna2
FROM taula1 LEFT [OUTER] JOIN taula2
ON taula1.clau_forana = taula2.clau_primaria;
```

* ON taula1.clau_forana = taula2.clau_primaria;

    Un RIGHT JOIN sempre es pot expressar com un LEFT JOIN,

    És suficient canviar l’ordre de les taules, però quan hi ha més de dues taules podria resultar + còmode no canviar-ho.



* Llista la ciutat de les oficines, i el nom i càrrec dels directors de cada oficina.

```sql
SELECT ciutat, nom, carrec
  FROM oficines
       JOIN rep_vendes
       ON oficines.director = rep_vendes.num_empl;
```


* Llista les comandes superiors a 25000, incloent el nom del venedor que va servir la comanda i el nom del client que el va sol·licitar.

```sql
SELECT nom, empresa, import
  FROM comandes
       JOIN rep_vendes
       ON comandes.rep = rep_vendes.num_empl

       JOIN clients
       ON comandes.clie = clients.num_clie
 WHERE import > 25000;  
```




* Llista els venedors amb una quota superior a la dels seus caps.

```sql
SELECT venedors.nom, venedors.quota, caps.nom AS CAPS, caps.quota AS CAP_QUOTA
  FROM rep_vendes AS venedors
       JOIN rep_vendes AS caps
       ON venedors.cap  = caps.num_empl
 WHERE venedors.quota > caps.quota;
```


* Llistar el nom de l'empresa i totes les comandes fetes pel client 2103.

```sql
SELECT empresa, num_comanda
  FROM comandes
       JOIN clients
       ON comandes.clie = clients.num_clie
 WHERE clients.num_clie = 2103;
```


* Llista les comandes amb un import superior a 5000 i també aquelles comandes realitzades per un client amb un crèdit inferior a 30000. 

* Mostrar l'identificador de la comanda, el nom del client i el nom del representant de vendes que va prendre la comanda.


```sql
SELECT num_comanda, empresa, rep_vendes.nom 
  FROM comandes 
       JOIN clients
       ON comandes.clie = clients.num_clie 

       JOIN rep_vendes
       ON rep_vendes.num_empl = clients.rep_clie 

 WHERE comandes.import > 5000
       OR clients.limit_credit < 30000; 
```

```sql
 num_comanda |      empresa      |     nom     
-------------+-------------------+-------------
      112961 | J.P. Sinclair     | Sam Clark
      110036 | Ace International | Tom Snyder
      113045 | Zetacorp          | Larry Fitch
      113024 | Orion Corp        | Sue Smith
      112979 | Orion Corp        | Sue Smith
      113069 | Chen Associates   | Paul Cruz
      113003 | Holm & Landis     | Mary Jones
      112987 | Acme Mfg.         | Bill Adams
      113042 | Ian & Schmidt     | Bob Smith
(9 rows)
```



# Funciones de grupo

```sql
SELECT AVG(sal), MAX(sal), MIN(sal), SUM(sal) FROM emp WHERE Lower(job) = 'salesman';
```

# COUNT

```sql
SELECT COUNT(*) FROM emp;
```


# COALESCE  = Transforma los valores nulos - Falsea los datos.


```sql
SELECT AVG(coalesce(comm,0)) FROM emp;
```


# Creación de Grupos de Datos GROUP BY

```sql
SELECT camp/s, funció_grup
FROM taula/es
[WHERE condició/ons]
[GROUP BY camp/s_d’agrupació]
[ORDER BY camp/s];
```


```sql
SELECT deptno, AVG(sal)
FROM emp
GROUP BY deptno;
```


```sql
SELECT deptno, job, sum(sal)
FROM emp
GROUP BY deptno, job;
```

# Having


```sql
SELECT deptno, avg(sal)
FROM emp
GROUP BY deptno
HAVING avg(sal) > 2900;
```

* Muestra Job, Suma el Salario, donde Job no empiece por SALES y la suma de salario sea mayor que 5000.*

```sql
SELECT job, SUM(sal) AS "Suma de salaris"
FROM emp
WHERE job NOT LIKE 'SALES%'
GROUP BY job
HAVING SUM(sal) > 5000
ORDER BY SUM(sal);
```


# ROUND

* Quina és la quota promig mostrada com a "prom_quota" i la venda promig mostrades com a "prom_vendes" dels venedors?

```sql
SELECT ROUND(AVG(quota),2) AS prom_vendes, AVG(vendes) AS prom_vendes
FROM rep_vendes;
 prom_vendes |     prom_vendes     
-------------+---------------------
   300000.00 | 289353.200000000000
(1 row)

```

# CAST

* Quin és el promig del rendiment dels venedors (promig del percentatge de les vendes respecte la quota)?

```sql
SELECT CAST( 100 * AVG( vendes / quota ) AS NUMERIC(5,2) )
  FROM rep_vendes;
```

* Exercici

    Trobar l'import mitjà de les comandes, 
    
    l'import total de les comandes, 
    
    la mitjana del percentatge de l'import mitjà de les comandes respecte del límit de crèdit del client i 
    
    la mitjana del percentatge de l'import mitjà de comandes respecte a la quota del venedor.

```sql
SELECT ROUND(AVG(import),2) AS import_mitja, ROUND(SUM(import),2) AS import_total,
       ROUND(AVG(100 * import / limit_credit),2) AS "mitjana import/credit",
       ROUND(AVG(100 * import / quota),2) AS "mitjana import/quota"
  FROM comandes
       JOIN clients
       ON comandes.clie = clients.num_clie

       JOIN rep_vendes
       ON comandes.rep = rep_vendes.num_empl;
```

# DISTINCT GROUP

* Quants tipus de càrrecs hi ha de venedors?

```sql
SELECT COUNT(DISTINCT carrec)
FROM repventas;
```

* Quantes oficines de vendes tenen venedors que superen les seves quotes?

```sql
SELECT COUNT(DISTINCT oficina_rep) AS "oficines amb grans venedors"
  FROM rep_vendes
 WHERE vendes > quota;
```



# GROUP BY

* Quina és l'import promig de les comandes de cada venedor?

```sql
  SELECT rep, ROUND(AVG(import),2) AS promig_comandes
    FROM comandes
GROUP BY rep
ORDER BY rep;
```


* Calcula el total dels imports de les comandes fetes per cada client a cada vendedor.

```sql
SELECT clie, rep, SUM(import) AS total_import
  FROM comandes
 GROUP BY clie, rep;
```

* El mateix que a la qüestió anterior, però ordenat per client i dintre de client per venedor.


```sql
SELECT clie, rep, SUM(import) AS total_import
  FROM comandes
 GROUP BY clie, rep
 ORDER BY clie, rep;
```


* Calcula les comandes totals per a cada venedor.

Si el que ens estan preguntant és el número total de comandes que ha fet cada venedor:


```sql
  SELECT rep, COUNT(*)
    FROM comandes
   WHERE rep IS NOT NULL
GROUP BY rep;
```



# Examen Multitaules i resum


* Es vol llistar aquelles comandes que tinguin associat un representant de vendes i també tinguin associat un producte on el preu pagat (import) sigui inferior a 5000. Mostreu l'identificador i l'import de la comanda, el nom del representant de vendes, la descripció del producte i el nom del client que ha fet la comanda.



```sql
SELECT num_comanda, import, nom, descripcio, empresa
  FROM comandes
       JOIN productes
       ON comandes.fabricant = productes.id_fabricant
         AND comandes.producte = productes.id_producte

       JOIN clients
       ON comandes.clie = clients.num_clie

       JOIN rep_vendes
       ON comandes.rep = rep_vendes.num_empl
 WHERE import < 5000;
```

* Llisteu les comandes que continguin un producte amb la lletra x al seu codi de producte. S'ha de mostrar el codi de la comanda, el codi del fabricant i del producte, el nom del venedor que ha servit la comanda com a empleat_comanda i el nom del venedor associat al client que ha fet la comanda com a empleat_client. Ordena-ho pel camp que tingui més sentit escollir.

```sql
SELECT num_comanda, fabricant, producte, ven_comandes.nom AS empleat_comanda, ven_clients.nom AS empleat_client
  FROM comandes
       JOIN clients
       ON comandes.clie = clients.num_clie

       JOIN rep_vendes AS ven_comandes
       ON comandes.rep = ven_comandes.num_empl

       JOIN rep_vendes AS ven_clients
       ON clients.rep_clie = ven_clients.num_empl
WHERE producte LIKE '%x%'
ORDER BY 2,3;
```

* Mostreu un camp anomenat "edat_m". 

* El camp ha de contenir la mitjana de l'edat dels treballadors amb només dos decimals.



```sql
SELECT ROUND(AVG(edat),2) AS edat_m
  FROM rep_vendes;
```



* Mostreu l'identificador dels clients i un camp anomenat "comandes". 

* El camp "comandes" ha de mostrar quantes comandes ha fet cada client. S'ha d'ordenar per identificador del client, de més petit a més gran.

```sql
SELECT num_clie, COUNT(clie) AS comandes
  FROM comandes
       RIGHT JOIN clients
       ON comandes.clie = clients.num_clie
 GROUP BY num_clie
 ORDER BY num_clie;
```



* Llisteu aquells clients pels quals la suma dels imports de les seves comandes sigui menor al limit de crèdit. 

* Mostreu l'identificador i el nom de l'empresa dels clients.


```sql
SELECT num_clie, empresa, limit_credit, SUM(import) AS total_imports
  FROM comandes
       JOIN clients
       ON comandes.clie = clients.num_clie
 GROUP BY num_clie
HAVING limit_credit > SUM(import);
```


* Mostreu l'identificador del venedor i un camp anomenat "preu_top". El camp "preu_top" ha de contenir el preu del producte més car que ha venut.

```sql
SELECT rep, MAX(preu) AS preu_top
  FROM comandes
       JOIN productes
       ON comandes.fabricant = productes.id_fabricant
         AND comandes.producte = productes.id_producte
 GROUP BY rep
 ORDER BY rep;
```


    * Si l'enunciat de l'examen ens hagués demanat que també sortissin els venedors que no han fet cap comanda i que per a aquests casos el seu preu top fos 0, la consulta es podria resoldre de la següent manera.

* Con COALESCE

```sql
SELECT num_empl, COALESCE(MAX(preu),0) AS preu_top
  FROM comandes
       JOIN productes
       ON comandes.fabricant = productes.id_fabricant
         AND comandes.producte = productes.id_producte
 
       RIGHT JOIN rep_vendes
       ON comandes.rep = rep_vendes.num_empl    
 GROUP BY num_empl
 ORDER BY num_empl;
```



* Mostreu l'identificador i la ciutat de les oficines i dos camps més, un anomenat "crèdit1" i l'altre "crèdit2". 

* Per a cada oficina, el camp "crèdit1" ha de mostrar el límit de crèdit més petit dels clients que tenen assignat un representant en aquesta oficina. 

* El camp "crèdit2" ha de ser el mateix però pel límit de crèdit més gran.



```sql
SELECT oficina, ciutat, MIN(limit_credit) AS credit1, MAX(limit_credit) AS credit2
  FROM clients
       JOIN rep_vendes
       ON clients.rep_clie = rep_vendes.num_empl

       JOIN oficines
       ON rep_vendes.oficina_rep = oficines.oficina
 GROUP BY oficina        
 ORDER BY oficina, ciutat;
```



# SUBCONSULTAS


> Llista els venedors tals que la seva oficina sigui Chicago

* Con Join




```sql
SELECT rep_vendes.nom
FROM rep_vendes
JOIN oficines
ON rep_vendes.oficina_rep = oficines.oficina
WHERE oficines.ciutat = 'Chicago';
```


* Con Subconsultas

```sql
SELECT nom
FROM rep_vendes
WHERE oficina_rep IN
   (SELECT oficina
	  FROM oficines 
	 WHERE ciutat = 'Chicago');
```





```sql
SELECT nom
FROM rep_vendes
WHERE oficina_rep =
   (SELECT oficina
	  FROM oficines 
	 WHERE ciutat = 'Chicago');
```




# IN

* Alguna fila de la subconsulta coincideix amb el camp avaluat.

> Mostra els clients, el representant de vendes dels quals ha fet una comanda superior a 10000.

```sql
SELECT empresa
  FROM clients
 WHERE rep_clie IN 
       (SELECT rep
          FROM comandes
         WHERE import > 10000);
```

es = a = ANY

# ANY 

* Alguna fila de la subconsulta compleix la condició.

> Mostra els clients que el seu límit de crèdit és superior al 30% de la quota d'algun representant de vendes.

```sql
SELECT empresa
  FROM clients
 WHERE limit_credit > ANY
       (SELECT 0.3 * quota
	     FROM rep_vendes);
```


# ALL

* Totes les files de la subconsulta compleixen la condició.

> Mostra els clients el límit de crèdit dels quals és superior al 10% de les vendes de tots els representant de vendes.



```sql
SELECT empresa
  FROM clients
 WHERE limit_credit > ALL
       (SELECT 0.1 * vendes
          FROM rep_vendes);
```

# EXISTS

* La subconsulta retorna algun resultat.

> Clients que han fet una comanda l'any 89.

```sql
SELECT empresa
  FROM clients
 WHERE EXISTS 
       (SELECT *
	      FROM comandes
         WHERE num_clie = clie
           AND DATE_PART( 'year', data) = 1989);
```

# NOT EXISTS

> Clients que no han fet cap comanda l'any 89.

```sql
SELECT empresa
  FROM clients
 WHERE NOT EXISTS
       (SELECT *
          FROM comandes
         WHERE num_clie = clie
           AND DATE_PART( 'year', data) = 1989);
```



# Exercicis

* Tots els clients, identificador i nom de l'empresa, que han estat atesos per (que han fet comanda amb) Bill Adams.

```sql
SELECT DISTINCT num_clie, empresa 
  FROM clients
       JOIN comandes
       ON num_clie = clie
 WHERE rep =
       ( SELECT num_empl
           FROM rep_vendes
          WHERE nom = 'Bill Adams');
```

* Llista d'oficines on hi hagi algun venedor tal que la seva quota representi més del 50% de l'objectiu de l'oficina

```sql
SELECT ciutat 
  FROM oficines
WHERE objectiu * 0.5 < ANY
      (SELECT quota
	     FROM rep_vendes 
        WHERE oficina_rep = oficina);
```


*  Transforma el següent JOIN a una comanda amb subconsultes:

```sql
SELECT num_comanda, import, clie, num_clie, limit_credit
  FROM comandes
       JOIN clients
       ON clie = num_clie;
```


```sql
SELECT num_comanda, import, clie, 
       (SELECT num_clie
          FROM clients
         WHERE clie = num_clie), 
       (SELECT limit_credit
          FROM clients
         WHERE clie = num_clie) 
FROM comandes;
```


