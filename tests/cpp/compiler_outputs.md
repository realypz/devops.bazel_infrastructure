# Compiler outputs

## The command that works fine
```shell
# To use the default macOS clang.
# NOTE: without explicit `-lc++`, linker got error, due to hello.cpp include <iostream>
clang tests/C++/hello.cpp --verbose -lc++ -std=c++20 -o tests/C++/hello

# (The one below which has a different order also work, but the same order does not work for gcc on linux)
# clang --verbose -lc++ -std=c++20 -o tests/C++/hello tests/C++/hello.cpp

# To use gcc in Ubuntu
gcc tests/C++/hello.cpp -std=c++20 --verbose -lstdc++ -o tests/C++/hello

# To use clang via brew
/opt/homebrew/Cellar/llvm/18.1.5/bin/clang --verbose -lc++ -std=c++20 -o tests/cpp/hello tests/cpp/hello.cpp

# Use clang homebrew via Bazel Toolchain (not yet working)
bazelisk run --cxxopt="--verbose" --cxxopt="-resource-dir=/opt/homebrew/Cellar/llvm" //tests/C++:hello

# To use clang in Ubuntu. NOTE: -lc++ does not work, have to use -lstdc++
/usr/lib/llvm-18/bin/clang --verbose -lstdc++ -std=c++20 -o tests/cpp/hello tests/cpp/hello.cpp
```

## The command not work
```shell
# I don't know why. It seems the compiler is not going to be
gcc --verbose -lstdc++  -o tests/C++/hello tests/C++/hello.cpp

/opt/homebrew/bin/gcc-13 tests/C++/hello.cpp --verbose -lstdc++ --sysroot=/opt/homebrew -o tests/C++/hello

# NOTE: gcc on mac seems lack some header files, it is so painful pass the correct paths to the compiler.
/opt/homebrew/bin/gcc-13 tests/C++/hello.cpp --verbose -lstdc++ --sysroot=/opt/homebrew \
    -isystem /opt/homebrew/Cellar/gcc/13.2.0/include/c++/13/tr1/ \
    -isystem /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include \
    -o tests/C++/hello 
```


