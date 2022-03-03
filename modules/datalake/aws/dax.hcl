ingester aws_dax module {
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

  physical_address {
    type = "dax_node"
    name = "$input{NodeId}"
  }

  physical_component {
    type = "dax_cluster"
    name = "$input{ClusterId}"
  }

  data_for_graph_node {
    type = "dax"
    name = "$input{ClusterId}-dax"
  }

  using = {
    default = "$input{using}"
  }

  inputs = "$input{inputs}"

  gauge "throughput" {
    index       = 1
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"
    source prometheus "throughput" {
      query = "sum by (ClusterId, NodeId, tag_namespace, tag_service) (throughput)"
      join_on = {
        "$output{ClusterId}" = "$input{ClusterId}"
        "$output{NodeId}"    = "$input{NodeId}"
      }
    }
  }
  gauge "errored" {
    index       = 2
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"
    source prometheus "errored" {
      query = "sum by (ClusterId, NodeId, tag_namespace, tag_service) (errored)"
      join_on = {
        "$output{ClusterId}" = "$input{ClusterId}"
        "$output{NodeId}"    = "$input{NodeId}"
      }
    }
  }
  gauge "throttled" {
    index       = 3
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"
    source prometheus "throttled" {
      query = "sum by (ClusterId, NodeId, tag_namespace, tag_service) (throttled)"
      join_on = {
        "$output{ClusterId}" = "$input{ClusterId}"
        "$output{NodeId}"    = "$input{NodeId}"
      }
    }
  }
  gauge "connections" {
    index       = 4
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"
    source prometheus "connections" {
      query = "max by (ClusterId, NodeId, tag_namespace, tag_service) (connections)"
      join_on = {
        "$output{ClusterId}" = "$input{ClusterId}"
        "$output{NodeId}"    = "$input{NodeId}"
      }
    }
  }
  gauge "query_miss" {
    index       = 5
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"
    source prometheus "query_miss" {
      query = "sum by (ClusterId, NodeId, tag_namespace, tag_service) (query_miss)"
      join_on = {
        "$output{ClusterId}" = "$input{ClusterId}"
        "$output{NodeId}"    = "$input{NodeId}"
      }
    }
  }
  gauge "cache_memory" {
    index       = 6
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "AVG"
    source prometheus "cache_memory" {
      query = "sum by (ClusterId, NodeId, tag_namespace, tag_service) (cache_memory)"
      join_on = {
        "$output{ClusterId}" = "$input{ClusterId}"
        "$output{NodeId}"    = "$input{NodeId}"
      }
    }
  }
  gauge "cpu" {
    index       = 7
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "AVG"
    source prometheus "cpu" {
      query = "sum by (ClusterId, NodeId, tag_namespace, tag_service) (cpu)"
      join_on = {
        "$output{ClusterId}" = "$input{ClusterId}"
        "$output{NodeId}"    = "$input{NodeId}"
      }
    }
  }
}
