ingester aws_efs_cloudwatch module {
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
    type = "aws_efs_group"
    name = "$input{namespace}-efs-group"
  }

  data_for_graph_node {
    type = "aws_efs"
    name = "$input{FileSystemId}-efs"
  }

  using = {
    "default" : "$input{using}"
  }

  gauge "last_sync" {
    index       = 1
    input_unit  = "s"
    output_unit = "s"
    aggregator  = "MAX"
    source cloudwatch "last_sync" {
      query {
        aggregator  = "Maximum"
        namespace   = "AWS/EFS"
        metric_name = "TimeSinceLastSync"

        dimensions = {
          "FileSystemId" = "$input{FileSystemId}"
        }
      }
    }
  }

  gauge "io_limit" {
    index       = 2
    input_unit  = "percentage"
    output_unit = "percentage"
    aggregator  = "MAX"
    source cloudwatch "io_limit" {
      query {
        aggregator  = "Maximum"
        namespace   = "AWS/EFS"
        metric_name = "PercentIOLimit"

        dimensions = {
          "FileSystemId" = "$input{FileSystemId}"
        }
      }
    }
  }

  gauge "burst_balance" {
    index       = 3
    input_unit  = "bytes"
    output_unit = "bytes"
    aggregator  = "MIN"
    source cloudwatch "burst_balance" {
      query {
        aggregator  = "Minimum"
        namespace   = "AWS/EFS"
        metric_name = "BurstCreditBalance"

        dimensions = {
          "FileSystemId" = "$input{FileSystemId}"
        }
      }
    }
  }

  gauge "permitted_throughput" {
    index       = 4
    input_unit  = "bps"
    output_unit = "bps"
    aggregator  = "MAX"
    source cloudwatch "permitted_throughput" {
      query {
        aggregator  = "Maximum"
        namespace   = "AWS/EFS"
        metric_name = "PermittedThroughput"

        dimensions = {
          "FileSystemId" = "$input{FileSystemId}"
        }
      }
    }
  }

  gauge "metered_io" {
    index       = 5
    input_unit  = "bytes"
    output_unit = "bytes"
    aggregator  = "SUM"
    source cloudwatch "metered_io" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/EFS"
        metric_name = "MeteredIOBytes"

        dimensions = {
          "FileSystemId" = "$input{FileSystemId}"
        }
      }
    }
  }

  gauge "bytes_read" {
    index       = 6
    input_unit  = "bytes"
    output_unit = "bytes"
    aggregator  = "SUM"
    source cloudwatch "bytes_read" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/EFS"
        metric_name = "DataReadIOBytes"

        dimensions = {
          "FileSystemId" = "$input{FileSystemId}"
        }
      }
    }
  }

  gauge "bytes_write" {
    index       = 7
    input_unit  = "bytes"
    output_unit = "bytes"
    aggregator  = "SUM"
    source cloudwatch "bytes_write" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/EFS"
        metric_name = "DataWriteIOBytes"

        dimensions = {
          "FileSystemId" = "$input{FileSystemId}"
        }
      }
    }
  }

  gauge "connections" {
    index       = 8
    input_unit  = "count"
    output_unit = "count"
    aggregator  = "SUM"
    source cloudwatch "connections" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/EFS"
        metric_name = "ClientConnections"

        dimensions = {
          "FileSystemId" = "$input{FileSystemId}"
        }
      }
    }
  }

  gauge "total_storage" {
    index       = 9
    input_unit  = "bytes"
    output_unit = "bytes"
    aggregator  = "MAX"
    source cloudwatch "total_storage" {
      query {
        aggregator  = "Maximum"
        namespace   = "AWS/EFS"
        metric_name = "StorageBytes"

        dimensions = {
          "FileSystemId" = "$input{FileSystemId}"
          "StorageClass" = "Total"
        }
      }
    }
  }
}
