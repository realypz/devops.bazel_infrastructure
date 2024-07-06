```python
:316:10: name:  local-aarch64-linux
:317:10: cpu:  aarch64
:318:10: compiler:  clang
:319:10: toolchain_identifier:  clang-aarch64-linux
:320:10: host_system_name:  aarch64
:321:10: target_system_name:  aarch64-unknown-linux-gnu
:322:10: target_libc:  glibc_unknown
:323:10: abi_version:  clang
:324:10: abi_libc_version:  glibc_unknown
:325:10: cxx_builtin_include_directories:  ["external/toolchains_llvm~~llvm~llvm_toolchain_llvm/include/c++/v1", "external/toolchains_llvm~~llvm~llvm_toolchain_llvm/include/aarch64-unknown-linux-gnu/c++/v1", "external/toolchains_llvm~~llvm~llvm_toolchain_llvm/lib/clang/17.0.6/include", "external/toolchains_llvm~~llvm~llvm_toolchain_llvm/lib/clang/17.0.6/share", "external/toolchains_llvm~~llvm~llvm_toolchain_llvm/lib64/clang/17.0.6/include", "external/toolchains_llvm~~llvm~llvm_toolchain_llvm/lib/clang/17/include", "external/toolchains_llvm~~llvm~llvm_toolchain_llvm/lib/clang/17/share", "external/toolchains_llvm~~llvm~llvm_toolchain_llvm/lib64/clang/17/include", "/usr/include", "/usr/local/include"]
:326:10: tool_paths:  {"ar": "bin/llvm-ar", "cpp": "bin/clang-cpp", "dwp": "bin/llvm-dwp", "gcc": "bin/cc_wrapper.sh", "gcov": "bin/llvm-profdata", "ld": "bin/ld.lld", "llvm-cov": "bin/llvm-cov", "llvm-profdata": "bin/llvm-profdata", "nm": "bin/llvm-nm", "objcopy": "bin/llvm-objcopy", "objdump": "bin/llvm-objdump", "strip": "bin/llvm-strip"}
:327:10: compile_flags:  ["--target=aarch64-unknown-linux-gnu", "-U_FORTIFY_SOURCE", "-fstack-protector", "-fno-omit-frame-pointer", "-fcolor-diagnostics", "-Wall", "-Wthread-safety", "-Wself-assign"]
:328:10: dbg_compile_flags:  ["-g", "-fstandalone-debug"]
:329:10: opt_compile_flags:  ["-g0", "-O2", "-D_FORTIFY_SOURCE=1", "-DNDEBUG", "-ffunction-sections", "-fdata-sections"]
:330:10: cxx_flags:  ["-std=c++17", "-stdlib=libc++"]
:331:10: link_flags:  ["--target=aarch64-unknown-linux-gnu", "-lm", "-no-canonical-prefixes", "-fuse-ld=lld", "-Wl,--build-id=md5", "-Wl,--hash-style=gnu", "-Wl,-z,relro,-z,now", "-l:libc++.a", "-l:libc++abi.a", "-l:libunwind.a", "-rtlib=compiler-rt", "-lpthread", "-ldl"]
:332:10: archive_flags:  []
:333:10: link_libs:  []
:334:10: opt_link_flags:  ["-Wl,--gc-sections"]
:335:10: unfiltered_compile_flags:  ["-no-canonical-prefixes", "-Wno-builtin-macro-redefined", "-D__DATE__=\"redacted\"", "-D__TIMESTAMP__=\"redacted\"", "-D__TIME__=\"redacted\"", "-fdebug-prefix-map=external/toolchains_llvm~~llvm~llvm_toolchain_llvm/=__bazel_toolchain_llvm_repo__/"]
:336:10: coverage_compile_flags:  ["-fprofile-instr-generate", "-fcoverage-mapping"]
:337:10: coverage_link_flags:  ["-fprofile-instr-generate"]
:338:10: supports_start_end_lib:  True
:339:10: builtin_sysroot:  
```