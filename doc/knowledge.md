# Knowledge
This page is more for personal use.

## Bazel repos

* [C/C++ related rules, e.g. `cc_library`, `cc_test`](https://github.com/bazelbuild/bazel/blob/master/src/main/starlark/builtins_bzl/common/cc/)
* [`cc_toolchain_config`](https://github.com/bazelbuild/bazel/blob/master/tools/cpp/unix_cc_toolchain_config.bzl)
* [Toolchain field check](https://github.com/bazelbuild/bazel/blob/master/src/main/starlark/builtins_bzl/common/cc/cc_toolchain_provider_helper.bzl#L33)

## Other repos, or references being used in this project

* [LLVM release](https://github.com/llvm/llvm-project/releases)
* [Assembly a Complete Clang toolchain](https://clang.llvm.org/docs/Toolchain.html#language-frontends-for-other-languages)
* [erenon/bazel_clang_tidy](https://github.com/erenon/bazel_clang_tidy)
* [bazel-contrib/toolchains_llvm](https://github.com/bazel-contrib/toolchains_llvm): The cc_toolchain_config comes from here.

## Bazel commands or flags

### Flags

```shell
# For C++ rule level
--cxxopt="--verbose"

# For Bazel building level
--sandbox_debug -s
```

### Helper commands

```shell
# Display the bazel build cache folder for the current workspace
bazelisk info output_base

# Clean the bazel build cache
bazelisk clean
```

## Other commands

```shell
clang -print-targets

clang -print-supported-cpus

# In macOS, display the sysroot dir
xcrun --show-sdk-path

# List the installed packages in homebrew
brew list --versions

# Update homebrew
brew update

# Update the packages installed by homebrew
brew upgrade
```
