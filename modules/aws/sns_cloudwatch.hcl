ingester aws_sns_cloudwatch module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  label {
    type = "service"
    name = "$input{service}"
  }

  label {
    type = "namespace"
    name = "$input{namespace}"
  }

  physical_component {
    type = "sns"
    name = "$input{TopicName}"
  }

  data_for_graph_node {
    type = "sns_topic"
    name = "$input{TopicName}-topic"
  }

  using = {
    "default" : "$input{using}"
  }

  inputs = "$input{inputs}"

  input_query = <<-EOF
	label_set(
		label_replace(
			sns{$input{tag_filter}}, 'id=TopicName'
		), "service", "$input{service}", "namespace", "$input{namespace}"
	)
	EOF

  gauge "published" {
    index       = 1
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"
    source cloudwatch "published" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/SNS"
        metric_name = "NumberOfMessagesPublished"

        dimensions = {
          "TopicName" = "$input{TopicName}"
        }
      }
    }
  }

  gauge "delivered" {
    index       = 2
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"
    source cloudwatch "delivered" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/SNS"
        metric_name = "NumberOfNotificationsDelivered"

        dimensions = {
          "TopicName" = "$input{TopicName}"
        }
      }
    }
  }

  gauge "failed" {
    index       = 3
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"
    source cloudwatch "failed" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/SNS"
        metric_name = "NumberOfNotificationsFailed"

        dimensions = {
          "TopicName" = "$input{TopicName}"
        }
      }
    }
  }

  gauge "filtered" {
    index       = 4
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"
    source cloudwatch "filtered" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/SNS"
        metric_name = "NumberOfNotificationsFilteredOut"

        dimensions = {
          "TopicName" = "$input{TopicName}"
        }
      }
    }
  }

  gauge "size" {
    index       = 5
    input_unit  = "bytes"
    output_unit = "bytes"
    aggregator  = "AVG"
    source cloudwatch "size" {
      query {
        aggregator  = "Average"
        namespace   = "AWS/SNS"
        metric_name = "PublishSize"

        dimensions = {
          "TopicName" = "$input{TopicName}"
        }
      }
    }
  }

}
