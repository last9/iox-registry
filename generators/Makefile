.ONESHELL:
SHELL = /bin/bash

# Edit these for new org
tenant := <tenant>
BUCKET ?= <tenant>-bucket


last9_cli_version := 0.0.7-11d84e8c3

# Do not change anything below this line
DATE := $(shell date +%Y%m%d%H%M%S)
artifact_name := ${tenant}-iox-$(DATE).tar.gz
artifact_source := /tmp/last9/${artifact_name}

UNAME_S := $(shell uname -s)

OS := linux
ifeq ($(UNAME_S),Linux)
	OS := linux
endif
ifeq ($(UNAME_S),Darwin)
	OS := darwin
endif

ask_question = (tput bold; tput setab 1; echo -n "$1 [y/N]"; tput sgr0; read ans; [[ $${ans} == "y" ]] || exit 1)

link:
	ln -s ../generators/aws_components.hcl.tpl aws_components.hcl.tpl
	ln -s ../generators/gen_aws_json.sh gen_aws_json.sh
	ln -s ../generators/aws_init.sh aws_init.sh

clean:
	for i in $$(ls -la . | grep "\->" | awk -F ' \-> ' '{ print $$1 }' | awk -F ' ' '{ print $$9 }'); do unlink $$i; done

checklist:
	$(call ask_question, "have you ensured config.hcl is updated")

plan: clean link load_last9_cli checklist hclfmt
	/tmp/last9/last9 iox plan --dir . --subgraph

load_last9_cli:
	which /tmp/last9/last9 || (mkdir -p /tmp/last9; cd /tmp/last9; wget https://last9-public-artifactory.s3.ap-south-1.amazonaws.com/last9/last9_${last9_cli_version}_${OS}.zip -O last9.zip && unzip last9.zip)

lint:
	find . -name "*.hcl" | xargs -I {} bash -c "printf '\n\nChecking {}' && diff {} <(hclfmt -check {})"

init:
	terraform init

hclfmt:
	find . -name "*.hcl" | xargs hclfmt -w

package: plan clean
	mkdir -p /tmp/${tenant}/iox
	cp * /tmp/${tenant}/iox/
	cd /tmp/${tenant}/iox && tar -X exclude.txt -cvzf ${artifact_source} .

publish-package: package init
	aws s3 cp /tmp/last9/${artifact_name} s3://$(BUCKET)/iox/hcl/${artifact_name}

