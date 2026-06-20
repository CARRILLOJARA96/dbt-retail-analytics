with source as (
    select
        p.producto_id,
        p.producto_nombre,
        c.categoria_id,
        c.categoria_nombre
    from {{ ref('productos') }} p
    left join {{ ref('categorias') }} c on p.categoria_id = c.categoria_id
)
select
    {{ generar_sk(['producto_id']) }} as hub_producto_hk,
    {{ generar_sk(['producto_nombre', 'categoria_id', 'categoria_nombre']) }} as hashdiff,
    producto_nombre,
    categoria_id,
    categoria_nombre,
    current_timestamp as load_date,
    'seed.productos' as record_source
from source
