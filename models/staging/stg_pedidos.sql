with fuente as (
    select * from {{ source('raw', 'pedidos') }}
)
select
    cast(pedido_id as integer)  as pedido_id,
    cast(cliente_id as integer) as cliente_id,
    cast(fecha_pedido as date)  as fecha_pedido,
    estado,
    canal
from fuente
