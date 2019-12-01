FROM synaptiq/scipy-env-base:v3

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

USER root

ARG spark_jars=jars
ARG img_path=kubernetes/dockerfiles
ARG k8s_tests=kubernetes/tests
ARG user=spark
ARG HADOOP_VERSION=3.2.1
ARG SPARK_VERSION=2.4.4
ARG POLYNOTE_VERSION=0.2.13
ARG KUBERNETES_CLIENT_VERSION=4.5.0
ARG PORT=8192

# groupmems -a spark -g root && \
RUN set -ex &&\
    cd /opt &&\
    groupadd -g127 spark && useradd -u 117 -r -g 127 spark &&\
    mkdir - /home/spark &&\
    chown -R spark:spark /home/spark && \
    echo "Installing coursier" && \
    curl -L -o /usr/local/bin/coursier https://git.io/coursier && \
    chmod +x /usr/local/bin/coursier && \
    echo "Installing ammonite" &&\
    sh -c '(echo "#!/usr/bin/env sh" && curl -L https://github.com/lihaoyi/Ammonite/releases/download/1.8.2/2.13-1.8.2) > /usr/local/bin/amm && chmod +x /usr/local/bin/amm' &&\
    install -o spark -d /home/spark/.ammonite && \
    echo "Installing hadoop ${HADOOP_VERSION} " && \
    curl -L http://mirrors.gigenet.com/apache/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz \
    | tar -xz \
    --exclude hadoop-${HADOOP_VERSION}/share/doc \
    --exclude hadoop-${HADOOP_VERSION}/share/hadoop/tools \
    --exclude "*-sources.jar" \
    --exclude "*-tests.jar"  \
    && \
    ln -s hadoop-* hadoop && \
    mkdir /var/log/hadoop && \
    chown ${user} /var/log/hadoop && \
    ln -s /var/log/hadoop /opt/hadoop/logs && \
    echo "/opt/hadoop/lib" > /etc/ld.so.conf.d/hadoop && \
    echo "Installing spark ${SPARK_VERSION} " && \
    curl -L https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-without-hadoop.tgz | tar -xz && \
    ln -s spark-* spark && \
    touch /opt/spark/RELEASE && \
    chown -R root:root /opt && \
    mkdir -p /opt/spark/work-dir && \
    chown ${user} /opt/spark/work-dir && \
    chmod g+ws /opt/spark/work-dir && \
    cd /opt && \
    mv spark/${k8s_tests} spark/tests && \
    cp spark/conf/spark-env.sh.template spark/conf/spark-env.sh && \
    cp spark/conf/spark-defaults.conf.template spark/conf/spark-defaults.conf && \
    echo SPARK_DIST_CLASSPATH=$(/opt/hadoop/bin/hadoop classpath) >> /opt/spark/conf/spark-env.sh && \
    echo "Upgrading kubenetes client version" && \
    rm -v /opt/spark/jars/kubernetes*.jar && \
    coursier fetch \
        --intransitive io.fabric8:kubernetes-client:4.5.0 \
        --intransitive io.fabric8:kubernetes-model:4.5.0 \
        --intransitive io.fabric8:kubernetes-model-common:4.5.0 \
        | xargs -i mv -v {} /opt/spark/jar &&\
    echo "Installing polynote " && \
    apt-get install -y build-essential &&\
    conda install -y jedi pyspark virtualenv && \
    pip install jep &&\
    curl -L https://github.com/polynote/polynote/releases/download/${POLYNOTE_VERSION}/polynote-dist.tar.gz | tar -xz && \
    cp /opt/polynote/config-template.yml /opt/polynote/config.yml &&\
    chmod a+w /opt/polynote/config.yml &&\
    echo DONE

ENV HADOOP_HOME=/opt/hadoop
ENV SPARK_HOME=/opt/spark
ENV PATH=$PATH:$HADOOP_HOME/bin:$SPARK_HOME/bin

COPY entrypoint.sh /opt/spark/bin/entrypoint.sh
ENTRYPOINT ["gosu", "spark", "/bin/bash", "/opt/spark/bin/entrypoint.sh"]

CMD python /opt/polynote/polynote.py
