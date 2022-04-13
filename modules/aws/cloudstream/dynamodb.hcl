ingester aws_dynamodb_table_operation_cloudstream module {
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
    type = "dynamodb_operation"
    name = "$input{Operation}"
  }

  using = {
    default = "$input{using}"
  }

  gauge "system_errors" {
    index       = 1
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "system_errors" {
      query = "sum by (TableName) (amazonaws_com_AWS_DynamoDB_SystemErrors_sum{TableName=~'$input{TableName}',Operation='$input{Operation}'})"

      join_on = {
        "$output{TableName}" = "$input{TableName}"
        "$output{Operation}" = "$input{Operation}"
      }
    }
  }

  gauge "returned_items" {
    index       = 2
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"

    source prometheus "returned_items" {
      query = "sum by (TableName) (amazonaws_com_AWS_DynamoDB_ReturnedItemCount{quantile='1', TableName=~'$input{TableName}',Operation='$input{Operation}'})"

      join_on = {
          "$output{TableName}" = "$input{TableName}"
          "$output{Operation}" = "$input{Operation}"
      }
    }
  }

  gauge "throttled" {
    index       = 3
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "latency_update" {
      query = "sum by (TableName) (amazonaws_com_AWS_DynamoDB_ThrottledRequests_sum{TableName=~'$input{TableName}',Operation='$input{Operation}'})"

      join_on = {
          "$output{TableName}" = "$input{TableName}"
          "$output{Operation}" = "$input{Operation}"
      }
    }
  }

}

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
