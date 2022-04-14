ingester aws_dynamodb_table_cloudstream module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  inputs = "$input{inputs}"

  label {
    type = "service"
    name = "$input{service}"
  }

  label {
    type = "namespace"
    name = "$input{namespace}"
  }

  physical_component {
    type = "dynamodb"
    name = "$input{TableName}"
  }

  data_for_graph_node {
    type = "dynamodb"
    name = "$input{TableName}"
  }

  using = {
    default = "$input{using}"
  }

  gauge "rcu" {
    index       = 1
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "rcu" {
      query = "sum by (TableName) (amazonaws_com_AWS_DynamoDB_ConsumedReadCapacityUnits_sum{TableName=~'$input{TableName}'})"

      join_on = {
        "$output{TableName}" = "$input{TableName}"
      }
    }
  }

  gauge "wcu" {
    index       = 2
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "wcu" {
      query = "sum by (TableName) (amazonaws_com_AWS_DynamoDB_ConsumedWriteCapacityUnits_sum{TableName=~'$input{TableName}'})"

      join_on = {
        "$output{TableName}" = "$input{TableName}"
      }
    }
  }

  gauge "read_throttled" {
    index       = 3
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "read_throttled" {
      query = "sum by (TableName) (amazonaws_com_AWS_DynamoDB_ReadThrottledEvents_sum{TableName=~'$input{TableName}'})"

      join_on = {
        "$output{TableName}" = "$input{TableName}"
      }
    }
  }

  gauge "write_throttled" {
    index       = 4
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "write_throttled" {
      query = "sum by (TableName) (amazonaws_com_AWS_DynamoDB_WriteThrottledEvents_sum{TableName=~'$input{TableName}'})"

      join_on = {
        "$output{TableName}" = "$input{TableName}"
      }
    }
  }
}
