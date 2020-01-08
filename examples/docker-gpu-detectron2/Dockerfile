FROM synaptiq/scipy-env-gpu:v7

ARG USER_NAME=user
ARG USER_ID=1000
ARG GROUP_ID=1000
ARG PORT=8889

RUN apt-get install -y \
    build-essential ccache cmake unzip pkg-config checkinstall yasm \
    cuda-toolkit-10-1 \
    libcudnn7=7.6.5.32-1+cuda10.1 \
    libcudnn7-dev=7.6.5.32-1+cuda10.1 

RUN pip install 'https://github.com/cocodataset/cocoapi/archive/master.tar.gz#subdirectory=PythonAPI'

RUN pip install 'https://github.com/facebookresearch/fvcore/archive/master.tar.gz'
# install detectron2
ENV FORCE_CUDA="1"
ENV TORCH_CUDA_ARCH_LIST="Kepler;Kepler+Tesla;Maxwell;Maxwell+Tegra;Pascal;Volta;Turing"
RUN pip install 'https://github.com/facebookresearch/detectron2/archive/master.tar.gz'

# Set a fixed model cache directory.
ENV FVCORE_CACHE="/tmp"

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
