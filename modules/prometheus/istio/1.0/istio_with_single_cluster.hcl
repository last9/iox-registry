ingester prometheus_istio_workload module {
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
    default = "$input{using}"
  }

  gauge "throughput" {
    index       = 3
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"

    source prometheus "throughput" {
      // query = "label_set(sum by (cluster, destination_canonical_service,  destination_workload, destination_workload_namespace, destination_version, pod_name) (increase(istio_requests_total{reporter='destination', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster', pod_name=~'.+'}[1m])), 'cluster', '$input{cluster}')"
      query = "label_replace(sum by (cluster, destination_canonical_service,  destination_workload, destination_workload_namespace, destination_version, pod_name) (increase(istio_requests_total{reporter='destination', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster', pod_name=~'.+'}[1m])), 'cluster', '$input{cluster}', '', '')"

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
      histo_column = "response_code"
      // query        = "label_set(sum by (cluster, destination_canonical_service,  destination_workload, destination_workload_namespace, destination_version, pod_name, response_code) (increase(istio_requests_total{reporter='destination', source_canonical_service!='unknown', response_code=~'^2.*', destination_service_name!='PassthroughCluster', pod_name=~'.+'}[1m])), 'cluster', '$input{cluster}')"
      query = "label_replace(sum by (cluster, destination_canonical_service,  destination_workload, destination_workload_namespace, destination_version, pod_name, response_code) (increase(istio_requests_total{reporter='destination', source_canonical_service!='unknown', response_code=~'^2.*', destination_service_name!='PassthroughCluster', pod_name=~'.+'}[1m])), 'cluster', '$input{cluster}', '', '')"

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
      histo_column = "response_code"
      // query        = "label_set(sum by (cluster, destination_canonical_service,  destination_workload, destination_workload_namespace, destination_version, pod_name, response_code) (increase(istio_requests_total{reporter='destination', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster', response_code=~'^3.*', pod_name=~'.+'}[1m])), 'cluster', '$input{cluster}')"
      query = "label_replace(sum by (cluster, destination_canonical_service,  destination_workload, destination_workload_namespace, destination_version, pod_name, response_code) (increase(istio_requests_total{reporter='destination', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster', response_code=~'^3.*', pod_name=~'.+'}[1m])), 'cluster', '$input{cluster}', '', '')"

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
      histo_column = "response_code"
      // query        = "label_set(sum by (cluster, destination_canonical_service,  destination_workload, destination_workload_namespace, destination_version, pod_name, response_code) (increase(istio_requests_total{reporter='destination', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster', response_code=~'^4.*', pod_name=~'.+'}[1m])), 'cluster', '$input{cluster}')"
      query = "label_replace(sum by (cluster, destination_canonical_service,  destination_workload, destination_workload_namespace, destination_version, pod_name, response_code) (increase(istio_requests_total{reporter='destination', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster', response_code=~'^4.*', pod_name=~'.+'}[1m])), 'cluster', '$input{cluster}', '', '')"

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
      histo_column = "response_code"
      // query        = "label_set(sum by (cluster, destination_canonical_service,  destination_workload, destination_workload_namespace, destination_version, pod_name, response_code) (increase(istio_requests_total{reporter='destination', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster', response_code=~'^5.*', pod_name=~'.+'}[1m])), 'cluster', '$input{cluster}')"
      query = "label_replace(sum by (cluster, destination_canonical_service,  destination_workload, destination_workload_namespace, destination_version, pod_name, response_code) (increase(istio_requests_total{reporter='destination', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster', response_code=~'^5.*', pod_name=~'.+'}[1m])), 'cluster', '$input{cluster}', '', '')"

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
      // query = "label_set(sum by (cluster, destination_canonical_service,  destination_workload, destination_workload_namespace, destination_version, pod_name) (increase(istio_request_bytes_sum{reporter='destination', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster', pod_name=~'.+'}[1m])), 'cluster', '$input{cluster}')"
      query = "label_replace(sum by (cluster, destination_canonical_service,  destination_workload, destination_workload_namespace, destination_version, pod_name) (increase(istio_request_bytes_sum{reporter='destination', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster', pod_name=~'.+'}[1m])), 'cluster', '$input{cluster}', '', '')"

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
      // query = "label_set(sum by (cluster, destination_canonical_service,  destination_workload, destination_workload_namespace,  destination_version, pod_name) (increase(istio_response_bytes_sum{reporter='destination', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster', pod_name=~'.+'}[1m])), 'cluster', '$input{cluster}')"
      query = "label_replace(sum by (cluster, destination_canonical_service,  destination_workload, destination_workload_namespace,  destination_version, pod_name) (increase(istio_response_bytes_sum{reporter='destination', source_canonical_service!='unknown', destination_service_name!='PassthroughCluster', pod_name=~'.+'}[1m])), 'cluster', '$input{cluster}', '', '')"

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
      query = <<EOT
      label_replace(sum by (cluster, destination_canonical_service, destination_workload, destination_workload_namespace, destination_version, pod_name, le)
      (increase(istio_request_duration_milliseconds_bucket{ reporter='destination', destination_canonical_service=~'.+',
      source_canonical_service!='unknown', destination_service_name!='PassthroughCluster', pod_name=~'.+'}[1m])), 'cluster', '$input{cluster}', '', '')
      EOT

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }
}

