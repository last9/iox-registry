// NOTE: When using tag based search in the MSK modules, the ClusterName extracted from the ARN (resource_id) has some unwanted prefix
// So, where ever the cluster name is required, remember to trim the suffix. This is the actual format of the
// kafka resource_id: "cluster_name/suffix" (split by '/' and use the first part)

ingester aws_msk_topic_per_broker_cloudwatch module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  inputs = "$input{inputs}"

  input_query = <<-EOF
  label_set(
    label_replace(
      kafka_cluster{$input{tag_filter}}, 'id=ClusterName'
    ), "service", "$input{service}", "namespace", "$input{namespace}"
  )
  EOF

  label {
    type = "service"
    name = "$input{service}"
  }

  label {
    type = "namespace"
    name = "$input{namespace}"
  }

  physical_address {
    type = "aws_msk_broker"
    name = <<-EOF
      format("%s-$input{BrokerID}", split("/", "$input{ClusterName}")[0])
    EOF
  }

  physical_component {
    type = "aws_msk_cluster"
    name = <<-EOF
      split("/", "$input{ClusterName}")[0]
    EOF
  }

  data_for_graph_node {
    type = "aws_msk_topic_per_broker"
    name = "$input{Topic}"
  }

  using = {
    "default" : "$input{using}"
  }

  gauge "bytes_in" {
    unit       = "bps"
    aggregator = "SUM"
    source cloudwatch "data_in" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/Kafka"
        metric_name = "BytesInPerSec"
        dimensions = {
          "Cluster Name" = <<-EOF
            split("/", "$input{ClusterName}")[0]
          EOF
          "Broker ID"    = "$input{BrokerID}"
          "Topic"        = "$input{Topic}"
        }
      }
    }
  }
  gauge "bytes_out" {
    unit       = "bps"
    aggregator = "SUM"
    source cloudwatch "data_out" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/Kafka"
        metric_name = "BytesOutPerSec"
        dimensions = {
          "Cluster Name" = <<-EOF
            split("/", "$input{ClusterName}")[0]
          EOF
          "Broker ID"    = "$input{BrokerID}"
          "Topic"        = "$input{Topic}"
        }
      }
    }
  }
  gauge "messages_in" {
    unit       = "tps"
    aggregator = "AVG"
    source cloudwatch "messages_in" {
      query {
        aggregator  = "Average"
        namespace   = "AWS/Kafka"
        metric_name = "MessagesInPerSec"
        dimensions = {
          "Cluster Name" = <<-EOF
            split("/", "$input{ClusterName}")[0]
          EOF
          "Broker ID"    = "$input{BrokerID}"
          "Topic"        = "$input{Topic}"
        }
      }
    }
  }
  gauge "fetch_msg_conversions" {
    unit       = "tps"
    aggregator = "AVG"
    source cloudwatch "fetch_msg_conversions" {
      query {
        aggregator  = "Average"
        namespace   = "AWS/Kafka"
        metric_name = "FetchMessageConversionsPerSec"
        dimensions = {
          "Cluster Name" = <<-EOF
            split("/", "$input{ClusterName}")[0]
          EOF
          "Broker ID"    = "$input{BrokerID}"
          "Topic"        = "$input{Topic}"
        }
      }
    }
  }
  gauge "produce_msg_conversions" {
    unit       = "tps"
    aggregator = "AVG"
    source cloudwatch "produce_msg_conversions" {
      query {
        aggregator  = "Average"
        namespace   = "AWS/Kafka"
        metric_name = "ProduceMessageConversionsPerSec"
        dimensions = {
          "Cluster Name" = <<-EOF
            split("/", "$input{ClusterName}")[0]
          EOF
          "Broker ID"    = "$input{BrokerID}"
          "Topic"        = "$input{Topic}"
        }
      }
    }
  }
}

ingester aws_msk_topic_per_consumer_grp_cloudwatch module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  inputs = "$input{inputs}"

  input_query = <<-EOF
  label_set(
    label_replace(
      kafka_cluster{$input{tag_filter}}, 'id=ClusterName'
    ), "service", "$input{service}", "namespace", "$input{namespace}"
  )
  EOF

  label {
    type = "service"
    name = "$input{service}"
  }

  label {
    type = "namespace"
    name = "$input{namespace}"
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
    unit       = "count"
    aggregator = "MAX"

    source cloudwatch "offset_lag" {
      query {
        aggregator  = "Maximum"
        namespace   = "AWS/Kafka"
        metric_name = "SumOffsetLag"

        dimensions = {
          "Cluster Name"   = <<-EOF
            split("/", "$input{ClusterName}")[0]
          EOF
          "Consumer Group" = "$input{ConsumerGroup}"
          "Topic"          = "$input{Topic}"
        }
      }
    }
  }
}


