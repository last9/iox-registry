// test commit
ingester aws_rds_logical_cloudwatch module {
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

  input_query = <<-EOF
  label_set(
    label_replace(
      rds_db{$input{tag_filter}}, 'id=DBInstanceIdentifier'
    ), "Service", "$input{service}"
  )
  EOF

  gauge "connections" {
    unit       = "count"
    aggregator = "MAX"
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
    unit       = "iops"
    aggregator = "AVG"
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
    unit       = "iops"
    aggregator = "AVG"
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
    unit       = "s"
    aggregator = "AVG"
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
    unit       = "s"
    aggregator = "AVG"
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

ingester aws_rds_physical_cloudwatch module {
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

  input_query = <<-EOF
  label_set(
    label_replace(
      rds_db{$input{tag_filter}}, 'id=DBInstanceIdentifier'
    ), "Service", "$input{service}"
  )
  EOF

  gauge "network_in" {
    unit       = "bps"
    aggregator = "AVG"
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
    unit       = "bps"
    aggregator = "AVG"
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
    unit       = "percent"
    aggregator = "AVG"
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
    unit       = "bytes"
    aggregator = "MIN"
    source cloudwatch "free_space" {
      query {
        aggregator  = "Minimum"
        namespace   = "AWS/RDS"
        metric_name = "FreeStorageSpace"

        dimensions = {
          "DBInstanceIdentifier" = "$input{DBInstanceIdentifier}"
        }
      }
    }
  }

  gauge "replica_lag" {
    unit       = "s"
    aggregator = "MAX"
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
    unit       = "count"
    aggregator = "MAX"
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
