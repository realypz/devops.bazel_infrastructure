#include "../sys_info.h"

#include <iostream>

void printCompilerInfo()
{
// Compiler info
#ifdef __clang__
    std::cout << "Compiler: Clang " << __clang_major__ << "." << __clang_minor__ << "."
              << __clang_patchlevel__ << "\n";
#elif __GNUC__
    std::cout << "Compiler: gcc " << __GNUC__ << '.' << __GNUC_MINOR__ << '.' << __GNUC_PATCHLEVEL__
              << "\n";
#else
    std::cout << "Compiler: Unknown\n";
#endif

// OS info
#ifdef __linux__
    std::cout << "OS: Linux\n";
#elif __APPLE__
    std::cout << "OS: macOS\n";
#else
    std::cout << "OS: Unknown\n";
#endif

// Sys arch info
#ifdef __x86_64__
    std::cout << "Arch: x86_64\n";
#elif __aarch64__
    std::cout << "Arch: aarch64\n";
#else
    std::cout << "Arch: Unknown\n";
#endif

    std::cout << "C++ standard: " << __cplusplus << "\n";

#ifdef __OPTIMIZE__
    std::cout << "Optimization enabled ✅\n";
#else
    std::cout << "Optimization disabled \n";
#endif
}