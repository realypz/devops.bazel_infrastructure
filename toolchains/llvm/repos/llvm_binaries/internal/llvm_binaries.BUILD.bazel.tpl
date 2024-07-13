""" LLVM Binaries Repo build file """
# This file is only a template and will be rendered by bazel repository rule.
genrule(
    name = "clang-format",
    srcs = [],
    outs = ["clang-format-symlink"],
    cmd = "ln -s @@LLVM_DIR@@/bin/clang-format $(OUTS)",
    executable = True,
    visibility = ["//visibility:public"],
)

genrule(
    name = "clang-tidy",
    srcs = [],
    outs = ["clang-tidy-symlink"],
    cmd = "ln -s @@LLVM_DIR@@/bin/clang-tidy $(OUTS)",
    executable = True,
    visibility = ["//visibility:public"],
)

##### INFO: The below are not used at the moment.
genrule(
    name = "ar",
    srcs = [],
    outs = ["ar-symlink"],
    cmd = "ln -s @@LLVM_DIR@@/bin/llvm-ar $(OUTS)",
    executable = True,
    visibility = ["//visibility:public"],
)

genrule(
    name = "as",
    srcs = [],
    outs = ["as-symlink"],
    cmd = "ln -s @@LLVM_DIR@@/bin/llvm-as $(OUTS)",
    executable = True,
    visibility = ["//visibility:public"],
)

genrule(
    name = "ld",
    srcs = [],
    outs = ["ld-symlink"],
    cmd = "ln -s @@LLVM_DIR@@/bin/ld.lld $(OUTS)",
    executable = True,
    visibility = ["//visibility:public"],
)

genrule(
    name = "nm",
    srcs = [],
    outs = ["nm-symlink"],
    cmd = "ln -s @@LLVM_DIR@@/bin/llvm-nm $(OUTS)",
    executable = True,
    visibility = ["//visibility:public"],
)

genrule(
    name = "objcopy",
    srcs = [],
    outs = ["objcopy-symlink"],
    cmd = "ln -s @@LLVM_DIR@@/bin/llvm-objcopy $(OUTS)",
    executable = True,
    visibility = ["//visibility:public"],
)

genrule(
    name = "objdump",
    srcs = [],
    outs = ["objdump-symlink"],
    cmd = "ln -s @@LLVM_DIR@@/bin/llvm-objdump $(OUTS)",
    executable = True,
    visibility = ["//visibility:public"],
)

genrule(
    name = "profdata",
    srcs = [],
    outs = ["profdata-symlink"],
    cmd = "ln -s @@LLVM_DIR@@/bin/llvm-profdata $(OUTS)",
    executable = True,
    visibility = ["//visibility:public"],
)

genrule(
    name = "dwp",
    srcs = [],
    outs = ["dwp-symlink"],
    cmd = "ln -s @@LLVM_DIR@@/bin/llvm-dwp $(OUTS)",
    executable = True,
    visibility = ["//visibility:public"],
)

genrule(
    name = "ranlib",
    srcs = [],
    outs = ["ranlib-symlink"],
    cmd = "ln -s @@LLVM_DIR@@/bin/llvm-ranlib $(OUTS)",
    executable = True,
    visibility = ["//visibility:public"],
)

genrule(
    name = "readelf",
    srcs = [],
    outs = ["readelf-symlink"],
    cmd = "ln -s @@LLVM_DIR@@/bin/llvm-readelf $(OUTS)",
    executable = True,
    visibility = ["//visibility:public"],
)

genrule(
    name = "strip",
    srcs = [],
    outs = ["strip-symlink"],
    cmd = "ln -s @@LLVM_DIR@@/bin/llvm-strip $(OUTS)",
    executable = True,
    visibility = ["//visibility:public"],
)

genrule(
    name = "symbolizer",
    srcs = [],
    outs = ["symbolizer-symlink"],
    cmd = "ln -s @@LLVM_DIR@@/bin/llvm-symbolizer $(OUTS)",
    executable = True,
    visibility = ["//visibility:public"],
)