ingester aws_msk_partition_cloudwatch module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  inputs = "$input{inputs}"

  input_query = <<-EOF
  label_set(
    label_replace(
      kafka_cluster{$input{tag_filter}}, 'id=ClusterName'
    ), "service", "$input{service}", "namespace", "$input{namespace}"
  )
  EOF

  label {
    type = "service"
    name = "$input{service}"
  }

  label {
    type = "namespace"
    name = "$input{namespace}"
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
    unit       = "count"
    aggregator = "MAX"

    source cloudwatch "offset_lag" {
      query {
        aggregator  = "Maximum"
        namespace   = "AWS/Kafka"
        metric_name = "OffsetLag"

        dimensions = {
          "Cluster Name"   = "$input{ClusterName}"
          "Consumer Group" = "$input{ConsumerGroup}"
          "Partition"      = "$input{Partition}"
          "Topic"          = "$input{Topic}"
        }
      }
    }
  }

  gauge "time_lag" {
    unit       = "seconds"
    aggregator = "MAX"

    source cloudwatch "time_lag" {
      query {
        aggregator  = "Maximum"
        namespace   = "AWS/Kafka"
        metric_name = "EstimatedTimeLag"

        dimensions = {
          "Cluster Name"   = <<-EOF
            split("/", "$input{ClusterName}")[0]
          EOF
          "Consumer Group" = "$input{ConsumerGroup}"
          "Partition"      = "$input{Partition}"
          "Topic"          = "$input{Topic}"
        }
      }
    }
  }
}

ingester aws_msk_cluster_cloudwatch module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  inputs = "$input{inputs}"

  input_query = <<-EOF
  label_set(
    label_replace(
      kafka_cluster{$input{tag_filter}}, 'id=ClusterName'
    ), "service", "$input{service}", "namespace", "$input{namespace}"
  )
  EOF

  label {
    type = "service"
    name = "$input{service}"
  }

  label {
    type = "namespace"
    name = "$input{namespace}"
  }

  physical_component {
    type = "aws_msk_cluster"
    name = <<-EOF
      split("/", "$input{ClusterName}")[0]
    EOF
  }

  data_for_graph_node {
    type = "aws_msk_cluster"
    name = <<-EOF
      split("/", "$input{ClusterName}")[0]
    EOF
  }

  using = {
    "default" : "$input{using}"
  }

  gauge "active_controller_count" {
    unit       = "count"
    aggregator = "MAX"

    source cloudwatch "active_controller_count" {
      query {
        aggregator  = "Maximum"
        namespace   = "AWS/Kafka"
        metric_name = "ActiveControllerCount"

        dimensions = {
          "Cluster Name" = <<-EOF
            split("/", "$input{ClusterName}")[0]
          EOF
        }
      }
    }
  }

  gauge "offline_partition_count" {
    unit       = "count"
    aggregator = "MAX"

    source cloudwatch "offline_partition_count" {
      query {
        aggregator  = "Maximum"
        namespace   = "AWS/Kafka"
        metric_name = "OfflinePartitionsCount"

        dimensions = {
          "Cluster Name" = <<-EOF
            split("/", "$input{ClusterName}")[0]
          EOF
        }
      }
    }
  }
}

