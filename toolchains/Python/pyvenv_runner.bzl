def _pyvenv_runner_impl(ctx):
    sh_runner = ctx.actions.declare_file(ctx.label.name + ".sh")

    substitutions = {
        "@@REQUIREMENTS_TXT@@": ctx.file.requirements.short_path,
        "@@SCRIPT@@": ctx.file.script.short_path,
    }

    ctx.actions.expand_template(
        output = sh_runner,
        template = ctx.file.wrapper_template,
        substitutions = substitutions,
        is_executable = True,
    )

    return DefaultInfo(
        runfiles = ctx.runfiles(files = [ctx.file.requirements, ctx.file.script]),
        executable = sh_runner,
    )

pyvenv_runner = rule(
    implementation = _pyvenv_runner_impl,
    attrs = {
        "wrapper_template": attr.label(
            allow_single_file = True,
            default = "venv_runner.sh.template",
            doc = "The shell script template that createa a virtualenv and runs the script",
        ),
        "script": attr.label(
            allow_single_file = True,
            doc = "The shell script to run",
        ),
        "requirements": attr.label(
            allow_single_file = True,
            default = "requirements.txt",
            doc = "The python requirements file to install",
        ),
    },
    executable = True,
)
