ingester prometheus_kube_cluster module {
  frequency = 600
  lookback = 900
  timeout = 180
  resolution = 60
  lag = 60

  inputs = "$input{inputs}"

  label {
    type = "service"
    name = "K8s-Resources"
  }

  label {
    type = "namespace"
    name = "k8s Namespace"
  }

  physical_component {
    type = "kube_cluster"
    name = "$input{cluster}"
  }

  data_for_graph_node {
    type = "kube_cluster"
    name = "$output{cluster}"
  }

  using = {
    "default" : "$input{using}"
  }

  gauge "total_unknown_nodes" {
    unit = "count"

    source prometheus "total_unknown_nodes" {
      query = "sum by (cluster)(kube_node_status_condition{status='unknown'})"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "node_with_disk_pressure" {
    unit = "count"

    source prometheus "node_with_disk_pressure" {
      query = "sum by (cluster)(kube_node_status_condition{condition='DiskPressure', status='true'})"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "node_with_memory_pressure" {
    unit = "count"

    source prometheus "node_with_memory_pressure" {
      query = "sum by (cluster)(kube_node_status_condition{condition='MemoryPressure', status='true'})"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "available_memory_capacity" {
    unit = "bytes"

    source prometheus "available_memory_capacity" {
      query = "sum by (cluster)(kube_node_status_allocatable_memory_bytes{}) - sum(kube_pod_container_resource_requests_memory_bytes{})"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "available_cpu_capacity" {
    unit = "count"

    source prometheus "available_cpu_capacity" {
      query = "sum by (cluster)(kube_node_status_allocatable_cpu_cores{}) - sum(kube_pod_container_resource_requests_cpu_cores{})"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "total_unscheduled_pods" {
    unit = "count"

    source prometheus "total_unscheduled_pods" {
      query = "sum by (cluster)(kube_pod_status_unschedulable{})"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "total_failed_pods" {
    unit = "count"

    source prometheus "total_failed_pods" {
      query = "sum by (cluster)(kube_pod_status_phase{phase='Failed'})"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }
}


ingester prometheus_kube_cluster_with_namespace module {
  frequency = 600
  lookback = 900
  timeout = 180
  resolution = 60
  lag = 60


  inputs = "$input{inputs}"

  label {
    type = "service"
    name = "K8s-Resources"
  }

  label {
    type = "namespace"
    name = "$output{namespace}"
  }

  physical_component {
    type = "kube_cluster"
    name = "$input{cluster}"
  }

  data_for_graph_node {
    type = "kube_virtual_cluster"
    name = "$output{cluster}-$output{namespace}"
  }

  using = {
    "default" : "$input{using}"
  }

  gauge "total_memory_requested" {
    unit = "bytes"

    source prometheus "total_memory_requested" {
      query = "sum by (cluster, namespace)(kube_pod_container_resource_requests_memory_bytes{})"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "total_cpu_requested" {
    unit = "count"

    source prometheus "total_cpu_requested" {
      query = "sum by (cluster, namespace) (kube_pod_container_resource_requests_cpu_cores{})"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "total_unscheduled_pods" {
    unit = "count"

    source prometheus "total_unscheduled_pods" {
      query = "sum by (cluster, namespace) (kube_pod_status_unschedulable{})"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "total_failed_and_unknown_pods" {
    unit = "count"

    source prometheus "total_failed_and_unknown_pods" {
      query = "sum by (cluster, namespace) (kube_pod_status_phase{phase=~'Failed|Unknown'})"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "total_container_restarts" {
    unit = "count"

    source prometheus "total_container_restarts" {
      query = "sum by (cluster, namespace) (kube_pod_container_status_restarts_total{})"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }
}


ingester prometheus_kube_node module {
  frequency = 600
  lookback = 900
  timeout = 180
  resolution = 60
  lag = 60


  inputs = "$input{inputs}"

  label {
    type = "service"
    name = "K8s-Resources"
  }

  label {
    type = "namespace"
    name = "k8s Namespace"
  }

  physical_address {
    type = "kube_node"
    name = "$output{node}"
  }

  physical_component {
    type = "kube_cluster"
    name = "$input{cluster}"
  }

  data_for_graph_node {
    type = "kube_node"
    name = "$output{node}"
  }

  using = {
    "default" : "$input{using}"
  }

  gauge "total_cpu_for_scheduling" {
    unit = "count"

    source prometheus "total_cpu_for_scheduling" {
      query = "sum by (cluster, node) (kube_node_status_allocatable{resource='cpu', unit='core'}) - sum by (cluster, node) (kube_pod_container_resource_limits{resource='cpu', unit='core'})"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "total_memory_for_scheduling" {
    unit = "bytes"

    source prometheus "total_memory_for_scheduling" {
      query = "sum by (cluster, node) (kube_node_status_allocatable{resource='memory', unit='byte'}) - sum by (cluster, node) (kube_pod_container_resource_limits{resource='memory', unit='byte'})"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "out_of_pods" {
    unit = "count"

    source prometheus "out_of_pods" {
      query = "sum by (cluster, node) (kube_node_spec_unschedulable{})"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "high_disk_pressure" {
    unit = "count"

    source prometheus "high_disk_pressure" {
      query = "sum by (cluster, node) (kube_node_status_condition{condition='DiskPressure', status='true'})"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "high_memory_pressure" {
    unit = "count"

    source prometheus "high_memory_pressure" {
      query = "sum by (cluster, node) (kube_node_status_condition{condition='MemoryPressure', status='true'})"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "high_pid_pressure" {
    unit = "count"

    source prometheus "high_pid_pressure" {
      query = "sum by (cluster, node) (kube_node_status_condition{condition='PIDPressure', status='true'})"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }
}

ingester prometheus_kube_pod module {
  frequency = 600
  lookback = 900
  timeout = 180
  resolution = 60
  lag = 60


  inputs = "$input{inputs}"

  label {
    type = "service"
    name = "K8s-Resources"
  }

  label {
    type = "namespace"
    name = "$output{namespace}"
  }

  physical_component {
    type = "kube_cluster"
    name = "$input{cluster}"
  }

  data_for_graph_node {
    type = "kube_pod"
    name = "$output{pod}"
  }

  logical_parent_nodes = [
    {
      type = "kube_virtual_cluster"
      name = "$output{cluster}-$output{namespace}"
    },
    {
      type = "kube_pods"
      name = "Pods"
    },
  ]

  using = {
    "default" : "$input{using}"
  }

  gauge "total_container_restarts" {
    unit = "count"

    source prometheus "total_container_restarts" {
      query = "sum by (cluster, namespace, pod) (kube_pod_container_status_restarts_total{})"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "total_containers_in_error" {
    unit = "count"

    source prometheus "total_containers_in_error" {
      query = "sum by (cluster, namespace, pod) (kube_pod_container_status_terminated_reason{reason!='Completed'})"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "running_vs_waiting_containers" {
    unit = "count"

    source prometheus "running_vs_waiting_containers" {
      query = "sum by (cluster, namespace, pod) (kube_pod_container_status_running{}) - sum by (cluster, namespace, pod) (kube_pod_container_status_waiting{})"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }
}


ingester prometheus_kube_container module {
  frequency = 600
  lookback = 900
  timeout = 180
  resolution = 60
  lag = 60


  inputs = "$input{inputs}"

  label {
    type = "service"
    name = "K8s-Resources"
  }

  label {
    type = "namespace"
    name = "$output{namespace}"
  }

  physical_component {
    type = "kube_cluster"
    name = "$input{cluster}"
  }

  data_for_graph_node {
    type = "kube_container"
    name = "$output{container}"
  }

  logical_parent_nodes = [
    {
      type = "kube_virtual_cluster"
      name = "$output{cluster}-$output{namespace}"
    },
    {
      type = "kube_pods"
      name = "Pods"
    },
    {
      type = "kube_pod"
      name = "$output{pod}"
    },
  ]

  using = {
    "default" : "$input{using}"
  }

  gauge "total_container_restarts" {
    unit = "count"

    source prometheus "total_container_restarts" {
      query = "sum by (cluster, namespace, pod, container) (kube_pod_container_status_restarts_total{})"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "container_in_terminated" {
    unit = "count"

    source prometheus "container_in_terminated" {
      query = "sum by (cluster, namespace, pod, container) (kube_pod_container_status_terminated_reason{reason!='Completed'})"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "container_in_waiting" {
    unit = "count"

    source prometheus "container_in_waiting" {
      query = "sum by (cluster, namespace, pod, container) (kube_pod_container_status_waiting_reason{reason!='ContainerCreating', reason!='PodInitializing'})"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "container_cpu_limit" {
    unit = "count"

    source prometheus "container_cpu_limit" {
      query = "sum by (cluster, namespace, pod, container) (kube_pod_container_resource_limits{resource='cpu', unit='core'})"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "container_memory_limit" {
    unit = "bytes"

    source prometheus "container_memory_limit" {
      query = "sum by (cluster, namespace, pod, container) (kube_pod_container_resource_limits{resource='memory', unit='byte'})"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }
}

ingester prometheus_kube_deployment module {
  frequency = 600
  lookback = 900
  timeout = 180
  resolution = 60
  lag = 60


  inputs = "$input{inputs}"

  label {
    type = "service"
    name = "K8s-Resources"
  }

  label {
    type = "namespace"
    name = "$output{namespace}"
  }

  physical_component {
    type = "kube_cluster"
    name = "$input{cluster}"
  }

  data_for_graph_node {
    type = "kube_deployment"
    name = "$output{deployment}"
  }

  logical_parent_nodes = [
    {
      type = "kube_virtual_cluster"
      name = "$input{cluster}-$output{namespace}"
    },
    {
      type = "kube_deployments"
      name = "Deployments"
    },
  ]

  using = {
    "default" : "$input{using}"
  }

  gauge "total_unavailable_replicas" {
    unit = "count"

    source prometheus "total_unavailable_replicas" {
      query = "sum by (cluster, namespace, deployment) (kube_deployment_status_replicas_unavailable{})"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "total_updated_replicas" {
    unit = "count"

    source prometheus "total_updated_replicas" {
      query = "sum by (cluster, namespace, deployment) (kube_deployment_status_replicas_updated{})"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "desired_vs_available_replicas" {
    unit = "count"
    source prometheus "desired_vs_available_replicas" {
      query = "sum by (cluster, namespace, deployment)(kube_deployment_status_replicas{}) - sum by (cluster, namespace, deployment) (kube_deployment_status_replicas_available{})"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }
}
