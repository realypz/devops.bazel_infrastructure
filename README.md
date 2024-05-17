# devops.bazel_infrastructure
This repo provides **centralized toolchain management** for my personal projects that uses Bazel build system.

What is provided:
* LLVM Bazel toolchain and the way to use them.
* Clang format
* Python tools

The subpurposes are:
* Document Bazel learning experience.
* Document the typical C++ toolchain setup.

## How to use
### 1. [Install Bazelisk](https://github.com/bazelbuild/bazelisk?tab=readme-ov-file#installation)<br>
Bazelisk is a bazel package manager. It works as symlink to a specified version of bazel executable.
* On macOS: `brew install bazelisk`
* On Linux: Download Bazelisk binary on our [Releases](https://github.com/bazelbuild/bazelisk/releases) page.
    ```shell
    # At some directory
    wget https://github.com/bazelbuild/bazelisk/releases/download/<version>/<exec_name>

    # Move to /usr/bin/
    sudo mv <exec_name> /usr/bin/

    # Add executable permission
    sudo chmod +x /usr/bin/<exec_name>
    ```
After these steps, you should be able to use `bazelisk` directly in terminal.

### 2. Install the complete llvm toolchain
* On macOS
    * Install homebrew, and make sure `brew` can be invoked in terminal.
    * Install llvm tools of a specific verison, e.g. `18`
        ```shell
        brew install llvm@18
        ```
* On Ubuntu, follow section **Automatic installation script** at https://apt.llvm.org/.<br>
    Strongly **recommend** install **all llvm packages** at once to use llvm provided runtime libraries with clang.
    ```shell
    wget https://apt.llvm.org/llvm.sh
    chmod +x llvm.sh
    sudo ./llvm.sh <version number> all
    ```

  If you don't install all llvm packges at once, you might need to install some libraries separately as below (not recommended).
    ```shell
    sudo ./llvm.sh 18
    sudo apt-get install libc++-18-dev libc++abi-18-dev
    ```


## Bazel command
```shell
# Default run, which will invoke the Bazel-determined toolchain.
# NOTE: Bazel-determined toolchain is not the same as system default compiler and linker.
bazelisk run //tests/cpp/my_hello:hello 

# To use llvm toolchain (work for both macOS and Linux, because an alias target is used)
#   NOTE: --extra_toolchain will not exit with error if an unmatched (e.g. processor type, os type)toolchain is referred.
#         Instead, it will silently resolve to the default toolchain.
bazelisk run --extra_toolchains=//toolchains/cpp/build_tools:llvm_toolchain \
  --cxxopt="--verbose" //tests/cpp/my_hello:hello

# Run bazel buildifier
# Requires install the buildifier manually.
buildifier -r .

# Clang format
bazelisk run //toolchains/cpp/format:clang_format_fix
#   You can also specify the config settings in command, e.g.
#       bazelisk run //toolchains/cpp/format:clang_format_fix --//toolchains/Bazel/common/platform:os=macosx
#       bazelisk run //toolchains/cpp/format:clang_format_fix --//toolchains/Bazel/common/platform:os=linux
#   But not necessary.
```

## Knowledge
### Github repos
* [Toolchain field check](https://github.com/bazelbuild/bazel/blob/master/src/main/starlark/builtins_bzl/common/cc/cc_toolchain_provider_helper.bzl#L33)
* [Toolchain config](https://cs.opensource.google/bazel/bazel/+/master:tools/cpp/unix_cc_toolchain_config.bzl;l=1509)
* [LLVM release](https://github.com/llvm/llvm-project/releases)
* [Assembly a Complete Clang toolchain](https://clang.llvm.org/docs/Toolchain.html#language-frontends-for-other-languages)

## Bazel verbose flags
```shell
# For C++
--cxxopt="--verbose"

# For Bazel
--sandbox_debug -s
```

## Helper commands
```shell
clang -print-targets

clang -print-supported-cpus

# In macOS, display the sysroot dir
xcrun --show-sdk-path
```

## Homebrew commands
```shell
brew list --versions
```
