ingester gcp_cloudsql_logical module {
  lookback   = 600
  frequency  = 60
  timeout    = 30
  resolution = 60
  lag        = 0

  label {
    type = "service"
    name = "$input{service}"
  }

  physical_component {
    type = "cloudsql_cluster"
    name = "$input{database_id}"
  }

  data_for_graph_node {
    type = "cloudsql_database"
    name = "$input{database_id}-db"
  }

  using = {
    "default" : "$input{using}"
  }

  inputs = "$input{inputs}"

  gauge "connections" {
    index       = 1
    gap_fill    = "zero_fill"
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"

    source stackdriver "connections" {
      query {
        resource {}
        aggregation {
          per_series_aligner   = ""
          cross_series_reducer = ""
          group_by_fields      = []
        }
        metric {
          type = "cloudsql.googleapis.com/database/network/connections"
        }
      }
      join_on = {
        "$output{database_id}" = "$input{database_id}"
      }
    }
  }

  gauge "write_iops" {
    index       = 2
    gap_fill    = "zero_fill"
    input_unit  = "iops"
    output_unit = "iops"
    aggregator  = "AVG"

    source stackdriver "write_iops" {
      query {
        resource {}
        aggregation {
          per_series_aligner   = ""
          cross_series_reducer = ""
          group_by_fields      = []
        }
        metric {
          type = "cloudsql.googleapis.com/database/disk/write_ops_count"
        }
      }
      join_on = {
        "$output{database_id}" = "$input{database_id}"
      }
    }
  }

  gauge "read_iops" {
    index       = 3
    gap_fill    = "zero_fill"
    input_unit  = "iops"
    output_unit = "iops"
    aggregator  = "AVG"

    source stackdriver "read_iops" {
      query {
        resource {}
        aggregation {
          per_series_aligner   = ""
          cross_series_reducer = ""
          group_by_fields      = []
        }
        metric {
          type = "cloudsql.googleapis.com/database/disk/read_ops_count"
        }
      }
      join_on = {
        "$output{database_id}" = "$input{database_id}"
      }
    }
  }
}

ingester gcp_cloudsql_physical module {
  lookback   = 600
  frequency  = 60
  timeout    = 30
  resolution = 60
  lag        = 0

  label {
    type = "service"
    name = "$input{service}"
  }

  physical_component {
    type = "cloudsql_cluster"
    name = "$input{database_id}"
  }

  data_for_graph_node {
    type = "cloudsql_cluster"
    name = "$input{database_id}"
  }

  using = {
    "default" : "$input{using}"
  }

  inputs = "$input{inputs}"

  gauge "cpu" {
    index       = 3
    gap_fill    = "zero_fill"
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "AVG"

    source stackdriver "cpu" {
      query {
        resource {}
        aggregation {}
        metric {
          type = "cloudsql.googleapis.com/database/cpu/utilization"
        }
      }
      join_on = {
        "$output{database_id}" = "$input{database_id}"
      }
    }
  }

  gauge "network_in" {
    index       = 1
    gap_fill    = "zero_fill"
    input_unit  = "bps"
    output_unit = "bps"
    aggregator  = "AVG"

    source stackdriver "network_in" {
      query {
        resource {}
        aggregation {}
        metric {
          type = "cloudsql.googleapis.com/database/network/received_bytes_count"
        }
      }
      join_on = {
        "$output{database_id}" = "$input{database_id}"
      }
    }
  }

  gauge "network_out" {
    index       = 2
    gap_fill    = "zero_fill"
    input_unit  = "bps"
    output_unit = "bps"
    aggregator  = "AVG"

    source stackdriver "network_out" {
      query {
        resource {}
        aggregation {}
        metric {
          type = "cloudsql.googleapis.com/database/network/sent_bytes_count"
        }
      }
      join_on = {
        "$output{database_id}" = "$input{database_id}"
      }
    }
  }

  gauge "replica_lag" {
    index       = 5
    gap_fill    = "zero_fill"
    input_unit  = "s"
    output_unit = "s"
    aggregator  = "AVG"

    source stackdriver "replica_lag" {
      query {
        resource {}
        aggregation {}
        metric {
          type = "cloudsql.googleapis.com/database/replication/replica_lag"
        }
      }
      join_on = {
        "$output{database_id}" = "$input{database_id}"
      }
    }
  }

  # gauge "memory_utilization" {
  #   index = 1
  #   gap_fill = "zero_fill"
  #   input_unit       = "percent"
  #   output_unit       = "percent"
  #   aggregator = "AVG"
  #
  #   source stackdriver "memory_utilization" {
  #     query {
  #       resource {}
  #       aggregation {
  #         per_series_aligner   = ""
  #         cross_series_reducer = ""
  #         group_by_fields      = []
  #       }
  #       metric {
  #         type = "cloudsql.googleapis.com/database/memory/utilization"
  #       }
  #     }
  #     join_on = {
  #       "$output{database_id}" = "$input{database_id}"
  #     }
  #   }
  # }
  #
  # gauge "disk_utilization" {
  #   index = 1
  #   gap_fill = "zero_fill"
  #   input_unit       = "percent"
  #   output_unit       = "percent"
  #   aggregator = "AVG"
  #
  #   source stackdriver "disk_utilization" {
  #     query {
  #       resource {}
  #       aggregation {
  #         per_series_aligner   = ""
  #         cross_series_reducer = ""
  #         group_by_fields      = []
  #       }
  #       metric {
  #         type = "cloudsql.googleapis.com/database/disk/utilization"
  #       }
  #     }
  #     join_on = {
  #       "$output{database_id}" = "$input{database_id}"
  #     }
  #   }
  # }
}
