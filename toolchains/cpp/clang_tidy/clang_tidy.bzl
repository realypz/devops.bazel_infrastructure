load("@bazel_tools//tools/build_defs/cc:action_names.bzl", "ACTION_NAMES")
load("@bazel_tools//tools/cpp:toolchain_utils.bzl", "find_cpp_toolchain")
load("//toolchains/cpp/clang_tidy:constants.bzl", "CLANG_TIDY_IGNORE_TAG")

def _exsits_in_list(value, list):
    """
    Returns True if the file exists in the list of files.
    """
    for x in list:
        if x == value:
            return True
    return False

def _rule_sources(ctx):
    """
    Returns the sources of the rule.
    """
    PERMITTED_FILE_EXTENSIONS = [
        ".c",
        ".cc",
        ".cpp",
        ".cxx",
        ".c++",
        ".C",
        ".h",
        ".hh",
        ".hpp",
        ".hxx",
        ".inc",
        ".inl",
        ".H",
    ]

    source_files = []

    # ctx.rule (rule_attributes): Information about attributes of a rule an aspect is applied to.
    if hasattr(ctx.rule.attr, "srcs"):
        for src in ctx.rule.attr.srcs:
            # NOTE: src is a File object. https://bazel.build/rules/lib/builtins/File
            #      src.is_source: True if the file it is NOT a generated file.
            source_files += [
                src
                for src in src.files.to_list()
                if src.is_source and _exsits_in_list(src.extension, PERMITTED_FILE_EXTENSIONS)
            ]

    if hasattr(ctx.rule.attr, "hdrs"):
        for hdr in ctx.rule.attr.hdrs:
            source_files += [
                hdr
                for hdr in hdr.files.to_list()
                if hdr.is_source and _exsits_in_list(hdr.extension, PERMITTED_FILE_EXTENSIONS)
            ]
    return source_files

def _toolchain_flags(ctx, action_name = ACTION_NAMES.cpp_compile):
    cc_toolchain = find_cpp_toolchain(ctx)
    feature_configuration = cc_common.configure_features(
        ctx = ctx,
        cc_toolchain = cc_toolchain,
    )
    compile_variables = cc_common.create_compile_variables(
        feature_configuration = feature_configuration,
        cc_toolchain = cc_toolchain,
        user_compile_flags = ctx.fragments.cpp.cxxopts + ctx.fragments.cpp.copts,
    )
    flags = cc_common.get_memory_inefficient_command_line(
        feature_configuration = feature_configuration,
        action_name = action_name,
        variables = compile_variables,
    )
    return flags

def _filter_unspported_flags(flags):
    # Some flags might be used by GCC, but not understood by Clang.
    # Remove them here, to allow users to run clang-tidy, without having
    # a clang toolchain configured (that would produce a good command line with --compiler clang)
    unsupported_flags = [
        "-fno-canonical-system-headers",
        # "-fstack-usage",  # Disabled since both clang and gcc support it
    ]

    return [flag for flag in flags if flag not in unsupported_flags]

def _run_tidy(
        ctx,
        wrapper,
        clangtidy_exe,
        clangtidy_cfg,
        flags,
        compilation_context,
        infile):
    """
    Run clang-tidy on a target and return the suggested fixes.

    Args:
        ctx: The context of the aspect.
        wrapper: The wrapper script to run clang-tidy.
        clangtidy_exe: The executable of clang-tidy.
        clangtidy_cfg: The clang-tidy configuration file.
        flags: The flags to run clang-tidy.
        compilation_context (CompilationContext): The compilation context from a C/C++ target's provider.
        infile: The input file to run clang-tidy.

    Returns:
        A file containing the suggested fixes.
    """

    # NOTE: Bazel requires explicitly declare all the input and out file because of sandbox mechanism.
    # Declare the sets of the inputs files.
    inputs = depset(
        direct = (
            [
                infile,
                clangtidy_cfg,
                clangtidy_exe.files_to_run.executable,
            ]
        ),
        # NOTE: compilation_context.headers are not directly referred by the clang-tidy command line,
        #       but they are referred by the cpp files, and needed by the compilation process.
        #       Thus they are declared as transitive inputs.
        #       Without the headers, clang-tidy exits with error as if compiler throws error
        #       "the header file not found".
        transitive = [compilation_context.headers],
    )

    outfile = ctx.actions.declare_file(
        "bazel_clang_tidy_" + infile.path + "." + ".clang-tidy-report.yaml",
    )

    # Create an args object to store the arguments.
    args = ctx.actions.args()

    # this is consumed by the wrapper script
    args.add(clangtidy_exe.files_to_run.executable)
    args.add(outfile.path)  # this is consumed by the wrapper script
    args.add(clangtidy_cfg.path)

    # YAML file to store suggested fixes in
    args.add("--export-fixes", outfile.path)

    # add source to check
    args.add(infile.path)

    # start args passed to the compiler
    args.add("--")

    # add args specified by the toolchain, on the command line and rule copts
    args.add_all(flags)

    # add defines
    for define in compilation_context.defines.to_list():
        args.add("-D" + define)

    for define in compilation_context.local_defines.to_list():
        args.add("-D" + define)

    # add includes
    for i in compilation_context.framework_includes.to_list():
        args.add("-F" + i)

    for i in compilation_context.includes.to_list():
        args.add("-I" + i)

    args.add_all(compilation_context.quote_includes.to_list(), before_each = "-iquote")
    args.add_all(compilation_context.system_includes.to_list(), before_each = "-isystem")

    # Without this flag, clang-tidy cannot link to the C++ standard library,
    # thus reporting false-positive errors.
    args.add("-stdlib=libc++")

    ctx.actions.run(
        inputs = inputs,
        outputs = [outfile],
        executable = wrapper,
        arguments = [args],
        mnemonic = "ClangTidy",
        use_default_shell_env = True,
        progress_message = "Run clang-tidy on {}".format(infile.short_path),
    )
    return outfile

