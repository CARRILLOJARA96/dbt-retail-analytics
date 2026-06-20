with hub as (
    select * from {{ ref('hub_clientes') }}
),
sat_erp as (
    select * from {{ ref('sat_clientes_erp') }}
),
sat_crm as (
    select * from {{ ref('sat_clientes_crm') }}
),
metricas as (
    select
        lpc.hub_cliente_hk,
        count(distinct lpc.hub_pedido_hk) as total_pedidos,
        sum(coalesce(si_erp.monto_neto, si_ecom.monto_neto)) as monto_total,
        min(coalesce(sp_erp.fecha_pedido, sp_ecom.fecha_pedido)) as primera_compra,
        max(coalesce(sp_erp.fecha_pedido, sp_ecom.fecha_pedido)) as ultima_compra
    from {{ ref('lnk_pedido_cliente') }} lpc
    join {{ ref('lnk_pedido_producto') }} lpp on lpc.hub_pedido_hk = lpp.hub_pedido_hk
    left join {{ ref('sat_pedido_items_erp') }} si_erp on lpp.lnk_pedido_producto_hk = si_erp.lnk_pedido_producto_hk
    left join {{ ref('sat_pedido_items_ecom') }} si_ecom on lpp.lnk_pedido_producto_hk = si_ecom.lnk_pedido_producto_hk
    left join {{ ref('sat_pedidos_erp') }} sp_erp on lpc.hub_pedido_hk = sp_erp.hub_pedido_hk
    left join {{ ref('sat_pedidos_ecom') }} sp_ecom on lpc.hub_pedido_hk = sp_ecom.hub_pedido_hk
    where coalesce(sp_erp.estado, sp_ecom.estado) != 'cancelado'
    group by lpc.hub_cliente_hk
)
select
    h.hub_cliente_hk as cliente_sk,
    h.cliente_id,
    coalesce(crm.nombre_completo, erp.nombre) as nombre,
    erp.segmento,
    coalesce(erp.ciudad, 'Online') as ciudad,
    erp.fecha_registro,
    crm.email,
    crm.tipo_cliente,
    crm.telefono,
    coalesce(m.total_pedidos, 0) as total_pedidos,
    coalesce(m.monto_total, 0) as monto_total,
    m.primera_compra,
    m.ultima_compra,
    case
        when coalesce(m.total_pedidos, 0) >= 3 then 'Frecuente'
        when coalesce(m.total_pedidos, 0) = 2 then 'Recurrente'
        else 'Nuevo'
    end as frecuencia_compra,
    case
        when erp.hub_cliente_hk is not null and crm.hub_cliente_hk is not null then 'ERP + CRM'
        when crm.hub_cliente_hk is not null then 'Solo CRM'
        else 'Solo ERP'
    end as origen_datos
from hub h
left join sat_erp erp on h.hub_cliente_hk = erp.hub_cliente_hk
left join sat_crm crm on h.hub_cliente_hk = crm.hub_cliente_hk
left join metricas m on h.hub_cliente_hk = m.hub_cliente_hk
