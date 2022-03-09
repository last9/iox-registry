ingester aws_msk_topic_per_broker module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  inputs = "$input{inputs}"

  label {
    type = "service"
    name = "$output{tag_service}"
  }

  label {
    type = "namespace"
    name = "$output{tag_namespace}"
  }

  physical_address {
    type = "aws_msk_broker"
    name = "$input{ClusterName}-$input{BrokerID}"
  }

  physical_component {
    type = "aws_msk_cluster"
    name = "aws_msk_cluster"
  }

  data_for_graph_node {
    type = "aws_msk_topic_per_broker"
    name = "coalesce_on_interpolation(\"$input{Topic} $input{custom_tag}\",\"$input{Topic}\")"
  }

  using = {
    "default" : "$input{using}"
  }

  gauge "bytes_in" {
    index       = 4
    input_unit  = "Bps"
    output_unit = "Bps"
    aggregator  = "SUM"
    source prometheus "data_in" {
      query = "sum by (ClusterName, BrokerID, Topic, tag_service, tag_namespace) (bytes_in)"
      join_on = {
        "$output{ClusterName}" = "$input{ClusterName}"
        "$output{BrokerID}"    = "$input{BrokerID}"
        "$output{Topic}"       = "$input{Topic}"
      }
    }
  }
  gauge "bytes_out" {
    index       = 5
    input_unit  = "Bps"
    output_unit = "Bps"
    aggregator  = "SUM"
    source prometheus "data_out" {
      query = "sum by (ClusterName, BrokerID, Topic, tag_service, tag_namespace) (bytes_out)"
      join_on = {
        "$output{ClusterName}" = "$input{ClusterName}"
        "$output{BrokerID}"    = "$input{BrokerID}"
        "$output{Topic}"       = "$input{Topic}"
      }
    }
  }
  gauge "messages_in" {
    index       = 1
    input_unit  = "tps"
    output_unit = "tps"
    aggregator  = "AVG"
    source prometheus "messages_in" {
      query = "avg by (ClusterName, BrokerID, Topic, tag_service, tag_namespace) (messages_in)"
      join_on = {
        "$output{ClusterName}" = "$input{ClusterName}"
        "$output{BrokerID}"    = "$input{BrokerID}"
        "$output{Topic}"       = "$input{Topic}"
      }
    }
  }
  gauge "fetch_msg_conversions" {
    index       = 3
    input_unit  = "tps"
    output_unit = "tps"
    aggregator  = "AVG"
    source prometheus "fetch_msg_conversions" {
      query = "avg by (ClusterName, BrokerID, Topic, tag_service, tag_namespace) (fetch_msg_conversions)"
      join_on = {
        "$output{ClusterName}" = "$input{ClusterName}"
        "$output{BrokerID}"    = "$input{BrokerID}"
        "$output{Topic}"       = "$input{Topic}"
      }
    }
  }
  gauge "produce_msg_conversions" {
    index       = 2
    input_unit  = "tps"
    output_unit = "tps"
    aggregator  = "AVG"
    source prometheus "produce_msg_conversions" {
      query = "avg by (ClusterName, BrokerID, Topic, tag_service, tag_namespace) (produce_msg_conversions)"
      join_on = {
        "$output{ClusterName}" = "$input{ClusterName}"
        "$output{BrokerID}"    = "$input{BrokerID}"
        "$output{Topic}"       = "$input{Topic}"
      }
    }
  }
}

ingester aws_msk_topic_per_consumer_grp module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  inputs = "$input{inputs}"

  label {
    type = "service"
    name = "$output{tag_service}"
  }

  label {
    type = "namespace"
    name = "$output{tag_namespace}"
  }

  physical_address {
    type = "aws_msk_consumer_grp"
    name = "$input{ConsumerGroup}"
  }

  physical_component {
    type = "aws_msk_consumer"
    name = "Consumers"
  }

  data_for_graph_node {
    type = "aws_msk_topic_per_consumer_grp"
    name = "$input{Topic}"
  }

  using = {
    "default" : "$input{using}"
  }

  gauge "offset_lag" {
    index       = 1
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"

    source prometheus "offset_lag" {
      query = "max by (ConsumerGroup, Topic, tag_service, tag_namespace) (offset_lag)"
      join_on = {
        "$output{ConsumerGroup}" = "$input{ConsumerGroup}"
        "$output{Topic}"         = "$input{Topic}"
      }
    }
  }
}


