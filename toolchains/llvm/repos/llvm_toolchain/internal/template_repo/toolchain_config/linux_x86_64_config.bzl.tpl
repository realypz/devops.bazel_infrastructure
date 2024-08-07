load("@bazel_skylib//lib:paths.bzl", "paths")
load(
    "@bazel_tools//tools/cpp:unix_cc_toolchain_config.bzl",
    unix_cc_toolchain_config = "cc_toolchain_config",
)

_NOT_USED = "NOT_USED"

def _create_llvm_toolchain_config(llvm_dir, llvm_major_version, sysroot):
    """ Function: Returns a dictionary with the data for unix_cc_toolchain_config. Works for Linux x86_64.

    Args:
        llvm_dir (str): The directory where the LLVM toolchain is installed.
        llvm_major_version (int): The major version of the LLVM toolchain.
        sysroot (str): The sysroot to use for the toolchain.
                       For macosx, typically "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk".
                       For Linux, typically "/".

    Returns:
        dict: The configuration for the clang toolchain.
    """

    return {
        "cpu": _NOT_USED,  # "k8",
        "compiler": _NOT_USED,  # "clang",
        "host_system_name": _NOT_USED,  # "x86_64",
        "target_system_name": _NOT_USED,  # "x86_64-pc-linux-gnu",
        "target_libc": "glibc_unknown",
        "abi_version": _NOT_USED,  # "clang",
        "abi_libc_version": _NOT_USED,  # "glibc_unknown",
        "cxx_builtin_include_directories": [
            paths.join(llvm_dir, "include/c++/v1"),
            paths.join(llvm_dir, "include/x86_64-pc-linux-gnu/c++/v1"),
            paths.join(llvm_dir, "lib/clang/{}/include".format(llvm_major_version)),
            paths.join(sysroot, "usr/include"),
        ],
        "tool_paths": {
            "ar": paths.join(llvm_dir, "bin/llvm-ar"),
            "cpp": paths.join(llvm_dir, "bin/clang-cpp"),
            "gcc": paths.join(llvm_dir, "bin/clang"),
            "ld": paths.join(llvm_dir, "bin/lld"),
            "llvm-cov": paths.join(llvm_dir, "bin/llvm-cov"),
            "nm": paths.join(llvm_dir, "bin/llvm-nm"),
            "objcopy": paths.join(llvm_dir, "bin/llvm-objcopy"),
            "objdump": paths.join(llvm_dir, "bin/objdump"),
            "strip": paths.join(llvm_dir, "bin/llvm-strip"),
        },
        "compile_flags": [
            "--target=x86_64-pc-linux-gnu",
            "-U_FORTIFY_SOURCE",
            "-fstack-protector",
            "-fno-omit-frame-pointer",
            "-fcolor-diagnostics",
            "-Wall",
            "-Wthread-safety",
            "-Wself-assign",
        ],
        "dbg_compile_flags": ["-g", "-fstandalone-debug"],
        "opt_compile_flags": [
            "-g0",
            "-O2",
            "-D_FORTIFY_SOURCE=1",
            "-DNDEBUG",
            "-ffunction-sections",
            "-fdata-sections",
        ],
        "cxx_flags": [
            "-std=c++20",  # Will be overriden by bazel command line arg `--cxxopt="-std=c++<standard>"`
            "-stdlib=libc++",
        ],
        "link_flags": [
            "--target=x86_64-pc-linux-gnu",
            "-lm",
            "-no-canonical-prefixes",
            "-fuse-ld=lld",
            "-Wl,--build-id=md5",
            "-Wl,--hash-style=gnu",
            "-Wl,-z,relro,-z,now",
            "-lc++",
            "-lc++abi",
            "-lunwind",
            "-rtlib=compiler-rt",
            "-lpthread",
            "-ldl",
        ],
        "archive_flags": [],
        "link_libs": [],
        "opt_link_flags": ["-Wl,--gc-sections"],
        "unfiltered_compile_flags": [
            "-no-canonical-prefixes",
            "-Wno-builtin-macro-redefined",
            "-D__DATE__=\"redacted\"",
            "-D__TIMESTAMP__=\"redacted\"",
            "-D__TIME__=\"redacted\"",
        ],
        "coverage_compile_flags": ["-fprofile-instr-generate", "-fcoverage-mapping"],
        "coverage_link_flags": ["-fprofile-instr-generate"],
        "supports_start_end_lib": True,
        "builtin_sysroot": sysroot,
    }

def MACRO_llvm_toolchain_config(name, llvm_dir, llvm_major_version, sysroot):
    """
    Macro: Instantiate a rule `cc_toolchain_config`.

    Args:
        name (str): The name (identifier) of the toolchain config.
        llvm_dir (str): The directory containing the LLVM/Clang installation.
        llvm_major_version (int): The major version of the LLVM/Clang installation.
        sysroot (dir): The sysroot to use for the C++ toolchain.
    """
    base_config = _create_llvm_toolchain_config(llvm_dir, llvm_major_version, sysroot)

    unix_cc_toolchain_config(
        name = name,
        cpu = base_config["cpu"],
        compiler = base_config["compiler"],
        toolchain_identifier = name,
        host_system_name = base_config["host_system_name"],
        target_system_name = base_config["target_system_name"],
        target_libc = base_config["target_libc"],
        abi_version = base_config["abi_version"],
        abi_libc_version = base_config["abi_libc_version"],
        cxx_builtin_include_directories = base_config["cxx_builtin_include_directories"],
        tool_paths = base_config["tool_paths"],
        compile_flags = base_config["compile_flags"],
        dbg_compile_flags = base_config["dbg_compile_flags"],
        opt_compile_flags = base_config["opt_compile_flags"],
        cxx_flags = base_config["cxx_flags"],
        link_flags = base_config["link_flags"],
        archive_flags = base_config["archive_flags"],
        link_libs = base_config["link_libs"],
        opt_link_flags = base_config["opt_link_flags"],
        unfiltered_compile_flags = base_config["unfiltered_compile_flags"],
        coverage_compile_flags = base_config["coverage_compile_flags"],
        coverage_link_flags = base_config["coverage_link_flags"],
        supports_start_end_lib = base_config["supports_start_end_lib"],
        builtin_sysroot = base_config["builtin_sysroot"],
    )
