USER_ID:=$(shell id -u ${USER})
PORT:=5${USER_ID}

.PHONY: default
default: run

.PHONY: run
run: build
	docker container run --gpus=all -ti -P \
        -e PORT=${PORT} \
        -p 127.0.0.1:${PORT}:${PORT} \
        -v ${PWD}/data:/home/jupyter/data:ro \
        -v ${PWD}/src:/home/jupyter/src \
        -v ${PWD}/notebooks:/home/jupyter/notebooks \
        -v ${PWD}/scratch:/home/jupyter/scratch \
        scipi-env:latest-${USER_ID}

.PHONY: test
test: build
	docker container run -ti -P \
        -e PORT=${PORT} \
        -p 127.0.0.1:${PORT}:${PORT} \
        -v ${PWD}/data:/home/jupyter/data:ro \
        -v ${PWD}/pytest.ini:/home/jupyter/pytest.ini:ro \
        -v ${PWD}/src:/home/jupyter/src \
        -v ${PWD}/notebooks:/home/jupyter/notebooks \
        -v ${PWD}/scratch:/home/jupyter/scratch \
        scipi-env:latest-${USER_ID} pytest 


.PHONY: build
build:
	docker image build \
        --build-arg USER_ID=${USER_ID} \
        --build-arg PORT=${PORT} \
        -t scipi-env:latest-${USER_ID} \
        .

.PHONY: create-local
create-local:
	conda env create -n synaptiq -f environment.yml

.PHONY: update-local
update-local:
	conda env -n synaptiq update -f environment.yml
