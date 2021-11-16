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
    index       = 1
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MIN"


    source prometheus "available_nodes" {
      query = <<EOF
      sum by (cluster)(kube_node_status_condition{condition='Ready', status='true'})/
      sum by (cluster)(kube_node_status_condition{condition='Ready'})
      EOF
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "disk_pressure_nodes" {
    index       = 2
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"

    source prometheus "disk_pressure_nodes" {
      query = <<EOF
      sum by (cluster)(kube_node_status_condition{condition='DiskPressure', status='true'})/
      sum by (cluster)(kube_node_status_condition{condition='DiskPressure'})
      EOF
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "pid_pressure_nodes" {
    index       = 3
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"

    source prometheus "pid_pressure_nodes" {
      query = <<EOF
      sum by (cluster)(kube_node_status_condition{condition='PIDPressure', status='true'})/
      sum by (cluster)(kube_node_status_condition{condition='PIDPressure'})
      EOF
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "memory_pressure_nodes" {
    index       = 4
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"

    source prometheus "memory_pressure_nodes" {
      query = <<EOF
      sum by (cluster)(kube_node_status_condition{condition='MemoryPressure', status='true'})/
      sum by (cluster)(kube_node_status_condition{condition='MemoryPressure'})
      EOF
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "requested_memory" {
    index       = 5
    input_unit  = "bytes"
    output_unit = "bytes"
    aggregator  = "MAX"

    source prometheus "requested_memory" {
      query = "sum(kube_pod_container_resource_requests{resource='memory', unit='byte'})/sum by (cluster)(kube_node_status_allocatable{resource='memory', unit='byte'})"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "requested_cpu" {
    index       = 6
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"

    source prometheus "requested_cpu" {
      query = "sum(kube_pod_container_resource_requests{resource='cpu', unit='core'})/sum by (cluster)(kube_node_status_allocatable{resource='cpu', unit='core'})"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "saturated_nodes" {
    index       = 7
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"

    source prometheus "saturated_nodes" {
      query = "sum by (cluster) (kube_node_spec_unschedulable{})"
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
    index       = 2
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"

    source prometheus "unscheduled_pods" {
      query = "sum by (cluster, namespace) (increase(kube_pod_status_unschedulable{}[1m]))"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "desired_pods" {
    index       = 6
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"

    source prometheus "desired_pods" {
      query = "sum by (cluster, namespace) (increase(kube_pod_status_phase{}[1m]))"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "running_pods" {
    index       = 5
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"

    source prometheus "running_pods" {
      query = "sum by (cluster, namespace) (kube_pod_status_phase{phase=~'Running'})"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "pending_pods" {
    index       = 4
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"

    source prometheus "pending_pods" {
      query = "sum by (cluster, namespace) (kube_pod_status_phase{phase=~'Pending'})"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "failed_and_unknown_pods" {
    index       = 1
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"

    source prometheus "failed_and_unknown_pods" {
      query = "sum by (cluster, namespace) (kube_pod_status_phase{phase=~'Failed|Unknown'})"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "container_restarts" {
    index       = 3
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "container_restarts" {
      query = "sum by (cluster, namespace) (kube_pod_container_status_restarts_total{})"
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
    index       = 2
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"

    source prometheus "disk_pressure" {
      query = <<EOF
      sum by (cluster, node)(kube_node_status_condition{condition='DiskPressure', status='true'})/
      sum by (cluster, node)(kube_node_status_condition{condition='DiskPressure'})
      EOF
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "pid_pressure" {
    index       = 3
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"

    source prometheus "pid_pressure" {
      query = <<EOF
      sum by (cluster, node)(kube_node_status_condition{condition='PIDPressure', status='true'})/
      sum by (cluster, node)(kube_node_status_condition{condition='PIDPressure'})
      EOF
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "memory_pressure" {
    index       = 4
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"

    source prometheus "memory_pressure" {
      query = <<EOF
      sum by (cluster, node)(kube_node_status_condition{condition='MemoryPressure', status='true'})/
      sum by (cluster, node)(kube_node_status_condition{condition='MemoryPressure'})
      EOF
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "saturated" {
    index       = 7
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"

    source prometheus "saturated" {
      query = "sum by (cluster, node) (kube_node_spec_unschedulable{})"
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
    index       = 1
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "AVG"

    source prometheus "container_restarted" {
      query = <<EOT
      sum without (pod) (label_replace((sum by (cluster, namespace, pod_group, pod) (kube_pod_container_status_restarts_total{})), 'pod_group', '$1', 'pod', '(\\D+)-(.*)'))
      EOT
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "containers_failed" {
    index       = 2
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "AVG"

    source prometheus "containers_failed" {
      query = <<EOT
      sum without (pod) (label_replace((sum by (cluster, namespace, pod_group, pod) (kube_pod_container_status_terminated_reason{reason!='Completed'})), 'pod_group', '$1', 'pod', '(\\D+)-(.*)'))
      EOT
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "containers_running" {
    index       = 4
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "AVG"

    source prometheus "containers_running" {
      query = <<EOT
      sum without (pod) (label_replace((sum by (cluster, namespace, pod_group, pod) (kube_pod_container_status_running{})), 'pod_group', '$1', 'pod', '(\\D+)-(.*)'))
      EOT
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "containers_desired" {
    index       = 5
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "AVG"

    source prometheus "containers_desired" {
      query = <<EOT
      sum without (pod) (label_replace((sum by (cluster, namespace, pod_group, pod) (kube_pod_container_status_terminated{}) +  sum by (cluster, namespace, pod_group, pod) (kube_pod_container_status_running{}) +  sum by (cluster, namespace, pod_group, pod) (kube_pod_container_status_waiting{})), 'pod_group', '$1', 'pod', '(\\D+)-(.*)'))
      EOT
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "containers_cold" {
    index       = 6
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "AVG"

    source prometheus "containers_cold" {
      query = <<EOT
      sum without (pod) (label_replace((sum by (cluster, namespace, pod_group, pod) (kube_pod_container_status_running{}) - sum by (cluster, namespace, pod_group, pod) (kube_pod_container_status_ready{})), 'pod_group', '$1', 'pod', '(\\D+)-(.*)'))
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
    index       = 1
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "AVG"

    source prometheus "container_restarted" {
      query = <<EOT
      label_replace((sum by (cluster, namespace, pod_group, pod) (kube_pod_container_status_restarts_total{})), 'pod_group', '$1', 'pod', '(\\D+)-(.*)')
      EOT
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "containers_failed" {
    index       = 2
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "AVG"

    source prometheus "containers_failed" {
      query = <<EOT
      label_replace((sum by (cluster, namespace, pod_group, pod) (kube_pod_container_status_terminated_reason{reason!='Completed'})), 'pod_group', '$1', 'pod', '(\\D+)-(.*)')
      EOT
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "containers_running" {
    index       = 4
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "AVG"

    source prometheus "containers_failed" {
      query = <<EOT
      label_replace((sum by (cluster, namespace, pod_group, pod) (kube_pod_container_status_running{})), 'pod_group', '$1', 'pod', '(\\D+)-(.*)')
      EOT
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "containers_desired" {
    index       = 5
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "AVG"

    source prometheus "containers_desired" {
      query = <<EOT
      label_replace((sum by (cluster, namespace, pod_group, pod) (kube_pod_container_status_terminated{}) + sum by (cluster, namespace, pod_group, pod) (kube_pod_container_status_running{}) + sum by (cluster, namespace, pod_group, pod) (kube_pod_container_status_waiting{})), 'pod_group', '$1', 'pod', '(\\D+)-(.*)')
      EOT
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "containers_cold" {
    index       = 6
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "AVG"

    source prometheus "containers_cold" {
      query = <<EOT
      label_replace((sum by (cluster, namespace, pod_group, pod) (kube_pod_container_status_running{}) - sum by (cluster, namespace, pod_group, pod) (kube_pod_container_status_ready{})), 'pod_group', '$1', 'pod', '(\\D+)-(.*)')
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
    index       = 1
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "total_container_restarts" {
      query = <<EOT
      label_replace((sum by (cluster, namespace, pod_group, pod, container) (kube_pod_container_status_restarts_total{pod!~'sshjump.*'})), 'pod_group', '$1', 'pod', '(\\D+)-(.*)')
      EOT
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "container_in_terminated" {
    index       = 2
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "container_in_terminated" {
      query = <<EOT
      label_replace((sum by (cluster, namespace, pod_group, pod, container) (kube_pod_container_status_terminated_reason{reason!='Completed'})), 'pod_group', '$1', 'pod', '(\\D+)-(.*)')
      EOT
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "container_in_waiting" {
    index       = 2
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "container_in_waiting" {
      query = <<EOT
      label_replace((sum by (cluster, namespace, pod_group, pod, container) (kube_pod_container_status_waiting_reason{reason!='ContainerCreating', reason!='PodInitializing'})), 'pod_group', '$1', 'pod', '(\\D+)-(.*)')
      EOT
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "container_cpu_limit" {
    index       = 4
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "AVG"

    source prometheus "container_cpu_limit" {
      query = <<EOT
      label_replace((sum by (cluster, namespace, pod_group, pod, container) (kube_pod_container_resource_limits{resource='cpu', unit='core'})), 'pod_group', '$1', 'pod', '(\\D+)-(.*)')
      EOT
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "container_memory_limit" {
    index       = 5
    input_unit  = "bytes"
    output_unit = "bytes"
    aggregator  = "AVG"

    source prometheus "container_memory_limit" {
      query = <<EOT
      label_replace((sum by (cluster, namespace, pod_group, pod, container) (kube_pod_container_resource_limits{resource='memory', unit='byte'})), 'pod_group', '$1', 'pod', '(\\D+)-(.*)')
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
    index       = 1
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"

    source prometheus "unavailable_replicas" {
      query = "sum by (cluster, namespace, deployment) (kube_deployment_status_replicas_unavailable{})"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }

  gauge "desired_replicas" {
    index       = 4
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"

    source prometheus "desired_replicas" {
      query = "sum by (cluster, namespace, deployment) (kube_deployment_spec_replicas{})"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }


  gauge "cold_replicas" {
    index       = 5
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"
    source prometheus "cold_replicas" {
      query = "sum by (cluster, namespace, deployment) (kube_deployment_status_replicas{}) - sum by (cluster, namespace, deployment)(kube_deployment_status_replicas_available{})"
      join_on = {
        "$output{cluster}" = "$input{cluster}"
      }
    }
  }
}
