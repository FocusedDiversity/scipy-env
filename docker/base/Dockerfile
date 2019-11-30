FROM nvidia/cuda:10.1-base-ubuntu18.04

ARG USER_ID=889
ARG GROUP_ID=889
ARG PORT=8889

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN DEBIAN_FRONTEND=noninteractive && \    
    ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime &&\
    apt-get update --fix-missing && \
    apt-get install -y \
        tzdata wget bzip2 ca-certificates \
        libglib2.0-0 libxext6 libsm6 libxrender1 \
        tesseract-ocr tesseract-ocr-eng \
        git curl grep sed dpkg

RUN TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
    curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
    dpkg -i tini.deb && \
    rm tini.deb && \
    apt-get clean

ENV CONDA_VERSION="2019.10"

RUN wget --quiet https://repo.anaconda.com/archive/Anaconda3-${CONDA_VERSION}-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

ENV PATH /opt/conda/bin:$PATH

RUN /opt/conda/bin/conda install \
    gensim \
    keras \
    numpy \
    pandas \
    scipy \
    tensorflow

RUN /opt/conda/bin/conda install -c conda-forge tika pytesseract nbstripout

ADD ./entrypoint.sh /opt/conda/bin/entrypoint.sh
RUN chmod +x /opt/conda/bin/entrypoint.sh
ENTRYPOINT [ "/opt/conda/bin/entrypoint.sh" ]

RUN useradd -l -u $USER_ID -g users jupyter &&\
    install -d -m 0755 -o jupyter -g users /home/jupyter

USER jupyter

EXPOSE ${PORT}
ENV PORT=${PORT}

CMD /opt/conda/bin/jupyter lab --ip='0.0.0.0' --port=$PORT --no-browse
