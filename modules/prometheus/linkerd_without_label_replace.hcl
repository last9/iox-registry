ingester prometheus_linkerd_workload module {
  frequency  = 120
  lookback   = 600
  timeout    = 90
  resolution = 60
  lag        = 60

  inputs = "$input{inputs}"

  label {
    type = "service"
    name = "$output{service}"
  }

  label {
    type = "namespace"
    name = "$input{cluster}.$output{workload_ns}"
  }

  physical_address {
    type = "k8s_linkerd_pod"
    name = "$output{pod}"
  }

  physical_component {
    type = "k8s_linkerd_cluster"
    name = "$input{cluster}"
  }

  data_for_graph_node {
    type = "linkerd_deployment"
    name = "$input{cluster}-$output{deployment}"
  }

  using = {
    default = "$input{using}"
  }

  gauge "throughput" {
    index       = 4
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"

    source prometheus "throughput" {
      query = "label_replace((sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_request_total{direction='inbound', dst=~'.*svc.cluster.local.*'}[1m]))), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*')"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  status_histo "status_2xx" {
    index       = 2
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"

    source prometheus "status_2xx" {
      histo_column = "status_code"
      query        = "label_replace((sum by (cluster, workload_ns, deployment, dst, pod, status_code) (increase(route_response_total{direction='inbound', dst=~'.*svc.cluster.local.*', status_code=~'^2.*'}[1m]))), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*')"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  status_histo "status_3xx" {
    index       = 3
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"

    source prometheus "status_3xx" {
      histo_column = "status_code"
      query        = "label_replace((sum by (cluster, workload_ns, deployment, dst, pod, status_code) (increase(route_response_total{direction='inbound', dst=~'.*svc.cluster.local.*', status_code=~'^3.*'}[1m]))), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*')"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  status_histo "status_4xx" {
    index       = 4
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"

    source prometheus "status_4xx" {
      histo_column = "status_code"
      query        = "label_replace((sum by (cluster, workload_ns, deployment, dst, pod, status_code) (increase(route_response_total{direction='inbound', dst=~'.*svc.cluster.local.*', status_code=~'^4.*'}[1m]))), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*')"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  status_histo "status_5xx" {
    index       = 5
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"

    source prometheus "status_5xx" {
      histo_column = "status_code"
      query        = "label_replace((sum by (cluster, workload_ns, deployment, dst, pod, status_code) (increase(route_response_total{direction='inbound', dst=~'.*svc.cluster.local.*', status_code=~'^5.*'}[1m]))), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*')"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  latency_histo "latency_histo" {
    index       = 6
    input_unit  = "ms"
    output_unit = "ms"
    aggregator  = "PERCENTILE"

    source prometheus "latency" {
      query = "label_replace(sum by (cluster, workload_ns, deployment, dst, pod, le) (increase(route_response_latency_ms_bucket{direction='inbound', dst=~'.*svc.cluster.local.*'}[1m])), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*')"


      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }
}

ingester prometheus_linkerd_k8s_pod module {
  frequency  = 120
  lookback   = 600
  timeout    = 90
  resolution = 60
  lag        = 60

  inputs = "$input{inputs}"

  label {
    type = "service"
    name = "$output{service}"
  }

  label {
    type = "namespace"
    name = "$input{cluster}.$output{workload_ns}"
  }

  physical_address {
    type = "k8s_linkerd_pod"
    name = "$output{pod}"
  }

  physical_component {
    type = "k8s_linkerd_cluster"
    name = "$input{cluster}"
  }

  data_for_graph_node {
    type = "k8s_linkerd_pod"
    name = "$output{pod}"
  }

  using = {
    default = "$input{using}"
  }

  gauge "throughput" {
    index       = 4
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"

    source prometheus "throughput" {
      query = "label_replace((sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_request_total{direction='inbound', dst=~'.*svc.cluster.local.*'}[1m]))), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*')"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  status_histo "status_2xx" {
    index       = 2
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"

    source prometheus "status_2xx" {
      histo_column = "status_code"
      query        = "label_replace((sum by (cluster, workload_ns, deployment, dst, pod, status_code) (increase(route_response_total{direction='inbound', dst=~'.*svc.cluster.local.*', status_code=~'^2.*'}[1m]))), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*')"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  status_histo "status_3xx" {
    index       = 3
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"

    source prometheus "status_3xx" {
      histo_column = "status_code"
      query        = "label_replace((sum by (cluster, workload_ns, deployment, dst, pod, status_code) (increase(route_response_total{direction='inbound', dst=~'.*svc.cluster.local.*', status_code=~'^3.*'}[1m]))), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*')"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  status_histo "status_4xx" {
    index       = 4
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"

    source prometheus "status_4xx" {
      histo_column = "status_code"
      query        = "label_replace((sum by (cluster, workload_ns, deployment, dst, pod, status_code) (increase(route_response_total{direction='inbound', dst=~'.*svc.cluster.local.*', status_code=~'^4.*'}[1m]))), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*')"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  status_histo "status_5xx" {
    index       = 5
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"

    source prometheus "status_5xx" {
      histo_column = "status_code"
      query        = "label_replace((sum by (cluster, workload_ns, deployment, dst, pod, status_code) (increase(route_response_total{direction='inbound', dst=~'.*svc.cluster.local.*', status_code=~'^5.*'}[1m]))), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*')"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  latency_histo "latency_histo" {
    index       = 6
    input_unit  = "ms"
    output_unit = "ms"
    aggregator  = "PERCENTILE"

    source prometheus "latency" {
      query = "label_replace(sum by (cluster, workload_ns, deployment, dst, pod, le) (increase(route_response_latency_ms_bucket{direction='inbound', dst=~'.*svc.cluster.local.*'}[1m])), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*')"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }
}
