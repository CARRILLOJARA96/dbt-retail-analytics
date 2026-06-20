with fuente as (
    select * from {{ source('raw', 'crm_clientes') }}
)
select
    cast(cliente_id as integer) as cliente_id,
    nombre_completo,
    tipo_cliente,
    email,
    telefono,
    cast(fecha_alta_crm as date) as fecha_alta_crm
from fuente
