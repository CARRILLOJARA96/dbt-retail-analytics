select
    {{ generar_sk(['cliente_id']) }} as hub_cliente_hk,
    {{ generar_sk(['nombre_completo', 'tipo_cliente', 'email', 'telefono']) }} as hashdiff,
    nombre_completo,
    tipo_cliente,
    email,
    telefono,
    fecha_alta_crm,
    current_timestamp as load_date,
    'raw.crm_clientes' as record_source
from {{ ref('brz_crm_clientes') }}
