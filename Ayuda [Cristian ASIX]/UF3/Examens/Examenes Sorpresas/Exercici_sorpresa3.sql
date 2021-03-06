select *,
case
    when existencias < (select sum(cant) from pedidos
                        where num_pedido in (select num_pedido from pedidos
                                             where id_fab=fab and id_producto=producto
                                             order by fecha_pedido desc limit 2))
         then 'ALERTA: ultimes comandes sumen ' || (select sum(cant) from pedidos
                                                    where num_pedido in (select num_pedido from pedidos
                                                                         where id_fab=fab and id_producto=producto
                                                                         order by fecha_pedido desc limit 2))
    else NULL
end as "Alerta existències"
from productos;
 id_fab | id_producto |    descripcion    | precio  | existencias |        Alerta existències         
--------+-------------+-------------------+---------+-------------+-----------------------------------
 rei    | 2a45c       | V Stago Trinquete |   79.00 |         210 | 
 aci    | 4100y       | Extractor         | 2750.00 |          25 | 
 qsa    | xk47        | Reductor          |  355.00 |          38 | 
 bic    | 41672       | Plate             |  180.00 |           0 | 
 imm    | 779c        | Riostra 2-Tm      | 1875.00 |           9 | 
 aci    | 41003       | Articulo Tipo 3   |  107.00 |         207 | 
 aci    | 41004       | Articulo Tipo 4   |  117.00 |         139 | 
 bic    | 41003       | Manivela          |  652.00 |           3 | 
 imm    | 887p        | Perno Riostra     |  250.00 |          24 | 
 qsa    | xk48        | Reductor          |  134.00 |         203 | 
 rei    | 2a44l       | Bisagra Izqda.    | 4500.00 |          12 | 
 fea    | 112         | Cubierta          |  148.00 |         115 | 
 imm    | 887h        | Soporte Riostra   |   54.00 |         223 | 
 bic    | 41089       | Retn              |  225.00 |          78 | 
 aci    | 41001       | Articulo Tipo 1   |   55.00 |         277 | 
 imm    | 775c        | Riostra 1-Tm      | 1425.00 |           5 | ALERTA: ultimes comandes sumen 22
 aci    | 4100z       | Montador          | 2500.00 |          28 | 
 qsa    | xk48a       | Reductor          |  117.00 |          37 | 
 aci    | 41002       | Articulo Tipo 2   |   76.00 |         167 | 
 rei    | 2a44r       | Bisagra Dcha.     | 4500.00 |          12 | ALERTA: ultimes comandes sumen 15
 imm    | 773c        | Riostra 1/2-Tm    |  975.00 |          28 | 
 aci    | 4100x       | Ajustador         |   25.00 |          37 | 
 fea    | 114         | Bancada Motor     |  243.00 |          15 | ALERTA: ultimes comandes sumen 16
 imm    | 887x        | Retenedor Riostra |  475.00 |          32 | 
 rei    | 2a44g       | Pasador Bisagra   |  350.00 |          14 | 
(25 rows)
