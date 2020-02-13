USER_ID:=$(shell id -u ${USER})
PORT:=5${USER_ID}

gpuflag=--gpus=all
ifeq ($(DISABLE_GPU), true)
gpuflag=
endif

.PHONY: default
default: run

.PHONY: run
run: build
	docker container run $(gpuflag) -ti -P \
        -e PORT=${PORT} \
        -p ${PORT}:${PORT} \
        -v ${PWD}/data:/home/${USER}/data:ro \
        -v ${PWD}/src:/home/${USER}/src \
        -v ${PWD}/notebooks:/home/${USER}/notebooks \
        -v ${PWD}/scratch:/home/${USER}/scratch \
        scipi-env:latest-${USER} 

.PHONY: test
test: build
	docker container run $(gpuflag) -ti -P \
        -e PORT=${PORT} \
        -p ${PORT}:${PORT} \
        -v ${PWD}/data:/home/${USER}/data:ro \
        -v ${PWD}/pytest.ini:/home/${USER}/pytest.ini:ro \
        -v ${PWD}/src:/home/${USER}/src \
        -v ${PWD}/notebooks:/home/${USER}/notebooks \
        -v ${PWD}/scratch:/home/${USER}/scratch \
        scipi-env:latest-${USER} pytest 


.PHONY: build
build:
	docker image build \
        --build-arg USER_NAME=${USER} \
        --build-arg USER_ID=${USER_ID} \
        --build-arg PORT=${PORT} \
        -t scipi-env:latest-${USER} \
        .

.PHONY: create-local
create-local:
	conda env create -n synaptiq -f environment.yml

.PHONY: update-local
update-local:
	conda env -n synaptiq update -f environment.yml
