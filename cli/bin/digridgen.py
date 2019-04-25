#!/usr/bin/env python3

# Dimetric grid generator
# Dependencies: [Pillow](https://pypi.org/project/Pillow/)
# Example: [Grid w/ 64x32 tiles](https://i.imgur.com/BWADxdj.png)

from PIL import Image, ImageDraw

class Edge:
    def __init__(self, segw, segh, segn):
        self.segw = segw
        self.segh = segh
        self.segn = segn

    def width(self):
        return self.segn * self.segw

    def height(self):
        return self.segn * self.segh

    def generator(self):
        for i in range(self.segn):
            x = self.width() - (i + 1) * self.segw
            y = self.segh * i
            p1 = (x, y)
            p2 = (x + self.segw - 1, y + self.segh - 1)
            yield (p1, p2)

    def __str__(self):
        return f"e{self.segw}x{self.segh}x{self.segn}"

class Tile:
    def __init__(self, edge, fgcolor = (0, 0, 0), bgcolor = None):
        self.edge = edge
        self.fgcolor = fgcolor
        self.bgcolor = bgcolor

    def width(self):
        return 2 * self.edge.width()

    def height(self):
        return 2 * self.edge.height()

    def size(self):
        return [self.width(), self.height()]

    def image(self):
        bg = Image.new('RGBA', self.size(), self.bgcolor)
        fg = Image.new('RGBA', self.size())
        drawfg = ImageDraw.Draw(fg)

        for box in self.edge.generator():
            drawfg.rectangle(box, self.fgcolor)
        fg.alpha_composite(fg.transpose(Image.FLIP_LEFT_RIGHT))
        fg.alpha_composite(fg.transpose(Image.FLIP_TOP_BOTTOM))
        bg.alpha_composite(fg)
        return bg

    def save(self, filename = None):
        filename = filename or f"{self}.png"
        self.image().save(filename)

    def __str__(self):
        return f"t{self.width()}x{self.height()}_{self.edge}"

class Grid:
    def __init__(self, tile, area):
        self.tile = tile
        self.area = area

    def width(self):
        return self.area[0] * self.tile.width()

    def height(self):
        return self.area[1] * self.tile.height()

    def size(self):
        return [self.width(), self.height()]

    def image(self):
        tileimg = self.tile.image()
        gridimg = Image.new('RGBA', self.size())
        for x in range(0, self.width(), self.tile.width()):
            for y in range(0, self.height(), self.tile.height()):
                gridimg.paste(tileimg, (x, y))
        return gridimg

    def save(self, filename = None):
        filename = filename or f"{self}.png"
        self.image().save(filename)

    def __str__(self):
        return f"g{self.width()}x{self.height()}_{self.tile}"

Grid(
    tile = Tile(
        edge    = Edge(segw = 4, segh = 2, segn = 8),
        fgcolor = "#4B5263",
        bgcolor = "#ABB2BF",
    ),
    area = [10, 10],
).save()
