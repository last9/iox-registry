ingester aws_rds_logical_cloudstream module {
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

  gauge "connections" {
    index       = 1
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"

    source prometheus "connections" {
      query = "sum by (DBInstanceIdentifier) (amazonaws_com_AWS_RDS_DatabaseConnections{DBInstanceIdentifier=~'$input{DBInstanceIdentifier}', quantile='1'})"
      join_on = {
        "$output{DBInstanceIdentifier}" = "$input{DBInstanceIdentifier}"
      }
    }
  }

  gauge "ebs_io_balance" {
    index       = 6
    input_unit  = "percentage"
    output_unit = "percentage"
    aggregator  = "MIN"

    source prometheus "ebs_io_balance" {
      query = "sum by (DBInstanceIdentifier) (amazonaws_com_AWS_RDS_EBSIOBalance_{DBInstanceIdentifier=~'$input{DBInstanceIdentifier}', quantile='0'})"
      join_on = {
        "$output{DBInstanceIdentifier}" = "$input{DBInstanceIdentifier}"
      }
    }
  }

  gauge "ebs_byte_balance" {
    index       = 7
    input_unit  = "percentage"
    output_unit = "percentage"
    aggregator  = "MIN"

    source prometheus "ebs_byte_balance" {
      query = "sum by (DBInstanceIdentifier) (amazonaws_com_AWS_RDS_EBSByteBalance_{DBInstanceIdentifier=~'$input{DBInstanceIdentifier}', quantile='0'})"
      join_on = {
        "$output{DBInstanceIdentifier}" = "$input{DBInstanceIdentifier}"
      }
    }
  }

  gauge "burst_balance" {
    index       = 14
    input_unit  = "percentage"
    output_unit = "percentage"
    aggregator  = "MIN"

    source prometheus "burst_balance" {
      query = "sum by (DBInstanceIdentifier) (amazonaws_com_AWS_RDS_BurstBalance{DBInstanceIdentifier=~'$input{DBInstanceIdentifier}', quantile='0'})"
      join_on = {
        "$output{DBInstanceIdentifier}" = "$input{DBInstanceIdentifier}"
      }
    }
  }

  gauge "read_latency" {
    index       = 4
    input_unit  = "s"
    output_unit = "s"
    aggregator  = "AVG"

    source prometheus "read_latency" {
      query = "sum by (DBInstanceIdentifier) (amazonaws_com_AWS_RDS_ReadLatency_sum{DBInstanceIdentifier=~'$input{DBInstanceIdentifier}'}) / sum by (DBInstanceIdentifier)  (amazonaws_com_AWS_RDS_ReadLatency_count{DBInstanceIdentifier=~'$input{DBInstanceIdentifier}'})"
      join_on = {
        "$output{DBInstanceIdentifier}" = "$input{DBInstanceIdentifier}"
      }
    }
  }

  gauge "write_latency" {
    index       = 5
    input_unit  = "s"
    output_unit = "s"
    aggregator  = "AVG"

    source prometheus "write_latency" {
      query = "sum by (DBInstanceIdentifier)  (amazonaws_com_AWS_RDS_WriteLatency_sum{DBInstanceIdentifier=~'$input{DBInstanceIdentifier}'}) / sum by (DBInstanceIdentifier)  (amazonaws_com_AWS_RDS_WriteLatency_count{DBInstanceIdentifier=~'$input{DBInstanceIdentifier}'})"
      join_on = {
        "$output{DBInstanceIdentifier}" = "$input{DBInstanceIdentifier}"
      }
    }
  }

  gauge "cpu" {
    index       = 8
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "AVG"

    source prometheus "cpu" {
      query = "sum by (DBInstanceIdentifier) (amazonaws_com_AWS_RDS_CPUUtilization_sum{DBInstanceIdentifier=~'$input{DBInstanceIdentifier}'}) / sum by (DBInstanceIdentifier) (amazonaws_com_AWS_RDS_CPUUtilization_count{DBInstanceIdentifier=~'$input{DBInstanceIdentifier}'})"
      join_on = {
        "$output{DBInstanceIdentifier}" = "$input{DBInstanceIdentifier}"
      }
    }
  }

  gauge "cpu_balance" {
    index       = 13
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MIN"

    source prometheus "cpu_balance" {
      query = "sum by (DBInstanceIdentifier) (amazonaws_com_AWS_RDS_CPUCreditBalance{DBInstanceIdentifier=~'$input{DBInstanceIdentifier}', quantile='0'})"
      join_on = {
        "$output{DBInstanceIdentifier}" = "$input{DBInstanceIdentifier}"
      }
    }
  }

  gauge "free_space" {
    index       = 9
    input_unit  = "bytes"
    output_unit = "bytes"
    aggregator  = "MIN"

    source prometheus "free_space" {
      query = "sum by (DBInstanceIdentifier) (amazonaws_com_AWS_RDS_FreeStorageSpace{DBInstanceIdentifier=~'$input{DBInstanceIdentifier}', quantile='0'})"
      join_on = {
        "$output{DBInstanceIdentifier}" = "$input{DBInstanceIdentifier}"
      }
    }
  }

  gauge "replica_lag" {
    index       = 11
    input_unit  = "s"
    output_unit = "s"
    aggregator  = "MAX"

    source prometheus "replica_lag" {
      query = "sum by (DBInstanceIdentifier) (amazonaws_com_AWS_RDS_ReplicaLag{DBInstanceIdentifier=~'$input{DBInstanceIdentifier}', quantile='1'})"
      join_on = {
        "$output{DBInstanceIdentifier}" = "$input{DBInstanceIdentifier}"
      }
    }
  }

  gauge "queue_depth" {
    index       = 12
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"

    source prometheus "replica_lag" {
      query = "sum by (DBInstanceIdentifier) (amazonaws_com_AWS_RDS_DiskQueueDepth{DBInstanceIdentifier=~'$input{DBInstanceIdentifier}', quantile='1'})"
      join_on = {
        "$output{DBInstanceIdentifier}" = "$input{DBInstanceIdentifier}"
      }
    }
  }
}

ingester aws_rds_physical_cloudstream module {
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

  gauge "network_in" {
    index       = 1
    input_unit  = "bps"
    output_unit = "bps"
    aggregator  = "AVG"

    source prometheus "network_in" {
      query = "sum by (DBInstanceIdentifier) (amazonaws_com_AWS_RDS_NetworkReceiveThroughput_sum{DBInstanceIdentifier=~'$input{DBInstanceIdentifier}'}) / sum by (DBInstanceIdentifier) (amazonaws_com_AWS_RDS_NetworkReceiveThroughput_count{DBInstanceIdentifier=~'$input{DBInstanceIdentifier}'})"
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
      query = "sum by (DBInstanceIdentifier) (amazonaws_com_AWS_RDS_NetworkTransmitThroughput_sum{DBInstanceIdentifier=~'$input{DBInstanceIdentifier}'}) / sum by (DBInstanceIdentifier) (amazonaws_com_AWS_RDS_NetworkTransmitThroughput_count{DBInstanceIdentifier=~'$input{DBInstanceIdentifier}'})"
      join_on = {
        "$output{DBInstanceIdentifier}" = "$input{DBInstanceIdentifier}"
      }
    }
  }
}
