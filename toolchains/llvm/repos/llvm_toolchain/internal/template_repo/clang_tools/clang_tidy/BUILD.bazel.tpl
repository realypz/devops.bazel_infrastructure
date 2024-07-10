""" Clang-tidy shell binary """

exports_files([".clang-tidy"])

sh_binary(
    name = "run_clang_tidy_sh",
    srcs = ["run_clang_tidy.sh"],
    data = [".clang-tidy"],
)