ingester prometheus_istio_cluster module {
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
    type = "k8s__cluster"
    name = "$input{cluster}"
  }

  data_for_graph_node {
    type = "k8s__cluster"
    name = "$input{cluster}"
  }

  using = {
    default = "$input{using}"
  }

  gauge "throughput" {
    index       = 3
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"

    source prometheus "throughput" {
      // query = "label_set(sum by (cluster) (increase(istio_requests_total{reporter='destination'}[1m])), 'cluster', '$input{cluster}')"
      query = "label_replace(sum by (cluster) (increase(istio_requests_total{reporter='destination'}[1m])), 'cluster', '$input{cluster}', '', '')"

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
      histo_column = "response_code"
      // query        = "label_set(sum by (cluster, response_code) (increase(istio_requests_total{reporter='destination', response_code=~'^2.*'}[1m])), 'cluster', '$input{cluster}')"
      query = "label_replace(sum by (cluster, response_code) (increase(istio_requests_total{reporter='destination', response_code=~'^2.*'}[1m])), 'cluster', '$input{cluster}', '', '')"

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
      histo_column = "response_code"
      // query        = "label_set(sum by (cluster, response_code) (increase(istio_requests_total{reporter='destination', response_code=~'^3.*'}[1m])), 'cluster', '$input{cluster}')"
      query = "label_replace(sum by (cluster, response_code) (increase(istio_requests_total{reporter='destination', response_code=~'^3.*'}[1m])), 'cluster', '$input{cluster}', '', '')"

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
      histo_column = "response_code"
      // query        = "label_set(sum by (cluster, response_code) (increase(istio_requests_total{reporter='destination', response_code=~'^4.*'}[1m])), 'cluster', '$input{cluster}')"
      query = "label_replace(sum by (cluster, response_code) (increase(istio_requests_total{reporter='destination', response_code=~'^4.*'}[1m])), 'cluster', '$input{cluster}', '', '')"

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
      histo_column = "response_code"
      // query        = "label_set(sum by (cluster, response_code) (increase(istio_requests_total{reporter='destination', response_code=~'^5.*'}[1m])), 'cluster', '$input{cluster}')"
      query = "label_replace(sum by (cluster, response_code) (increase(istio_requests_total{reporter='destination', response_code=~'^5.*'}[1m])), 'cluster', '$input{cluster}', '', '')"

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
      // query = "label_set(sum by (cluster) (increase(istio_request_bytes_sum{reporter='destination'}[1m])), 'cluster', '$input{cluster}')"
      query = "label_replace(sum by (cluster) (increase(istio_request_bytes_sum{reporter='destination'}[1m])), 'cluster', '$input{cluster}', '', '')"

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
      // query = "label_set(sum by (cluster) (increase(istio_response_bytes_sum{reporter='destination'}[1m])), 'cluster', '$input{cluster}')"
      query = "label_replace(sum by (cluster) (increase(istio_response_bytes_sum{reporter='destination'}[1m])), 'cluster', '$input{cluster}', '', '')"

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
      query = <<EOT
      label_replace(sum by (cluster, le)
      (increase(istio_request_duration_milliseconds_bucket{ reporter='destination', destination_canonical_service=~'.+',
      source_canonical_service!='unknown', destination_service_name!='PassthroughCluster'}[1m])), 'cluster', '$input{cluster}', '', '')
      EOT

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }
}

