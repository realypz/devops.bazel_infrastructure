# def MACRO_genrule_symlink(name, src, dst):
#     return {
#         "name": name,
#         "type": "genrule",
#         "srcs": [],
#         "outs": [dst],
#         "cmd": "ln -s %s $@" % src,
#     }
