ingester prometheus_istio_tcp_workload module {
  frequency  = 600
  lookback   = 600
  timeout    = 180
  resolution = 60
  lag        = 60


  inputs = "$input{inputs}"

  label {
    type = "service"
    name = "$output{destination_canonical_service}"
  }

  label {
    type = "namespace"
    name = "$output{destination_workload_namespace}"
  }

  physical_address {
    type = "k8s_tcp_pod"
    name = "$output{pod_name}"
  }

  physical_component {
    type = "k8s_tcp_cluster"
    name = "$input{cluster}"
  }

  data_for_graph_node {
    type = "istio_tcp_deployment"
    // name = "$output{destination_workload}-$output{destination_version}"
    // name = "$output{destination_workload}-${coalesce($output{destination_version}, \"unknown\")}"
    name = "$output{destination_workload}-unknown"
    // name = <<EOT
    // format("$output{destination_workload}-%s", coalesce($output{destination_version}, "unknown"))
    // EOT
  }

  using = {
    default = "$input{using}"
  }

  gauge "open_connections" {
    unit = "count"

    source prometheus "open_connections" {
      query = "sum by (cluster, destination_canonical_service, destination_workload, destination_workload_namespace, destination_version, pod_name) (increase(istio_tcp_connections_opened_total{reporter='source', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster', destination_canonical_service=~'.+'}[1m]))"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "closed_connections" {
    unit = "count"

    source prometheus "closed_connections" {
      query = "sum by (cluster, destination_canonical_service,  destination_workload, destination_workload_namespace, destination_version, pod_name) (increase(istio_tcp_connections_closed_total{reporter='source', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster', destination_canonical_service=~'.+'}[1m]))"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "bytes_in" {
    unit = "bytes"

    source prometheus "bytes_in" {
      query = "sum by (cluster, destination_canonical_service,  destination_workload, destination_workload_namespace, destination_version, pod_name) (increase(istio_tcp_received_bytes_total{reporter='source', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster', destination_canonical_service=~'.+'}[1m]))"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "bytes_out" {
    unit = "bytes"

    source prometheus "bytes_out" {
      query = "sum by (cluster, destination_canonical_service,  destination_workload, destination_workload_namespace,  destination_version, pod_name) (increase(istio_tcp_sent_bytes_total{reporter='source', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster', destination_canonical_service=~'.+'}[1m]))"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }
}


ingester prometheus_istio_tcp_cluster module {
  frequency  = 600
  lookback   = 600
  timeout    = 180
  resolution = 60
  lag        = 60


  inputs = "$input{inputs}"

  label {
    type = "service"
    name = "$input{destination_canonical_service}"
  }

  label {
    type = "namespace"
    name = "$input{destination_workload_namespace}"
  }

  physical_component {
    type = "k8s_tcp_cluster"
    name = "$input{cluster}"
  }

  data_for_graph_node {
    type = "k8s_tcp_cluster"
    name = "$input{cluster}"
  }

  using = {
    default = "$input{using}"
  }

  gauge "open_connections" {
    unit = "count"

    source prometheus "open_connections" {
      query = "sum by (cluster) (increase(istio_tcp_connections_opened_total{reporter='source', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster'}[1m]))"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "closed_connections" {
    unit = "count"

    source prometheus "closed_connections" {
      query = "sum by (cluster) (increase(istio_tcp_connections_closed_total{reporter='source', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster'}[1m]))"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "bytes_in" {
    unit = "bytes"

    source prometheus "bytes_in" {
      query = "sum by (cluster) (increase(istio_tcp_received_bytes_total{reporter='source', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster'}[1m]))"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "bytes_out" {
    unit = "bytes"

    source prometheus "bytes_out" {
      query = "sum by (cluster, destination_canonical_service,  destination_workload, destination_workload_namespace,  destination_version, pod_name) (increase(istio_tcp_sent_bytes_total{reporter='source', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster'}[1m]))"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }
}

ingester prometheus_istio_tcp_k8s_pod module {
  frequency  = 600
  lookback   = 600
  timeout    = 180
  resolution = 60
  lag        = 60

  inputs = "$input{inputs}"

  label {
    type = "service"
    name = "$output{destination_canonical_service}"
  }

  label {
    type = "namespace"
    name = "$output{destination_workload_namespace}"
  }

  physical_address {
    type = "k8s_tcp_pod"
    name = "$output{pod_name}"
  }

  physical_component {
    type = "k8s_tcp_cluster"
    name = "$input{cluster}"
  }

  data_for_graph_node {
    type = "k8s_tcp_pod"
    name = "$output{pod_name}"
  }

  using = {
    default = "$input{using}"
  }

  gauge "open_connections" {
    unit = "count"

    source prometheus "open_connections" {
      query = "sum by (cluster, pod_name, destination_canonical_service, destination_workload_namespace) (increase(istio_tcp_connections_opened_total{reporter='source', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster', destination_canonical_service=~'.+'}[1m]))"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "closed_connections" {
    unit = "count"

    source prometheus "closed_connections" {
      query = "sum by (cluster, destination_canonical_service, destination_workload_namespace, pod_name) (increase(istio_tcp_connections_closed_total{reporter='source', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster', destination_canonical_service=~'.+'}[1m]))"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "bytes_in" {
    unit = "bytes"

    source prometheus "bytes_in" {
      query = "sum by (cluster, destination_canonical_service, destination_workload_namespace, pod_name) (increase(istio_tcp_received_bytes_total{reporter='source', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster', destination_canonical_service=~'.+'}[1m]))"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "bytes_out" {
    unit = "bytes"

    source prometheus "bytes_out" {
      query = "sum by (cluster, destination_canonical_service, destination_workload_namespace, pod_name) (increase(istio_tcp_sent_bytes_total{reporter='source', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster', destination_canonical_service=~'.+'}[1m]))"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }
}
