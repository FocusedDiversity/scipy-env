FROM synaptiq/scipy-env-gpu:v5

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update --fix-missing && apt-get install -y \
    cuda-toolkit-10-2 \
    libcudnn7-dev \
    build-essential ccache cmake unzip pkg-config \
    libjpeg-dev libpng-dev libtiff-dev \
    libavcodec-dev libavformat-dev libswscale-dev libv4l-dev \
    libxvidcore-dev libx264-dev \
    libavresample-dev \
    libtesseract-dev \
    libfreetype6-dev \
    libatlas-base-dev gfortran \
    libprotobuf-dev protobuf-compiler

RUN wget --quiet -O opencv.zip https://github.com/opencv/opencv/archive/4.1.2.zip &&\
    wget --quiet -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/4.1.2.zip &&\
    unzip -q opencv.zip &&\
    unzip -q opencv_contrib.zip &&\
    rm opencv.zip &&\
    rm opencv_contrib.zip &&\
    mv opencv-4.1.2 opencv &&\
    mv opencv_contrib-4.1.2 opencv_contrib &&\
    cd opencv &&\
    mkdir build &&\
    cd build &&\
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
        -D CMAKE_INSTALL_PREFIX=/opt/opencv \
        -D BUILD_opencv_python2=OFF \
        -D BUILD_opencv_python3=ON \
        -D BUILD_opencv_java=ON \
        -D BUILD_PROTOBUF=ON \
        -D PYTHON2_EXECUTABLE=OFF \
        -D PYTHON3_EXECUTABLE=/opt/conda/bin/python \
        -D PYTHON_LIBRARIES=/opt/conda \
        -D PYTHON_INCLUDE_DIRS=/opt/conda \
        -D INSTALL_PYTHON_EXAMPLES=OFF \
        -D BUILD_opencv_cudacodec=ON \
        -D CUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda \
        -D WITH_CUDA=ON \
        -D CUDA_GENERATION=Auto \
        -D CUDA_FAST_MATH=1 \
        -D WITH_CUDNN=1 \
        -D OPENCV_DNN_CUDA=1 \
        -D WITH_CUBLAS=1 \
        -D INSTALL_C_EXAMPLES=OFF \
        -D BUILD_EXAMPLES=OFF \
        -D OPENCV_ENABLE_NONFREE=OFF \
        -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
        -D ENABLE_PRECOMPILED_HEADERS=ON \
        -D ENABLE_FAST_MATH=1 \
        -D WITH_V4L=ON \
        -D WITH_IPP=ON \
        -D WITH_TBB=ON \
        -D WITH_EIGEN=ON \
        .. && \
        make -j8 &&\
        make install
