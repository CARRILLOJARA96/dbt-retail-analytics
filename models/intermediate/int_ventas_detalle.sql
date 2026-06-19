with items as (
    select * from {{ ref('stg_pedido_items') }}
),
pedidos as (
    select * from {{ ref('stg_pedidos') }}
),
productos as (
    select * from {{ ref('productos') }}
),
categorias as (
    select * from {{ ref('categorias') }}
)
select
    i.pedido_id,
    p.cliente_id,
    p.fecha_pedido,
    p.estado,
    i.producto_id,
    pr.producto_nombre,
    c.categoria_nombre,
    i.cantidad,
    i.precio_unitario,
    i.cantidad * i.precio_unitario as monto_linea
from items i
join pedidos p      on i.pedido_id = p.pedido_id
left join productos pr  on i.producto_id = pr.producto_id
left join categorias c  on pr.categoria_id = c.categoria_id