ingester prometheus_istio_k8s_pod module {
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
    default = "$input{using}"
  }

  gauge "throughput" {
    index       = 3
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"

    source prometheus "throughput" {
      // query = "label_set(sum by (cluster, pod_name, destination_canonical_service, destination_workload_namespace) (increase(istio_requests_total{reporter='destination', destination_service_name!='PassthroughCluster', source_canonical_service!='unknown', pod_name=~'.+'}[1m])), 'cluster', '$input{cluster}')"
      query = "label_replace(sum by (cluster, pod_name, destination_canonical_service, destination_workload_namespace) (increase(istio_requests_total{reporter='destination', destination_service_name!='PassthroughCluster', source_canonical_service!='unknown', pod_name=~'.+'}[1m])), 'cluster', '$input{cluster}', '', '')"

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
      histo_column = "response_code"
      // query        = "label_set(sum by (cluster, pod_name, destination_canonical_service, destination_workload_namespace, response_code) (increase(istio_requests_total{reporter='destination', destination_service_name!='PassthroughCluster', source_canonical_service!='unknown', response_code=~'^2.*', pod_name=~'.+'}[1m])), 'cluster', '$input{cluster}')"
      query = "label_replace(sum by (cluster, pod_name, destination_canonical_service, destination_workload_namespace, response_code) (increase(istio_requests_total{reporter='destination', destination_service_name!='PassthroughCluster', source_canonical_service!='unknown', response_code=~'^2.*', pod_name=~'.+'}[1m])), 'cluster', '$input{cluster}', '', '')"

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
      histo_column = "response_code"
      // query        = "label_set(sum by (cluster, pod_name, destination_canonical_service, destination_workload_namespace, response_code) (increase(istio_requests_total{reporter='destination', destination_service_name!='PassthroughCluster', source_canonical_service!='unknown', response_code=~'^3.*', pod_name=~'.+'}[1m])), 'cluster', '$input{cluster}')"
      query = "label_replace(sum by (cluster, pod_name, destination_canonical_service, destination_workload_namespace, response_code) (increase(istio_requests_total{reporter='destination', destination_service_name!='PassthroughCluster', source_canonical_service!='unknown', response_code=~'^3.*', pod_name=~'.+'}[1m])), 'cluster', '$input{cluster}', '', '')"

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
      histo_column = "response_code"
      // query        = "label_set(sum by (cluster, pod_name, destination_canonical_service, destination_workload_namespace, response_code) (increase(istio_requests_total{reporter='destination', destination_service_name!='PassthroughCluster', source_canonical_service!='unknown', response_code=~'^4.*', pod_name=~'.+'}[1m])), 'cluster', '$input{cluster}')"
      query = "label_replace(sum by (cluster, pod_name, destination_canonical_service, destination_workload_namespace, response_code) (increase(istio_requests_total{reporter='destination', destination_service_name!='PassthroughCluster', source_canonical_service!='unknown', response_code=~'^4.*', pod_name=~'.+'}[1m])), 'cluster', '$input{cluster}', '', '')"

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
      histo_column = "response_code"
      // query        = "label_set(sum by (cluster, pod_name, destination_canonical_service, destination_workload_namespace, response_code) (increase(istio_requests_total{reporter='destination', destination_service_name!='PassthroughCluster', source_canonical_service!='unknown', response_code=~'^5.*', pod_name=~'.+'}[1m])), 'cluster', '$input{cluster}')"
      query = "label_replace(sum by (cluster, pod_name, destination_canonical_service, destination_workload_namespace, response_code) (increase(istio_requests_total{reporter='destination', destination_service_name!='PassthroughCluster', source_canonical_service!='unknown', response_code=~'^5.*', pod_name=~'.+'}[1m])), 'cluster', '$input{cluster}', '', '')"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "bytes_in" {
    index       = 1
    input_unit  = "Bpw"
    output_unit = "Bps"
    aggregator  = "SUM"

    source prometheus "bytes_in" {
      // query = "label_set(sum by (cluster, pod_name, destination_canonical_service, destination_workload_namespace) (increase(istio_request_bytes_sum{reporter='destination', destination_service_name!='PassthroughCluster', source_canonical_service!='unknown', pod_name=~'.+'}[1m])), 'cluster', '$input{cluster}')"
      query = "label_replace(sum by (cluster, pod_name, destination_canonical_service, destination_workload_namespace) (increase(istio_request_bytes_sum{reporter='destination', destination_service_name!='PassthroughCluster', source_canonical_service!='unknown', pod_name=~'.+'}[1m])), 'cluster', '$input{cluster}', '', '')"

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
      // query = "label_set(sum by (cluster, pod_name, destination_canonical_service, destination_workload_namespace) (increase(istio_response_bytes_sum{reporter='destination', destination_service_name!='PassthroughCluster', source_canonical_service!='unknown', pod_name=~'.+'}[1m])), 'cluster', '$input{cluster}')"
      query = "label_replace(sum by (cluster, pod_name, destination_canonical_service, destination_workload_namespace) (increase(istio_response_bytes_sum{reporter='destination', destination_service_name!='PassthroughCluster', source_canonical_service!='unknown', pod_name=~'.+'}[1m])), 'cluster', '$input{cluster}', '', '')"

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
      query = <<EOT
      label_replace(sum by (cluster, destination_canonical_service, destination_workload_namespace, pod_name, le)
      (increase(istio_request_duration_milliseconds_bucket{ reporter='destination', destination_canonical_service=~'.+',
      source_canonical_service!='unknown', destination_service_name!='PassthroughCluster', pod_name=~'.+'}[1m])), 'cluster', '$input{cluster}', '', '')
      EOT

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }
}
