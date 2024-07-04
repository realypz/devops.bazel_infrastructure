""" Module for the C++ toolchains. """

load(
    "//toolchains/internal:common.bzl",
    "OS_NAME_LINUX",
    "OS_NAME_MACOS",
    "SUPPORTED_TARGETS",
    "get_os_arch_pair",
)
load(
    "//toolchains/llvm/internal:llvm_binaries.bzl",
    "llvm_binaries_repo",
)

def _llvm_module(module_ctx):
    """Module extension impl of the LLVM related repositories.

    Args:
        module_ctx (any): The module context.
    """
    os, arch = get_os_arch_pair(module_ctx)

    if (os, arch) not in SUPPORTED_TARGETS:
        fail("The os-arch pair is not supported yet with LLVM toolchain binaries!")

    if len(module_ctx.modules) != 1:
        fail("Check why there are more than one module in the module_ctx.")
    mod = module_ctx.modules[0]  # TODO: Check why it is a list.

    configs = mod.tags.config
    if len(configs) != 1:
        fail("Error: The module must be configured exactly once. " +
             "But you have configured it {} times!".format(len(configs)))

    for config in configs:
        llvm_dir = config.llvm_dir
        if llvm_dir == None or llvm_dir == "":
            if os == OS_NAME_LINUX:
                llvm_dir = "/usr/lib/llvm-18"
            elif os == OS_NAME_MACOS:
                llvm_dir = "/opt/homebrew/Cellar/llvm/18.1.8"
            else:
                fail("The os-arch pair is not supported yet with LLVM toolchain binaries!")

        # Create several llvm related repositories.
        llvm_binaries_repo(
            name = "llvm_binaries",
            llvm_dir = llvm_dir,
        )

llvm_module = module_extension(
    implementation = _llvm_module,
    tag_classes = {
        "config": tag_class(
            attrs = {
                "llvm_dir": attr.string(
                    doc = "The absolute LLVM directory on the target machine." +
                          "If not provided, the default directory will be used:" +
                          "darwin: /opt/homebrew/Cellar/llvm/18.X.X" +
                          "linux:  /usr/lib/llvm-X",
                    default = "",
                ),
                "sysroot": attr.string(
                    doc = "The sysroot directory for the target machine." +
                          "If not provided, the default sysroot will be used:" +
                          "darwin: /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk" +
                          "linux:  /",
                    default = "",
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
