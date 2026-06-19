with fuente as (
    select * from {{ source('raw', 'pedido_items') }}
)
select
    cast(pedido_id as integer)        as pedido_id,
    cast(producto_id as integer)      as producto_id,
    cast(cantidad as integer)         as cantidad,
    cast(precio_unitario as double)   as precio_unitario
from fuente
