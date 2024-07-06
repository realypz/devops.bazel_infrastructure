"""Repository for buildifier binary."""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_file")
load(
    "//toolchains/bzl_utils/common:common.bzl",
    "ARCH_NAME_AARCH64",
    "ARCH_NAME_AMD64",
    "OS_NAME_LINUX",
    "OS_NAME_MACOS",
    "get_os_arch_pair",
)

_BUILDIFIER_REPO_NAME = "buildifier_exe"

_URLS = {
    (OS_NAME_LINUX, ARCH_NAME_AMD64): {
        "url": "https://github.com/bazelbuild/buildtools/releases/download/v7.1.2/buildifier-linux-amd64",
        "sha256": "28285fe7e39ed23dc1a3a525dfcdccbc96c0034ff1d4277905d2672a71b38f13",
    },
    (OS_NAME_LINUX, ARCH_NAME_AARCH64): {
        "url": "https://github.com/bazelbuild/buildtools/releases/download/v7.1.2/buildifier-linux-arm64",
        "sha256": "c22a44eee37b8927167ee6ee67573303f4e31171e7ec3a8ea021a6a660040437",
    },
    (OS_NAME_MACOS, ARCH_NAME_AARCH64): {
        "url": "https://github.com/bazelbuild/buildtools/releases/download/v7.1.2/buildifier-darwin-arm64",
        "sha256": "d0909b645496608fd6dfc67f95d9d3b01d90736d7b8c8ec41e802cb0b7ceae7c",
    },
}

def _bazel_buildifier_exe_impl(module_ctx):
    os_arch = get_os_arch_pair(module_ctx)

    if (os_arch not in _URLS):
        fail("The os-arch pair is not supported yet with buildifier!")

    http_file(
        name = _BUILDIFIER_REPO_NAME,
        executable = True,
        sha256 = _URLS[os_arch]["sha256"],
        url = _URLS[os_arch]["url"],
    )

bazel_buildifier_exe = module_extension(
    implementation = _bazel_buildifier_exe_impl,
)
