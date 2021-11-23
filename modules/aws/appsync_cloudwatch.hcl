ingester aws_appsync_cloudwatch module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  label {
    type = "service"
    name = "$input{service}"
  }

  label {
    type = "namespace"
    name = "$input{namespace}"
  }

  physical_component {
    type = "appsync"
    name = "$input{AppSyncName}-$input{GraphQLAPIId}"
  }

  data_for_graph_node {
    type = "appsync"
    name = "$input{AppSyncName}-$input{GraphQLAPIId}"
  }

  using = {
    "default" : "$input{using}"
  }

  inputs = "$input{inputs}"

  latency "latency_histo" {
    index        = 6
    input_unit   = "ms"
    output_unit  = "ms"
    aggregator   = "PERCENTILE"
    error_margin = 0.05
    multiplier   = 1

    source cloudwatch "throughput" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/AppSync"
        metric_name = "Count"

        dimensions = {
          "GraphQLAPIId" = "$input{GraphQLAPIId}"
        }
      }
    }

    source cloudwatch "latency" {
      query {
        aggregator  = "Average"
        namespace   = "AWS/AppSync"
        metric_name = "Latency"

        dimensions = {
          "GraphQLAPIId" = "$input{GraphQLAPIId}"
        }
      }
    }

    source cloudwatch "p50" {
      query {
        aggregator  = "p50"
        namespace   = "AWS/AppSync"
        metric_name = "Latency"

        dimensions = {
          "GraphQLAPIId" = "$input{GraphQLAPIId}"
        }
      }
    }
    source cloudwatch "p75" {
      query {
        aggregator  = "p75"
        namespace   = "AWS/AppSync"
        metric_name = "Latency"

        dimensions = {
          "GraphQLAPIId" = "$input{GraphQLAPIId}"
        }
      }
    }

    source cloudwatch "p90" {
      query {
        aggregator  = "p90"
        namespace   = "AWS/AppSync"
        metric_name = "Latency"

        dimensions = {
          "GraphQLAPIId" = "$input{GraphQLAPIId}"
        }
      }
    }

    source cloudwatch "p99" {
      query {
        aggregator  = "p99"
        namespace   = "AWS/AppSync"
        metric_name = "Latency"

        dimensions = {
          "GraphQLAPIId" = "$input{GraphQLAPIId}"
        }
      }
    }

    source cloudwatch "p100" {
      query {
        aggregator  = "p100"
        namespace   = "AWS/AppSync"
        metric_name = "Latency"

        dimensions = {
          "GraphQLAPIId" = "$input{GraphQLAPIId}"
        }
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
    source cloudwatch "status_400" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/AppSync"
        metric_name = "4XXError"
        dimensions = {
          "GraphQLAPIId" = "$input{GraphQLAPIId}"
        }
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
    source cloudwatch "status_500" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/AppSync"
        metric_name = "5XXError"
        dimensions = {
          "GraphQLAPIId" = "$input{GraphQLAPIId}"
        }
      }
    }
  }

  gauge "connect_server_error" {
    index       = 9
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source cloudwatch "connect_server_error" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/AppSync"
        metric_name = "ConnectServerError"
        dimensions = {
          "GraphQLAPIId" = "$input{GraphQLAPIId}"
        }
      }
    }
  }

  gauge "subscribe_server_error" {
    index       = 11
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source cloudwatch "subscribe_server_error" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/AppSync"
        metric_name = "SubscribeServerError"
        dimensions = {
          "GraphQLAPIId" = "$input{GraphQLAPIId}"
        }
      }
    }
  }

  gauge "disconnect_server_error" {
    index       = 12
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source cloudwatch "disconnect_server_error" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/AppSync"
        metric_name = "DisconnectServerError"
        dimensions = {
          "GraphQLAPIId" = "$input{GraphQLAPIId}"
        }
      }
    }
  }

  gauge "unsubscribe_server_error" {
    index       = 13
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source cloudwatch "unsubscribe_server_error" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/AppSync"
        metric_name = "UnsubscribeServerError"
        dimensions = {
          "GraphQLAPIId" = "$input{GraphQLAPIId}"
        }
      }
    }
  }

  gauge "publish_data_message_server_error" {
    index       = 14
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source cloudwatch "publish_data_message_server_error" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/AppSync"
        metric_name = "PublishDataMessageServerError"
        dimensions = {
          "GraphQLAPIId" = "$input{GraphQLAPIId}"
        }
      }
    }
  }
}
