ingester aws_eks_containerinsights_deployment_without_service module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  inputs = "$input{input}"

  using = {
    "default" = "$input{using}"
  }

  label {
    type = "namespace"
    name = "$output{tag_namespace}"
  }

  label {
    type = "service"
    name = "$output{tag_service}"
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
    index       = 2
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "AVG"

    source prometheus "cpu" {
      query = "avg by (ClusterName, Namespace, PodName, tag_namespace, tag_service) (cpu)"

      join_on = {
        "$output{ClusterName}" = "$input{ClusterName}"
        "$output{Namespace}"   = "$input{Namespace}"
        "$output{PodName}"     = "$input{PodName}"
      }
    }
  }

  gauge "memory" {
    index       = 3
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "AVG"

    source prometheus "memory" {
      query = "avg by (ClusterName, Namespace, PodName, tag_namespace, tag_service) (memory)"

      join_on = {
        "$output{ClusterName}" = "$input{ClusterName}"
        "$output{Namespace}"   = "$input{Namespace}"
        "$output{PodName}"     = "$input{PodName}"
      }
    }
  }

  gauge "cpu_overlimit" {
    index       = 6
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "AVG"

    source prometheus "cpu_overlimit" {
      query = "avg by (ClusterName, Namespace, PodName, tag_namespace, tag_service) (cpu_overlimit)"

      join_on = {
        "$output{ClusterName}" = "$input{ClusterName}"
        "$output{Namespace}"   = "$input{Namespace}"
        "$output{PodName}"     = "$input{PodName}"
      }
    }
  }

  gauge "memory_overlimit" {
    index       = 7
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "AVG"

    source prometheus "memory_overlimit" {
      query = "avg by (ClusterName, Namespace, PodName, tag_namespace, tag_service) (memory_overlimit)"

      join_on = {
        "$output{ClusterName}" = "$input{ClusterName}"
        "$output{Namespace}"   = "$input{Namespace}"
        "$output{PodName}"     = "$input{PodName}"
      }
    }
  }

  gauge "bytes_in" {
    index       = 4
    input_unit  = "bps"
    output_unit = "bps"
    aggregator  = "AVG"

    source prometheus "bytes_in" {
      query = "avg by (ClusterName, Namespace, PodName, tag_namespace, tag_service) (bytes_in)"

      join_on = {
        "$output{ClusterName}" = "$input{ClusterName}"
        "$output{Namespace}"   = "$input{Namespace}"
        "$output{PodName}"     = "$input{PodName}"
      }
    }
  }

  gauge "bytes_out" {
    index       = 5
    input_unit  = "bps"
    output_unit = "bps"
    aggregator  = "AVG"

    source prometheus "bytes_out" {
      query = "avg by (ClusterName, Namespace, PodName, tag_namespace, tag_service) (bytes_out)"

      join_on = {
        "$output{ClusterName}" = "$input{ClusterName}"
        "$output{Namespace}"   = "$input{Namespace}"
        "$output{PodName}"     = "$input{PodName}"
      }
    }
  }

  gauge "container_restarts" {
    index       = 8
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "container_restarts" {
      query = "sum by (ClusterName, Namespace, PodName, tag_namespace, tag_service) (container_restarts)"

      join_on = {
        "$output{ClusterName}" = "$input{ClusterName}"
        "$output{Namespace}"   = "$input{Namespace}"
        "$output{PodName}"     = "$input{PodName}"
      }
    }
  }
}

ingester aws_eks_containerinsights_node module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  inputs = "$input{input}"

  using = {
    "default" = "$input{using}"
  }

  label {
    type = "namespace"
    name = "$output{tag_namespace}"
  }

  label {
    type = "service"
    name = "$output{tag_service}"
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
    index       = 1
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "AVG"

    source prometheus "cpu_used" {
      query = "avg by (ClusterName, NodeName, InstanceId, tag_namespace, tag_service) (cpu_used)"

      join_on = {
        "$output{ClusterName}" = "$input{ClusterName}"
        "$output{NodeName}"    = "$input{NodeName}"
        "$output{InstanceId}"  = "$input{InstanceId}"
      }
    }
  }

  gauge "filesystem_used" {
    index       = 2
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "AVG"

    source prometheus "filesystem_used" {
      query = "avg by (ClusterName, NodeName, InstanceId, tag_namespace, tag_service) (filesystem_used)"

      join_on = {
        "$output{ClusterName}" = "$input{ClusterName}"
        "$output{NodeName}"    = "$input{NodeName}"
        "$output{InstanceId}"  = "$input{InstanceId}"
      }
    }
  }

  gauge "memory_overlimit" {
    index       = 3
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "AVG"

    source prometheus "memory_overlimit" {
      query = "avg by (ClusterName, NodeName, InstanceId, tag_namespace, tag_service) (memory_overlimit)"

      join_on = {
        "$output{ClusterName}" = "$input{ClusterName}"
        "$output{NodeName}"    = "$input{NodeName}"
        "$output{InstanceId}"  = "$input{InstanceId}"
      }
    }
  }

  gauge "running_pods" {
    index       = 5
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "running_pods" {
      query = "sum by (ClusterName, NodeName, InstanceId, tag_namespace, tag_service) (running_pods)"

      join_on = {
        "$output{ClusterName}" = "$input{ClusterName}"
        "$output{NodeName}"    = "$input{NodeName}"
        "$output{InstanceId}"  = "$input{InstanceId}"
      }
    }
  }

  gauge "running_containers" {
    index       = 4
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "running_containers" {
      query = "sum by (ClusterName, NodeName, InstanceId, tag_namespace, tag_service) (running_containers)"

      join_on = {
        "$output{ClusterName}" = "$input{ClusterName}"
        "$output{NodeName}"    = "$input{NodeName}"
        "$output{InstanceId}"  = "$input{InstanceId}"
      }
    }
  }
}

