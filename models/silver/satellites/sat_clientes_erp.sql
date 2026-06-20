select
    {{ generar_sk(['cliente_id']) }} as hub_cliente_hk,
    {{ generar_sk(['nombre', 'segmento', 'ciudad', 'fecha_registro']) }} as hashdiff,
    nombre,
    segmento,
    ciudad,
    fecha_registro,
    current_timestamp as load_date,
    'raw.clientes' as record_source
from {{ ref('brz_clientes') }}
