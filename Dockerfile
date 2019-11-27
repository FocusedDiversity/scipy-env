FROM synaptiq/scipy-env-base:v1

RUN /opt/conda/bin/conda install tensorflow-gpu 

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
