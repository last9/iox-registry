ingester aws_sqs module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  label {
    type = "service"
    name = "$output{tag_service}"
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
    "default" = "$input{using}"
  }

  inputs = "$input{inputs}"

  gauge "sent" {
    index       = 1
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "sent" {
      query = "sum by (QueueName, tag_service) (sent)"

      join_on = {
        "$output{QueueName}" = "$input{QueueName}"
      }
    }
  }

  gauge "received" {
    index       = 2
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "received" {
      query = "sum by (QueueName, tag_service) (received)"

      join_on = {
        "$output{QueueName}" = "$input{QueueName}"
      }
    }
  }

  gauge "visible" {
    index       = 3
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "visible" {
      query = "sum by (QueueName, tag_service) (visible)"

      join_on = {
        "$output{QueueName}" = "$input{QueueName}"
      }
    }
  }

  gauge "empty_receives" {
    index       = 4
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "empty_receives" {
      query = "sum by (QueueName, tag_service) (empty_receives)"

      join_on = {
        "$output{QueueName}" = "$input{QueueName}"
      }
    }
  }

  gauge "deleted" {
    index       = 5
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "deleted" {
      query = "sum by (QueueName, tag_service) (deleted)"

      join_on = {
        "$output{QueueName}" = "$input{QueueName}"
      }
    }
  }

  gauge "delayed" {
    index       = 6
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"

    source prometheus "delayed" {
      query = "sum by (QueueName, tag_service) (delayed)"

      join_on = {
        "$output{QueueName}" = "$input{QueueName}"
      }
    }
  }

  gauge "oldest" {
    index       = 7
    input_unit  = "s"
    output_unit = "s"
    aggregator  = "MAX"

    source prometheus "oldest" {
      query = "max by (QueueName, tag_service) (oldest)"

      join_on = {
        "$output{QueueName}" = "$input{QueueName}"
      }
    }
  }
}
