FROM ubuntu:24.10


ARG QT_VERSION=5.15
ARG QT_VERSION_FULL=5.15.15
ARG ANDROID_NDK_VERSION=25.1.8937393
ARG ANDROID_SDK_VERSION=31
ARG ANDROID_BUILD_TOOLS_VERSION=31.0.0

# Update the package list and install necessary packages
RUN apt-get update && apt-get install -y \
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
    nano \
    wget

# Install Android SDK
RUN mkdir -p /opt/android-sdk && \
    cd /opt/android-sdk && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-8092744_latest.zip -O android-sdk.zip && \
    unzip android-sdk.zip && \
    rm android-sdk.zip && \
    yes | ./cmdline-tools/bin/sdkmanager --sdk_root=/opt/android-sdk --licenses && \
    ./cmdline-tools/bin/sdkmanager --sdk_root=/opt/android-sdk --update && \
    ./cmdline-tools/bin/sdkmanager --sdk_root=/opt/android-sdk --install "cmdline-tools;latest" && \
    ./cmdline-tools/bin/sdkmanager --sdk_root=/opt/android-sdk --install "platform-tools" "platforms;android-${ANDROID_SDK_VERSION}" "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" "ndk;${ANDROID_NDK_VERSION}"


# Set environment variables
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV ANDROID_NDK_ROOT=/opt/android-sdk/ndk/${ANDROID_NDK_VERSION}
ENV ANDROID_SDK_VERSION=${ANDROID_SDK_VERSION}
ENV QT_DIR=/opt/qt
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

# Download and extract Qt source
RUN mkdir -p /opt/qt-src && \
    cd /opt/qt-src && \
    wget https://download.qt.io/official_releases/qt/${QT_VERSION}/${QT_VERSION_FULL}/single/qt-everywhere-opensource-src-${QT_VERSION_FULL}.tar.xz && \
    tar -xf qt-everywhere-opensource-src-${QT_VERSION_FULL}.tar.xz

# Configure and build Qt
 RUN cd /opt/qt-src/qt-everywhere-src-${QT_VERSION_FULL} && \
    ./configure \
    -xplatform android-clang \
    -disable-rpath \
    -android-sdk ${ANDROID_SDK_ROOT} \
    -android-ndk ${ANDROID_NDK_ROOT} \
    -prefix /opt/qt \
    -opensource \
    -confirm-license \
    -nomake examples \
    -nomake tests \
    -no-warnings-are-errors && \
    make -j$(nproc) && \
    make install

# Remove Qt sources
RUN rm /opt/qt-src/qt-everywhere-opensource-src-${QT_VERSION_FULL}.tar.xz

# Add Qt to PATH
ENV PATH=$QT_DIR/bin:$PATH
ENV PATH="${QT_DIR}/${QT_VERSION_FULL}/android_armv7/bin/:${PATH}"

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create a workspace
WORKDIR /workspace

# Entry point
CMD ["/bin/bash"]
