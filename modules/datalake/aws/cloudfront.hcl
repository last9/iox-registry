ingester aws_cloudfront module {
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
    name = "$output{tag_service}"
  }

  label {
    type = "namespace"
    name = "$output{domain}"
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

    source prometheus "status_5xx" {
      query = "sum by (DistributionId, Region, tag_domain, tag_service) (status_5xx)"

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

    source prometheus "status_4xx" {
      query = "sum by (DistributionId, Region, tag_domain, tag_service) (status_4xx)"

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
      query = "sum by (DistributionId, Region, tag_domain, tag_service) (bytes_out)"

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
      query = "sum by (DistributionId, Region, tag_domain, tag_service) (bytes_in)"

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
      query = "sum by (DistributionId, Region, tag_domain, tag_service) (throughput)"

      join_on = {
        "$output{DistributionId}" = "$input{DistributionId}"
        "$output{Region}"         = "$input{Region}"
      }
    }
  }
}
