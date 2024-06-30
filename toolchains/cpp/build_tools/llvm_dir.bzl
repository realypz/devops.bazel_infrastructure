# Define the LLVM toolchain dictionary, sysroot etc for different platforms.
# Please adapt these values according to your system.
LLVM_TOOLCHAIN_DICT = \
    {
        "linux": {
            "llvm_dir": "/usr/lib/llvm-18",
            "llvm_major_version": 18,
            "sysroot": "/",
        },
        "macosx": {
            "llvm_dir": "/opt/homebrew/Cellar/llvm/18.1.8/",
            "llvm_major_version": 18,
            "sysroot": "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk",
        },
    }
