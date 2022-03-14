ingester aws_elb module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  inputs = "[]"

  label {
    type = "service"
    name = "$output{tag_service}"
  }

  label {
    type = "namespace"
    name = "$output{tag_namespace}"
  }

  physical_component {
    type = "elb"
    name = "ELB"
  }

  data_for_graph_node {
    type = "elb_logical"
    name = "$output{LoadBalancerName}"
  }

  using = {
    "default" = "$input{using}"
  }

  gauge "throughput" {
    index       = 1
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"

    source prometheus "throughput" {
      query = "sum by (LoadBalancerName, tag_namespace, tag_service) (throughput{LoadBalancerName!=''})"
    }
  }

  gauge "surge_queue_length" {
    index       = 2
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "MAX"

    source prometheus "surge_queue_length" {
      query = "max by (LoadBalancerName, tag_namespace, tag_service) (surge_queue_length{LoadBalancerName!=''})"
    }
  }

  gauge "connection_errors" {
    index       = 3
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "connection_errors" {
      query = "sum by (LoadBalancerName, tag_namespace, tag_service) (connection_errors{LoadBalancerName!=''})"
    }
  }

  gauge "unhealthy_hosts" {
    index       = 4
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"

    source prometheus "unhealthy_hosts" {
      query = "max by (LoadBalancerName, tag_namespace, tag_service) (unhealthy_hosts{LoadBalancerName!=''})"
    }
  }

  status_histo status_5xx {
    index       = 5
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"

    source prometheus "status_5xx" {
      query = "sum by (LoadBalancerName, tag_namespace, tag_service) (status_5xx{LoadBalancerName!=''})"
    }
  }

  status_histo status_4xx {
    index       = 4
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"

    source prometheus "status_4xx" {
      query = "sum by (LoadBalancerName, tag_namespace, tag_service) (status_4xx{LoadBalancerName!=''})"
    }
  }

  gauge lb_5xx {
    index       = 8
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"

    source prometheus "lb_5xx" {
      query = "sum by (LoadBalancerName, tag_namespace, tag_service) (lb_5xx{LoadBalancerName!=''})"
    }
  }

  gauge lb_4xx {
    index       = 7
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"

    source prometheus "lb_4xx" {
      query = "sum by (LoadBalancerName, tag_namespace, tag_service) (lb_4xx{LoadBalancerName!=''})"
    }
  }

  latency "latency_histo" {
    index        = 6
    input_unit   = "ms"
    output_unit  = "ms"
    aggregator   = "PERCENTILE"
    error_margin = 0.05

    source prometheus "throughput" {
      query = "avg by (LoadBalancerName, tag_namespace, tag_service) (latency_histo{le='throughput',LoadBalancerName!=''})"
    }

    source prometheus "p50" {
      query = "avg by (LoadBalancerName, tag_namespace, tag_service) (latency_histo{le='p50',LoadBalancerName!=''})"
    }

    source prometheus "p75" {
      query = "avg by (LoadBalancerName, tag_namespace, tag_service) (latency_histo{le='p75',LoadBalancerName!=''})"
    }

    source prometheus "p90" {
      query = "avg by (LoadBalancerName, tag_namespace, tag_service) (latency_histo{le='p90',LoadBalancerName!=''})"
    }

    source prometheus "p99" {
      query = "avg by (LoadBalancerName, tag_namespace, tag_service) (latency_histo{le='p99',LoadBalancerName!=''})"
    }

    source prometheus "p100" {
      query = "avg by (LoadBalancerName, tag_namespace, tag_service) (latency_histo{le='p100',LoadBalancerName!=''})"
    }
  }
}
