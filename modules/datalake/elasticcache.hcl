ingester aws_elasticache_redis_cloudwatch module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  inputs = "$input{input}"

  label {
    type = "service"
    name = "$output{tag_service}"
  }

  label {
    type = "namespace"
    name = "$output{tag_namespace}"
  }

  physical_component {
    type = "elasticache_cluster"
    name = "$input{CacheClusterId}"
  }

  physical_address {
    type = "elasticache_node"
    name = "0001"
  }

  using = {
    "default" : "$input{using}"
  }

  gauge "curr_connections" {
    index       = 1
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "AVG"

    source prometheus "curr_connections" {
      query = "avg by (CacheClusterId, CacheNodeId, tag_namespace, tag_service) (curr_connections)"

      join_on = {
        "$output{CacheClusterId}" = "$input{CacheClusterId}"
        "$output{CacheNodeId}"    = "0001"
      }
    }
  }

  gauge "new_connections" {
    index       = 3
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "AVG"

    source prometheus "new_connections" {
      query = "avg by (CacheClusterId, CacheNodeId, tag_namespace, tag_service) (new_connections)"

      join_on = {
        "$output{CacheClusterId}" = "$input{CacheClusterId}"
        "$output{CacheNodeId}"    = "0001"
      }
    }
  }

  gauge "curr_items" {
    index       = 2
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"

    source prometheus "curr_items" {
      query = "max by (CacheClusterId, CacheNodeId, tag_namespace, tag_service) (curr_items)"

      join_on = {
        "$output{CacheClusterId}" = "$input{CacheClusterId}"
        "$output{CacheNodeId}"    = "0001"
      }
    }
  }

  gauge "cache_hit_rate" {
    index       = 4
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "MIN"

    source prometheus "cache_hit_rate" {
      query = "min by (CacheClusterId, CacheNodeId, tag_namespace, tag_service) (cache_hit_rate)"

      join_on = {
        "$output{CacheClusterId}" = "$input{CacheClusterId}"
        "$output{CacheNodeId}"    = "0001"
      }
    }
  }

  gauge "cache_hits" {
    index       = 6
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"

    source prometheus "cache_hits" {
      query = "max by (CacheClusterId, CacheNodeId, tag_namespace, tag_service) (cache_hits)"

      join_on = {
        "$output{CacheClusterId}" = "$input{CacheClusterId}"
        "$output{CacheNodeId}"    = "0001"
      }
    }
  }

  gauge "cache_misses" {
    index       = 7
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"

    source prometheus "cache_misses" {
      query = "max by (CacheClusterId, CacheNodeId, tag_namespace, tag_service) (cache_misses)"

      join_on = {
        "$output{CacheClusterId}" = "$input{CacheClusterId}"
        "$output{CacheNodeId}"    = "0001"
      }
    }
  }

  gauge "evictions" {
    index       = 5
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "evictions" {
      query = "sum by (CacheClusterId, CacheNodeId, tag_namespace, tag_service) (evictions)"

      join_on = {
        "$output{CacheClusterId}" = "$input{CacheClusterId}"
        "$output{CacheNodeId}"    = "0001"
      }
    }
  }

  latency "latency_histo" {
    error_margin = 0.05
    index        = 6
    input_unit   = "ms"
    output_unit  = "ms"
    aggregator   = "PERCENTILE"
    multiplier   = 0.001

    source prometheus "throughput" {
      query = "avg by (CacheClusterId, CacheNodeId, tag_namespace, tag_service) (latency_histo{le='throughput'})"

      join_on = {
        "$output{CacheClusterId}" = "$input{CacheClusterId}"
        "$output{CacheNodeId}"    = "0001"
      }
    }

    source prometheus "p50" {
      query = "avg by (CacheClusterId, CacheNodeId, tag_namespace, tag_service) (latency_histo{le='p50'})"

      join_on = {
        "$output{CacheClusterId}" = "$input{CacheClusterId}"
        "$output{CacheNodeId}"    = "0001"
      }
    }

    source prometheus "p75" {
      query = "avg by (CacheClusterId, CacheNodeId, tag_namespace, tag_service) (latency_histo{le='p75'})"

      join_on = {
        "$output{CacheClusterId}" = "$input{CacheClusterId}"
        "$output{CacheNodeId}"    = "0001"
      }
    }

    source prometheus "p90" {
      query = "avg by (CacheClusterId, CacheNodeId, tag_namespace, tag_service) (latency_histo{le='p90'})"

      join_on = {
        "$output{CacheClusterId}" = "$input{CacheClusterId}"
        "$output{CacheNodeId}"    = "0001"
      }
    }

    source prometheus "p99" {
      query = "avg by (CacheClusterId, CacheNodeId, tag_namespace, tag_service) (latency_histo{le='p99'})"

      join_on = {
        "$output{CacheClusterId}" = "$input{CacheClusterId}"
        "$output{CacheNodeId}"    = "0001"
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

  inputs = "$input{input}"

  label {
    type = "service"
    name = "$output{tag_service}"
  }

  label {
    type = "namespace"
    name = "$output{tag_namespace}"
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
    "default" : "$input{using}"
  }

  gauge "replication_lag" {
    index       = 4
    input_unit  = "s"
    output_unit = "s"
    aggregator  = "MAX"

    source prometheus "replication_lag" {
      query = "max by (CacheClusterId, CacheNodeId, tag_namespace, tag_service) (replication_lag)"

      join_on = {
        "$output{CacheClusterId}" = "$input{CacheClusterId}"
        "$output{CacheNodeId}"    = "0001"
      }
    }
  }

  gauge "bytes_out" {
    index       = 2
    input_unit  = "bytes"
    output_unit = "bps"
    aggregator  = "SUM"

    source prometheus "bytes_out" {
      query = "sum by (CacheClusterId, CacheNodeId, tag_namespace, tag_service) (bytes_out)"

      join_on = {
        "$output{CacheClusterId}" = "$input{CacheClusterId}"
        "$output{CacheNodeId}"    = "0001"
      }
    }
  }

  gauge "bytes_in" {
    index       = 3
    input_unit  = "bytes"
    output_unit = "bps"
    aggregator  = "SUM"

    source prometheus "bytes_in" {
      query = "sum by (CacheClusterId, CacheNodeId, tag_namespace, tag_service) (bytes_in)"

      join_on = {
        "$output{CacheClusterId}" = "$input{CacheClusterId}"
        "$output{CacheNodeId}"    = "0001"
      }
    }
  }

  gauge "cpu_used" {
    index       = 1
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "AVG"

    source prometheus "cpu_used" {
      query = "avg by (CacheClusterId, CacheNodeId, tag_namespace, tag_service) (cpu_used)"

      join_on = {
        "$output{CacheClusterId}" = "$input{CacheClusterId}"
        "$output{CacheNodeId}"    = "0001"
      }
    }
  }

  gauge "memory_used" {
    index       = 5
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "AVG"

    source prometheus "memory_used" {
      query = "avg by (CacheClusterId, CacheNodeId, tag_namespace, tag_service) (memory_used)"

      join_on = {
        "$output{CacheClusterId}" = "$input{CacheClusterId}"
        "$output{CacheNodeId}"    = "0001"
      }
    }
  }
}
