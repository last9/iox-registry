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
    unit       = "percent"
    aggregator = "AVG"

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
    unit       = "percent"
    aggregator = "AVG"

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
    unit       = "percent"
    aggregator = "AVG"

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
    unit       = "percent"
    aggregator = "AVG"

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
    unit       = "bps"
    aggregator = "AVG"

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
    unit       = "bps"
    aggregator = "AVG"

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
    unit       = "count"
    aggregator = "SUM"

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
    unit       = "count"
    aggregator = "MAX"

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
    unit       = "count"
    aggregator = "MAX"

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

  gauge "node_cpu_utilization" {
    unit       = "percent"
    aggregator = "AVG"

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

  gauge "node_memory_utilization" {
    unit       = "percent"
    aggregator = "AVG"

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
    unit       = "percent"
    aggregator = "AVG"

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

