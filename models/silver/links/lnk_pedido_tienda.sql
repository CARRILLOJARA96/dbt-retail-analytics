with all_sources as (
    select distinct pedido_id, tienda_id, 'raw.pedidos' as record_source
    from {{ ref('brz_pedidos') }}
    union all
    select distinct pedido_id, 7 as tienda_id, 'raw.ecommerce_pedidos' as record_source
    from {{ ref('brz_ecommerce_pedidos') }}
),
deduped as (
    select
        pedido_id,
        tienda_id,
        min(record_source) as record_source
    from all_sources
    group by pedido_id, tienda_id
)
select
    {{ generar_sk(['pedido_id', 'tienda_id']) }} as lnk_pedido_tienda_hk,
    {{ generar_sk(['pedido_id']) }} as hub_pedido_hk,
    {{ generar_sk(['tienda_id']) }} as hub_tienda_hk,
    pedido_id,
    tienda_id,
    current_timestamp as load_date,
    record_source
from deduped
