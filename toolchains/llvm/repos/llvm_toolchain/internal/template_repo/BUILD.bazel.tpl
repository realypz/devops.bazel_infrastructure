load("//toolchain_config:config.bzl", "MACRO_llvm_toolchain_config")
load("//clang_tools/clang_format:clang_format.bzl", "clang_format_check")

MACRO_llvm_toolchain_config(
    name = "llvm.@@OS@@.@@ARCH@@.cc_toolchain_config",
    llvm_dir = "@@LLVM_DIR@@",
    llvm_major_version = "@@LLVM_MAJOR_VERSION@@",
    sysroot = "@@SYSROOT@@",
)

filegroup(name = "empty")

cc_toolchain(
    name = "_llvm.@@OS@@.@@ARCH@@.cc_toolchain",
    all_files = ":empty",
    compiler_files = ":empty",
    dwp_files = ":empty",
    linker_files = ":empty",
    objcopy_files = ":empty",
    strip_files = ":empty",
    supports_param_files = 0,
    toolchain_config = ":llvm.@@OS@@.@@ARCH@@.cc_toolchain_config",
    toolchain_identifier = "_llvm.@@OS@@.@@ARCH@@.cc_toolchain.identifier",
)

toolchain(
    name = "llvm_toolchain",
    exec_compatible_with = [],
    target_compatible_with = [],
    toolchain = ":_llvm.@@OS@@.@@ARCH@@.cc_toolchain",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
    visibility = ["//visibility:public"],
)

clang_format_check(
    name = "clang_format_fix",
    clang_format_binary = "@@@LLVM_BINARIES_REPO_NAME@@//:clang-format",
    mode = "fix",
    visibility = ["//visibility:public"],
)

clang_format_check(
    name = "clang_format_diff",
    clang_format_binary = "@@@LLVM_BINARIES_REPO_NAME@@//:clang-format",
    mode = "diff",
    visibility = ["//visibility:public"],
)
