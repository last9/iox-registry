ingester aws_cloudfront_cloudstream module {
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
    index       = 5
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "SUM"

    source prometheus "5xx" {
      query = "sum by (Region, DistributionId) (amazonaws_com_AWS_CloudFront_5xxErrorRate_sum{DistributionId='$input{DistributionId}', Region='$input{Region}'}) / sum by (Region, DistributionId) (amazonaws_com_AWS_CloudFront_5xxErrorRate_count{DistributionId='$input{DistributionId}', Region='$input{Region}'})"

      join_on = {
        "$output{DistributionId}" = "$input{DistributionId}"
        "$output{Region}"         = "$input{Region}"
      }
    }
  }

  gauge "status_4xx" {
    index       = 4
    input_unit  = "percent"
    output_unit = "percent"
    aggregator  = "SUM"

    source prometheus "4xx" {
      query = "sum by (Region, DistributionId) (amazonaws_com_AWS_CloudFront_4xxErrorRate_sum{DistributionId='$input{DistributionId}', Region='$input{Region}'}) / sum by (Region, DistributionId) (amazonaws_com_AWS_CloudFront_4xxErrorRate_count{DistributionId='$input{DistributionId}', Region='$input{Region}'})"

      join_on = {
        "$output{DistributionId}" = "$input{DistributionId}"
        "$output{Region}"         = "$input{Region}"
      }
    }
  }

  gauge "bytes_out" {
    index       = 3
    input_unit  = "bytes"
    output_unit = "Bps"
    aggregator  = "SUM"

    source prometheus "bytes_out" {
      query = "sum by (Region, DistributionId) (amazonaws_com_AWS_CloudFront_BytesDownloaded_sum{DistributionId='$input{DistributionId}', Region='$input{Region}'})"

      join_on = {
        "$output{DistributionId}" = "$input{DistributionId}"
        "$output{Region}"         = "$input{Region}"
      }
    }
  }

  gauge "bytes_in" {
    index       = 2
    input_unit  = "bytes"
    output_unit = "Bps"
    aggregator  = "SUM"

    source prometheus "bytes_in" {
      query = "sum by (Region, DistributionId) (amazonaws_com_AWS_CloudFront_BytesUploaded_sum{DistributionId='$input{DistributionId}', Region='$input{Region}'})"

      join_on = {
        "$output{DistributionId}" = "$input{DistributionId}"
        "$output{Region}"         = "$input{Region}"
      }
    }
  }

  gauge "throughput" {
    index       = 1
    input_unit  = "count"
    output_unit = "rpm"
    aggregator  = "SUM"

    source prometheus "throughput" {
      query = "sum by (Region, DistributionId) (amazonaws_com_AWS_CloudFront_Requests_sum{DistributionId='$input{DistributionId}', Region='$input{Region}'})"

      join_on = {
        "$output{DistributionId}" = "$input{DistributionId}"
        "$output{Region}"         = "$input{Region}"
      }
    }
  }
}
