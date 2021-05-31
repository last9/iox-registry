ingester elb_endpoint module {
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
    type = "elb"
    name = "$input{LoadBalancerName}"
  }

  data_for_graph_node {
    type = "endpoint"
    name = "$input{namespace}/"
  }

  inputs = "$input{inputs}"

  gauge "throughput" {
    unit = "tps"
    source cloudwatch "throughput" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/ELB"
        metric_name = "RequestCount"

        dimensions = {
          "LoadBalancerName" = "$input{LoadBalancerName}"
        }
      }
    }
  }
  latency "latency_histo" {
    error_margin = 0.05
    source cloudwatch "throughput" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/ELB"
        metric_name = "RequestCount"

        dimensions = {
          "LoadBalancerName" = "$input{LoadBalancerName}"
        }
      }
    }

    source cloudwatch "p50" {
      query {
        aggregator  = "p50"
        namespace   = "AWS/ELB"
        metric_name = "Latency"

        dimensions = {
          "LoadBalancerName" = "$input{LoadBalancerName}"
        }
      }
    }

    source cloudwatch "p75" {
      query {
        aggregator  = "p75"
        namespace   = "AWS/ELB"
        metric_name = "Latency"

        dimensions = {
          "LoadBalancerName" = "$input{LoadBalancerName}"
        }
      }
    }

    source cloudwatch "p90" {
      query {
        aggregator  = "p90"
        namespace   = "AWS/ELB"
        metric_name = "Latency"

        dimensions = {
          "LoadBalancerName" = "$input{LoadBalancerName}"
        }
      }
    }

    source cloudwatch "p99" {
      query {
        aggregator  = "p99"
        namespace   = "AWS/ELB"
        metric_name = "Latency"

        dimensions = {
          "LoadBalancerName" = "$input{LoadBalancerName}"
        }
      }
    }

    source cloudwatch "p100" {
      query {
        aggregator  = "Maximum"
        namespace   = "AWS/ELB"
        metric_name = "Latency"

        dimensions = {
          "LoadBalancerName" = "$input{LoadBalancerName}"
        }
      }
    }
  }
  status_histo status_5xx {
    source cloudwatch "status_500" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/ELB"
        metric_name = "HTTPCode_Backend_5XX"

        dimensions = {
          "LoadBalancerName" = "$input{LoadBalancerName}"
        }
      }
    }
  }
  status_histo status_4xx {
    source cloudwatch "status_400" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/ELB"
        metric_name = "HTTPCode_Backend_4XX"

        dimensions = {
          "LoadBalancerName" = "$input{LoadBalancerName}"
        }
      }
    }
  }
  status_histo status_3xx {
    source cloudwatch "status_300" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/ELB"
        metric_name = "HTTPCode_Backend_3XX"

        dimensions = {
          "LoadBalancerName" = "$input{LoadBalancerName}"
        }
      }
    }
  }
  status_histo status_2xx {
    source cloudwatch "status_200" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/ELB"
        metric_name = "HTTPCode_Backend_2XX"

        dimensions = {
          "LoadBalancerName" = "$input{LoadBalancerName}"
        }
      }
    }
  }
}

ingester internalElb_endpoint module {
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
    type = "internalElb"
    name = "$input{LoadBalancerName}"
  }

  data_for_graph_node {
    type = "endpoint"
    name = "$input{endpoint}"
  }

  inputs = "$input{inputs}"

  gauge "throughput" {
    unit = "tps"
    source cloudwatch "throughput" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/ELB"
        metric_name = "RequestCount"

        dimensions = {
          "LoadBalancerName" = "$input{LoadBalancerName}"
        }
      }
    }
  }
  latency "latency_histo" {
    error_margin = 0.05
    source cloudwatch "throughput" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/ELB"
        metric_name = "RequestCount"

        dimensions = {
          "LoadBalancerName" = "$input{LoadBalancerName}"
        }
      }
    }

    source cloudwatch "p50" {
      query {
        aggregator  = "p50"
        namespace   = "AWS/ELB"
        metric_name = "Latency"

        dimensions = {
          "LoadBalancerName" = "$input{LoadBalancerName}"
        }
      }
    }

    source cloudwatch "p75" {
      query {
        aggregator  = "p75"
        namespace   = "AWS/ELB"
        metric_name = "Latency"

        dimensions = {
          "LoadBalancerName" = "$input{LoadBalancerName}"
        }
      }
    }

    source cloudwatch "p90" {
      query {
        aggregator  = "p90"
        namespace   = "AWS/ELB"
        metric_name = "Latency"

        dimensions = {
          "LoadBalancerName" = "$input{LoadBalancerName}"
        }
      }
    }

    source cloudwatch "p99" {
      query {
        aggregator  = "p99"
        namespace   = "AWS/ELB"
        metric_name = "Latency"

        dimensions = {
          "LoadBalancerName" = "$input{LoadBalancerName}"
        }
      }
    }

    source cloudwatch "p100" {
      query {
        aggregator  = "Maximum"
        namespace   = "AWS/ELB"
        metric_name = "Latency"

        dimensions = {
          "LoadBalancerName" = "$input{LoadBalancerName}"
        }
      }
    }
  }
  status_histo status_5xx {
    source cloudwatch "status_500" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/ELB"
        metric_name = "HTTPCode_Backend_5XX"

        dimensions = {
          "LoadBalancerName" = "$input{LoadBalancerName}"
        }
      }
    }
  }
  status_histo status_4xx {
    source cloudwatch "status_400" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/ELB"
        metric_name = "HTTPCode_Backend_4XX"

        dimensions = {
          "LoadBalancerName" = "$input{LoadBalancerName}"
        }
      }
    }
  }
  status_histo status_3xx {
    source cloudwatch "status_300" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/ELB"
        metric_name = "HTTPCode_Backend_3XX"

        dimensions = {
          "LoadBalancerName" = "$input{LoadBalancerName}"
        }
      }
    }
  }
  status_histo status_2xx {
    source cloudwatch "status_200" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/ELB"
        metric_name = "HTTPCode_Backend_2XX"

        dimensions = {
          "LoadBalancerName" = "$input{LoadBalancerName}"
        }
      }
    }
  }
}
