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

    llvm_dir = rctx.attr.llvm_dir
    if llvm_dir[-1] == "/":
        llvm_dir = llvm_dir[:-1]

    llvm_major_version = rctx.attr.llvm_major_version
    if llvm_major_version == "":
        # TODO: Write a function to extract the major version from llvm_dir
        llvm_major_version = "18"

    default_sysroots = {
        (OS_NAME_LINUX, ARCH_NAME_AMD64): "/",
        (OS_NAME_LINUX, ARCH_NAME_AARCH64): "/",
        (OS_NAME_MACOS, ARCH_NAME_AARCH64): "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk",
    }

    sysroot = rctx.attr.sysroot
    if sysroot == "":
        sysroot = default_sysroots[os_arch_pair]

    toolchain_configs = {
        (OS_NAME_LINUX, ARCH_NAME_AMD64): ":internal/linux_x86_64_config.bzl",
        (OS_NAME_LINUX, ARCH_NAME_AARCH64): ":internal/linux_aarch64_config.bzl",
        (OS_NAME_MACOS, ARCH_NAME_AARCH64): ":internal/darwin_config.bzl",
    }

    rctx.template(
        "llvm_toolchain_config.bzl",  # path
        Label(toolchain_configs[os_arch_pair]),  # template
        substitutions = {},
    )

    rctx.template(
        "BUILD.bazel",  # path
        Label("internal/BUILD.bazel.tpl"),  # template
        substitutions = {
            "@@LLVM_DIR@@": llvm_dir,
            "@@LLVM_MAJOR_VERSION@@": llvm_major_version,
            "@@SYSROOT@@": sysroot,
            "@@OS@@": os_arch_pair[0],
            "@@ARCH@@": os_arch_pair[1],
        },
    )

llvm_toolchain_repo = repository_rule(
    implementation = llvm_toolchain_impl,
    attrs = {
        "llvm_dir": attr.string(
            doc = "The absolute LLVM directory on the target machine. " +
                  "Example: /opt/homebrew/Cellar/llvm/18.X.X/, /usr/lib/llvm-X",
            mandatory = True,
        ),
        "llvm_major_version": attr.string(
            doc = "The major version of the LLVM toolchain.",
            default = "",
        ),
        "sysroot": attr.string(
            doc = "The sysroot to use for the toolchain. " +
                  "For macosx, typically /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk. " +
                  "For Linux, typically /.",
            default = "",
        ),
    },
)
