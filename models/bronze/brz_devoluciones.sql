with fuente as (
    select * from {{ source('raw', 'devoluciones') }}
)
select
    cast(devolucion_id as integer) as devolucion_id,
    cast(pedido_id as integer)     as pedido_id,
    cast(producto_id as integer)   as producto_id,
    cast(cantidad as integer)      as cantidad,
    motivo,
    cast(fecha_devolucion as date) as fecha_devolucion
from fuente
