FROM nvidia/cuda:10.1-base-ubuntu18.04

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    tesseract-ocr tesseract-ocr-eng \
    git build-essential cmake unzip pkg-config \
    libjpeg-dev libpng-dev libtiff-dev \
    libavcodec-dev libavformat-dev libswscale-dev libv4l-dev \
    libxvidcore-dev libx264-dev \
    libgtk-3-dev libatlas-base-dev gfortran \
    python-tk \
    python3-tk python-imaging-tk

ENV CONDA_VERSION="2019.10"

RUN wget --quiet https://repo.anaconda.com/archive/Anaconda3-${CONDA_VERSION}-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

ENV PATH /opt/conda/bin:$PATH

RUN apt-get install -y curl grep sed dpkg && \
    TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
    curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
    dpkg -i tini.deb && \
    rm tini.deb && \
    apt-get clean

#ADD ./environment.yml /opt/conda/etc/environment-base.yml
#RUN /opt/conda/bin/conda env update -f /opt/conda/etc/environment-base.yml
RUN /opt/conda/bin/conda install \
    gensim \
    keras \
    numpy \
    pandas \
    scipy \
    tensorflow-gpu 

RUN /opt/conda/bin/conda install -c conda-forge tika pytesseract nbstripout

RUN wget --quiet -O opencv.zip https://github.com/opencv/opencv/archive/4.1.2.zip &&\
    wget --quiet -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/4.1.2.zip &&\
    unzip opencv.zip &&\
    unzip opencv_contrib.zip &&\
    rm opencv.zip &&\
    rm opencv_contrib.zip &&\
    mv opencv-4.1.2 opencv &&\
    mv opencv_contrib-4.1.2 opencv_contrib &&\
    cd opencv &&\
    mkdir build &&\
    cd build &&\
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
        -D BUILD_opencv_python3=yes \
        -D CMAKE_INSTALL_PREFIX=/opt/conda \
        -D INSTALL_PYTHON_EXAMPLES=ON \
        -D INSTALL_C_EXAMPLES=OFF \
        -D OPENCV_ENABLE_NONFREE=ON \
        -D WITH_CUDA=ON -D ENABLE_FAST_MATH=1 \
        -D CUDA_FAST_MATH=1 -D WITH_CUBLAS=1 \
        -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
        -D BUILD_EXAMPLES=ON \
        -D BUILD_opencv_cudacodec=OFF \
        -D ENABLE_PRECOMPILED_HEADERS=OFF \
        -D PYTHON_EXECUTABLE=/opt/conda/bin/python \
        -D BUILD_EXAMPLES=ON .. &&\
            make -j8 &&\
            make install