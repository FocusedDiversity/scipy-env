FROM synaptiq/scipy-env-gpu:v6

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update --fix-missing && apt-get install -y \
    cuda-toolkit-10-0 \
    libcudnn7=7.6.3.30-1+cuda10.0 \
    libcudnn7-dev=7.6.3.30-1+cuda10.0 \
    build-essential ccache cmake unzip pkg-config checkinstall yasm \
    libjpeg-dev libpng-dev libtiff-dev \
    libavcodec-dev libavformat-dev libswscale-dev libv4l-dev \
    libxvidcore-dev libx264-dev \
    libdc1394-22-dev \
    libxine2-dev  \
    libavresample-dev \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    libgtk2.0-dev libtbb-dev qt5-default \
    libfaac-dev libmp3lame-dev libtheora-dev \
    libvorbis-dev \
    libopencore-amrnb-dev libopencore-amrwb-dev \
    libtesseract-dev \
    libfreetype6-dev \
    libgflags-dev \
    libgoogle-glog-dev \
    liblapack-dev \
    libatlas-base-dev \
    libeigen3-dev \
    gfortran \
    ant \
    libprotobuf-dev protobuf-compiler

RUN conda install -y -c pytorch \
    pytorch-gpu  \
    cudatoolkit=10.0

ARG OPENCV_VERSION=4.2.0
RUN curl -sL https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.tar.gz | tar -xz &&\
    curl -sL https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.tar.gz | tar -xz &&\
    mkdir build &&\
    cd build &&\
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
        -D CMAKE_INSTALL_PREFIX=/opt/conda \
        -D BUILD_opencv_python2=OFF \
        -D BUILD_opencv_python3=ON \
        -D BUILD_opencv_java=ON \
        -D BUILD_PROTOBUF=ON \
        -D PYTHON2_EXECUTABLE=OFF \
        -D PYTHON_EXECUTABLE=/opt/conda/bin/python \
        -D PYTHON3_EXECUTABLE=/opt/conda/bin/python \
        -D PYTHON_LIBRARIES=/opt/conda \
        -D PYTHON_INCLUDE_DIRS=/opt/conda \
        -D INSTALL_PYTHON_EXAMPLES=OFF \
        -D BUILD_opencv_cudacodec=ON \
        -D CUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda \
        -D WITH_CUDA=ON \
        -D CUDA_FAST_MATH=1 \
        -D WITH_CUDNN=1 \
        -D OPENCV_DNN_CUDA=1 \
        -D CUDA_ARCH_BIN="5.3 6.0 6.0 6.1 6.2 7.0 7.5" \
        -D WITH_CUBLAS=1 \
        -D INSTALL_C_EXAMPLES=OFF \
        -D BUILD_EXAMPLES=OFF \
        -D OPENCV_ENABLE_NONFREE=OFF \
        -D OPENCV_EXTRA_MODULES_PATH=../opencv_contrib-${OPENCV_VERSION}/modules \
        -D ENABLE_FAST_MATH=1 \
        -D WITH_V4L=ON \
        -D WITH_IPP=ON \
        -D WITH_TBB=ON \
        -D WITH_EIGEN=ON \
        ../opencv-${OPENCV_VERSION} && \
        make -j8 &&\
        make install &&\
        cd .. &&\
        rm -rf build opencv-${OPENCV_VERSION} opencv_contrib-${OPENCV_VERSION}

