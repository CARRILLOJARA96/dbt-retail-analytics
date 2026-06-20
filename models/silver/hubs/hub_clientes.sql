with all_sources as (
    select distinct cliente_id, 'raw.clientes' as record_source
    from {{ ref('brz_clientes') }}
    union all
    select distinct cliente_id, 'raw.crm_clientes' as record_source
    from {{ ref('brz_crm_clientes') }}
),
deduped as (
    select
        cliente_id,
        min(record_source) as record_source
    from all_sources
    group by cliente_id
)
select
    {{ generar_sk(['cliente_id']) }} as hub_cliente_hk,
    cliente_id,
    current_timestamp as load_date,
    record_source
from deduped
