select
    {{ generar_sk(['tienda_id']) }} as hub_tienda_hk,
    {{ generar_sk(['nombre_tienda', 'region', 'ciudad', 'formato', 'fecha_apertura']) }} as hashdiff,
    nombre_tienda,
    region,
    ciudad,
    formato,
    fecha_apertura,
    current_timestamp as load_date,
    'raw.tiendas' as record_source
from {{ ref('brz_tiendas') }}
