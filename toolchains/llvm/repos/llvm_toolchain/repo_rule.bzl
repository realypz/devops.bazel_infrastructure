""" LLVM toolchain targets (i.e. cc_toolchain) repository. """

load(
    "//toolchains/bzl_utils/common:common.bzl",
    "ARCH_NAME_AARCH64",
    "ARCH_NAME_AMD64",
    "OS_NAME_LINUX",
    "OS_NAME_MACOS",
    "SUPPORTED_TARGETS",
    "get_os_arch_pair",
)

def llvm_toolchain_impl(rctx):
    """Repository rules impl of the LLVM toolchain repository.

    Args:
        rctx (any): The repository rule context.
    """
    os_arch_pair = get_os_arch_pair(rctx)
    if os_arch_pair not in SUPPORTED_TARGETS:
        fail("The os-arch pair is not supported yet with LLVM toolchain binaries!")

    llvm_major_version = rctx.attr.llvm_major_version

    toolchain_configs_templates = {
        (OS_NAME_LINUX, ARCH_NAME_AMD64): ":internal/template_repo/toolchain_config/linux_x86_64_config.bzl.tpl",
        (OS_NAME_LINUX, ARCH_NAME_AARCH64): ":internal/template_repo/toolchain_config/linux_aarch64_config.bzl.tpl",
        (OS_NAME_MACOS, ARCH_NAME_AARCH64): ":internal/template_repo/toolchain_config/darwin_config.bzl.tpl",
    }

    ##### //toolchain_config/...
    rctx.template(
        "toolchain_config/BUILD.bazel",
        Label("internal/template_repo/toolchain_config/BUILD.bazel.tpl"),
        substitutions = {},
    )

    rctx.template(
        "toolchain_config/config.bzl",  # path
        Label(toolchain_configs_templates[os_arch_pair]),  # template
        substitutions = {},
    )

    ##### //clang_tools/clang_format/...
    rctx.template(
        "clang_tools/clang_format/BUILD.bazel",
        Label("internal/template_repo/clang_tools/clang_format/BUILD.bazel.tpl"),
        substitutions = {},
    )
    rctx.template(
        "clang_tools/clang_format/clang_format.bzl",  # path
        Label("internal/template_repo/clang_tools/clang_format/clang_format.bzl.tpl"),  # template
        substitutions = {},
    )

    rctx.template(
        "clang_tools/clang_format/clang_format.template.sh",  # path
        Label("internal/template_repo/clang_tools/clang_format/clang_format.template.sh"),  # template
        substitutions = {},
    )

    ##### //clang_tools/clang_tidy/...
    rctx.template(
        "clang_tools/clang_tidy/.clang-tidy",
        Label("internal/template_repo/clang_tools/clang_tidy/.clang-tidy.tpl"),
        substitutions = {},
        executable = False,
    )

    rctx.template(
        "clang_tools/clang_tidy/BUILD.bazel",
        Label("internal/template_repo/clang_tools/clang_tidy/BUILD.bazel.tpl"),
        substitutions = {},
    )

    rctx.template(
        "clang_tools/clang_tidy/clang_tidy.bzl",  # path
        Label("internal/template_repo/clang_tools/clang_tidy/clang_tidy.bzl.tpl"),  # template
        substitutions = {
            "@@LLVM_BINARIES_REPO_NAME@@": rctx.attr.llvm_binaries_repo_name,
        },
    )

    rctx.template(
        "clang_tools/clang_tidy/run_clang_tidy.sh",  # path
        Label("internal/template_repo/clang_tools/clang_tidy/run_clang_tidy.template.sh"),  # template
        substitutions = {},
    )

    llvm_dir = rctx.attr.llvm_dir
    if llvm_dir[-1] == "/":
        llvm_dir = llvm_dir[:-1]

    rctx.template(
        "BUILD.bazel",  # path
        Label("internal/template_repo/BUILD.bazel.tpl"),  # template
        substitutions = {
            "@@LLVM_DIR@@": llvm_dir,
            "@@LLVM_MAJOR_VERSION@@": rctx.attr.llvm_major_version,
            "@@SYSROOT@@": rctx.attr.sysroot,
            "@@OS@@": os_arch_pair[0],
            "@@ARCH@@": os_arch_pair[1],
            "@@LLVM_BINARIES_REPO_NAME@@": rctx.attr.llvm_binaries_repo_name,
        },
    )

llvm_toolchain_repo = repository_rule(
    implementation = llvm_toolchain_impl,
    attrs = {
        "llvm_binaries_repo_name": attr.string(
            doc = "The name of the LLVM binaries repository. " +
                  "The clang_format, clang_tidy rules will depend on this repository.",
            mandatory = True,
        ),
        "llvm_dir": attr.string(
            doc = "The absolute LLVM directory on the target machine. " +
                  "Example: /opt/homebrew/opt/llvm/, /usr/lib/llvm-X",
            mandatory = True,
        ),
        "llvm_major_version": attr.string(
            doc = "The major version of the LLVM toolchain.",
            mandatory = True,
        ),
        "sysroot": attr.string(
            doc = "The sysroot to use for the toolchain. " +
                  "For macosx, typically /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk" +
                  "For Linux, typically /.",
            mandatory = True,
        ),
    },
)
