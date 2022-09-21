 {{ config(
    tags=["artifacts", "manifest"]
) }}

with source as (
    select * from {{ source('dbt_artifacts', 'dbt_manifest_nodes') }}
),

manifest_nodes as (

    select
        artifact_generated_at,
        trim(split(node_id, '.')[2], '"') as model_name,
        array_to_string(node_json:tags, ',') as tags,
        array_to_string(node_json:depends_on:nodes, ', ') as upstream_dependencies
    from source
    where resource_type = 'model'

)

select * from manifest_nodes
