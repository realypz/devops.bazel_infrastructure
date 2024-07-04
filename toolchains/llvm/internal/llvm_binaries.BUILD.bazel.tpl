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
