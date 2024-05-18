load("@bazel_skylib//lib:paths.bzl", "paths")
load(
    "@bazel_tools//tools/cpp:unix_cc_toolchain_config.bzl",
    unix_cc_toolchain_config = "cc_toolchain_config",
)

_NOT_USED = "NOT_USED"

def _create_clang_config_macos(llvm_dir, llvm_major_version, sysroot):
    """ Function: Returns a dictionary with the data for unix_cc_toolchain_config. Works for macOS.

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
        "cpu": _NOT_USED,  # "darwin",
        "compiler": _NOT_USED,  # "clang",
        "host_system_name": _NOT_USED,  # "aarch64",
        "target_system_name": _NOT_USED,  # "NONE",
        "target_libc": "macosx",
        "abi_version": _NOT_USED,  # "darwin_aarch64",
        "abi_libc_version": _NOT_USED,  # "darwin_aarch64",
        "cxx_builtin_include_directories": [
            paths.join(llvm_dir, "include/c++/v1"),
            paths.join(llvm_dir, "lib/clang/{}/include".format(llvm_major_version)),
            paths.join(sysroot, "usr/include"),
        ],
        "tool_paths": {
            "ar": paths.join(llvm_dir, "bin/llvm-libtool-darwin"),
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
            # Security
            "-U_FORTIFY_SOURCE",  # https://github.com/google/sanitizers/issues/247
            "-fstack-protector",
            "-fno-omit-frame-pointer",
            # Diagnostics
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
            # "--target=aarch64-apple-macosx", # NOTE: Disabled now. It seems you can pass any arbitrary string.
            "-no-canonical-prefixes",
            "-headerpad_max_install_names",
            "-fobjc-link-runtime",
            # -l<library> for linking
            "-lc++",
            "-lc++abi",
            "-lunwind",
            # "-lm", # TODO: link math library.Disable for now, not necessary at the moment.
            "-L{}lib".format(llvm_dir),  # Or equivalent as `--library-directory=<lib>`
            # "-Bstatic",  # NOTE: Disabled for now, don't know how this flag affects the linking.
            # "-Bdynamic_t",  # NOTE: Disabled for now, don't know how this flag affects the linking.
        ],
        "archive_flags": ["-static"],
        "link_libs": [],
        "opt_link_flags": [],
        "unfiltered_compile_flags": [
            "-no-canonical-prefixes",
            "-Wno-builtin-macro-redefined",
            "-D__DATE__=\"redacted\"",
            "-D__TIMESTAMP__=\"redacted\"",
            "-D__TIME__=\"redacted\"",
        ],
        "coverage_compile_flags": ["-fprofile-instr-generate", "-fcoverage-mapping"],
        "coverage_link_flags": ["-fprofile-instr-generate"],
        "supports_start_end_lib": False,
        "builtin_sysroot": sysroot,
    }

def _create_clang_config_linux(llvm_dir, llvm_major_version, sysroot):
    """ Function: Returns a dictionary with the data for unix_cc_toolchain_config. Works for Linux.

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
        "cpu": _NOT_USED,  # "darwin",
        "compiler": _NOT_USED,  # "clang",
        "host_system_name": _NOT_USED,  # "aarch64",
        "target_system_name": _NOT_USED,  # "aarch64",
        "target_libc": "glibc_unknown",
        "abi_version": _NOT_USED,  # "clang",
        "abi_libc_version": _NOT_USED,  # "glibc_unknown",
        "cxx_builtin_include_directories": [
            paths.join(llvm_dir, "include/c++/v1"),
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
            "--target=aarch64-unknown-linux-gnu",
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
            "--target=aarch64-unknown-linux-gnu",
            "-lm",
            "-no-canonical-prefixes",
            "-fuse-ld=lld",
            "-Wl,--build-id=md5",
            "-Wl,--hash-style=gnu",
            "-Wl,-z,relro,-z,now",
            "-l:libc++.a",
            "-l:libc++abi.a",
            "-l:libunwind.a",
            "-rtlib=compiler-rt",
            "-lpthread",
            "-ldl",
        ],
        "archive_flags": [""],
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
        "supports_start_end_lib": False,
        "builtin_sysroot": sysroot,
    }

def MACRO_llvm_toolchain_config(name, target_os, llvm_dir, llvm_major_version, sysroot):
    """
    Macro: Instantiate a rule `cc_toolchain_config`.

    Args:
        target_os (str): The target OS for the toolchain config. One of ["macosx", "linux]
        name (str): The name (identifier) of the toolchain config.
        llvm_dir (str): The directory containing the LLVM/Clang installation.
        llvm_major_version (int): The major version of the LLVM/Clang installation.
        sysroot (dir): The sysroot to use for the C++ toolchain.
    """
    if (target_os == "macosx"):
        base_config = _create_clang_config_macos(llvm_dir, llvm_major_version, sysroot)
    elif (target_os == "linux"):
        base_config = _create_clang_config_linux(llvm_dir, llvm_major_version, sysroot)
    else:
        fail("Unsupported target_os: {}".format(target_os))

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
