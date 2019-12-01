FROM synaptiq/scipy-env-base:v3

ARG USER_NAME=user
ARG USER_ID=1000
ARG GROUP_ID=1000
ARG PORT=8889

RUN useradd -l -u $USER_ID -g users ${USER_NAME} &&\
    install -d -m 0755 -o ${USER_NAME} -g users \
        /home/${USER_NAME} \
        /home/${USER_NAME}/data \
        /home/${USER_NAME}/notebooks \
        /home/${USER_NAME}/scratch \
        /home/${USER_NAME}/src

VOLUME /home/${USER_NAME}/data
VOLUME /home/${USER_NAME}/notebooks
VOLUME /home/${USER_NAME}/scratch
VOLUME /home/${USER_NAME}/src

EXPOSE ${PORT}
ENV PORT=${PORT}

USER ${USER_NAME}
ENTRYPOINT [ "/opt/conda/bin/entrypoint.sh" ]
CMD /opt/conda/bin/jupyter lab --notebook-dir=/home/${USER_NAME} --ip='0.0.0.0' --port=$PORT --no-browser
