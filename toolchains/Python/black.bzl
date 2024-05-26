def _black_impl(ctx):
    black_sh = ctx.actions.declare_file(ctx.label.name + ".sh")

    substitutions = {
        "@@REQUIREMENTS_TXT@@": ctx.file.requirements.short_path,
    }

    ctx.actions.expand_template(
        output = black_sh,
        template = ctx.file.wrapper_template,
        substitutions = substitutions,
        is_executable = True,
    )

    return DefaultInfo(
        runfiles = ctx.runfiles(files = [ctx.file.requirements]),
        executable = black_sh,
    )

python_black = rule(
    implementation = _black_impl,
    attrs = {
        "wrapper_template": attr.label(
            allow_single_file = True,
            default = "run_black.sh.template",
        ),
        "requirements": attr.label(
            allow_single_file = True,
            default = "requirements.txt",
        ),
    },
    executable = True,
)
