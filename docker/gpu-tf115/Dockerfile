FROM synaptiq/scipy-env-base:v4

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

USER root

RUN conda install \
    tensorflow-gpu==1.15.0 \
    tensorboard==1.15.0 \
    tensorflow-estimator==1.15.1

USER jupyter