ingester aws_msk_partition module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  inputs = "$input{inputs}"

  label {
    type = "service"
    name = "$output{tag_service}"
  }

  label {
    type = "namespace"
    name = "$output{tag_namespace}"
  }

  physical_address {
    type = "aws_msk_consumer_grp"
    name = "$input{ConsumerGroup}"
  }

  physical_component {
    type = "aws_msk_consumer"
    name = "Consumers"
  }

  data_for_graph_node {
    type = "aws_msk_partition"
    name = "$input{Topic}-$input{Partition}"
  }

  logical_parent_nodes = [
    {
      type = "aws_msk_topic_per_consumer_grp"
      name = "$input{Topic}"
    }
  ]


  using = {
    "default" : "$input{using}"
  }

  gauge "offset_lag" {
    index       = 1
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"

    source prometheus "offset_lag" {
      query = "max by (ClusterName, ConsumerGroup, Partition, Topic, tag_service, tag_namespace) (offset_lag)"
      join_on = {
        "$output{ClusterName}"   = "$input{ClusterName}"
        "$output{ConsumerGroup}" = "$input{ConsumerGroup}"
        "$output{Partition}"     = "$input{Partition}"
        "$output{Topic}"         = "$input{Topic}"
      }
    }
  }

  gauge "time_lag" {
    index       = 2
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"

    source prometheus "time_lag" {
      query = "max by (ClusterName, ConsumerGroup, Partition, Topic, tag_service, tag_namespace) (time_lag)"
      join_on = {
        "$output{ClusterName}"   = "$input{ClusterName}"
        "$output{ConsumerGroup}" = "$input{ConsumerGroup}"
        "$output{Partition}"     = "$input{Partition}"
        "$output{Topic}"         = "$input{Topic}"
      }
    }
  }
}

ingester aws_msk_cluster module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  inputs = "$input{inputs}"

  label {
    type = "service"
    name = "$output{tag_service}"
  }

  label {
    type = "namespace"
    name = "$output{tag_namespace}"
  }

  physical_component {
    type = "aws_msk_cluster"
    name = "aws_msk_cluster"
  }

  data_for_graph_node {
    type = "aws_msk_cluster"
    name = "$input{ClusterName}"
  }

  using = {
    "default" : "$input{using}"
  }

  gauge "active_controller_count" {
    index       = 1
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"

    source prometheus "active_controller_count" {
      query = "max by (ClusterName, tag_service, tag_namespace) (active_controller_count)"
      join_on = {
        "$output{ClusterName}" = "$input{ClusterName}"
      }
    }
  }

  gauge "offline_partition_count" {
    index       = 2
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"

    source prometheus "offline_partition_count" {
      query = "max by (ClusterName, tag_service, tag_namespace) (offline_partition_count)"
      join_on = {
        "$output{ClusterName}" = "$input{ClusterName}"
      }
    }
  }
}

