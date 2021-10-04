ingester cloudflare_cdn module {
  lookback = 600

  # Should be less than frequency
  timeout    = 30
  resolution = 60
  frequency  = 60
  lag        = 60

  label {
    type = "namespace"
    name = "$output{host}.cdn"
  }

  label {
    type = "service"
    name = "$input{service_label}"
  }

  physical_component {
    type = "cloudflare_cdn"
    name = "Cloudflare CDN"
  }

  physical_address {
    type = "cloudflare_zone"
    name = "$input{zone}"
  }

  data_for_graph_node {
    type = "cloudflare_endpoint"
    name = "$output{host}.cdn$input{path}"
  }

  using = {
    "default" : "$input{using}"
  }

  inputs = "$input{inputs}"

  gauge "throughput" {
    unit = "rpm"
    source cloudflare "throughput" {
      query = <<-EOH
{
  viewer {
    zones(filter: {zoneTag: "$input{zone}"}) {
      httpRequestsAdaptiveGroups(filter: {datetime_geq: "$input{floor_time}", datetime_lt: "$input{ceiling_time}",
        clientRequestPath_like: "$input{path}"}, limit: 10000) {
        count
        dimensions {
          datetimeMinute
          clientRequestHTTPHost
        }
      }
    }
  }
}
EOH
      value = "count"
      dimensions = {
        "host" : "dimensions.clientRequestHTTPHost"
      }
    }
  }

  gauge "status_2xx" {
    unit = "rpm"
    source cloudflare "2xx" {
      query = <<-EOH
{
  viewer {
    zones(filter: {zoneTag: "$input{zone}"}) {
      httpRequestsAdaptiveGroups(filter: {datetime_geq: "$input{floor_time}", datetime_lt: "$input{ceiling_time}",
        clientRequestPath_like: "$input{path}", AND: [
          {edgeResponseStatus_geq: 200},
          {edgeResponseStatus_lt: 300},
          ]}, limit: 10000
        ) {
        count
        dimensions {
          datetimeMinute
          clientRequestHTTPHost
        }
      }
    }
  }
}
EOH
      value = "count"
      dimensions = {
        "host" : "dimensions.clientRequestHTTPHost"
      }
    }
  }

  gauge "status_3xx" {
    unit = "rpm"
    source cloudflare "3xx" {
      query = <<-EOH
{
  viewer {
    zones(filter: {zoneTag: "$input{zone}"}) {
      httpRequestsAdaptiveGroups(filter: {datetime_geq: "$input{floor_time}", datetime_lt: "$input{ceiling_time}",
        clientRequestPath_like: "$input{path}", AND: [
          {edgeResponseStatus_geq: 300},
          {edgeResponseStatus_lt: 400},
          ]}, limit: 10000
        ) {
        count
        dimensions {
          datetimeMinute
          clientRequestHTTPHost
        }
      }
    }
  }
}
EOH
      value = "count"
      dimensions = {
        "host" : "dimensions.clientRequestHTTPHost"
      }
    }
  }

  gauge "status_4xx" {
    unit = "rpm"
    source cloudflare "4xx" {
      query = <<-EOH
{
  viewer {
    zones(filter: {zoneTag: "$input{zone}"}) {
      httpRequestsAdaptiveGroups(filter: {datetime_geq: "$input{floor_time}", datetime_lt: "$input{ceiling_time}",
        clientRequestPath_like: "$input{path}", AND: [
          {edgeResponseStatus_geq: 400},
          {edgeResponseStatus_lt: 500},
          ]}, limit: 10000
        ) {
        count
        dimensions {
          datetimeMinute
          clientRequestHTTPHost
        }
      }
    }
  }
}
EOH
      value = "count"
      dimensions = {
        "host" : "dimensions.clientRequestHTTPHost"
      }
    }
  }

  gauge "status_5xx" {
    unit = "rpm"
    source cloudflare "5xx" {
      query = <<-EOH
{
  viewer {
    zones(filter: {zoneTag: "$input{zone}"}) {
      httpRequestsAdaptiveGroups(filter: {datetime_geq: "$input{floor_time}", datetime_lt: "$input{ceiling_time}",
        clientRequestPath_like: "$input{path}", AND: [
          {edgeResponseStatus_geq: 500},
          {edgeResponseStatus_lt: 600},
          ]}, limit: 10000
        ) {
        count
        dimensions {
          datetimeMinute
          clientRequestHTTPHost
        }
      }
    }
  }
}
EOH
      value = "count"
      dimensions = {
        "host" : "dimensions.clientRequestHTTPHost"
      }
    }
  }
}

