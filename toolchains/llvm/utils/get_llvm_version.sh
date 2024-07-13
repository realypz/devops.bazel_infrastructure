# usr/bin/env bash
## Usage:
## llvm_version.sh <clang_path>
  
get_llvm_version() {
    local llvm_version_info=$($1 --version)
    local version_number=$(echo "$llvm_version_info" | grep -oE 'clang version [0-9]+\.[0-9]+\.[0-9]+' | grep -oE '[0-9]+\.[0-9]+\.[0-9]'  | head -n 1)
    echo "$version_number"
}

get_llvm_version $1
