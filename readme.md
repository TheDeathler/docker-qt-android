# Docker Image for Qt 5.15.15 Android

This project contains a dockerfile to create a docker image which allows to build Qt applications using Qt 5.15.15. Qt is downloaded and compiled from source during the image creation.

- [Configure and build the image](#configure-and-build-the-image)
- [Build Qt application using cmake](#build-qt-application-using-cmake)
- [Build Qt application using qmake](#build-qt-application-using-qmake)

## Configure and build the image

You can change the Qt version, as well as the used SDK/NDK versions. Mind that the SDK and ANdroid build tools version should at least be equal:

```Docker
ARG QT_VERSION=5.15.15
ARG ANDROID_NDK_VERSION=25.1.8937393
ARG ANDROID_SDK_VERSION=31
ARG ANDROID_BUILD_TOOLS_VERSION=31.0.0
```

You might might get errors due to incorrect Qt paths etc. and hence you might have to align the URLs.

In order to build the image simply use:

```shell
docker build -t qt-android:qt-5.15.15 .
```

And in order to run the resulting image in an container:

```shell
docker run -it --rm -v /path/to/your/qt/project/:/project qt-android:qt-5.15.15
```

## Build Qt application using cmake

If you are using cmake, use the following command for example:

```shell
cmake -DANDROID_NDK:PATH="${ANDROID_NDK_ROOT}" \
    -DCMAKE_FIND_ROOT_PATH:PATH="${QT_DIR}" \
    -DANDROID_PLATFORM:STRING="android-${ANDROID_SDK_VERSION}" \
    -DANDROID_SDK:PATH="${ANDROID_SDK_ROOT}" \
    -DANDROID_ABI:STRING=armeabi-v7a \
    -DCMAKE_PREFIX_PATH:PATH="${QT_DIR}" \
    -DCMAKE_C_COMPILER:FILEPATH="${ANDROID_NDK_ROOT}/toolchains/llvm/prebuilt/linux-x86_64/bin/clang" \
    -DCMAKE_TOOLCHAIN_FILE:FILEPATH="${ANDROID_NDK_ROOT}/build/cmake/android.toolchain.cmake" \
    -DQT_QMAKE_EXECUTABLE:FILEPATH="${QT_DIR}/bin/qmake" \
    -DCMAKE_CXX_COMPILER:FILEPATH="${ANDROID_NDK_ROOT}/toolchains/llvm/prebuilt/linux-x86_64/bin/clang++" \
    -S /project \
    -B /project/build/Android_Qt_5_15_2_Clang_armeabi-v7a-Debug
```

## Build Qt application using qmake

If you are using qmake, use the following commands to build your project:

```shell
qmake
make -j$(nproc)
make install

androiddeployqt \
    --input android-AndroidTest-deployment-settings.json \
    --output android-build \
    --android-platform android-${ANDROID_SDK_VERSION} \
    --jdk $JAVA_HOME \
    --gradle
```

You might have to deploy your build targets in a specific manner to ensure that androiddeployqt can detect them. It seems the path it looks for the created files is auto generated. Hence, you can use this to copy your fields in your build directly using `make install`:

```qmake
target.path = $$OUT_PWD/$${TARGET}/libs/$$ANDROID_TARGET_ARCH
INSTALLS += target
DESTDIR += $$OUT_PWD/$${TARGET}/libs/$$ANDROID_TARGET_ARCH
```
