#!/bin/bash

export ARCH=arm64
mkdir out

BUILD_CROSS_COMPILE=~/kernel/toolchain/aarch64-linux-android-4.9/bin/aarch64-linux-android-
KERNEL_LLVM_BIN=~/kernel/toolchain/llvm-arm-toolchain-ship/10.0/bin/clang
CLANG_TRIPLE=aarch64-linux-gnu-
KERNEL_MAKE_ENV="CONFIG_BUILD_ARM64_DT_OVERLAY=y"

make -j64 -C $(pwd) O=$(pwd)/out $KERNEL_MAKE_ENV ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE REAL_CC=$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE CONFIG_SECTION_MISMATCH_WARN_ONLY=y vendor/papaya_r9q_defconfig
make -j64 -C $(pwd) O=$(pwd)/out $KERNEL_MAKE_ENV ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE REAL_CC=$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE CONFIG_SECTION_MISMATCH_WARN_ONLY=y
 
mkdir out/G990B

cp out/arch/arm64/boot/Image $(pwd)/out/G990B/Image

DTBO_FILES=$(find $(pwd)/out/arch/$ARCH/boot/dts/samsung/ -name r9q_*_w00_r*.dtbo)
    cat $(pwd)/out/arch/$ARCH/boot/dts/vendor/qcom/*.dtb > $(pwd)/out/G990B/dtb.img
    $(pwd)/tools/mkdtimg create $(pwd)/out/G990B/dtbo.img --page_size=4096 ${DTBO_FILES}