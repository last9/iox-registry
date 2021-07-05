ingester aws_elb_cloudwatch module {
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

  physical_component {
    type = "elb"
    name = "$input{LoadBalancerName}"
  }

  data_for_graph_node {
    type = "elb"
    name = "$input{LoadBalancerName}"
  }

  using = {
    "default" : "$input{using}"
  }

  gauge "throughput" {
    unit = "count"
    aggregator = "SUM"
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
  gauge "surge_queue_length" {
    unit = "count"
    aggregator = "MAX"
    source cloudwatch "surge_queue_length" {
      query {
        aggregator  = "Maximum"
        namespace   = "AWS/ELB"
        metric_name = "SurgeQueueLength"

        dimensions = {
          "LoadBalancerName" = "$input{LoadBalancerName}"
        }
      }
    }
  }
  gauge "connection_errors" {
    unit = "count"
    aggregator = "SUM"
    source cloudwatch "connection_errors" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/ELB"
        metric_name = "BackendConnectionErrors"

        dimensions = {
          "LoadBalancerName" = "$input{LoadBalancerName}"
        }
      }
    }
  }
  gauge "unhealthy_hosts" {
    unit = "count"
    aggregator = "MAX"
    source cloudwatch "unhealthy_hosts" {
      query {
        aggregator  = "Maximum"
        namespace   = "AWS/ELB"
        metric_name = "UnHealthyHostCount"

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
    source cloudwatch "status_501" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/ELB"
        metric_name = "HTTPCode_ELB_5XX"

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
    source cloudwatch "status_401" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/ELB"
        metric_name = "HTTPCode_ELB_4XX"

        dimensions = {
          "LoadBalancerName" = "$input{LoadBalancerName}"
        }
      }
    }
  }
}

ingester aws_elb_internal_cloudwatch module {
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

  physical_component {
    type = "internalElb"
    name = "$input{LoadBalancerName}"
  }

  data_for_graph_node {
    type = "internalElb"
    name = "$input{LoadBalancerName}"
  }

  using = {
    "default" : "$input{using}"
  }

  gauge "throughput" {
    unit = "count"
    aggregator = "SUM"
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
  gauge "surge_queue_length" {
    unit = "count"
    aggregator = "MAX"
    source cloudwatch "surge_queue_length" {
      query {
        aggregator  = "Maximum"
        namespace   = "AWS/ELB"
        metric_name = "SurgeQueueLength"

        dimensions = {
          "LoadBalancerName" = "$input{LoadBalancerName}"
        }
      }
    }
  }
  gauge "connection_errors" {
    unit = "count"
    aggregator = "SUM"
    source cloudwatch "connection_errors" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/ELB"
        metric_name = "BackendConnectionErrors"

        dimensions = {
          "LoadBalancerName" = "$input{LoadBalancerName}"
        }
      }
    }
  }
  gauge "unhealthy_hosts" {
    unit = "count"
    aggregator = "MAX"
    source cloudwatch "unhealthy_hosts" {
      query {
        aggregator  = "Maximum"
        namespace   = "AWS/ELB"
        metric_name = "UnHealthyHostCount"

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
    source cloudwatch "status_501" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/ELB"
        metric_name = "HTTPCode_ELB_5XX"

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
    source cloudwatch "status_401" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/ELB"
        metric_name = "HTTPCode_ELB_4XX"

        dimensions = {
          "LoadBalancerName" = "$input{LoadBalancerName}"
        }
      }
    }
  }
}

ingester aws_elb_endpoint_cloudwatch module {
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
    unit = "count"
    aggregator = "SUM"
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
    unit = "s"
    aggregator = "percentile"
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
    unit = "count"
    aggregator = "SUM"
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
    source cloudwatch "status_501" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/ELB"
        metric_name = "HTTPCode_ELB_5XX"

        dimensions = {
          "LoadBalancerName" = "$input{LoadBalancerName}"
        }
      }
    }
  }
  status_histo status_4xx {
    unit = "count"
    aggregator = "SUM"
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
    source cloudwatch "status_401" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/ELB"
        metric_name = "HTTPCode_ELB_4XX"

        dimensions = {
          "LoadBalancerName" = "$input{LoadBalancerName}"
        }
      }
    }
  }
  status_histo status_3xx {
    unit = "count"
    aggregator = "SUM"
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
    unit = "count"
    aggregator = "SUM"
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

ingester aws_elb_internal_endpoint_cloudwatch module {
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
    unit = "count"
    aggregator = "SUM"
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
    unit = "s"
    aggregator = "percentile"
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
    unit = "count"
    aggregator = "SUM"
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
    source cloudwatch "status_501" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/ELB"
        metric_name = "HTTPCode_ELB_5XX"

        dimensions = {
          "LoadBalancerName" = "$input{LoadBalancerName}"
        }
      }
    }
  }
  status_histo status_4xx {
    unit = "count"
    aggregator = "SUM"
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
    source cloudwatch "status_401" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/ELB"
        metric_name = "HTTPCode_ELB_4XX"

        dimensions = {
          "LoadBalancerName" = "$input{LoadBalancerName}"
        }
      }
    }
  }
  status_histo status_3xx {
    unit = "count"
    aggregator = "SUM"
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
    unit = "count"
    aggregator = "SUM"
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
