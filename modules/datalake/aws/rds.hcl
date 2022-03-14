ingester aws_rds module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  inputs = "[]"

  label {
    type = "service"
    name = "$output{tag_service}"
  }

  label {
    type = "namespace"
    name = "$output{tag_namespace}"
  }

  physical_component {
    type = "rds"
    name = "RDS"
  }

  data_for_graph_node {
    type = "rds_logical"
    name = "$output{DBInstanceIdentifier}"
  }

  using = {
    "default" : "$input{using}"
  }

  gauge "connections" {
    index       = 1
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MAX"
    source prometheus "connections" {
      query = "max by (DBInstanceIdentifier, tag_namespace, tag_service) (connections{DBInstanceIdentifier!=''})"
    }
  }

  gauge "cpu" {
    index       = 2
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "AVG"

    source prometheus "cpu" {
      query = "avg by (DBInstanceIdentifier, tag_namespace, tag_service) (cpu{DBInstanceIdentifier!=''})"

      
    }
  }

  gauge "write_iops" {
    index       = 3
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"

    source prometheus "write_iops" {
      query = "sum by (DBInstanceIdentifier, tag_namespace, tag_service) (write_iops{DBInstanceIdentifier!=''})"

      
    }
  }

  gauge "read_iops" {
    index       = 4
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"

    source prometheus "read_iops" {
      query = "sum by (DBInstanceIdentifier, tag_namespace, tag_service) (read_iops{DBInstanceIdentifier!=''})"

      
    }
  }

  gauge "read_latency" {
    index       = 5
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"

    source prometheus "read_latency" {
      query = "sum by (DBInstanceIdentifier, tag_namespace, tag_service) (read_latency{DBInstanceIdentifier!=''})"

      
    }
  }

  gauge "write_latency" {
    index       = 6
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"

    source prometheus "write_latency" {
      query = "sum by (DBInstanceIdentifier, tag_namespace, tag_service) (write_latency{DBInstanceIdentifier!=''})"

      
    }
  }

  gauge "network_in" {
    index       = 7
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"

    source prometheus "network_in" {
      query = "sum by (DBInstanceIdentifier, tag_namespace, tag_service) (network_in{DBInstanceIdentifier!=''})"

      
    }
  }

  gauge "network_out" {
    index       = 8
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"

    source prometheus "network_out" {
      query = "sum by (DBInstanceIdentifier, tag_namespace, tag_service) (network_out{DBInstanceIdentifier!=''})"

      
    }
  }

  gauge "free_space" {
    index       = 9
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"

    source prometheus "free_space" {
      query = "sum (DBInstanceIdentifier, tag_namespace, tag_service) (free_space{DBInstanceIdentifier!=''})"

      
    }
  }

  gauge "replica_lag" {
    index       = 11
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"

    source prometheus "replica_lag" {
      query = "sum (DBInstanceIdentifier, tag_namespace, tag_service) (replica_lag{DBInstanceIdentifier!=''})"

      
    }
  }

  gauge "queue_depth" {
    index       = 12
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"

    source prometheus "queue_depth" {
      query = "sum (DBInstanceIdentifier, tag_namespace, tag_service) (queue_depth{DBInstanceIdentifier!=''})" 
    }
  }
}
