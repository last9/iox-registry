ingester aws_dax_cloudstream module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  inputs = "$input{inputs}"

  label {
    type = "service"
    name = "$input{service}"
  }

  label {
    type = "namespace"
    name = "$input{namespace}"
  }

  physical_address {
    type = "dax_node"
    name = "$output{NodeId}"
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

  gauge "throughput" {
    index       = 1
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"
    source prometheus "throughput" {
      query = "sum by (ClusterId, NodeId) (amazonaws_com_AWS_DAX_TotalRequestCount_sum{ClusterId=~'$input{ClusterId}',NodeId!=''})"

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
    source prometheus "errors" {
      query = "sum by (ClusterId) (amazonaws_com_AWS_DAX_ErrorRequestCount_sum{ClusterId=~'$input{ClusterId}',NodeId='$input{NodeId}'})"

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
      query = "sum by (ClusterId) (amazonaws_com_AWS_DAX_ThrottledRequestCount_sum{ClusterId=~'$input{ClusterId}',NodeId='$input{NodeId}'})"

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
      query = "sum by (ClusterId) (amazonaws_com_AWS_DAX_ClientConnections{quantile='1',ClusterId=~'$input{ClusterId}',NodeId='$input{NodeId}'})"

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
    source prometheus "memory" {
      query = "sum by (ClusterId) (amazonaws_com_AWS_DAX_QueryCacheMisses_sum{ClusterId=~'$input{ClusterId}',NodeId='$input{NodeId}'})"

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
    source prometheus "memory" {
      query = "sum by (ClusterId) (amazonaws_com_AWS_DAX_CacheMemoryUtilization_sum{ClusterId=~'$input{ClusterId}',NodeId='$input{NodeId}'}) / sum by (ClusterId) (amazonaws_com_AWS_DAX_CacheMemoryUtilization_count{ClusterId=~'$input{ClusterId}',NodeId='$input{NodeId}'})"

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
      query = "sum by (ClusterId) (amazonaws_com_AWS_DAX_CPUUtilization_sum{ClusterId=~'$input{ClusterId}',NodeId='$input{NodeId}'}) / sum by (ClusterId) (amazonaws_com_AWS_DAX_CPUUtilization_count{ClusterId=~'$input{ClusterId}',NodeId='$input{NodeId}'})"

      join_on = {
          "$output{ClusterId}" = "$input{ClusterId}"
          "$output{NodeId}"    = "$input{NodeId}"
      }
    }
  }
}
