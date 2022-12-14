{% macro upload_artifacts_wrapper() %}

{% if target.name in [ var('target_dev'), var('target_prod') ] and flags.WHICH in ['run','test','build'] %}

  {{ upload_dbt_artifacts_v2() }}

{% endif %}

{% endmacro %}
