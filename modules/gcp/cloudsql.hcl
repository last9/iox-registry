ingester gcp_cloud_sql_logical module {
  lookback   = 600
  frequency  = 60
  timeout    = 30
  resolution = 60
  lag        = 0

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
    unit       = "count"
    aggregator = "MAX"

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
    unit       = "iops"
    aggregator = "AVG"

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
    unit       = "iops"
    aggregator = "AVG"

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

ingester gcp_cloud_sql module {
  lookback   = 600
  frequency  = 60
  timeout    = 30
  resolution = 60
  lag        = 0

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
    unit       = "percent"
    aggregator = "AVG"

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
    unit       = "bps"
    aggregator = "AVG"

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
    unit       = "bps"
    aggregator = "AVG"

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
    unit       = "s"
    aggregator = "AVG"

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
  #   unit       = "percent"
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
  #   unit       = "percent"
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
