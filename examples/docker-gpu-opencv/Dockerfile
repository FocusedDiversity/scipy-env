FROM synaptiq/scipy-env-gpu-opencv-contrib:v1

ARG USER_NAME=user
ARG USER_ID=1000
ARG GROUP_ID=1000
ARG PORT=8889

# Install cocoapi from master, there are no tagged releases
RUN pip install 'https://github.com/cocodataset/cocoapi/archive/master.tar.gz#subdirectory=PythonAPI'

# Get object_detection from tensorflow research models
RUN curl -sL https://github.com/tensorflow/models/archive/v1.13.0.tar.gz | tar -xz &&\
    mv models-1.13.0 /opt/tensorflow-models &&\
    cd /opt/tensorflow-models/research &&\
    protoc object_detection/protos/*.proto --python_out=.

# Add research and research/slim to pythonpath since we can't install them properly
ENV PYTHONPATH=$PYTHONPATH:/opt/tensorflow-models/research:/opt/tensorflow-models/research/slim

RUN useradd -l -u $USER_ID -s /bin/bash -g users ${USER_NAME} &&\
    install -d -m 0755 -o ${USER_NAME} -g users /home/${USER_NAME} &&\
    install -d -m 0755 -o ${USER_NAME} -g users /home/${USER_NAME}/data &&\
    install -d -m 0755 -o ${USER_NAME} -g users /home/${USER_NAME}/notebooks &&\
    install -d -m 0755 -o ${USER_NAME} -g users /home/${USER_NAME}/scratch &&\
    install -d -m 0755 -o ${USER_NAME} -g users /home/${USER_NAME}/src
    
VOLUME /tmp
VOLUME /home/${USER_NAME}
VOLUME /home/${USER_NAME}/data
VOLUME /home/${USER_NAME}/notebooks
VOLUME /home/${USER_NAME}/scratch
VOLUME /home/${USER_NAME}/src

EXPOSE ${PORT}
ENV PORT=${PORT}
ENV SHELL=/bin/bash

USER ${USER_NAME}
ENTRYPOINT ["/opt/conda/bin/entrypoint.sh"]
CMD /opt/conda/bin/jupyter lab --ip='0.0.0.0' --port=$PORT --no-browser
