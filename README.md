# Pipeline analítico de ventas con dbt (dbt-duckdb)

Proyecto dbt de extremo a extremo sobre un dominio de **ventas retail**, construido
sobre **DuckDB** (sin dependencias cloud). Implementa arquitectura **Medallion** con
**Data Vault 2.0** en la capa silver.

## Arquitectura

```
raw (CSV) → sources → bronze → silver (Data Vault 2.0) → gold → exposures
```

### Bronze (staging)
Limpieza y tipado desde las fuentes crudas.
- `stg_clientes`, `stg_pedidos`, `stg_pedido_items`, `stg_tiendas`, `stg_devoluciones`

### Silver (Data Vault 2.0)
Modelado por hubs, links y satellites con hash keys y hashdiff.
- **Hubs**: `hub_clientes`, `hub_productos`, `hub_tiendas`, `hub_pedidos`
- **Links**: `lnk_pedido_cliente`, `lnk_pedido_tienda`, `lnk_pedido_producto`
- **Satellites**: `sat_clientes`, `sat_productos`, `sat_tiendas`, `sat_pedidos`, `sat_pedido_items`, `sat_devoluciones`

### Gold (marts)
Dimensiones y hechos listos para consumo analítico.
- **Dimensiones**: `dim_clientes`, `dim_productos`, `dim_tiendas`
- **Hechos**: `fct_ventas` (incremental), `fct_devoluciones`

### Otros componentes
- **seeds** (`seeds/`): datos de referencia `categorias`, `productos`.
- **snapshots** (`snapshots/snap_clientes.sql`): historización SCD (estrategia `check`).
- **macros** (`macros/generar_sk.sql`): generación de surrogate keys / hash keys reutilizable.
- **tests**: `not_null`, `unique`, `accepted_values`, `relationships`.
- **exposures**: `dashboard_ventas`, `reporte_devoluciones`.

## Cómo correrlo

```bash
pip install dbt-duckdb
export DBT_PROFILES_DIR=$(pwd)   # usa el profiles.yml del proyecto

dbt seed        # carga datos de referencia
dbt run         # construye bronze, silver y gold
dbt snapshot    # historiza clientes (SCD)
dbt test        # corre las pruebas de calidad
dbt docs generate && dbt docs serve   # documentación + lineage
```
