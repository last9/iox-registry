ingester aws_apigateway_cloudwatch module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  label {
    type = "service"
    name = "$input{service}"
  }

  physical_component {
    type = "aws_apigateway"
    name = "$input{ApiName}-$input{Stage}"
  }

  data_for_graph_node {
    type = "aws_apigateway"
    name = "$input{ApiName}-$input{Stage}"
  }

  using = {
    "default" : "$input{using}"
  }

  inputs = "$input{inputs}"

  gauge "throughput" {
    unit       = "count"
    aggregator = "SUM"
    source cloudwatch "througput" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/ApiGateway"
        metric_name = "Count"

        dimensions = {
          "ApiName" = "$input{ApiName}"
          "Stage"   = "$input{Stage}"
        }
      }
    }
  }

  latency "latency_histo" {
    unit         = "ms"
    aggregator   = "PERCENTILE"
    error_margin = 0.05

    source cloudwatch "throughput" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/ApiGateway"
        metric_name = "Count"

        dimensions = {
          "ApiName" = "$input{ApiName}"
          "Stage"   = "$input{Stage}"
        }
      }
    }

    source cloudwatch "latency" {
      query {
        aggregator  = "Average"
        namespace   = "AWS/ApiGateway"
        metric_name = "Latency"

        dimensions = {
          "ApiName" = "$input{ApiName}"
          "Stage"   = "$input{Stage}"
        }
      }
    }

    source cloudwatch "p50" {
      query {
        aggregator  = "p50"
        namespace   = "AWS/ApiGateway"
        metric_name = "Latency"

        dimensions = {
          "ApiName" = "$input{ApiName}"
          "Stage"   = "$input{Stage}"
        }
      }
    }
    source cloudwatch "p75" {
      query {
        aggregator  = "p75"
        namespace   = "AWS/ApiGateway"
        metric_name = "Latency"

        dimensions = {
          "ApiName" = "$input{ApiName}"
          "Stage"   = "$input{Stage}"
        }
      }
    }

    source cloudwatch "p90" {
      query {
        aggregator  = "p90"
        namespace   = "AWS/ApiGateway"
        metric_name = "Latency"

        dimensions = {
          "ApiName" = "$input{ApiName}"
          "Stage"   = "$input{Stage}"
        }
      }
    }

    source cloudwatch "p99" {
      query {
        aggregator  = "p99"
        namespace   = "AWS/ApiGateway"
        metric_name = "Latency"

        dimensions = {
          "ApiName" = "$input{ApiName}"
          "Stage"   = "$input{Stage}"
        }
      }
    }

    source cloudwatch "p100" {
      query {
        aggregator  = "p100"
        namespace   = "AWS/ApiGateway"
        metric_name = "Latency"

        dimensions = {
          "ApiName" = "$input{ApiName}"
          "Stage"   = "$input{Stage}"
        }
      }
    }
  }

  gauge "integration_latency" {
    unit       = "ms"
    aggregator = "AVG"
    source cloudwatch "integration_latency" {
      query {
        aggregator  = "Average"
        namespace   = "AWS/ApiGateway"
        metric_name = "IntegrationLatency"

        dimensions = {
          "ApiName" = "$input{ApiName}"
          "Stage"   = "$input{Stage}"
        }
      }
    }
  }

  // The Average statistic represents the cache hit rate, namely, the total count of the cache hits divided by
  // the total number of requests during the period
  gauge "cache_miss" {
    unit       = "count"
    aggregator = "SUM"
    source cloudwatch "cache_miss" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/ApiGateway"
        metric_name = "CacheMissCount"

        dimensions = {
          "ApiName" = "$input{ApiName}"
          "Stage"   = "$input{Stage}"
        }
      }
    }
  }

  // The Average statistic represents the 4XXError error rate, namely, the total count of the 4XXError errors divided by
  // the total number of requests during the period.
  status_histo "status_4xx" {
    unit       = "count"
    aggregator = "SUM"
    source cloudwatch "status_400" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/ApiGateway"
        metric_name = "4xxError"
        dimensions = {
          "ApiName" = "$input{ApiName}"
          "Stage"   = "$input{Stage}"
        }
      }
    }
  }

  // The Average statistic represents the 5XXError error rate, namely, the total count of the 5XXError errors divided by
  // the total number of requests during the period.
  status_histo "status_5xx" {
    unit       = "count"
    aggregator = "SUM"
    source cloudwatch "status_500" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/ApiGateway"
        metric_name = "5xxError"
        dimensions = {
          "ApiName" = "$input{ApiName}"
          "Stage"   = "$input{Stage}"
        }
      }
    }
  }

}
