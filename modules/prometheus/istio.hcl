ingester prometheus_istio_workload module {
  frequency = 60

  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  inputs = "$input{inputs}"

  label {
    type = "service"
    name = "$input{service}"
  }

  label {
    type = "namespace"
    name = "$input{destination_workload_namespace}"
  }

  physical_address {
    type = "k8s__pod"
    name = "$output{pod_name}-$input{destination_workload_namespace}"
  }

  physical_component {
    type = "k8s__cluster"
    name = "$input{cluster}"
  }

  data_for_graph_node {
    type = "istio_deployment"
    name = "$input{destination_workload}-$input{destination_version}"
  }

  using = {
    default = "victoriametrics"
  }

  gauge "throughput" {
    unit = "count"

    source prometheus "throughput" {
      query = "sum by (cluster, destination_workload, destination_workload_namespace, destination_version, pod_name) (rate(istio_requests_total{reporter='source'}[1m])*60)"

      join_on = {
        "$output{cluster}"                        = "$input{cluster}"
        "$output{destination_version}"            = "$input{destination_version}"
        "$output{destination_workload}"           = "$input{destination_workload}"
        "$output{destination_workload_namespace}" = "$input{destination_workload_namespace}"
      }
    }
  }

  gauge "status_2xx" {
    unit = "count"

    source prometheus "status_2xx" {
      query = "sum by (cluster, destination_workload, destination_workload_namespace, destination_version, pod_name) (rate(istio_requests_total{reporter='source', response_code=~'^2.*'}[1m])*60)"

      join_on = {
        "$output{cluster}"                        = "$input{cluster}"
        "$output{destination_version}"            = "$input{destination_version}"
        "$output{destination_workload}"           = "$input{destination_workload}"
        "$output{destination_workload_namespace}" = "$input{destination_workload_namespace}"
      }
    }
  }

  gauge "status_3xx" {
    unit = "count"

    source prometheus "status_3xx" {
      query = "sum by (cluster, destination_workload, destination_workload_namespace, destination_version, pod_name) (rate(istio_requests_total{reporter='source', response_code=~'^3.*'}[1m])*60)"

      join_on = {
        "$output{cluster}"                        = "$input{cluster}"
        "$output{destination_version}"            = "$input{destination_version}"
        "$output{destination_workload}"           = "$input{destination_workload}"
        "$output{destination_workload_namespace}" = "$input{destination_workload_namespace}"
      }
    }
  }

  gauge "status_4xx" {
    unit = "count"

    source prometheus "status_4xx" {
      query = "sum by (cluster, destination_workload, destination_workload_namespace, destination_version, pod_name) (rate(istio_requests_total{reporter='source', response_code=~'^4.*'}[1m])*60)"

      join_on = {
        "$output{cluster}"                        = "$input{cluster}"
        "$output{destination_version}"            = "$input{destination_version}"
        "$output{destination_workload}"           = "$input{destination_workload}"
        "$output{destination_workload_namespace}" = "$input{destination_workload_namespace}"
      }
    }
  }

  gauge "status_5xx" {
    unit = "count"

    source prometheus "status_5xx" {
      query = "sum by (cluster, destination_workload, destination_workload_namespace, destination_version, pod_name) (rate(istio_requests_total{reporter='source', response_code=~'^5.*'}[1m])*60)"

      join_on = {
        "$output{cluster}"                        = "$input{cluster}"
        "$output{destination_version}"            = "$input{destination_version}"
        "$output{destination_workload}"           = "$input{destination_workload}"
        "$output{destination_workload_namespace}" = "$input{destination_workload_namespace}"
      }
    }
  }

  gauge "P50" {
    unit = "milliseconds"

    source prometheus "latency" {
      query = "(histogram_quantile(0.50, sum(rate(istio_request_duration_milliseconds_bucket{reporter='source'}[1m])) by (le, cluster, destination_version, destination_workload, destination_workload_namespace, pod_name)))"

      join_on = {
        "$output{cluster}"                        = "$input{cluster}"
        "$output{destination_version}"            = "$input{destination_version}"
        "$output{destination_workload}"           = "$input{destination_workload}"
        "$output{destination_workload_namespace}" = "$input{destination_workload_namespace}"
      }
    }
  }

  gauge "P90" {
    unit = "milliseconds"

    source prometheus "latency" {
      query = "(histogram_quantile(0.90, sum(rate(istio_request_duration_milliseconds_bucket{reporter='source'}[1m])) by (le, cluster, destination_version, destination_workload, destination_workload_namespace, pod_name)))"

      join_on = {
        "$output{cluster}"                        = "$input{cluster}"
        "$output{destination_version}"            = "$input{destination_version}"
        "$output{destination_workload}"           = "$input{destination_workload}"
        "$output{destination_workload_namespace}" = "$input{destination_workload_namespace}"
      }
    }
  }

  gauge "P99" {
    unit = "milliseconds"

    source prometheus "latency" {
      query = "(histogram_quantile(0.99, sum(rate(istio_request_duration_milliseconds_bucket{reporter='source'}[1m])) by (le, cluster, destination_version, destination_workload, destination_workload_namespace, pod_name)))"

      join_on = {
        "$output{cluster}"                        = "$input{cluster}"
        "$output{destination_version}"            = "$input{destination_version}"
        "$output{destination_workload}"           = "$input{destination_workload}"
        "$output{destination_workload_namespace}" = "$input{destination_workload_namespace}"
      }
    }
  }

  gauge "bytes_in" {
    unit = "bytes"

    source prometheus "bytes_in" {
      query = "sum by (cluster, destination_workload, destination_workload_namespace, destination_version, pod_name) (rate(istio_request_bytes_sum{reporter='source'}[1m])*60)"

      join_on = {
        "$output{cluster}"                        = "$input{cluster}"
        "$output{destination_version}"            = "$input{destination_version}"
        "$output{destination_workload}"           = "$input{destination_workload}"
        "$output{destination_workload_namespace}" = "$input{destination_workload_namespace}"
      }
    }
  }

  gauge "bytes_out" {
    unit = "bytes"

    source prometheus "bytes_out" {
      query = "sum by (cluster, destination_workload, destination_workload_namespace,  destination_version, pod_name) (rate(istio_response_bytes_sum{reporter='source'}[1m])*60)"

      join_on = {
        "$output{cluster}"                        = "$input{cluster}"
        "$output{destination_version}"            = "$input{destination_version}"
        "$output{destination_workload}"           = "$input{destination_workload}"
        "$output{destination_workload_namespace}" = "$input{destination_workload_namespace}"
      }
    }
  }
}

