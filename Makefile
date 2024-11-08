.PHONY: all dep test lint build 
PROJECT_NAME := apic-discovery-agents

WORKSPACE ?= $$(pwd)

GO_PKG_LIST := $(shell go list ./... | grep -v /vendor/)

lint:
	@golint -set_exit_status ${GO_PKG_LIST}

dep:
	@echo "Resolving go package dependencies"
	@go mod tidy
	@echo "Package dependencies completed"

update-sdk:
	@echo "Updating SDK dependencies"
	@export GOFLAGS="" && go get "github.com/Axway/agent-sdk@main"


${WORKSPACE}/apic_discovery_agent: dep
	@export time=`date +%Y%m%d%H%M%S` && \
	export version=`cat version` && \
	export commit_id=`git rev-parse --short HEAD` && \
	go build -tags static_all \
		-ldflags="-X 'github.com/Axway/agent-sdk/pkg/cmd.BuildTime=$${time}' \
				-X 'github.com/Axway/agent-sdk/pkg/cmd.BuildVersion=$${version}' \
				-X 'github.com/Axway/agent-sdk/pkg/cmd.BuildCommitSha=$${commit_id}' \
				-X 'github.com/Axway/agent-sdk/pkg/cmd.BuildAgentName=SampleDiscoveryAgent'" \
		-a -o ${WORKSPACE}/bin/apic_discovery_agent ${WORKSPACE}/main.go

build:${WORKSPACE}/apic_discovery_agent
	@echo "Build complete"

docker: dep
	docker build -t $(PROJECT_NAME):latest -f ${WORKSPACE}/build/docker/Dockerfile .
	@echo "Docker build complete"

docker-push: docker
	docker tag $(PROJECT_NAME):latest jcollins7227/beano:$(PROJECT_NAME)
	docker push jcollins7227/beano:$(PROJECT_NAME)