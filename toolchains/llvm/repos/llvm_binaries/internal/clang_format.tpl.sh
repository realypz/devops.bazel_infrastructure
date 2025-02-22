#!/usr/bin/env bash

set -eu

if [[ $# != 1 ]]; then
    echo "Usage: $0 <workspace>"
    exit 1
fi

workspace=$(realpath $1)

find ${workspace} \( -name "*.cpp" -o -name "*.c" -o -name "*.cc" -o -name "*.cxx" -o -name "*.hpp" -o -name "*.h" -o -name "*.hxx" \) | \
xargs @@LLVM_DIR@@/bin/clang-format -i
