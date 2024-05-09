
def _y_cc_toolchain_source_impl(rctx):


def _y_cc_toolchain_impl(rctx):
    _check_os_arch_keys(rctx.attr.sysroot)
    _check_os_arch_keys(rctx.attr.cxx_builtin_include_directories)

    os = _os(rctx)
    if os == "windows":
        _empty_repository(rctx)
        return
    arch = _arch(rctx)

    if not rctx.attr.toolchain_roots:
        toolchain_root = ("@" if BZLMOD_ENABLED else "") + "@%s_llvm//" % rctx.attr.name
    else:
        (_key, toolchain_root) = _exec_os_arch_dict_value(rctx, "toolchain_roots")

    if not toolchain_root:
        fail("LLVM toolchain root missing for ({}, {})".format(os, arch))
    (_key, llvm_version) = _exec_os_arch_dict_value(rctx, "llvm_versions")
    if not llvm_version:
        # LLVM version missing for (os, arch)
        _empty_repository(rctx)
        return
    use_absolute_paths_llvm = rctx.attr.absolute_paths
    use_absolute_paths_sysroot = use_absolute_paths_llvm

    # Check if the toolchain root is a system path.
    system_llvm = False
    if _is_absolute_path(toolchain_root):
        use_absolute_paths_llvm = True
        system_llvm = True

    # Paths for LLVM distribution:
    if system_llvm:
        llvm_dist_path_prefix = _canonical_dir_path(toolchain_root)
    else:
        llvm_dist_label = Label(toolchain_root + ":BUILD.bazel")  # Exact target does not matter.
        if use_absolute_paths_llvm:
            llvm_dist_path_prefix = _canonical_dir_path(str(rctx.path(llvm_dist_label).dirname))
        else:
            llvm_dist_path_prefix = _pkg_path_from_label(llvm_dist_label)

    if not use_absolute_paths_llvm:
        llvm_dist_rel_path = _canonical_dir_path("../../" + llvm_dist_path_prefix)
        llvm_dist_label_prefix = toolchain_root + ":"

        # tools can only be defined as absolute paths or in a subdirectory of
        # config_repo_path, because their paths are relative to the package
        # defining cc_toolchain, and cannot contain '..'.
        # https://github.com/bazelbuild/bazel/issues/7746.  To work around
        # this, we symlink the needed tools under the package so that they (except
        # clang) can be called with normalized relative paths. For clang
        # however, using a path with symlinks interferes with the header file
        # inclusion validation checks, because clang frontend will infer the
        # InstalledDir to be the symlinked path, and will look for header files
        # in the symlinked path, but that seems to fail the inclusion
        # validation check. So we always use a cc_wrapper (which is called
        # through a normalized relative path), and then call clang with the not
        # symlinked path from the wrapper.
        wrapper_bin_prefix = "bin/"
        tools_path_prefix = "bin/"
        tools = _toolchain_tools(os)
        for tool_name, symlink_name in tools.items():
            rctx.symlink(llvm_dist_rel_path + "bin/" + tool_name, tools_path_prefix + symlink_name)
        symlinked_tools_str = "".join([
            "\n" + (" " * 8) + "\"" + tools_path_prefix + symlink_name + "\","
            for symlink_name in tools.values()
        ])
    else:
        llvm_dist_rel_path = llvm_dist_path_prefix
        llvm_dist_label_prefix = llvm_dist_path_prefix

        # Path to individual tool binaries.
        # No symlinking necessary when using absolute paths.
        wrapper_bin_prefix = "bin/"
        tools_path_prefix = llvm_dist_path_prefix + "bin/"
        symlinked_tools_str = ""

    sysroot_paths_dict, sysroot_labels_dict = _sysroot_paths_dict(
        rctx,
        rctx.attr.sysroot,
        use_absolute_paths_sysroot,
    )

    workspace_name = rctx.name
    toolchain_info = struct(
        os = os,
        arch = arch,
        llvm_dist_label_prefix = llvm_dist_label_prefix,
        llvm_dist_path_prefix = llvm_dist_path_prefix,
        tools_path_prefix = tools_path_prefix,
        wrapper_bin_prefix = wrapper_bin_prefix,
        sysroot_paths_dict = sysroot_paths_dict,
        sysroot_labels_dict = sysroot_labels_dict,
        target_settings_dict = rctx.attr.target_settings,
        additional_include_dirs_dict = rctx.attr.cxx_builtin_include_directories,
        stdlib_dict = rctx.attr.stdlib,
        cxx_standard_dict = rctx.attr.cxx_standard,
        compile_flags_dict = rctx.attr.compile_flags,
        cxx_flags_dict = rctx.attr.cxx_flags,
        link_flags_dict = rctx.attr.link_flags,
        archive_flags_dict = rctx.attr.archive_flags,
        link_libs_dict = rctx.attr.link_libs,
        opt_compile_flags_dict = rctx.attr.opt_compile_flags,
        opt_link_flags_dict = rctx.attr.opt_link_flags,
        dbg_compile_flags_dict = rctx.attr.dbg_compile_flags,
        coverage_compile_flags_dict = rctx.attr.coverage_compile_flags,
        coverage_link_flags_dict = rctx.attr.coverage_link_flags,
        unfiltered_compile_flags_dict = rctx.attr.unfiltered_compile_flags,
        llvm_version = llvm_version,
        extra_compiler_files = rctx.attr.extra_compiler_files,
    )
    exec_dl_ext = "dylib" if os == "darwin" else "so"
    cc_toolchains_str, toolchain_labels_str = _cc_toolchains_str(
        rctx,
        workspace_name,
        toolchain_info,
        use_absolute_paths_llvm,
    )

    convenience_targets_str = _convenience_targets_str(
        rctx,
        use_absolute_paths_llvm,
        llvm_dist_rel_path,
        llvm_dist_label_prefix,
        exec_dl_ext,
    )

    # Convenience macro to register all generated toolchains.
    rctx.template(
        "toolchains.bzl",
        rctx.attr._toolchains_bzl_tpl,
        {
            "%{toolchain_labels}": toolchain_labels_str,
        },
    )

    # BUILD file with all the generated toolchain definitions.
    rctx.template(
        "BUILD.bazel",
        rctx.attr._build_toolchain_tpl,
        {
            "%{cc_toolchain_config_bzl}": str(rctx.attr._cc_toolchain_config_bzl),
            "%{cc_toolchains}": cc_toolchains_str,
            "%{symlinked_tools}": symlinked_tools_str,
            "%{wrapper_bin_prefix}": wrapper_bin_prefix,
            "%{convenience_targets}": convenience_targets_str,
        },
    )

    # CC wrapper script; see comments near the definition of `wrapper_bin_prefix`.
    if os == "darwin":
        cc_wrapper_tpl = rctx.attr._darwin_cc_wrapper_sh_tpl
    else:
        cc_wrapper_tpl = rctx.attr._cc_wrapper_sh_tpl
    rctx.template(
        "bin/cc_wrapper.sh",
        cc_wrapper_tpl,
        {
            "%{toolchain_path_prefix}": llvm_dist_path_prefix,
        },
    )


# Rule that create the source repo, e.g.
# clang+llvm-17.0.6-x86_64-linux-gnu-ubuntu-22.04
toolchain_source = repository_rule(
    attrs = ,
    local = False,
    implementation = _y_cc_toolchain_source_impl
)

# Rule that creates a toolchain repo, e.g. invoking the file
toolchain = repository_rule(
    attrs = ,
    local = False,
    implementation = _y_cc_toolchain_impl,
)

def y_cc_toolchain(rctx):
    """
    Macro that initialize the y_cc_toolchain.
    """
