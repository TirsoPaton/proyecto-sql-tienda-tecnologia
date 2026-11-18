# Análisis de ventas de una tienda de tecnología (SQL, PostgreSQL)

Proyecto de portfolio: respondo con SQL a preguntas de negocio de una tienda ficticia.
**Estado:** Fases 1 y 2 hechas (SQL). Próximamente: dashboard en Power BI.

## Problema de negocio
El dueño de una tienda de tecnología tiene sus datos en una base de datos, pero no sabe
qué productos y categorías le dejan más dinero ni cómo evolucionan sus ventas.
Este proyecto responde a esas preguntas con SQL.

## Datos
Base de datos **sintética** (datos ficticios generados para practicar), con 6 tablas.
Periodo: enero 2025 – octubre 2026. 300 pedidos y 40 clientes.

**Modelo de datos (relaciones):**
- `pedidos` → `clientes` (por `id_cliente`) y `tiendas` (por `id_tienda`)
- `lineas_pedido` → `pedidos` (por `id_pedido`) y `productos` (por `id_producto`)
- `productos` → `categorias` (por `id_categoria`)

## Estructura del repositorio
- `sql/01_crear_base_datos.sql`: crea las tablas y carga los datos.
- `sql/02_consultas_negocio.sql`: JOINs, agregaciones y CTEs.
- `sql/03_consultas_avanzadas.sql`: funciones de ventana (ranking y `LAG`).

## Cómo reproducirlo
1. Ejecuta `sql/01_crear_base_datos.sql` en PostgreSQL.
2. Ejecuta las consultas de los archivos 02 y 03.

## Preguntas y hallazgos
| Pregunta | Hallazgo |
|---|---|
| Ventas netas por mes | Oscilan entre 531 € (mayo 2026) y 7.476 € (enero 2026). Los crecimientos mensuales son muy volátiles por el bajo volumen de pedidos (+880 % en marzo de 2025, −87 % en mayo de 2026). |
| Top 5 productos | Smartphone lidera las ventas netas (20.186 €); tres de los cinco primeros son de Informática (Tablet, Portátil y Monitor). |
| Top 3 por categoría | Líderes de cada categoría: Tablet (Informática), Smartphone (Móviles), Barra de sonido (Audio), Webcam (Periféricos) y Cámara de seguridad (Hogar inteligente). |
| Margen por categoría | Informática es la categoría que más margen deja (11.569 €), un 42 % más que Móviles (8.138 €). |
| Margen porcentual | Informática es la última en porcentaje (31,7 %); Periféricos (56,1 %) y Hogar inteligente (55,5 %) lideran. |
| Ticket medio | 303,17 € por pedido (sin cancelados). |

## Recomendaciones
- [Propuesta: impulsar Periféricos y Hogar inteligente, que dejan más margen por cada euro vendido.]
- [Propuesta: revisar costes y precios de Informática, que factura más pero con menor margen porcentual.]
- [Propuesta: con tan pocos pedidos al mes, no planificar compras solo con estos crecimientos; haría falta más histórico.]

## Supuestos y limitaciones
- Los descuentos NULL se tratan como 0.
- Se excluyen los pedidos cancelados.
- El margen se calcula sobre precio bruto, sin descuentos.
- Los datos son sintéticos y de poco volumen, así que las cifras son ilustrativas.

## Herramientas
PostgreSQL · SQL (JOINs, CTEs, agregaciones, funciones de ventana: `ROW_NUMBER`, `LAG`)
