ingester dynamodb_table_operation_via_datalake module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  inputs = "$input{input}"

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
    name = "$input{TableName}"
  }

  data_for_graph_node {
    type = "dynamodb_operation"
    name = "$input{Operation}"
  }


  gauge "system_errors" {
    index       = 1
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "system_errors" {
      query = "sum by (TableName, Operation, tag_namespace, tag_service) (system_errors)"
      join_on = {
        "$output{TableName}" = "$input{TableName}"
        "$output{Operation}" = "$input{Operation}"
      }
    }
  }

  gauge "returned_items" {
    index       = 2
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"

    source prometheus "returned_items" {
      query = "max by (TableName, Operation, tag_namespace, tag_service) (returned_items)"
      join_on = {
        "$output{TableName}" = "$input{TableName}"
        "$output{Operation}" = "$input{Operation}"
      }
    }
  }

  gauge "throttled" {
    index       = 3
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "latency_update" {
      query = "sum by (TableName, Operation, tag_namespace, tag_service) (latency_update)"
      join_on = {
        "$output{TableName}" = "$input{TableName}"
        "$output{Operation}" = "$input{Operation}"
      }
    }
  }

  gauge "latency" {
    index       = 4
    input_unit  = "ms"
    output_unit = "ms"
    aggregator  = "AVG"

    source prometheus "latency" {
      query = "avg by (TableName, Operation, tag_namespace, tag_service) (latency)"
      join_on = {
        "$output{TableName}" = "$input{TableName}"
        "$output{Operation}" = "$input{Operation}"
      }
    }
  }
}


ingester dynamodb_table_via_datalake module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  inputs = "$input{input}"

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
    name = "$input{TableName}"
  }

  data_for_graph_node {
    type = "dynamodb"
    name = "$input{TableName}"
  }

  gauge "rcu" {
    index       = 1
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "rcu" {
      query = "sum by (TableName, tag_namespace, tag_service) (rcu)"
      join_on = {
        "$output{TableName}" = "$input{TableName}"
      }
    }
  }

  gauge "wcu" {
    index       = 2
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "wcu" {
      query = "sum by (TableName, tag_namespace, tag_service) (wcu)"
      join_on = {
        "$output{TableName}" = "$input{TableName}"
      }
    }
  }

  gauge "read_throttled" {
    index       = 3
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "read_throttled" {
      query = "sum by (TableName, tag_namespace, tag_service) (read_throttled)"
      join_on = {
        "$output{TableName}" = "$input{TableName}"
      }
    }
  }

  gauge "write_throttled" {
    index       = 4
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "write_throttled" {
      query = "sum by (TableName, tag_namespace, tag_service) (write_throttled)"
      join_on = {
        "$output{TableName}" = "$input{TableName}"
      }
    }
  }
}
