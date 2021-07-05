config cloudwatch "default" {
  region = "ap-south-1"
}
extends aws_alb_cloudwatch "alb_ap-south-1" {
  source_uri = "../modules/aws/alb_cloudwatch.hcl"
  vars = {
    using  = "default"
    inputs = <<-EOF
    [{"LoadBalancer": "blah_1"}]
    EOF
  }
}
extends aws_alb_endpoint_cloudwatch "alb_endpoint" {
  source_uri = "../modules/aws/alb_cloudwatch.hcl"
  vars = {
    using  = "default"
    inputs = <<-EOF
    [{"LoadBalancer": "blah_2"}]
    EOF
  }
}
extends aws_alb_internal_cloudwatch "alb_internal" {
  source_uri = "../modules/aws/alb_cloudwatch.hcl"
  vars = {
    using  = "default"
    inputs = <<-EOF
    [{"LoadBalancer": "blah_1"}]
    EOF
  }
}
extends aws_alb_internal_endpoint_cloudwatch "alb_internal_endpoint" {
  source_uri = "../modules/aws/alb_cloudwatch.hcl"
  vars = {
    using  = "default"
    inputs = <<-EOF
    [{"LoadBalancer": "blah_2"}]
    EOF
  }
}
extends aws_elb_cloudwatch "elb" {
  source_uri = "../modules/aws/elb_cloudwatch.hcl"
  vars = {
    using  = "default"
    inputs = <<-EOF
    [{"LoadBalancerName": "blah_1"}]
    EOF
  }
}
extends aws_elb_endpoint_cloudwatch "elb_endpoint" {
  source_uri = "../modules/aws/elb_cloudwatch.hcl"
  vars = {
    using  = "default"
    inputs = <<-EOF
    [{"LoadBalancerName": "blah_2"}]
    EOF
  }
}
extends aws_elb_internal_cloudwatch "elb_internal" {
  source_uri = "../modules/aws/elb_cloudwatch.hcl"
  vars = {
    using  = "default"
    inputs = <<-EOF
    [{"LoadBalancerName": "blah_3"}]
    EOF
  }
}
extends aws_elb_internal_endpoint_cloudwatch "elb_internal_endpoint" {
  source_uri = "../modules/aws/elb_cloudwatch.hcl"
  vars = {
    using  = "default"
    inputs = <<-EOF
    [{"LoadBalancerName": "blah"}]
    EOF
  }
}
extends aws_cloudfront_cloudwatch "cloudfront" {
  source_uri = "../modules/aws/cloudfront_cloudwatch.hcl"
  vars = {
    using  = "default"
    inputs = <<-EOF
    [{"DistributionId": "blah"}]
    EOF
  }
}
extends aws_cloudfront_endpoint_cloudwatch "cloudfront_endpoint" {
  source_uri = "../modules/aws/cloudfront_cloudwatch.hcl"
  vars = {
    using  = "default"
    inputs = <<-EOF
    [{"DistributionId": "blah"}]
    EOF
  }
}
extends aws_ec2_cloudwatch "ec2" {
  source_uri = "../modules/aws/ec2_cloudwatch.hcl"
  vars = {
    using  = "default"
    inputs = <<-EOF
    [{"InstanceId": "blah"}]
    EOF
  }
}
extends aws_eks_containerinsights_service_cloudwatch "eks_containerinsights_service" {
  source_uri = "../modules/aws/eks_containerinsights_cloudwatch.hcl"
  vars = {
    using  = "default"
    inputs = <<-EOF
    [{"ClusterName": "blah"}]
    EOF
  }
}
extends aws_eks_containerinsights_pod_cloudwatch "eks_containerinsights_pod" {
  source_uri = "../modules/aws/eks_containerinsights_cloudwatch.hcl"
  vars = {
    using  = "default"
    inputs = <<-EOF
    [{"ClusterName": "blah"}]
    EOF
  }
}
extends aws_eks_containerinsights_cluster_cloudwatch "eks_containerinsights_cluster" {
  source_uri = "../modules/aws/eks_containerinsights_cloudwatch.hcl"
  vars = {
    using  = "default"
    inputs = <<-EOF
    [{"ClusterName": "blah"}]
    EOF
  }
}
extends aws_elasticsearch_cloudwatch "elasticsearch" {
  source_uri = "../modules/aws/elasticsearch_cloudwatch.hcl"
  vars = {
    using  = "default"
    inputs = <<-EOF
    [{"DomainName": "blah"}]
    EOF
  }
}
extends aws_elasticsearch_master_cloudwatch "elasticsearch_master" {
  source_uri = "../modules/aws/elasticsearch_cloudwatch.hcl"
  vars = {
    using  = "default"
    inputs = <<-EOF
    [{"DomainName": "blah"}]
    EOF
  }
}
extends aws_lambda_cloudwatch "lambda" {
  source_uri = "../modules/aws/lambda_cloudwatch.hcl"
  vars = {
    using  = "default"
    inputs = <<-EOF
    [{"FunctionName": "blah"}]
    EOF
  }
}
extends aws_lambda_resource_cloudwatch "lambda_resource" {
  source_uri = "../modules/aws/lambda_cloudwatch.hcl"
  vars = {
    using  = "default"
    inputs = <<-EOF
    [{"FunctionName": "blah"}]
    EOF
  }
}
extends aws_dynamodb_table_operation_cloudwatch "dynamodb_table_operation" {
  source_uri = "../modules/aws/dynamodb_cloudwatch.hcl"
  vars = {
    using  = "default"
    inputs = <<-EOF
    [{"TableName": "blah"}]
    EOF
  }
}
extends aws_dynamodb_table_cloudwatch "dynamodb_table" {
  source_uri = "../modules/aws/dynamodb_cloudwatch.hcl"
  vars = {
    using  = "default"
    inputs = <<-EOF
    [{"TableName": "blah"}]
    EOF
  }
}
extends aws_apigateway_cloudwatch "apigateway" {
  source_uri = "../modules/aws/apigateway_cloudwatch.hcl"
  vars = {
    using  = "default"
    inputs = <<-EOF
    [{"ApiName": "blah"}]
    EOF
  }
}
extends aws_apigateway_stage_cloudwatch "apigateway_stage" {
  source_uri = "../modules/aws/apigateway_cloudwatch.hcl"
  vars = {
    using  = "default"
    inputs = <<-EOF
    [{"ApiName": "blah"}]
    EOF
  }
}
extends aws_sqs_cloudwatch "sqs" {
  source_uri = "../modules/aws/sqs_cloudwatch.hcl"
  vars = {
    using  = "default"
    inputs = <<-EOF
    [{"QueueName": "blah"}]
    EOF
  }
}
extends aws_elasticache_redis_cloudwatch "elasticache_redis" {
  source_uri = "../modules/aws/elasticache_cloudwatch.hcl"
  vars = {
    using  = "default"
    inputs = <<-EOF
    [{"CacheClusterId": "blah"}]
    EOF
  }
}
extends aws_elasticache_cluster_cloudwatch "elasticache_cluster" {
  source_uri = "../modules/aws/elasticache_cloudwatch.hcl"
  vars = {
    using  = "default"
    inputs = <<-EOF
    [{"CacheClusterId": "blah"}]
    EOF
  }
}
extends aws_dax_cloudwatch "dax" {
  source_uri = "../modules/aws/dax_cloudwatch.hcl"
  vars = {
    using  = "default"
    inputs = <<-EOF
    [{"ClusterId": "blah"}]
    EOF
  }
}
extends aws_rds_logical_cloudwatch "rds_logical" {
  source_uri = "../modules/aws/rds_cloudwatch.hcl"
  vars = {
    using  = "default"
    inputs = <<-EOF
    [{"DBInstanceIdentifier": "blah"}]
    EOF
  }
}
extends aws_rds_physical_cloudwatch "rds_physical" {
  source_uri = "../modules/aws/rds_cloudwatch.hcl"
  vars = {
    using  = "default"
    inputs = <<-EOF
    [{"DBInstanceIdentifier": "blah"}]
    EOF
  }
}
