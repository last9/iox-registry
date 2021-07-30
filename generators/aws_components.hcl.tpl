extends aws_alb_cloudwatch "albs_<region>" {
  source_uri = "https://github.com/last9/iox-registry/releases/download/v0.0.13/aws_alb_cloudwatch.hcl"
    vars = {
      using  = "<region>"
        inputs = file("${pwd}/applicationelb_<region>.json")
    }
}

extends aws_elb_cloudwatch "elbs_<region>" {
  source_uri = "https://github.com/last9/iox-registry/releases/download/v0.0.13/aws_elb_cloudwatch.hcl"
    vars = {
      using  = "<region>"
        inputs = file("${pwd}/elb_<region>.json")
    }
}

extends aws_elb_endpoint_cloudwatch "elbs_<region>" {
  source_uri = "https://github.com/last9/iox-registry/releases/download/v0.0.13/aws_elb_cloudwatch.hcl"
    vars = {
      using    = "<region>"
        inputs   = file("${pwd}/elb_<region>.json")
        endpoint = "/"
    }
}

extends aws_alb_endpoint_cloudwatch "elbs_<region>" {
  source_uri = "https://github.com/last9/iox-registry/releases/download/v0.0.13/aws_alb_cloudwatch.hcl"
    vars = {
      using    = "<region>"
        inputs   = file("${pwd}/applicationelb_<region>.json")
        endpoint = "/"
    }
}

extends aws_elasticache_redis_cloudwatch "elasticache_redis_<region>" {
  source_uri = "https://github.com/last9/iox-registry/releases/download/v0.0.13/aws_elasticache_cloudwatch.hcl"
    vars = {
      using  = "<region>"
        inputs = file("${pwd}/elasticache_<region>.json")
    }
}

extends aws_elasticache_cluster_cloudwatch "elasticache_cluster_<region>" {
  source_uri = "https://github.com/last9/iox-registry/releases/download/v0.0.13/aws_elasticache_cloudwatch.hcl"
    vars = {
      using  = "<region>"
        inputs = file("${pwd}/elasticache_<region>.json")
    }
}

extends aws_dynamodb_table_operation_cloudwatch "dynamodb_table_ops_<region>" {
  source_uri = "https://github.com/last9/iox-registry/releases/download/v0.0.13/aws_dynamodb_cloudwatch.hcl"
    vars = {
      using = "<region>"
        inputs = cross_join(file("${pwd}/dynamodb_<region>.json"), <<-EOF
            [{
            "Operation": "Query"
            }, {
            "Operation": "Scan"
            }, {
            "Operation": "GetItem"
            }, {
            "Operation": "BatchWriteItem"
            }, {
            "Operation": "DeleteItem"
            }, {
            "Operation": "UpdateItem"
            }, {
            "Operation": "PutItem"
            }]
            EOF
            )
    }
}

extends aws_dynamodb_table_cloudwatch "dynamodb_tables_<region>" {
  source_uri = "https://github.com/last9/iox-registry/releases/download/v0.0.13/aws_dynamodb_cloudwatch.hcl"
    vars = {
      using  = "<region>"
        inputs = file("${pwd}/dynamodb_<region>.json")
    }
}

extends aws_rds_logical_cloudwatch "rds_tables_<region>" {
  source_uri = "https://github.com/last9/iox-registry/releases/download/v0.0.13/aws_rds_cloudwatch.hcl"
    vars = {
      using  = "<region>"
        inputs = file("${pwd}/rds_<region>.json")
    }
}

extends aws_rds_physical_cloudwatch "peg_rds_physical_<region>" {
  source_uri = "https://github.com/last9/iox-registry/releases/download/v0.0.13/aws_rds_cloudwatch.hcl"
    vars = {
      using  = "<region>"
        inputs = file("${pwd}/rds_<region>.json")
    }
}

extends aws_dax_cloudwatch "dax_<region>" {
  source_uri = "https://github.com/last9/iox-registry/releases/download/v0.0.13/aws_dax_cloudwatch.hcl"
    vars = {
      using  = "<region>"
        inputs = file("${pwd}/dax_<region>.json")
    }
}

extends aws_lambda_cloudwatch "lambda_<region>" {
  source_uri = "https://github.com/last9/iox-registry/releases/download/v0.0.13/aws_lambda_cloudwatch.hcl"
    vars = {
      using  = "<region>"
        inputs = file("${pwd}/lambda_<region>.json")
    }
}

extends aws_ec2_cloudwatch "ec2_<region>" {
  source_uri = "https://github.com/last9/iox-registry/releases/download/v0.0.13/aws_ec2_cloudwatch.hcl"
    vars = {
      using  = "<region>"
        inputs = file("${pwd}/ec2_<region>.json")
    }
}

extends aws_apigateway_cloudwatch "apigateway_<region>" {
  source_uri = "https://github.com/last9/iox-registry/releases/download/v0.0.13/aws_apigateway_cloudwatch.hcl"
    vars = {
      using  = "<region>"
        inputs = file("${pwd}/apigateway_<region>.json")
    }
}

extends aws_elasticsearch_cloudwatch "elasticsearch_<region>" {
  source_uri = "https://github.com/last9/iox-registry/releases/download/v0.0.13/aws_elasticsearch_cloudwatch.hcl"
    vars = {
      using  = "<region>"
        inputs = file("${pwd}/es_<region>.json")
    }
}

extends aws_elasticsearch_master_cloudwatch "elasticsearch_<region>" {
  source_uri = "https://github.com/last9/iox-registry/releases/download/v0.0.13/aws_elasticsearch_cloudwatch.hcl"
    vars = {
      using  = "<region>"
        inputs = file("${pwd}/es_<region>.json")
    }
}

extends aws_sqs_cloudwatch "sqs_<region>" {
  source_uri = "https://github.com/last9/iox-registry/releases/download/v0.0.13/aws_sqs_cloudwatch.hcl"
    vars = {
      using  = "<region>"
        inputs = file("${pwd}/sqs_<region>.json")
    }
}

extends aws_cloudfront_endpoint_cloudwatch "cloudfront_<region>" {
  source_uri = "https://github.com/last9/iox-registry/releases/download/v0.0.13/aws_cloudfront_cloudwatch.hcl"
    vars = {
      using  = "<region>"
        inputs = file("${pwd}/cloudfront_<region>.json")
    }
}

extends aws_eks_containerinsights_service_cloudwatch "eks_service_containerinsights_<region>" {
  source_uri = "https://github.com/last9/iox-registry/releases/download/v0.0.13/aws_eks_containerinsights_cloudwatch.hcl"
    vars = {
      using  = "<region>"
        inputs = file("${pwd}/eks_service_containerinsights_<region>.json")
    }
}

extends aws_eks_containerinsights_pod_cloudwatch "eks_pod_containerinsights_<region>" {
  source_uri = "https://github.com/last9/iox-registry/releases/download/v0.0.13/aws_eks_containerinsights_cloudwatch.hcl"
    vars = {
      using  = "<region>"
        inputs = file("${pwd}/eks_pod_containerinsights_<region>.json")
    }
}

extends aws_eks_containerinsights_cluster_cloudwatch "eks_cluster_containerinsights_<region>" {
  source_uri = "https://github.com/last9/iox-registry/releases/download/v0.0.13/aws_eks_containerinsights_cloudwatch.hcl"
    vars = {
      using  = "<region>"
        inputs = file("${pwd}/eks_cluster_containerinsights_<region>.json")
    }
}
