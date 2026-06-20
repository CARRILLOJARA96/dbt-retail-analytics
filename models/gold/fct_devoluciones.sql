with base as (
    select
        sd.devolucion_id,
        lp.pedido_id,
        lp.producto_id,
        sd.cantidad_devuelta,
        sd.motivo,
        sd.fecha_devolucion,
        lc.cliente_id,
        lt.tienda_id,
        coalesce(sped_erp.fecha_pedido, sped_ecom.fecha_pedido) as fecha_pedido,
        coalesce(si_erp.precio_unitario, si_ecom.precio_unitario) as precio_unitario,
        sd.cantidad_devuelta * coalesce(si_erp.precio_unitario, si_ecom.precio_unitario) as monto_devolucion
    from {{ ref('sat_devoluciones') }} sd
    join {{ ref('lnk_pedido_producto') }} lp on sd.lnk_pedido_producto_hk = lp.lnk_pedido_producto_hk
    join {{ ref('lnk_pedido_cliente') }} lc on lp.hub_pedido_hk = lc.hub_pedido_hk
    join {{ ref('lnk_pedido_tienda') }} lt on lp.hub_pedido_hk = lt.hub_pedido_hk
    left join {{ ref('sat_pedido_items_erp') }} si_erp on lp.lnk_pedido_producto_hk = si_erp.lnk_pedido_producto_hk
    left join {{ ref('sat_pedido_items_ecom') }} si_ecom on lp.lnk_pedido_producto_hk = si_ecom.lnk_pedido_producto_hk
    left join {{ ref('sat_pedidos_erp') }} sped_erp on lp.hub_pedido_hk = sped_erp.hub_pedido_hk
    left join {{ ref('sat_pedidos_ecom') }} sped_ecom on lp.hub_pedido_hk = sped_ecom.hub_pedido_hk
)
select
    {{ generar_sk(['devolucion_id']) }} as devolucion_sk,
    *
from base
