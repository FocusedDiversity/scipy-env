.PHONY: build run clean test
.DEFAULT: run

USER_ID:=$(shell id -u ${USER})
PORT:=5${USER_ID}
PORT2:=6${USER_ID}
BASE_NAME=docker-gpu-detecton2
IMAGE_NAME:=${BASE_NAME}:latest-${USER}
CONTAINER_NAME:=${BASE_NAME}-${USER}
LISTEN_HOST=127.0.0.1

build:
	docker image build \
        --build-arg USER_NAME=${USER} \
        --build-arg USER_ID=${USER_ID} \
        --build-arg PORT=${PORT} \
        --build-arg PORT2=${PORT2} \
        -t ${IMAGE_NAME} \
        .

run: build
	docker container run --rm --read-only --gpus=all -ti -P \
        --name ${CONTAINER_NAME} \
	--shm-size=1g \
        -e PORT=${PORT} \
        -e PORT2=${PORT2} \
	-p ${LISTEN_HOST}:${PORT}:${PORT} \
	-p ${LISTEN_HOST}:${PORT2}:${PORT2} \
        -v ${PWD}/data:/home/${USER}/data:ro \
        -v ${PWD}/src:/home/${USER}/src \
        -v ${PWD}/notebooks:/home/${USER}/notebooks \
        -v ${PWD}/scratch:/home/${USER}/scratch \
        ${IMAGE_NAME}

test: build
	docker container run -ti -P \
	-v ${PWD}/data:/home/${USER}/data:ro \
	-v ${PWD}/pytest.ini:/home/${USER}/pytest.ini:ro \
	-v ${PWD}/src:/home/${USER}/src \
	-v ${PWD}/notebooks:/home/${USER}/notebooks \
	-v ${PWD}/scratch:/home/${USER}/scratch \
	${IMAGE_NAME} pytest 


clean:
	docker container rm ${CONTAINER_NAME}
