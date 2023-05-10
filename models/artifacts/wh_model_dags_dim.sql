{{ config(
    tags=["artifacts", "manifest", "dags"],
    alias='model_dags_dim',
    unique_key='model_dag_pk'
) }}

with manifest_nodes as (
    select * from {{ ref('stg_manifest_nodes') }}
),

final as (

    select distinct
        {{ dbt_utils.generate_surrogate_key(['model_name', 'tags', 'upstream_dependencies']) }} as model_dag_pk,
        model_name,
        first_value(tags) over (partition by model_name order by artifact_generated_at desc) as tags,
        first_value(
            upstream_dependencies
        ) over (partition by model_name order by artifact_generated_at desc) as upstream_dependencies
    from manifest_nodes

)

select * from final
