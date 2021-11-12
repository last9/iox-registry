ingester prometheus_kube_cluster module {
  frequency  = 120
  lookback   = 600
  timeout    = 90
  resolution = 60
  lag        = 60

  inputs = "$input{inputs}"

  label {
    type = "service"
    name = "$input{service}"
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

  gauge "available_nodes" {
    unit = "count"

    source prometheus "available_nodes" {
      query = <<EOF
      label_set(sum by (cluster)(kube_node_status_condition{condition='Ready', status='true'})/
      sum by (cluster)(kube_node_status_condition{condition='Ready'}), 'cluster', '$input{cluster}')
      EOF
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "disk_pressure_nodes" {
    unit = "count"

    source prometheus "disk_pressure_nodes" {
      query = <<EOF
      label_set(sum by (cluster)(kube_node_status_condition{condition='DiskPressure', status='true'})/
      sum by (cluster)(kube_node_status_condition{condition='DiskPressure'}), 'cluster', '$input{cluster}')
      EOF
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "pid_pressure_nodes" {
    unit = "count"

    source prometheus "pid_pressure_nodes" {
      query = <<EOF
      label_set(sum by (cluster)(kube_node_status_condition{condition='PIDPressure', status='true'})/
      sum by (cluster)(kube_node_status_condition{condition='PIDPressure'}), 'cluster', '$input{cluster}')
      EOF
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "memory_pressure_nodes" {
    unit = "count"

    source prometheus "memory_pressure_nodes" {
      query = <<EOF
      label_set(sum by (cluster)(kube_node_status_condition{condition='MemoryPressure', status='true'})/
      sum by (cluster)(kube_node_status_condition{condition='MemoryPressure'}), 'cluster', '$input{cluster}')
      EOF
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "requested_memory" {
    unit = "bytes"

    source prometheus "requested_memory" {
      query = "label_set(sum(kube_pod_container_resource_requests{resource='memory', unit='byte'})/sum by (cluster)(kube_node_status_allocatable{resource='memory', unit='byte'}), 'cluster', '$input{cluster}')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "requested_cpu" {
    unit = "count"

    source prometheus "requested_cpu" {
      query = "label_set(sum(kube_pod_container_resource_requests{resource='cpu', unit='core'})/sum by (cluster)(kube_node_status_allocatable{resource='cpu', unit='core'}), 'cluster', '$input{cluster}')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "saturated_nodes" {
    unit = "count"

    source prometheus "saturated_nodes" {
      query = "label_set(sum by (cluster) (kube_node_spec_unschedulable{}), 'cluster', '$input{cluster}')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }
}

ingester prometheus_kube_cluster_with_namespace module {
  frequency  = 120
  lookback   = 600
  timeout    = 90
  resolution = 60
  lag        = 60


  inputs = "$input{inputs}"

  label {
    type = "service"
    name = "$input{service}"
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

  gauge "unscheduled_pods" {
    unit = "count"

    source prometheus "unscheduled_pods" {
      query = "label_set(sum by (cluster, namespace) (increase(kube_pod_status_unschedulable{}[1m])), 'cluster', '$input{cluster}')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "desired_pods" {
    unit = "count"

    source prometheus "desired_pods" {
      query = "label_set(sum by (cluster, namespace) (increase(kube_pod_status_phase{}[1m])), 'cluster', '$input{cluster}')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "running_pods" {
    unit = "count"

    source prometheus "running_pods" {
      query = "label_set(sum by (cluster, namespace) (kube_pod_status_phase{phase=~'Running'}), 'cluster', '$input{cluster}')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "pending_pods" {
    unit = "count"

    source prometheus "pending_pods" {
      query = "label_set(sum by (cluster, namespace) (kube_pod_status_phase{phase=~'Pending'}), 'cluster', '$input{cluster}')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "failed_and_unknown_pods" {
    unit = "count"

    source prometheus "failed_and_unknown_pods" {
      query = "label_set(sum by (cluster, namespace) (kube_pod_status_phase{phase=~'Failed|Unknown'}), 'cluster', '$input{cluster}')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "container_restarts" {
    unit = "count"

    source prometheus "container_restarts" {
      query = "label_set(sum by (cluster, namespace) (kube_pod_container_status_restarts_total{}), 'cluster', '$input{cluster}')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }
}

ingester prometheus_kube_node module {
  frequency  = 120
  lookback   = 600
  timeout    = 90
  resolution = 60
  lag        = 60


  inputs = "$input{inputs}"

  label {
    type = "service"
    name = "$input{service}"
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

  gauge "disk_pressure" {
    unit = "count"

    source prometheus "disk_pressure" {
      query = <<EOF
      label_set(sum by (cluster, node)(kube_node_status_condition{condition='DiskPressure', status='true'})/
      sum by (cluster, node)(kube_node_status_condition{condition='DiskPressure'}), 'cluster', '$input{cluster}')
      EOF
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "pid_pressure" {
    unit = "count"

    source prometheus "pid_pressure" {
      query = <<EOF
      label_set(sum by (cluster, node)(kube_node_status_condition{condition='PIDPressure', status='true'})/
      sum by (cluster, node)(kube_node_status_condition{condition='PIDPressure'}), 'cluster', '$input{cluster}')
      EOF
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "memory_pressure" {
    unit = "count"

    source prometheus "memory_pressure" {
      query = <<EOF
      label_set(sum by (cluster, node)(kube_node_status_condition{condition='MemoryPressure', status='true'})/
      sum by (cluster, node)(kube_node_status_condition{condition='MemoryPressure'}), 'cluster', '$input{cluster}')
      EOF
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "saturated" {
    unit = "count"

    source prometheus "saturated" {
      query = "label_set(sum by (cluster, node) (kube_node_spec_unschedulable{}), 'cluster', '$input{cluster}')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }
}

ingester prometheus_kube_pod_grp module {
  frequency  = 120
  lookback   = 600
  timeout    = 90
  resolution = 60
  lag        = 60


  inputs = "$input{inputs}"

  label {
    type = "service"
    name = "$input{service}"
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
    name = "$output{pod_group}$output{namespace} on $input{cluster}"
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

  gauge "container_restarted" {
    unit = "count"

    source prometheus "container_restarted" {
      query = <<EOT
      label_set(sum without (pod) (label_replace((sum by (cluster, namespace, pod_group, pod) (kube_pod_container_status_restarts_total{})), 'pod_group', '$1', 'pod', '(\\D+)-(.*)')), 'cluster', '$input{cluster}')
      EOT
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "containers_failed" {
    unit = "count"

    source prometheus "containers_failed" {
      query = <<EOT
      label_set(sum without (pod) (label_replace((sum by (cluster, namespace, pod_group, pod) (kube_pod_container_status_terminated_reason{reason!='Completed'})), 'pod_group', '$1', 'pod', '(\\D+)-(.*)')), 'cluster', '$input{cluster}')
      EOT
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "containers_running" {
    unit = "count"

    source prometheus "containers_running" {
      query = <<EOT
      label_set(sum without (pod) (label_replace((sum by (cluster, namespace, pod_group, pod) (kube_pod_container_status_running{})), 'pod_group', '$1', 'pod', '(\\D+)-(.*)')), 'cluster', '$input{cluster}')
      EOT
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "containers_desired" {
    unit = "count"

    source prometheus "containers_desired" {
      query = <<EOT
      label_set(sum without (pod) (label_replace((sum by (cluster, namespace, pod_group, pod) (kube_pod_container_status_terminated{}) + sum by (cluster, namespace, pod_group, pod) (kube_pod_container_status_running{}) + sum by (cluster, namespace, pod_group, pod) (kube_pod_container_status_waiting{})), 'pod_group', '$1', 'pod', '(\\D+)-(.*)')), 'cluster', '$input{cluster}')
      EOT
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "containers_cold" {
    unit = "count"

    source prometheus "containers_cold" {
      query = <<EOT
      label_set(sum without (pod) (label_replace((sum by (cluster, namespace, pod_group, pod) (kube_pod_container_status_running{}) - sum by (cluster, namespace, pod_group, pod) (kube_pod_container_status_ready{})), 'pod_group', '$1', 'pod', '(\\D+)-(.*)')), 'cluster', '$input{cluster}')
      EOT
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }
}

ingester prometheus_kube_pod module {
  frequency  = 120
  lookback   = 600
  timeout    = 90
  resolution = 60
  lag        = 60


  inputs = "$input{inputs}"

  label {
    type = "service"
    name = "$input{service}"
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
      type = "kube_pod_grp"
      name = "$output{pod_group}$output{namespace} on $input{cluster}"
    },
  ]

  using = {
    "default" : "$input{using}"
  }

  gauge "container_restarted" {
    unit = "count"

    source prometheus "container_restarted" {
      query = <<EOT
      label_set(label_replace((sum by (cluster, namespace, pod_group, pod) (kube_pod_container_status_restarts_total{})), 'pod_group', '$1', 'pod', '(\\D+)-(.*)'), 'cluster', '$input{cluster}')
      EOT
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "containers_failed" {
    unit = "count"

    source prometheus "containers_failed" {
      query = <<EOT
      label_set(label_replace((sum by (cluster, namespace, pod_group, pod) (kube_pod_container_status_terminated_reason{reason!='Completed'})), 'pod_group', '$1', 'pod', '(\\D+)-(.*)'), 'cluster', '$input{cluster}')
      EOT
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "containers_running" {
    unit = "count"

    source prometheus "containers_running" {
      query = <<EOT
      label_set(label_replace((sum by (cluster, namespace, pod_group, pod) (kube_pod_container_status_running{})), 'pod_group', '$1', 'pod', '(\\D+)-(.*)'), 'cluster', '$input{cluster}')
      EOT
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "containers_desired" {
    unit = "count"

    source prometheus "containers_desired" {
      query = <<EOT
      label_set(label_replace((sum by (cluster, namespace, pod_group, pod) (kube_pod_container_status_terminated{}) +  sum by (cluster, namespace, pod_group, pod) (kube_pod_container_status_running{}) +  sum by (cluster, namespace, pod_group, pod) (kube_pod_container_status_waiting{})), 'pod_group', '$1', 'pod', '(\\D+)-(.*)'), 'cluster', '$input{cluster}')
      EOT
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "containers_cold" {
    unit = "count"

    source prometheus "containers_cold" {
      query = <<EOT
      label_set(label_replace((sum by (cluster, namespace, pod_group, pod) (kube_pod_container_status_running{}) - sum by (cluster, namespace, pod_group, pod) (kube_pod_container_status_ready{})), 'pod_group', '$1', 'pod', '(\\D+)-(.*)'), 'cluster', '$input{cluster}')
      EOT
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }
}

ingester prometheus_kube_container module {
  frequency  = 120
  lookback   = 600
  timeout    = 90
  resolution = 60
  lag        = 60


  inputs = "$input{inputs}"

  label {
    type = "service"
    name = "$input{service}"
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
      type = "kube_pod_grp"
      name = "$output{pod_group}$output{namespace} on $input{cluster}"
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
      label_set(label_replace((sum by (cluster, namespace, pod_group, pod, container) (kube_pod_container_status_restarts_total{})), 'pod_group', '$1', 'pod', '(\\D+)-(.*)'), 'cluster', '$input{cluster}')
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
      label_set(label_replace((sum by (cluster, namespace, pod_group, pod, container) (kube_pod_container_status_terminated_reason{reason!='Completed'})), 'pod_group', '$1', 'pod', '(\\D+)-(.*)'), 'cluster', '$input{cluster}')
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
      label_set(label_replace((sum by (cluster, namespace, pod_group, pod, container) (kube_pod_container_status_waiting_reason{reason!='ContainerCreating', reason!='PodInitializing'})), 'pod_group', '$1', 'pod', '(\\D+)-(.*)'), 'cluster', '$input{cluster}')
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
      label_set(label_replace((sum by (cluster, namespace, pod_group, pod, container) (kube_pod_container_resource_limits{resource='cpu', unit='core'})), 'pod_group', '$1', 'pod', '(\\D+)-(.*)'), 'cluster', '$input{cluster}')
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
      label_set(label_replace((sum by (cluster, namespace, pod_group, pod, container) (kube_pod_container_resource_limits{resource='memory', unit='byte'})), 'pod_group', '$1', 'pod', '(\\D+)-(.*)'), 'cluster', '$input{cluster}')
      EOT
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }
}

ingester prometheus_kube_deployment module {
  frequency  = 120
  lookback   = 600
  timeout    = 90
  resolution = 60
  lag        = 60


  inputs = "$input{inputs}"

  label {
    type = "service"
    name = "$input{service}"
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

  gauge "unavailable_replicas" {
    unit = "count"

    source prometheus "unavailable_replicas" {
      query = "label_set(sum by (cluster, namespace, deployment) (kube_deployment_status_replicas_unavailable{}), 'cluster', '$input{cluster}')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "desired_replicas" {
    unit = "count"

    source prometheus "desired_replicas" {
      query = "label_set(sum by (cluster, namespace, deployment) (kube_deployment_spec_replicas{}), 'cluster', '$input{cluster}')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }


  gauge "cold_replicas" {
    unit = "count"
    source prometheus "cold_replicas" {
      query = "label_set(sum by (cluster, namespace, deployment) (kube_deployment_status_replicas{}) - sum by (cluster, namespace, deployment)(kube_deployment_status_replicas_available{}), 'cluster', '$input{cluster}')"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }
}
