ingester aws_aurora_cloudwatch module {
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
    source cloudwatch "connections" {
      query {
        aggregator  = "Maximum"
        namespace   = "AWS/RDS"
        metric_name = "DatabaseConnections"

        dimensions = {
          "DBInstanceIdentifier" = "$input{DBInstanceIdentifier}"
        }
      }
    }
  }

  gauge "read_throughput" {
    index       = 2
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "AVG"
    source cloudwatch "read_throughput" {
      query {
        aggregator  = "Average"
        namespace   = "AWS/RDS"
        metric_name = "ReadThroughput"

        dimensions = {
          "DBInstanceIdentifier" = "$input{DBInstanceIdentifier}"
        }
      }
    }
  }


  gauge "read_latency" {
    index       = 3
    input_unit  = "s"
    output_unit = "s"
    aggregator  = "MAX"
    source cloudwatch "read_latency" {
      query {
        aggregator  = "Average"
        namespace   = "AWS/RDS"
        metric_name = "ReadLatency"

        dimensions = {
          "DBInstanceIdentifier" = "$input{DBInstanceIdentifier}"
        }
      }
    }
  }

  gauge "write_throughput" {
    index       = 4
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "AVG"
    source cloudwatch "write_throughput" {
      query {
        aggregator  = "Average"
        namespace   = "AWS/RDS"
        metric_name = "WriteThroughput"

        dimensions = {
          "DBInstanceIdentifier" = "$input{DBInstanceIdentifier}"
        }
      }
    }
  }

  gauge "write_latency" {
    index       = 5
    input_unit  = "s"
    output_unit = "s"
    aggregator  = "MAX"
    source cloudwatch "write_latency" {
      query {
        aggregator  = "Average"
        namespace   = "AWS/RDS"
        metric_name = "WriteLatency"

        dimensions = {
          "DBInstanceIdentifier" = "$input{DBInstanceIdentifier}"
        }
      }
    }
  }

  gauge "update_throughput" {
    index       = 6
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "AVG"
    source cloudwatch "update_throughput" {
      query {
        aggregator  = "Average"
        namespace   = "AWS/RDS"
        metric_name = "UpdateThroughput"

        dimensions = {
          "DBInstanceIdentifier" = "$input{DBInstanceIdentifier}"
        }
      }
    }
  }

  gauge "update_latency" {
    index       = 7
    input_unit  = "s"
    output_unit = "s"
    aggregator  = "MAX"
    source cloudwatch "update_latency" {
      query {
        aggregator  = "Average"
        namespace   = "AWS/RDS"
        metric_name = "UpdateLatency"

        dimensions = {
          "DBInstanceIdentifier" = "$input{DBInstanceIdentifier}"
        }
      }
    }
  }

  gauge "delete_throughput" {
    index       = 8
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "AVG"
    source cloudwatch "delete_throughput" {
      query {
        aggregator  = "Average"
        namespace   = "AWS/RDS"
        metric_name = "DeleteThroughput"

        dimensions = {
          "DBInstanceIdentifier" = "$input{DBInstanceIdentifier}"
        }
      }
    }
  }

  gauge "delete_latency" {
    index       = 9
    input_unit  = "s"
    output_unit = "s"
    aggregator  = "MAX"
    source cloudwatch "delete_latency" {
      query {
        aggregator  = "Average"
        namespace   = "AWS/RDS"
        metric_name = "DeleteLatency"

        dimensions = {
          "DBInstanceIdentifier" = "$input{DBInstanceIdentifier}"
        }
      }
    }
  }

  gauge "deadlocks" {
    index       = 11
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"
    source cloudwatch "deadlocks" {
      query {
        aggregator  = "Maximum"
        namespace   = "AWS/RDS"
        metric_name = "Deadlocks"

        dimensions = {
          "DBInstanceIdentifier" = "$input{DBInstanceIdentifier}"
        }
      }
    }
  }

  gauge "network_in" {
    index       = 12
    input_unit  = "bps"
    output_unit = "bps"
    aggregator  = "AVG"
    source cloudwatch "network_in" {
      query {
        aggregator  = "Average"
        namespace   = "AWS/RDS"
        metric_name = "NetworkReceiveThroughput"

        dimensions = {
          "DBInstanceIdentifier" = "$input{DBInstanceIdentifier}"
        }
      }
    }
  }

  gauge "network_out" {
    index       = 13
    input_unit  = "bps"
    output_unit = "bps"
    aggregator  = "AVG"
    source cloudwatch "network_out" {
      query {
        aggregator  = "Average"
        namespace   = "AWS/RDS"
        metric_name = "NetworkTransmitThroughput"

        dimensions = {
          "DBInstanceIdentifier" = "$input{DBInstanceIdentifier}"
        }
      }
    }
  }

  gauge "cpu" {
    index       = 14
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "AVG"
    source cloudwatch "cpu" {
      query {
        aggregator  = "Average"
        namespace   = "AWS/RDS"
        metric_name = "CPUUtilization"

        dimensions = {
          "DBInstanceIdentifier" = "$input{DBInstanceIdentifier}"
        }
      }
    }
  }

  gauge "free_space" {
    index       = 15
    input_unit  = "bytes"
    output_unit = "bytes"
    aggregator  = "MIN"
    source cloudwatch "free_space" {
      query {
        aggregator  = "Minimum"
        namespace   = "AWS/RDS"
        metric_name = "FreeLocalStorage"

        dimensions = {
          "DBInstanceIdentifier" = "$input{DBInstanceIdentifier}"
        }
      }
    }
  }

  gauge "replica_lag" {
    index       = 16
    input_unit  = "s"
    output_unit = "s"
    aggregator  = "MAX"
    source cloudwatch "replica_lag" {
      query {
        aggregator  = "Maximum"
        namespace   = "AWS/RDS"
        metric_name = "AuroraReplicaLag"

        dimensions = {
          "DBInstanceIdentifier" = "$input{DBInstanceIdentifier}"
        }
      }
    }
  }

  gauge "queue_depth" {
    index       = 17
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"
    source cloudwatch "queue_depth" {
      query {
        aggregator  = "Maximum"
        namespace   = "AWS/RDS"
        metric_name = "DiskQueueDepth"

        dimensions = {
          "DBInstanceIdentifier" = "$input{DBInstanceIdentifier}"
        }
      }
    }
  }
}
