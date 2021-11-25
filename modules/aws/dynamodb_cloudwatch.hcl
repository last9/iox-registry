ingester aws_dynamodb_table_operation_cloudwatch module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

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

  inputs = "$input{inputs}"

  input_query = <<-EOF
    label_set(
      label_replace(
        dynamodb_table{$input{tag_filter}}, 'id=TableName'
      ), "service", "$input{service}"
    )
  EOF

  gauge "system_errors" {
    index       = 1
    gap_fill    = "zero_fill"
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source cloudwatch "system_errors" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/DynamoDB"
        metric_name = "SystemErrors"

        dimensions = {
          "TableName" = "$input{TableName}"
          "Operation" = "$input{Operation}"
        }
      }
    }
  }

  gauge "returned_items" {
    index       = 2
    gap_fill    = "zero_fill"
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"

    source cloudwatch "returned_items" {
      query {
        aggregator  = "Maximum"
        namespace   = "AWS/DynamoDB"
        metric_name = "ReturnedItemCount"

        dimensions = {
          "TableName" = "$input{TableName}"
          "Operation" = "$input{Operation}"
        }
      }
    }
  }

  gauge "throttled" {
    index       = 3
    gap_fill    = "zero_fill"
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source cloudwatch "latency_update" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/DynamoDB"
        metric_name = "ThrottledRequests"

        dimensions = {
          "TableName" = "$input{TableName}"
          "Operation" = "$input{Operation}"
        }
      }
    }
  }

  gauge "latency" {
    index       = 4
    gap_fill    = "zero_fill"
    input_unit  = "ms"
    output_unit = "ms"
    aggregator  = "AVG"

    source cloudwatch "latency" {
      query {
        aggregator  = "Average"
        namespace   = "AWS/DynamoDB"
        metric_name = "SuccessfulRequestLatency"

        dimensions = {
          "TableName" = "$input{TableName}"
          "Operation" = "$input{Operation}"
        }
      }
    }
  }
}

ingester aws_dynamodb_table_cloudwatch module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

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

  inputs = "$input{inputs}"

  input_query = <<-EOF
    label_set(
      label_replace(
        dynamodb_table{$input{tag_filter}}, 'id=TableName'
      ), "service", "$input{service}"
    )
  EOF

  gauge "rcu" {
    index       = 1
    gap_fill    = "zero_fill"
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source cloudwatch "rcu" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/DynamoDB"
        metric_name = "ConsumedReadCapacityUnits"

        dimensions = {
          "TableName" = "$input{TableName}"
        }
      }
    }
  }

  gauge "wcu" {
    index       = 2
    gap_fill    = "zero_fill"
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source cloudwatch "wcu" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/DynamoDB"
        metric_name = "ConsumedWriteCapacityUnits"

        dimensions = {
          "TableName" = "$input{TableName}"
        }
      }
    }
  }

  gauge "read_throttled" {
    index       = 3
    gap_fill    = "zero_fill"
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source cloudwatch "read_throttled" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/DynamoDB"
        metric_name = "ReadThrottledEvents"

        dimensions = {
          "TableName" = "$input{TableName}"
        }
      }
    }
  }

  gauge "write_throttled" {
    index       = 4
    gap_fill    = "zero_fill"
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source cloudwatch "write_throttled" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/DynamoDB"
        metric_name = "WriteThrottledEvents"

        dimensions = {
          "TableName" = "$input{TableName}"
        }
      }
    }
  }
}
