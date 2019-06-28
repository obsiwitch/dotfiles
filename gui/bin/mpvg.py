#!/usr/bin/env python3

# usage: mpvg [path...]
# * mpvg - open media files from current directory
# * mpvg file - open media files from directory containing the specified `file`
# * mpvg dir  - open media files from specified `dir`
# * mpvg paths - open media files from specified `paths`

import sys
import os
from pathlib import Path

def getfiles(dir = '.'):
    _, _, files = next(os.walk(dir))
    files.sort()
    files = [ str(Path(dir) / f) for f in files ]
    return files

def mpvg(paths = [], args = []):
    if len(paths) == 0:
        paths = getfiles()
    elif len(paths) == 1:
        path = Path(paths[0])
        if path.is_file():
            paths = getfiles(dir = path.parent)
            starti = paths.index(str(path))
            args.append(f'--playlist-start={starti}')

    os.execvp('mpv', ['mpv', '--profile=gallery'] + args + paths)

mpvg(sys.argv[1:])
