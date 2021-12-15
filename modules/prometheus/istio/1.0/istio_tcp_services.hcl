ingester prometheus_istio_tcp_workload module {
  frequency  = 120
  lookback   = 600
  timeout    = 90
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
    name = "$output{destination_workload}-$output{destination_version}"
  }

  using = {
    default = "$input{using}"
  }

  gauge "open_connections" {
    index       = 3
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "open_connections" {
      query = "label_set(sum by (cluster, destination_canonical_service,  destination_workload, destination_workload_namespace, destination_version, pod_name) (increase(istio_tcp_connections_opened_total{reporter='source', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster'}[1m])), 'cluster', '$input{cluster}')"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "closed_connections" {
    index       = 4
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "closed_connections" {
      query = "label_set(sum by (cluster, destination_canonical_service,  destination_workload, destination_workload_namespace, destination_version, pod_name) (increase(istio_tcp_connections_closed_total{reporter='source', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster'}[1m])), 'cluster', '$input{cluster}')"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "bytes_in" {
    index       = 1
    input_unit  = "Bps"
    output_unit = "Bps"
    aggregator  = "SUM"

    source prometheus "bytes_in" {
      query = "label_set(sum by (cluster, destination_canonical_service,  destination_workload, destination_workload_namespace, destination_version, pod_name) (increase(istio_tcp_received_bytes_total{reporter='source', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster'}[1m])), 'cluster', '$input{cluster}')"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "bytes_out" {
    index       = 2
    input_unit  = "Bps"
    output_unit = "Bps"
    aggregator  = "SUM"

    source prometheus "bytes_out" {
      query = "label_set(sum by (cluster, destination_canonical_service,  destination_workload, destination_workload_namespace,  destination_version, pod_name) (increase(istio_tcp_sent_bytes_total{reporter='source', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster'}[1m])), 'cluster', '$input{cluster}')"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }
}

ingester prometheus_istio_tcp_cluster module {
  frequency  = 120
  lookback   = 600
  timeout    = 90
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
    index       = 3
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "open_connections" {
      query = "label_set(sum by (cluster) (increase(istio_tcp_connections_opened_total{reporter='source', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster'}[1m])), 'cluster', '$input{cluster}')"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "closed_connections" {
    index       = 4
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "closed_connections" {
      query = "label_set(sum by (cluster) (increase(istio_tcp_connections_closed_total{reporter='source', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster'}[1m])), 'cluster', '$input{cluster}')"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "bytes_in" {
    index       = 1
    input_unit  = "Bps"
    output_unit = "Bps"
    aggregator  = "SUM"

    source prometheus "bytes_in" {
      query = "label_set(sum by (cluster) (increase(istio_tcp_received_bytes_total{reporter='source', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster'}[1m])), 'cluster', '$input{cluster}')"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "bytes_out" {
    index       = 2
    input_unit  = "Bps"
    output_unit = "Bps"
    aggregator  = "SUM"

    source prometheus "bytes_out" {
      query = "label_set(sum by (cluster, destination_canonical_service,  destination_workload, destination_workload_namespace,  destination_version, pod_name) (increase(istio_tcp_sent_bytes_total{reporter='source', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster'}[1m])), 'cluster', '$input{cluster}')"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }
}

ingester prometheus_istio_tcp_k8s_pod module {
  frequency  = 120
  lookback   = 600
  timeout    = 90
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
    index       = 3
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "open_connections" {
      query = "label_set(sum by (cluster, pod_name, destination_canonical_service, destination_workload_namespace) (increase(istio_tcp_connections_opened_total{reporter='source', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster'}[1m])), 'cluster', '$input{cluster}')"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "closed_connections" {
    index       = 4
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "closed_connections" {
      query = "label_set(sum by (cluster, destination_canonical_service, destination_workload_namespace, pod_name) (increase(istio_tcp_connections_closed_total{reporter='source', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster'}[1m])), 'cluster', '$input{cluster}')"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "bytes_in" {
    index       = 1
    input_unit  = "Bps"
    output_unit = "Bps"
    aggregator  = "SUM"

    source prometheus "bytes_in" {
      query = "label_set(sum by (cluster, destination_canonical_service, destination_workload_namespace, pod_name) (increase(istio_tcp_received_bytes_total{reporter='source', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster'}[1m])), 'cluster', '$input{cluster}')"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "bytes_out" {
    index       = 2
    input_unit  = "Bps"
    output_unit = "Bps"
    aggregator  = "SUM"

    source prometheus "bytes_out" {
      query = "label_set(sum by (cluster, destination_canonical_service, destination_workload_namespace, pod_name) (increase(istio_tcp_sent_bytes_total{reporter='source', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster'}[1m])), 'cluster', '$input{cluster}')"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }
}
