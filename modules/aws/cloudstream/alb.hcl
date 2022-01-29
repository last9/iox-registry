ingester aws_alb_cloudstream module {
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

  physical_component {
    type = "alb_cloudstream"
    name = "$input{LoadBalancer}"
  }

  data_for_graph_node {
    type = "alb_cloudstream"
    name = "$input{LoadBalancer}"
  }

  using = {
    "default" : "$input{using}"
  }

  gauge "throughput" {
    index       = 1
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"

    source prometheus "throughput" {
      query = "sum by (LoadBalancer) (amazonaws_com_AWS_ApplicationELB_RequestCount_sum{LoadBalancer=~'$input{LoadBalancer}',AvailabilityZone='',TargetGroup=''})"

      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
      }
    }
  }

  gauge "new_connections" {
    index       = 2
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"

    source prometheus "new_connections" {
      query = "sum by (LoadBalancer) (amazonaws_com_AWS_ApplicationELB_NewConnectionCount_sum{LoadBalancer=~'$input{LoadBalancer}',AvailabilityZone='',TargetGroup=''})"

      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
      }
    }
  }

  gauge "rejected_connections" {
    index       = 3
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "rejected_connections" {
      query = "sum by (LoadBalancer) (amazonaws_com_AWS_ApplicationELB_RejectedConnectionCount_sum{LoadBalancer=~'$input{LoadBalancer}',AvailabilityZone='',TargetGroup=''})"

      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
      }
    }
  }

  gauge "processed_bytes" {
    index       = 4
    input_unit  = "bytes"
    output_unit = "bytes"
    aggregator  = "SUM"

    source prometheus "processed_bytes" {
      query = "sum by (LoadBalancer) (amazonaws_com_AWS_ApplicationELB_ProcessedBytes_sum{LoadBalancer=~'$input{LoadBalancer}',AvailabilityZone='',TargetGroup=''})"

      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
      }
    }
  }

  gauge "lcu" {
    index       = 5
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "lcu" {
      query = "sum by (LoadBalancer) (amazonaws_com_AWS_ApplicationELB_ConsumedLCUs_sum{LoadBalancer=~'$input{LoadBalancer}',AvailabilityZone='',TargetGroup=''})"

      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
      }
    }
  }

  gauge "status_4xx" {
    index       = 6
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"

    source prometheus "status_400" {
      query = "sum by (LoadBalancer) (amazonaws_com_AWS_ApplicationELB_HTTPCode_Target_4XX_Count_sum{LoadBalancer=~'$input{LoadBalancer}',AvailabilityZone='',TargetGroup=''})"

      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
      }
    }
  }

  gauge "status_5xx" {
    index       = 7
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"

    source prometheus "status_500" {
      query = "sum by (LoadBalancer) (amazonaws_com_AWS_ApplicationELB_HTTPCode_Target_5XX_Count_sum{LoadBalancer=~'$input{LoadBalancer}',AvailabilityZone='',TargetGroup=''})"

      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
      }
    }
  }

  gauge "latency_min" {
    index       = 8
    input_unit  = "s"
    output_unit = "ms"
    aggregator  = "MIN"

    source prometheus "latency_min" {
      query = "sum by (LoadBalancer) (amazonaws_com_AWS_ApplicationELB_TargetResponseTime{LoadBalancer=~'$input{LoadBalancer}', quantile='0',AvailabilityZone='',TargetGroup=''})"

      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
      }
    }
  }

  gauge "latency_max" {
    index       = 9
    input_unit  = "s"
    output_unit = "ms"
    aggregator  = "MAX"

    source prometheus "latency_max" {
      query = "sum by (LoadBalancer) (amazonaws_com_AWS_ApplicationELB_TargetResponseTime{LoadBalancer=~'$input{LoadBalancer}', quantile='1',AvailabilityZone='',TargetGroup=''})"

      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
      }
    }
  }

  gauge "latency_avg" {
    index       = 11
    input_unit  = "s"
    output_unit = "ms"
    aggregator  = "MAX"

    source prometheus "latency_avg" {
      query = "sum by (LoadBalancer) (amazonaws_com_AWS_ApplicationELB_TargetResponseTime_sum{LoadBalancer=~'$input{LoadBalancer}',AvailabilityZone='',TargetGroup=''}) / sum by (LoadBalancer) (amazonaws_com_AWS_ApplicationELB_TargetResponseTime_count{LoadBalancer='$input{LoadBalancer}',AvailabilityZone='',TargetGroup=''})"

      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
      }
    }
  }

}

