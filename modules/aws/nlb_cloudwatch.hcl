ingester aws_nlb_cloudwatch module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  inputs = "$input{inputs}"

  input_query = <<-EOF
  label_set(
    label_replace(
      elasticloadbalancing_loadbalancer{id=~"^net/.*",$input{tag_filter}}, 'id=LoadBalancer'
    ), "service", "$input{service}", "namespace", "$input{namespace}"
  )
  EOF

  label {
    type = "service"
    name = "$input{service}"
  }

  label {
    type = "namespace"
    name = "$input{namespace}"
  }

  physical_component {
    type = "nlb"
    name = "$input{LoadBalancer}"
  }

  data_for_graph_node {
    type = "nlb"
    name = "$input{LoadBalancer}"
  }

  using = {
    "default" : "$input{using}"
  }

  gauge "throughput" {
    index       = 1
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "MAX"
    source cloudwatch "throughput" {
      query {
        aggregator  = "Maximum"
        namespace   = "AWS/NetworkELB"
        metric_name = "PeakBytesPerSecond"

        dimensions = {
          "LoadBalancer" = "$input{LoadBalancer}"
        }
      }
    }
  }

  gauge "new_connections" {
    index       = 2
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"
    source cloudwatch "new_connections" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/NetworkELB"
        metric_name = "NewFlowCount"

        dimensions = {
          "LoadBalancer" = "$input{LoadBalancer}"
        }
      }
    }
  }

  gauge "concurrent_connections" {
    index       = 9
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "MAX"
    source cloudwatch "concurrent_connections" {
      query {
        aggregator  = "Maximum"
        namespace   = "AWS/NetworkELB"
        metric_name = "ActiveFlowCount"

        dimensions = {
          "LoadBalancer" = "$input{LoadBalancer}"
        }
      }
    }
  }


  gauge "processed_bytes" {
    index       = 3
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"
    source cloudwatch "ProcessedBytes" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/NetworkELB"
        metric_name = "ProcessedBytes"

        dimensions = {
          "LoadBalancer" = "$input{LoadBalancer}"
        }
      }
    }
  }

  gauge "consumed_lcus" {
    index       = 4
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"
    source cloudwatch "consumed_lcus" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/NetworkELB"
        metric_name = "ConsumedLCUs"

        dimensions = {
          "LoadBalancer" = "$input{LoadBalancer}"
        }
      }
    }
  }

  gauge "tcp_client_reset_count" {
    index       = 5
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"
    source cloudwatch "tcp_client_reset_count" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/NetworkELB"
        metric_name = "TCP_Client_Reset_Count"

        dimensions = {
          "LoadBalancer" = "$input{LoadBalancer}"
        }
      }
    }
  }

  gauge "tcp_elb_reset_count" {
    index       = 6
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"
    source cloudwatch "tcp_elb_reset_count" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/NetworkELB"
        metric_name = "TCP_ELB_Reset_Count"

        dimensions = {
          "LoadBalancer" = "$input{LoadBalancer}"
        }
      }
    }
  }

  gauge "tcp_target_reset_count" {
    index       = 7
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"
    source cloudwatch "tcp_target_reset_count" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/NetworkELB"
        metric_name = "TCP_Target_Reset_Count"

        dimensions = {
          "LoadBalancer" = "$input{LoadBalancer}"
        }
      }
    }
  }

  gauge "target_tls_error" {
    index       = 8
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"
    source cloudwatch "target_tls_error" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/NetworkELB"
        metric_name = "TargetTLSNegotiationErrorCount"

        dimensions = {
          "LoadBalancer" = "$input{LoadBalancer}"
        }
      }
    }
  }


}
