ingester prometheus_linkerd_path module {
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


  physical_component {
    type = "linkerd_cluster"
    name = "$input{cluster}"
  }

  data_for_graph_node {
    type = "linkerd_endpoint"
    name = "$output{rt_route}"
  }

  using = {
    default = "$input{using}"
  }

  gauge "throughput" {
    unit = "count"

    source prometheus "throughput" {
      query = "label_set(label_replace((sum by (cluster, workload_ns, dst, rt_route) (increase(route_request_total{direction='outbound', dst=~'.*svc.cluster.local.*', rt_route=~'.*'})[1m])), 'service', '$1', 'dst', '([a-zA-Z-]*){1}.([a-zA-Z-.]*):.*'), 'cluster', '$input{cluster}')"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  status_histo "status_2xx" {
    unit = "count"

    source prometheus "status_2xx" {
      histo_column = "status_code"
      query = "label_set(label_replace((sum by (cluster, workload_ns, dst, rt_route, status_code) (increase(route_response_total{direction='outbound', dst=~'.*svc.cluster.local.*', status_code=~'^2.*', rt_route=~'.*'})[1m])), 'service', '$1', 'dst', '([a-zA-Z-]*){1}.([a-zA-Z-.]*):.*'), 'cluster', '$input{cluster}')"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  status_histo "status_3xx" {
    unit = "count"

    source prometheus "status_3xx" {
      histo_column = "status_code"
      query = "label_set(label_replace((sum by (cluster, workload_ns, dst, rt_route, status_code) (increase(route_response_total{direction='outbound', dst=~'.*svc.cluster.local.*', status_code=~'^3.*', rt_route=~'.*'})[1m])), 'service', '$1', 'dst', '([a-zA-Z-]*){1}.([a-zA-Z-.]*):.*'), 'cluster', '$input{cluster}')"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  status_histo "status_4xx" {
    unit = "count"

    source prometheus "status_4xx" {
      histo_column = "status_code"
      query = "label_set(label_replace((sum by (cluster, workload_ns, dst, rt_route, status_code) (increase(route_response_total{direction='outbound', dst=~'.*svc.cluster.local.*', status_code=~'^4.*', rt_route=~'.*'})[1m])), 'service', '$1', 'dst', '([a-zA-Z-]*){1}.([a-zA-Z-.]*):.*'), 'cluster', '$input{cluster}')"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  status_histo "status_5xx" {
    unit = "count"

    source prometheus "status_5xx" {
      histo_column = "status_code"
      query = "label_set(label_replace((sum by (cluster, workload_ns, dst, rt_route, status_code) (increase(route_response_total{direction='outbound', dst=~'.*svc.cluster.local.*', status_code=~'^5.*', rt_route=~'.*'})[1m])), 'service', '$1', 'dst', '([a-zA-Z-]*){1}.([a-zA-Z-.]*):.*'), 'cluster', '$input{cluster}')"

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  latency_histo "latency_histo" {
    unit = "ms"

    source prometheus "latency" {
      query = <<EOT
         label_set(sum by (cluster, workload_ns, dst, rt_route, le)
          (increase(route_response_latency_ms_bucket{direction='outbound', dst=~'.*svc.cluster.local.*', rt_route=~'.*'}[1m])), 'cluster', '$input{cluster}')
      EOT

      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }
}

