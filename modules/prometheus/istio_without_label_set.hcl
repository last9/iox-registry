ingester prometheus_istio_workload module {
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
    type = "k8s__pod"
    name = "$output{pod_name}"
  }

  physical_component {
    type = "k8s__cluster"
    name = "$input{cluster}"
  }

  data_for_graph_node {
    type = "istio_deployment"
    name = "$output{destination_workload}-$output{destination_version}"
  }

  using = {
    default = "victoriametrics"
  }

  gauge "throughput" {
    unit = "count"

    source prometheus "throughput" {
      //query = "sum by (cluster, destination_canonical_service,  destination_workload, destination_workload_namespace, destination_version, pod_name) (increase(istio_requests_total{reporter='source', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster'}[1m]))"
      query = "sum by (cluster, destination_canonical_service,  destination_workload, destination_workload_namespace, destination_version, pod_name) (increase(istio_requests_total{reporter='source', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster'}[1m]))"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "status_2xx" {
    unit = "count"

    source prometheus "status_2xx" {
      query = "sum by (cluster, destination_canonical_service,  destination_workload, destination_workload_namespace, destination_version, pod_name) (increase(istio_requests_total{reporter='source', source_canonical_service!='unknown', response_code=~'^2.*', destination_service_name!='PassthroughCluster'}[1m]))"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "status_3xx" {
    unit = "count"

    source prometheus "status_3xx" {
      query = "sum by (cluster, destination_canonical_service,  destination_workload, destination_workload_namespace, destination_version, pod_name) (increase(istio_requests_total{reporter='source', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster', response_code=~'^3.*'}[1m]))"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "status_4xx" {
    unit = "count"

    source prometheus "status_4xx" {
      query = "sum by (cluster, destination_canonical_service,  destination_workload, destination_workload_namespace, destination_version, pod_name) (increase(istio_requests_total{reporter='source', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster', response_code=~'^4.*'}[1m]))"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "status_5xx" {
    unit = "count"

    source prometheus "status_5xx" {
      query = "sum by (cluster, destination_canonical_service,  destination_workload, destination_workload_namespace, destination_version, pod_name) (increase(istio_requests_total{reporter='source', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster', response_code=~'^5.*'}[1m]))"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  //   latency_histo "latency" {
  //     unit = "milliseconds"

  //     source prometheus "latency" {
  //       query = "increase(istio_request_duration_milliseconds_bucket{reporter='source', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster'}[1m]) by (cluster, destination_version, destination_workload, destination_workload_namespace, pod_name)"
  //       join_on = {
  //         "$output{cluster}"                        = "$input{cluster}"
  //       }
  //     }
  //   }

  //   gauge "P90" {
  //     unit = "milliseconds"

  //     source prometheus "latency" {
  //       query = "(histogram_quantile(0.90, sum(increase(istio_request_duration_milliseconds_bucket{reporter='source', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster'}[1m])) by (le, cluster, destination_version, destination_workload, destination_workload_namespace, pod_name)))"

  //       join_on = {
  //         "$output{cluster}"                        = "$input{cluster}"
  //       }
  //     }
  //   }

  //   gauge "P99" {
  //     unit = "milliseconds"

  //     source prometheus "latency" {
  //       query = "(histogram_quantile(0.99, sum(increase(istio_request_duration_milliseconds_bucket{reporter='source', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster'}[1m])) by (le, cluster, destination_version, destination_workload, destination_workload_namespace, pod_name)))"

  //       join_on = {
  //         "$output{cluster}"                        = "$input{cluster}"
  //       }
  //     }
  //   }

  gauge "bytes_in" {
    unit = "bytes"

    source prometheus "bytes_in" {
      query = "sum by (cluster, destination_canonical_service,  destination_workload, destination_workload_namespace, destination_version, pod_name) (increase(istio_request_bytes_sum{reporter='source', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster'}[1m]))"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "bytes_out" {
    unit = "bytes"

    source prometheus "bytes_out" {
      query = "sum by (cluster, destination_canonical_service,  destination_workload, destination_workload_namespace,  destination_version, pod_name) (increase(istio_response_bytes_sum{reporter='source', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster'}[1m]))"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }
}

ingester prometheus_istio_cluster module {
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
    type = "k8s__cluster"
    name = "$input{cluster}"
  }

  data_for_graph_node {
    type = "k8s__cluster"
    name = "$input{cluster}"
  }

  using = {
    default = "victoriametrics"
  }

  gauge "throughput" {
    unit = "count"

    source prometheus "throughput" {
      query = "sum by (cluster) (increase(istio_requests_total{reporter='source'}[1m]))"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "status_2xx" {
    unit = "count"

    source prometheus "status_2xx" {
      query = "sum by (cluster) (increase(istio_requests_total{reporter='source', response_code=~'^2.*'}[1m]))"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "status_3xx" {
    unit = "count"

    source prometheus "status_3xx" {
      query = "sum by (cluster) (increase(istio_requests_total{reporter='source', response_code=~'^3.*'}[1m]))"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "status_4xx" {
    unit = "count"

    source prometheus "status_4xx" {
      query = "sum by (cluster) (increase(istio_requests_total{reporter='source', response_code=~'^4.*'}[1m]))"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "status_5xx" {
    unit = "count"

    source prometheus "status_5xx" {
      query = "sum by (cluster) (increase(istio_requests_total{reporter='source', response_code=~'^5.*'}[1m]))"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "bytes_in" {
    unit = "bytes"

    source prometheus "bytes_in" {
      query = "sum by (cluster) (increase(istio_request_bytes_sum{reporter='source'}[1m]))"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "bytes_out" {
    unit = "bytes"

    source prometheus "bytes_out" {
      query = "sum by (cluster) (increase(istio_response_bytes_sum{reporter='source'}[1m]))"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }
}

ingester prometheus_istio_k8s_pod module {
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
    type = "k8s__pod"
    name = "$output{pod_name}"
  }

  physical_component {
    type = "k8s__cluster"
    name = "$input{cluster}"
  }

  data_for_graph_node {
    type = "k8s__pod"
    name = "$output{pod_name}"
  }

  using = {
    default = "victoriametrics"
  }

  gauge "throughput" {
    unit = "count"

    source prometheus "throughput" {
      query = "sum by (cluster, pod_name, destination_canonical_service, destination_workload_namespace) (increase(istio_requests_total{reporter='source', destination_service_name!='PassthroughCluster', source_canonical_service!='unknown', destination_canonical_service=~'.+'}[1m]))"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "status_2xx" {
    unit = "count"

    source prometheus "status_2xx" {
      query = "sum by (cluster, pod_name, destination_canonical_service, destination_workload_namespace) (increase(istio_requests_total{reporter='source', destination_service_name!='PassthroughCluster', source_canonical_service!='unknown', response_code=~'^2.*', destination_canonical_service=~'.+'}[1m]))"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "status_3xx" {
    unit = "count"

    source prometheus "status_3xx" {
      query = "sum by (cluster, pod_name, destination_canonical_service, destination_workload_namespace) (increase(istio_requests_total{reporter='source', destination_service_name!='PassthroughCluster', source_canonical_service!='unknown', response_code=~'^3.*', destination_canonical_service=~'.+'}[1m]))"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "status_4xx" {
    unit = "count"

    source prometheus "status_4xx" {
      query = "sum by (cluster, pod_name, destination_canonical_service, destination_workload_namespace) (increase(istio_requests_total{reporter='source', destination_service_name!='PassthroughCluster', source_canonical_service!='unknown', response_code=~'^4.*', destination_canonical_service=~'.+'}[1m]))"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "status_5xx" {
    unit = "count"

    source prometheus "status_5xx" {
      query = "sum by (cluster, pod_name, destination_canonical_service, destination_workload_namespace) (increase(istio_requests_total{reporter='source', destination_service_name!='PassthroughCluster', source_canonical_service!='unknown', response_code=~'^5.*', destination_canonical_service=~'.+'}[1m]))"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "bytes_in" {
    unit = "bytes"

    source prometheus "bytes_in" {
      query = "sum by (cluster, pod_name, destination_canonical_service, destination_workload_namespace) (increase(istio_request_bytes_sum{reporter='source', destination_service_name!='PassthroughCluster', source_canonical_service!='unknown', destination_canonical_service=~'.+'}[1m]))"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "bytes_out" {
    unit = "bytes"

    source prometheus "bytes_out" {
      query = "sum by (cluster, pod_name, destination_canonical_service, destination_workload_namespace) (increase(istio_response_bytes_sum{reporter='source', destination_service_name!='PassthroughCluster', source_canonical_service!='unknown', destination_canonical_service=~'.+' }[1m]))"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }
}
