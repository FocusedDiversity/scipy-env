FROM ubuntu:18.04

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH
ENV CONDA_VERSION="2019.10"

RUN apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git

RUN wget --quiet https://repo.anaconda.com/archive/Anaconda3-${CONDA_VERSION}-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

RUN apt-get install -y curl grep sed dpkg && \
    TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
    curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
    dpkg -i tini.deb && \
    rm tini.deb && \
    apt-get clean

ADD ./environment.yml /opt/conda/etc/environment.yml
RUN /opt/conda/bin/conda env update --file /opt/conda/etc/environment.yml --prune

ARG USER_ID=1000
ARG GROUP_ID=1000
ARG PORT=8889

RUN useradd -l -u $USER_ID -g users jupyter &&\
    install -d -m 0755 -o jupyter -g users /home/jupyter

ADD ./entrypoint.sh /opt/conda/bin/entrypoint.sh
RUN chmod +x /opt/conda/bin/entrypoint.sh

USER jupyter

VOLUME /home/jupyter/data
VOLUME /home/jupyter/notebooks
VOLUME /home/jupyter/scratch
VOLUME /home/jupyter/src

EXPOSE ${PORT}

ENTRYPOINT [ "/opt/conda/bin/entrypoint.sh" ]
ENV PORT=${PORT}

CMD /opt/conda/bin/jupyter lab --notebook-dir=/home/jupyter --ip='0.0.0.0' --port=$PORT --no-browser