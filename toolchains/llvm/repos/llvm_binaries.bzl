"""Create the LLVM toolchain binary repository."""

def _llvm_binaries_impl(rctx):
    """Repository rules impl of the LLVM toolchain binaries repository.

    Args:
        rctx (any): The repository rule context.
    """
    llvm_dir = rctx.attr.llvm_dir
    if llvm_dir[-1] == "/":
        llvm_dir = llvm_dir[:-1]

    rctx.template(
        "BUILD.bazel",  # path
        Label("llvm_binaries/llvm_binaries.BUILD.bazel.tpl"),  # template
        substitutions = {
            "@@LLVM_DIR@@": llvm_dir,
        },
    )

    # Q: Need rctx.file(MODULE.bazel)?
    # A: No.

llvm_binaries_repo = repository_rule(
    implementation = _llvm_binaries_impl,
    attrs = {
        "llvm_dir": attr.string(
            doc = "The absolute LLVM directory on the target machine. " +
                  "Example: /opt/homebrew/Cellar/llvm/18.X.X/, /usr/lib/llvm-X",
            mandatory = True,
        ),
    },
)