ingester aws_msk_broker module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  inputs = "$input{inputs}"

  label {
    type = "service"
    name = "$output{tag_service}"
  }

  label {
    type = "namespace"
    name = "$output{tag_namespace}"
  }

  physical_address {
    type = "aws_msk_broker"
    name = "$input{ClusterName}-$input{BrokerID}"
  }

  physical_component {
    type = "aws_msk_cluster"
    name = "aws_msk_cluster"
  }

  data_for_graph_node {
    type = "aws_msk_broker"
    name = "$input{ClusterName}-$input{BrokerID}"
  }

  using = {
    "default" : "$input{using}"
  }

  gauge "mem_free" {
    index       = 12
    input_unit  = "bytes"
    output_unit = "bytes"
    aggregator  = "MIN"
    source prometheus "mem_free" {
      query = "min by (ClusterName, BrokerID, tag_service, tag_namespace) (mem_free)"
      join_on = {
        "$output{ClusterName}" = "$input{ClusterName}"
        "$output{BrokerID}"    = "$input{BrokerID}"
      }
    }
  }

  gauge "messages_in" {
    index       = 1
    input_unit  = "tps"
    output_unit = "tps"
    aggregator  = "AVG"
    source prometheus "messages_in" {
      query = "avg by (ClusterName, BrokerID, tag_service, tag_namespace) (messages_in)"
      join_on = {
        "$output{ClusterName}" = "$input{ClusterName}"
        "$output{BrokerID}"    = "$input{BrokerID}"
      }
    }
  }

  gauge "partition_count" {
    index       = 8
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MIN"
    source prometheus "partition_count" {
      query = "min by (ClusterName, BrokerID, tag_service, tag_namespace) (partition_count)"
      join_on = {
        "$output{ClusterName}" = "$input{ClusterName}"
        "$output{BrokerID}"    = "$input{BrokerID}"
      }
    }
  }

  gauge "produce_time_ms_mean" {
    index       = 2
    input_unit  = "ms"
    output_unit = "ms"
    aggregator  = "AVG"
    source prometheus "produce_time_ms_mean" {
      query = "avg by (ClusterName, BrokerID, tag_service, tag_namespace) (produce_time_ms_mean)"
      join_on = {
        "$output{ClusterName}" = "$input{ClusterName}"
        "$output{BrokerID}"    = "$input{BrokerID}"
      }
    }
  }

  gauge "request_bytes_mean" {
    index       = 7
    input_unit  = "Bps"
    output_unit = "Bps"
    aggregator  = "SUM"
    source prometheus "request_bytes_mean" {
      query = "sum by (ClusterName, BrokerID, tag_service, tag_namespace) (request_bytes_mean)"
      join_on = {
        "$output{ClusterName}" = "$input{ClusterName}"
        "$output{BrokerID}"    = "$input{BrokerID}"
      }
    }
  }

  gauge "request_time" {
    index       = 6
    input_unit  = "ms"
    output_unit = "ms"
    aggregator  = "AVG"
    source prometheus "request_time" {
      query = "avg by (ClusterName, BrokerID, tag_service, tag_namespace) (request_time)"
      join_on = {
        "$output{ClusterName}" = "$input{ClusterName}"
        "$output{BrokerID}"    = "$input{BrokerID}"
      }
    }
  }

  gauge "produce_msg_conversions" {
    index       = 4
    input_unit  = "tps"
    output_unit = "tps"
    aggregator  = "AVG"
    source prometheus "produce_msg_conversions" {
      query = "avg by (ClusterName, BrokerID, tag_service, tag_namespace) (produce_msg_conversions)"
      join_on = {
        "$output{ClusterName}" = "$input{ClusterName}"
        "$output{BrokerID}"    = "$input{BrokerID}"
      }
    }
  }

  gauge "fetch_msg_conversions" {
    index       = 5
    input_unit  = "count"
    output_unit = "tps"
    aggregator  = "AVG"
    source prometheus "fetch_msg_conversions" {
      query = "avg by (ClusterName, BrokerID, tag_service, tag_namespace) (fetch_msg_conversions)"
      join_on = {
        "$output{ClusterName}" = "$input{ClusterName}"
        "$output{BrokerID}"    = "$input{BrokerID}"
      }
    }
  }

  gauge "fetch_time_ms_mean" {
    index       = 3
    input_unit  = "ms"
    output_unit = "ms"
    aggregator  = "AVG"
    source prometheus "fetch_time_ms_mean" {
      query = "avg by (ClusterName, BrokerID, tag_service, tag_namespace) (fetch_time_ms_mean)"
      join_on = {
        "$output{ClusterName}" = "$input{ClusterName}"
        "$output{BrokerID}"    = "$input{BrokerID}"
      }
    }
  }

  gauge "root_disk_used" {
    index       = 11
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "MAX"
    source prometheus "root_disk_used" {
      query = "max by (ClusterName, BrokerID, tag_service, tag_namespace) (root_disk_used)"
      join_on = {
        "$output{ClusterName}" = "$input{ClusterName}"
        "$output{BrokerID}"    = "$input{BrokerID}"
      }
    }
  }
}
