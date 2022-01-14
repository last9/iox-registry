ingester aws_elb_cloudstream module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  inputs = "$input{inputs}"

  //  input_query = <<-EOF
  //    label_set(
  //      label_replace(
  //        elasticloadbalancing_loadbalancer{id!~".*/.*",$input{tag_filter}}, 'id=LoadBalancerName'
 //      ), "service", "$input{service}", "namespace", "$input{namespace}"
 //    )
 //  EOF

 label {
   type = "service"
   name = "$input{service}"
 }

 label {
   type = "namespace"
   name = "$input{namespace}"
 }

 physical_component {
   type = "elb"
   name = "$input{LoadBalancerName}"
 }

 data_for_graph_node {
   type = "elb"
   name = "$input{LoadBalancerName}"
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
     query = "sum by (LoadBalancerName) (amazonaws_com_AWS_ELB_RequestCount_sum{LoadBalancerName='$input{LoadBalancerName}'})"

     join_on = {
       "$output{LoadBalancerName}" = "$input{LoadBalancerName}"
     }
   }
 }

 gauge "surge_queue_length" {
   index       = 2
   input_unit  = "count"
   output_unit = "rpm"
   aggregator  = "MAX"

   source prometheus "throughput" {
     query = "sum by (LoadBalancerName) (amazonaws_com_AWS_ELB_SurgeQueueLength{LoadBalancerName='$input{LoadBalancerName}', quantile='1'})"

     join_on = {
       "$output{LoadBalancerName}" = "$input{LoadBalancerName}"
     }
   }
 }

 gauge "connection_errors" {
   index       = 3
   input_unit  = "count"
   output_unit = "count"
   aggregator  = "SUM"

   source prometheus "connection_errors" {
     query = "sum by (LoadBalancerName) (amazonaws_com_AWS_ELB_BackendConnectionErrors_sum{LoadBalancerName='$input{LoadBalancerName}'})"

     join_on = {
       "$output{LoadBalancerName}" = "$input{LoadBalancerName}"
     }
   }
 }

 gauge "unhealthy_hosts" {
   index       = 4
   input_unit  = "count"
   output_unit = "count"
   aggregator  = "MAX"

   source prometheus "unhealthy_hosts" {
     query = "sum by (LoadBalancerName) (amazonaws_com_AWS_ELB_UnHealthyHostCount{LoadBalancerName='$input{LoadBalancerName}', quantile='1'})"

     join_on = {
       "$output{LoadBalancerName}" = "$input{LoadBalancerName}"
     }
   }
 }

 gauge "status_4xx" {
   index       = 5
   input_unit  = "count"
   output_unit = "rpm"
   aggregator  = "SUM"

   source prometheus "lb_400" {
     query = "sum by (LoadBalancerName) (amazonaws_com_AWS_ELB_HTTPCode_Backend_4XX_sum{LoadBalancerName='$input{LoadBalancerName}'})"

     join_on = {
       "$output{LoadBalancerName}" = "$input{LoadBalancerName}"
     }
   }
 }

 gauge "status_5xx" {
   index       = 6
   input_unit  = "count"
   output_unit = "rpm"
   aggregator  = "SUM"

   source prometheus "lb_500" {
     query = "sum by (LoadBalancerName) (amazonaws_com_AWS_ELB_HTTPCode_Backend_5XX_sum{LoadBalancerName='$input{LoadBalancerName}'})"

     join_on = {
       "$output{LoadBalancerName}" = "$input{LoadBalancerName}"
     }
   }
 }

 gauge "latency_min" {
   index       = 7
   input_unit  = "s"
   output_unit = "ms"
   aggregator  = "MIN"

   source prometheus "latency_min" {
     query = "sum by (LoadBalancerName) (amazonaws_com_AWS_ELB_Latency{LoadBalancerName='$input{LoadBalancerName}', quantile='0'})"

     join_on = {
       "$output{LoadBalancerName}" = "$input{LoadBalancerName}"
     }
   }
 }

 gauge "latency_max" {
   index       = 8
   input_unit  = "s"
   output_unit = "ms"
   aggregator  = "MAX"

   source prometheus "latency_max" {
     query = "sum by (LoadBalancerName) (amazonaws_com_AWS_ELB_Latency{LoadBalancerName='$input{LoadBalancerName}', quantile='1'})"

     join_on = {
       "$output{LoadBalancerName}" = "$input{LoadBalancerName}"
     }
   }
 }

 gauge "latency_avg" {
   index       = 9
   input_unit  = "s"
   output_unit = "ms"
   aggregator  = "MAX"

   source prometheus "latency_avg" {
     query = "sum by (LoadBalancerName) (amazonaws_com_AWS_ELB_Latency_sum{LoadBalancerName='$input{LoadBalancerName}'}) / sum by (LoadBalancerName) (amazonaws_com_AWS_ELB_Latency_count{LoadBalancerName='$input{LoadBalancerName}'})"

     join_on = {
       "$output{LoadBalancerName}" = "$input{LoadBalancerName}"
     }
   }
 }

}

