USER_ID:=$(shell id -u ${USER})
GROUP_ID:=$(shell id -g ${USER})
PORT:=5${USER_ID}

.PHONY: build
run: build
        docker container run -ti -P \
        -e PORT=${PORT} \
        -p 127.0.0.1:${PORT}:${PORT} \
        -v ${PWD}/data:/home/jupyter/data:ro \
        -v ${PWD}/src:/home/jupyter/src \
        -v ${PWD}/notebooks:/home/jupyter/notebooks \
        -v ${PWD}/scratch:/home/jupyter/scratch \
        scipi-env:latest-${USER_ID}

.PHONY: build
build:
	docker image build \
        --build-arg USER_ID=${USER_ID} \
        --build-arg GROUP_ID=${GROUP_ID} \
        --build-arg PORT=${PORT} \
        -t scipi-env:latest-${USER_ID} \
        .

.PHONY: update-env
update-env:
	conda env update -f docker/environment.yml
