#!/bin/bash
# have ndk-build in your $PATH and the script figures out where your ANDROID_NDK is at
####################################################
# You do not need to modify anything below this line
####################################################
# find system torch, if not found, install it
command -v luajit -ltorch >/dev/null 2>&1
TORCHINSTALLCHECK=$?
if [ $TORCHINSTALLCHECK -ne 0 ]; then
    echo "Torch-7 not found on system. Please install it using instructions from http://torch.ch"
    exit -1
fi
# have ndk-build in your PATH and the script figures out where your ANDROID_NDK is at
unamestr=`uname`
ndkbuildloc=`which ndk-build`
if [[ "$unamestr" == 'Linux' ]]; then
    export ANDROID_NDK=`readlink -f $ndkbuildloc|sed 's/ndk-exec.sh//'|sed 's/ndk-build//'`
elif [[ "$unamestr" == 'Darwin' ]]; then
    brew install coreutils
    export ANDROID_NDK=`greadlink -f $ndkbuildloc|sed 's/ndk-exec.sh//'|sed 's/ndk-build//'`
fi
echo "Android NDK found at: $ANDROID_NDK"
cd "$(dirname "$0")" # switch to script directory
INSTALL_DIR=`pwd`
cd src
rm -rf build
mkdir -p build
cd build
# CUDA_ANDROID_HOME = $ENV{CUDA_ANDROID_HOME}
# CUDA_TOOLKIT_ROOT = $ENV{CUDA_TOOLKIT_ROOT}
cmake VERBOSE=1 -DCMAKE_TOOLCHAIN_FILE=../cmake/android.toolchain.cmake .. -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR -DANDROID_STL=none -DANDROID_TOOLCHAIN_NAME=aarch64-linux-android-4.9 -DCUDA_NVCC_EXECUTABLE=$CUDA_TOOLKIT_ROOT/bin/nvcc -DCUDA_SDK_ROOT_DIR=$CUDA_TOOLKIT_ROOT/samples -DCUDA_TOOLKIT_ROOT_DIR=$CUDA_ANDROID_HOME/aarch64-linux-androideabi

CMAKERET=$?
if [ $CMAKERET -ne 0 ]; then
 echo "CMake error. Exiting."
 exit $CMAKERET
fi
make install
MAKERET=$?
if [ $MAKERET -ne 0 ]; then
 echo "make error. Exiting."
 exit $MAKERET
fi
cd ../../

# copy libs
echo "Copying libraries"
rm -rf lib
mkdir -p lib
cp src/libs/armeabi-v7a/*.a lib/
echo "done"

# export lua sources
echo "exporting lua sources"
rm -rf share
mkdir -p share/lua/5.1/torch
cp -r src/pkg/torch/*.lua share/lua/5.1/torch/

mkdir -p share/lua/5.1/dok
cp -r src/pkg/dok/*.lua share/lua/5.1/dok/

mkdir -p share/lua/5.1/nn
cp -r src/3rdparty/nn/*.lua share/lua/5.1/nn/

mkdir -p share/lua/5.1/image
cp -r src/3rdparty/image/*.lua share/lua/5.1/image/

mkdir -p share/lua/5.1/nnx
cp -r src/3rdparty/nnx/*.lua share/lua/5.1/nnx/

mkdir -p share/lua/5.1/imgraph
cp -r src/3rdparty/imgraph/*.lua share/lua/5.1/imgraph/
echo "done"

mkdir -p share/lua/5.1/cutorch
cp -r src/3rdparty/cutorch/*.lua share/lua/5.1/cutorch/
echo "done"
#remove cmake files in framework
echo "removing cmake files in framework"
rm -rf share/cmake
echo "done"
