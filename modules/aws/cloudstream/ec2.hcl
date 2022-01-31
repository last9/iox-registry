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
      query = "sum by (InstanceId) (amazonaws_com_AWS_EC2_EBSIOBalance_{InstanceId=~'$input{InstanceId}'})"

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
      query = "sum by (InstanceId) (amazonaws_com_AWS_EC2_EBSByteBalance_{InstanceId=~'$input{InstanceId}'})"

      join_on = {
        "$output{InstanceId}" = "$input{InstanceId}"
      }
    }
  }

  gauge "cpu_surplus_credits_charged" {
    index       = 3
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "MIN"

    source prometheus "cpu_surplus_credits_charged" {
      query = "sum by (InstanceId) (amazonaws_com_AWS_EC2_CPUSurplusCreditsCharged{InstanceId=~'$input{InstanceId}'})"

      join_on = {
        "$output{InstanceId}" = "$input{InstanceId}"
      }
    }
  }
}

