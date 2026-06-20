with source as (
    select distinct tienda_id
    from {{ ref('brz_tiendas') }}
)
select
    {{ generar_sk(['tienda_id']) }} as hub_tienda_hk,
    tienda_id,
    current_timestamp as load_date,
    'raw.tiendas' as record_source
from source
