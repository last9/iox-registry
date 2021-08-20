#!/usr/bin/env python

"""
Usage:
    manage_service_mapping.py [--verbose] extract-dependencies --prometheus-url=<prometheus_url> --max-items=<max_items>
    manage_service_mapping.py [--verbose] bulk-add --data-api-url=<data_api_url> --org=<org> --dependencies-file=<payload_file> --max-items=<max_items>
    manage_service_mapping.py [--verbose] bulk-delete --data-api-url=<data_api_url> --org=<org> --dependencies-file=<payload_file>
    manage_service_mapping.py [--verbose] add --data-api-url=<data_api_url> --org=<org> --node-id=<node_id> --payload-file=<payload_file>
    manage_service_mapping.py [--verbose] delete --data-api-url=<data_api_url> --org=<org> --node-id=<node_id> --payload-file=<payload_file>
    manage_service_mapping.py [--verbose] get --data-api-url=<data_api_url> --org=<org> --node-id=<node_id> --direction=<direction>
Options:
    -h|--help                  show this help text.
"""

# curl 'http://127.0.0.1:9797/v1/org/groww/node/8997375544138862853:deposit-data-Prototype1/service_dependency?direction=upstream'
# curl -X POST -d @/var/tmp/add-upstream.json 'http://127.0.0.1:9797/v1/org/groww/node/8997375544138862853:deposit-data-Prototype1/add/service_dependency'
# curl -X POST -d @/var/tmp/delete-upstream.json 'http://127.0.0.1:9797/v1/org/groww/node/8997375544138862853:deposit-data-Prototype1/delete/service_dependency'

import requests


def main():
    pass


if __name__ == "main":
    main()
