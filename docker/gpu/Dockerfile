FROM nvidia/cuda:10.1-cudnn7-runtime-ubuntu18.04

ARG USER_ID=889
ARG GROUP_ID=889
ARG PORT=8889
ARG CONDA_VERSION="2019.10"

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

ENV DEBIAN_FRONTEND=noninteractive 
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime &&\
    apt-get update && \
    apt-get install -y \
        bzip2  \
        curl \
        gosu \
        libglib2.0-0 \
        libxext6 \
        libsm6 \
        libxrender1 \
        make \
        sed \
        tesseract-ocr \
        tesseract-ocr-eng \
        tzdata  \
        wget &&\
    curl https://apt.corretto.aws/corretto.key | apt-key add - &&\
    echo 'deb https://apt.corretto.aws stable main' > /etc/apt/sources.list.d/corretto.list &&\
    apt-get update && \
    apt-get install -y \
        java-1.8.0-amazon-corretto-jdk  \
        java-common &&\
    apt-get clean &&\
    TINI_VERSION=`curl -q https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
    wget --quiet https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb -O tini.deb && \
    dpkg -i tini.deb && \
    rm tini.deb && \
    wget --quiet https://repo.anaconda.com/archive/Anaconda3-${CONDA_VERSION}-Linux-x86_64.sh -O anaconda.sh && \
    /bin/bash anaconda.sh -b -p /opt/conda && \
    rm anaconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh

ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-amazon-corretto

ENV PATH /opt/conda/bin:$PATH

RUN echo "Install packages from the base pkgs channel" && \
    conda install \
        cudatoolkit=10.1 \
        cudnn=7.6.5 \
        gensim \
        keras \
        numpy \
        pandas \
        pillow \
        scipy \
        tensorboard \
        tensorflow-gpu \
        tensorflow-estimator \
    && echo "\nInstalling packages from the pytorch channel" \
    && conda install -y -c pytorch \
        cudatoolkit=10.1 \
        cudnn=7.6.5 \
        pytorch-gpu  \
        torchvision  \
    && echo "\nInstalling packages from the conda-forge channel" \
    && conda install -y -c conda-forge \
        tika \
        pytesseract \
        nbstripout

RUN useradd -l -u $USER_ID -g users jupyter &&\
    install -d -m 0755 -o jupyter -g users /home/jupyter

COPY ./entrypoint.sh /opt/conda/bin/entrypoint.sh
RUN chmod +x /opt/conda/bin/entrypoint.sh
EXPOSE ${PORT} 
ENV PORT=${PORT}

ENTRYPOINT [ "gosu", "jupyter", "/opt/conda/bin/entrypoint.sh" ]
CMD /opt/conda/bin/jupyter lab --ip='0.0.0.0' --port=$PORT --no-browse
