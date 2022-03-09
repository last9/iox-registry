ingester aws_ec2 module {
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
    type = "ec2_instance"
    name = "ec2_instance"
  }

  data_for_graph_node {
    type = "ec2_instance"
    name = "$input{InstanceId}"
  }

  gauge "cpu" {
    index       = 1
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "AVG"

    source prometheus "cpu" {
      query = "avg by (InstanceId, tag_namespace, tag_service) (cpu)"
      join_on = {
        "$output{InstanceId}" = "$input{InstanceId}"
      }
    }
  }

  gauge "disk_read_ops" {
    index       = 3
    input_unit  = "count"
    output_unit = "tps"
    aggregator  = "SUM"

    source prometheus "disk_read_ops" {
      query = "sum by (InstanceId, tag_namespace, tag_service) (disk_read_ops)"

      join_on = {
        "$output{InstanceId}" = "$input{InstanceId}"
      }
    }
  }

  gauge "disk_write_ops" {
    index       = 4
    input_unit  = "count"
    output_unit = "tps"
    aggregator  = "SUM"

    source prometheus "disk_write_ops" {
      query = "sum by (InstanceId, tag_namespace, tag_service) (disk_write_ops)"

      join_on = {
        "$output{InstanceId}" = "$input{InstanceId}"
      }
    }
  }

  gauge "network_in" {
    index       = 5
    input_unit  = "bytes"
    output_unit = "Bps"
    aggregator  = "SUM"

    source prometheus "network_in" {
      query = "sum by (InstanceId, tag_namespace, tag_service) (network_in)"

      join_on = {
        "$output{InstanceId}" = "$input{InstanceId}"
      }

    }
  }

  gauge "network_out" {
    index       = 6
    input_unit  = "bytes"
    output_unit = "Bps"
    aggregator  = "SUM"

    source prometheus "network_out" {
      query = "sum by (InstanceId, tag_namespace, tag_service) (network_out)"

      join_on = {
        "$output{InstanceId}" = "$input{InstanceId}"
      }
    }
  }

  gauge "status_check_failed" {
    index       = 7
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "status_check_failed" {
      query = "sum by (InstanceId, tag_namespace, tag_service) (status_check_failed)"

      join_on = {
        "$output{InstanceId}" = "$input{InstanceId}"
      }

    }
  }

  gauge "cpu_balance" {
    index       = 2
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MIN"

    source prometheus "cpu_balance" {
      query = "min by (InstanceId, tag_namespace, tag_service) (cpu_balance)"

      join_on = {
        "$output{InstanceId}" = "$input{InstanceId}"
      }
    }
  }
}
