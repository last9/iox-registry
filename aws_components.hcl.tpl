extends alb "albs_<region>" {
  vars = {
    using      = "<region>"
    inputs = file("${pwd}/applicationelb_<region>.json")
  }
}

extends elb "elbs_<region>" {
  vars = {
    using      = "<region>"
    inputs = file("${pwd}/elb_<region>.json")
  }
}

extends elb_endpoint "elbs_<region>" {
  vars = {
    using      = "<region>"
    inputs = file("${pwd}/elb_<region>.json")
    endpoint   = "/"
  }
}

extends alb_endpoint "elbs_<region>" {
  vars = {
    using      = "<region>"
    inputs = file("${pwd}/applicationelb_<region>.json")
    endpoint   = "/"
  }
}

extends elasticache_redis "elasticache_redis_<region>" {
  vars = {
    using      = "<region>"
    inputs = file("${pwd}/elasticache_<region>.json")
  }
}

extends elasticache_cluster "elasticache_cluster_<region>" {
  vars = {
    using      = "<region>"
    inputs = file("${pwd}/elasticache_<region>.json")
  }
}

extends dynamodb_table_operation "dynamodb_table_ops_<region>" {
  vars = {
    using      = "<region>"
    inputs = cross_join(file("${pwd}/dynamodb_<region>.json"), file("${pwd}/dynamodb_ops.json"))
  }
}

extends dynamodb_table "dynamodb_tables_<region>" {
  vars = {
    using      = "<region>"
    inputs = file("${pwd}/dynamodb_<region>.json")
  }
}

extends rds_logical "rds_tables_<region>" {
  vars = {
    using      = "<region>"
    inputs = file("${pwd}/rds_<region>.json")
  }
}

extends rds_physical "peg_rds_physical_<region>" {
  vars = {
    using      = "<region>"
    inputs = file("${pwd}/rds_<region>.json")
  }
}

extends dax "dax_<region>" {
  vars = {
    using      = "<region>"
    inputs = file("${pwd}/dax_<region>.json")
  }
}

extends aws_lambda "aws_lambda_<region>" {
  vars = {
    using      = "<region>"
    inputs = file("${pwd}/lambda_<region>.json")
  }
}

extends aws_lambda_resource "aws_lambda_resource_<region>" {
  vars = {
    using      = "<region>"
    inputs = file("${pwd}/lambda_<region>.json")
  }
}

extends cloudfront_endpoint "cloudfront_<region>" {
  vars = {
    using      = "<region>"
    inputs = file("${pwd}/cloudfront_<region>.json")
  }
}

extends aws_elasticsearch "elasticsearch_<region>" {
  vars = {
    using      = "<region>"
    inputs = file("${pwd}/es_<region>.json")
  }
}
