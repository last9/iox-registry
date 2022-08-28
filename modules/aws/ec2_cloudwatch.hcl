ingester aws_ec2_cloudwatch module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  using = {
    default = "$input{using}"
  }

  inputs = "$input{inputs}"

  input_query = <<-EOF
  label_set(
    label_replace(
      ec2_instance{$input{tag_filter}}, 'id=InstanceId'
    ), "service", "$input{service}"
  )
  EOF

  label {
    type = "namespace"
    name = "$input{namespace}"
  }


  label {
    type = "service"
    name = "$input{service}"
  }

  physical_component {
    type = "ec2_instance"
    name = "coalesce_on_interpolation(\"$input{InstanceId}-$input{custom_tag}\",\"$input{InstanceId}\")"
  }

  data_for_graph_node {
    type = "ec2_instance"
    name = "coalesce_on_interpolation(\"$input{InstanceId}-$input{custom_tag}\",\"$input{InstanceId}\")"
  }

  gauge "cpu" {
    index       = 1
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "AVG"

    source cloudwatch "cpu" {
      query {
        aggregator  = "Average"
        namespace   = "AWS/EC2"
        metric_name = "CPUUtilization"

        dimensions = {
          "InstanceId" = "$input{InstanceId}"
        }
      }
    }
  }

  gauge "disk_read_ops" {
    index       = 3
    input_unit  = "count"
    output_unit = "tps"
    aggregator  = "SUM"

    source cloudwatch "disk_read_ops" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/EC2"
        metric_name = "EBSReadOps"

        dimensions = {
          "InstanceId" = "$input{InstanceId}"
        }
      }
    }
  }

  gauge "disk_write_ops" {
    index       = 4
    input_unit  = "count"
    output_unit = "tps"
    aggregator  = "SUM"

    source cloudwatch "disk_write_ops" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/EC2"
        metric_name = "EBSWriteOps"

        dimensions = {
          "InstanceId" = "$input{InstanceId}"
        }
      }
    }
  }

  gauge "network_in" {
    index       = 5
    input_unit  = "bytes"
    output_unit = "Bps"
    aggregator  = "SUM"

    source cloudwatch "network_in" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/EC2"
        metric_name = "NetworkIn"

        dimensions = {
          "InstanceId" = "$input{InstanceId}"
        }
      }
    }
  }

  gauge "network_out" {
    index       = 6
    input_unit  = "bytes"
    output_unit = "Bps"
    aggregator  = "SUM"

    source cloudwatch "network_out" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/EC2"
        metric_name = "NetworkOut"

        dimensions = {
          "InstanceId" = "$input{InstanceId}"
        }
      }
    }
  }

  gauge "status_check_failed" {
    index       = 7
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source cloudwatch "status_check_failed" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/EC2"
        metric_name = "StatusCheckFailed"

        dimensions = {
          "InstanceId" = "$input{InstanceId}"
        }
      }
    }
  }

  gauge "cpu_balance" {
    index       = 2
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MIN"

    source cloudwatch "cpu_balance" {
      query {
        aggregator  = "Minimum"
        namespace   = "AWS/EC2"
        metric_name = "CPUCreditBalance"

        dimensions = {
          "InstanceId" = "$input{InstanceId}"
        }
      }
    }
  }
}
