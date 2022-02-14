ingester aws_lambda_cloudstream module {
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
    type = "aws_lambda"
    name = "$input{FunctionName}"
  }

  inputs = "$input{inputs}"

  //  input_query = <<-EOF
  //    label_set(
  //      label_replace(
  //        lambda_function{$input{tag_filter}}, 'id=FunctionName'
  //      ), "Service", "$input{service}", "Namespace", "$input{namespace}"
  //    )
  //  EOF

  gauge "invocations" {
    index       = 1
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "invocations" {
      query = "sum by (FunctionName) (amazonaws_com_AWS_Lambda_Invocations_sum{FunctionName='$input{FunctionName}'})"
      join_on = {
        "$output{FunctionName}" = "$input{FunctionName}"
      }
    }

  }

  gauge "latency_min" {
    index       = 2
    input_unit  = "s"
    output_unit = "ms"
    aggregator  = "MIN"

    source prometheus "latency_min" {
      query = "sum by (FunctionName) (amazonaws_com_AWS_Lambda_Duration{FunctionName='$input{FunctionName}', quantile='0'})"

      join_on = {
        "$output{FunctionName}" = "$input{FunctionName}"
      }
    }
  }

  gauge "latency_max" {
    index       = 3
    input_unit  = "s"
    output_unit = "ms"
    aggregator  = "MAX"

    source prometheus "latency_max" {
      query = "sum by (FunctionName) (amazonaws_com_AWS_Lambda_Duration{FunctionName='$input{FunctionName}', quantile='1'})"

      join_on = {
        "$output{FunctionName}" = "$input{FunctionName}"
      }
    }
  }

  gauge "latency_avg" {
    index       = 4
    input_unit  = "s"
    output_unit = "ms"
    aggregator  = "AVG"

    source prometheus "latency_avg" {
      query = "sum by (FunctionName) (amazonaws_com_AWS_Lambda_Duration_sum{FunctionName='$input{FunctionName}'}) / sum by (FunctionName) (amazonaws_com_AWS_Lambda_Duration_count{FunctionName='$input{FunctionName}'}) "

      join_on = {
        "$output{FunctionName}" = "$input{FunctionName}"
      }
    }
  }

  gauge "concurrent_executions" {
    index       = 5
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"

    source prometheus "concurrent_executions" {
      query = "sum by (FunctionName) (amazonaws_com_AWS_Lambda_ConcurrentExecutions{FunctionName='$input{FunctionName}', quantile='1'})"

      join_on = {
        "$output{FunctionName}" = "$input{FunctionName}"
      }
    }
  }

  gauge "concurrency_spillover" {
    index       = 6
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "concurrency_spillover" {
      query = "sum by (FunctionName) (amazonaws_com_AWS_Lambda_UnreservedConcurrentExecutions_sum{FunctionName='$input{FunctionName}'})"
      join_on = {
        "$output{FunctionName}" = "$input{FunctionName}"
      }
    }
  }

  gauge "throttles" {
    index       = 7
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "throttles" {
      query = "sum by (FunctionName) (amazonaws_com_AWS_Lambda_Throttles_sum{FunctionName='$input{FunctionName}'})"
      join_on = {
        "$output{FunctionName}" = "$input{FunctionName}"
      }
    }

  }

  gauge "errors" {
    index       = 8
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "errors" {
      query = "sum by (FunctionName) (amazonaws_com_AWS_Lambda_Errors_sum{FunctionName='$input{FunctionName}'})"
      join_on = {
        "$output{FunctionName}" = "$input{FunctionName}"
      }
    }
  }
}
