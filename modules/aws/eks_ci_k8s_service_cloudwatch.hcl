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

  input_query = "label_replace(eks_cluster{$input{tag_filter}}, 'id=ClusterName')"

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
