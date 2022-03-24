ingester prometheus_linkerd_grpc_workload module {
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
    type = "grpc_k8s_linkerd_pod"
    name = "$output{pod}"
  }

  physical_component {
    type = "k8s_linkerd_cluster"
    name = "$input{cluster}"
  }

  data_for_graph_node {
    type = "grpc_linkerd_deployment"
    name = "$output{deployment}-$input{cluster}"
  }

  using = {
    default = "$input{using}"
  }

  gauge "throughput" {
    index       = 1
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "throughput" {
      query = "label_replace(sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_request_total{direction='inbound', dst=~'.*svc.cluster.local.*', rt_route!~'.*/.*|^$', cluster='$input{cluster}'}[1m])), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*')"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "status_success" {
    index       = 4
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "status_success" {
      query = "label_replace(sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_response_total{grpc_status='0', direction='inbound', dst=~'.*svc.cluster.local.*', rt_route!~'.*/.*|^$', cluster='$input{cluster}'}[1m])), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*')"
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
      query = "label_replace(sum by (cluster, workload_ns, deployment, dst, pod, le) (increase(route_response_latency_ms_bucket{direction='inbound', dst=~'.*svc.cluster.local.*', rt_route!~'.*/.*|^$', cluster='$input{cluster}'}[1m])), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  status_histo "status_4xx" {
    index       = 4
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "status_401" {
      query = "label_replace(label_replace(sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_response_total{grpc_status='1', direction='inbound', dst=~'.*svc.cluster.local.*', rt_route!~'.*/.*|^$', cluster='$input{cluster}'}[1m])), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*'), 'grpc_code', 'CANCELLED', '', '')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }

    source prometheus "status_402" {
      query = "label_replace(label_replace(sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_response_total{grpc_status='2', direction='inbound', dst=~'.*svc.cluster.local.*', rt_route!~'.*/.*|^$', cluster='$input{cluster}'}[1m])), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*'), 'grpc_code', 'UNKNOWN', '', '')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }

    source prometheus "status_403" {
      query = "label_replace(label_replace(sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_response_total{grpc_status='3', direction='inbound', dst=~'.*svc.cluster.local.*', rt_route!~'.*/.*|^$', cluster='$input{cluster}'}[1m])), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*'), 'grpc_code', 'INVALID_ARGUMENT', '', '')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }

    source prometheus "status_404" {
      query = "label_replace(label_replace(sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_response_total{grpc_status='4', direction='inbound', dst=~'.*svc.cluster.local.*', rt_route!~'.*/.*|^$', cluster='$input{cluster}'}[1m])), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*'), 'grpc_code', 'DEADLINE_EXCEEDED', '', '')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }

    source prometheus "status_405" {
      query = "label_replace(label_replace(sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_response_total{grpc_status='5', direction='inbound', dst=~'.*svc.cluster.local.*', rt_route!~'.*/.*|^$', cluster='$input{cluster}'}[1m])), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*'), 'grpc_code', 'NOT_FOUND', '', '')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }

    source prometheus "status_406" {
      query = "label_replace(label_replace(sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_response_total{grpc_status='6', direction='inbound', dst=~'.*svc.cluster.local.*', rt_route!~'.*/.*|^$', cluster='$input{cluster}'}[1m])), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*'), 'grpc_code', 'ALREADY_EXISTS', '', '')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }

    source prometheus "status_407" {
      query = "label_replace(label_replace(sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_response_total{grpc_status='7', direction='inbound', dst=~'.*svc.cluster.local.*', rt_route!~'.*/.*|^$', cluster='$input{cluster}'}[1m])), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*'), 'grpc_code', 'PERMISSION_DENIED', '', '')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }

    source prometheus "status_408" {
      query = "label_replace(label_replace(sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_response_total{grpc_status='8', direction='inbound', dst=~'.*svc.cluster.local.*', rt_route!~'.*/.*|^$', cluster='$input{cluster}'}[1m])), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*'), 'grpc_code', 'RESOURCE_EXHAUSTED', '', '')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }

    source prometheus "status_409" {
      query = "label_replace(label_replace(sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_response_total{grpc_status='9', direction='inbound', dst=~'.*svc.cluster.local.*', rt_route!~'.*/.*|^$', cluster='$input{cluster}'}[1m])), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*'), 'grpc_code', 'FAILED_PRECONDITION', '', '')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }

    source prometheus "status_410" {
      query = "label_replace(label_replace(sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_response_total{grpc_status='10', direction='inbound', dst=~'.*svc.cluster.local.*', rt_route!~'.*/.*|^$', cluster='$input{cluster}'}[1m])), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*'), 'grpc_code', 'ABORTED', '', '')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }

    source prometheus "status_411" {
      query = "label_replace(label_replace(sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_response_total{grpc_status='11', direction='inbound', dst=~'.*svc.cluster.local.*', rt_route!~'.*/.*|^$', cluster='$input{cluster}'}[1m])), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*'), 'grpc_code', 'OUT_OF_RANGE', '', '')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }

    source prometheus "status_412" {
      query = "label_replace(label_replace(sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_response_total{grpc_status='12', direction='inbound', dst=~'.*svc.cluster.local.*', rt_route!~'.*/.*|^$', cluster='$input{cluster}'}[1m])), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*'), 'grpc_code', 'UNIMPLEMENTED', '', '')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }

    source prometheus "status_413" {
      query = "label_replace(label_replace(sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_response_total{grpc_status='13', direction='inbound', dst=~'.*svc.cluster.local.*', rt_route!~'.*/.*|^$', cluster='$input{cluster}'}[1m])), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*'), 'grpc_code', 'INTERNAL', '', '')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }

    source prometheus "status_414" {
      query = "label_replace(label_replace(sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_response_total{grpc_status='14', direction='inbound', dst=~'.*svc.cluster.local.*', rt_route!~'.*/.*|^$', cluster='$input{cluster}'}[1m])), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*'), 'grpc_code', 'UNAVAILABLE', '', '')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }

    source prometheus "status_415" {
      query = "label_replace(label_replace(sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_response_total{grpc_status='15', direction='inbound', dst=~'.*svc.cluster.local.*', rt_route!~'.*/.*|^$', cluster='$input{cluster}'}[1m])), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*'), 'grpc_code', 'DATA_LOSS', '', '')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }

    source prometheus "status_416" {
      query = "label_replace(label_replace(sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_response_total{grpc_status='16', direction='inbound', dst=~'.*svc.cluster.local.*', rt_route!~'.*/.*|^$', cluster='$input{cluster}'}[1m])), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*'), 'grpc_code', 'UNAUTHENTICATED', '', '')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }
}

ingester prometheus_linkerd_grpc_k8s_pod module {
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
    type = "grpc_k8s_linkerd_pod"
    name = "$output{pod}"
  }

  physical_component {
    type = "k8s_linkerd_cluster"
    name = "$input{cluster}"
  }

  data_for_graph_node {
    type = "grpc_k8s_linkerd_pod"
    name = "$output{pod}"
  }

  using = {
    default = "$input{using}"
  }

  gauge "throughput" {
    index       = 1
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "throughput" {
      query = "label_replace(sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_request_total{direction='inbound', dst=~'.*svc.cluster.local.*', rt_route!~'.*/.*|^$', cluster='$input{cluster}'}[1m])), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*')"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "status_success" {
    index       = 4
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "status_success" {
      query = "label_replace(sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_response_total{grpc_status='0', direction='inbound', dst=~'.*svc.cluster.local.*', rt_route!~'.*/.*|^$', cluster='$input{cluster}'}[1m])), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*')"
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
      query = "label_replace(sum by (cluster, workload_ns, deployment, dst, pod, le) (increase(route_response_latency_ms_bucket{direction='inbound', dst=~'.*svc.cluster.local.*', rt_route!~'.*/.*|^$', cluster='$input{cluster}'}[1m])), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  status_histo "status_4xx" {
    index       = 4
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "status_401" {
      query = "label_replace(sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_response_total{grpc_status='1', direction='inbound', dst=~'.*svc.cluster.local.*', rt_route!~'.*/.*|^$', cluster='$input{cluster}'}[1m])), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }

    source prometheus "status_402" {
      query = "label_replace(sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_response_total{grpc_status='2', direction='inbound', dst=~'.*svc.cluster.local.*', rt_route!~'.*/.*|^$', cluster='$input{cluster}'}[1m])), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }

    source prometheus "status_403" {
      query = "label_replace(sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_response_total{grpc_status='3', direction='inbound', dst=~'.*svc.cluster.local.*', rt_route!~'.*/.*|^$', cluster='$input{cluster}'}[1m])), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }

    source prometheus "status_404" {
      query = "label_replace(sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_response_total{grpc_status='4', direction='inbound', dst=~'.*svc.cluster.local.*', rt_route!~'.*/.*|^$', cluster='$input{cluster}'}[1m])), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }

    source prometheus "status_405" {
      query = "label_replace(sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_response_total{grpc_status='5', direction='inbound', dst=~'.*svc.cluster.local.*', rt_route!~'.*/.*|^$', cluster='$input{cluster}'}[1m])), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }

    source prometheus "status_406" {
      query = "label_replace(sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_response_total{grpc_status='6', direction='inbound', dst=~'.*svc.cluster.local.*', rt_route!~'.*/.*|^$', cluster='$input{cluster}'}[1m])), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }

    source prometheus "status_407" {
      query = "label_replace(sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_response_total{grpc_status='7', direction='inbound', dst=~'.*svc.cluster.local.*', rt_route!~'.*/.*|^$', cluster='$input{cluster}'}[1m])), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }

    source prometheus "status_408" {
      query = "label_replace(sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_response_total{grpc_status='8', direction='inbound', dst=~'.*svc.cluster.local.*', rt_route!~'.*/.*|^$', cluster='$input{cluster}'}[1m])), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }

    source prometheus "status_409" {
      query = "label_replace(sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_response_total{grpc_status='9', direction='inbound', dst=~'.*svc.cluster.local.*', rt_route!~'.*/.*|^$', cluster='$input{cluster}'}[1m])), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }

    source prometheus "status_410" {
      query = "label_replace(sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_response_total{grpc_status='10', direction='inbound', dst=~'.*svc.cluster.local.*', rt_route!~'.*/.*|^$', cluster='$input{cluster}'}[1m])), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }

    source prometheus "status_411" {
      query = "label_replace(sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_response_total{grpc_status='11', direction='inbound', dst=~'.*svc.cluster.local.*', rt_route!~'.*/.*|^$', cluster='$input{cluster}'}[1m])), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }

    source prometheus "status_412" {
      query = "label_replace(sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_response_total{grpc_status='12', direction='inbound', dst=~'.*svc.cluster.local.*', rt_route!~'.*/.*|^$', cluster='$input{cluster}'}[1m])), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }

    source prometheus "status_413" {
      query = "label_replace(sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_response_total{grpc_status='13', direction='inbound', dst=~'.*svc.cluster.local.*', rt_route!~'.*/.*|^$', cluster='$input{cluster}'}[1m])), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }

    source prometheus "status_414" {
      query = "label_replace(sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_response_total{grpc_status='14', direction='inbound', dst=~'.*svc.cluster.local.*', rt_route!~'.*/.*|^$', cluster='$input{cluster}'}[1m])), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }

    source prometheus "status_415" {
      query = "label_replace(sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_response_total{grpc_status='15', direction='inbound', dst=~'.*svc.cluster.local.*', rt_route!~'.*/.*|^$', cluster='$input{cluster}'}[1m])), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }

    source prometheus "status_416" {
      query = "label_replace(sum by (cluster, workload_ns, deployment, dst, pod) (increase(route_response_total{grpc_status='16', direction='inbound', dst=~'.*svc.cluster.local.*', rt_route!~'.*/.*|^$', cluster='$input{cluster}'}[1m])), 'service', '$1', 'dst', '([a-zA-Z0-9-]*){1}.([a-zA-Z-.]*):.*')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

}
