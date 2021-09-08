// Elasticache Metrics Ingesters
ingester aws_elasticache_redis_cloudwatch module {
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
    type = "elasticache_cluster"
    name = "$input{CacheClusterId}"
  }

  physical_address {
    type = "elasticache_node"
    name = "$input{CacheNodeId}"
  }

  data_for_graph_node {
    type = "elasticache_database"
    name = "$input{CacheClusterId}-db"
  }

  using = {
    default = "$input{using}"
  }

  inputs = "$input{inputs}"

  input_query = <<-EOF
    label_set(
      label_replace(
        elasticache_cluster{$input{tag_filter}}, 'id=CacheClusterId'
      ), "service", "$input{service}"
    )
  EOF

  gauge "curr_items" {
    unit       = "count"
    aggregator = "MAX"

    source cloudwatch "CurrItems" {
      query {
        aggregator  = "Maximum"
        namespace   = "AWS/ElastiCache"
        metric_name = "CurrItems"
        dimensions = {
          CacheClusterId = "$input{CacheClusterId}"
          CacheNodeId    = "$input{CacheNodeId}"
        }
      }
    }
  }
  gauge "cache_hit_rate" {
    unit       = "percent"
    aggregator = "MIN"

    source cloudwatch "CacheHitRate" {
      query {
        aggregator  = "Minimum"
        namespace   = "AWS/ElastiCache"
        metric_name = "CacheHitRate"
        dimensions = {
          CacheClusterId = "$input{CacheClusterId}"
          CacheNodeId    = "$input{CacheNodeId}"
        }
      }
    }
  }
  gauge "evictions" {
    unit       = "count"
    aggregator = "SUM"
    source cloudwatch "Evictions" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/ElastiCache"
        metric_name = "Evictions"
        dimensions = {
          CacheClusterId = "$input{CacheClusterId}"
          CacheNodeId    = "$input{CacheNodeId}"
        }
      }
    }
  }
  latency "latency_histo" {
    error_margin = 0.05
    unit         = "ms"
    aggregator   = "PERCENTILE"
    multiplier   = 0.001
    source cloudwatch "throughput" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/ElastiCache"
        metric_name = "SetTypeCmds"
        dimensions = {
          CacheClusterId = "$input{CacheClusterId}"
          CacheNodeId    = "$input{CacheNodeId}"
        }
      }
    }
    source cloudwatch "p50" {
      query {
        aggregator  = "p50"
        namespace   = "AWS/ElastiCache"
        metric_name = "SetTypeCmdsLatency"
        dimensions = {
          CacheClusterId = "$input{CacheClusterId}"
          CacheNodeId    = "$input{CacheNodeId}"
        }
      }
    }
    source cloudwatch "p75" {
      query {
        aggregator  = "p75"
        namespace   = "AWS/ElastiCache"
        metric_name = "SetTypeCmdsLatency"
        dimensions = {
          CacheClusterId = "$input{CacheClusterId}"
          CacheNodeId    = "$input{CacheNodeId}"
        }
      }
    }
    source cloudwatch "p90" {
      query {
        aggregator  = "p90"
        namespace   = "AWS/ElastiCache"
        metric_name = "SetTypeCmdsLatency"
        dimensions = {
          CacheClusterId = "$input{CacheClusterId}"
          CacheNodeId    = "$input{CacheNodeId}"
        }
      }
    }
    source cloudwatch "p99" {
      query {
        aggregator  = "p99"
        namespace   = "AWS/ElastiCache"
        metric_name = "SetTypeCmdsLatency"
        dimensions = {
          CacheClusterId = "$input{CacheClusterId}"
          CacheNodeId    = "$input{CacheNodeId}"
        }
      }
    }
  }
}

ingester aws_elasticache_cluster_cloudwatch module {
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
    type = "elasticache_cluster"
    name = "$input{CacheClusterId}"
  }

  data_for_graph_node {
    type = "elasticache_cluster"
    name = "$input{CacheClusterId}"
  }

  using = {
    default = "$input{using}"
  }

  inputs = "$input{inputs}"

  input_query = <<-EOF
    label_set(
      label_replace(
        elasticache_cluster{$input{tag_filter}}, 'id=CacheClusterId'
      ), "service", "$input{service}"
    )
  EOF

  gauge "replication_lag" {
    unit       = "s"
    aggregator = "MAX"

    source cloudwatch "ReplicationLag" {
      query {
        aggregator  = "Maximum"
        namespace   = "AWS/ElastiCache"
        metric_name = "ReplicationLag"
        dimensions = {
          CacheClusterId = "$input{CacheClusterId}"
          CacheNodeId    = "$input{CacheNodeId}"
        }
      }
    }
  }
  gauge "bytes_out" {
    unit       = "bytes"
    aggregator = "SUM"

    source cloudwatch "NetworkBytesOut" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/ElastiCache"
        metric_name = "NetworkBytesOut"
        dimensions = {
          CacheClusterId = "$input{CacheClusterId}"
          CacheNodeId    = "$input{CacheNodeId}"
        }
      }
    }
  }
  gauge "bytes_in" {
    unit       = "bytes"
    aggregator = "SUM"

    source cloudwatch "NetworkBytesIn" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/ElastiCache"
        metric_name = "NetworkBytesIn"
        dimensions = {
          CacheClusterId = "$input{CacheClusterId}"
          CacheNodeId    = "$input{CacheNodeId}"
        }
      }
    }
  }
  gauge "cpu_used" {
    unit       = "percent"
    aggregator = "AVG"

    source cloudwatch "EngineCPUUtilization" {
      query {
        aggregator  = "Average"
        namespace   = "AWS/ElastiCache"
        metric_name = "EngineCPUUtilization"
        dimensions = {
          CacheClusterId = "$input{CacheClusterId}"
          CacheNodeId    = "$input{CacheNodeId}"
        }
      }
    }
  }
}
