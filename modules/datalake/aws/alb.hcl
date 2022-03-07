ingester aws_alb_cloudwatch module {
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
    type = "alb"
    name = "alb"
  }

  data_for_graph_node {
    type = "alb"
    name = "$input{LoadBalancer}"
  }

  gauge "throughput" {
    index       = 1
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"

    source prometheus "throughput" {
      query = "sum by (LoadBalancer, tag_service, tag_namespace) (throughput)"

      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
      }
    }
  }

  gauge "new_connections" {
    index       = 4
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "new_connections" {
      query = "sum by (LoadBalancer, tag_service, tag_namespace) (new_connections)"

      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
      }
    }
  }

  gauge "rejected_connections" {
    index       = 5
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "rejected_connections" {
      query = "sum by (LoadBalancer, tag_service, tag_namespace) (rejected_connections)"

      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
      }
    }
  }

  gauge "processed_bytes" {
    index       = 6
    input_unit  = "bytes"
    output_unit = "bytes"
    aggregator  = "SUM"

    source prometheus "processed_bytes" {
      query = "sum by (LoadBalancer, tag_service, tag_namespace) (processed_bytes)"

      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
      }
    }
  }

  gauge "lcu" {
    index       = 3
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "lcu" {
      query = "sum by (LoadBalancer, tag_service, tag_namespace) (lcu)"

      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
      }
    }
  }

  status_histo status_5xx {
    index       = 5
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"

    source prometheus "status_5xx" {
      query = "sum by (LoadBalancer, tag_service, tag_namespace) (status_5xx)"

      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
      }
    }
  }

  status_histo status_4xx {
    index       = 4
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"

    source prometheus "status_4xx" {
      query = "sum by (LoadBalancer, tag_service, tag_namespace) (status_4xx)"

      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
      }
    }
  }

  gauge lb_5xx {
    index       = 8
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"

    source prometheus "lb_5xx" {
      query = "sum by (LoadBalancer, tag_service, tag_namespace) (lb_5xx)"

      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
      }
    }
  }

  gauge lb_4xx {
    index       = 7
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"

    source prometheus "lb_4xx" {
      query = "sum by (LoadBalancer, tag_service, tag_namespace) (lb_4xx)"

      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
      }
    }
  }

  latency "latency_histo" {
    index        = 6
    input_unit   = "ms"
    output_unit  = "ms"
    aggregator   = "PERCENTILE"
    error_margin = 0.05

    source prometheus "throughput" {
      query = "sum by (LoadBalancer, tag_service, tag_namespace) (throughput)"
      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
      }
    }

    source prometheus "p50" {
      query = "avg by (LoadBalancer, TargetGroup, tag_service, tag_namespace) (latency{latency='p50'})"
      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
      }
    }

    source prometheus "p75" {
      query = "avg by (LoadBalancer, TargetGroup, tag_service, tag_namespace) (latency{latency='p75'})"
      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
      }
    }

    source prometheus "p90" {
      query = "avg by (LoadBalancer, TargetGroup, tag_service, tag_namespace) (latency{latency='p90'})"
      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
      }
    }

    source prometheus "p99" {
      query = "avg by (LoadBalancer, TargetGroup, tag_service, tag_namespace) (latency{latency='p99'})"
      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
      }
    }

    source prometheus "p100" {
      query = "avg by (LoadBalancer, TargetGroup, tag_service, tag_namespace) (latency{latency='p100'})"
      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
      }
    }
  }
}


ingester aws_alb_tg_cloudwatch module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  using = {
    "default" : "$input{using}"
  }

  inputs = "$input{input}"

  label {
    type = "service"
    name = "$output{tag_service}"
  }

  label {
    type = "namespace"
    name = "$output{tag_namespace}"
  }

  physical_component {
    type = "alb"
    name = "alb"
  }

  physical_address {
    type = "alb_target_group"
    name = "$input{TargetGroup}"
  }

  data_for_graph_node {
    type = "alb_logical"
    name = "lb: $input{LoadBalancer}"
  }

  gauge "throughput" {
    index       = 1
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"
    source prometheus "throughput" {
      query = "sum by (LoadBalancer, TargetGroup, tag_service, tag_namespace) (throughput)"

      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
        "$output{TargetGroup}"  = "$input{TargetGroup}"
      }
    }
  }

  latency "latency_histo" {
    index        = 6
    input_unit   = "ms"
    output_unit  = "ms"
    aggregator   = "PERCENTILE"
    error_margin = 0.05
    source prometheus "throughput" {
      query = "sum by (LoadBalancer, TargetGroup, tag_service, tag_namespace) (throughput)"
      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
        "$output{TargetGroup}"  = "$input{TargetGroup}"
      }
    }

    source prometheus "p50" {
      query = "avg by (LoadBalancer, TargetGroup, tag_service, tag_namespace) (latency{latency='p50'})"
      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
        "$output{TargetGroup}"  = "$input{TargetGroup}"
      }
    }

    source prometheus "p75" {
      query = "avg by (LoadBalancer, TargetGroup, tag_service, tag_namespace) (latency{latency='p75'})"
      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
        "$output{TargetGroup}"  = "$input{TargetGroup}"
      }
    }

    source prometheus "p90" {
      query = "avg by (LoadBalancer, TargetGroup, tag_service, tag_namespace) (latency{latency='p90'})"
      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
        "$output{TargetGroup}"  = "$input{TargetGroup}"
      }
    }

    source prometheus "p99" {
      query = "avg by (LoadBalancer, TargetGroup, tag_service, tag_namespace) (latency{latency='p99'})"
      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
        "$output{TargetGroup}"  = "$input{TargetGroup}"
      }
    }

    source prometheus "p100" {
      query = "avg by (LoadBalancer, TargetGroup, tag_service, tag_namespace) (latency{latency='p100'})"
      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
        "$output{TargetGroup}"  = "$input{TargetGroup}"
      }
    }
  }

  status_histo status_5xx {
    index       = 5
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"
    source prometheus "status_500" {
      query = "sum by (LoadBalancer, TargetGroup, tag_service, tag_namespace) (status_5xx)"
      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
        "$output{TargetGroup}"  = "$input{TargetGroup}"
      }
    }
  }

  status_histo status_4xx {
    index       = 4
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"
    source prometheus "status_400" {
      query = "sum by (LoadBalancer, TargetGroup, tag_service, tag_namespace) (status_4xx)"
      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
        "$output{TargetGroup}"  = "$input{TargetGroup}"
      }
    }
  }

  status_histo status_3xx {
    index       = 3
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"
    source prometheus "status_300" {
      query = "sum by (LoadBalancer, TargetGroup, tag_service, tag_namespace) (status_3xx)"
      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
        "$output{TargetGroup}"  = "$input{TargetGroup}"
      }
    }
  }

  status_histo status_2xx {
    index       = 2
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"
    source prometheus "status_200" {
      query = "sum by (LoadBalancer, TargetGroup, tag_service, tag_namespace) (status_2xx)"
      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
        "$output{TargetGroup}"  = "$input{TargetGroup}"
      }
    }
  }
}
