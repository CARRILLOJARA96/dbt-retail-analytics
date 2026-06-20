with hub as (
    select * from {{ ref('hub_productos') }}
),
sat_erp as (
    select * from {{ ref('sat_productos_erp') }}
),
sat_ecom as (
    select * from {{ ref('sat_productos_ecom') }}
)
select
    h.hub_producto_hk as producto_sk,
    h.producto_id,
    coalesce(erp.producto_nombre, ecom.nombre_producto) as producto_nombre,
    erp.categoria_id,
    coalesce(erp.categoria_nombre, ecom.categoria) as categoria_nombre,
    ecom.precio_base as precio_base_ecom,
    case
        when erp.hub_producto_hk is not null then 'Fisico'
        else 'Digital'
    end as tipo_producto
from hub h
left join sat_erp erp on h.hub_producto_hk = erp.hub_producto_hk
left join sat_ecom ecom on h.hub_producto_hk = ecom.hub_producto_hk
