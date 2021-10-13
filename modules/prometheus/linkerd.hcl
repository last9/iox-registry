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
    name = "$output{workload_ns}"
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
    name = "$output{deployment}"
  }

  using = {
    default = "$input{using}"
  }

  gauge "throughput" {
    unit = "count"

    source prometheus "throughput" {
      query = "label_set(label_replace((sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_request_total{direction='inbound', dst=~'.*svc.cluster.local.*'})[1m])), 'service', '$1', 'dst', '([a-zA-Z-]*){1}.([a-zA-Z-.]*):.*'), 'cluster', '$input{cluster}')"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "status_2xx" {
    unit = "count"

    source prometheus "status_2xx" {
      query = "label_set(label_replace((sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_response_total{direction='inbound', dst=~'.*svc.cluster.local.*', status_code=~'^2.*'})[1m])), 'service', '$1', 'dst', '([a-zA-Z-]*){1}.([a-zA-Z-.]*):.*'), 'cluster', '$input{cluster}')"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "status_3xx" {
    unit = "count"

    source prometheus "status_3xx" {
      query = "label_set(label_replace((sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_response_total{direction='inbound', dst=~'.*svc.cluster.local.*', status_code=~'^3.*'})[1m])), 'service', '$1', 'dst', '([a-zA-Z-]*){1}.([a-zA-Z-.]*):.*'), 'cluster', '$input{cluster}')"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "status_4xx" {
    unit = "count"

    source prometheus "status_4xx" {
      query = "label_set(label_replace((sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_response_total{direction='inbound', dst=~'.*svc.cluster.local.*', status_code=~'^4.*'})[1m])), 'service', '$1', 'dst', '([a-zA-Z-]*){1}.([a-zA-Z-.]*):.*'), 'cluster', '$input{cluster}')"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "status_5xx" {
    unit = "count"

    source prometheus "status_5xx" {
      query = "label_set(label_replace((sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_response_total{direction='inbound', dst=~'.*svc.cluster.local.*', status_code=~'^5.*'})[1m])), 'service', '$1', 'dst', '([a-zA-Z-]*){1}.([a-zA-Z-.]*):.*'), 'cluster', '$input{cluster}')"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  //   gauge "latency" {
  //     unit = "milliseconds"
  //
  //     source prometheus "latency" {
  //       query = "label_set(label_replace((sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_response_latency_ms_bucket{direction='inbound', dst=~'.*svc.cluster.local.*'})[1m])), 'service', '$1', 'dst', '([a-zA-Z-]*){1}.([a-zA-Z-.]*):.*'), 'cluster', '$input{cluster}')"
  //       join_on = {
  //         "$output{cluster}" = "$input{cluster}"
  //       }
  //     }
  //   }
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
    name = "$output{workload_ns}"
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
    unit = "count"

    source prometheus "throughput" {
      query = "label_set(label_replace((sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_request_total{direction='inbound', dst=~'.*svc.cluster.local.*'})[1m])), 'service', '$1', 'dst', '([a-zA-Z-]*){1}.([a-zA-Z-.]*):.*'), 'cluster', '$input{cluster}')"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "status_2xx" {
    unit = "count"

    source prometheus "status_2xx" {
      query = "label_set(label_replace((sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_response_total{direction='inbound', dst=~'.*svc.cluster.local.*', status_code=~'^2.*'})[1m])), 'service', '$1', 'dst', '([a-zA-Z-]*){1}.([a-zA-Z-.]*):.*'), 'cluster', '$input{cluster}')"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "status_3xx" {
    unit = "count"

    source prometheus "status_3xx" {
      query = "label_set(label_replace((sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_response_total{direction='inbound', dst=~'.*svc.cluster.local.*', status_code=~'^3.*'})[1m])), 'service', '$1', 'dst', '([a-zA-Z-]*){1}.([a-zA-Z-.]*):.*'), 'cluster', '$input{cluster}')"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "status_4xx" {
    unit = "count"

    source prometheus "status_4xx" {
      query = "label_set(label_replace((sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_response_total{direction='inbound', dst=~'.*svc.cluster.local.*', status_code=~'^4.*'})[1m])), 'service', '$1', 'dst', '([a-zA-Z-]*){1}.([a-zA-Z-.]*):.*'), 'cluster', '$input{cluster}')"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "status_5xx" {
    unit = "count"

    source prometheus "status_5xx" {
      query = "label_set(label_replace((sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_response_total{direction='inbound', dst=~'.*svc.cluster.local.*', status_code=~'^5.*'})[1m])), 'service', '$1', 'dst', '([a-zA-Z-]*){1}.([a-zA-Z-.]*):.*'), 'cluster', '$input{cluster}')"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  //   gauge "latency" {
  //     unit = "milliseconds"
  //
  //     source prometheus "latency" {
  //       query = "label_set(label_replace((sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_response_latency_ms_bucket{direction='inbound', dst=~'.*svc.cluster.local.*'})[1m])), 'service', '$1', 'dst', '([a-zA-Z-]*){1}.([a-zA-Z-.]*):.*'), 'cluster', '$input{cluster}')"
  //       join_on = {
  //         "$output{cluster}" = "$input{cluster}"
  //       }
  //     }
  //   }
}
