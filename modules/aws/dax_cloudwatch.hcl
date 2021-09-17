ingester aws_dax_cloudwatch module {
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

  physical_address {
    type = "dax_node"
    name = "$input{NodeId}"
  }

  physical_component {
    type = "dax_cluster"
    name = "$input{ClusterId}"
  }

  data_for_graph_node {
    type = "dax"
    name = "$input{ClusterId}-dax"
  }

  using = {
    default = "$input{using}"
  }

  inputs = "$input{inputs}"

  input_query = <<-EOF
    label_set(
      label_replace(
        dax_cache{$input{tag_filter}}, 'id=ClusterId'
      ), "service", "$input{service}"
    )
  EOF

  gauge "throughput" {
    unit       = "count"
    aggregator = "SUM"
    source cloudwatch "throughput" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/DAX"
        metric_name = "TotalRequestCount"

        dimensions = {
          "ClusterId" = "$input{ClusterId}"
          "NodeId"    = "$input{NodeId}"
        }
      }
    }
  }
  gauge "errored" {
    unit       = "count"
    aggregator = "SUM"
    source cloudwatch "errors" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/DAX"
        metric_name = "ErrorRequestCount"

        dimensions = {
          "ClusterId" = "$input{ClusterId}"
          "NodeId"    = "$input{NodeId}"
        }
      }
    }
  }
  gauge "throttled" {
    unit       = "count"
    aggregator = "SUM"
    source cloudwatch "throttled" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/DAX"
        metric_name = "ThrottledRequestCount"

        dimensions = {
          "ClusterId" = "$input{ClusterId}"
          "NodeId"    = "$input{NodeId}"
        }
      }
    }
  }
  gauge "connections" {
    unit       = "count"
    aggregator = "MAX"
    source cloudwatch "connections" {
      query {
        aggregator  = "Maximum"
        namespace   = "AWS/DAX"
        metric_name = "ClientConnections"

        dimensions = {
          "ClusterId" = "$input{ClusterId}"
          "NodeId"    = "$input{NodeId}"
        }
      }
    }
  }
  gauge "query_miss" {
    unit       = "count"
    aggregator = "SUM"
    source cloudwatch "memory" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/DAX"
        metric_name = "QueryCacheMisses"

        dimensions = {
          "ClusterId" = "$input{ClusterId}"
          "NodeId"    = "$input{NodeId}"
        }
      }
    }
  }
  gauge "cache_memory" {
    unit       = "percent"
    aggregator = "AVG"
    source cloudwatch "memory" {
      query {
        aggregator  = "Average"
        namespace   = "AWS/DAX"
        metric_name = "CacheMemoryUtilization"

        dimensions = {
          "ClusterId" = "$input{ClusterId}"
          "NodeId"    = "$input{NodeId}"
        }
      }
    }
  }
  gauge "cpu" {
    unit       = "percent"
    aggregator = "AVG"
    source cloudwatch "cpu" {
      query {
        aggregator  = "Average"
        namespace   = "AWS/DAX"
        metric_name = "CPUUtilization"

        dimensions = {
          "ClusterId" = "$input{ClusterId}"
          "NodeId"    = "$input{NodeId}"
        }
      }
    }
  }
}