ingester aws_eks_containerinsights_service module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  inputs = "$input{input}"

  using = {
    "default" = "$input{using}"
  }

  label {
    type = "namespace"
    name = "$output{tag_namespace}"
  }

  label {
    type = "service"
    name = "$output{tag_service}"
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
    index       = 2
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "AVG"

    source prometheus "cpu" {
      query = "avg by (ClusterName, Namespace, Service, tag_namespace, tag_service) (cpu)"

      join_on = {
        "$output{ClusterName}" = "$input{ClusterName}"
        "$output{Namespace}"   = "$input{Namespace}"
        "$output{Service}"     = "$input{Service}"
      }
    }
  }

  gauge "memory" {
    index       = 3
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "AVG"

    source prometheus "memory" {
      query = "avg by (ClusterName, Namespace, Service, tag_namespace, tag_service) (memory)"

      join_on = {
        "$output{ClusterName}" = "$input{ClusterName}"
        "$output{Namespace}"   = "$input{Namespace}"
        "$output{Service}"     = "$input{Service}"
      }
    }
  }

  gauge "cpu_overlimit" {
    index       = 6
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "AVG"

    source prometheus "cpu_overlimit" {
      query = "avg by (ClusterName, Namespace, Service, tag_namespace, tag_service) (cpu_overlimit)"

      join_on = {
        "$output{ClusterName}" = "$input{ClusterName}"
        "$output{Namespace}"   = "$input{Namespace}"
        "$output{Service}"     = "$input{Service}"
      }
    }
  }

  gauge "memory_overlimit" {
    index       = 7
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "AVG"

    source prometheus "memory_overlimit" {
      query = "avg by (ClusterName, Namespace, Service, tag_namespace, tag_service) (memory_overlimit)"

      join_on = {
        "$output{ClusterName}" = "$input{ClusterName}"
        "$output{Namespace}"   = "$input{Namespace}"
        "$output{Service}"     = "$input{Service}"
      }
    }
  }

  gauge "bytes_in" {
    index       = 4
    input_unit  = "bps"
    output_unit = "bps"
    aggregator  = "AVG"

    source prometheus "bytes_in" {
      query = "avg by (ClusterName, Namespace, Service, tag_namespace, tag_service) (bytes_in)"

      join_on = {
        "$output{ClusterName}" = "$input{ClusterName}"
        "$output{Namespace}"   = "$input{Namespace}"
        "$output{Service}"     = "$input{Service}"
      }
    }
  }

  gauge "bytes_out" {
    index       = 5
    input_unit  = "bps"
    output_unit = "bps"
    aggregator  = "AVG"

    source prometheus "bytes_out" {
      query = "avg by (ClusterName, Namespace, Service, tag_namespace, tag_service) (bytes_out)"

      join_on = {
        "$output{ClusterName}" = "$input{ClusterName}"
        "$output{Namespace}"   = "$input{Namespace}"
        "$output{Service}"     = "$input{Service}"
      }
    }
  }

  gauge "running_pods" {
    index       = 8
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "running_pods" {
      query = "sum by (ClusterName, Namespace, Service, tag_namespace, tag_service) (running_pods)"

      join_on = {
        "$output{ClusterName}" = "$input{ClusterName}"
        "$output{Namespace}"   = "$input{Namespace}"
        "$output{Service}"     = "$input{Service}"
      }
    }
  }
}

ingester aws_eks_cluster module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  inputs = "[]"

  using = {
    "default" = "$input{using}"
  }

  label {
    type = "namespace"
    name = "$output{tag_namespace}"
  }

  label {
    type = "service"
    name = "$output{tag_service}"
  }

  physical_component {
    type = "eks_cluster"
    name = "EKS_CLUSTER"
  }

  data_for_graph_node {
    type = "eks_cluster_logical"
    name = "$output{ClusterName}"
  }

  gauge "total_nodes" {
    index       = 1
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"

    source prometheus "total_nodes" {
      query = "max by (ClusterName, tag_namespace, tag_service) (total_nodes{ClusterName!=''})"
    }
  }

  gauge "failed_nodes" {
    index       = 2
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"

    source prometheus "failed_nodes" {
      query = "max by (ClusterName, tag_namespace, tag_service) (failed_nodes{ClusterName!=''})"
    }
  }

  gauge "cpu_utilization" {
    index       = 6
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "AVG"

    source prometheus "cpu_utilization" {
      query = "avg by (ClusterName, tag_namespace, tag_service) (cpu_utilization{ClusterName!=''})"
    }
  }

  gauge "memory_utilization" {
    index       = 7
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "AVG"

    source prometheus "memory_utilization" {
      query = "avg by (ClusterName, tag_namespace, tag_service) (memory_utilization{ClusterName!=''})"
    }
  }

  gauge "disk_used" {
    index       = 5
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "AVG"

    source prometheus "disk_used" {
      query = "avg by (ClusterName, tag_namespace, tag_service) (disk_used{ClusterName!=''})"
    }
  }
}
