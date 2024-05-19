# Description: This script is used to run the smoke test suite.

# Run this script under `tests` directory.

set -e
bazelisk build --config=llvm_toolchain //...
bazelisk test --config=llvm_toolchain //...
