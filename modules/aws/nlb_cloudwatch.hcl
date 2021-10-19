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
    unit       = "count"
    aggregator = "MAX"
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
    unit       = "count"
    aggregator = "SUM"
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
    unit       = "count"
    aggregator = "MAX"
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
    unit       = "count"
    aggregator = "SUM"
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
    unit       = "count"
    aggregator = "SUM"
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
    unit       = "count"
    aggregator = "SUM"
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
    unit       = "count"
    aggregator = "SUM"
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
    unit       = "count"
    aggregator = "SUM"
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
    unit       = "count"
    aggregator = "SUM"
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