VERSION:=v1
PROJECT=synaptiq/scipy-env-gpu-tf115
PORT:=8889

.PHONY: default
default: build

.PHONY: build
build:
	docker image build \
        -t ${PROJECT}:${VERSION} -t ${PROJECT}:latest \
        .

.PHONY: publish
publish:
	docker image push ${PROJECT}:${VERSION} 
	docker image push ${PROJECT}:latest

.PHONY: run
run: build
	docker container run -ti -P \
		-e PORT=${PORT} \
		-p ${PORT}:${PORT} \
        ${PROJECT}:latest 

.PHONY: run-shell
run-shell: build
	docker container run -ti -P \
	${PROJECT}:latest /bin/sh
