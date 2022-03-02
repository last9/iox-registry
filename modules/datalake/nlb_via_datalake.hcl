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
    name = "$input{tag_service}"
  }

  label {
    type = "namespace"
    name = "$input{tag_namespace}"
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

    source prometheus "throughput" {
      query = "max by (LoadBalancer, tag_namespace, tag_service) (throughput)"
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
      query = "max by (LoadBalancer, tag_namespace, tag_service) (new_connections)"
      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
      }
    }
  }

  gauge "concurrent_connections" {
    index       = 9
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "MAX"
    source prometheus "concurrent_connections" {
      query = "max by (LoadBalancer, tag_namespace, tag_service) (concurrent_connections)"
      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
      }
    }
  }


  gauge "processed_bytes" {
    index       = 3
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"
    source prometheus "processed_bytes" {
      query = "max by (LoadBalancer, tag_namespace, tag_service) (processed_bytes)"
      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
      }
    }
  }

  gauge "consumed_lcus" {
    index       = 4
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"
    source prometheus "consumed_lcus" {
      query = "max by (LoadBalancer, tag_namespace, tag_service) (consumed_lcus)"
      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
      }
    }
  }

  gauge "tcp_client_reset_count" {
    index       = 5
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"
    source prometheus "tcp_client_reset_count" {
      query = "max by (LoadBalancer, tag_namespace, tag_service) (tcp_client_reset_count)"
      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
      }
    }
  }

  gauge "tcp_elb_reset_count" {
    index       = 6
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"
    source prometheus "tcp_elb_reset_count" {
      query = "max by (LoadBalancer, tag_namespace, tag_service) (tcp_elb_reset_count)"
      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
      }
    }
  }

  gauge "tcp_target_reset_count" {
    index       = 7
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"
    source prometheus "tcp_target_reset_count" {
      query = "max by (LoadBalancer, tag_namespace, tag_service) (tcp_target_reset_count)"
      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
      }
    }
  }

  gauge "target_tls_error" {
    index       = 8
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"
    source prometheus "target_tls_error" {
      query = "max by (LoadBalancer, tag_namespace, tag_service) (target_tls_error)"
      join_on = {
        "$output{LoadBalancer}" = "$input{LoadBalancer}"
      }
    }
  }


}
