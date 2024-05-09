load(
    "@bazel_tools//tools/cpp:unix_cc_toolchain_config.bzl",
    unix_cc_toolchain_config = "cc_toolchain_config",
)

def llvm_linux_toolchain_config(name, llvm_dir):
   # /usr/lib/llvm-18/
    LLVM_DIR = llvm_dir

    unix_cc_toolchain_config(
        name = name,
        cpu = "not_checked",
        compiler = "not_checked",
        toolchain_identifier = name,
        host_system_name = "not_checked",
        target_system_name = "not_checked",
        target_libc = "not_checked",
        abi_version = "not_checked",
        abi_libc_version = "not_checked",
        cxx_builtin_include_directories = [
            LLVM_DIR + "include/c++/v1",
            LLVM_DIR + "lib/clang/18/include",  # /opt/homebrew/Cellar/llvm/18.1.5/lib/clang/18/include
            "/usr/include",
        ],
        tool_paths = {
            "ar": LLVM_DIR + "bin/llvm-ar",
            "cpp": LLVM_DIR + "bin/clang-cpp",
            "gcc": LLVM_DIR + "bin/clang",
            "ld": LLVM_DIR + "bin/lld",
            "llvm-cov": LLVM_DIR + "bin/llvm-cov",
            "nm": LLVM_DIR + "bin/llvm-nm",
            "objcopy": LLVM_DIR + "bin/llvm-objcopy",
            "objdump": LLVM_DIR + "bin/objdump",
            "strip": LLVM_DIR + "bin/llvm-strip",
        },
        compile_flags = [
            # "--target=" + target_system_name,
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
        dbg_compile_flags = ["-g", "-fstandalone-debug"],
        opt_compile_flags = [
            "-g0",
            "-O2",
            "-D_FORTIFY_SOURCE=1",
            "-DNDEBUG",
            "-ffunction-sections",
            "-fdata-sections",
        ],
        cxx_flags = [
                "-std=c++20", # Will be overriden by bazel command line arg `--cxxopt="-std=c++<standard>"`
                "-stdlib=libc++", 
            ],
        link_flags = [
            # "--target=linux", # NOTE: Disabled now. It seems you can pass any arbitrary string.
            "-no-canonical-prefixes",
            "-headerpad_max_install_names",
            "-fobjc-link-runtime",
            # -l<library> for linking
            "-lc++", 
            "-lc++abi",
            "-lunwind",
            # "-lm", # TODO: link math library.Disable for now, not necessary at the moment.
            "-L{}lib".format(LLVM_DIR), # Or equivalent as `--library-directory=<lib>`
            # "-L/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib", # NOTE: Disabled for now, not necessary at the moment.
            # "-Bstatic", # NOTE: Disabled for now, don't know how this flag affects the linking.
            # "-Bdynamic_t", # NOTE: Disabled for now, don't know how this flag affects the linking.
            ],
        archive_flags = [],
        link_libs = [],
        opt_link_flags = [],
        unfiltered_compile_flags = [],
        coverage_compile_flags = ["-fprofile-instr-generate", "-fcoverage-mapping"],
        coverage_link_flags = ["-fprofile-instr-generate"],
        supports_start_end_lib = True,
        builtin_sysroot = "/",
        # Run `xcrun --show-sdk-path` to get the path to the SDK.
    )
