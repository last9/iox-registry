ingester prometheus_remote_write module {
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
    type = "prometheus_remote_write_cluster"
    name = "$input{pod}"
  }

  data_for_graph_node {
    type = "prometheus_remote_write_pod"
    name = "$input{pod}-pod"
  }

  inputs = "$input{inputs}"

  using = {
    default = "victoriametrics"
  }

  gauge "pending" {
    unit = "count"

    source prometheus "pending" {
      query = "label_set(sum by (pod) (prometheus_remote_storage_samples_pending{}), 'pod', '$input{pod}')"
      join_on = {
        "$output{pod}" = "$input{pod}"
      }
    }
  }

  gauge "retried" {
    unit = "count"

    source prometheus "retried" {
      query = "label_set(max by (pod) (rate(prometheus_remote_storage_samples_retried_total{}[1m])), 'pod', '$input{pod}')"
      join_on = {
        "$output{pod}" = "$input{pod}"
      }
    }
  }

  gauge "failed" {
    unit = "count"

    source prometheus "failed" {
      query = "label_set(max by (pod) (rate(prometheus_remote_storage_samples_failed_total{}[1m])), 'pod', '$input{pod}')"
      join_on = {
        "$output{pod}" = "$input{pod}"
      }
    }
  }

  gauge "dropped" {
    unit = "count"

    source prometheus "failed" {
      query = "label_set(max by (pod) (rate(prometheus_remote_storage_samples_dropped_total{}[1m])), 'pod', '$input{pod}')"
      join_on = {
        "$output{pod}" = "$input{pod}"
      }
    }
  }

  gauge "processed_percent" {
    unit = "percent"

    source prometheus "processed_percent" {
      query = "label_set((1 - (sum by (pod) (prometheus_remote_storage_samples_pending{}) / max by (pod) (rate(prometheus_remote_storage_samples_in_total{}[1m])*60))) * 100, 'pod', '$input{pod}')"
      join_on = {
        "$output{pod}" = "$input{pod}"
      }
    }
  }

  gauge "bytes_sent" {
    unit = "bytes"

    source prometheus "bytes_sent" {
      query = "label_set(sum by (pod) (rate(prometheus_remote_storage_samples_bytes_total{}[1m])*60 or rate(prometheus_remote_storage_bytes_total{}[1m])*60) + sum by (pod) (rate(prometheus_remote_storage_metadata_bytes_total{}[1m])*60), 'pod', '$input{pod}')"
      join_on = {
        "$output{pod}" = "$input{pod}"
      }
    }
  }

  gauge "wal_lag" {
    unit = "count"

    source prometheus "wal_lag" {
      query = "label_set((max by (pod) (max_over_time(prometheus_tsdb_wal_segment_current{}[1m]))) - (max by (pod) (max_over_time(prometheus_wal_watcher_current_segment{}[1m]))), 'pod', '$input{pod}')"
      join_on = {
        "$output{pod}" = "$input{pod}"
      }
    }
  }


  gauge "timestamp_lag" {
    unit = "seconds"

    source prometheus "timestamp_lag" {
      query = "label_set(max_over_time(prometheus_remote_storage_highest_timestamp_in_seconds{}[1m]) - ignoring(remote_name, url) group_right max_over_time(prometheus_remote_storage_queue_highest_sent_timestamp_seconds{}[1m]), 'pod', '$input{pod}')"
      join_on = {
        "$output{pod}" = "$input{pod}"
      }
    }
  }

  gauge "available_shards" {
    unit = "count"

    source prometheus "available_shards" {
      query = "label_set(max by (pod) (max_over_time(prometheus_remote_storage_shards_max{}[1m])) - max by (pod) (max_over_time(prometheus_remote_storage_shards_desired{}[1m])), , 'pod', '$input{pod}')"
      join_on = {
        "$output{pod}" = "$input{pod}"
      }
    }
  }
}
