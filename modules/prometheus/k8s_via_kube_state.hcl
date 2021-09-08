ingester prometheus_kube_cluster module {
  frequency  = 600
  lookback   = 900
  timeout    = 180
  resolution = 60
  lag        = 60

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
      query = "label_set(sum by (cluster)(kube_node_status_condition{status='unknown'}), 'cluster', '$input{cluster}')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "node_with_disk_pressure" {
    unit = "count"

    source prometheus "node_with_disk_pressure" {
      query = "label_set(sum by (cluster)(kube_node_status_condition{condition='DiskPressure', status='true'}), 'cluster', '$input{cluster}')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "node_with_memory_pressure" {
    unit = "count"

    source prometheus "node_with_memory_pressure" {
      query = "label_set(sum by (cluster)(kube_node_status_condition{condition='MemoryPressure', status='true'}), 'cluster', '$input{cluster}')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "available_memory_capacity" {
    unit = "bytes"

    source prometheus "available_memory_capacity" {
      query = "label_set(sum by (cluster)(kube_node_status_allocatable{resource='memory', unit='byte'}) - sum(kube_pod_container_resource_requests{resource='memory', unit='byte'}), 'cluster', '$input{cluster}')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "available_cpu_capacity" {
    unit = "count"

    source prometheus "available_cpu_capacity" {
      query = "label_set(sum by (cluster)(kube_node_status_allocatable{resource='cpu', unit='core'}) - sum(kube_pod_container_resource_requests{resource='cpu', unit='core'}), 'cluster', '$input{cluster}')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "total_unscheduled_pods" {
    unit = "count"

    source prometheus "total_unscheduled_pods" {
      query = "label_set(sum by (cluster)(kube_pod_status_unschedulable{}), 'cluster', '$input{cluster}')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "total_failed_pods" {
    unit = "count"

    source prometheus "total_failed_pods" {
      query = "label_set(sum by (cluster)(kube_pod_status_phase{phase='Failed'}), 'cluster', '$input{cluster}')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }
}


ingester prometheus_kube_cluster_with_namespace module {
  frequency  = 600
  lookback   = 900
  timeout    = 180
  resolution = 60
  lag        = 60


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
      query = "label_set(sum by (cluster, namespace)(kube_pod_container_resource_requests{resource='memory', unit='byte'}), 'cluster', '$input{cluster}')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "total_cpu_requested" {
    unit = "count"

    source prometheus "total_cpu_requested" {
      query = "label_set(sum by (cluster, namespace) (kube_pod_container_resource_requests{resource='cpu', unit='core'}), 'cluster', '$input{cluster}')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "total_unscheduled_pods" {
    unit = "count"

    source prometheus "total_unscheduled_pods" {
      query = "label_set(sum by (cluster, namespace) (kube_pod_status_unschedulable{}), 'cluster', '$input{cluster}')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "total_failed_and_unknown_pods" {
    unit = "count"

    source prometheus "total_failed_and_unknown_pods" {
      query = "label_set(sum by (cluster, namespace) (kube_pod_status_phase{phase=~'Failed|Unknown'}), 'cluster', '$input{cluster}')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "total_container_restarts" {
    unit = "count"

    source prometheus "total_container_restarts" {
      query = "label_set(sum by (cluster, namespace) (kube_pod_container_status_restarts_total{}), 'cluster', '$input{cluster}')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }
}


ingester prometheus_kube_node module {
  frequency  = 600
  lookback   = 900
  timeout    = 180
  resolution = 60
  lag        = 60


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
      query = "label_set(sum by (cluster, node) (kube_node_status_allocatable{resource='cpu', unit='core'}) - sum by (cluster, node) (kube_pod_container_resource_limits{resource='cpu', unit='core'}), 'cluster', '$input{cluster}')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "total_memory_for_scheduling" {
    unit = "bytes"

    source prometheus "total_memory_for_scheduling" {
      query = "label_set(sum by (cluster, node) (kube_node_status_allocatable{resource='memory', unit='byte'}) - sum by (cluster, node) (kube_pod_container_resource_limits{resource='memory', unit='byte'}), 'cluster', '$input{cluster}')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "out_of_pods" {
    unit = "count"

    source prometheus "out_of_pods" {
      query = "label_set(sum by (cluster, node) (kube_node_spec_unschedulable{}), 'cluster', '$input{cluster}')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "high_disk_pressure" {
    unit = "count"

    source prometheus "high_disk_pressure" {
      query = "label_set(sum by (cluster, node) (kube_node_status_condition{condition='DiskPressure', status='true'}), 'cluster', '$input{cluster}')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "high_memory_pressure" {
    unit = "count"

    source prometheus "high_memory_pressure" {
      query = "label_set(sum by (cluster, node) (kube_node_status_condition{condition='MemoryPressure', status='true'}), 'cluster', '$input{cluster}')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "high_pid_pressure" {
    unit = "count"

    source prometheus "high_pid_pressure" {
      query = "label_set(sum by (cluster, node) (kube_node_status_condition{condition='PIDPressure', status='true'}), 'cluster', '$input{cluster}')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }
}

ingester prometheus_kube_pod_grp module {
  frequency  = 600
  lookback   = 900
  timeout    = 180
  resolution = 60
  lag        = 60


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
    type = "kube_pod_grp"
    name = <<EOT
        format("%s%s on %s", "$output{pod_group}", "$output{namespace}", "$input{cluster}")
       EOT
  }

  logical_parent_nodes = [
    {
      type = "kube_virtual_cluster"
      name = "$output{cluster}-$output{namespace}"
    },
    {
      type = "kube_pods"
      name = "Pods in $output{namespace} on $input{cluster}"
    }
  ]

  using = {
    "default" : "$input{using}"
  }

  gauge "total_container_restarts" {
    unit = "count"

    source prometheus "total_container_restarts" {
      query = <<EOT
        "label_set(sum without (pod) (label_replace((sum by (cluster, namespace, pod_group, pod) (kube_pod_container_status_restarts_total{})), 'pod_group', '$1', 'pod', '(\\D+)-(.*)')), 'cluster', '$input{cluster}')"
        EOT
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "total_containers_in_error" {
    unit = "count"

    source prometheus "total_containers_in_error" {
      query = <<EOT
        label_set(sum without (pod) (label_replace((sum by (cluster, namespace, pod_group, pod) (kube_pod_container_status_terminated_reason{reason!='Completed'})), 'pod_group', '$1', 'pod', '(\\D+)-(.*)')), 'cluster', '$input{cluster}')
        EOT
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "running_vs_waiting_containers" {
    unit = "count"

    source prometheus "running_vs_waiting_containers" {
      query = <<EOT
        label_set(sum without (pod) (label_replace((sum by (cluster, namespace, pod) (kube_pod_container_status_running{}) - sum by (cluster, namespace, pod) (kube_pod_container_status_waiting{})), 'pod_group', '$1', 'pod', '(\\D+)-(.*)')), 'cluster', '$input{cluster}')
        EOT
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }
}

ingester prometheus_kube_pod module {
  frequency  = 600
  lookback   = 900
  timeout    = 180
  resolution = 60
  lag        = 60


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
      name = "Pods in $output{namespace} on $input{cluster}"
    },
    {
      type = "kube_pods_grp"
      name = <<EOT
        format("%s%s on %s", "$output{pod_group}", "$output{namespace}", "$input{cluster}")
       EOT
    },
  ]

  using = {
    "default" : "$input{using}"
  }

  gauge "total_container_restarts" {
    unit = "count"

    source prometheus "total_container_restarts" {
      query = <<EOT
        label_set(label_replace((sum by (cluster, namespace, pod_group, pod) (kube_pod_container_status_restarts_total{})), 'pod_group', '$1', 'pod', '(\\D+)-(.*)'), 'cluster', '$input{cluster}')
        EOT
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "total_containers_in_error" {
    unit = "count"

    source prometheus "total_containers_in_error" {
      query = <<EOT
        label_set(label_replace((sum by (cluster, namespace, pod) (kube_pod_container_status_terminated_reason{reason!='Completed'})), 'pod_group', '$1', 'pod', '(\\D+)-(.*)'), 'cluster', '$input{cluster}')
        EOT
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "running_vs_waiting_containers" {
    unit = "count"

    source prometheus "running_vs_waiting_containers" {
      query = <<EOT
        label_set(label_replace((sum by (cluster, namespace, pod) (kube_pod_container_status_running{}) - sum by (cluster, namespace, pod) (kube_pod_container_status_waiting{})), 'pod_group', '$1', 'pod', '(\\D+)-(.*)'), 'cluster', '$input{cluster}')
        EOT
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }
}


ingester prometheus_kube_container module {
  frequency  = 600
  lookback   = 900
  timeout    = 180
  resolution = 60
  lag        = 60


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
    name = "$output{container}-$output{pod}"
  }

  logical_parent_nodes = [
    {
      type = "kube_virtual_cluster"
      name = "$output{cluster}-$output{namespace}"
    },
    {
      type = "kube_pods"
      name = "Pods in $output{namespace} on $input{cluster}"
    },
    {
      type = "kube_pods_grp"
      name = <<EOT
        format("%s%s on %s", "$output{pod_group}", "$output{namespace}", "$input{cluster}")
       EOT
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
      query = <<EOT
          label_set(label_replace((sum by (cluster, namespace, pod, container) (kube_pod_container_status_restarts_total{})), 'pod_group', '$1', 'pod', '(\\D+)-(.*)'), 'cluster', '$input{cluster}')
        EOT
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "container_in_terminated" {
    unit = "count"

    source prometheus "container_in_terminated" {
      query = <<EOT
          label_set(label_replace((sum by (cluster, namespace, pod, container) (kube_pod_container_status_terminated_reason{reason!='Completed'})), 'pod_group', '$1', 'pod', '(\\D+)-(.*)'), 'cluster', '$input{cluster}')
        EOT
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "container_in_waiting" {
    unit = "count"

    source prometheus "container_in_waiting" {
      query = <<EOT
          label_set(label_replace((sum by (cluster, namespace, pod, container) (kube_pod_container_status_waiting_reason{reason!='ContainerCreating', reason!='PodInitializing'})), 'pod_group', '$1', 'pod', '(\\D+)-(.*)'), 'cluster', '$input{cluster}')
        EOT
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "container_cpu_limit" {
    unit = "count"

    source prometheus "container_cpu_limit" {
      query = <<EOT
          label_set(label_replace((sum by (cluster, namespace, pod, container) (kube_pod_container_resource_limits{resource='cpu', unit='core'})), 'pod_group', '$1', 'pod', '(\\D+)-(.*)'), 'cluster', '$input{cluster}')
          EOT
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "container_memory_limit" {
    unit = "bytes"

    source prometheus "container_memory_limit" {
      query = <<EOT
        label_set(label_replace((sum by (cluster, namespace, pod, container) (kube_pod_container_resource_limits{resource='memory', unit='byte'})), 'pod_group', '$1', 'pod', '(\\D+)-(.*)'), 'cluster', '$input{cluster}')
        EOT
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }
}

ingester prometheus_kube_deployment module {
  frequency  = 600
  lookback   = 900
  timeout    = 180
  resolution = 60
  lag        = 60


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
      name = "Deployments in $output{namespace} on $input{cluster}"
    },
  ]

  using = {
    "default" : "$input{using}"
  }

  gauge "total_unavailable_replicas" {
    unit = "count"

    source prometheus "total_unavailable_replicas" {
      query = "label_set(sum by (cluster, namespace, deployment) (kube_deployment_status_replicas_unavailable{}), 'cluster', '$input{cluster}')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "total_updated_replicas" {
    unit = "count"

    source prometheus "total_updated_replicas" {
      query = "label_set(sum by (cluster, namespace, deployment) (kube_deployment_status_replicas_updated{}), 'cluster', '$input{cluster}')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "desired_vs_available_replicas" {
    unit = "count"
    source prometheus "desired_vs_available_replicas" {
      query = "label_set(sum by (cluster, namespace, deployment)(kube_deployment_status_replicas{}) - sum by (cluster, namespace, deployment) (kube_deployment_status_replicas_available{}), 'cluster', '$input{cluster}')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }
}
