LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := torchdemo
CUDA_ANDROID_ARCH = $(CUDA_ANDROID_HOME)/aarch64-linux-androideabi
LOCAL_LDFLAGS := -L../lib/ -L$(CUDA_ANDROID_ARCH)/lib64 -L$(CUDA_ANDROID_ARCH)/lib64/stubs
LOCAL_LDLIBS := -llog -landroid -lcutorch -lluaT -ltorch-lua-static -lTH -lTHC -lnn  -ltorch -lnnx -limage -limgraph  -ltorch-lua-static -lTHC -lnn  -ltorch -lnnx -limage -limgraph -lcutorch -lcutorch -lluaT -ltorch-lua-static -lTH -lTHC -lnn  -ltorch -lnnx -limage -limgraph  -ltorch-lua-static -lTHC -lnn  -ltorch -lnnx -limage -limgraph -lcutorch -lcudart -lcuda -lcublas -lcurand
LOCAL_LDLIBS += -L$(NDK_ROOT)/sources/cxx-stl/gnu-libstdc++/4.9/libs/$(TARGET_ARCH_ABI) -lgnustl_static
LOCAL_C_INCLUDES += ../include/torch

LOCAL_SRC_FILES := torchandroid.cpp torchdemo.cpp android_fopen.c


include $(BUILD_SHARED_LIBRARY)
