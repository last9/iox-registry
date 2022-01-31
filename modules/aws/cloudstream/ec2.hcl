ingester aws_ec2_cloudstream module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  using = {
    default = "$input{using}"
  }

  inputs = "$input{inputs}"

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
    name = "$input{InstanceId}"
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
      query = "sum by (InstanceId) (amazonaws_com_AWS_EC2_CPUUtilization_sum{InstanceId=~'$input{InstanceId}'}) / sum by (InstanceId) (amazonaws_com_AWS_EC2_CPUUtilization_count{InstanceId=~'$input{InstanceId}'})"

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
      query = "sum by (InstanceId) (amazonaws_com_AWS_EC2_NetworkIn_sum{InstanceId=~'$input{InstanceId}'})"

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
      query = "sum by (InstanceId) (amazonaws_com_AWS_EC2_NetworkOut_sum{InstanceId=~'$input{InstanceId}'})"

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
      query = "sum by (InstanceId) (amazonaws_com_AWS_EC2_StatusCheckFailed_sum{InstanceId=~'$input{InstanceId}'})"

      join_on = {
        "$output{InstanceId}" = "$input{InstanceId}"
      }
    }
  }

  gauge "cpu_credit_balance" {
    index       = 2
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MIN"

    source prometheus "cpu_balance" {
      query = "sum by (InstanceId) (amazonaws_com_AWS_EC2_CPUCreditBalance{InstanceId=~'$input{InstanceId}', quantile='0'})"

      join_on = {
        "$output{InstanceId}" = "$input{InstanceId}"
      }
    }
  }

  gauge "ebs_io_balance" {
    index       = 3
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MIN"

    source prometheus "ebs_io_balance" {
      query = "sum by (InstanceId) (amazonaws_com_AWS_EC2_EBSIOBalance_{InstanceId=~'$input{InstanceId}', quantile='0'})"

      join_on = {
        "$output{InstanceId}" = "$input{InstanceId}"
      }
    }
  }

  gauge "ebs_byte_balance" {
    index       = 3
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MIN"

    source prometheus "ebs_byte_balance" {
      query = "sum by (InstanceId) (amazonaws_com_AWS_EC2_EBSByteBalance_{InstanceId=~'$input{InstanceId}', quantile='0'})"

      join_on = {
        "$output{InstanceId}" = "$input{InstanceId}"
      }
    }
  }

  gauge "cpu_surplus_credits_charged" {
    index       = 3
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "cpu_surplus_credits_charged" {
      query = "sum by (InstanceId) (amazonaws_com_AWS_EC2_CPUSurplusCreditsCharged_sum{InstanceId=~'$input{InstanceId}'})"

      join_on = {
        "$output{InstanceId}" = "$input{InstanceId}"
      }
    }
  }
}