def _clang_tidy_aspect_impl(target, ctx):
    """The aspect implementation for clang-tidy.

    Args:
        target (Any): The target to apply the aspect to.
        ctx (ctx): The context of the aspect.

    NOTE: The (target, ctx) is the pattern params for the aspect implementation.
    """

    # if not a C/C++ target, we are not interested
    if not CcInfo in target:
        # NOTE: https://bazel.build/rules/lib/providers/CcInfo
        return []

    # Ignore external targets
    if target.label.workspace_root.startswith("external"):
        return []

    # Targets with specific tags will not be formatted
    if ctx.rule.attr.tags == CLANG_TIDY_IGNORE_TAG:
        return []

    wrapper = ctx.attr._clang_tidy_wrapper.files_to_run
    exe = ctx.attr._clang_tidy_executable

    # additional_deps = ctx.attr._clang_tidy_additional_deps
    config = ctx.attr._clang_tidy_config.files.to_list()[0]
    compilation_context = target[CcInfo].compilation_context  # target is e.g. //example:lib

    rule_flags = ctx.rule.attr.copts if hasattr(ctx.rule.attr, "copts") else []
    c_flags = _filter_unspported_flags(_toolchain_flags(ctx, ACTION_NAMES.c_compile) + rule_flags) + ["-xc"]
    cxx_flags = _filter_unspported_flags(_toolchain_flags(ctx, ACTION_NAMES.cpp_compile) + rule_flags) + ["-xc++"]

    srcs = _rule_sources(ctx)

    outputs = [
        _run_tidy(
            ctx,
            wrapper,
            exe,
            # additional_deps,
            config,
            c_flags if src.extension == "c" else cxx_flags,
            compilation_context,
            src,
        )
        for src in srcs
    ]

    return [
        OutputGroupInfo(report = depset(direct = outputs)),
    ]

clang_tidy_aspect = aspect(
    implementation = _clang_tidy_aspect_impl,
    fragments = ["cpp"],
    attrs = {
        "_cc_toolchain": attr.label(default = Label("@bazel_tools//tools/cpp:current_cc_toolchain")),
        # NOTE: Why need _cc_toolchain?
        #       To depend on a C++ toolchain in your rule, add a Label attribute named _cc_toolchain and
        #       point it to @bazel_tools//tools/cpp:current_cc_toolchain (an instance of cc_toolchain_alias rule,
        #       that points to the currently selected C++ toolchain).
        #       https://bazel.build/configure/integrate-cpp
        "_clang_tidy_wrapper": attr.label(
            default = Label("//toolchains/cpp/clang_tidy:run_clang_tidy_sh"),
            executable = True,
            cfg = "exec",
        ),
        "_clang_tidy_executable": attr.label(
            default = Label("//toolchains/cpp/clang_tidy:clang-tidy-symlink"),
            executable = True,
            cfg = "exec",
        ),
        # "_clang_tidy_additional_deps": attr.label(default = Label("//:clang_tidy_additional_deps")),
        "_clang_tidy_config": attr.label(
            default = ".clang-tidy",
            allow_single_file = True,
        ),
    },
    toolchains = ["@bazel_tools//tools/cpp:toolchain_type"],
)
