load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_file")

_BUILDIFIER_REPO_NAME = "buildifier_http_file"

def _bazel_buildifier_exe_impl(module_ctx):
    if module_ctx.os.name == "mac os x" and module_ctx.os.arch == "aarch64":
        sha256 = "d0909b645496608fd6dfc67f95d9d3b01d90736d7b8c8ec41e802cb0b7ceae7c"
        url = "https://github.com/bazelbuild/buildtools/releases/download/v7.1.2/buildifier-darwin-arm64"

    elif module_ctx.os.name == "linux" and module_ctx.os.arch == "amd64":
        sha256 = "28285fe7e39ed23dc1a3a525dfcdccbc96c0034ff1d4277905d2672a71b38f13"
        url = "https://github.com/bazelbuild/buildtools/releases/download/v7.1.2/buildifier-linux-amd64"

    elif module_ctx.os.name == "linux" and module_ctx.os.arch == "aarch64":
        sha256 = "c22a44eee37b8927167ee6ee67573303f4e31171e7ec3a8ea021a6a660040437"
        url = "https://github.com/bazelbuild/buildtools/releases/download/v7.1.2/buildifier-linux-arm64"

    else:
        fail("The os is not supported yet with buildifier!")

    # NOTE: http_file is a repo rule that creates a bazel repo!
    http_file(
        name = _BUILDIFIER_REPO_NAME,
        executable = True,
        sha256 = sha256,
        urls = [url],
    )

bazel_buildifier_exe = module_extension(
    implementation = _bazel_buildifier_exe_impl,
)