## Test raw building
### Homebrew clang
```shell
~/peizhengs_git/workspace/devops.bazel_infrastructure on  DEV-5/c++_toolchain_skeleton! ⌚ 9:49:21
$ clang tests/C++/hello.cpp --verbose -lc++ -std=c++20 -o tests/C++/hello
Apple clang version 15.0.0 (clang-1500.3.9.4)
Target: arm64-apple-darwin23.4.0
Thread model: posix
InstalledDir: /Library/Developer/CommandLineTools/usr/bin
 "/Library/Developer/CommandLineTools/usr/bin/clang" -cc1 -triple arm64-apple-macosx14.0.0 -Wundef-prefix=TARGET_OS_ -Wdeprecated-objc-isa-usage -Werror=deprecated-objc-isa-usage -Werror=implicit-function-declaration -emit-obj -mrelax-all --mrelax-relocations -disable-free -clear-ast-before-backend -disable-llvm-verifier -discard-value-names -main-file-name hello.cpp -mrelocation-model pic -pic-level 2 -mframe-pointer=non-leaf -fno-strict-return -ffp-contract=on -fno-rounding-math -funwind-tables=1 -fobjc-msgsend-selector-stubs -target-sdk-version=14.4 -fvisibility-inlines-hidden-static-local-var -target-cpu apple-m1 -target-feature +v8.5a -target-feature +crc -target-feature +lse -target-feature +rdm -target-feature +crypto -target-feature +dotprod -target-feature +fp-armv8 -target-feature +neon -target-feature +fp16fml -target-feature +ras -target-feature +rcpc -target-feature +zcm -target-feature +zcz -target-feature +fullfp16 -target-feature +sm4 -target-feature +sha3 -target-feature +sha2 -target-feature +aes -target-abi darwinpcs -debugger-tuning=lldb -target-linker-version 1053.12 -v -fcoverage-compilation-dir=/Users/ypz/peizhengs_git/workspace/devops.bazel_infrastructure -resource-dir /Library/Developer/CommandLineTools/usr/lib/clang/15.0.0 -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -I/usr/local/include -internal-isystem /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/c++/v1 -internal-isystem /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/local/include -internal-isystem /Library/Developer/CommandLineTools/usr/lib/clang/15.0.0/include -internal-externc-isystem /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include -internal-externc-isystem /Library/Developer/CommandLineTools/usr/include -Wno-reorder-init-list -Wno-implicit-int-float-conversion -Wno-c99-designator -Wno-final-dtor-non-final-class -Wno-extra-semi-stmt -Wno-misleading-indentation -Wno-quoted-include-in-framework-header -Wno-implicit-fallthrough -Wno-enum-enum-conversion -Wno-enum-float-conversion -Wno-elaborated-enum-base -Wno-reserved-identifier -Wno-gnu-folding-constant -std=c++20 -fdeprecated-macro -fdebug-compilation-dir=/Users/ypz/peizhengs_git/workspace/devops.bazel_infrastructure -ferror-limit 19 -stack-protector 1 -fstack-check -mdarwin-stkchk-strong-link -fblocks -fencode-extended-block-signature -fregister-global-dtors-with-atexit -fgnuc-version=4.2.1 -fno-cxx-modules -fno-implicit-modules -fcxx-exceptions -fexceptions -fmax-type-align=16 -fcommon -fcolor-diagnostics -clang-vendor-feature=+disableNonDependentMemberExprInCurrentInstantiation -fno-odr-hash-protocols -clang-vendor-feature=+enableAggressiveVLAFolding -clang-vendor-feature=+revert09abecef7bbf -clang-vendor-feature=+thisNoAlignAttr -clang-vendor-feature=+thisNoNullAttr -mllvm -disable-aligned-alloc-awareness=1 -D__GCC_HAVE_DWARF2_CFI_ASM=1 -o /var/folders/x8/7g2htwjd1ss6rqvvx7t95x0m0000gn/T/hello-a14a5e.o -x c++ tests/C++/hello.cpp
clang -cc1 version 15.0.0 (clang-1500.3.9.4) default target arm64-apple-darwin23.4.0
ignoring nonexistent directory "/usr/local/include"
ignoring nonexistent directory "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/local/include"
ignoring nonexistent directory "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/Library/Frameworks"
#include "..." search starts here:
#include <...> search starts here:
 /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/c++/v1
 /Library/Developer/CommandLineTools/usr/lib/clang/15.0.0/include
 /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include
 /Library/Developer/CommandLineTools/usr/include
 /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks (framework directory)
End of search list.
 "/Library/Developer/CommandLineTools/usr/bin/ld" -demangle -lto_library /Library/Developer/CommandLineTools/usr/lib/libLTO.dylib -no_deduplicate -dynamic -arch arm64 -platform_version macos 14.0.0 14.4 -syslibroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -o tests/C++/hello -L/usr/local/lib /var/folders/x8/7g2htwjd1ss6rqvvx7t95x0m0000gn/T/hello-a14a5e.o -lc++ -lSystem /Library/Developer/CommandLineTools/usr/lib/clang/15.0.0/lib/darwin/libclang_rt.osx.a
```


