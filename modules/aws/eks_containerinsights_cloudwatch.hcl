ingester aws_eks_containerinsights_service_cloudwatch module {
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
    name = "$input{K8sService}"
  }

  gauge "pods_min" {
    unit       = "count"
    aggregator = "MIN"

    source cloudwatch "service_number_of_running_pods_min" {
      query {
        aggregator  = "Minimum"
        namespace   = "ContainerInsights"
        metric_name = "service_number_of_running_pods"
        dimensions = {
          "ClusterName" = "$input{ClusterName}"
          "Namespace"   = "$input{K8sNamespace}"
          "Service"     = "$input{K8sService}"
        }
      }
    }
  }

  gauge "pods_max" {
    unit       = "count"
    aggregator = "MAX"

    source cloudwatch "service_number_of_running_pods_max" {
      query {
        aggregator  = "Maximum"
        namespace   = "ContainerInsights"
        metric_name = "service_number_of_running_pods"
        dimensions = {
          "ClusterName" = "$input{ClusterName}"
          "Namespace"   = "$input{K8sNamespace}"
          "Service"     = "$input{K8sService}"
        }
      }
    }
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
          "Service"     = "$input{K8sService}"
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
          "Service"     = "$input{K8sService}"
        }
      }
    }
  }

  gauge "cpu_usage_of_limit" {
    unit       = "percent"
    aggregator = "AVG"

    source cloudwatch "cpu_usage_of_limit" {
      query {
        aggregator  = "Average"
        namespace   = "ContainerInsights"
        metric_name = "pod_cpu_utilization_over_pod_limit"
        dimensions = {
          "ClusterName" = "$input{ClusterName}"
          "Namespace"   = "$input{K8sNamespace}"
          "Service"     = "$input{K8sService}"
        }
      }
    }
  }

  gauge "memory_usage_of_limit" {
    unit       = "percent"
    aggregator = "AVG"

    source cloudwatch "memory_usage_of_limit" {
      query {
        aggregator  = "Average"
        namespace   = "ContainerInsights"
        metric_name = "pod_memory_utilization_over_pod_limit"
        dimensions = {
          "ClusterName" = "$input{ClusterName}"
          "Namespace"   = "$input{K8sNamespace}"
          "Service"     = "$input{K8sService}"
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
          "Service"     = "$input{K8sService}"
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
          "Service"     = "$input{K8sService}"
        }
      }
    }
  }
}

ingester aws_eks_containerinsights_pod_cloudwatch module {
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

  physical_address {
    type = "k8s_pod"
    name = "$input{PodName}"
  }

  data_for_graph_node {
    type = "k8s_pod"
    name = "$input{PodName}"
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

  gauge "cpu_usage_of_limit" {
    unit       = "percent"
    aggregator = "AVG"

    source cloudwatch "cpu_usage_of_limit" {
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

  gauge "memory_usage_of_limit" {
    unit       = "percent"
    aggregator = "AVG"

    source cloudwatch "memory_usage_of_limit" {
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

  gauge "cpu_limit" {
    unit       = "count"
    aggregator = "AVG"

    source cloudwatch "cluster_cpu_limit" {
      query {
        aggregator  = "Average"
        namespace   = "ContainerInsights"
        metric_name = "node_cpu_limit"
        dimensions = {
          "ClusterName" = "$input{ClusterName}"
        }
      }
    }
  }

  gauge "memory_limit" {
    unit       = "bytes"
    aggregator = "AVG"

    source cloudwatch "cluster_memory_limit" {
      query {
        aggregator  = "Average"
        namespace   = "ContainerInsights"
        metric_name = "node_memory_limit"
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
