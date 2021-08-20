#!/bin/bash

usage="$0 metric_dump_path"

if [[ $# -ne 1 ]]; then
  echo "ERROR: Invalid usage: metric dump path not provided" >&2
  echo "$usage"
  exit 1
fi

metric_dump_path=$1

if ! [[ -f $metric_dump_path ]]; then
  echo "ERROR: Invalid usage: $metric_dump_path is not a file" >&2
  echo "$usage"
  exit 1
fi

istio_metric_dump_path="/var/tmp/istio-metrics.json"
if [[ -f $istio_metric_dump_path ]]; then
  echo "STATUS: Using existing $istio_metric_dump_path" >&2
else
  echo "STATUS: Extracting istio metrics to $istio_metric_dump_path" >&2
  jq '.[] | select(.__name__ | contains("istio"))' < "$metric_dump_path" | jq -s > "$istio_metric_dump_path"
fi

prometheus_istio_workload="$(pwd)/../iox/prometheus-istio-workload.json"
parent_dir=$(dirname "$prometheus_istio_workload")
if ! [[ -d $parent_dir ]]; then
  echo "ERROR: $parent_dir does not exist" >&2
  exit 1
fi
echo "STATUS: Generating payload: $prometheus_istio_workload" >&2
jq '.[] | select(.destination_service_name != null)
    | {cluster: .cluster, destination_service_name: .destination_service_name, destination_workload: .destination_workload,
      destination_version: .destination_version, destination_workload_namespace: .destination_workload_namespace}' < "$istio_metric_dump_path" | \
        jq -s 'unique_by({cluster, destination_service_name, destination_workload, destination_version, destination_workload_namespace})' > "$prometheus_istio_workload"

prometheus_istio_k8s_pod="$(pwd)/../iox/prometheus-istio-k8s-pod.json"
parent_dir=$(dirname "$prometheus_istio_k8s_pod")
if ! [[ -d $parent_dir ]]; then
  echo "ERROR: $parent_dir does not exist" >&2
  exit 1
fi
echo "STATUS: Generating payload: $prometheus_istio_k8s_pod" >&2
jq '.[] | {cluster: .cluster, destination_workload_namespace: .destination_workload_namespace , destination_service_name: .destination_service_name}' < "$prometheus_istio_workload"  | \
        jq -s 'unique_by({cluster, destination_service_name, destination_workload_namespace})' > "$prometheus_istio_k8s_pod"

prometheus_istio_cluster="$(pwd)/../iox/prometheus-istio-cluster.json"
parent_dir=$(dirname "$prometheus_istio_cluster")
if ! [[ -d $parent_dir ]]; then
  echo "ERROR: $parent_dir does not exist" >&2
  exit 1
fi
echo "STATUS: Generating payload: $prometheus_istio_cluster" >&2
jq '.[0]' < "$prometheus_istio_workload"  | jq -s > "$prometheus_istio_cluster"
