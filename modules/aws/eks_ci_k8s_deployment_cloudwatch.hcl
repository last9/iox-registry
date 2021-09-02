ingester aws_eks_containerinsights_deployment_without_service_cloudwatch module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  using = {
    default = "$input{using}"
  }

  inputs = "$input{inputs}"

  input_query = "label_replace(eks_cluster{$input{tag_filter}}, 'id=ClusterName')"

  label {
    type = "service"
    name = "k8s-deployments"
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

ingester aws_eks_containerinsights_node_cloudwatch module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  using = {
    default = "$input{using}"
  }

  inputs = "$input{inputs}"

  input_query = "label_replace(eks_cluster{$input{tag_filter}}, 'id=ClusterName')"

  label {
    type = "service"
    name = "k8s-deployments"
  }

  label {
    type = "namespace"
    name = "default"
  }

  physical_address {
    type = "eks_node"
    name = "$input{NodeName}"
  }

  physical_component {
    type = "eks_cluster"
    name = "$input{ClusterName}"
  }

  data_for_graph_node {
    type = "eks_node"
    name = "$input{NodeName}"
  }

  gauge "cpu_used" {
    unit       = "percent"
    aggregator = "AVG"

    source cloudwatch "cpu_used" {
      query {
        aggregator  = "Average"
        namespace   = "ContainerInsights"
        metric_name = "node_cpu_utilization"
        dimensions = {
          "ClusterName" = "$input{ClusterName}"
          "NodeName"    = "$input{NodeName}"
          "InstanceId"  = "$input{InstanceId}"
        }
      }
    }
  }

  gauge "filesystem_used" {
    unit       = "percent"
    aggregator = "AVG"

    source cloudwatch "filesystem_used" {
      query {
        aggregator  = "Average"
        namespace   = "ContainerInsights"
        metric_name = "node_filesystem_utilization"
        dimensions = {
          "ClusterName" = "$input{ClusterName}"
          "NodeName"    = "$input{NodeName}"
          "InstanceId"  = "$input{InstanceId}"
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
        metric_name = "node_cpu_utilization"
        dimensions = {
          "ClusterName" = "$input{ClusterName}"
          "NodeName"    = "$input{NodeName}"
          "InstanceId"  = "$input{InstanceId}"
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
        metric_name = "node_number_of_running_pods"
        dimensions = {
          "ClusterName" = "$input{ClusterName}"
          "NodeName"    = "$input{NodeName}"
          "InstanceId"  = "$input{InstanceId}"
        }
      }
    }
  }

  gauge "running_containers" {
    unit       = "count"
    aggregator = "SUM"

    source cloudwatch "running_containers" {
      query {
        aggregator  = "Maximum"
        namespace   = "ContainerInsights"
        metric_name = "node_number_of_running_containers"
        dimensions = {
          "ClusterName" = "$input{ClusterName}"
          "NodeName"    = "$input{NodeName}"
          "InstanceId"  = "$input{InstanceId}"
        }
      }
    }
  }
}
