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
    type = "aws_sqs"
    name = "$input{QueueName}"
  }

  data_for_graph_node {
    type = "aws_sqs_queue"
    name = "$input{QueueName}"
  }

  using = {
    "default" : "$input{using}"
  }

  inputs = "$input{inputs}"

  gauge "sent" {
    unit = "count"
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
    unit = "count"
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
    unit = "count"
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
    unit = "count"
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
    unit = "count"
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
    unit = "count"
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
    unit = "seconds"
    source cloudwatch "oldest" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/SQS"
        metric_name = "ApproximateAgeOfOldestMessage"

        dimensions = {
          "QueueName" = "$input{QueueName}"
        }
      }
    }
  }
}
