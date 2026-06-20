select
    {{ generar_sk(['pedido_id']) }} as hub_pedido_hk,
    {{ generar_sk(['fecha_pedido', 'estado', 'metodo_pago']) }} as hashdiff,
    fecha_pedido,
    estado,
    metodo_pago,
    current_timestamp as load_date,
    'raw.ecommerce_pedidos' as record_source
from {{ ref('brz_ecommerce_pedidos') }}
