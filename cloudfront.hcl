ingester cloudfront_endpoint module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  using = {
    default = "$input{using}"
  }

  inputs = "$input{inputs}"

  label {
    type = "service"
    name = "$input{service}"
  }

  label {
    type = "namespace"
    name = "$input{domain}"
  }

  physical_component {
    type = "cloudfront_distribution"
    name = "$input{DistributionId}"
  }

  data_for_graph_node {
    type = "cloudfront_distribution"
    name = "$input{DistributionId}"
  }

  gauge "status_5xx" {
    unit = "percent"
    source cloudwatch "5xx" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/CloudFront"
        metric_name = "5xxErrorRate"
        dimensions = {
          "DistributionId" = "$input{DistributionId}"
          "Region"         = "$input{Region}"
        }
      }
    }
  }
  gauge "status_4xx" {
    unit = "percent"
    source cloudwatch "4xx" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/CloudFront"
        metric_name = "4xxErrorRate"
        dimensions = {
          "DistributionId" = "$input{DistributionId}"
          "Region"         = "$input{Region}"
        }
      }
    }
  }
  gauge "bytes_out" {
    unit = "count"
    source cloudwatch "bytes_out" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/CloudFront"
        metric_name = "BytesDownloaded"
        dimensions = {
          "DistributionId" = "$input{DistributionId}"
          "Region"         = "$input{Region}"
        }
      }
    }
  }
  gauge "bytes_in" {
    unit = "count"
    source cloudwatch "bytes_in" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/CloudFront"
        metric_name = "BytesUploaded"
        dimensions = {
          "DistributionId" = "$input{DistributionId}"
          "Region"         = "$input{Region}"
        }
      }
    }
  }
  gauge "throughput" {
    unit = "count"
    source cloudwatch "throughput" {
      query {
        aggregator  = "Sum"
        namespace   = "AWS/CloudFront"
        metric_name = "Requests"
        dimensions = {
          "DistributionId" = "$input{DistributionId}"
          "Region"         = "$input{Region}"
        }
      }
    }
  }
}
