ingester aws_elasticsearch module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  label {
    type = "service"
    name = "$output{tag_service}"
  }

  label {
    type = "namespace"
    name = "$output{tag_namespace}"
  }

  physical_component {
    type = "aws_elasticsearch_cluster"
    name = "$input{DomainName}"
  }

  data_for_graph_node {
    type = "aws_elasticsearch_domain"
    name = "$input{DomainName}-domain"
  }

  using = {
    "default" : "$input{using}"
  }

  inputs = "$input{inputs}"

  gauge "nodes" {
    index       = 1
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MIN"
    source prometheus "nodes" {
      query = "min by (DomainName, ClientId, tag_namespace, tag_service) (nodes)"
      join_on = {
        "$output{DomainName}" = "$input{DomainName}"
        "$output{ClientId}"   = "$input{ClientId}"
      }
    }
  }

  gauge "kibana_healthy_nodes" {
    index       = 2
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MIN"
    source prometheus "kibana_healthy_nodes" {
      query = "min by (DomainName, ClientId, tag_namespace, tag_service) (kibana_healthy_nodes)"
      join_on = {
        "$output{DomainName}" = "$input{DomainName}"
        "$output{ClientId}"   = "$input{ClientId}"
      }
    }
  }

  gauge "cluster_yellow" {
    index       = 3
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"
    source prometheus "cluster_yellow" {
      query = "max by (DomainName, ClientId, tag_namespace, tag_service) (cluster_yellow)"
      join_on = {
        "$output{DomainName}" = "$input{DomainName}"
        "$output{ClientId}"   = "$input{ClientId}"
      }
    }
  }

  gauge "cluster_red" {
    index       = 4
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"
    source prometheus "cluster_red" {
      query = "max by (DomainName, ClientId, tag_namespace, tag_service) (cluster_red)"
      join_on = {
        "$output{DomainName}" = "$input{DomainName}"
        "$output{ClientId}"   = "$input{ClientId}"
      }
    }
  }

  gauge "throughput" {
    index       = 5
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"
    source prometheus "throughput" {
      query = "sum by (DomainName, ClientId, tag_namespace, tag_service) (throughput)"
      join_on = {
        "$output{DomainName}" = "$input{DomainName}"
        "$output{ClientId}"   = "$input{ClientId}"
      }
    }
  }

  gauge "status_4xx" {
    index       = 6
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"
    source prometheus "status_4xx" {
      query = "sum by (DomainName, ClientId, tag_namespace, tag_service) (status_4xx)"
      join_on = {
        "$output{DomainName}" = "$input{DomainName}"
        "$output{ClientId}"   = "$input{ClientId}"
      }
    }
  }


  gauge "status_5xx" {
    index       = 7
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"
    source prometheus "status_5xx" {
      query = "sum by (DomainName, ClientId, tag_namespace, tag_service) (status_5xx)"
      join_on = {
        "$output{DomainName}" = "$input{DomainName}"
        "$output{ClientId}"   = "$input{ClientId}"
      }
    }
  }

  gauge "cpu" {
    index       = 8
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "AVG"
    source prometheus "cpu" {
      query = "avg by (DomainName, ClientId, tag_namespace, tag_service) (cpu)"
      join_on = {
        "$output{DomainName}" = "$input{DomainName}"
        "$output{ClientId}"   = "$input{ClientId}"
      }
    }
  }


  gauge "free_space" {
    index       = 11
    input_unit  = "bytes"
    output_unit = "bytes"
    aggregator  = "MIN"
    source prometheus "free_space" {
      query = "min by (DomainName, ClientId, tag_namespace, tag_service) (free_space)"
      join_on = {
        "$output{DomainName}" = "$input{DomainName}"
        "$output{ClientId}"   = "$input{ClientId}"
      }
    }
  }

  gauge "jvm_memory_pressure" {
    index       = 12
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "AVG"
    source prometheus "jvm_memory_pressure" {
      query = "avg by (DomainName, ClientId, tag_namespace, tag_service) (jvm_memory_pressure)"
      join_on = {
        "$output{DomainName}" = "$input{DomainName}"
        "$output{ClientId}"   = "$input{ClientId}"
      }
    }
  }

  gauge "writes_blocked" {
    index       = 13
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"
    source prometheus "writes_blocked" {
      query = "max by (DomainName, ClientId, tag_namespace, tag_service) (writes_blocked)"
      join_on = {
        "$output{DomainName}" = "$input{DomainName}"
        "$output{ClientId}"   = "$input{ClientId}"
      }
    }
  }

  gauge "snapshot_failure" {
    index       = 14
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"
    source prometheus "snapshot_failure" {
      query = "max by (DomainName, ClientId, tag_namespace, tag_service) (snapshot_failure)"
      join_on = {
        "$output{DomainName}" = "$input{DomainName}"
        "$output{ClientId}"   = "$input{ClientId}"
      }
    }
  }

  gauge "master_reachable" {
    index       = 15
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MIN"
    source prometheus "master_reachable" {
      query = "min by (DomainName, ClientId, tag_namespace, tag_service) (master_reachable)"
      join_on = {
        "$output{DomainName}" = "$input{DomainName}"
        "$output{ClientId}"   = "$input{ClientId}"
      }
    }
  }

}

ingester aws_elasticsearch_master module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  label {
    type = "service"
    name = "$output{tag_service}"
  }

  label {
    type = "namespace"
    name = "$output{tag_namespace}"
  }

  physical_component {
    type = "aws_elasticsearch_cluster"
    name = "$input{DomainName}"
  }

  data_for_graph_node {
    type = "aws_elasticsearch_master"
    name = "MasterNode"
  }

  logical_parent_nodes = [
    {
      type = "aws_elasticsearch_domain"
      name = "$input{DomainName}-domain"
    },
  ]

  using = {
    "default" : "$input{using}"
  }

  inputs = "$input{inputs}"

  gauge "master_reachable" {
    index       = 1
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MIN"
    source prometheus "master_reachable" {
      query = "min by (DomainName, ClientId, tag_namespace, tag_service) (master_reachable)"
      join_on = {
        "$output{DomainName}" = "$input{DomainName}"
        "$output{ClientId}"   = "$input{ClientId}"
      }
    }
  }

  gauge "cpu" {
    index       = 2
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "AVG"
    source prometheus "cpu" {
      query = "avg by (DomainName, ClientId, tag_namespace, tag_service) (cpu)"
      join_on = {
        "$output{DomainName}" = "$input{DomainName}"
        "$output{ClientId}"   = "$input{ClientId}"
      }
    }
  }

  gauge "jvm_memory_pressure" {
    index       = 5
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "AVG"
    source prometheus "jvm_memory_pressure" {
      query = "avg by (DomainName, ClientId, tag_namespace, tag_service) (jvm_memory_pressure))"
      join_on = {
        "$output{DomainName}" = "$input{DomainName}"
        "$output{ClientId}"   = "$input{ClientId}"
      }
    }
  }

}
