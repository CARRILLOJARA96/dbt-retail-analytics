with all_sources as (
    select distinct pedido_id, cliente_id, 'raw.pedidos' as record_source
    from {{ ref('brz_pedidos') }}
    union all
    select distinct pedido_id, cliente_id, 'raw.ecommerce_pedidos' as record_source
    from {{ ref('brz_ecommerce_pedidos') }}
),
deduped as (
    select
        pedido_id,
        cliente_id,
        min(record_source) as record_source
    from all_sources
    group by pedido_id, cliente_id
)
select
    {{ generar_sk(['pedido_id', 'cliente_id']) }} as lnk_pedido_cliente_hk,
    {{ generar_sk(['pedido_id']) }} as hub_pedido_hk,
    {{ generar_sk(['cliente_id']) }} as hub_cliente_hk,
    pedido_id,
    cliente_id,
    current_timestamp as load_date,
    record_source
from deduped
