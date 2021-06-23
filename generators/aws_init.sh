#! /bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
usage() { echo "Usage: $0 [-r <region>] [-p <profile>]" 1>&2; exit 1; }
while getopts ":p:r:" o; do
  case "${o}" in
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
if [ -z "${p}" ] || [ -z "${r}" ]; then
  usage
fi

function validate_user_policies() {
  # Continue on pipe
  set -o pipefail
  echo "Looking in attached user policies $1"
  aws iam list-attached-user-policies \
    --user-name=$1 --profile=$p --region=$r | \
    jq -r -e -c '.AttachedPolicies | .[] | select (.PolicyName |
    contains("SecurityAudit"))'
}

function validate_group_policies() {
  echo "Looking for user groups attached to $1"
  aws iam list-groups-for-user \
    --user-name=$1 --profile=$p --region=$r | \
    jq -r -e -c '.Groups | .[ ] | .GroupName' | \
    xargs -I {} aws iam list-group-policies \
    --group-name={} --profile=$p --region=$r | \
    jq -r -e -c \
    '.PolicyNames | .[] | select( . | contains("SecurityAudit"))'
}

function validate_role_policies() {
  echo "Looking in attached role policies $1"
  aws iam list-attached-role-policies \
    --role-name=$1 --profile=$p --region=$r | \
    jq -r -e -c '.AttachedPolicies | .[] | select (.PolicyName |
    contains("SecurityAudit"))'
}

function validate_cloudwatch_policy() {
  namespaces=(
    "AWS/ElastiCache"
    "AWS/RDS"
    "AWS/DynamoDB"
    "AWS/DAX"
    "AWS/ApplicationELB"
    "AWS/ELB"
    "AWS/EC2"
    "AWS/CloudFront"
    "AWS/Lambda"
    "AWS/ElastiCache"
    "AWS/ApiGateway"
    "AWS/ES"
    "AWS/SQS"
  )
  for n in "${namespaces[@]}"; do \
    bash ${DIR}/gen_aws_json.sh -r $r -p $p -n $n -s "uncategorized" > $(echo $n | tr '/' '\n' | tail -n 1 | tr '[:upper:]' '[:lower:]')_${r}.json;
  done
}
# Get my user name
echo "Fetching user details"
user_or_role_name=$(aws sts get-caller-identity --profile="$p" | jq '.Arn' | awk -F '/' '{ print $2 }' | tr -d '"')
validate_user_policies "$user_or_role_name" || validate_group_policies "$user_or_role_name" || validate_role_policies "$user_or_role_name" || exit 127
validate_cloudwatch_policy || exit 127
rm -rf "*_${r}.json"
rm -rf "aws_components_${r}.hcl"
echo "Saving aws_components_${r}.hcl"
cat ${DIR}/aws_components.hcl.tpl | sed "s|<profile>|${p}|g" | sed "s|<region>|${r}|g" \
  > ${DIR}/aws_components_${r}.hcl
stat ${DIR}/config.hcl > /dev/null 2>&1 || cat ${DIR}/config.hcl.tpl | sed "s|<region>|${r}|g" \
  > ${DIR}/config.hcl
