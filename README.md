# devops.bazel_infrastructure
This repo provides **centralized toolchain management** for my personal projects that uses Bazel build system.

What is provided:
* LLVM Bazel toolchain and the way to use them.
* Clang format

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
```shell
# Default run, which will invoke the Bazel-determined toolchain.
# NOTE: Bazel-determined toolchain is not the same as system default compiler and linker.
bazelisk build //tests/cpp/my_hello:hello

# Build with llvm toolchain (clang compiler, llvm-ar, llvm linker, etc.)
#   NOTE: --extra_toolchain will not exit with error if an unmatched (e.g. processor type, os type)toolchain is referred.
#         Instead, it will silently resolve to the default toolchain.
bazelisk run --config=llvm_toolchain //tests/cpp/my_hello:hello

# Run bazel buildifier
# Requires install the buildifier manually.
buildifier -r .

# Clang format
bazelisk run //toolchains/cpp/format:clang_format_fix

# Clang-tidy
bazelisk build --config=clang_tidy //tests/cpp/my_hello:hello
```


