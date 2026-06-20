select
    {{ generar_sk(['producto_id']) }} as hub_producto_hk,
    {{ generar_sk(['nombre_producto', 'categoria', 'precio_base']) }} as hashdiff,
    nombre_producto,
    categoria,
    precio_base,
    current_timestamp as load_date,
    'raw.ecommerce_productos' as record_source
from {{ ref('brz_ecommerce_productos') }}
