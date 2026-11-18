
-- PREGUNTA 6: Top 3 productos por ventas netas dentro de cada categoría
-- Objetivo: obtener los 3 productos que más facturan en cada categoría,
-- excluyendo pedidos cancelados.
-- Método: primera CTE con las ventas netas por producto; segunda CTE con
-- un ranking por categoría (ROW_NUMBER + PARTITION BY); y el filtro
-- posicion <= 3 en la consulta final, porque una función de ventana no se
-- puede filtrar en el WHERE del mismo nivel.
-- Supuestos: los descuentos NULL se tratan como 0.
--            Con ROW_NUMBER, un empate en el 3.er puesto se resuelve al azar.

WITH ventas_producto AS (
    SELECT pr.nombre AS producto,
           cat.nombre AS categoria,
           SUM(l.cantidad * pr.precio * (1 - COALESCE(l.descuento, 0))) AS ventas_netas
    FROM lineas_pedido AS l
    INNER JOIN productos AS pr
        ON l.id_producto = pr.id_producto
    INNER JOIN categorias AS cat
        ON pr.id_categoria = cat.id_categoria
    INNER JOIN pedidos AS p
        ON l.id_pedido = p.id_pedido
    WHERE p.estado <> 'Cancelado'
    GROUP BY pr.nombre, cat.nombre
),
ranking AS (
    SELECT categoria,
           producto,
           ventas_netas,
           ROW_NUMBER() OVER (PARTITION BY categoria ORDER BY ventas_netas DESC) AS posicion
    FROM ventas_producto
)
SELECT categoria, producto, ventas_netas, posicion
FROM ranking
WHERE posicion <= 3
ORDER BY categoria, posicion;



-- PREGUNTA 7: Crecimiento mensual de las ventas netas
-- Objetivo: calcular el crecimiento porcentual de las ventas netas de cada
-- mes respecto al mes anterior, excluyendo pedidos cancelados.
-- Método: primera CTE con las ventas netas por mes; segunda CTE con el mes
-- anterior mediante LAG; y el cálculo del porcentaje en la consulta final.
-- Supuestos: los descuentos NULL se tratan como 0.
--            El primer mes no tiene mes anterior: LAG devuelve NULL y, por
--            tanto, su crecimiento también es NULL.
--            NULLIF evita la división por cero si un mes anterior fuera 0.

WITH ventas_mes AS (
    SELECT TO_CHAR(p.fecha, 'YYYY-MM') AS mes,
           SUM(l.cantidad * pr.precio * (1 - COALESCE(l.descuento, 0))) AS ventas_netas
    FROM lineas_pedido AS l
    INNER JOIN productos AS pr
        ON l.id_producto = pr.id_producto
    INNER JOIN pedidos AS p
        ON l.id_pedido = p.id_pedido
    WHERE p.estado <> 'Cancelado'
    GROUP BY TO_CHAR(p.fecha, 'YYYY-MM')
),
con_anterior AS (
    SELECT mes,
           ventas_netas,
           LAG(ventas_netas) OVER (ORDER BY mes) AS ventas_mes_anterior
    FROM ventas_mes
)
SELECT mes,
       ventas_netas,
       ventas_mes_anterior,
       ROUND((ventas_netas - ventas_mes_anterior)
             / NULLIF(ventas_mes_anterior, 0) * 100, 1) AS crecimiento_pct
FROM con_anterior
ORDER BY mes;