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
    index       = 1
    gap_fill    = "zero_fill"
    input_unit  = "count"
    output_unit = "count"
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

  gauge "write_iops" {
    index       = 2
    gap_fill    = "zero_fill"
    input_unit  = "iops"
    output_unit = "iops"
    aggregator  = "AVG"
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
    index       = 3
    gap_fill    = "zero_fill"
    input_unit  = "iops"
    output_unit = "iops"
    aggregator  = "AVG"
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
    index       = 4
    gap_fill    = "zero_fill"
    input_unit  = "s"
    output_unit = "s"
    aggregator  = "AVG"
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
    index       = 5
    gap_fill    = "zero_fill"
    input_unit  = "s"
    output_unit = "s"
    aggregator  = "AVG"
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
    index       = 1
    gap_fill    = "zero_fill"
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
    index       = 2
    gap_fill    = "zero_fill"
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
    index       = 3
    gap_fill    = "zero_fill"
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
    index       = 4
    gap_fill    = "zero_fill"
    input_unit  = "bytes"
    output_unit = "bytes"
    aggregator  = "MIN"
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
    index       = 5
    gap_fill    = "zero_fill"
    input_unit  = "s"
    output_unit = "s"
    aggregator  = "MAX"
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
    index       = 6
    gap_fill    = "zero_fill"
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
