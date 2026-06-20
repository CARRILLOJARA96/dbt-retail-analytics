with all_sources as (
    select distinct pedido_id, producto_id, 'raw.pedido_items' as record_source
    from {{ ref('brz_pedido_items') }}
    union all
    select distinct pedido_id, producto_id, 'raw.ecommerce_pedido_items' as record_source
    from {{ ref('brz_ecommerce_pedido_items') }}
),
deduped as (
    select
        pedido_id,
        producto_id,
        min(record_source) as record_source
    from all_sources
    group by pedido_id, producto_id
)
select
    {{ generar_sk(['pedido_id', 'producto_id']) }} as lnk_pedido_producto_hk,
    {{ generar_sk(['pedido_id']) }} as hub_pedido_hk,
    {{ generar_sk(['producto_id']) }} as hub_producto_hk,
    pedido_id,
    producto_id,
    current_timestamp as load_date,
    record_source
from deduped
