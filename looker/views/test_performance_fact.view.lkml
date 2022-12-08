# The name of this view in Looker is "Test Performance Fact"
view: test_performance_fact {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: {{ _user_attributes['dbt_database'] }}.{{ _user_attributes['dataset'] }}_ARTIFACTS."TEST_PERFORMANCE_FACT"
    ;;
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Artifact Run ID" in Explore.

  dimension: artifact_run_id {
    type: string
    sql: ${TABLE}."ARTIFACT_RUN_ID" ;;
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: end {
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
    sql: ${TABLE}."END_DATE" ;;
  }

  dimension: error_message {
    type: string
    sql: ${TABLE}."ERROR_MESSAGE" ;;
  }

  dimension_group: start {
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
    sql: ${TABLE}."START_DATE" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
    html:
    {% if value == 'PASS' %}
    <p style="color: green; background-color: green; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% elsif value == 'WARN' %}
    <p style="color: yellow; background-color: yellow; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% else %}
    <p style="color: red; background-color: red; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% endif %}
    ;;
  }

  dimension: test_name {
    type: string
    sql: ${TABLE}."MODEL_NAME" ;;
  }

  dimension: test_performance_pk {
    type: string
    sql: ${TABLE}."TEST_PERFORMANCE_PK" ;;
  }

  dimension: total_node_runtime {
    type: number
    sql: ${TABLE}."TOTAL_NODE_RUNTIME" ;;
  }

  measure: successful_runs {
    type: sum
    sql: case when ${status} = 'PASS' then 1 else 0 end;;
  }

  measure: total_runs {
    type: count
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_total_node_runtime {
    type: sum
    sql: ${total_node_runtime} ;;
  }

  measure: average_total_node_runtime {
    type: average
    sql: ${total_node_runtime} ;;
  }

  dimension: was_full_refresh {
    type: yesno
    sql: ${TABLE}."WAS_FULL_REFRESH" ;;
  }

  measure: count {
    type: count
    drill_fields: [test_name]
  }
}
