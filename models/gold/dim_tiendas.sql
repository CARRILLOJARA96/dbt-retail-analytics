with hub as (
    select * from {{ ref('hub_tiendas') }}
),
sat as (
    select * from {{ ref('sat_tiendas') }}
)
select
    h.hub_tienda_hk as tienda_sk,
    h.tienda_id,
    s.nombre_tienda,
    s.region,
    s.ciudad,
    s.formato,
    s.fecha_apertura
from hub h
join sat s on h.hub_tienda_hk = s.hub_tienda_hk
