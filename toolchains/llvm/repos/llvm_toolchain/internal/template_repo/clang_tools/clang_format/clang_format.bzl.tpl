load("@bazel_skylib//lib:shell.bzl", "shell")

def _clang_format_impl(ctx):
    wrapper_sh = ctx.actions.declare_file(ctx.label.name + ".sh")  # ctx.label.name is the name of the rule.
    exclude_patterns = ["\\! -path {}".format(shell.quote(p)) for p in ctx.attr.exclude_patterns]
    include_patterns = ["-name {}".format(shell.quote(p)) for p in ctx.attr.patterns]
    CURRENT_WORKSPACE = ""
    workspace = ctx.file.workspace.path if ctx.file.workspace else CURRENT_WORKSPACE

    substitutions = {
        "@@EXCLUDE_PATTERNS@@": " ".join(exclude_patterns),
        "@@INCLUDE_PATTERNS@@": " -o ".join(include_patterns),
        "@@CLANG_FORMAT@@": shell.quote(ctx.executable.clang_format_binary.short_path),
        # Each value in the struct `ctx.executable` is either a File or None.
        # `short_path` is from Built-in Type `File`.
        "@@DIFF_COMMAND@@": shell.quote(ctx.attr.diff_command),
        "@@MODE@@": shell.quote(ctx.attr.mode),
        "@@WORKSPACE@@": workspace,
    }

    ctx.actions.expand_template(
        template = ctx.file._wrapper_template,
        output = wrapper_sh,
        substitutions = substitutions,
        is_executable = True,
    )

    files = [ctx.executable.clang_format_binary]

    if ctx.file.workspace:
        files.append(ctx.file.workspace)

    return DefaultInfo(
        runfiles = ctx.runfiles(files = files),
        executable = wrapper_sh,
    )

_clang_format_exclude = [
    # NOTE: The bazel symlink directories are automatically excluded when the rule is executed.
    # "./bazel-out/**",
    # "./bazel-bin/**",
    # "./bazel-testlogs/**",

    # TODO: Add directorys in .gitignore
]

clang_format_attrs = {
    "patterns": attr.string_list(
        default = ["*.c", "*.h", "*.cc", "*.cpp"],
        doc = "Filename patterns for format checking",
    ),
    "exclude_patterns": attr.string_list(
        default = _clang_format_exclude,
        doc = "Filename patterns to exlucde from format checking",
    ),
    "mode": attr.string(
        default = "diff",
        values = ["diff", "fix"],
        doc = "Execution mode: display diffs or fix formatting",
    ),
    "diff_command": attr.string(
        default = "diff -u",
        doc = "Command to execute to display diffs",
    ),
    "clang_format_binary": attr.label(
        # which is a `native_binary`.
        cfg = "exec",
        executable = True,
        doc = "The clang-format binary",
    ),
    # NOTE: Can be disabled since not have a need to run clang-format in another workspace.
    "workspace": attr.label(
        allow_single_file = True,  # Can be referred as ctx.file.workspace
        doc = "Label of the WORKSPACE file",
    ),
    "_wrapper_template": attr.label(
        default = ":clang_format.template.sh",
        allow_single_file = True,
        doc = "The shell template file, typically ends with `.template.sh`." +
              "The rendered template will be the entry point of execution.",
    ),
}

clang_format_check = rule(
    implementation = _clang_format_impl,
    attrs = clang_format_attrs,
    executable = True,
)
