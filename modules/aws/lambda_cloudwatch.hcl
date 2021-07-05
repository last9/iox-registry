ingester aws_lambda_fn_cloudwatch module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  using = {
    "default" : "$input{using}"
  }

  label {
    type = "service"
    name = "$input{service}"
  }

  label {
    type = "namespace"
    name = "$input{namespace}"
  }

  physical_component {
    type = "aws_lambda"
    name = "$input{FunctionName}"
  }

  data_for_graph_node {
    type = "aws_lambda_fn"
    name = "$input{FunctionName}-fn"
  }

  inputs = "$input{inputs}"

  gauge "invocations" {
    unit = "count"
    aggregator = "SUM"
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

  latency "latency_histo" {
    unit = "ms"
    aggregator = "PERCENTILE"
    error_margin = "0.05"

    source cloudwatch "throughput" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/Lambda"
        metric_name = "Invocations"

        dimensions = {
          "FunctionName" = "$input{FunctionName}"
        }
      }
    }

    source cloudwatch "p50" {
      query {
        aggregator  = "p50"
        namespace   = "AWS/Lambda"
        metric_name = "Duration"

        dimensions = {
          "FunctionName" = "$input{FunctionName}"
        }
      }
    }

    source cloudwatch "p75" {
      query {
        aggregator  = "p75"
        namespace   = "AWS/Lambda"
        metric_name = "Duration"

        dimensions = {
          "FunctionName" = "$input{FunctionName}"
        }
      }
    }

    source cloudwatch "p90" {
      query {
        aggregator  = "p90"
        namespace   = "AWS/Lambda"
        metric_name = "Duration"

        dimensions = {
          "FunctionName" = "$input{FunctionName}"
        }
      }
    }

    source cloudwatch "p99" {
      query {
        aggregator  = "p99"
        namespace   = "AWS/Lambda"
        metric_name = "Duration"

        dimensions = {
          "FunctionName" = "$input{FunctionName}"
        }
      }
    }

    source cloudwatch "p100" {
      query {
        aggregator  = "p100"
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
    aggregator  = "MAX"
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
    aggregator  = "SUM"
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
    aggregator  = "SUM"
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
    aggregator  = "SUM"
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
