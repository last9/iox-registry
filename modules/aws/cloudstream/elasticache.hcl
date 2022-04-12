ingester aws_elasticache_cloudstream module {
  frequency = 60
  lookback = 600
  timeout = 30
  resolution = 60
  lag = 60

  label {
    type = "service"
    name = "$input{service}"
  }

  label {
    type = "namespace"
    name = "$input{namespace}"
  }

  physical_component {
    type = "elasticache_cluster"
    name = "$input{CacheClusterId}"
  }

  physical_address {
    type = "elasticache_node"
    name = "0001"
  }

  data_for_graph_node {
    type = "elasticache_database"
    name = "$input{CacheClusterId}-db"
  }

  using = {
    default = "$input{using}"
  }

  gauge "curr_connections" {
    index       = 1
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "AVG"

    source prometheus "CurrConnections" {
      query = "sum by (CacheClusterId) (amazonaws_com_AWS_ElastiCache_CurrConnections{quantile='1',CacheClusterId=~'$input{CacheClusterId}',CacheNodeId='0001'})"
        aggregator  = "Maximum"
        namespace   = "AWS_ElastiCache"
        metric_name = "CurrConnections"
        dimensions = {
          CacheClusterId = "$input{CacheClusterId}"
          CacheNodeId    = "0001"
        }
      join_on = {
        "$output{CacheClusterId}" = "$input{CacheClusterId}"
      }
    }
  }

  gauge "new_connections" {
    index       = 3
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "AVG"

    source cloudwatch "NewConnections" {
      query = "sum by (CacheClusterId) (amazonaws_com_AWS_ElastiCache_NewConnections{quantile='1',CacheClusterId=~'$input{CacheClusterId}',CacheNodeId='0001'})"

      join_on = {
        "$output{CacheClusterId}" = "$input{CacheClusterId}"
      }
    }
  }

  gauge "curr_items" {
    index       = 2
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"

    source cloudwatch "CurrItems" {
      query = "sum by (CacheClusterId) (amazonaws_com_AWS_ElastiCache_CurrItems{quantile='1',CacheClusterId=~'$input{CacheClusterId}',CacheNodeId='0001'})"

      join_on = {
        "$output{CacheClusterId}" = "$input{CacheClusterId}"
      }
    }
  }

  gauge "cache_hit_rate" {
    index       = 4
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "MIN"

    source cloudwatch "CacheHitRate" {
      query = "sum by (CacheClusterId) (amazonaws_com_AWS_ElastiCache_CacheHitRate{quantile='0',CacheClusterId=~'$input{CacheClusterId}',CacheNodeId='0001'})"

      join_on = {
        "$output{CacheClusterId}" = "$input{CacheClusterId}"
      }
    }
  }

  gauge "cache_hits" {
    index       = 6
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"

    source cloudwatch "CacheHits" {
      query = "sum by (CacheClusterId) (amazonaws_com_AWS_ElastiCache_CacheHits{quantile='1',CacheClusterId=~'$input{CacheClusterId}',CacheNodeId='0001'})"

      join_on = {
        "$output{CacheClusterId}" = "$input{CacheClusterId}"
      }
    }
  }

  gauge "cache_misses" {
    index       = 7
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"

    source cloudwatch "CacheMisses" {
      query = "sum by (CacheClusterId) (amazonaws_com_AWS_ElastiCache_CacheMisses{quantile='1',CacheClusterId=~'$input{CacheClusterId}',CacheNodeId='0001'})"

      join_on = {
        "$output{CacheClusterId}" = "$input{CacheClusterId}"
      }
    }
  }

  gauge "evictions" {
    index       = 5
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"
    source cloudwatch "Evictions" {
      query = "sum by (CacheClusterId) (amazonaws_com_AWS_ElastiCache_Evictions_sum{CacheClusterId=~'$input{CacheClusterId}',CacheNodeId='0001'})"

      join_on = {
        "$output{CacheClusterId}" = "$input{CacheClusterId}"
      }
    }
  }

  gauge "replication_lag" {
    index       = 8
    input_unit  = "s"
    output_unit = "s"
    aggregator  = "MAX"

    source cloudwatch "ReplicationLag" {
      query = "sum by (CacheClusterId) (amazonaws_com_AWS_ElastiCache_ReplicationLag{quantile='1',CacheClusterId=~'$input{CacheClusterId}',CacheNodeId='0001'})"

      join_on = {
        "$output{CacheClusterId}" = "$input{CacheClusterId}"
      }
    }
  }

  gauge "cpu_used" {
    index       = 9
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "AVG"

    source cloudwatch "EngineCPUUtilization" {
      query = "sum by (CacheClusterId) (amazonaws_com_AWS_ElastiCache_EngineCPUUtilization_sum{CacheClusterId=~'$input{CacheClusterId}',CacheNodeId='0001'}) / sum by (CacheClusterId) (amazonaws_com_AWS_ElastiCache_EngineCPUUtilization_count{CacheClusterId=~'$input{CacheClusterId}',CacheNodeId='0001'})"

      join_on = {
        "$output{CacheClusterId}" = "$input{CacheClusterId}"
      }
    }
  }

  gauge "bytes_out" {
    index       = 11
    input_unit  = "bytes"
    output_unit = "bps"
    aggregator  = "SUM"

    source cloudwatch "NetworkBytesOut" {
      query = "sum by (CacheClusterId) (amazonaws_com_AWS_NetworkBytesOut_sum{CacheClusterId=~'$input{CacheClusterId}',CacheNodeId='0001'})"

      join_on = {
        "$output{CacheClusterId}" = "$input{CacheClusterId}"
      }
    }
  }

  gauge "bytes_in" {
    index       = 12
    input_unit  = "bytes"
    output_unit = "bps"
    aggregator  = "SUM"

    source cloudwatch "NetworkBytesIn" {
      query = "sum by (CacheClusterId) (amazonaws_com_AWS_NetworkBytesIn_sum{CacheClusterId=~'$input{CacheClusterId}',CacheNodeId='0001'})"

      join_on = {
        "$output{CacheClusterId}" = "$input{CacheClusterId}"
      }
    }
  }

  gauge "memory_used" {
    index       = 13
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "AVG"

    source cloudwatch "DatabaseMemoryUsagePercentage" {
      query = "sum by (CacheClusterId) (amazonaws_com_AWS_ElastiCache_DatabaseMemoryUsagePercentage_sum{CacheClusterId=~'$input{CacheClusterId}',CacheNodeId='0001'}) / sum by (CacheClusterId) (amazonaws_com_AWS_ElastiCache_DatabaseMemoryUsagePercentage_count{CacheClusterId=~'$input{CacheClusterId}',CacheNodeId='0001'})"

      join_on = {
        "$output{CacheClusterId}" = "$input{CacheClusterId}"
      }
    }
  }
}