# -*- coding: utf-8 -*-
import glob
import pathspec
import re
import argparse
import os

ALLOWED_HDR_EXTENSIONS = [".h", ".hpp"]

def _generate_macro(base_dir: str, file_path: str) -> str:
    """
    Generate the macro from a file name.

    Args:
        file_path: the relative path of a file.

    Return:
        The generated macro.
    """
    matched_hdr_extension_found = False
    for hdr_extension in ALLOWED_HDR_EXTENSIONS:
        if file_path.endswith(hdr_extension):
            matched_hdr_extension_found = True
            break
    assert(matched_hdr_extension_found)
    raw_macro = file_path.replace(base_dir, "")
    macro = re.sub("[/\.]", "_", raw_macro.upper()) + "_"
    return macro


def _read_lines(file_path: str) -> str:
    """Read a file and return lines

    Args:
        file_path: the relative path of a file.

    Return:
        list of strings, each element has a content of one line.
    """
    with open(file_path) as f:
        lines = f.readlines()
    return lines


def _generate_or_fix_header_guard(lines, macro: str):
    IFNDEF = f"#ifndef {macro}\n"
    DEFINE = f"#define {macro}\n"
    ENDIF = f"#endif // {macro}\n"

    # None means the line number is not found.
    ifndef_line_nr = None
    define_line_nr = None
    endif_line_nr = None

    ifndef_ok = False
    define_ok = False
    endif_ok = False

    for line_number, line_content in enumerate(lines, 0):
        if line_content == "":
            continue

        if ifndef_line_nr == None and line_content.startswith("#ifndef"):
            ifndef_line_nr = line_number
            if line_content == IFNDEF:
                ifndef_ok = True
            continue

        if ifndef_ok == True and line_content == IFNDEF:
            lines[line_number] = ""
            continue

        if define_line_nr == None and line_content.startswith("#define"):
            define_line_nr = line_number
            if ifndef_line_nr != None:
                if (define_line_nr - ifndef_line_nr) == 1 and line_content == DEFINE:
                    define_ok = True
                elif (define_line_nr - ifndef_line_nr) > 1 and line_content == DEFINE:
                    define_ok = False
                    lines[define_line_nr] = ""

            continue

        if define_line_nr != None and line_content == DEFINE:
            lines[line_number] = ""
            continue

    for line_number, line_content in reversed(list(enumerate(lines))):
        if line_content == "":
            continue
        if endif_line_nr == None and line_content.startswith("#endif"):
            endif_line_nr = line_number
            if line_content == ENDIF:
                endif_ok = True
        break

    # NOTE: important to have #define immediately after #ifndef.
    if ifndef_line_nr != None:
        define_line_nr = ifndef_line_nr + 1

    if ifndef_line_nr != None and ifndef_ok == False:
        lines[ifndef_line_nr] = IFNDEF
        ifndef_ok = True

    if define_line_nr != None and define_ok == False:
        lines[define_line_nr] = DEFINE
        define_ok = True

    if endif_line_nr != None and endif_ok == False:
        lines[endif_line_nr] = ENDIF
        endif_ok = True

    if ifndef_ok == False:
        lines.insert(
            ifndef_line_nr if ifndef_line_nr != None else 0, f"#ifndef {macro}\n"
        )
    if define_ok == False:
        lines.insert(
            define_line_nr if define_line_nr != None else 1, f"#define {macro}\n"
        )
    if endif_ok == False:
        lines.insert(
            endif_line_nr if endif_line_nr != None else len(lines),
            f"#endif // {macro}\n",
        )


def header_guard(base_dir: str, file_path: str) -> None:
    macro = _generate_macro(base_dir, file_path)
    lines = _read_lines(file_path)
    _generate_or_fix_header_guard(lines, macro)

    with open(file_path, "w") as f:
        for line in lines:
            f.write(line)


def list_header_files(base_dir: str) -> list[str]:  # TODO: make `base_dir` available.
    gitignore_spec = None if not os.path.exists(
        os.path.join(base_dir, ".gitignore")
    ) else pathspec.PathSpec.from_lines(
        pathspec.patterns.GitWildMatchPattern, open(os.path.join(base_dir, ".gitignore"))
    )

    all_hdrs = []
    for extension in ALLOWED_HDR_EXTENSIONS:
        all_hdrs += glob.glob(pathname=os.path.join(base_dir, f"**/*{extension}"), recursive=False)

    files = os.listdir(base_dir)
    for name in files:
        full_path = os.path.join(base_dir, name)
        if os.path.isdir(full_path) and not name.startswith("bazel-"):
            all_hdrs += glob.glob(pathname=os.path.join(full_path, "**/*.h"), recursive=True)

    if gitignore_spec:
        print("Found .gitignore file")
        return [hdr for hdr in all_hdrs if not gitignore_spec.match_file(hdr)]

    return all_hdrs


def parse_args():
    parser = argparse.ArgumentParser(description="Generate or fix header guard.")
    parser.add_argument("--workspace-root", help="The root dir of a Bazel workspace.")
    return parser.parse_args()


if __name__ == "__main__":
    args = parse_args()
    base_dir = os.path.abspath(args.workspace_root)

    hdrs = list_header_files(base_dir)

    for hdr in hdrs:
        header_guard(base_dir, hdr)
