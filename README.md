# Pipeline analítico de ventas con dbt (dbt-duckdb)

Proyecto dbt de extremo a extremo sobre un dominio de **ventas retail**, construido
sobre **DuckDB** (sin dependencias cloud). Demuestra los componentes centrales de dbt.

## Arquitectura

raw (CSV) -> sources -> staging -> intermediate -> marts -> exposures

- **sources** (`models/staging/_sources.yml`): tablas crudas `raw.clientes`, `raw.pedidos`, `raw.pedido_items`.
- **seeds** (`seeds/`): datos de referencia `categorias`, `productos`.
- **staging** (`models/staging/`): limpieza y tipado (`stg_*`).
- **intermediate** (`models/intermediate/`): `int_ventas_detalle` (joins de negocio).
- **marts** (`models/marts/`): `dim_clientes` y `fct_ventas`.
- **snapshots** (`snapshots/snap_clientes.sql`): historización SCD (estrategia `check`).
- **incremental model**: `fct_ventas` (`materialized='incremental'`, `unique_key`).
- **macros** (`macros/generar_sk.sql`): generación de surrogate keys reutilizable.
- **tests**: `not_null`, `unique`, `relationships` (en `_staging.yml` y `_marts.yml`).
- **documentation**: descripciones de modelos/columnas + `dbt docs`.
- **exposures** (`models/marts/_exposures.yml`): `dashboard_ventas` (consumidor downstream).

## Cómo correrlo

```bash
pip install dbt-duckdb
export DBT_PROFILES_DIR=$(pwd)   # usa el profiles.yml del proyecto

dbt seed        # carga datos de referencia
dbt run         # construye staging, intermediate y marts
dbt snapshot    # historiza clientes (SCD)
dbt test        # corre las pruebas de calidad
dbt docs generate && dbt docs serve   # documentación + lineage
```
