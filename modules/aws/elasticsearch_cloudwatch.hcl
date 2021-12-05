ingester aws_elasticsearch_cloudwatch module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  label {
    type = "service"
    name = "$input{service}"
  }

  label {
    type = "namespace"
    name = "$input{namespace}"
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

  input_query = <<-EOF
  label_set(
    label_replace(
      es_domain{$input{tag_filter}}, 'id=DomainName'
    ), "service", "$input{service}", "namespace", "$input{namespace}"
  )
  EOF

  gauge "nodes" {
    index       = 1
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MIN"
    source cloudwatch "nodes" {
      query {
        aggregator  = "Minimum"
        namespace   = "AWS/ES"
        metric_name = "Nodes"

        dimensions = {
          "DomainName" = "$input{DomainName}"
          "ClientId"   = "$input{ClientId}"
        }
      }
    }
  }

  gauge "kibana_healthy_nodes" {
    index       = 2
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MIN"
    source cloudwatch "kibana_healthy_nodes" {
      query {
        aggregator  = "Minimum"
        namespace   = "AWS/ES"
        metric_name = "KibanaHealthyNodes"

        dimensions = {
          "DomainName" = "$input{DomainName}"
          "ClientId"   = "$input{ClientId}"
        }
      }
    }
  }

  gauge "cluster_yellow" {
    index       = 3
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"
    source cloudwatch "cluster_yellow" {
      query {
        aggregator  = "Maximum"
        namespace   = "AWS/ES"
        metric_name = "ClusterStatus.yellow"

        dimensions = {
          "DomainName" = "$input{DomainName}"
          "ClientId"   = "$input{ClientId}"
        }
      }
    }
  }

  gauge "cluster_red" {
    index       = 4
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"
    source cloudwatch "cluster_red" {
      query {
        aggregator  = "Maximum"
        namespace   = "AWS/ES"
        metric_name = "ClusterStatus.red"

        dimensions = {
          "DomainName" = "$input{DomainName}"
          "ClientId"   = "$input{ClientId}"
        }
      }
    }
  }

  gauge "throughput" {
    index       = 5
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"
    source cloudwatch "throughput" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/ES"
        metric_name = "ElasticsearchRequests"

        dimensions = {
          "DomainName" = "$input{DomainName}"
          "ClientId"   = "$input{ClientId}"
        }
      }
    }
  }

  gauge "status_4xx" {
    index       = 6
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"
    source cloudwatch "status_4xx" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/ES"
        metric_name = "4xx"

        dimensions = {
          "DomainName" = "$input{DomainName}"
          "ClientId"   = "$input{ClientId}"
        }
      }
    }
  }


  gauge "status_5xx" {
    index       = 7
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"
    source cloudwatch "5xx" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/ES"
        metric_name = "5xx"

        dimensions = {
          "DomainName" = "$input{DomainName}"
          "ClientId"   = "$input{ClientId}"
        }
      }
    }
  }

  gauge "cpu" {
    index       = 8
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "AVG"
    source cloudwatch "cpu" {
      query {
        aggregator  = "Average"
        namespace   = "AWS/ES"
        metric_name = "CPUUtilization"

        dimensions = {
          "DomainName" = "$input{DomainName}"
          "ClientId"   = "$input{ClientId}"
        }
      }
    }
  }


  gauge "free_space" {
    index       = 11
    input_unit  = "bytes"
    output_unit = "bytes"
    aggregator  = "MIN"
    source cloudwatch "free_space" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/ES"
        metric_name = "FreeStorageSpace"

        dimensions = {
          "DomainName" = "$input{DomainName}"
          "ClientId"   = "$input{ClientId}"
        }
      }
    }
  }

  gauge "jvm_memory_pressure" {
    index       = 12
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "AVG"
    source cloudwatch "jvm_memory_pressure" {
      query {
        aggregator  = "Maximum"
        namespace   = "AWS/ES"
        metric_name = "JVMMemoryPressure"

        dimensions = {
          "DomainName" = "$input{DomainName}"
          "ClientId"   = "$input{ClientId}"
        }
      }
    }
  }

  gauge "writes_blocked" {
    index       = 13
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"
    source cloudwatch "writes_blocked" {
      query {
        aggregator  = "Maximum"
        namespace   = "AWS/ES"
        metric_name = "ClusterIndexWritesBlocked"

        dimensions = {
          "DomainName" = "$input{DomainName}"
          "ClientId"   = "$input{ClientId}"
        }
      }
    }
  }

  gauge "snapshot_failure" {
    index       = 14
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"
    source cloudwatch "snapshot_failure" {
      query {
        aggregator  = "Maximum"
        namespace   = "AWS/ES"
        metric_name = "AutomatedSnapshotFailure"

        dimensions = {
          "DomainName" = "$input{DomainName}"
          "ClientId"   = "$input{ClientId}"
        }
      }
    }
  }

  gauge "master_reachable" {
    index       = 15
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MIN"
    source cloudwatch "master_reachable" {
      query {
        aggregator  = "Minimum"
        namespace   = "AWS/ES"
        metric_name = "MasterReachableFromNode"

        dimensions = {
          "DomainName" = "$input{DomainName}"
          "ClientId"   = "$input{ClientId}"
        }
      }
    }
  }

}

ingester aws_elasticsearch_master_cloudwatch module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  label {
    type = "service"
    name = "$input{service}"
  }

  label {
    type = "namespace"
    name = "$input{namespace}"
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

  input_query = <<-EOF
  label_set(
    label_replace(
      es_domain{$input{tag_filter}}, 'id=DomainName'
    ), "service", "$input{service}", "namespace", "$input{namespace}"
  )
  EOF


  gauge "master_reachable" {
    index       = 1
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MIN"
    source cloudwatch "master_reachable" {
      query {
        aggregator  = "Minimum"
        namespace   = "AWS/ES"
        metric_name = "MasterReachableFromNode"

        dimensions = {
          "DomainName" = "$input{DomainName}"
          "ClientId"   = "$input{ClientId}"
        }
      }
    }
  }

  gauge "cpu" {
    index       = 2
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "AVG"
    source cloudwatch "cpu" {
      query {
        aggregator  = "Average"
        namespace   = "AWS/ES"
        metric_name = "MasterCPUUtilization"

        dimensions = {
          "DomainName" = "$input{DomainName}"
          "ClientId"   = "$input{ClientId}"
        }
      }
    }
  }

  gauge "jvm_memory_pressure" {
    index       = 5
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "AVG"
    source cloudwatch "jvm_memory_pressure" {
      query {
        aggregator  = "Maximum"
        namespace   = "AWS/ES"
        metric_name = "MasterJVMMemoryPressure"

        dimensions = {
          "DomainName" = "$input{DomainName}"
          "ClientId"   = "$input{ClientId}"
        }
      }
    }
  }

}
