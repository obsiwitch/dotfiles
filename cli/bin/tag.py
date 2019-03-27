#!/usr/bin/env python3

import sys
import os
import argparse
import glob

def cwd(): return sorted(glob.glob("*"))

class Xattr:
    @classmethod
    def list(cls, path): return [
        attr[5:] for attr in os.listxattr(path)
    ]

    @classmethod
    def rm(cls, path, attr):
        try: os.removexattr(path, "user." + attr)
        except OSError: raise OSError(
            f"Xattr.rm: {path} does not contain {attr}"
        )

    @classmethod
    def set(cls, path, attr, val = ""): os.setxattr(
        path, "user." + attr, val.encode()
    )

class Tag:
    def __init__(self):
        parser = argparse.ArgumentParser(
            description = "Tagging tool using extended attributes (xattr)."
        )
        parser.add_argument("-d", "--debug",
            action = "store_true",
            help   = "display traceback"
        )
        subparsers = parser.add_subparsers(
            required = True,
            dest     = "command",
            metavar  = "command",
            help     = "{ls, search, add, rm, clean}",
        )

        # ls
        parser_ls = subparsers.add_parser("ls",
            help = "List tags for the given paths.",
        )
        parser_ls.add_argument("--shared", action = "store_true")
        parser_ls.add_argument("paths", nargs = "*", default = cwd())

        # search
        parser_search = subparsers.add_parser("search",
            help     = "Search files by evaluating the given expression.",
            add_help = False,
        )
        parser_search.add_argument("expression")
        parser_search.add_argument("directory", nargs = "?", default = ".")

        # add
        parser_add = subparsers.add_parser("add",
            help = "Add tag to the given files.",
        )
        parser_add.add_argument("tag")
        parser_add.add_argument("paths", nargs = "+")

        # rm
        parser_rm = subparsers.add_parser("rm",
            help = "Remove tag from the given files.",
        )
        parser_rm.add_argument("tag")
        parser_rm.add_argument("paths", nargs = "+")

        # clean
        parser_clean = subparsers.add_parser("clean",
            help = "Remove all tags from the given files.",
        )
        parser_clean.add_argument("paths", nargs = "+")

        # parse
        args = parser.parse_args().__dict__
        if not args.pop("debug"): sys.tracebacklimit = 0
        getattr(self, args.pop("command"))(**args)

    @classmethod
    def ls(cls, paths = cwd(), shared = False):
        def fndefault():
            for path in paths:
                tags = Xattr.list(path)
                if not tags: continue
                strtags = str(tags).replace("'", "")
                print(f"{path}: {strtags}")

        def fnshared():
            tags = set(
                tag for path in paths
                    for tag in Xattr.list(path)
            )
            print("\n".join(tags))

        if shared: fnshared()
        else: fndefault()

    @classmethod
    def search(cls, expression, directory = "."):
        def generator():
            for dirpath, dirnames, filenames in os.walk(directory):
                yield dirpath
                yield from (
                    os.path.join(dirpath, f) for f in sorted(filenames)
                )

        def satisfy_one(attrs, criterion):
            include = (criterion in attrs)
            exclude = (criterion[0] == "-") and (criterion[1:] not in attrs)
            return include or exclude

        def satisfy_all(attrs, criteria): return all(
            satisfy_one(attrs, criterion)
            for criterion in criteria
        )

        print(*(
            filepath for filepath in generator() if satisfy_all(
                attrs    = Xattr.list(filepath),
                criteria = expression.split(),
            )
        ))

    @classmethod
    def add(cls, tag, paths):
        for path in paths:
            Xattr.set(path, tag)

    @classmethod
    def rm(cls, tag, paths):
        for path in paths:
            try: Xattr.rm(path, tag)
            except OSError as e: print(e)

    @classmethod
    def clean(cls, paths):
        for path in paths:
            for tag in Xattr.list(path):
                Xattr.rm(path, tag)

if __name__ == "__main__": Tag()
