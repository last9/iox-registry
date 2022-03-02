ingester aws_aurora_instance_logical_cloudwatch module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  label {
    type = "service"
    name = "$input{tag_service}"
  }

  label {
    type = "namespace"
    name = "$input{tag_namespace}"
  }

  physical_component {
    type = "aurora_instance"
    name = "$input{DBInstanceIdentifier}"
  }

  data_for_graph_node {
    type = "aurora_instance_database"
    name = "$input{DBInstanceIdentifier}-db"
  }

  using = {
    default = "$input{using}"
  }

  inputs = "$input{inputs}"

  gauge "connections" {
    index       = 1
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "MAX"
    source prometheus "connections" {
      query = "max by (DBInstanceIdentifier, tag_namespace, tag_service) (connections)"

      join_on = {
        "$output{DBInstanceIdentifier}" = "$input{DBInstanceIdentifier}"
      }
    }
  }

  gauge "read_throughput" {
    index       = 2
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "AVG"
    source prometheus "read_throughput" {
      query = "max by (DBInstanceIdentifier, tag_namespace, tag_service) (read_throughput)"

      join_on = {
        "$output{DBInstanceIdentifier}" = "$input{DBInstanceIdentifier}"
      }
    }
  }


  gauge "read_latency" {
    index       = 3
    input_unit  = "s"
    output_unit = "s"
    aggregator  = "MAX"
    source prometheus "read_latency" {
      query = "max by (DBInstanceIdentifier, tag_namespace, tag_service) (read_latency)"

      join_on = {
        "$output{DBInstanceIdentifier}" = "$input{DBInstanceIdentifier}"
      }
    }
  }

  gauge "write_throughput" {
    index       = 4
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "AVG"
    source prometheus "write_throughput" {
      query = "max by (DBInstanceIdentifier, tag_namespace, tag_service) (write_throughput)"

      join_on = {
        "$output{DBInstanceIdentifier}" = "$input{DBInstanceIdentifier}"
      }
    }
  }

  gauge "write_latency" {
    index       = 5
    input_unit  = "s"
    output_unit = "s"
    aggregator  = "MAX"
    source prometheus "write_latency" {
      query = "max by (DBInstanceIdentifier, tag_namespace, tag_service) (write_latency)"

      join_on = {
        "$output{DBInstanceIdentifier}" = "$input{DBInstanceIdentifier}"
      }
    }
  }

  gauge "update_throughput" {
    index       = 6
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "AVG"
    source prometheus "update_throughput" {
      query = "max by (DBInstanceIdentifier, tag_namespace, tag_service) (update_throughput)"

      join_on = {
        "$output{DBInstanceIdentifier}" = "$input{DBInstanceIdentifier}"
      }
    }
  }

  gauge "update_latency" {
    index       = 7
    input_unit  = "s"
    output_unit = "s"
    aggregator  = "MAX"
    source prometheus "update_latency" {
      query = "max by (DBInstanceIdentifier, tag_namespace, tag_service) (update_latency)"

      join_on = {
        "$output{DBInstanceIdentifier}" = "$input{DBInstanceIdentifier}"
      }
    }
  }

  gauge "delete_throughput" {
    index       = 8
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "AVG"
    source prometheus "delete_throughput" {
      query = "max by (DBInstanceIdentifier, tag_namespace, tag_service) (delete_throughput)"

      join_on = {
        "$output{DBInstanceIdentifier}" = "$input{DBInstanceIdentifier}"
      }
    }
  }

  gauge "delete_latency" {
    index       = 9
    input_unit  = "s"
    output_unit = "s"
    aggregator  = "MAX"
    source prometheus "delete_latency" {
      query = "max by (DBInstanceIdentifier, tag_namespace, tag_service) (delete_latency)"

      join_on = {
        "$output{DBInstanceIdentifier}" = "$input{DBInstanceIdentifier}"
      }
    }
  }

  gauge "deadlocks" {
    index       = 11
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"
    source prometheus "deadlocks" {
      query = "max by (DBInstanceIdentifier, tag_namespace, tag_service) (deadlocks)"

      join_on = {
        "$output{DBInstanceIdentifier}" = "$input{DBInstanceIdentifier}"
      }
    }
  }
}

ingester aws_aurora_instance_physical_cloudwatch module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  label {
    type = "service"
    name = "$input{tag_service}"
  }

  label {
    type = "namespace"
    name = "$input{tag_namespace}"
  }

  physical_component {
    type = "aurora_instance"
    name = "$input{DBInstanceIdentifier}"
  }

  data_for_graph_node {
    type = "aurora_instance"
    name = "$input{DBInstanceIdentifier}"
  }

  using = {
    default = "$input{using}"
  }

  inputs = "$input{inputs}"

  gauge "network_in" {
    index       = 1
    input_unit  = "bps"
    output_unit = "bps"
    aggregator  = "AVG"
    source prometheus "network_in" {
      query = "max by (DBInstanceIdentifier, tag_namespace, tag_service) (network_in)"

      join_on = {
        "$output{DBInstanceIdentifier}" = "$input{DBInstanceIdentifier}"
      }
    }
  }

  gauge "network_out" {
    index       = 2
    input_unit  = "bps"
    output_unit = "bps"
    aggregator  = "AVG"
    source prometheus "network_out" {
      query = "max by (DBInstanceIdentifier, tag_namespace, tag_service) (network_out)"

      join_on = {
        "$output{DBInstanceIdentifier}" = "$input{DBInstanceIdentifier}"
      }
    }
  }

  gauge "cpu" {
    index       = 3
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "AVG"
    source prometheus "cpu" {
      query = "max by (DBInstanceIdentifier, tag_namespace, tag_service) (cpu)"

      join_on = {
        "$output{DBInstanceIdentifier}" = "$input{DBInstanceIdentifier}"
      }
    }
  }

  gauge "free_space" {
    index       = 4
    input_unit  = "bytes"
    output_unit = "bytes"
    aggregator  = "MIN"
    source prometheus "free_space" {
      query = "max by (DBInstanceIdentifier, tag_namespace, tag_service) (free_space)"

      join_on = {
        "$output{DBInstanceIdentifier}" = "$input{DBInstanceIdentifier}"
      }
    }
  }

  gauge "replica_lag" {
    index       = 5
    input_unit  = "s"
    output_unit = "s"
    aggregator  = "MAX"
    source prometheus "replica_lag" {
      query = "max by (DBInstanceIdentifier, tag_namespace, tag_service) (replica_lag)"

      join_on = {
        "$output{DBInstanceIdentifier}" = "$input{DBInstanceIdentifier}"
      }
    }
  }

  gauge "queue_depth" {
    index       = 6
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"
    source prometheus "queue_depth" {
      query = "max by (DBInstanceIdentifier, tag_namespace, tag_service) (queue_depth)"

      join_on = {
        "$output{DBInstanceIdentifier}" = "$input{DBInstanceIdentifier}"
      }
    }
  }
}