ingester prometheus_istio_cluster module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  inputs = "$input{inputs}"

  label {
    type = "service"
    name = "$input{service}"
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
      query = "sum by (cluster) (rate(istio_requests_total{reporter='source'}[1m])*60)"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "status_2xx" {
    unit = "count"

    source prometheus "status_2xx" {
      query = "sum by (cluster) (rate(istio_requests_total{reporter='source', response_code=~'^2.*'}[1m])*60)"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "status_3xx" {
    unit = "count"

    source prometheus "status_3xx" {
      query = "sum by (cluster) (rate(istio_requests_total{reporter='source', response_code=~'^3.*'}[1m])*60)"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "status_4xx" {
    unit = "count"

    source prometheus "status_4xx" {
      query = "sum by (cluster) (rate(istio_requests_total{reporter='source', response_code=~'^4.*'}[1m])*60)"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "status_5xx" {
    unit = "count"

    source prometheus "status_5xx" {
      query = "sum by (cluster) (rate(istio_requests_total{reporter='source', response_code=~'^5.*'}[1m])*60)"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "bytes_in" {
    unit = "bytes"

    source prometheus "bytes_in" {
      query = "sum by (cluster) (rate(istio_request_bytes_sum{reporter='source'}[1m])*60)"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "bytes_out" {
    unit = "bytes"

    source prometheus "bytes_out" {
      query = "sum by (cluster) (rate(istio_response_bytes_sum{reporter='source'}[1m])*60)"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }
}

ingester prometheus_istio module {
  frequency  = 60
  lookback   = 3600
  timeout    = 30
  resolution = 60
  lag        = 60

  inputs = "$input{inputs}"

  label {
    type = "service"
    name = "$input{service}"
  }

  label {
    type = "namespace"
    name = "$input{destination_workload_namespace}"
  }

  physical_address {
    type = "k8s__pod"
    name = "$output{pod_name}-$input{destination_workload_namespace}"
  }

  physical_component {
    type = "k8s__cluster"
    name = "$input{cluster}"
  }

  data_for_graph_node {
    type = "k8s__pod"
    name = "$output{pod_name}-$input{destination_workload_namespace}"
  }

  using = {
    default = "victoriametrics"
  }

  gauge "throughput" {
    unit = "count"

    source prometheus "throughput" {
      query = "sum by (cluster, pod_name, destination_workload_namespace) (rate(istio_requests_total{reporter='source'}[1m])*60)"

      join_on = {
        "$output{cluster}"                        = "$input{cluster}"
        "$output{destination_workload_namespace}" = "$input{destination_workload_namespace}"
      }
    }
  }

  gauge "status_2xx" {
    unit = "count"

    source prometheus "status_2xx" {
      query = "sum by (cluster, pod_name, destination_workload_namespace) (rate(istio_requests_total{reporter='source', response_code=~'^2.*'}[1m])*60)"

      join_on = {
        "$output{cluster}"                        = "$input{cluster}"
        "$output{destination_workload_namespace}" = "$input{destination_workload_namespace}"
      }
    }
  }

  gauge "status_3xx" {
    unit = "count"

    source prometheus "status_3xx" {
      query = "sum by (cluster, pod_name, destination_workload_namespace) (rate(istio_requests_total{reporter='source', response_code=~'^3.*'}[1m])*60)"

      join_on = {
        "$output{cluster}"                        = "$input{cluster}"
        "$output{destination_workload_namespace}" = "$input{destination_workload_namespace}"
      }
    }
  }

  gauge "status_4xx" {
    unit = "count"

    source prometheus "status_4xx" {
      query = "sum by (cluster, pod_name, destination_workload_namespace) (rate(istio_requests_total{reporter='source', response_code=~'^4.*'}[1m])*60)"

      join_on = {
        "$output{cluster}"                        = "$input{cluster}"
        "$output{destination_workload_namespace}" = "$input{destination_workload_namespace}"
      }
    }
  }

  gauge "status_5xx" {
    unit = "count"

    source prometheus "status_5xx" {
      query = "sum by (cluster, pod_name, destination_workload_namespace) (rate(istio_requests_total{reporter='source', response_code=~'^5.*'}[1m])*60)"

      join_on = {
        "$output{cluster}"                        = "$input{cluster}"
        "$output{destination_workload_namespace}" = "$input{destination_workload_namespace}"
      }
    }
  }

  gauge "bytes_in" {
    unit = "bytes"

    source prometheus "bytes_in" {
      query = "sum by (cluster, pod_name, destination_version) (rate(istio_request_bytes_sum{reporter='source'}[1m])*60)"

      join_on = {
        "$output{cluster}"                        = "$input{cluster}"
        "$output{destination_workload_namespace}" = "$input{destination_workload_namespace}"
      }
    }
  }

  gauge "bytes_out" {
    unit = "bytes"

    source prometheus "bytes_out" {
      query = "sum by (cluster, pod_name, destination_version) (rate(istio_response_bytes_sum{reporter='source'}[1m])*60)"

      join_on = {
        "$output{cluster}"                        = "$input{cluster}"
        "$output{destination_workload_namespace}" = "$input{destination_workload_namespace}"
      }
    }
  }
}
