ingester aws_apigateway module {
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
    name = "$input{ApiName}"
  }

  data_for_graph_node {
    type = "aws_apigateway"
    name = "$input{ApiName}"
  }

  using = {
    "default" : "$input{using}"
  }

  inputs = "$input{inputs}"

  gauge "throughput" {
    unit = "count"
    source cloudwatch "througput" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/ApiGateway"
        metric_name = "Count"

        dimensions = {
          "ApiName" = "$input{ApiName}"
        }
      }
    }
  }

  gauge "latency" {
    unit = "millisecond"
    source cloudwatch "latency" {
      query {
        aggregator  = "Average"
        namespace   = "AWS/ApiGateway"
        metric_name = "Latency"

        dimensions = {
          "ApiName" = "$input{ApiName}"
        }
      }
    }
  }

  gauge "integration_latency" {
    unit = "count"
    source cloudwatch "integration_latency" {
      query {
        aggregator  = "Average"
        namespace   = "AWS/ApiGateway"
        metric_name = "IntegrationLatency"

        dimensions = {
          "ApiName" = "$input{ApiName}"
        }
      }
    }
  }

  // The Average statistic represents the cache hit rate, namely, the total count of the cache hits divided by
  // the total number of requests during the period
  gauge "cache_hit_rate" {
    unit = "average"
    source cloudwatch "cache_hit_rate" {
      query {
        aggregator  = "Average"
        namespace   = "AWS/ApiGateway"
        metric_name = "CacheHitCount"

        dimensions = {
          "ApiName" = "$input{ApiName}"
        }
      }
    }
  }

  // The Average statistic represents the 4XXError error rate, namely, the total count of the 4XXError errors divided by
  // the total number of requests during the period.
  gauge "status_4xx" {
    unit = "percent"
    source cloudwatch "4xx" {
      query {
        aggregator  = "Average"
        namespace   = "AWS/ApiGateway"
        metric_name = "4xxError"
        dimensions = {
          "ApiName" = "$input{ApiName}"
        }
      }
    }
  }

  // The Average statistic represents the 5XXError error rate, namely, the total count of the 5XXError errors divided by
  // the total number of requests during the period.
  gauge "status_5xx" {
    unit = "percent"
    source cloudwatch "5xx" {
      query {
        aggregator  = "Average"
        namespace   = "AWS/ApiGateway"
        metric_name = "5xxError"
        dimensions = {
          "ApiName" = "$input{ApiName}"
        }
      }
    }
  }

}
