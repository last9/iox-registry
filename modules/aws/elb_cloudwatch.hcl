ingester aws_elb_cloudwatch module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  inputs = "$input{inputs}"

  input_query = <<-EOF
  label_set(
    label_replace(
      elasticloadbalancing_loadbalancer{id!~".*/.*",$input{tag_filter}}, 'id=LoadBalancerName'
   ), "service", "$input{service}", "namespace", "$input{namespace}"
 )
 EOF

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
    type = "elb"
    name = "$input{LoadBalancerName}"
  }

  using = {
    "default" : "$input{using}"
  }

  gauge "throughput" {
    index       = 1
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"
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
    index       = 2
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"
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
    index       = 3
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"
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
    index       = 4
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"
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
    index       = 5
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"
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
    index       = 4
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"
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

  status_histo status_2xx {
    index       = 9
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"
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

  gauge lb_5xx {
    index       = 8
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"
    source cloudwatch "lb_500" {
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
  gauge lb_4xx {
    index       = 7
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"
    source cloudwatch "lb_400" {
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

  gauge "latency_max" {
    index       = 15
    input_unit  = "s"
    output_unit = "ms"
    aggregator  = "MAX"
    source cloudwatch "latency_max" {
      query {
        aggregator  = "p99"
        namespace   = "AWS/ApplicationELB"
        metric_name = "TargetResponseTime"

        dimensions = {
          "LoadBalancerName" = "$input{LoadBalancerName}"
        }
      }
    }
  }

  latency "latency_histo" {
    index        = 6
    input_unit   = "ms"
    output_unit  = "ms"
    aggregator   = "PERCENTILE"
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
}

ingester aws_elb_internal_cloudwatch module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  inputs = "$input{inputs}"

  input_query = <<-EOF
  label_set(
    label_replace(
      elasticloadbalancing_loadbalancer{id!~".*/.*",$input{tag_filter}}, 'id=LoadBalancerName'
   ), "service", "$input{service}", "namespace", "$input{namespace}"
 )
 EOF

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
    type = "internalElb"
    name = "$input{LoadBalancerName}"
  }

  using = {
    "default" : "$input{using}"
  }

  gauge "throughput" {
    index       = 1
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"
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
    index       = 2
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"
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
    index       = 3
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"
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
    index       = 4
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"
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
    index       = 5
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"
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
    index       = 4
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"
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

  status_histo status_2xx {
    index       = 9
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"
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


  gauge lb_5xx {
    index       = 8
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"
    source cloudwatch "lb_500" {
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
  gauge lb_4xx {
    index       = 7
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"
    source cloudwatch "lb_400" {
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

  gauge "latency_max" {
    index       = 15
    input_unit  = "s"
    output_unit = "ms"
    aggregator  = "MAX"
    source cloudwatch "latency_max" {
      query {
        aggregator  = "p99"
        namespace   = "AWS/ApplicationELB"
        metric_name = "TargetResponseTime"

        dimensions = {
          "LoadBalancerName" = "$input{LoadBalancerName}"
        }
      }
    }
  }

  latency "latency_histo" {
    index        = 6
    input_unit   = "ms"
    output_unit  = "ms"
    aggregator   = "PERCENTILE"
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

  input_query = <<-EOF
  label_set(
    label_replace(
      elasticloadbalancing_loadbalancer{id!~".*/.*",$input{tag_filter}}, 'id=LoadBalancerName'
   ), "service", "$input{service}", "namespace", "$input{namespace}"
 )
 EOF

  gauge "throughput" {
    index       = 1
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"
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

  gauge "latency_max" {
    index       = 15
    input_unit  = "s"
    output_unit = "ms"
    aggregator  = "MAX"
    source cloudwatch "latency_max" {
      query {
        aggregator  = "p99"
        namespace   = "AWS/ApplicationELB"
        metric_name = "TargetResponseTime"

        dimensions = {
          "LoadBalancerName" = "$input{LoadBalancerName}"
        }
      }
    }
  }

  latency "latency_histo" {
    index        = 6
    input_unit   = "ms"
    output_unit  = "ms"
    aggregator   = "PERCENTILE"
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
    index       = 5
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"
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
    index       = 4
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"
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
    index       = 3
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"
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
    index       = 2
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"
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

  gauge lb_5xx {
    index       = 8
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"
    source cloudwatch "lb_500" {
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
  gauge lb_4xx {
    index       = 7
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"
    source cloudwatch "lb_400" {
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

  input_query = <<-EOF
  label_set(
    label_replace(
      elasticloadbalancing_loadbalancer{id!~".*/.*",$input{tag_filter}}, 'id=LoadBalancerName'
   ), "service", "$input{service}", "namespace", "$input{namespace}"
 )
 EOF

  gauge "throughput" {
    index       = 1
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"
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

  gauge "latency_max" {
    index       = 15
    input_unit  = "s"
    output_unit = "ms"
    aggregator  = "MAX"
    source cloudwatch "latency_max" {
      query {
        aggregator  = "p99"
        namespace   = "AWS/ApplicationELB"
        metric_name = "TargetResponseTime"

        dimensions = {
          "LoadBalancerName" = "$input{LoadBalancerName}"
        }
      }
    }
  }

  latency "latency_histo" {
    index        = 6
    input_unit   = "ms"
    output_unit  = "ms"
    aggregator   = "PERCENTILE"
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
    index       = 5
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"
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
    index       = 4
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"
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
    index       = 3
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"
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
    index       = 2
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"
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
  gauge lb_5xx {
    index       = 8
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"
    source cloudwatch "lb_500" {
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
  gauge lb_4xx {
    index       = 7
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"
    source cloudwatch "lb_400" {
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
