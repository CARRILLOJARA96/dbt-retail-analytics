with all_sources as (
    select distinct producto_id, 'seed.productos' as record_source
    from {{ ref('productos') }}
    union all
    select distinct producto_id, 'raw.ecommerce_productos' as record_source
    from {{ ref('brz_ecommerce_productos') }}
),
deduped as (
    select
        producto_id,
        min(record_source) as record_source
    from all_sources
    group by producto_id
)
select
    {{ generar_sk(['producto_id']) }} as hub_producto_hk,
    producto_id,
    current_timestamp as load_date,
    record_source
from deduped
