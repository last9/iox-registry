.ONESHELL:
SHELL = /bin/bash

last9_cli_version := 0.0.8-f9d100715

load_last9_cli:
	which /tmp/last9/last9 || (mkdir -p /tmp/last9; cd /tmp/last9; wget https://last9-public-artifactory.s3.ap-south-1.amazonaws.com/last9/last9_${last9_cli_version}_linux.zip -O last9.zip && unzip last9.zip)

lint:
	find ../modules -name "*.hcl" | xargs -I {} bash -c "printf 'Linting {}\n' && diff {} <(hclfmt -check {})"

plan: load_last9_cli
	/tmp/last9/last9 iox plan --dir . --subgraph

test: lint plan

