{% snapshot snap_clientes %}
{{
    config(
      target_schema='snapshots',
      unique_key='cliente_id',
      strategy='check',
      check_cols=['segmento', 'ciudad']
    )
}}
select
    cliente_id,
    nombre,
    segmento,
    ciudad,
    fecha_registro
from {{ source('raw', 'clientes') }}
{% endsnapshot %}
