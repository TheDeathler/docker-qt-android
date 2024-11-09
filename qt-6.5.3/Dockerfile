FROM ubuntu:24.04


ARG QT_VERSION=6.5
ARG QT_VERSION_FULL=6.5.3
ARG ANDROID_NDK_VERSION=25.1.8937393
ARG ANDROID_SDK_VERSION=33
ARG ANDROID_BUILD_TOOLS_VERSION=33.0.0

# Update the package list and install necessary packages
RUN apt-get update && apt-get install -y -f \
    build-essential \
    coreutils \
    curl \
    git \
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
    llvm

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

RUN apt-get install -y -f \
    libxrender-dev  \
    libpng-dev \
    libgl-dev

RUN apt-get upgrade -y

RUN apt-get install -y -f \
    android-sdk \
    google-android-ndk-r25c-installer


#RUN apt-get install -y -f \
#    google-android-build-tools-31.0.0-installer \
#    google-android-cmdline-tools-11.0-installer

#RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 11 --slave /usr/bin/g++ g++ /usr/bin/g++-11

# Install Android SDK
#RUN mkdir -p /opt/android-sdk && \
#    cd /opt/android-sdk && \
#    wget https://dl.google.com/android/repository/commandlinetools-linux-8092744_latest.zip -O android-sdk.zip && \
#    unzip android-sdk.zip && \
#    rm android-sdk.zip && \
#    yes | ./cmdline-tools/bin/sdkmanager --sdk_root=/opt/android-sdk --licenses && \
#    ./cmdline-tools/bin/sdkmanager --sdk_root=/opt/android-sdk --update && \
#    ./cmdline-tools/bin/sdkmanager --sdk_root=/opt/android-sdk --install "cmdline-tools;latest" && \
#    ./cmdline-tools/bin/sdkmanager --sdk_root=/opt/android-sdk --install "platform-tools" "platforms;android-${ANDROID_SDK_VERSION}" "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" "ndk;${ANDROID_NDK_VERSION}"
#RUN yes | sdkmanager --sdk_root=/usr/lib/android-sdk --licenses && \
#    sdkmanager --sdk_root=/usr/lib/android-sdk --update && \
#    sdkmanager --sdk_root=/usr/lib/android-sdk --install "cmdline-tools;latest" && \
#    sdkmanager --sdk_root=/usr/lib/android-sdk --install "platform-tools" "platforms;android-${ANDROID_SDK_VERSION}" "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" "ndk;${ANDROID_NDK_VERSION}"


# Set environment variables
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV ANDROID_NDK_ROOT=/opt/android-sdk/ndk/${ANDROID_NDK_VERSION}
ENV ANDROID_SDK_VERSION=${ANDROID_SDK_VERSION}
ENV QT_DIR="/opt/qt-android"
ENV QT_HOST_PATH="/opt/qt-host"
ENV QT_PLUGIN_PATH="/opt/qt-host/plugins"

# Download and extract Qt source
#RUN mkdir -p /opt/qt-src && \
#    cd /opt/qt-src && \
#    wget https://download.qt.io/official_releases/qt/${QT_VERSION}/${QT_VERSION_FULL}/single/qt-everywhere-src-${QT_VERSION_FULL}.tar.xz && \
#    tar -xf qt-everywhere-src-${QT_VERSION_FULL}.tar.xz


# Qt 6 requires a host build to be able to build for a target
#RUN cd /opt/qt-src/qt-everywhere-src-${QT_VERSION_FULL} && \
#    mkdir build-host && \
#    cd build-host && \
#    ../configure \
#    -prefix ${QT_HOST_PATH} \
#    -opensource \
#    -confirm-license \
#    -skip qtwebengine \
#    -skip qtpdf \
#    -nomake examples \
#    -nomake tests && \
#    cmake --build . --parallel && \
#    cmake --install . && \
#    cd .. && \
#    rm -r build-host

# Configure and build Qt
# RUN cd /opt/qt-src/qt-everywhere-src-${QT_VERSION_FULL} && \
#    mkdir build-target && \
#    cd build-target && \
#    ../configure \
#    -platform android-clang \
#    -android-sdk ${ANDROID_SDK_ROOT} \
#    -android-ndk ${ANDROID_NDK_ROOT} \
#    -prefix ${QT_DIR} \
#    -qt-host-path ${QT_HOST_PATH} \
#    -opensource \
#    -confirm-license \
#    -skip qtwebengine \
#    -skip qtpdf \
#    -nomake examples \
#    -nomake tests && \
#    cmake --build . --parallel && \
#    cmake --install . && \
#    cd .. && \
#    rm -r build-target

# Remove Qt sources
#RUN rm /opt/qt-src/qt-everywhere-src-${QT_VERSION_FULL}.tar.xz && \
#    rm -r /opt/qt-src/qt-everywhere-src-${QT_VERSION_FULL}

# Add Qt to PATH
ENV PATH=$QT_DIR/bin:$PATH
ENV PATH="${QT_DIR}/${QT_VERSION_FULL}/android_armv7/bin/:${PATH}"

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create a workspace
WORKDIR /workspace

# Entry point
CMD ["/bin/bash"]
