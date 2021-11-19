ingester aws_eks_containerinsights_pod_logical_cloudwatch module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  using = {
    default = "$input{using}"
  }

  inputs = "$input{inputs}"

  input_query = <<-EOF
    label_set(
      label_replace(
        eks_cluster{$input{tag_filter}}, 'id=ClusterName'
      ), "Service", "$input{service}"
    )
  EOF

  label {
    type = "service"
    name = "$input{service}"
  }

  label {
    type = "namespace"
    name = "$input{K8sNamespace}"
  }

  physical_component {
    type = "k8s_cluster"
    name = "$input{ClusterName}"
  }

  data_for_graph_node {
    type = "k8s_service"
    name = "$input{PodName}-$input{K8sNamespace}"
  }

  gauge "cpu" {
    index       = 2
    gap_fill    = "zero_fill"
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "AVG"

    source cloudwatch "cpu" {
      query {
        aggregator  = "Average"
        namespace   = "ContainerInsights"
        metric_name = "pod_cpu_utilization"
        dimensions = {
          "ClusterName" = "$input{ClusterName}"
          "Namespace"   = "$input{K8sNamespace}"
          "PodName"     = "$input{PodName}"
        }
      }
    }
  }

  gauge "memory" {
    index       = 3
    gap_fill    = "zero_fill"
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "AVG"

    source cloudwatch "memory" {
      query {
        aggregator  = "Average"
        namespace   = "ContainerInsights"
        metric_name = "pod_memory_utilization"
        dimensions = {
          "ClusterName" = "$input{ClusterName}"
          "Namespace"   = "$input{K8sNamespace}"
          "PodName"     = "$input{PodName}"
        }
      }
    }
  }

  gauge "cpu_overlimit" {
    index       = 6
    gap_fill    = "zero_fill"
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "AVG"

    source cloudwatch "cpu_overlimit" {
      query {
        aggregator  = "Average"
        namespace   = "ContainerInsights"
        metric_name = "pod_cpu_utilization_over_pod_limit"
        dimensions = {
          "ClusterName" = "$input{ClusterName}"
          "Namespace"   = "$input{K8sNamespace}"
          "PodName"     = "$input{PodName}"
        }
      }
    }
  }

  gauge "memory_overlimit" {
    index       = 7
    gap_fill    = "zero_fill"
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "AVG"

    source cloudwatch "memory_overlimit" {
      query {
        aggregator  = "Average"
        namespace   = "ContainerInsights"
        metric_name = "pod_memory_utilization_over_pod_limit"
        dimensions = {
          "ClusterName" = "$input{ClusterName}"
          "Namespace"   = "$input{K8sNamespace}"
          "PodName"     = "$input{PodName}"
        }
      }
    }
  }

  gauge "bytes_in" {
    index       = 4
    gap_fill    = "zero_fill"
    input_unit  = "bps"
    output_unit = "bps"
    aggregator  = "AVG"

    source cloudwatch "bytes_in" {
      query {
        aggregator  = "Average"
        namespace   = "ContainerInsights"
        metric_name = "pod_network_rx_bytes"
        dimensions = {
          "ClusterName" = "$input{ClusterName}"
          "Namespace"   = "$input{K8sNamespace}"
          "PodName"     = "$input{PodName}"
        }
      }
    }
  }

  gauge "bytes_out" {
    index       = 5
    gap_fill    = "zero_fill"
    input_unit  = "bps"
    output_unit = "bps"
    aggregator  = "AVG"

    source cloudwatch "bytes_out" {
      query {
        aggregator  = "Average"
        namespace   = "ContainerInsights"
        metric_name = "pod_network_tx_bytes"
        dimensions = {
          "ClusterName" = "$input{ClusterName}"
          "Namespace"   = "$input{K8sNamespace}"
          "PodName"     = "$input{PodName}"
        }
      }
    }
  }

  gauge "restarts" {
    index       = 8
    gap_fill    = "zero_fill"
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source cloudwatch "pod_number_of_container_restarts" {
      query {
        aggregator  = "Sum"
        namespace   = "ContainerInsights"
        metric_name = "pod_number_of_container_restarts"
        dimensions = {
          "ClusterName" = "$input{ClusterName}"
          "Namespace"   = "$input{K8sNamespace}"
          "PodName"     = "$input{PodName}"
        }
      }
    }
  }
}

ingester aws_eks_containerinsights_cluster_cloudwatch module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  using = {
    default = "$input{using}"
  }

  inputs = "$input{inputs}"

  input_query = <<-EOF
    label_set(
      label_replace(
        eks_cluster{$input{tag_filter}}, 'id=ClusterName'
      ), "Service", "$input{service}"
    )
  EOF

  label {
    type = "service"
    name = "$input{service}"
  }

  physical_component {
    type = "k8s_cluster"
    name = "$input{ClusterName}"
  }

  data_for_graph_node {
    type = "k8s_cluster"
    name = "$input{ClusterName}"
  }

  gauge "total_nodes" {
    index       = 1
    gap_fill    = "zero_fill"
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"

    source cloudwatch "cluster_node_count" {
      query {
        aggregator  = "Maximum"
        namespace   = "ContainerInsights"
        metric_name = "cluster_node_count"
        dimensions = {
          "ClusterName" = "$input{ClusterName}"
        }
      }
    }
  }

  gauge "failed_nodes" {
    index       = 2
    gap_fill    = "zero_fill"
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"

    source cloudwatch "cluster_failed_node_count" {
      query {
        aggregator  = "Maximum"
        namespace   = "ContainerInsights"
        metric_name = "cluster_failed_node_count"
        dimensions = {
          "ClusterName" = "$input{ClusterName}"
        }
      }
    }
  }

  gauge "cpu_utilization" {
    index       = 6
    gap_fill    = "zero_fill"
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "AVG"

    source cloudwatch "cluster_node_cpu_utilization" {
      query {
        aggregator  = "Average"
        namespace   = "ContainerInsights"
        metric_name = "node_cpu_utilization"
        dimensions = {
          "ClusterName" = "$input{ClusterName}"
        }
      }
    }
  }

  gauge "memory_utilization" {
    index       = 7
    gap_fill    = "zero_fill"
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "AVG"

    source cloudwatch "cluster_node_memory_utilization" {
      query {
        aggregator  = "Average"
        namespace   = "ContainerInsights"
        metric_name = "node_memory_utilization"
        dimensions = {
          "ClusterName" = "$input{ClusterName}"
        }
      }
    }
  }

  gauge "disk_used" {
    index       = 5
    gap_fill    = "zero_fill"
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "AVG"

    source cloudwatch "cluster_memory_limit" {
      query {
        aggregator  = "Average"
        namespace   = "ContainerInsights"
        metric_name = "node_filesystem_utilization"
        dimensions = {
          "ClusterName" = "$input{ClusterName}"
        }
      }
    }
  }
}