ingester aws_msk_broker_cloudwatch module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  inputs = "$input{inputs}"

  input_query = <<-EOF
  label_set(
    label_replace(
      kafka_cluster{$input{tag_filter}}, 'id=ClusterName'
    ), "service", "$input{service}", "namespace", "$input{namespace}"
  )
  EOF

  label {
    type = "service"
    name = "$input{service}"
  }

  label {
    type = "namespace"
    name = "$input{namespace}"
  }

  physical_address {
    type = "aws_msk_broker"
    name = <<-EOF
      format("%s-$input{BrokerID}", split("/", "$input{ClusterName}")[0])
    EOF
  }

  physical_component {
    type = "aws_msk_cluster"
    name = <<-EOF
      split("/", "$input{ClusterName}")[0]
    EOF
  }

  data_for_graph_node {
    type = "aws_msk_broker"
    name = <<-EOF
      format("%s-$input{BrokerID}", split("/", "$input{ClusterName}")[0])
    EOF
  }

  using = {
    "default" : "$input{using}"
  }

  gauge "mem_free" {
    unit       = "bytes"
    aggregator = "MIN"
    source cloudwatch "mem_free" {
      query {
        aggregator  = "Minimum"
        namespace   = "AWS/Kafka"
        metric_name = "MemoryFree"
        dimensions = {
          "Cluster Name" = <<-EOF
            split("/", "$input{ClusterName}")[0]
          EOF
          "Broker ID"    = "$input{BrokerID}"
        }
      }
    }
  }

  gauge "messages_in" {
    unit       = "tps"
    aggregator = "AVG"
    source cloudwatch "messages_in" {
      query {
        aggregator  = "Average"
        namespace   = "AWS/Kafka"
        metric_name = "MessagesInPerSec"
        dimensions = {
          "Cluster Name" = <<-EOF
            split("/", "$input{ClusterName}")[0]
          EOF
          "Broker ID"    = "$input{BrokerID}"
        }
      }
    }
  }

  gauge "partition_count" {
    unit       = "count"
    aggregator = "MIN"
    source cloudwatch "partition_count" {
      query {
        aggregator  = "Minimum"
        namespace   = "AWS/Kafka"
        metric_name = "PartitionCount"
        dimensions = {
          "Cluster Name" = <<-EOF
            split("/", "$input{ClusterName}")[0]
          EOF
          "Broker ID"    = "$input{BrokerID}"
        }
      }
    }
  }

  gauge "produce_time_ms_mean" {
    unit       = "milliseconds"
    aggregator = "AVG"
    source cloudwatch "produce_time_ms_mean" {
      query {
        aggregator  = "Average"
        namespace   = "AWS/Kafka"
        metric_name = "ProduceTotalTimeMsMean"
        dimensions = {
          "Cluster Name" = <<-EOF
            split("/", "$input{ClusterName}")[0]
          EOF
          "Broker ID"    = "$input{BrokerID}"
        }
      }
    }
  }

  gauge "request_bytes_mean" {
    unit       = "bytes"
    aggregator = "SUM"
    source cloudwatch "request_bytes_mean" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/Kafka"
        metric_name = "RequestBytesMean"
        dimensions = {
          "Cluster Name" = <<-EOF
            split("/", "$input{ClusterName}")[0]
          EOF
          "Broker ID"    = "$input{BrokerID}"
        }
      }
    }
  }

  gauge "request_time" {
    unit       = "milliseconds"
    aggregator = "AVG"
    source cloudwatch "request_time" {
      query {
        aggregator  = "Average"
        namespace   = "AWS/Kafka"
        metric_name = "RequestTime"
        dimensions = {
          "Cluster Name" = <<-EOF
            split("/", "$input{ClusterName}")[0]
          EOF
          "Broker ID"    = "$input{BrokerID}"
        }
      }
    }
  }

  gauge "produce_msg_conversions" {
    unit       = "tps"
    aggregator = "AVG"
    source cloudwatch "produce_msg_conversions" {
      query {
        aggregator  = "Average"
        namespace   = "AWS/Kafka"
        metric_name = "ProduceMessageConversionsPerSec"
        dimensions = {
          "Cluster Name" = <<-EOF
            split("/", "$input{ClusterName}")[0]
          EOF
          "Broker ID"    = "$input{BrokerID}"
        }
      }
    }
  }

  gauge "fetch_msg_conversions" {
    unit       = "tps"
    aggregator = "AVG"
    source cloudwatch "fetch_msg_conversions" {
      query {
        aggregator  = "Average"
        namespace   = "AWS/Kafka"
        metric_name = "FetchMessageConversionsPerSec"
        dimensions = {
          "Cluster Name" = <<-EOF
            split("/", "$input{ClusterName}")[0]
          EOF
          "Broker ID"    = "$input{BrokerID}"
        }
      }
    }
  }

  gauge "fetch_time_ms_mean" {
    unit       = "milliseconds"
    aggregator = "AVG"
    source cloudwatch "fetch_time_ms_mean" {
      query {
        aggregator  = "Average"
        namespace   = "AWS/Kafka"
        metric_name = "FetchConsumerTotalTimeMsMean"
        dimensions = {
          "Cluster Name" = <<-EOF
            split("/", "$input{ClusterName}")[0]
          EOF
          "Broker ID"    = "$input{BrokerID}"
        }
      }
    }
  }

  gauge "root_disk_used" {
    unit       = "percentage"
    aggregator = "MAX"
    source cloudwatch "root_disk_used" {
      query {
        aggregator  = "Maximum"
        namespace   = "AWS/Kafka"
        metric_name = "RootDiskUsed"
        dimensions = {
          "Cluster Name" = <<-EOF
            split("/", "$input{ClusterName}")[0]
          EOF
          "Broker ID"    = "$input{BrokerID}"
        }
      }
    }
  }

}
