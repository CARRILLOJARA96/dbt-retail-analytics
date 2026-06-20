with fuente as (
    select * from {{ source('raw', 'ecommerce_productos') }}
)
select
    cast(producto_id as integer) as producto_id,
    nombre_producto,
    categoria,
    cast(precio_base as double) as precio_base
from fuente
