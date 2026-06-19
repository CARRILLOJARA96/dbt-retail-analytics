with fuente as (
    select * from {{ source('raw', 'clientes') }}
)
select
    cast(cliente_id as integer) as cliente_id,
    nombre,
    segmento,
    ciudad,
    cast(fecha_registro as date) as fecha_registro
from fuente