## Apple clang
```shell
pointer=non-leaf -fno-strict-return -ffp-contract=on -fno-rounding-math -funwind-tables=1 -fobjc-msgsend-selector-stubs -target-sdk-version=14.4 -fvisibility-inlines-hidden-static-local-var -target-cpu apple-m1 -target-feature +v8.5a -target-feature +crc -target-feature +lse -target-feature +rdm -target-feature +crypto -target-feature +dotprod -target-feature +fp-armv8 -target-feature +neon -target-feature +fp16fml -target-feature +ras -target-feature +rcpc -target-feature +zcm -target-feature +zcz -target-feature +fullfp16 -target-feature +sm4 -target-feature +sha3 -target-feature +sha2 -target-feature +aes -target-abi darwinpcs -debugger-tuning=lldb -target-linker-version 1053.12 -v -fcoverage-compilation-dir=/Users/ypz/peizhengs_git/workspace/devops.bazel_infrastructure -resource-dir /Library/Developer/CommandLineTools/usr/lib/clang/15.0.0 -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -I/usr/local/include -cxx-isystem /opt/homebrew/include -cxx-isystem . -internal-isystem /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/c++/v1 -internal-isystem /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/local/include -internal-isystem /Library/Developer/CommandLineTools/usr/lib/clang/15.0.0/include -internal-externc-isystem /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include -internal-externc-isystem /Library/Developer/CommandLineTools/usr/include -Wno-reorder-init-list -Wno-implicit-int-float-conversion -Wno-c99-designator -Wno-final-dtor-non-final-class -Wno-extra-semi-stmt -Wno-misleading-indentation -Wno-quoted-include-in-framework-header -Wno-implicit-fallthrough -Wno-enum-enum-conversion -Wno-enum-float-conversion -Wno-elaborated-enum-base -Wno-reserved-identifier -Wno-gnu-folding-constant -std=c++20 -fdeprecated-macro -fdebug-compilation-dir=/Users/ypz/peizhengs_git/workspace/devops.bazel_infrastructure -ferror-limit 19 -stack-protector 1 -fstack-check -mdarwin-stkchk-strong-link -fblocks -fencode-extended-block-signature -fregister-global-dtors-with-atexit -fgnuc-version=4.2.1 -fno-cxx-modules -fno-implicit-modules -fcxx-exceptions -fexceptions -fmax-type-align=16 -fcommon -fcolor-diagnostics -clang-vendor-feature=+disableNonDependentMemberExprInCurrentInstantiation -fno-odr-hash-protocols -clang-vendor-feature=+enableAggressiveVLAFolding -clang-vendor-feature=+revert09abecef7bbf -clang-vendor-feature=+thisNoAlignAttr -clang-vendor-feature=+thisNoNullAttr -mllvm -disable-aligned-alloc-awareness=1 -D__GCC_HAVE_DWARF2_CFI_ASM=1 -o /var/folders/x8/7g2htwjd1ss6rqvvx7t95x0m0000gn/T/hello-07e189.o -x c++ tests/C++/hello.cpp
clang -cc1 version 15.0.0 (clang-1500.3.9.4) default target arm64-apple-darwin23.4.0
ignoring nonexistent directory "/usr/local/include"
ignoring nonexistent directory "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/local/include"
ignoring nonexistent directory "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/Library/Frameworks"
#include "..." search starts here:
#include <...> search starts here:
 /opt/homebrew/include
 .
 /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/c++/v1
 /Library/Developer/CommandLineTools/usr/lib/clang/15.0.0/include
 /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include
 /Library/Developer/CommandLineTools/usr/include
 /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks (framework directory)
End of search list.
 "/Library/Developer/CommandLineTools/usr/bin/ld" -demangle -lto_library /Library/Developer/CommandLineTools/usr/lib/libLTO.dylib -no_deduplicate -dynamic -arch arm64 -platform_version macos 14.0.0 14.4 -syslibroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -o tests/C++/hello -L/usr/local/lib /var/folders/x8/7g2htwjd1ss6rqvvx7t95x0m0000gn/T/hello-07e189.o -lc++ -lSystem /Library/Developer/CommandLineTools/usr/lib/clang/15.0.0/lib/darwin/libclang_rt.osx.a
```


