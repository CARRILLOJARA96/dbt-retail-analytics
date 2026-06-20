select
    {{ generar_sk(['pedido_id', 'producto_id']) }} as lnk_pedido_producto_hk,
    {{ generar_sk(['devolucion_id', 'cantidad', 'motivo', 'fecha_devolucion']) }} as hashdiff,
    devolucion_id,
    cantidad as cantidad_devuelta,
    motivo,
    fecha_devolucion,
    current_timestamp as load_date,
    'raw.devoluciones' as record_source
from {{ ref('brz_devoluciones') }}
