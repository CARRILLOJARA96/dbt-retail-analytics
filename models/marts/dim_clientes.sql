select
    {{ generar_sk(['cliente_id']) }} as cliente_sk,
    cliente_id,
    nombre,
    segmento,
    ciudad,
    fecha_registro
from {{ ref('stg_clientes') }}
