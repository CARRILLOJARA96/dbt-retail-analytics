with fuente as (
    select * from {{ source('raw', 'tiendas') }}
)
select
    cast(tienda_id as integer) as tienda_id,
    nombre_tienda,
    region,
    ciudad,
    formato,
    cast(fecha_apertura as date) as fecha_apertura
from fuente
