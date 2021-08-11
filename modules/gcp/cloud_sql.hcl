ingester gcp_cloud_sql_logical module {
  lookback   = 600
  frequency  = 60
  timeout    = 30
  resolution = 60
  lag        = 0

  physical_component {
    type = "gcp_cloud_sql"
    name = "$input{id}"
  }

  data_for_graph_node {
    type = "gcp_cloud_sql"
    name = "$input{id}"
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
        "$output{database_id}" = "$input{id}"
      }
    }
  }

  gauge "write_ops_count" {
    unit       = "iops"
    aggregator = "AVG"

    source stackdriver "write_ops_count" {
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
        "$output{database_id}" = "$input{id}"
      }
    }
  }

  gauge "read_ops_count" {
    unit       = "iops"
    aggregator = "AVG"

    source stackdriver "read_ops_count" {
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
        "$output{database_id}" = "$input{id}"
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
    type = "gcp_cloud_sql"
    name = "$input{id}"
  }

  data_for_graph_node {
    type = "gcp_cloud_sql"
    name = "$input{id}"
  }

  using = {
    "default" : "$input{using}"
  }

  inputs = "$input{inputs}"

  gauge "cpu_utilization" {
    unit       = "percent"
    aggregator = "AVG"

    source stackdriver "cpu" {
      query {
        resource {}
        aggregation {
          per_series_aligner   = ""
          cross_series_reducer = ""
          group_by_fields      = []
        }
        metric {
          type = "cloudsql.googleapis.com/database/cpu/utilization"
        }
      }
      join_on = {
        "$output{database_id}" = "$input{id}"
      }
    }
  }

  gauge "bytes_received" {
    unit       = "percent"
    aggregator = "AVG"

    source stackdriver "bytes_received" {
      query {
        resource {}
        aggregation {
          per_series_aligner   = ""
          cross_series_reducer = ""
          group_by_fields      = []
        }
        metric {
          type = "cloudsql.googleapis.com/database/mysql/received_bytes_count"
        }
      }
      join_on = {
        "$output{database_id}" = "$input{id}"
      }
    }
  }

  gauge "bytes_sent" {
    unit       = "percent"
    aggregator = "AVG"

    source stackdriver "bytes_sent" {
      query {
        resource {}
        aggregation {
          per_series_aligner   = ""
          cross_series_reducer = ""
          group_by_fields      = []
        }
        metric {
          type = "cloudsql.googleapis.com/database/mysql/sent_bytes_count"
        }
      }
      join_on = {
        "$output{database_id}" = "$input{id}"
      }
    }
  }

  gauge "replica_lag" {
    unit       = "percent"
    aggregator = "AVG"

    source stackdriver "replica_lag" {
      query {
        resource {}
        aggregation {
          per_series_aligner   = ""
          cross_series_reducer = ""
          group_by_fields      = []
        }
        metric {
          type = "cloudsql.googleapis.com/database/replication/replica_lag"
        }
      }
      join_on = {
        "$output{database_id}" = "$input{id}"
      }
    }
  }
}
