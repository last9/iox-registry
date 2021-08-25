ingester prometheus_istio_tcp_workload module {
  frequency  = 600
  lookback   = 300
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
    type = "k8s__pod"
    name = "$output{pod_name}"
  }

  physical_component {
    type = "k8s__cluster"
    name = "$input{cluster}"
  }

  data_for_graph_node {
    type = "istio_tcp_deployment"
    name = "$output{destination_workload}-$output{destination_version}"
  }

  using = {
    default = "victoriametrics"
  }

  gauge "open_connections" {
    unit = "count"

    source prometheus "bytes_in" {
      query = "label_set(sum by (cluster, destination_canonical_service,  destination_workload, destination_workload_namespace, destination_version, pod_name) (increase(istio_tcp_connections_opened_total{reporter='source', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster'}[1m])), 'cluster', '$input{cluster}')"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "closed_connections" {
    unit = "count"

    source prometheus "bytes_in" {
      query = "label_set(sum by (cluster, destination_canonical_service,  destination_workload, destination_workload_namespace, destination_version, pod_name) (increase(istio_tcp_connections_closed_total{reporter='source', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster'}[1m])), 'cluster', '$input{cluster}')"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "bytes_in" {
    unit = "bytes"

    source prometheus "bytes_in" {
      query = "label_set(sum by (cluster, destination_canonical_service,  destination_workload, destination_workload_namespace, destination_version, pod_name) (increase(istio_tcp_received_bytes_total{reporter='source', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster'}[1m])), 'cluster', '$input{cluster}')"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "bytes_out" {
    unit = "bytes"

    source prometheus "bytes_out" {
      query = "label_set(sum by (cluster, destination_canonical_service,  destination_workload, destination_workload_namespace,  destination_version, pod_name) (increase(istio_tcp_sent_bytes_total{reporter='source', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster'}[1m])), 'cluster', '$input{cluster}')"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }
}

