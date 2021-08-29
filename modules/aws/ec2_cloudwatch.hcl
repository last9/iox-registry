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

  # TODO: Figure this out
  # input_query = "label_set(ec2_instance{$input{tag_filter}}, 'service', '$input{service}')"

  label {
    type = "service"
    name = "$input{service}"
  }

  physical_component {
    type = "ec2_instance"
    name = "$input{InstanceId}"
  }

  data_for_graph_node {
    type = "ec2_instance"
    name = "$input{InstanceId}"
  }

  gauge "cpu" {
    unit       = "percent"
    aggregator = "AVG"

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
    unit       = "count"
    aggregator = "SUM"

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
    unit       = "count"
    aggregator = "SUM"

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
    unit       = "bytes"
    aggregator = "SUM"

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
    unit       = "bytes"
    aggregator = "SUM"

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
    unit       = "count"
    aggregator = "SUM"

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
    unit       = "count"
    aggregator = "MIN"

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
