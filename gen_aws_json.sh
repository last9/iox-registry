#! /bin/bash

usage() { echo "Usage: $0 [-s <service>] [-r <region>] [-p <profile>] [-n <namespace>]" 1>&2; exit 1; }
while getopts ":s:n:p:r:" o; do
    case "${o}" in
        s)
            s=${OPTARG}
            ;;
        n)
            n=${OPTARG}
            ;;
        r)
            r=${OPTARG}
            ;;
        p)
            p=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))
if [ -z "${s}" ] || [ -z "${n}" ] || [ -z "${p}" ] || [ -z "${r}" ]; then
    usage
fi

dims=""
id=''
case "${n}" in
  AWS/ElastiCache)
    dims='CacheClusterId,CacheNodeId'
    id='CacheClusterId'
    ;;
  AWS/RDS)
    dims='DBInstanceIdentifier'
    id='DBInstanceIdentifier'
    ;;
  AWS/DynamoDB)
    dims='TableName'
    id='TableName'
    ;;
  AWS/DAX)
    dims='ClusterId,NodeId'
    id='ClusterId'
    ;;
  AWS/ApplicationELB)
    dims='LoadBalancer'
    id='LoadBalancer'
    ;;
  AWS/ELB)
    dims='LoadBalancerName'
    id='LoadBalancerName'
    ;;
  AWS/EC2)
    dims='InstanceId'
    id='InstanceId'
    ;;
  AWS/CloudFront)
    dims='DistributionId,Region'
    id='DistributionId'
    ;;
  AWS/Lambda)
    dims='FunctionName,Resource'
    id='FunctionName'
    ;;
  AWS/ApiGateway)
    dims='ApiName,Stage'
    id='ApiName'
    ;;
  AWS/ES)
    dims='DomainName,ClientId'
    id='DomainName'
    ;;
  *)
    usage
    ;;
esac

aws cloudwatch list-metrics --namespace="${n}" --region="${r}" --profile="${p}" | python -c 'import sys, json; print(json.dumps([dict([(i["Name"], i["Value"]) for i in x["Dimensions"]]) for x in filter(lambda i: len(set([x["Name"] for x in i["Dimensions"]]).symmetric_difference("'${dims}'".split(","))) == 0, json.load(sys.stdin)["Metrics"])]))' | jq 'unique' | jq -c '[.[] | select (.'${id}') + {"namespace": "common", "service": "'${s}'"} ]' | jq
