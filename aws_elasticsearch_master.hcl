ingester aws_elasticsearch_master module {
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


  gauge "master_reachable" {
    unit = "count"
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
    unit = "percentage"
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
    unit = "count"
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
