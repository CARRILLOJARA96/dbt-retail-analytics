{#
  Macro reutilizable: genera un surrogate key (hash MD5) a partir de una
  lista de columnas, normalizando nulos. Se usa en dim_clientes y fct_ventas.
#}
{% macro generar_sk(columns) %}
    md5(concat_ws('||',
        {%- for c in columns %}
        coalesce(cast({{ c }} as varchar), ''){% if not loop.last %},{% endif %}
        {%- endfor %}
    ))
{% endmacro %}
