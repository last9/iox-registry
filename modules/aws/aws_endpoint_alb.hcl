ingester alb_endpoint module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  using = {
    "default" : "$input{using}"
  }

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
    type = "alb"
    name = "$input{LoadBalancer}"
  }

  data_for_graph_node {
    type = "endpoint"
    name = "$input{endpoint}"
  }

  gauge "throughput" {
    unit = "tps"
    source cloudwatch "throughput" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/ApplicationELB"
        metric_name = "RequestCount"

        dimensions = {
          "LoadBalancer" = "$input{LoadBalancer}"
        }
      }
    }
  }
  latency "latency_histo" {
    error_margin = 0.05
    source cloudwatch "throughput" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/ApplicationELB"
        metric_name = "RequestCount"

        dimensions = {
          "LoadBalancer" = "$input{LoadBalancer}"
        }
      }
    }

    source cloudwatch "p50" {
      query {
        aggregator  = "p50"
        namespace   = "AWS/ApplicationELB"
        metric_name = "TargetResponseTime"

        dimensions = {
          "LoadBalancer" = "$input{LoadBalancer}"
        }
      }
    }

    source cloudwatch "p75" {
      query {
        aggregator  = "p75"
        namespace   = "AWS/ApplicationELB"
        metric_name = "TargetResponseTime"

        dimensions = {
          "LoadBalancer" = "$input{LoadBalancer}"
        }
      }
    }

    source cloudwatch "p90" {
      query {
        aggregator  = "p90"
        namespace   = "AWS/ApplicationELB"
        metric_name = "TargetResponseTime"

        dimensions = {
          "LoadBalancer" = "$input{LoadBalancer}"
        }
      }
    }

    source cloudwatch "p99" {
      query {
        aggregator  = "p99"
        namespace   = "AWS/ApplicationELB"
        metric_name = "TargetResponseTime"

        dimensions = {
          "LoadBalancer" = "$input{LoadBalancer}"
        }
      }
    }

    source cloudwatch "p100" {
      query {
        aggregator  = "p100"
        namespace   = "AWS/ApplicationELB"
        metric_name = "TargetResponseTime"

        dimensions = {
          "LoadBalancer" = "$input{LoadBalancer}"
        }
      }
    }
  }
  status_histo status_5xx {
    source cloudwatch "status_500" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/ApplicationELB"
        metric_name = "HTTPCode_Target_5XX_Count"

        dimensions = {
          "LoadBalancer" = "$input{LoadBalancer}"
        }
      }
    }
  }
  status_histo status_4xx {
    source cloudwatch "status_400" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/ApplicationELB"
        metric_name = "HTTPCode_Target_4XX_Count"

        dimensions = {
          "LoadBalancer" = "$input{LoadBalancer}"
        }
      }
    }
  }
  status_histo status_3xx {
    source cloudwatch "status_300" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/ApplicationELB"
        metric_name = "HTTPCode_Target_3XX_Count"

        dimensions = {
          "LoadBalancer" = "$input{LoadBalancer}"
        }
      }
    }
  }
  status_histo status_2xx {
    source cloudwatch "status_200" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/ApplicationELB"
        metric_name = "HTTPCode_Target_2XX_Count"

        dimensions = {
          "LoadBalancer" = "$input{LoadBalancer}"
        }
      }
    }
  }
}

ingester internalAlb_endpoint module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  using = {
    "default" : "$input{using}"
  }

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
    type = "internalAlb"
    name = "$input{LoadBalancer}"
  }

  data_for_graph_node {
    type = "endpoint"
    name = "$input{namespace}$input{endpoint}"
  }

  gauge "throughput" {
    unit = "tps"
    source cloudwatch "throughput" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/ApplicationELB"
        metric_name = "RequestCount"

        dimensions = {
          "LoadBalancer" = "$input{LoadBalancer}"
        }
      }
    }
  }
  latency "latency_histo" {
    error_margin = 0.05
    source cloudwatch "throughput" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/ApplicationELB"
        metric_name = "RequestCount"

        dimensions = {
          "LoadBalancer" = "$input{LoadBalancer}"
        }
      }
    }

    source cloudwatch "p50" {
      query {
        aggregator  = "p50"
        namespace   = "AWS/ApplicationELB"
        metric_name = "TargetResponseTime"

        dimensions = {
          "LoadBalancer" = "$input{LoadBalancer}"
        }
      }
    }

    source cloudwatch "p75" {
      query {
        aggregator  = "p75"
        namespace   = "AWS/ApplicationELB"
        metric_name = "TargetResponseTime"

        dimensions = {
          "LoadBalancer" = "$input{LoadBalancer}"
        }
      }
    }

    source cloudwatch "p90" {
      query {
        aggregator  = "p90"
        namespace   = "AWS/ApplicationELB"
        metric_name = "TargetResponseTime"

        dimensions = {
          "LoadBalancer" = "$input{LoadBalancer}"
        }
      }
    }

    source cloudwatch "p99" {
      query {
        aggregator  = "p99"
        namespace   = "AWS/ApplicationELB"
        metric_name = "TargetResponseTime"

        dimensions = {
          "LoadBalancer" = "$input{LoadBalancer}"
        }
      }
    }

    source cloudwatch "p100" {
      query {
        aggregator  = "p100"
        namespace   = "AWS/ApplicationELB"
        metric_name = "TargetResponseTime"

        dimensions = {
          "LoadBalancer" = "$input{LoadBalancer}"
        }
      }
    }
  }
  status_histo status_5xx {
    source cloudwatch "status_500" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/ApplicationELB"
        metric_name = "HTTPCode_Target_5XX_Count"

        dimensions = {
          "LoadBalancer" = "$input{LoadBalancer}"
        }
      }
    }
  }
  status_histo status_4xx {
    source cloudwatch "status_400" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/ApplicationELB"
        metric_name = "HTTPCode_Target_4XX_Count"

        dimensions = {
          "LoadBalancer" = "$input{LoadBalancer}"
        }
      }
    }
  }
  status_histo status_3xx {
    source cloudwatch "status_300" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/ApplicationELB"
        metric_name = "HTTPCode_Target_3XX_Count"

        dimensions = {
          "LoadBalancer" = "$input{LoadBalancer}"
        }
      }
    }
  }
  status_histo status_2xx {
    source cloudwatch "status_200" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/ApplicationELB"
        metric_name = "HTTPCode_Target_2XX_Count"

        dimensions = {
          "LoadBalancer" = "$input{LoadBalancer}"
        }
      }
    }
  }
}
