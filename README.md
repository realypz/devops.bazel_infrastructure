# Toolchain
## Example command
```shell
# Default run, which will invoke the system default compiler.
bazelisk run //tests/C++:hello 

# Use the defined toolchain.
bazelisk run  --extra_toolchains=//toolchains/C++:macosx_homebrew_llvm_toolchain //tests/C++:hello 

# Verbose the compiler print out.
bazelisk run  --cxxopt="--verbose" --extra_toolchains=//toolchains/C++:macosx_homebrew_llvm_toolchain //tests/C++:hello 
```

## Knowledge
### Github repos
* [Toolchain field check](https://github.com/bazelbuild/bazel/blob/master/src/main/starlark/builtins_bzl/common/cc/cc_toolchain_provider_helper.bzl#L33)
* [Toolchain config](https://cs.opensource.google/bazel/bazel/+/master:tools/cpp/unix_cc_toolchain_config.bzl;l=1509)
* [LLVM release](https://github.com/llvm/llvm-project/releases)

## Helper commands
```shell
clang -print-targets

clang -print-supported-cpus

# In macOS, display the sysroot dir
xcrun --show-sdk-path
```
