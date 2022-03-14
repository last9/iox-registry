ingester aws_elasticache_redis module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  inputs = "[]"

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
    name = "ELASTICACHE_CLUSTER"
  }

  physical_address {
    type = "elasticache_node"
    name = "0001"
  }

  data_for_graph_node {
    type = "elasticache_database"
    name = "$output{CacheClusterId}"
  }

  using = {
    "default" = "$input{using}"
  }

  gauge "curr_connections" {
    index       = 1
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "AVG"

    source prometheus "curr_connections" {
      query = "avg by (CacheClusterId, CacheNodeId, tag_namespace, tag_service) (curr_connections{CacheClusterId!='',CacheNodeId!=''})"
    }
  }

  gauge "new_connections" {
    index       = 3
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "AVG"

    source prometheus "new_connections" {
      query = "avg by (CacheClusterId, CacheNodeId, tag_namespace, tag_service) (new_connections{CacheClusterId!='',CacheNodeId!=''})"
    }
  }

  gauge "curr_items" {
    index       = 2
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"

    source prometheus "curr_items" {
      query = "max by (CacheClusterId, CacheNodeId, tag_namespace, tag_service) (curr_items{CacheClusterId!='',CacheNodeId!=''})"
    }
  }

  gauge "cache_hit_rate" {
    index       = 4
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "MIN"

    source prometheus "cache_hit_rate" {
      query = "min by (CacheClusterId, CacheNodeId, tag_namespace, tag_service) (cache_hit_rate{CacheClusterId!='',CacheNodeId!=''})"
    }
  }

  gauge "cache_hits" {
    index       = 6
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"

    source prometheus "cache_hits" {
      query = "max by (CacheClusterId, CacheNodeId, tag_namespace, tag_service) (cache_hits{CacheClusterId!='',CacheNodeId!=''})"
    }
  }

  gauge "cache_misses" {
    index       = 7
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"

    source prometheus "cache_misses" {
      query = "max by (CacheClusterId, CacheNodeId, tag_namespace, tag_service) (cache_misses{CacheClusterId!='',CacheNodeId!=''})"
    }
  }

  gauge "evictions" {
    index       = 5
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "evictions" {
      query = "sum by (CacheClusterId, CacheNodeId, tag_namespace, tag_service) (evictions{CacheClusterId!='',CacheNodeId!=''})"
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
      query = "avg by (CacheClusterId, CacheNodeId, tag_namespace, tag_service) (latency_histo{le='throughput',CacheClusterId!='',CacheNodeId!=''})"
    }

    source prometheus "p50" {
      query = "avg by (CacheClusterId, CacheNodeId, tag_namespace, tag_service) (latency_histo{le='p50',CacheClusterId!='',CacheNodeId!=''})"
    }

    source prometheus "p75" {
      query = "avg by (CacheClusterId, CacheNodeId, tag_namespace, tag_service) (latency_histo{le='p75',CacheClusterId!='',CacheNodeId!=''})"
    }

    source prometheus "p90" {
      query = "avg by (CacheClusterId, CacheNodeId, tag_namespace, tag_service) (latency_histo{le='p90',CacheClusterId!='',CacheNodeId!=''})"
    }

    source prometheus "p99" {
      query = "avg by (CacheClusterId, CacheNodeId, tag_namespace, tag_service) (latency_histo{le='p99',CacheClusterId!='',CacheNodeId!=''})"
    }
  }
}

ingester aws_elasticache_cluster module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  inputs = "[]"

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
    name = "ELASTICACHE_CLUSTER"
  }

  data_for_graph_node {
    type = "elasticache_cluster_logical"
    name = "$output{CacheClusterId}"
  }

  using = {
    "default" = "$input{using}"
  }

  gauge "replication_lag" {
    index       = 4
    input_unit  = "s"
    output_unit = "s"
    aggregator  = "MAX"

    source prometheus "replication_lag" {
      query = "max by (CacheClusterId, CacheNodeId, tag_namespace, tag_service) (replication_lag)"
    }
  }

  gauge "bytes_out" {
    index       = 2
    input_unit  = "bytes"
    output_unit = "bps"
    aggregator  = "SUM"

    source prometheus "bytes_out" {
      query = "sum by (CacheClusterId, CacheNodeId, tag_namespace, tag_service) (bytes_out{CacheClusterId!='',CacheNodeId!=''})"
    }
  }

  gauge "bytes_in" {
    index       = 3
    input_unit  = "bytes"
    output_unit = "bps"
    aggregator  = "SUM"

    source prometheus "bytes_in" {
      query = "sum by (CacheClusterId, CacheNodeId, tag_namespace, tag_service) (bytes_in{CacheClusterId!='',CacheNodeId!=''})"
    }
  }

  gauge "cpu_used" {
    index       = 1
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "AVG"

    source prometheus "cpu_used" {
      query = "avg by (CacheClusterId, CacheNodeId, tag_namespace, tag_service) (cpu_used{CacheClusterId!='',CacheNodeId!=''})"
    }
  }

  gauge "memory_used" {
    index       = 5
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "AVG"

    source prometheus "memory_used" {
      query = "avg by (CacheClusterId, CacheNodeId, tag_namespace, tag_service) (memory_used{CacheClusterId!='',CacheNodeId!=''})"
    }
  }
}
