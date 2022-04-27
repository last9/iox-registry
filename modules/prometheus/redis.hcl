ingester redis_single_node module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  inputs = "$input{inputs}"

  label {
    type = "service"
    name = "$input{service}"
  }

  label {
    type = "namespace"
    name = "$input{namespace}"
  }

  physical_component {
    type = "redis_cluster_group_1"
    name = "redis_cluster_group_1"
  }

  data_for_graph_node {
    type = "redis_cluster_1"
    name = "$output{cluster}"
  }

  using = {
    "default" : "$input{using}"
  }


  gauge "cache_miss_rate" {
    index       = 1
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "AVG"

    source prometheus "cache_miss_rate" {
      query = "label_replace(100 - sum by (cluster) (redis_keyspace_hits_total{}) / (sum by (cluster) (redis_keyspace_hits_total{}) + sum by (cluster) (redis_keyspace_misses_total{}))*100, 'dummy_label', '$input{dummy_label}', '', '')"

      join_on = {
        "$output{dummy_label}" = "$input{dummy_label}"
      }
    }
  }

  gauge "uptime" {
    index       = 2
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MIN"

    source prometheus "uptime" {
      query = "label_replace(min by (cluster) (rate(redis_uptime_in_seconds{})), 'dummy_label', '$input{dummy_label}', '', '')"

      join_on = {
        "$output{dummy_label}" = "$input{dummy_label}"
      }
    }
  }
  gauge "evicted_keys" {
    index       = 3
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "AVG"

    source prometheus "evicted_keys" {
      query = "label_replace(max by (cluster) (rate(redis_evicted_keys_total{})), 'dummy_label', '$input{dummy_label}', '', '')"

      join_on = {
        "$output{dummy_label}" = "$input{dummy_label}"
      }
    }


  }


  gauge "total_keys" {
    index       = 4
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "total_keys" {
      query = "label_replace(sum by (cluster) (redis_db_keys{}) , 'dummy_label', '$input{dummy_label}', '', '')"

      join_on = {
        "$output{dummy_label}" = "$input{dummy_label}"
      }
    }
  }


  gauge "throughput" {
    index       = 5
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "throughput" {
      query = "label_replace(sum by (cluster) (rate(redis_commands_processed_total{})) , 'dummy_label', '$input{dummy_label}', '', '')"

      join_on = {
        "$output{dummy_label}" = "$input{dummy_label}"
      }
    }
  }


  gauge "max_latency" {
    index       = 6
    input_unit  = "s"
    output_unit = "s"
    aggregator  = "AVG"

    source prometheus "latency" {
      query = "label_replace(max by (cluster) (rate(redis_commands_duration_seconds_total{}))  , 'dummy_label', '$input{dummy_label}', '', '')"

      join_on = {
        "$output{dummy_label}" = "$input{dummy_label}"
      }
    }
  }

  gauge "blocked_clients" {
    index       = 7
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "blocked_clients" {
      query = "label_replace(sum by (cluster) (redis_blocked_clients{}) , 'dummy_label', '$input{dummy_label}', '', '')"

      join_on = {
        "$output{dummy_label}" = "$input{dummy_label}"
      }
    }
  }

  gauge "connections" {
    index       = 8
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "connections" {
      query = "label_replace(sum by (cluster) (redis_connected_clients{}) , 'dummy_label', '$input{dummy_label}', '', '')"

      join_on = {
        "$output{dummy_label}" = "$input{dummy_label}"
      }
    }
  }

  gauge "rejected_connections" {
    index       = 9
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "rejected_connections" {
      query = "label_replace(sum by (cluster) (redis_rejected_connections_total{}) , 'dummy_label', '$input{dummy_label}', '', '')"

      join_on = {
        "$output{dummy_label}" = "$input{dummy_label}"
      }
    }
  }

  gauge "memory" {
    index       = 11
    input_unit  = "bytes"
    output_unit = "bytes"
    aggregator  = "AVG"

    source prometheus "memory" {
      query = "label_replace(max by (cluster) (redis_memory_used_bytes{}) , 'dummy_label', '$input{dummy_label}', '', '')"

      join_on = {
        "$output{dummy_label}" = "$input{dummy_label}"
      }
    }
  }

  gauge "memory_defragmentation_ratio" {
    index       = 12
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "AVG"

    source prometheus "memory_defragmentation_ratio" {
      query = "label_replace(max by (cluster) (redis_mem_fragmentation_ratio{}) , 'dummy_label', '$input{dummy_label}', '', '')"

      join_on = {
        "$output{dummy_label}" = "$input{dummy_label}"
      }
    }
  }

  gauge "network_in" {
    index       = 13
    input_unit  = "Bps"
    output_unit = "Bps"
    aggregator  = "SUM"

    source prometheus "network_in" {
      query = "label_replace(sum by (cluster) (rate(redis_net_input_bytes_total{})) , 'dummy_label', '$input{dummy_label}', '', '')"

      join_on = {
        "$output{dummy_label}" = "$input{dummy_label}"
      }
    }
  }

  gauge "network_out" {
    index       = 14
    input_unit  = "Bps"
    output_unit = "Bps"
    aggregator  = "SUM"

    source prometheus "network_out" {
      query = "label_replace(sum by (cluster) (rate(redis_net_output_bytes_total{})) , 'dummy_label', '$input{dummy_label}', '', '')"

      join_on = {
        "$output{dummy_label}" = "$input{dummy_label}"
      }
    }
  }


}
