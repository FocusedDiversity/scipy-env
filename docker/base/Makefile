VERSION:=v1

.PHONY: default
default: build

.PHONY: build
build:
	docker image build \
        -t synaptiq/scipy-env-base:${VERSION} \
        .
