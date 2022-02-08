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

  gauge "ebs_io_balance" {
    index       = 6
    input_unit  = "percentage"
    output_unit = "percentage"
    aggregator  = "MIN"

    source cloudwatch "ebs_io_balance" {
      query {
        aggregator  = "Minimum"
        namespace   = "AWS/RDS"
        // Add placeholder name for EBSIOBalance% till iox supports %
        metric_name = "EBSIOBalance"

        dimensions = {
          "DBInstanceIdentifier" = "$input{DBInstanceIdentifier}"
        }
      }
    }
  }

  gauge "ebs_byte_balance" {
    index       = 7
    input_unit  = "percentage"
    output_unit = "percentage"
    aggregator  = "MIN"

    source cloudwatch "ebs_byte_balance" {
      query {
        aggregator  = "Minimum"
        namespace   = "AWS/RDS"
        // Add placeholder name for EBSByteBalance% till iox supports %
        metric_name = "EBSByteBalance"

        dimensions = {
          "DBInstanceIdentifier" = "$input{DBInstanceIdentifier}"
        }
      }
    }
  }

  gauge "burst_balance" {
    index       = 14
    input_unit  = "percentage"
    output_unit = "percentage"
    aggregator  = "MIN"

    source cloudwatch "burst_balance" {
      query {
        aggregator  = "Minimum"
        namespace   = "AWS/RDS"
        metric_name = "BurstBalance"

        dimensions = {
          "DBInstanceIdentifier" = "$input{DBInstanceIdentifier}"
        }
      }
    }
  }

  gauge "read_latency" {
    index       = 4
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

  gauge "cpu" {
    index       = 8
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

  gauge "cpu_balance" {
    index       = 13
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MIN"
    source cloudwatch "cpu" {
      query {
        aggregator  = "Minimum"
        namespace   = "AWS/RDS"
        metric_name = "CPUCreditBalance"

        dimensions = {
          "DBInstanceIdentifier" = "$input{DBInstanceIdentifier}"
        }
      }
    }
  }

  gauge "free_space" {
    index       = 9
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
    index       = 11
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
    index       = 12
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


}
