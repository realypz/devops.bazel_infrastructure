# Toolchain
## Example command
```shell
# Default run, which will invoke the system default compiler.
bazelisk run //tests/C++:hello 

# Use the defined toolchain.
# NOTE: --extra_toolchain will not exit with error if an unmatched (e.g. processor type, os type)toolchain is referred.
# Instead, it will resolve to the default toolchain.
bazelisk run  --extra_toolchains=//toolchains/C++:macosx_homebrew_llvm_toolchain //tests/C++:hello

# In Ubuntu, need to install libc++ manually
sudo ./llvm.sh 18
sudo apt-get install libc++-18-dev libc++abi-18-dev

bazelisk run  --extra_toolchains=//toolchains/C++:linux_llvm_toolchain --cxxopt="--verbose" //tests/C++:hello 

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
