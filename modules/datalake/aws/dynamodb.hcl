ingester aws_dynamodb_table_operation module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  inputs = "[]"

  using = {
    "default" = "$input{using}"
  }

  label {
    type = "namespace"
    name = "$output{tag_namespace}"
  }

  label {
    type = "service"
    name = "$output{tag_service}"
  }

  physical_component {
    type = "dynamodb"
    name = "DYNAMODB_OPERATION"
  }

  data_for_graph_node {
    type = "dynamodb_operation"
    name = "$output{Operation}"
  }

  gauge "system_errors" {
    index       = 1
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "system_errors" {
      query = "sum by (TableName, Operation, tag_namespace, tag_service) (system_errors{TableName!='',Operation!=''})"
    }
  }

  gauge "returned_items" {
    index       = 2
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"

    source prometheus "returned_items" {
      query = "max by (TableName, Operation, tag_namespace, tag_service) (returned_items{TableName!='',Operation!=''})"
    }
  }

  gauge "throttled" {
    index       = 3
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "latency_update" {
      query = "sum by (TableName, Operation, tag_namespace, tag_service) (latency_update{TableName!='',Operation!=''})"
    }
  }

  gauge "latency" {
    index       = 4
    input_unit  = "ms"
    output_unit = "ms"
    aggregator  = "AVG"

    source prometheus "latency" {
      query = "avg by (TableName, Operation, tag_namespace, tag_service) (latency{TableName!='',Operation!=''})"
    }
  }
}

ingester aws_dynamodb_table module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  inputs = "[]"

  using = {
    "default" = "$input{using}"
  }

  label {
    type = "namespace"
    name = "$output{tag_namespace}"
  }

  label {
    type = "service"
    name = "$output{tag_service}"
  }

  physical_component {
    type = "dynamodb"
    name = "DYNAMODB"
  }

  data_for_graph_node {
    type = "dynamodb_logical"
    name = "$output{TableName}"
  }

  gauge "rcu" {
    index       = 1
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "rcu" {
      query = "sum by (TableName, tag_namespace, tag_service) (rcu{TableName!=''})"
    }
  }

  gauge "wcu" {
    index       = 2
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "wcu" {
      query = "sum by (TableName, tag_namespace, tag_service) (wcu{TableName!=''})"
    }
  }

  gauge "read_throttled" {
    index       = 3
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "read_throttled" {
      query = "sum by (TableName, tag_namespace, tag_service) (read_throttled{TableName!=''})"
    }
  }

  gauge "write_throttled" {
    index       = 4
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "write_throttled" {
      query = "sum by (TableName, tag_namespace, tag_service) (write_throttled{TableName!=''})"
    }
  }
}
