extends aws_alb_cloudwatch "albs_<region>" {
  source_uri = "https://github.com/last9/iox-registry/releases/download/v0.0.48/aws_alb_cloudwatch.hcl"
  vars = {
    using  = "<region>"
    inputs = file("${pwd}/applicationelb_<region>.json")
  }
}

extends aws_elb_cloudwatch "elbs_<region>" {
  source_uri = "https://github.com/last9/iox-registry/releases/download/v0.0.48/aws_elb_cloudwatch.hcl"
  vars = {
    using  = "<region>"
    inputs = file("${pwd}/elb_<region>.json")
  }
}

extends aws_elasticache_redis_cloudwatch "elasticache_redis_<region>" {
  source_uri = "https://github.com/last9/iox-registry/releases/download/v0.0.48/aws_elasticache_cloudwatch.hcl"
  vars = {
    using  = "<region>"
    inputs = file("${pwd}/elasticache_<region>.json")
  }
}

extends aws_elasticache_cluster_cloudwatch "elasticache_cluster_<region>" {
  source_uri = "https://github.com/last9/iox-registry/releases/download/v0.0.48/aws_elasticache_cloudwatch.hcl"
  vars = {
    using  = "<region>"
    inputs = file("${pwd}/elasticache_<region>.json")
  }
}

extends aws_dynamodb_table_operation_cloudwatch "dynamodb_table_ops_<region>" {
  source_uri = "https://github.com/last9/iox-registry/releases/download/v0.0.48/aws_dynamodb_cloudwatch.hcl"
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
  source_uri = "https://github.com/last9/iox-registry/releases/download/v0.0.48/aws_dynamodb_cloudwatch.hcl"
  vars = {
    using  = "<region>"
    inputs = file("${pwd}/dynamodb_<region>.json")
  }
}

extends aws_rds_logical_cloudwatch "rds_tables_<region>" {
  source_uri = "https://github.com/last9/iox-registry/releases/download/v0.0.48/aws_rds_cloudwatch.hcl"
  vars = {
    using  = "<region>"
    inputs = file("${pwd}/rds_<region>.json")
  }
}

extends aws_rds_physical_cloudwatch "peg_rds_physical_<region>" {
  source_uri = "https://github.com/last9/iox-registry/releases/download/v0.0.48/aws_rds_cloudwatch.hcl"
  vars = {
    using  = "<region>"
    inputs = file("${pwd}/rds_<region>.json")
  }
}

extends aws_dax_cloudwatch "dax_<region>" {
  source_uri = "https://github.com/last9/iox-registry/releases/download/v0.0.48/aws_dax_cloudwatch.hcl"
  vars = {
    using  = "<region>"
    inputs = file("${pwd}/dax_<region>.json")
  }
}

extends aws_lambda_cloudwatch "lambda_<region>" {
  source_uri = "https://github.com/last9/iox-registry/releases/download/v0.0.48/aws_lambda_cloudwatch.hcl"
  vars = {
    using  = "<region>"
    inputs = file("${pwd}/lambda_<region>.json")
  }
}

extends aws_ec2_cloudwatch "ec2_<region>" {
  source_uri = "https://github.com/last9/iox-registry/releases/download/v0.0.48/aws_ec2_cloudwatch.hcl"
  vars = {
    using  = "<region>"
    inputs = file("${pwd}/ec2_<region>.json")
  }
}

extends aws_apigateway_cloudwatch "apigateway_<region>" {
  source_uri = "https://github.com/last9/iox-registry/releases/download/v0.0.48/aws_apigateway_cloudwatch.hcl"
  vars = {
    using  = "<region>"
    inputs = file("${pwd}/apigateway_<region>.json")
  }
}

extends aws_elasticsearch_cloudwatch "elasticsearch_<region>" {
  source_uri = "https://github.com/last9/iox-registry/releases/download/v0.0.48/aws_elasticsearch_cloudwatch.hcl"
  vars = {
    using  = "<region>"
    inputs = file("${pwd}/es_<region>.json")
  }
}

extends aws_elasticsearch_master_cloudwatch "elasticsearch_<region>" {
  source_uri = "https://github.com/last9/iox-registry/releases/download/v0.0.48/aws_elasticsearch_cloudwatch.hcl"
  vars = {
    using  = "<region>"
    inputs = file("${pwd}/es_<region>.json")
  }
}

