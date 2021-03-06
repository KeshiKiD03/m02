-- 1. Selecciona els treballadors que han venut menys quantitat de productes que la Sue Smith

SELECT num_empl, nombre 
FROM repventas
JOIN pedidos
ON num_empl = rep
WHERE cant < (SELECT cant
			FROM pedidos
			JOIN repventas 
			ON rep = num_empl
			WHERE nombre = 'Sue Smith');

SELECT nombre, SUM(cant) 
FROM pedidos
JOIN repventas
ON rep = num_empl
GROUP BY num_empl
HAVING SUM(cant) < (SELECT SUM(cant)
		    FROM pedidos
		    WHERE rep = '102');

SELECT nombre, SUM(cant) 
FROM pedidos
JOIN repventas
ON rep = num_empl
GROUP BY num_empl
HAVING SUM(cant) < (SELECT SUM(cant)
		    FROM pedidos, repventas
		    WHERE rep = num_empl AND nombre = 'Sue Smith');

SELECT nombre, SUM(cant) 
FROM pedidos
JOIN repventas
ON rep = num_empl
GROUP BY num_empl
HAVING SUM(cant) < (SELECT SUM(cant)
		    FROM pedidos
		    JOIN repventas
		    ON rep = num_empl
		    WHERE nombre = 'Sue Smith');


-- 2. Llista els treballadors que han venut mes en import que la Sue Smith, la Mary Jones i els Will Adams

SELECT nombre, SUM(importe)
FROM repventas 
JOIN pedidos
ON num_empl = rep
GROUP BY num_empl
HAVING SUM(importe) > (SELECT SUM(importe) FROM pedidos JOIN repventas ON rep = num_empl AND nombre = 'Sue Smith')
	AND
	SUM(importe) > (SELECT SUM(importe) FROM pedidos JOIN repventas ON rep = num_empl AND nombre = 'Mary Jones')
	AND
	SUM(importe) > (SELECT SUM(importe) FROM pedidos JOIN repventas ON rep = num_empl AND nombre = 'Bill Adams');

-- 3. Llista els treballadors que han venut mes que alguns dels seguents : Sue Smith, la Mary Jones i els Will Adams

SELECT nombre, SUM(cant)
FROM repventas 
JOIN pedidos
ON num_empl = rep
GROUP BY num_empl
HAVING SUM(cant) > (SELECT SUM(cant) FROM pedidos JOIN repventas ON rep = num_empl AND nombre = 'Sue Smith')
	OR
	SUM(cant) > (SELECT SUM(cant) FROM pedidos JOIN repventas ON rep = num_empl AND nombre = 'Mary Jones')
	OR
	SUM(cant) > (SELECT SUM(cant) FROM pedidos JOIN repventas ON rep = num_empl AND nombre = 'Bill Adams');

-- S'utilitza OR


SELECT nombre, SUM(cant)
FROM repventas 
JOIN pedidos
ON num_empl = rep
GROUP BY num_empl
HAVING SUM(cant) > ANY (SELECT SUM(cant) FROM pedidos JOIN repventas ON rep = num_empl WHERE nombre IN ('Sue Smith','Mary Jones','Bill Adams') GROUP BY num_empl);

-- AMB ANY

4. Llista els treballadors que han fet mes comandes que els seus directors.

5. Llista els treballadors que en el r[anking de ventes estan entre el Dan Roberts i la Mary Jones

6. Mostra les oficines (codi i ciutat) tals que el seu objectiu sigui inferior o igual a les quotes de tots els seus treballadors.

7. Llista els representants de vendes (codi de treballador i nom) que tenen un director m??s jove que algun dels seus empleats.

8. Mostrar el codi de treballador, el seu nom i un camp anomenat i_m. El camp i_m ??s l'import m??s gran de les comandes que ha fet aquest treballador. Nom??s s'han de llistar els treballadors que tinguin tots els clients amb alguna comanda amb import superior a la mitjana dels imports de totes les comandes.

9. Mostra el codi de fabricant i de producte i un camp de nom n_p. n_p ??s el nombre de comandes que s'han fet d'aquell producte. Nom??s s'han de llistar aquells productes tals que se n'ha fet alguna comanda amb una quantitat inferior a les seves exist??ncies. En el llistat nom??s han d''apar??ixer els tres productes amb m??s comandes, ordenats per codi de fabricant i de producte.

10. Mostra el codi de client, el nom de client, un camp c_r i un camp n_p. El camp c_r ha de mostrar la quota del representant de vendes del client. El camp n_p ha demostrar el nombre de comandes que ha fet aquest client. Nom??s s'han de mostrar els clients que l'import total de totes les seves comandes sigui superior a la mitjana de l''import de totes les comandes.

