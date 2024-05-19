# Bazel notes
This page summarizes knowledge of Bazel being used in this repo. Bazel terminology is highlighted with **bold** text.

## 1. [Built-in Types](https://bazel.build/rules/lib/builtins/)
The common built-in types are `ctx`, `actions`, `rule`, `Label`, `repository_rule`.
### [Label](https://bazel.build/rules/lib/builtins/Label)
A label is an identifier for a target. A typical label in its full canonical form looks like:
* double-`@` means **concanical repo name**.
    ```shell
    @@myrepo//my/app/main:app_binary
    ```

* single-`@` refers to a repo with the **apparent repo name**.
    ```shell
    @@myrepo//my/app/main:app_binary
    ```

* When a label refers to the same repository from which it is used, you can omit `@@myrepo`, which results only `//`.
    ```shell
    //my/app/main:app_binary
    ```

## 2. [Platforms and Toolchains Rules](https://bazel.build/reference/be/platforms-and-toolchains)
`constraint_setting`, `constraint_setting`, `platform`, `toolchain`, `toolchain_type`.

## 3. [General Rules](https://bazel.build/reference/be/general)
`file_group`, `alias`, `genrule` etc.

## 4. Functions
`package`, `package_group`, `exports_files`, `glob`, `select`, `subpackages`

### 5. Providers
`DefaultInfo`, `CcInfo`

## 6. Wait to be categorized
The source code of [`cc_library`](https://github.com/bazelbuild/bazel/blob/master/src/main/starlark/builtins_bzl/common/cc/cc_library.bzl). You can see the provider of `cc_library` is `DefaultInfo`, `CcInfo`, `OutputGroupInfo` and `InstrumentedFilesInfo`.

## 5. Bazel built-in and official Add-ons
The official add-ons are e.g.
* [bazel_skylib](https://github.com/bazelbuild/bazel-skylib)
* [bazel_tools](https://github.com/bazelbuild/bazel/tree/master/tools)