ingester aws_elb_endpoint_cloudstream module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  using = {
    "default" : "$input{using}"
  }

  label {
    type = "service"
    name = "$input{service}"
  }

  label {
    type = "namespace"
    name = "$input{namespace}"
  }

  physical_component {
    type = "elb"
    name = "$input{LoadBalancerName}"
  }

  data_for_graph_node {
    type = "endpoint"
    name = "$input{namespace}/"
  }

  inputs = "$input{inputs}"

  //  input_query = <<-EOF
  //    label_set(
  //      label_replace(
  //        elasticloadbalancing_loadbalancer{id!~".*/.*",$input{tag_filter}}, 'id=LoadBalancerName'
 //      ), "service", "$input{service}", "namespace", "$input{namespace}"
 //    )
 //  EOF

 gauge "throughput" {
   index       = 1
   input_unit  = "count"
   output_unit = "rpm"
   aggregator  = "SUM"

   source prometheus "throughput" {
     query = "sum by (LoadBalancerName) (amazonaws_com_AWS_ELB_RequestCount_sum{LoadBalancerName='$input{LoadBalancerName}'})"

     join_on = {
       "$output{LoadBalancerName}" = "$input{LoadBalancerName}"
     }
   }
 }

 gauge "surge_queue_length" {
   index       = 2
   input_unit  = "count"
   output_unit = "rpm"
   aggregator  = "MAX"

   source prometheus "throughput" {
     query = "sum by (LoadBalancerName) (amazonaws_com_AWS_ELB_SurgeQueueLength{LoadBalancerName='$input{LoadBalancerName}', quantile='1'})"

     join_on = {
       "$output{LoadBalancerName}" = "$input{LoadBalancerName}"
     }
   }
 }

 gauge "connection_errors" {
   index       = 3
   input_unit  = "count"
   output_unit = "count"
   aggregator  = "SUM"

   source prometheus "connection_errors" {
     query = "sum by (LoadBalancerName) (amazonaws_com_AWS_ELB_BackendConnectionErrors_sum{LoadBalancerName='$input{LoadBalancerName}'})"

     join_on = {
       "$output{LoadBalancerName}" = "$input{LoadBalancerName}"
     }
   }
 }

 gauge "unhealthy_hosts" {
   index       = 4
   input_unit  = "count"
   output_unit = "count"
   aggregator  = "MAX"

   source prometheus "unhealthy_hosts" {
     query = "sum by (LoadBalancerName) (amazonaws_com_AWS_ELB_UnHealthyHostCount{LoadBalancerName='$input{LoadBalancerName}', quantile='1'})"

     join_on = {
       "$output{LoadBalancerName}" = "$input{LoadBalancerName}"
     }
   }
 }

 gauge "status_2xx" {
   index       = 5
   input_unit  = "count"
   output_unit = "rpm"
   aggregator  = "SUM"

   source prometheus "lb_200" {
     query = "sum by (LoadBalancerName) (amazonaws_com_AWS_ELB_HTTPCode_Backend_2XX_sum{LoadBalancerName='$input{LoadBalancerName}'})"

     join_on = {
       "$output{LoadBalancerName}" = "$input{LoadBalancerName}"
     }
   }
 }

 gauge "status_3xx" {
   index       = 6
   input_unit  = "count"
   output_unit = "rpm"
   aggregator  = "SUM"

   source prometheus "lb_300" {
     query = "sum by (LoadBalancerName) (amazonaws_com_AWS_ELB_HTTPCode_Backend_3XX_sum{LoadBalancerName='$input{LoadBalancerName}'})"

     join_on = {
       "$output{LoadBalancerName}" = "$input{LoadBalancerName}"
     }
   }
 }

 gauge "status_4xx" {
   index       = 7
   input_unit  = "count"
   output_unit = "rpm"
   aggregator  = "SUM"

   source prometheus "lb_400" {
     query = "sum by (LoadBalancerName) (amazonaws_com_AWS_ELB_HTTPCode_Backend_4XX_sum{LoadBalancerName='$input{LoadBalancerName}'})"

     join_on = {
       "$output{LoadBalancerName}" = "$input{LoadBalancerName}"
     }
   }
 }

 gauge "status_5xx" {
   index       = 8
   input_unit  = "count"
   output_unit = "rpm"
   aggregator  = "SUM"

   source prometheus "lb_500" {
     query = "sum by (LoadBalancerName) (amazonaws_com_AWS_ELB_HTTPCode_Backend_5XX_sum{LoadBalancerName='$input{LoadBalancerName}'})"

     join_on = {
       "$output{LoadBalancerName}" = "$input{LoadBalancerName}"
     }
   }
 }

 gauge "latency_min" {
   index       = 9
   input_unit  = "s"
   output_unit = "ms"
   aggregator  = "MIN"

   source prometheus "latency_min" {
     query = "sum by (LoadBalancerName) (amazonaws_com_AWS_ELB_Latency{LoadBalancerName='$input{LoadBalancerName}', quantile='0'})"

     join_on = {
       "$output{LoadBalancerName}" = "$input{LoadBalancerName}"
     }
   }
 }

 gauge "latency_max" {
   index       = 11
   input_unit  = "s"
   output_unit = "ms"
   aggregator  = "MAX"

   source prometheus "latency_max" {
     query = "sum by (LoadBalancerName) (amazonaws_com_AWS_ELB_Latency{LoadBalancerName='$input{LoadBalancerName}', quantile='1'})"

     join_on = {
       "$output{LoadBalancerName}" = "$input{LoadBalancerName}"
     }
   }
 }

 gauge "latency_avg" {
   index       = 12
   input_unit  = "s"
   output_unit = "ms"
   aggregator  = "MAX"

   source prometheus "latency_avg" {
     query = "sum by (LoadBalancerName) (amazonaws_com_AWS_ELB_Latency_sum{LoadBalancerName='$input{LoadBalancerName}'}) / sum by (LoadBalancerName) (amazonaws_com_AWS_ELB_Latency_count{LoadBalancerName='$input{LoadBalancerName}'})"

     join_on = {
       "$output{LoadBalancerName}" = "$input{LoadBalancerName}"
     }
   }
 }

}
