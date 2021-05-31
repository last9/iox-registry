ingester aws_lambda module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  label {
    type = "service"
    name = "$input{service}"
  }

  physical_component {
    type = "aws_lambda"
    name = "$input{FunctionName}"
  }

  data_for_graph_node {
    type = "aws_lambda"
    name = "$input{FunctionName}"
  }

  using = {
    "default" : "$input{using}"
  }

  inputs = "$input{inputs}"

  gauge "invocations" {
    unit = "count"
    source cloudwatch "invocations" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/Lambda"
        metric_name = "Invocations"

        dimensions = {
          "FunctionName" = "$input{FunctionName}"
        }
      }
    }
  }

  gauge "duration" {
    unit = "millisecond"
    source cloudwatch "duration" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/Lambda"
        metric_name = "Duration"

        dimensions = {
          "FunctionName" = "$input{FunctionName}"
        }
      }
    }
  }

  gauge "concurrent_executions" {
    unit = "count"
    source cloudwatch "concurrent_executions" {
      query {
        aggregator  = "Maximum"
        namespace   = "AWS/Lambda"
        metric_name = "ConcurrentExecutions"

        dimensions = {
          "FunctionName" = "$input{FunctionName}"
        }
      }
    }
  }

  gauge "concurrency_spillover" {
    unit = "count"
    source cloudwatch "concurrency_spillover" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/Lambda"
        metric_name = "ProvisionedConcurrencySpilloverInvocations"

        dimensions = {
          "FunctionName" = "$input{FunctionName}"
        }
      }
    }
  }

  gauge "throttles" {
    unit = "count"
    source cloudwatch "throttles" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/Lambda"
        metric_name = "Throttles"

        dimensions = {
          "FunctionName" = "$input{FunctionName}"
        }
      }
    }
  }

  gauge "errors" {
    unit = "count"
    source cloudwatch "errors" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/Lambda"
        metric_name = "Errors"

        dimensions = {
          "FunctionName" = "$input{FunctionName}"
        }
      }
    }
  }
}
