ingester aws_rds_logical module {
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
    type = "rds"
    name = "$input{DBInstanceIdentifier}"
  }

  data_for_graph_node {
    type = "rds_database"
    name = "$input{DBInstanceIdentifier}-db"
  }

  using = {
    default = "$input{using}"
  }

  inputs = "$input{inputs}"

  gauge "connections" {
    unit = "count"

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

  gauge "write_iops" {
    unit = "iops"

    source cloudwatch "write_iops" {
      query {
        aggregator  = "Average"
        namespace   = "AWS/RDS"
        metric_name = "WriteIOPS"

        dimensions = {
          "DBInstanceIdentifier" = "$input{DBInstanceIdentifier}"
        }
      }
    }
  }

  gauge "read_iops" {
    unit = "iops"

    source cloudwatch "read_iops" {
      query {
        aggregator  = "Average"
        namespace   = "AWS/RDS"
        metric_name = "ReadIOPS"

        dimensions = {
          "DBInstanceIdentifier" = "$input{DBInstanceIdentifier}"
        }
      }
    }
  }

  gauge "read_latency" {
    unit = "s"

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

  gauge "write_latency" {
    unit = "s"

    source cloudwatch "wrtie_latency" {
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
}

ingester aws_rds_physical module {
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
    type = "rds"
    name = "$input{DBInstanceIdentifier}"
  }

  data_for_graph_node {
    type = "rds"
    name = "$input{DBInstanceIdentifier}"
  }

  using = {
    default = "$input{using}"
  }

  inputs = "$input{inputs}"

  gauge "network_in" {
    unit = "bps"

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
    unit = "bps"

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
    unit = "percentage"

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
    unit = "bytes"

    source cloudwatch "free_space" {
      query {
        aggregator  = "Minimum"
        namespace   = "AWS/RDS"
        metric_name = "WriteIOPS"

        dimensions = {
          "DBInstanceIdentifier" = "$input{DBInstanceIdentifier}"
        }
      }
    }
  }

  gauge "replica_lag" {
    unit = "s"

    source cloudwatch "replica_lag" {
      query {
        aggregator  = "Maximum"
        namespace   = "AWS/RDS"
        metric_name = "ReplicaLag"

        dimensions = {
          "DBInstanceIdentifier" = "$input{DBInstanceIdentifier}"
        }
      }
    }
  }

  gauge "queue_depth" {
    unit = "count"

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
