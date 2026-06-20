{{ config(materialized='incremental', unique_key='venta_id') }}

select
    lp.lnk_pedido_producto_hk as venta_id,
    lp.pedido_id,
    lc.cliente_id,
    lt.tienda_id,
    lp.producto_id,
    coalesce(sp_erp.categoria_nombre, sp_ecom.categoria) as categoria_nombre,
    coalesce(sped_erp.fecha_pedido, sped_ecom.fecha_pedido) as fecha_pedido,
    coalesce(sped_erp.estado, sped_ecom.estado) as estado,
    sped_erp.canal,
    sped_ecom.metodo_pago,
    coalesce(si_erp.cantidad, si_ecom.cantidad) as cantidad,
    coalesce(si_erp.precio_unitario, si_ecom.precio_unitario) as precio_unitario,
    coalesce(si_erp.descuento, si_ecom.descuento) as descuento,
    coalesce(si_erp.monto_bruto, si_ecom.monto_bruto) as monto_bruto,
    coalesce(si_erp.monto_neto, si_ecom.monto_neto) as monto_neto,
    si_ecom.cupon_codigo,
    lp.record_source
from {{ ref('lnk_pedido_producto') }} lp
join {{ ref('lnk_pedido_cliente') }} lc on lp.hub_pedido_hk = lc.hub_pedido_hk
join {{ ref('lnk_pedido_tienda') }} lt on lp.hub_pedido_hk = lt.hub_pedido_hk
left join {{ ref('sat_pedido_items_erp') }} si_erp on lp.lnk_pedido_producto_hk = si_erp.lnk_pedido_producto_hk
left join {{ ref('sat_pedido_items_ecom') }} si_ecom on lp.lnk_pedido_producto_hk = si_ecom.lnk_pedido_producto_hk
left join {{ ref('sat_pedidos_erp') }} sped_erp on lp.hub_pedido_hk = sped_erp.hub_pedido_hk
left join {{ ref('sat_pedidos_ecom') }} sped_ecom on lp.hub_pedido_hk = sped_ecom.hub_pedido_hk
left join {{ ref('sat_productos_erp') }} sp_erp on lp.hub_producto_hk = sp_erp.hub_producto_hk
left join {{ ref('sat_productos_ecom') }} sp_ecom on lp.hub_producto_hk = sp_ecom.hub_producto_hk
{% if is_incremental() %}
where coalesce(sped_erp.fecha_pedido, sped_ecom.fecha_pedido) > (select coalesce(max(fecha_pedido), date '1900-01-01') from {{ this }})
{% endif %}