extends aws_sqs_cloudwatch "sqs_<region>" {
  source_uri = "https://github.com/last9/iox-registry/releases/download/v0.0.48/aws_sqs_cloudwatch.hcl"
  vars = {
    using  = "<region>"
    inputs = file("${pwd}/sqs_<region>.json")
  }
}

extends aws_cloudfront_cloudwatch "cloudfront_<region>" {
  source_uri = "https://github.com/last9/iox-registry/releases/download/v0.0.48/aws_cloudfront_cloudwatch.hcl"
  vars = {
    using  = "<region>"
    inputs = file("${pwd}/cloudfront_<region>.json")
  }
}

extends aws_msk_topic_per_broker_cloudwatch "aws_msk_topic_per_broker_cloudwatch" {
  source_uri = "https://github.com/last9/iox-registry/releases/download/v0.0.48/aws_msk_cloudwatch.hcl"
  vars = {
    using  = "<region>"
    inputs = file("${pwd}/aws_msk_topic_per_broker_<region>.json")
  }
}

extends aws_msk_topic_per_consumer_grp_cloudwatch "aws_msk_topic_per_consumer_grp_cloudwatch" {
  source_uri = "https://github.com/last9/iox-registry/releases/download/v0.0.48/aws_msk_cloudwatch.hcl"
  vars = {
    using  = "<region>"
    inputs = file("${pwd}/aws_msk_topic_per_consumer_grp_<region>.json")
  }
}

extends aws_msk_partition_cloudwatch "aws_msk_partition_cloudwatch" {
  source_uri = "https://github.com/last9/iox-registry/releases/download/v0.0.48/aws_msk_cloudwatch.hcl"
  vars = {
    using  = "<region>"
    inputs = file("${pwd}/aws_msk_partition_<region>.json")
  }
}

extends aws_msk_cluster_cloudwatch "aws_msk_cluster_cloudwatch" {
  source_uri = "https://github.com/last9/iox-registry/releases/download/v0.0.48/aws_msk_cloudwatch.hcl"
  vars = {
    using  = "<region>"
    inputs = file("${pwd}/aws_msk_cluster_<region>.json")
  }
}

extends aws_msk_broker_cloudwatch "aws_msk_broker_cloudwatch" {
  source_uri = "https://github.com/last9/iox-registry/releases/download/v0.0.48/aws_msk_cloudwatch.hcl"
  vars = {
    using  = "<region>"
    inputs = file("${pwd}/aws_msk_broker_<region>.json")
  }
}

extends aws_eks_containerinsights_service_cloudwatch "eks_containerinsights_service_<region>" {
  source_uri = "https://github.com/last9/iox-registry/releases/download/v0.0.48/aws_eks_ci_k8s_service_cloudwatch.hcl"
  vars = {
    using  = "<region>"
    inputs = file("${pwd}/eks_ci_k8s_service_<region>.json")
  }
}


extends eks_containerinsights_eks_cluster_cloudwatch "eks_containerinsights_eks_cluster_<region>" {
  source_uri = "https://github.com/last9/iox-registry/releases/download/v0.0.48/aws_eks_ci_k8s_service_cloudwatch.hcl"
  vars = {
    using  = "<region>"
    inputs = file("${pwd}/eks_ci_cluster_<region>.json")
  }
}


extends aws_eks_containerinsights_deployment_without_service_cloudwatch "eks_containerinsights_deployment_without_service_<region>" {
  source_uri = "https://github.com/last9/iox-registry/releases/download/v0.0.48/aws_eks_ci_k8s_deployment_cloudwatch.hcl"
  vars = {
    using  = "<region>"
    inputs = file("${pwd}/eks_ci_k8s_deployment_without_service_<region>.json")
  }
}

extends aws_eks_containerinsights_node_cloudwatch "eks_containerinsights_node_<region>" {
  source_uri = "https://github.com/last9/iox-registry/releases/download/v0.0.48/aws_eks_ci_k8s_deployment_cloudwatch.hcl"
  vars = {
    using  = "<region>"
    inputs = file("${pwd}/eks_ci_node_<region>.json")
  }
}
