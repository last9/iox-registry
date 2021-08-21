ingester aws_eks_containerinsights_service_cloudwatch nodule {
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
    name = "$input{Service}"
  }

  label {
    type = "namespace"
    name = "$input{Namespace}"
  }

  physical_component {
    type = "eks_cluster"
    name = "$input{ClusterName}"
  }

  data_for_graph_node {
    type = "eks_service"
    name = "$input{Service}-$input{Namespace}-service"
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
          "Namespace"   = "$input{Namespace}"
          "Service"     = "$input{Service}"
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
          "Namespace"   = "$input{Namespace}"
          "Service"     = "$input{Service}"
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
          "Namespace"   = "$input{Namespace}"
          "Service"     = "$input{Service}"
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
          "Namespace"   = "$input{Namespace}"
          "Service"     = "$input{Service}"
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
          "Namespace"   = "$input{Namespace}"
          "Service"     = "$input{Service}"
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
          "Namespace"   = "$input{Namespace}"
          "Service"     = "$input{Service}"
        }
      }
    }
  }

  gauge "running_pods" {
    unit       = "count"
    aggregator = "SUM"

    source cloudwatch "running_pods" {
      query {
        aggregator  = "Maximum"
        namespace   = "ContainerInsights"
        metric_name = "service_number_of_running_pods"
        dimensions = {
          "ClusterName" = "$input{ClusterName}"
          "Namespace"   = "$input{Namespace}"
          "Service"     = "$input{Service}"
        }
      }
    }
  }
}


ingester aws_eks_containerinsights_deployment_with_service_cloudwatch nodule {
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
    name = "$input{Service}"
  }

  label {
    type = "namespace"
    name = "$input{Namespace}"
  }

  physical_component {
    type = "eks_cluster"
    name = "$input{ClusterName}"
  }

  data_for_graph_node {
    type = "eks_deployment"
    name = "$input{PodName}-$input{Namespace}"
  }

  logical_parent_nodes = [
    {
      type = "eks_service"
      name = "$input{Service}-$input{Namespace}-service"
    }
  ]

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
          "Namespace"   = "$input{Namespace}"
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
          "Namespace"   = "$input{Namespace}"
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
          "Namespace"   = "$input{Namespace}"
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
          "Namespace"   = "$input{Namespace}"
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
          "Namespace"   = "$input{Namespace}"
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
          "Namespace"   = "$input{Namespace}"
          "PodName"     = "$input{PodName}"
        }
      }
    }
  }

  gauge "container_restarts" {
    unit       = "count"
    aggregator = "SUM"

    source cloudwatch "pod_number_of_container_restarts" {
      query {
        aggregator  = "Sum"
        namespace   = "ContainerInsights"
        metric_name = "pod_number_of_container_restarts"
        dimensions = {
          "ClusterName" = "$input{ClusterName}"
          "Namespace"   = "$input{Namespace}"
          "PodName"     = "$input{PodName}"
        }
      }
    }
  }
}

ingester eks_containerinsights_els_cluster_cloudwatch module {
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
    name = "k8s-deployments"
  }

  label {
    type = "namespace"
    name = "default"
  }

  physical_component {
    type = "eks_cluster"
    name = "$input{ClusterName}"
  }

  data_for_graph_node {
    type = "eks_cluster"
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

  gauge "cpu_utilization" {
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

  gauge "memory_utilization" {
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