ingester cloudflare_waf module {
  lookback = 600

  # Should be less than frequency
  timeout    = 30
  resolution = 60
  frequency  = 60
  lag        = 60

  label {
    type = "namespace"
    name = "$output{host}.waf"
  }

  label {
    type = "service"
    name = "$input{service_label}"
  }

  physical_component {
    type = "cloudflare_waf"
    name = "Cloudflare WAF"
  }

  physical_address {
    type = "cloudflare_zone"
    name = "$input{zone}"
  }

  data_for_graph_node {
    type = "cloudflare_endpoint"
    name = "$output{host}.waf$input{path}"
  }

  using = {
    "default" : "$input{using}"
  }

  inputs = "$input{inputs}"

  gauge "throughput" {
    unit = "rpm"
    source cloudflare "throughput" {
      query = <<-EOH
{
  viewer {
    zones(filter: {zoneTag: "$input{zone}"}) {
      firewallEventsAdaptiveGroups(filter: {datetime_geq: "$input{floor_time}", datetime_lt: "$input{ceiling_time}",
        clientRequestPath_like: "$input{path}"}, limit: 10000) {
        count
        dimensions {
          datetimeMinute
          clientRequestHTTPHost
        }
      }
    }
  }
}
EOH
      value = "count"
      dimensions = {
        "host" : "dimensions.clientRequestHTTPHost"
      }
    }
  }

  gauge "connection_close" {
    unit = "rpm"
    source cloudflare "connection_close" {
      query = <<-EOH
  {
    viewer {
      zones(filter: {zoneTag: "$input{zone}"}) {
        firewallEventsAdaptiveGroups(filter: {datetime_geq: "$input{floor_time}", datetime_lt: "$input{ceiling_time}",
          clientRequestPath_like: "$input{path}", action: "connection_close"}, limit: 10000
          ) {
          count
          dimensions {
            datetimeMinute
            clientRequestHTTPHost
          }
        }
      }
    }
  }
  EOH
      value = "count"
      dimensions = {
        "host" : "dimensions.clientRequestHTTPHost"
      }
    }
  }

  gauge "bypass" {
    unit = "rpm"
    source cloudflare "bypass" {
      query = <<-EOH
  {
    viewer {
      zones(filter: {zoneTag: "$input{zone}"}) {
        firewallEventsAdaptiveGroups(filter: {datetime_geq: "$input{floor_time}", datetime_lt: "$input{ceiling_time}",
          clientRequestPath_like: "$input{path}", action: "bypass"}, limit: 10000
          ) {
          count
          dimensions {
            datetimeMinute
            clientRequestHTTPHost
          }
        }
      }
    }
  }
  EOH
      value = "count"
      dimensions = {
        "host" : "dimensions.clientRequestHTTPHost"
      }
    }
  }

  gauge "jschallenge" {
    unit = "rpm"
    source cloudflare "jschallenge" {
      query = <<-EOH
  {
    viewer {
      zones(filter: {zoneTag: "$input{zone}"}) {
        firewallEventsAdaptiveGroups(filter: {datetime_geq: "$input{floor_time}", datetime_lt: "$input{ceiling_time}",
          clientRequestPath_like: "$input{path}", action: "jschallenge"}, limit: 10000
          ) {
          count
          dimensions {
            datetimeMinute
            clientRequestHTTPHost
          }
        }
      }
    }
  }
  EOH
      value = "count"
      dimensions = {
        "host" : "dimensions.clientRequestHTTPHost"
      }
    }
  }

  gauge "log" {
    unit = "rpm"
    source cloudflare "log" {
      query = <<-EOH
  {
    viewer {
      zones(filter: {zoneTag: "$input{zone}"}) {
        firewallEventsAdaptiveGroups(filter: {datetime_geq: "$input{floor_time}", datetime_lt: "$input{ceiling_time}",
          clientRequestPath_like: "$input{path}", action: "log"}, limit: 10000
          ) {
          count
          dimensions {
            datetimeMinute
            clientRequestHTTPHost
          }
        }
      }
    }
  }
  EOH
      value = "count"
      dimensions = {
        "host" : "dimensions.clientRequestHTTPHost"
      }
    }
  }

  gauge "block" {
    unit = "rpm"
    source cloudflare "block" {
      query = <<-EOH
  {
    viewer {
      zones(filter: {zoneTag: "$input{zone}"}) {
        firewallEventsAdaptiveGroups(filter: {datetime_geq: "$input{floor_time}", datetime_lt: "$input{ceiling_time}",
          clientRequestPath_like: "$input{path}", action: "block"}, limit: 10000
          ) {
          count
          dimensions {
            datetimeMinute
            clientRequestHTTPHost
          }
        }
      }
    }
  }
  EOH
      value = "count"
      dimensions = {
        "host" : "dimensions.clientRequestHTTPHost"
      }
    }
  }

  gauge "status_2xx" {
    unit = "rpm"
    source cloudflare "2xx" {
      query = <<-EOH
  {
    viewer {
      zones(filter: {zoneTag: "$input{zone}"}) {
        firewallEventsAdaptiveGroups(filter: {datetime_geq: "$input{floor_time}", datetime_lt: "$input{ceiling_time}",
          clientRequestPath_like: "$input{path}", AND: [
            {edgeResponseStatus_geq: 200},
            {edgeResponseStatus_lt: 300},
            ]}, limit: 10000
          ) {
          count
          dimensions {
            datetimeMinute
            clientRequestHTTPHost
          }
        }
      }
    }
  }
  EOH
      value = "count"
      dimensions = {
        "host" : "dimensions.clientRequestHTTPHost"
      }
    }
  }

  gauge "status_4xx" {
    unit = "rpm"
    source cloudflare "4xx" {
      query = <<-EOH
  {
    viewer {
      zones(filter: {zoneTag: "$input{zone}"}) {
        firewallEventsAdaptiveGroups(filter: {datetime_geq: "$input{floor_time}", datetime_lt: "$input{ceiling_time}",
          clientRequestPath_like: "$input{path}", AND: [
            {edgeResponseStatus_geq: 400},
            {edgeResponseStatus_lt: 500},
            ]}, limit: 10000
          ) {
          count
          dimensions {
            datetimeMinute
            clientRequestHTTPHost
          }
        }
      }
    }
  }
  EOH
      value = "count"
      dimensions = {
        "host" : "dimensions.clientRequestHTTPHost"
      }
    }
  }

  gauge "status_5xx" {
    unit = "rpm"
    source cloudflare "5xx" {
      query = <<-EOH
  {
    viewer {
      zones(filter: {zoneTag: "$input{zone}"}) {
        firewallEventsAdaptiveGroups(filter: {datetime_geq: "$input{floor_time}", datetime_lt: "$input{ceiling_time}",
          clientRequestPath_like: "$input{path}", AND: [
            {edgeResponseStatus_geq: 500},
            {edgeResponseStatus_lt: 600},
            ]}, limit: 10000
          ) {
          count
          dimensions {
            datetimeMinute
            clientRequestHTTPHost
          }
        }
      }
    }
  }
  EOH
      value = "count"
      dimensions = {
        "host" : "dimensions.clientRequestHTTPHost"
      }
    }
  }
}