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
    type = "alb"
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
    aggregator = "SUM"
    source cloudwatch "throughput" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/NetworkELB"
        metric_name = "ActiveFlowCount"

        dimensions = {
          "LoadBalancer" = "$input{LoadBalancer}"
        }
      }
    }
  }

  gauge "NewFlowCount" {
    unit       = "count"
    aggregator = "SUM"
    source cloudwatch "NewFlowCount" {
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

  gauge "ConsumedLCUs" {
    unit       = "count"
    aggregator = "SUM"
    source cloudwatch "ConsumedLCUs" {
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
}
