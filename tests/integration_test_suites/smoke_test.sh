# Description: This script is used to run the smoke test suite.

# Run this script under `tests` directory.

set -e

# Build check
bazelisk build --config=llvm_toolchain -c opt //...
bazelisk test --config=llvm_toolchain //...
bazelisk build --config=clang_tidy //cpp/my_hello:hello

# Format check
bazelisk run //external_toolchains:bazel_buildifier_fix
bazelisk run //external_toolchains:clang_format_fix
bazelisk run //external_toolchains:header_guard -- --workspace-root=$(pwd)
bazelisk run //external_toolchains:python_black
