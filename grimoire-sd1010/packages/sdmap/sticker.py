#!/usr/bin/env python3

from xkbcommon import xkb
from libevdev import EV_KEY as K
from sdmapd import LAYOUT

EVDEV_OFFSET = 8

class Sticker:
    def __init__(self, layout='fr'):
        self.ctx = xkb.Context()
        self.keymap = self.ctx.keymap_new_from_names(layout=layout)
        self.state = self.keymap.state_new()

    def keystring(self, keycode, mods=[]):
        if keycode is None: return ''
        
        for mod in mods:
            self.state.update_key(mod.value + EVDEV_OFFSET, xkb.XKB_KEY_DOWN)

        result = self.state.key_get_string(keycode.value + EVDEV_OFFSET)
        if not result:
            keysym = self.state.key_get_one_sym(keycode.value + EVDEV_OFFSET)
            result = xkb.keysym_get_name(keysym)

        for mod in mods:
            self.state.update_key(mod.value + EVDEV_OFFSET, xkb.XKB_KEY_UP)

        match result:
            case 'Pause': result = 'Br'
            case 'Scroll_Lock': result = 'SL'
            case 'Print': result = 'PS'
            case 'dead_circumflex': result = '^'
            case 'dead_acute': result = '´'
            case 'dead_grave': result = '`'
            case 'dead_diaeresis': result = '¨'
            case 'dead_belowdot' | 'dead_hook': result = ''
        return result

    def keystrings(self, keycode):
        result = []
        for mods in ([], [K.KEY_LEFTSHIFT], [K.KEY_RIGHTALT]):
            keystring = self.keystring(keycode, mods)
            result.append(keystring if keystring not in result else '')
            if keystring in 'abcdefghijklmnopqrstuvwxyz': break
        return result

    def html(self):
        def mods(keycode):
            return ' '.join(f'<span class="l{i}">{ks}</span>'
                            for i, ks in enumerate(self.keystrings(keycode)))
        
        print('''<!DOCTYPE html><html><body>
            <style type="text/css">
            body {font-family:monospace;}
            table {border-collapse: collapse; width:378px; height:378px;}
            td {border:1px solid #DDD;}
            td .l0 {font-size:24px;} 
            td .l1 {font-size:24px;}
            td .l2 {font-size:24px;}
            td.x {border-width: 3px 1px 1px 3px;}
            td.y {border-width: 3px 3px 1px 1px;}
            td.a {border-width: 1px 1px 3px 3px;}
            td.b {border-width: 1px 3px 3px 1px;}
            .a {color:limegreen;}
            .b {color:crimson;}
            .x {color:dodgerblue;}
            .y {color:orange;}
            </style>
            <table>''')
        for row in LAYOUT:
            print('<tr class="top">')
            for col in row:
                 print(f'''<td class="x">{mods(col[2])}</td>
                           <td class="y">{mods(col[3])}</td>''')
            print('</tr><tr class="bottom">')
            for col in row:
                 print(f'''<td class="a">{mods(col[0])}</td>
                           <td class="b">{mods(col[1])}</td>''')
            print('</tr>')
        print('</table></body></html>')

if __name__ == '__main__':
    Sticker().html()
