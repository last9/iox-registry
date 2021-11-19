ingester aws_sqs_cloudwatch module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  label {
    type = "service"
    name = "$input{service}"
  }

  physical_component {
    type = "sqs"
    name = "$input{QueueName}"
  }

  data_for_graph_node {
    type = "sqs_queue"
    name = "$input{QueueName}-queue"
  }

  using = {
    "default" : "$input{using}"
  }

  inputs = "$input{inputs}"

  input_query = <<-EOF
  label_set(
    label_replace(
      sqs{$input{tag_filter}}, 'id=QueueName'
    ), "service", "$input{service}", "namespace", "$input{namespace}"
  )
  EOF

  gauge "sent" {
    index       = 1
    gap_fill    = "zero_fill"
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"
    source cloudwatch "sent" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/SQS"
        metric_name = "NumberOfMessagesSent"

        dimensions = {
          "QueueName" = "$input{QueueName}"
        }
      }
    }
  }

  gauge "received" {
    index       = 2
    gap_fill    = "zero_fill"
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"
    source cloudwatch "received" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/SQS"
        metric_name = "NumberOfMessagesReceived"

        dimensions = {
          "QueueName" = "$input{QueueName}"
        }
      }
    }
  }

  gauge "visible" {
    index       = 3
    gap_fill    = "zero_fill"
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"
    source cloudwatch "visible" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/SQS"
        metric_name = "ApproximateNumberOfMessagesVisible"

        dimensions = {
          "QueueName" = "$input{QueueName}"
        }
      }
    }
  }

  gauge "empty_receives" {
    index       = 4
    gap_fill    = "zero_fill"
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"
    source cloudwatch "empty_receives" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/SQS"
        metric_name = "NumberOfEmptyReceives"

        dimensions = {
          "QueueName" = "$input{QueueName}"
        }
      }
    }
  }

  gauge "deleted" {
    index       = 5
    gap_fill    = "zero_fill"
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"
    source cloudwatch "deleted" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/SQS"
        metric_name = "NumberOfMessagesDeleted"

        dimensions = {
          "QueueName" = "$input{QueueName}"
        }
      }
    }
  }

  gauge "delayed" {
    index       = 6
    gap_fill    = "zero_fill"
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"
    source cloudwatch "delayed" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/SQS"
        metric_name = "ApproximateNumberOfMessagesDelayed"

        dimensions = {
          "QueueName" = "$input{QueueName}"
        }
      }
    }
  }

  gauge "oldest" {
    index       = 7
    gap_fill    = "zero_fill"
    input_unit  = "s"
    output_unit = "s"
    aggregator  = "MAX"
    source cloudwatch "oldest" {
      query {
        aggregator  = "Maximum"
        namespace   = "AWS/SQS"
        metric_name = "ApproximateAgeOfOldestMessage"

        dimensions = {
          "QueueName" = "$input{QueueName}"
        }
      }
    }
  }
}
