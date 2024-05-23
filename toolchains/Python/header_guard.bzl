# load("@pip//:requirements.bzl", "requirement")
# load("@rules_python//python:defs.bzl", "py_binary")

# def header_guard_py_binary(name, all_headers):
#     py_binary(
#         name = "header_guard",
#         srcs = [":_header_guard_py"],
#         data = all_headers,
#         visibility = ["//visibility:public"],
#         deps = [requirement("pathspec")],
#     )
