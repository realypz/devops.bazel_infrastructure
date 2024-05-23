# devops.bazel_infrastructure
This repo provides **centralized toolchain management** for my personal projects that uses Bazel build system.

What is provided:
* LLVM Bazel toolchain and the way to use them.
* Clang format
* Header guards auto generation

The subpurposes are:
* Document Bazel learning experience.
* Document the typical C++ toolchain setup.

## Preparation
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


## Example using command
**First thing first, switch directory to your own repo** that use this devops repo as dependency.

For this repo, this means `cd tests/` before run any commands below.

```shell
# Default build with the default toolchain determined by the Bazel-determined toolchain.
# NOTE: The default toolchain will be the system default C++ toolchain if no C++ toolchain is registered to your project.
#       Otherwise, the default toolchain will be the registered C++ toolchain that matches your platform.
bazelisk build //cpp/my_hello:hello

# Build with llvm toolchain (clang compiler, llvm-ar, llvm linker, etc.)
#   NOTE: --extra_toolchain will not exit with error if an unmatched (e.g. processor type, os type)toolchain is referred.
#         Instead, it will silently resolve to the default toolchain.
#   NOTE: `//toolchains:llvm_toolchain` is an alias to the external llvm toolchain.
bazelisk build --config=llvm_toolchain //...

# Clang format
#   NOTE: `//toolchains:clang_format_fix` is an alias to the external clang_format_fix target.
bazelisk run //toolchains:clang_format_fix

# Clang-tidy
#   NOTE: I haven't found away to alias an aspect rule.
bazelisk build --config=clang_tidy //cpp/my_hello:hello

# Header guards
bazelisk run //toolchains:header_guard -- --workspace-root=$(pwd)
```
**NOTE**: The `--config` works in the examples above because `.bazelrc` with alias has been added under `test/`. Please add such alias definition according to your needs.

You can also run the unshortened commands as below **without** `.bazelrc`.
```shell
# Build with llvm toolchain
bazelisk build --extra_toolchains=//toolchains:llvm_toolchain //...

# Clang-tidy
bazelisk build \
    --extra_toolchains=@devops.bazel_infrastructure//toolchains/cpp/build_tools:llvm_toolchain \
    --aspects @devops.bazel_infrastructure//toolchains/cpp/clang_tidy:clang_tidy.bzl%clang_tidy_aspect \
    --output_groups=report \
    //cpp/my_hello:hello
```

An example of `.bazelrc`:
```shell
build:cpp20 --cxxopt="-std=c++20"

build:llvm_toolchain --extra_toolchains=@devops.bazel_infrastructure//toolchains/cpp/build_tools:llvm_toolchain

build:verbose_all --cxxopt="--verbose" --sandbox_debug -s --verbose_failures
build:verbose_bazel --sandbox_debug -s
build:verbose_cpp --cxxopt="--verbose"

build:clang_tidy --config=llvm_toolchain --config=cpp20 \
    --aspects @devops.bazel_infrastructure//toolchains/cpp/clang_tidy:clang_tidy.bzl%clang_tidy_aspect \
    --output_groups=report
```