## homebrew gcc
```shell
# --sysroot=/opt/homebrew
/opt/homebrew/bin/gcc-13 tests/C++/hello.cpp --verbose -lstdc++ --sysroot=/opt/homebrew -o tests/C++/hello

/opt/homebrew/bin/gcc-13 tests/C++/hello.cpp --verbose -lstdc++ --sysroot=/opt/homebrew \
    -isystem /opt/homebrew/Cellar/gcc/13.2.0/include/c++/13/tr1/ \
    -isystem /Library/Developer/CommandLineTools/SDKs/MacOSX14.4.sdk/usr/include/c++/v1/ \
    -o tests/C++/hello 
```

If you don't specify the any other tools, e.g. linker, include directories, you will definitely get errors.
```shell
$ /opt/homebrew/Cellar/gcc/13.2.0/bin/gcc-13 --verbose -o tests/C++/hello tests/C++/hello.cpp

Using built-in specs.
COLLECT_GCC=/opt/homebrew/Cellar/gcc/13.2.0/bin/gcc-13
COLLECT_LTO_WRAPPER=/opt/homebrew/Cellar/gcc/13.2.0/bin/../libexec/gcc/aarch64-apple-darwin23/13/lto-wrapper
Target: aarch64-apple-darwin23
Configured with: ../configure --prefix=/opt/homebrew/opt/gcc --libdir=/opt/homebrew/opt/gcc/lib/gcc/current --disable-nls --enable-checking=release --with-gcc-major-version-only --enable-languages=c,c++,objc,obj-c++,fortran --program-suffix=-13 --with-gmp=/opt/homebrew/opt/gmp --with-mpfr=/opt/homebrew/opt/mpfr --with-mpc=/opt/homebrew/opt/libmpc --with-isl=/opt/homebrew/opt/isl --with-zstd=/opt/homebrew/opt/zstd --with-pkgversion='Homebrew GCC 13.2.0' --with-bugurl=https://github.com/Homebrew/homebrew-core/issues --with-system-zlib --build=aarch64-apple-darwin23 --with-sysroot=/Library/Developer/CommandLineTools/SDKs/MacOSX14.sdk
Thread model: posix
Supported LTO compression algorithms: zlib zstd
gcc version 13.2.0 (Homebrew GCC 13.2.0) 
COLLECT_GCC_OPTIONS='-v' '-o' 'tests/C++/hello' '-mmacosx-version-min=14.0.0' '-asm_macosx_version_min=14.0' '-nodefaultexport' '-mlittle-endian' '-mabi=lp64' '-dumpdir' 'tests/C++/'
 /opt/homebrew/Cellar/gcc/13.2.0/bin/../libexec/gcc/aarch64-apple-darwin23/13/cc1plus -quiet -v -iprefix /opt/homebrew/Cellar/gcc/13.2.0/bin/../lib/gcc/current/gcc/aarch64-apple-darwin23/13/ -D__DYNAMIC__ tests/C++/hello.cpp -fPIC -quiet -dumpdir tests/C++/ -dumpbase hello.cpp -dumpbase-ext .cpp -mmacosx-version-min=14.0.0 -mlittle-endian -mabi=lp64 -version -o /var/folders/x8/7g2htwjd1ss6rqvvx7t95x0m0000gn/T//cc5wOHSj.s
GNU C++17 (Homebrew GCC 13.2.0) version 13.2.0 (aarch64-apple-darwin23)
        compiled by GNU C version 13.2.0, GMP version 6.3.0, MPFR version 4.2.1, MPC version 1.3.1, isl version isl-0.26-GMP

GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
ignoring nonexistent directory "/opt/homebrew/Cellar/gcc/13.2.0/bin/../lib/gcc/current/gcc/aarch64-apple-darwin23/13/../../../../../../aarch64-apple-darwin23/include"
ignoring duplicate directory "/opt/homebrew/Cellar/gcc/13.2.0/bin/../lib/gcc/current/gcc/../../../../lib/gcc/current/gcc/aarch64-apple-darwin23/13/../../../../../../include/c++/13"
ignoring duplicate directory "/opt/homebrew/Cellar/gcc/13.2.0/bin/../lib/gcc/current/gcc/../../../../lib/gcc/current/gcc/aarch64-apple-darwin23/13/../../../../../../include/c++/13/aarch64-apple-darwin23"
ignoring duplicate directory "/opt/homebrew/Cellar/gcc/13.2.0/bin/../lib/gcc/current/gcc/../../../../lib/gcc/current/gcc/aarch64-apple-darwin23/13/../../../../../../include/c++/13/backward"
ignoring duplicate directory "/opt/homebrew/Cellar/gcc/13.2.0/bin/../lib/gcc/current/gcc/../../../../lib/gcc/current/gcc/aarch64-apple-darwin23/13/include"
ignoring nonexistent directory "/Library/Developer/CommandLineTools/SDKs/MacOSX14.sdk/usr/local/include"
ignoring duplicate directory "/opt/homebrew/Cellar/gcc/13.2.0/bin/../lib/gcc/current/gcc/../../../../lib/gcc/current/gcc/aarch64-apple-darwin23/13/include-fixed"
ignoring nonexistent directory "/opt/homebrew/Cellar/gcc/13.2.0/bin/../lib/gcc/current/gcc/../../../../lib/gcc/current/gcc/aarch64-apple-darwin23/13/../../../../../../aarch64-apple-darwin23/include"
ignoring nonexistent directory "/Library/Developer/CommandLineTools/SDKs/MacOSX14.sdk/Library/Frameworks"
#include "..." search starts here:
#include <...> search starts here:
 /opt/homebrew/include
 .
 /opt/homebrew/Cellar/gcc/13.2.0/bin/../lib/gcc/current/gcc/aarch64-apple-darwin23/13/../../../../../../include/c++/13
 /opt/homebrew/Cellar/gcc/13.2.0/bin/../lib/gcc/current/gcc/aarch64-apple-darwin23/13/../../../../../../include/c++/13/aarch64-apple-darwin23
 /opt/homebrew/Cellar/gcc/13.2.0/bin/../lib/gcc/current/gcc/aarch64-apple-darwin23/13/../../../../../../include/c++/13/backward
 /opt/homebrew/Cellar/gcc/13.2.0/bin/../lib/gcc/current/gcc/aarch64-apple-darwin23/13/include
 /opt/homebrew/Cellar/gcc/13.2.0/bin/../lib/gcc/current/gcc/aarch64-apple-darwin23/13/include-fixed
 /Library/Developer/CommandLineTools/SDKs/MacOSX14.sdk/usr/include
 /Library/Developer/CommandLineTools/SDKs/MacOSX14.sdk/System/Library/Frameworks
End of search list.
Compiler executable checksum: 209502f8f01ec92b961792b1ab39bbf9
COLLECT_GCC_OPTIONS='-v' '-o' 'tests/C++/hello' '-mmacosx-version-min=14.0.0'  '-nodefaultexport' '-mlittle-endian' '-mabi=lp64' '-dumpdir' 'tests/C++/'
 as -arch arm64 -v -mmacosx-version-min=14.0 -o /var/folders/x8/7g2htwjd1ss6rqvvx7t95x0m0000gn/T//ccRY2XUA.o /var/folders/x8/7g2htwjd1ss6rqvvx7t95x0m0000gn/T//cc5wOHSj.s
Apple clang version 15.0.0 (clang-1500.3.9.4)
Target: arm64-apple-darwin23.4.0
Thread model: posix
InstalledDir: /Library/Developer/CommandLineTools/usr/bin
 "/Library/Developer/CommandLineTools/usr/bin/clang" -cc1as -triple arm64-apple-macosx14.0.0 -filetype obj -main-file-name cc5wOHSj.s -target-cpu apple-m1 -target-feature +v8.5a -target-feature +crc -target-feature +lse -target-feature +rdm -target-feature +crypto -target-feature +dotprod -target-feature +fp-armv8 -target-feature +neon -target-feature +fp16fml -target-feature +ras -target-feature +rcpc -target-feature +zcm -target-feature +zcz -target-feature +fullfp16 -target-feature +sm4 -target-feature +sha3 -target-feature +sha2 -target-feature +aes -fdebug-compilation-dir=/Users/ypz/peizhengs_git/workspace/devops.bazel_infrastructure -dwarf-debug-producer "Apple clang version 15.0.0 (clang-1500.3.9.4)" -dwarf-version=4 -mrelocation-model pic --mrelax-relocations -mllvm -disable-aligned-alloc-awareness=1 -o /var/folders/x8/7g2htwjd1ss6rqvvx7t95x0m0000gn/T//ccRY2XUA.o /var/folders/x8/7g2htwjd1ss6rqvvx7t95x0m0000gn/T//cc5wOHSj.s
COMPILER_PATH=/opt/homebrew/Cellar/gcc/13.2.0/bin/../libexec/gcc/aarch64-apple-darwin23/13/:/opt/homebrew/Cellar/gcc/13.2.0/bin/../libexec/gcc/
LIBRARY_PATH=/opt/homebrew/Cellar/gcc/13.2.0/bin/../lib/gcc/current/gcc/aarch64-apple-darwin23/13/:/opt/homebrew/Cellar/gcc/13.2.0/bin/../lib/gcc/current/gcc/:/opt/homebrew/Cellar/gcc/13.2.0/bin/../lib/gcc/current/gcc/aarch64-apple-darwin23/13/../../../
COLLECT_GCC_OPTIONS='-v' '-o' 'tests/C++/hello' '-mmacosx-version-min=14.0.0'  '-nodefaultexport' '-mlittle-endian' '-mabi=lp64' '-dumpdir' 'tests/C++/hello.'
 /opt/homebrew/Cellar/gcc/13.2.0/bin/../libexec/gcc/aarch64-apple-darwin23/13/collect2 -syslibroot /Library/Developer/CommandLineTools/SDKs/MacOSX14.sdk/ -dynamic -arch arm64 -platform_version macos 14.0.0 0.0 -o tests/C++/hello -L/opt/homebrew/Cellar/gcc/13.2.0/bin/../lib/gcc/current/gcc/aarch64-apple-darwin23/13 -L/opt/homebrew/Cellar/gcc/13.2.0/bin/../lib/gcc/current/gcc -L/opt/homebrew/Cellar/gcc/13.2.0/bin/../lib/gcc/current/gcc/aarch64-apple-darwin23/13/../../.. /var/folders/x8/7g2htwjd1ss6rqvvx7t95x0m0000gn/T//ccRY2XUA.o -lemutls_w -lgcc -lSystem -no_compact_unwind -rpath @loader_path -rpath /opt/homebrew/Cellar/gcc/13.2.0/lib/gcc/current/gcc/aarch64-apple-darwin23/13 -rpath /opt/homebrew/Cellar/gcc/13.2.0/lib/gcc/current/gcc -rpath /opt/homebrew/Cellar/gcc/13.2.0/lib/gcc/current
Undefined symbols for architecture arm64:
  "__ZNSolsEl", referenced from:
      _main in ccRY2XUA.o
  "__ZNSt8ios_base4InitC1Ev", referenced from:
      __Z41__static_initialization_and_destruction_0v in ccRY2XUA.o
  "__ZNSt8ios_base4InitD1Ev", referenced from:
      __Z41__static_initialization_and_destruction_0v in ccRY2XUA.o
  "__ZSt4cout", referenced from:
      _main in ccRY2XUA.o
      _main in ccRY2XUA.o
  "__ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc", referenced from:
      _main in ccRY2XUA.o
      _main in ccRY2XUA.o
      _main in ccRY2XUA.o
ld: symbol(s) not found for architecture arm64
collect2: error: ld returned 1 exit status
```