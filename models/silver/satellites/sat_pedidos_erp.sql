select
    {{ generar_sk(['pedido_id']) }} as hub_pedido_hk,
    {{ generar_sk(['fecha_pedido', 'estado', 'canal']) }} as hashdiff,
    fecha_pedido,
    estado,
    canal,
    current_timestamp as load_date,
    'raw.pedidos' as record_source
from {{ ref('brz_pedidos') }}
