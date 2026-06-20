select
    {{ generar_sk(['pedido_id', 'producto_id']) }} as lnk_pedido_producto_hk,
    {{ generar_sk(['cantidad', 'precio_unitario', 'descuento', 'cupon_codigo']) }} as hashdiff,
    cantidad,
    precio_unitario,
    descuento,
    cupon_codigo,
    cantidad * precio_unitario as monto_bruto,
    cantidad * precio_unitario - descuento as monto_neto,
    current_timestamp as load_date,
    'raw.ecommerce_pedido_items' as record_source
from {{ ref('brz_ecommerce_pedido_items') }}
