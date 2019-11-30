FROM synaptiq/scipy-env-base:v2

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

USER root

RUN apt-get update --fix-missing && apt-get install -y \
    git build-essential cmake unzip pkg-config \
    libjpeg-dev libpng-dev libtiff-dev \
    libavcodec-dev libavformat-dev libswscale-dev libv4l-dev \
    libxvidcore-dev libx264-dev \
    libgtk-3-dev libatlas-base-dev gfortran \
    python-tk \
    python3-tk python-imaging-tk 

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
        -D INSTALL_PYTHON_EXAMPLES=OFF \
        -D INSTALL_C_EXAMPLES=OFF \
        -D OPENCV_ENABLE_NONFREE=OFF \
        -D WITH_CUDA=ON \
        -D ENABLE_FAST_MATH=1 \
        -D CUDA_FAST_MATH=1 -D WITH_CUBLAS=1 \
        -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
        -D BUILD_EXAMPLES=OFF \
        -D BUILD_opencv_cudacodec=OFF \
        -D ENABLE_PRECOMPILED_HEADERS=ON \
        -D PYTHON_EXECUTABLE=/opt/conda/bin/python \
        -D BUILD_EXAMPLES=ON .. &&\
            make -j8 &&\
            make install

USER jupyter