ingester aws_alb_tg_cloudstream module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  using = {
    "default" : "$input{using}"
  }

  inputs = "$input{inputs}"

  label {
    type = "service"
    name = "$input{service}"
  }

  label {
    type = "namespace"
    name = "$input{namespace}"
  }

  physical_component {
    type = "alb_cloudstream"
    name = "$input{LoadBalancer}"
  }

  physical_address {
    type = "alb_cloudstream_target_group"
    name = "$output{TargetGroup}"
  }

  data_for_graph_node {
    type = "alb_cloudstream_dummy"
    name = "lb: $input{LoadBalancer}"
  }

  gauge "throughput" {
    index       = 1
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"

    source prometheus "throughput" {
      query = "sum by (LoadBalancer, TargetGroup) (amazonaws_com_AWS_ApplicationELB_RequestCount_sum{LoadBalancer=~'$input{LoadBalancer}', TargetGroup=~'.+', AvailabilityZone=''})"

      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
      }
    }
  }

  gauge "status_2xx" {
    index       = 2
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"

    source prometheus "status_200" {
      query = "sum by (LoadBalancer, TargetGroup) (amazonaws_com_AWS_ApplicationELB_HTTPCode_Target_2XX_Count_sum{LoadBalancer=~'$input{LoadBalancer}', TargetGroup=~'.+', AvailabilityZone=''})"

      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
      }
    }
  }

  gauge "status_3xx" {
    index       = 3
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"

    source prometheus "status_300" {
      query = "sum by (LoadBalancer, TargetGroup) (amazonaws_com_AWS_ApplicationELB_HTTPCode_Target_3XX_Count_sum{LoadBalancer=~'$input{LoadBalancer}', TargetGroup=~'.+', AvailabilityZone=''})"

      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
      }
    }
  }

  gauge "status_4xx" {
    index       = 4
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"

    source prometheus "status_400" {
      query = "sum by (LoadBalancer, TargetGroup) (amazonaws_com_AWS_ApplicationELB_HTTPCode_Target_4XX_Count_sum{LoadBalancer=~'$input{LoadBalancer}', TargetGroup=~'.+', AvailabilityZone=''})"

      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
      }
    }
  }

  gauge "status_5xx" {
    index       = 5
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"

    source prometheus "status_500" {
      query = "sum by (LoadBalancer, TargetGroup) (amazonaws_com_AWS_ApplicationELB_HTTPCode_Target_5XX_Count_sum{LoadBalancer=~'$input{LoadBalancer}', TargetGroup=~'.+', AvailabilityZone=''})"

      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
      }
    }
  }

  gauge "latency_min" {
    index       = 6
    input_unit  = "s"
    output_unit = "ms"
    aggregator  = "MIN"

    source prometheus "lcu" {
      query = "sum by (LoadBalancer, TargetGroup) (amazonaws_com_AWS_ApplicationELB_TargetResponseTime{LoadBalancer=~'$input{LoadBalancer}', TargetGroup=~'.+', quantile='0', AvailabilityZone=''})"

      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
      }
    }
  }

  gauge "latency_max" {
    index       = 7
    input_unit  = "s"
    output_unit = "ms"
    aggregator  = "MAX"

    source prometheus "lcu" {
      query = "sum by (LoadBalancer, TargetGroup) (amazonaws_com_AWS_ApplicationELB_TargetResponseTime{LoadBalancer=~'$input{LoadBalancer}', TargetGroup=~'.+', quantile='1', AvailabilityZone=''})"

      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
      }
    }
  }

  gauge "latency_avg" {
    index       = 8
    input_unit  = "s"
    output_unit = "ms"
    aggregator  = "MAX"

    source prometheus "lcu" {
      query = "sum by (LoadBalancer, TargetGroup) (amazonaws_com_AWS_ApplicationELB_TargetResponseTime_sum{LoadBalancer=~'$input{LoadBalancer}', TargetGroup=~'.+', AvailabilityZone=''}) / sum by (LoadBalancer, TargetGroup) (amazonaws_com_AWS_ApplicationELB_TargetResponseTime_count{LoadBalancer='$input{LoadBalancer}', TargetGroup=~'.+', AvailabilityZone=''})"

      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
      }
    }
  }
}
