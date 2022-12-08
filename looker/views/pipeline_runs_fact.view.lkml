# The name of this view in Looker is "Wh Pipeline Runs"
view: pipeline_runs_fact {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: {{ _user_attributes['dbt_database'] }}.{{ _user_attributes['dataset'] }}_ARTIFACTS."PIPELINE_RUNS_FACT"
    ;;
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Run Elapsed Time" in Explore.

  dimension: run_elapsed_time {
    type: number
    sql: ${TABLE}."RUN_ELAPSED_TIME" ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_run_elapsed_time {
    type: sum
    sql: ${run_elapsed_time} ;;
  }

  measure: average_run_elapsed_time {
    type: average
    sql: ${run_elapsed_time} ;;
  }

  dimension: run_selection {
    type: string
    sql: ${TABLE}."RUN_SELECTION" ;;
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: run_start {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."RUN_START" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
