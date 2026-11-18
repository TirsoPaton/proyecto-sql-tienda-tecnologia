# proyecto-sql-tienda-tecnologia
Análisis de ventas de una tienda de tecnología con SQL y PostgreSQL
# Análisis de ventas de una tienda de tecnología (SQL, PostgreSQL)

Proyecto de portfolio: respondo con SQL a preguntas de negocio de una tienda ficticia.

## Datos
Base de datos **sintética** (datos ficticios generados para practicar) con 6 tablas:
clientes, pedidos, líneas de pedido, productos, categorías y tiendas.
Periodo: enero 2025 – octubre 2026. 300 pedidos y 40 clientes.

## Cómo reproducirlo
1. Ejecuta `sql/01_crear_base_datos.sql` en PostgreSQL.
2. Ejecuta las consultas de `sql/02_consultas_negocio.sql`.

## Preguntas y hallazgos
| Pregunta | Hallazgo |
|---|---|
| Top 5 productos | Smartphone lidera las ventas netas (20.186 €); tres de los cinco primeros son de Informática (Tablet, Portátil y Monitor). |
| Margen por categoría | Informática es la categoría que más margen deja (11.569 €), un 42 % más que Móviles (8.138 €). |
| Margen porcentual | Informática es la última en porcentaje (31,7 %); Periféricos (56,1 %) y Hogar inteligente (55,5 %) lideran. |
| Ticket medio | 303,17 € por pedido (sin cancelados). |

## Supuestos
- Los descuentos NULL se tratan como 0.
- Se excluyen los pedidos cancelados.
- El margen se calcula sobre precio bruto, sin descuentos.

## Herramientas
PostgreSQL · SQL (JOINs, CTEs, agregaciones)
