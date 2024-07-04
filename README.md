# devops.bazel_infrastructure

This repo provides **centralized toolchain management** for my personal projects that uses Bazel build system.

What is provided:

* LLVM Bazel toolchain and the way to use them.
* Clang format
* Bazel buildifier formatting
* Header guards auto generation and complete
* Python formatting with Black

## Setup Before Using This ToolChain

The toolchain so far supports **macOS aarc64, Linux aarch64 and Linux x86_64**. Other platforms and CPUs are not supported.

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

* On Ubuntu, follow section **Automatic installation script** at https://apt.llvm.org/.

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

### 3. Use the Toolchain Repo in your Bazel projects

Add the code below to the `MODULE.bazel` file of your project.

```python
bazel_dep(name = "devops.bazel_infrastructure", version = "0.0.0")
git_override(
    module_name = "devops.bazel_infrastructure",
    commit = "Please refer to the latest commit hash in main",
    remote = "https://github.com/realypz/devops.bazel_infrastructure.git",
)
```

## Usage of The Toolchains

**First thing first, switch directory to your own repo** that use this devops repo as dependency. For this repo, this means `cd tests/` before run any commands below.

### 1. C++

```shell
# Build with llvm toolchain (clang compiler, llvm-ar, llvm linker, etc.)
#   NOTE: --extra_toolchain will not exit with error if an unmatched (e.g. processor type, os type)toolchain is referred.
#         Instead, it will silently resolve to the default toolchain.
bazelisk build --config=llvm_toolchain //...

# Clang-tidy
bazelisk build --config=clang_tidy //...

# Clang format
bazelisk run //external_toolchains:clang_format_fix

# Header guards
bazelisk run //external_toolchains:header_guard -- --workspace-root=$(pwd)
```

### 2. Python

```shell
# Formatting by Black
bazelisk run //external_toolchains:python_black
```

### 3. Bazel Files

```shell
# Bazel Buildifier
bazelisk run //external_toolchains:bazel_buildifier_fix
```

## Explanation of The Command Usage

### `--config=<>` option

The `--config` works in the examples above because `.bazelrc` under the workspace directory. An example is [tests/.bazelrc](tests/.bazelrc). Please add such alias definition according to your needs.

You can also run the unshortened commands as below without creating alias.

```shell
# Build with llvm toolchain
bazelisk build --extra_toolchains=//external_toolchains:llvm_toolchain //...

# Clang-tidy
bazelisk build \
    --extra_toolchains=@devops.bazel_infrastructure//toolchains/cpp/build_tools:llvm_toolchain \
    --aspects @devops.bazel_infrastructure//toolchains/cpp/clang_tidy:clang_tidy.bzl%clang_tidy_aspect \
    --output_groups=report \
    //cpp/my_hello:hello
```

### `//external_toolchain:<>`

The external toolchain Bazel package (i.e. `tests/external_toolchains/BUILD.bazel`) creates alias Bazel targets to the external toolchain targets. You can use similar technique to referring any external targets.
