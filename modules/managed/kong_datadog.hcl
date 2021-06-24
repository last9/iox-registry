ingester managed_kong_endpoint_datadog module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 0

  inputs = "$input{inputs}"

  label {
    type = "service"
    name = "$input{service}"
  }

  label {
    type = "namespace"
    name = "$input{env}"
  }

  physical_component {
    type = "kong_cluster"
    name = "$input{cluster}"
  }

  data_for_graph_node {
    type = "kong_endpoint"
    name = "$output{route}"
  }

  using = {
    "default" : "$input{using}"
  }

  gauge "throughput" {
    unit = "count"
    aggregator = "SUM"
    source datadog "throughput" {
      query = "sum:kong.request.count{*} by {cluster,env,kong_upstream,route}.rollup(sum, 60)"

      join_on = {
        "$input{cluster}"       = "$output{cluster}"
        "$input{env}"           = "$output{env}"
        "$input{kong_upstream}" = "$output{kong_upstream}"
      }
    }
  }

  gauge "latency" {
    unit = "ms"
    aggregator = "AVG"
    source datadog "avg_latency" {
      query = "avg:kong.latency.avg{*} by {cluster,env,kong_upstream,route}.rollup(sum, 60)"

      join_on = {
        "$input{cluster}"       = "$output{cluster}"
        "$input{env}"           = "$output{env}"
        "$input{kong_upstream}" = "$output{kong_upstream}"
      }
    }
  }
}
