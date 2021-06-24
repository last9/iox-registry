ingester managed_aerospike_namespace_ops_read_datadog module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 0

  inputs = "$input{inputs}"

  label {
    type = "service"
    name = "$input{service}"
  }

  physical_address {
    type = "aerospike_host"
    name = "$output{host}"
  }

  physical_component {
    type = "aerospike_cluster"
    name = "$input{cluster}"
  }

  data_for_graph_node {
    type = "aerospike_op"
    name = "read"
  }

  logical_parent_nodes = [
    {
      type = "aerospike_namespace"
      name = "$output{namespace}"
    },
    {
      type = "aerospike_ops"
      name = "operations"
    },
  ]

  using = {
    "default" : "$input{using}"
  }

  gauge "client_success" {
    unit = "count"
    aggregator = "SUM"
    source datadog "client_success" {
      query = "sum:aerospike.namespace.client_read_success{*} by {namespace,host}.rollup(sum, 60)"

      join_on = {
        "$input{namespace}"     = "$output{namespace}"
      }
    }
  }

  gauge "client_error" {
    unit = "count"
    aggregator = "SUM"
    source datadog "client_error" {
      query = "sum:aerospike.namespace.client_read_error{*} by {namespace,host}.rollup(sum, 60)"

      join_on = {
        "$input{namespace}"     = "$output{namespace}"
      }
    }
  }

  gauge "client_timeout" {
    unit = "count"
    aggregator = "SUM"
    source datadog "client_timeout" {
      query = "sum:aerospike.namespace.client_read_timeout{*} by {namespace,host}.rollup(sum, 60)"

      join_on = {
        "$input{namespace}"     = "$output{namespace}"
      }
    }
  }
}

ingester managed_aerospike_namespace_sets_datadog module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 0

  inputs = "$input{inputs}"

  label {
    type = "service"
    name = "$input{service}"
  }

  physical_address {
    type = "aerospike_host"
    name = "$output{host}"
  }

  physical_component {
    type = "aerospike_cluster"
    name = "$input{cluster}"
  }

  data_for_graph_node {
    type = "aerospike_set"
    name = "$output{set}"
  }

  logical_parent_nodes = [
    {
      type = "aerospike_namespace"
      name = "$output{namespace}"
    },
    {
      type = "aerospike_sets"
      name = "sets"
    },
  ]

  using = {
    "default" : "$input{using}"
  }

  gauge "memory" {
    unit = "bytes"
    aggregator = "AVG"
    source datadog "memory" {
      query = "avg:aerospike.set.memory_data_bytes{*} by {set,namespace,host}.rollup(avg, 60)"

      join_on = {
        "$input{namespace}"     = "$output{namespace}"
      }
    }
  }

  gauge "objects" {
    unit = "count"
    aggregator = "AVG"
    source datadog "objects" {
      query = "avg:aerospike.set.objects{*} by {set,namespace,host}.rollup(avg, 60)"

      join_on = {
        "$input{namespace}"     = "$output{namespace}"
      }
    }
  }

  gauge "stop_write" {
    unit = "count"
    aggregator = "SUM"
    source datadog "client_timeout" {
      query = "sum:aerospike.set.stop_writes_count{*} by {set,namespace,host}.rollup(sum, 60)"

      join_on = {
        "$input{namespace}"     = "$output{namespace}"
      }
    }
  }
}

ingester managed_aerospike_namespace_datadog module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 0

  inputs = "$input{inputs}"

  label {
    type = "service"
    name = "$input{service}"
  }

  physical_address {
    type = "aerospike_host"
    name = "$output{host}"
  }

  physical_component {
    type = "aerospike_cluster"
    name = "$input{cluster}"
  }

  data_for_graph_node {
    type = "aerospike_self"
    name = "self"
  }

  logical_parent_nodes = [
    {
      type = "aerospike_namespace"
      name = "$output{namespace}"
    }
  ]

  using = {
    "default" : "$input{using}"
  }

  gauge "query" {
    unit = "tps"
    aggregator = "AVG"
    source datadog "query" {
      query = "avg:aerospike.namespace.tps.query{*} by {namespace,host}.rollup(avg, 60)"

      join_on = {
        "$input{namespace}"     = "$output{namespace}"
      }
    }
  }

  gauge "read" {
    unit = "tps"
    aggregator = "AVG"
    source datadog "read" {
      query = "avg:aerospike.namespace.tps.read{*} by {namespace,host}.rollup(avg, 60)"

      join_on = {
        "$input{namespace}"     = "$output{namespace}"
      }
    }
  }

  gauge "write" {
    unit = "tps"
    aggregator = "AVG"
    source datadog "write" {
      query = "avg:aerospike.namespace.tps.write{*} by {namespace,host}.rollup(avg, 60)"

      join_on = {
        "$input{namespace}"     = "$output{namespace}"
      }
    }
  }
}
