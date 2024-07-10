"""Names, paths contants for the LLVM toolchain."""

load(
    "//toolchains/bzl_utils/common:common.bzl",
    "ARCH_NAME_AARCH64",
    "ARCH_NAME_AMD64",
    "OS_NAME_LINUX",
    "OS_NAME_MACOS",
)

DEFAULT_LLVM_DIR = {
    (OS_NAME_LINUX, ARCH_NAME_AMD64): "/usr/lib/llvm-18",
    (OS_NAME_LINUX, ARCH_NAME_AARCH64): "/usr/lib/llvm-18",
    (OS_NAME_MACOS, ARCH_NAME_AARCH64): "/opt/homebrew/opt/llvm",
}

DEFAULT_SYSROOT = {
    (OS_NAME_LINUX, ARCH_NAME_AMD64): "/",
    (OS_NAME_LINUX, ARCH_NAME_AARCH64): "/",
    (OS_NAME_MACOS, ARCH_NAME_AARCH64): "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk",
}
