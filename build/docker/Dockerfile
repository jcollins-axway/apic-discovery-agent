# syntax=docker/dockerfile:experimental

# hadolint ignore=DL3007
FROM golang:1.22.9-alpine3.20 AS builder

ENV BASEPATH=/go/src/github.com/jcollins-axway/apic-discovery-agent
RUN mkdir -p ${BASEPATH}

WORKDIR ${BASEPATH}

# Copy these for gomodule dependencies
COPY go.mod go.sum ./

# Get dependancies - will also be cached if we won't change mod/sum
RUN go mod download -x

# COPY the source code as the last step
COPY . . 

ENV GOFLAGS "-mod=mod"

# hadolint ignore=SC2215
RUN  go build -tags static_all -a -o ${BASEPATH}/bin/apic_discovery_agent ${BASEPATH}/main.go

# hadolint ignore=DL3007
FROM alpine:3.20

ENV BASEPATH=/go/src/github.com/jcollins-axway/apic-discovery-agent

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder ${BASEPATH}/apic_discovery_agent.yml /apic_discovery_agent.yml
COPY --from=builder ${BASEPATH}/bin/apic_discovery_agent /discovery_agent

# suggested remediation line
# hadolint ignore=SC2015
RUN mkdir /keys /data 

VOLUME ["/keys", "/data", "/apis"]

HEALTHCHECK --retries=1 CMD /discovery_agent --status || exit 1

ENTRYPOINT ["/discovery_agent"]
