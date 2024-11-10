FROM ubuntu:22.04


ARG QT_VERSION=6.5
ARG QT_VERSION_FULL=6.5.3
ARG ANDROID_NDK_VERSION=25.1.8937393
ENV ANDROID_NDK_VERSION=${ANDROID_NDK_VERSION}
ARG ANDROID_SDK_VERSION=33
ENV ANDROID_SDK_VERSION=${ANDROID_SDK_VERSION}
ARG ANDROID_BUILD_TOOLS_VERSION=33.0.3
ENV ANDROID_BUILD_TOOLS_VERSION=${ANDROID_BUILD_TOOLS_VERSION}

# Update the package list and install necessary packages
RUN apt update && apt install -y -f \
    build-essential \
    coreutils \
    curl \
    libgl1-mesa-dev \
    openjdk-17-jdk \
    python3 \
    python3-pip \
    perl \
    make \
    cmake \
    unzip \
    ninja-build \
    nano \
    wget \
    clang \
    ruby \
    flex \
    bison \
    autoconf \
    automake \
    gcc-11 \
    g++-11 \
    gperf \
    libtool \
    llvm \
    qt6-base-dev \
    libclang-14-dev

RUN apt install -y \
    libgl-dev \
    libegl-dev \
    libfontconfig1-dev \
    libinput-dev

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

RUN apt install -y -f \
    libxrender-dev  \
    libpng-dev
# RUN apt upgrade -y

RUN apt install -y -f \
    android-sdk \
    android-sdk-build-tools \
    sdkmanager

RUN yes | sdkmanager --sdk_root=/usr/lib/android-sdk --licenses && \
    sdkmanager --sdk_root=/usr/lib/android-sdk --install "tools" && \
    sdkmanager --sdk_root=/usr/lib/android-sdk --install "platform-tools" "platforms;android-${ANDROID_SDK_VERSION}" "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" "ndk;${ANDROID_NDK_VERSION}"


# Set environment variables
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV ANDROID_NDK_ROOT=/opt/android-sdk/ndk/${ANDROID_NDK_VERSION}
ENV ANDROID_SDK_VERSION=${ANDROID_SDK_VERSION}

ARG QT_ANDROID_PATH="/opt/qt-android"
ARG QT_LIB_PATH="/usr/lib/qt6/"
ARG QT_HOST_PATH="/opt/qt-host"
ARG QT_PLUGIN_PATH="/opt/qt-host/plugins"
ARG QT6_HOST_INFO_DIR=/usr/lib/x86_64-linux-gnu/cmake/Qt6HostInfo


# Download and extract Qt source
RUN mkdir -p /opt/qt-src && \
    cd /opt/qt-src && \
    wget https://download.qt.io/official_releases/qt/${QT_VERSION}/${QT_VERSION_FULL}/single/qt-everywhere-src-${QT_VERSION_FULL}.tar.xz && \
    tar -xf qt-everywhere-src-${QT_VERSION_FULL}.tar.xz

# Qt 6 requires a host build to be able to build for a target
RUN cd /opt/qt-src/qt-everywhere-src-${QT_VERSION_FULL} && \
    mkdir build-host && \
    cd build-host && \
    ../configure \
    -prefix ${QT_HOST_PATH} \
    -opensource \
    -confirm-license \
    -skip qtwebengine \
    -skip qtpdf \
    -nomake examples \
    -nomake tests \
    -qt-host-path ${QT_LIB_PATH} \
    -- -DQt6HostInfo_DIR=${QT6_HOST_INFO_DIR} && \
    cmake --build . --parallel $(nproc --all) && \
    cmake --install . && \
    cd .. && \
    rm -r build-host

# Configure and build Qt
RUN cd /opt/qt-src/qt-everywhere-src-${QT_VERSION_FULL} && \
    mkdir build-target && \
    cd build-target && \
    ../configure \
    -platform android-clang \
    -android-sdk ${ANDROID_SDK_ROOT} \
    -android-ndk ${ANDROID_NDK_ROOT} \
    -prefix ${QT_ANDROID_PATH} \
    -qt-host-path ${QT_HOST_PATH} \
    -opensource \
    -confirm-license \
    -skip qtwebengine \
    -skip qtpdf \
    -nomake examples \
    -nomake tests && \
    cmake --build . --parallel $(nproc --all) && \
    cmake --install . && \
    cd .. && \
    rm -r build-target

# Remove Qt sources
RUN rm /opt/qt-src/qt-everywhere-src-${QT_VERSION_FULL}.tar.xz && \
    rm -r /opt/qt-src/qt-everywhere-src-${QT_VERSION_FULL}

# Cleanup a little bit
RUN apt remove -y qt6-base-dev && apt autoremove -y

# Add Qt to PATH
ENV QT_DIR=${QT_ANDROID_PATH}
ENV PATH=$QT_DIR/bin:$PATH
ENV PATH="${QT_DIR}/${QT_VERSION_FULL}/android_armv7/bin/:${PATH}"


# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create a workspace
WORKDIR /workspace

# Entry point
CMD ["/bin/bash"]
