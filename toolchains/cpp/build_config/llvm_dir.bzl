LLVM_TOOLCHAIN_DICT = \
    """Define the LLVM toolchain dictionary, sysroot etc for different platforms."""
    {
        "linux": {
            "llvm_dir": "/usr/lib/llvm-18",
            "llvm_major_version": 18,
            "sysroot": "/",
        },
        "macosx": {
            "llvm_dir": "/opt/homebrew/Cellar/llvm/18.1.5/",
            "llvm_major_version": 18,
            "sysroot": "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk",
        },
    }
