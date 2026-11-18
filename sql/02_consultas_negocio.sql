
-- PREGUNTA 1: Ventas netas por mes
-- Objetivo: ventas netas por mes, sin pedidos cancelados
-- Supuesto: descuento NULL = sin descuento (0)

SELECT DATE_TRUNC('month', p.fecha)::date AS mes,
       SUM(l.cantidad * pr.precio * (1 - COALESCE(l.descuento, 0))) AS ventas_netas
FROM lineas_pedido AS l
INNER JOIN productos AS pr
    ON l.id_producto = pr.id_producto
INNER JOIN pedidos AS p
    ON l.id_pedido = p.id_pedido
WHERE p.estado <> 'Cancelado'
GROUP BY DATE_TRUNC('month', p.fecha)
ORDER BY mes;

SET search_path TO tienda;

-- PREGUNTA 2: Top 5 productos por facturación
-- Objetivo: Calcular los 5 productos que más facturan en ventas netas,
-- mostrando su categoría y excluyendo pedidos cancelados.

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
ORDER BY ventas_netas DESC
LIMIT 5;

-- PREGUNTA 3: Margen por categoría
-- Objetivo: Calcular el beneficio total por categoría de mayor a menor,
-- excluyendo pedidos cancelados.
-- Supuesto: Se calcula sobre precio bruto sin aplicar descuentos.

SELECT cat.nombre AS categoria,
       SUM((pr.precio - pr.coste) * l.cantidad) AS margen_total
FROM lineas_pedido AS l
INNER JOIN productos AS pr
    ON l.id_producto = pr.id_producto
INNER JOIN categorias AS cat
    ON pr.id_categoria = cat.id_categoria
INNER JOIN pedidos AS p
    ON l.id_pedido = p.id_pedido
WHERE p.estado <> 'Cancelado'
GROUP BY cat.nombre
ORDER BY margen_total DESC;


-- PREGUNTA 4: TICKET MEDIO
-- Objetivo: ticket medio por pedido, sin cancelados
WITH totales_pedido AS (
    SELECT l.id_pedido,
           SUM(l.cantidad * pr.precio * (1 - COALESCE(l.descuento, 0))) AS total_pedido
    FROM lineas_pedido AS l
    INNER JOIN productos AS pr
        ON l.id_producto = pr.id_producto
    INNER JOIN pedidos AS p
        ON l.id_pedido = p.id_pedido
    WHERE p.estado <> 'Cancelado'
    GROUP BY l.id_pedido
)
SELECT ROUND(AVG(total_pedido), 2) AS ticket_medio
FROM totales_pedido;


-- PREGUNTA 5: Margen porcentual por categoría
-- Objetivo: Calcular el margen porcentual sobre ventas brutas por categoría
-- de mayor a menor rentabilidad relativa, excluyendo pedidos cancelados.
-- Supuesto: Se calcula sobre precio bruto sin aplicar descuentos.

SELECT cat.nombre AS categoria,
       SUM((pr.precio - pr.coste) * l.cantidad) AS margen_total,
       SUM(l.cantidad * pr.precio) AS ventas_brutas,
       ROUND(
           SUM((pr.precio - pr.coste) * l.cantidad) / NULLIF(SUM(l.cantidad * pr.precio), 0) * 100,
           1
       ) AS margen_pct
FROM lineas_pedido AS l
INNER JOIN productos AS pr
    ON l.id_producto = pr.id_producto
INNER JOIN categorias AS cat
    ON pr.id_categoria = cat.id_categoria
INNER JOIN pedidos AS p
    ON l.id_pedido = p.id_pedido
WHERE p.estado <> 'Cancelado'
GROUP BY cat.nombre
ORDER BY margen_pct DESC;