{{ config(materialized='incremental', unique_key='venta_id') }}

with detalle as (
    select * from {{ ref('int_ventas_detalle') }}
)
select
    {{ generar_sk(['pedido_id', 'producto_id']) }} as venta_id,
    pedido_id,
    cliente_id,
    producto_id,
    categoria_nombre,
    fecha_pedido,
    estado,
    cantidad,
    precio_unitario,
    monto_linea
from detalle
{% if is_incremental() %}
where fecha_pedido > (select coalesce(max(fecha_pedido), date '1900-01-01') from {{ this }})
{% endif %}
