ingester aws_lambda module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  inputs = "$input{input}"

  using = {
    "default" = "$input{using}"
  }

  label {
    type = "namespace"
    name = "$output{tag_namespace}"
  }

  label {
    type = "service"
    name = "$output{tag_service}"
  }

  physical_component {
    type = "aws_lambda"
    name = "$input{FunctionName}"
  }

  data_for_graph_node {
    type = "aws_lambda"
    name = "$input{FunctionName}"
  }

  gauge "invocations" {
    index       = 1
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "invocations" {
      query = "sum by (FunctionName, tag_namespace, tag_service) (invocations)"

      join_on = {
        "$output{FunctionName}" = "$input{FunctionName}"
      }
    }
  }

  latency "latency_histo" {
    index        = 6
    input_unit   = "ms"
    output_unit  = "ms"
    aggregator   = "PERCENTILE"
    error_margin = "0.05"
    multiplier   = 1

    source prometheus "throughput" {
      query = "avg by (FunctionName, tag_namespace, tag_service) (latency_histo{le='throughput'})"

      join_on = {
        "$output{FunctionName}" = "$input{FunctionName}"
      }
    }

    source prometheus "p50" {
      query = "avg by (FunctionName, tag_namespace, tag_service) (latency_histo{le='p50'})"

      join_on = {
        "$output{FunctionName}" = "$input{FunctionName}"
      }
    }

    source prometheus "p75" {
      query = "avg by (FunctionName, tag_namespace, tag_service) (latency_histo{le='p75'})"

      join_on = {
        "$output{FunctionName}" = "$input{FunctionName}"
      }
    }

    source prometheus "p90" {
      query = "avg by (FunctionName, tag_namespace, tag_service) (latency_histo{le='p90'})"

      join_on = {
        "$output{FunctionName}" = "$input{FunctionName}"
      }
    }

    source prometheus "p99" {
      query = "avg by (FunctionName, tag_namespace, tag_service) (latency_histo{le='p99'})"

      join_on = {
        "$output{FunctionName}" = "$input{FunctionName}"
      }
    }

    source prometheus "p100" {
      query = "avg by (FunctionName, tag_namespace, tag_service) (latency_histo{le='p100'})"

      join_on = {
        "$output{FunctionName}" = "$input{FunctionName}"
      }
    }
  }

  gauge "concurrent_executions" {
    index       = 3
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "concurrent_executions" {
      query = "sum by (FunctionName, tag_namespace, tag_service) (concurrent_executions)"

      join_on = {
        "$output{FunctionName}" = "$input{FunctionName}"
      }
    }
  }

  gauge "concurrency_spillover" {
    index       = 4
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "concurrency_spillover" {
      query = "sum by (FunctionName, tag_namespace, tag_service) (concurrency_spillover)"

      join_on = {
        "$output{FunctionName}" = "$input{FunctionName}"
      }
    }
  }

  gauge "throttles" {
    index       = 5
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "throttles" {
      query = "sum by (FunctionName, tag_namespace, tag_service) (throttles)"

      join_on = {
        "$output{FunctionName}" = "$input{FunctionName}"
      }
    }
  }

  gauge "errors" {
    index       = 6
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "errors" {
      query = "sum by (FunctionName, tag_namespace, tag_service) (errors)"

      join_on = {
        "$output{FunctionName}" = "$input{FunctionName}"
      }
    }
  }
}
