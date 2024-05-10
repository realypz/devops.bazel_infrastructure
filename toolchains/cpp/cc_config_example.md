## An example of The toolchain config

```python
DEBUG: /private/var/tmp/_bazel_ypz/cea4ec323ef2588ec86f57d74bb4e67a/external/toolchains_llvm~/toolchain/cc_toolchain_config.bzl:318:10

cc_toolchain_config.bzl:318:10: name:  local-aarch64-darwin
cc_toolchain_config.bzl:319:10: cpu:  darwin
cc_toolchain_config.bzl:320:10: compiler:  clang
cc_toolchain_config.bzl:321:10: toolchain_identifier:  clang-aarch64-darwin
cc_toolchain_config.bzl:322:10: host_system_name:  aarch64
cc_toolchain_config.bzl:323:10: target_system_name:  aarch64-apple-macosx
cc_toolchain_config.bzl:324:10: target_libc:  macosx
cc_toolchain_config.bzl:325:10: abi_version:  darwin_aarch64
cc_toolchain_config.bzl:326:10: abi_libc_version:  darwin_aarch64
cc_toolchain_config.bzl:327:10: cxx_builtin_include_directories:  ["external/toolchains_llvm~~llvm~llvm_toolchain_llvm/include/c++/v1", "external/toolchains_llvm~~llvm~llvm_toolchain_llvm/include/aarch64-apple-macosx/c++/v1", "external/toolchains_llvm~~llvm~llvm_toolchain_llvm/lib/clang/16.0.5/include", "external/toolchains_llvm~~llvm~llvm_toolchain_llvm/lib/clang/16.0.5/share", "external/toolchains_llvm~~llvm~llvm_toolchain_llvm/lib64/clang/16.0.5/include", "external/toolchains_llvm~~llvm~llvm_toolchain_llvm/lib/clang/16/include", "external/toolchains_llvm~~llvm~llvm_toolchain_llvm/lib/clang/16/share", "external/toolchains_llvm~~llvm~llvm_toolchain_llvm/lib64/clang/16/include", "%sysroot%/usr/include", "%sysroot%/System/Library/Frameworks"]
cc_toolchain_config.bzl:328:10: tool_paths:  {"ar": "bin/libtool", # Key must be "ar".
											  "cpp": "bin/clang-cpp",
                                              "dwp": "bin/llvm-dwp",
											  "gcc": "bin/cc_wrapper.sh", # Note this is a wrapper, not a real binary.
                                                            # The key name must be "gcc", regardless you are using clang or gcc.
                                              "gcov": "bin/llvm-profdata",
                                              "ld": "/usr/bin/ld",
                                              "llvm-cov": "bin/llvm-cov",
                                              "llvm-profdata": "bin/llvm-profdata",
                                              "nm": "bin/llvm-nm",
                                              "objcopy": "bin/llvm-objcopy",
                                              "objdump": "bin/llvm-objdump",
                                              "strip": "bin/llvm-strip"}
                                              # The required toolpath are defined in
                                              # https://github.com/bazelbuild/bazel/blob/master/src/main/starlark/builtins_bzl/common/cc/cc_toolchain_provider_helper.bzl#L33
																							
cc_toolchain_config.bzl:329:10: compile_flags:  ["--target=aarch64-apple-macosx",	"-U_FORTIFY_SOURCE", "-fstack-protector",
												 "-fno-omit-frame-pointer", "-fcolor-diagnostics",
												 "-Wall", "-Wthread-safety", "-Wself-assign"]
cc_toolchain_config.bzl:330:10: dbg_compile_flags:  ["-g", "-fstandalone-debug"]
cc_toolchain_config.bzl:331:10: opt_compile_flags:  ["-g0", "-O2", "-D_FORTIFY_SOURCE=1", "-DNDEBUG", "-ffunction-sections", "-fdata-sections"]
cc_toolchain_config.bzl:332:10: cxx_flags:  ["-std=c++17", "-stdlib=libc++"]
cc_toolchain_config.bzl:333:10: link_flags:  ["--target=aarch64-apple-macosx", "-lm", "-no-canonical-prefixes", "-headerpad_max_install_names", "-fobjc-link-runtime", "-L/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib", "-lc++", "-lc++abi", "-Bstatic", "-lunwind", "-Bdynamic", "-Lexternal/toolchains_llvm~~llvm~llvm_toolchain_llvm/lib"]
cc_toolchain_config.bzl:334:10: archive_flags:  ["-static"]
cc_toolchain_config.bzl:335:10: link_libs:  []
cc_toolchain_config.bzl:336:10: opt_link_flags:  []
cc_toolchain_config.bzl:337:10: unfiltered_compile_flags:  ["-no-canonical-prefixes", "-Wno-builtin-macro-redefined", "-D__DATE__=\"redacted\"", "-D__TIMESTAMP__=\"redacted\"", "-D__TIME__=\"redacted\"", "-fdebug-prefix-map=external/toolchains_llvm~~llvm~llvm_toolchain_llvm/=__bazel_toolchain_llvm_repo__/"]
cc_toolchain_config.bzl:338:10: coverage_compile_flags:  ["-fprofile-instr-generate", "-fcoverage-mapping"]
cc_toolchain_config.bzl:339:10: coverage_link_flags:  ["-fprofile-instr-generate"]
cc_toolchain_config.bzl:340:10: supports_start_end_lib:  False
cc_toolchain_config.bzl:341:10: builtin_sysroot:  /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk

```

## How are the fields specified?
```json
{
    "name": "The correctness are not checked.",
    "cpu": "The correctness are not checked.",
    "compiler": "The correctness are not checked.",
    "toolchain_identifier": "The correctness are not checked.",
    "host_system_name": "The correctness are not checked.",
    "target_system_name": "TBD",
    "target_libc": "must be one of [\"macosx\", ]",
    "abi_version": "The correctness are not checked.",
    "abi_libc_version": "The correctness are not checked.",
    "tool_paths": {
		    
    },
    "cxx_flags": "The value is passed, but does not take any effect. The real effect is controlled by bazelisk build --cxxopt='-std=c++'",
    
}
```