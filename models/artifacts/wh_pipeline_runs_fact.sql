{{ config(
    tags=["artifacts", "pipeline"],
    alias='pipeline_runs_fact',
    unique_key='pipeline_run_pk'
) }}

with pipeline_runs as (
    select * from {{ ref('stg_pipeline_runs') }}
),

final as (

    select
        {{ dbt_utils.generate_surrogate_key(['run_start', 'run_elapsed_time', 'run_selection']) }} as pipeline_run_pk,
        *
    from pipeline_runs

)

select * from final
