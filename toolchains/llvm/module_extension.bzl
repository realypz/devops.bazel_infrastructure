""" Module for the C++ toolchains. """

load(
    "//toolchains/bzl_utils/common:common.bzl",
    "OS_NAME_LINUX",
    "OS_NAME_MACOS",
    "SUPPORTED_TARGETS",
    # "check_os_arch",
    "get_os_arch_pair",
)
load(
    "//toolchains/llvm/repos/llvm_binaries:repo_rule.bzl",
    "llvm_binaries_repo",
)
load(
    "//toolchains/llvm/repos/llvm_toolchain:internal/constants.bzl",
    "DEFAULT_LLVM_DIR",
    "DEFAULT_SYSROOT",
)
load("//toolchains/llvm/repos/llvm_toolchain:repo_rule.bzl", "llvm_toolchain_repo")

_DEFAULT_LLVM_TOOLCHAIN_REPO_NAME = "llvm_toolchain"
_DEFAULT_LLVM_BINARIES_REPO_NAME = "llvm_binaries"
_SEPARATOR = "_"

def _llvm_module(module_ctx):
    """Module extension impl of the LLVM related repositories.

    Args:
        module_ctx (any): The module context.
    """
    this_os, this_arch = get_os_arch_pair(module_ctx)

    if (this_os, this_arch) not in SUPPORTED_TARGETS:
        fail("The os-arch pair is not supported yet with LLVM toolchain binaries!")

    if len(module_ctx.modules) != 1:
        fail("Check why len(module_ctx.modules) != 1")
    mod = module_ctx.modules[0]  # TODO: Check why it is a list.

    ##### Detect whether the default llvm directory can be found or not.
    #     If yes, initialize a llvm_repo with the default name "@llvm_toolchain" and "@llvm_binaries".
    #     Ohterwise, do nothing.
    #####
    # TODO: Implement the script to found the default llvm directory and llvm version number.
    llvm_found = True

    if llvm_found:
        llvm_dir = DEFAULT_LLVM_DIR[(this_os, this_arch)]
        llvm_major_version = "18"
        sysroot = DEFAULT_SYSROOT[(this_os, this_arch)]

        llvm_binaries_repo(
            name = _DEFAULT_LLVM_BINARIES_REPO_NAME,
            llvm_dir = llvm_dir,
        )

        llvm_toolchain_repo(
            name = _DEFAULT_LLVM_TOOLCHAIN_REPO_NAME,
            llvm_dir = llvm_dir,
            llvm_major_version = llvm_major_version,
            sysroot = sysroot,
            llvm_binaries_repo_name = _DEFAULT_LLVM_BINARIES_REPO_NAME,
        )

    # Create other customized llvm repos if there are any
    for config in mod.tags.config:
        # Create several llvm related repositories.

        llvm_toolchain_repo_name = _DEFAULT_LLVM_TOOLCHAIN_REPO_NAME + _SEPARATOR + config.specifier
        llvm_binaries_repo_name = _DEFAULT_LLVM_BINARIES_REPO_NAME + _SEPARATOR + config.specifier

        if config.os != this_os or config.arch != this_arch:
            print("The repo {llvm_binaries_repo_name} and {llvm_toolchain_repo_name} are declared " +
                  "in the MODULE.bazel but not created due to not matching the current os-arch pair ({this_os}, {this_arch}).")
            continue

        llvm_major_version = "18"

        llvm_binaries_repo(
            name = llvm_binaries_repo_name,
            llvm_dir = config.llvm_dir,
        )

        llvm_toolchain_repo(
            name = llvm_toolchain_repo_name,
            llvm_dir = config.llvm_dir,
            llvm_major_version = llvm_major_version,
            sysroot = config.sysroot,
            llvm_binaries_repo_name = llvm_binaries_repo_name,
        )

llvm_module = module_extension(
    implementation = _llvm_module,
    tag_classes = {
        "config": tag_class(
            attrs = {
                "specifier": attr.string(
                    doc = "The specifier of the config." +
                          "The repo with name llvm_toolchain_<specifier> will be created. " +
                          "     You may have the same specifier for different (os, arch). " +
                          "     Keep in mind that they must unique for the same (os, arch) to " +
                          "     gurantee the uniqueness of the repo name.",
                    mandatory = True,
                ),
                "os": attr.string(
                    doc = "The OS name of the target machine. " +
                          "If not specified, the module extension rule will try to create " +
                          "this toolchain when being executed at any supported OS.",
                    mandatory = True,
                ),
                "arch": attr.string(
                    doc = "The architecture name of the target machine." +
                          "If not specified, the module extension rule will try to create " +
                          "this toolchain when being executed at any supported OS.",
                    mandatory = True,
                ),
                "llvm_dir": attr.string(
                    doc = "The absolute LLVM directory on the target machine." +
                          "If not provided, the default directory will be used:" +
                          "darwin: /opt/homebrew/Cellar/llvm/X.X.X" +
                          "linux:  /usr/lib/llvm-X",
                    mandatory = True,
                ),
                "sysroot": attr.string(
                    doc = "The sysroot directory for the target machine." +
                          "If not provided, the default sysroot will be used:" +
                          "darwin: /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk" +
                          "linux:  /",
                    mandatory = True,
                ),
            },
        ),
    },
    # The usage of tag_classes is in MODULE.bazel
    # llvm_module = use_extension("//toolchains/llvm:module.bzl", "llvm_module")
    # llvm_module.<tag_class>(
    #     attr_0 = ...,
    #     attr_1 = ...,
    # )
    # use_repo(llvm_module, "llvm_module")
)
