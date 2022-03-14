ingester aws_apigateway module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  inputs = "$input{input}"

  using = {
    "default" = "$input{using}"
  }

  label {
    type = "namespace"
    name = "$output{tag_namespace}"
  }

  label {
    type = "service"
    name = "$output{tag_service}"
  }

  physical_component {
    type = "aws_apigateway"
    name = "$input{ApiName}-$input{Stage}"
  }

  data_for_graph_node {
    type = "aws_apigateway"
    name = "$input{ApiName}-$input{Stage}"
  }

  gauge "throughput" {
    index       = 1
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"

    source prometheus "throughput" {
      query = "sum by (ApiName, Stage, tag_namespace, tag_service) (throughput)"

      join_on = {
        "$output{ApiName}" = "$input{ApiName}"
        "$output{Stage}"   = "$input{Stage}"
      }
    }
  }

  latency "latency_histo" {
    index        = 6
    input_unit   = "ms"
    output_unit  = "ms"
    aggregator   = "PERCENTILE"
    error_margin = 0.05
    multiplier   = 1

    source prometheus "throughput" {
      query = "avg by (ApiName, Stage, tag_namespace, tag_service) (latency_histo{le='throughput'})"

      join_on = {
        "$output{ApiName}" = "$input{ApiName}"
        "$output{Stage}"   = "$input{Stage}"
      }
    }

    source prometheus "p50" {
      query = "avg by (ApiName, Stage, tag_namespace, tag_service) (latency_histo{le='p50'})"

      join_on = {
        "$output{ApiName}" = "$input{ApiName}"
        "$output{Stage}"   = "$input{Stage}"
      }
    }

    source prometheus "latency" {
      query = "avg by (ApiName, Stage, tag_namespace, tag_service) (latency_histo{le='latency'})"

      join_on = {
        "$output{ApiName}" = "$input{ApiName}"
        "$output{Stage}"   = "$input{Stage}"
      }
    }

    source prometheus "p75" {
      query = "avg by (ApiName, Stage, tag_namespace, tag_service) (latency_histo{le='p75'})"

      join_on = {
        "$output{ApiName}" = "$input{ApiName}"
        "$output{Stage}"   = "$input{Stage}"
      }
    }

    source prometheus "p90" {
      query = "avg by (ApiName, Stage, tag_namespace, tag_service) (latency_histo{le='p90'})"

      join_on = {
        "$output{ApiName}" = "$input{ApiName}"
        "$output{Stage}"   = "$input{Stage}"
      }
    }

    source prometheus "p99" {
      query = "avg by (ApiName, Stage, tag_namespace, tag_service) (latency_histo{le='p99'})"

      join_on = {
        "$output{ApiName}" = "$input{ApiName}"
        "$output{Stage}"   = "$input{Stage}"
      }
    }

    source prometheus "p100" {
      query = "avg by (ApiName, Stage, tag_namespace, tag_service) (latency_histo{le='p100'})"

      join_on = {
        "$output{ApiName}" = "$input{ApiName}"
        "$output{Stage}"   = "$input{Stage}"
      }
    }
  }

  gauge "integration_latency" {
    index       = 3
    input_unit  = "ms"
    output_unit = "ms"
    aggregator  = "AVG"

    source prometheus "integration_latency" {
      query = "avg by (ApiName, Stage, tag_namespace, tag_service) (integration_latency)"

      join_on = {
        "$output{ApiName}" = "$input{ApiName}"
        "$output{Stage}"   = "$input{Stage}"
      }
    }
  }

  // The Average statistic represents the cache hit rate, namely, the total count of the cache hits divided by
  // the total number of requests during the period
  gauge "cache_miss" {
    index       = 7
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "cache_miss" {
      query = "sum by (ApiName, Stage, tag_namespace, tag_service) (cache_miss)"

      join_on = {
        "$output{ApiName}" = "$input{ApiName}"
        "$output{Stage}"   = "$input{Stage}"
      }
    }
  }

  // The Average statistic represents the 4XXError error rate, namely, the total count of the 4XXError errors divided by
  // the total number of requests during the period.
  status_histo "status_4xx" {
    index       = 4
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"

    source prometheus "status_4xx" {
      query = "sum by (ApiName, Stage, tag_namespace, tag_service) (status_4xx)"

      join_on = {
        "$output{ApiName}" = "$input{ApiName}"
        "$output{Stage}"   = "$input{Stage}"
      }
    }
  }

  // The Average statistic represents the 5XXError error rate, namely, the total count of the 5XXError errors divided by
  // the total number of requests during the period.
  status_histo "status_5xx" {
    index       = 5
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"

    source prometheus "status_5xx" {
      query = "sum by (ApiName, Stage, tag_namespace, tag_service) (status_5xx)"

      join_on = {
        "$output{ApiName}" = "$input{ApiName}"
        "$output{Stage}"   = "$input{Stage}"
      }
    }
  }
}
