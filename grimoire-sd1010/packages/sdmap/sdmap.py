#!/usr/bin/env python3

# ref: https://wiki.archlinux.org/title/Keyboard_input

import sys, curses
from collections import defaultdict
from enum import Enum
import libevdev
from libevdev import InputEvent, EV_SYN, EV_KEY, EV_ABS, EV_REL

class SDMap:
    DEVICE = '/dev/input/by-id/usb-Valve_Software_Steam_Controller_123456789ABCDEF-if02-event-joystick'
    LAYOUT = [[[EV_KEY.KEY_F1,        EV_KEY.KEY_F2,  EV_KEY.KEY_F3,    EV_KEY.KEY_F4, EV_KEY.KEY_F5,],
               [EV_KEY.KEY_1,         EV_KEY.KEY_2,   EV_KEY.KEY_3,     EV_KEY.KEY_4,  EV_KEY.KEY_5, ],
               [EV_KEY.KEY_Q,         EV_KEY.KEY_W,   EV_KEY.KEY_E,     EV_KEY.KEY_R,  EV_KEY.KEY_T, ],
               [EV_KEY.KEY_A,         EV_KEY.KEY_S,   EV_KEY.KEY_D,     EV_KEY.KEY_F,  EV_KEY.KEY_G, ],
               [EV_KEY.KEY_Z,         EV_KEY.KEY_X,   EV_KEY.KEY_C,     EV_KEY.KEY_V,  EV_KEY.KEY_B, ],],

              [[EV_KEY.KEY_F10,       EV_KEY.KEY_F9,  EV_KEY.KEY_F8,    EV_KEY.KEY_F7, EV_KEY.KEY_F6,],
               [EV_KEY.KEY_0,         EV_KEY.KEY_9,   EV_KEY.KEY_8,     EV_KEY.KEY_7,  EV_KEY.KEY_6, ],
               [EV_KEY.KEY_P,         EV_KEY.KEY_O,   EV_KEY.KEY_I,     EV_KEY.KEY_U,  EV_KEY.KEY_Y, ],
               [EV_KEY.KEY_SEMICOLON, EV_KEY.KEY_L,   EV_KEY.KEY_K,     EV_KEY.KEY_J,  EV_KEY.KEY_H, ],
               [EV_KEY.KEY_SLASH,     EV_KEY.KEY_DOT, EV_KEY.KEY_COMMA, EV_KEY.KEY_M,  EV_KEY.KEY_N, ],],

              [[EV_KEY.KEY_BRIGHTNESSDOWN, EV_KEY.KEY_VOLUMEDOWN, EV_KEY.KEY_MUTE, EV_KEY.KEY_F12, EV_KEY.KEY_F11,       ],
               [None,                      None,                  None,            None,           EV_KEY.KEY_MINUS,     ],
               [None,                      None,                  None,            None,           EV_KEY.KEY_LEFTBRACE, ],
               [None,                      None,                  None,            None,           EV_KEY.KEY_APOSTROPHE,],
               [None,                      None,                  None,            None,           EV_KEY.KEY_GRAVE,     ],],

              [[EV_KEY.KEY_BRIGHTNESSUP,   EV_KEY.KEY_VOLUMEUP, None, None, EV_KEY.KEY_SYSRQ,     ],
               [None,                      None,                None, None, EV_KEY.KEY_EQUAL,     ],
               [None,                      None,                None, None, EV_KEY.KEY_RIGHTBRACE,],
               [None,                      None,                None, None, EV_KEY.KEY_BACKSLASH, ],
               [None,                      None,                None, None, None,                 ],],]

    def __init__(self):
        # input
        fd = open(self.DEVICE, 'rb')
        self.dev_in = libevdev.Device(fd)
        self.dev_in.grab()

        # pointer
        self.dev_in.enable(EV_KEY.BTN_LEFT)
        self.dev_in.enable(EV_KEY.BTN_RIGHT)
        self.dev_in.enable(EV_KEY.BTN_MIDDLE)
        self.dev_in.enable(EV_KEY.BTN_EXTRA)
        self.dev_in.enable(EV_KEY.BTN_SIDE)
        self.dev_in.enable(EV_REL.REL_X)
        self.dev_in.enable(EV_REL.REL_Y)

        # keyboard
        self.dev_in.enable(EV_KEY.KEY_PAGEUP)
        self.dev_in.enable(EV_KEY.KEY_PAGEDOWN)
        self.dev_in.enable(EV_KEY.KEY_HOME)
        self.dev_in.enable(EV_KEY.KEY_END)
        self.dev_in.enable(EV_KEY.KEY_UP)
        self.dev_in.enable(EV_KEY.KEY_DOWN)
        self.dev_in.enable(EV_KEY.KEY_LEFT)
        self.dev_in.enable(EV_KEY.KEY_RIGHT)
        self.dev_in.enable(EV_KEY.KEY_LEFTSHIFT)
        self.dev_in.enable(EV_KEY.KEY_LEFTCTRL)
        self.dev_in.enable(EV_KEY.KEY_LEFTMETA)
        self.dev_in.enable(EV_KEY.KEY_LEFTALT)
        self.dev_in.enable(EV_KEY.KEY_ENTER)
        self.dev_in.enable(EV_KEY.KEY_ESC)
        self.dev_in.enable(EV_KEY.KEY_BACKSPACE)
        self.dev_in.enable(EV_KEY.KEY_SPACE)
        self.dev_in.enable(EV_KEY.KEY_TAB)
        self.dev_in.enable(EV_KEY.KEY_COMPOSE)
        for layout in self.LAYOUT:
            for row in layout:
                for key in row:
                    if key is None: continue
                    self.dev_in.enable(key)

        # output
        self.dev_out = self.dev_in.create_uinput_device()
        self.kbd_mode = True
        self.state_in = defaultdict(lambda: 0)
        self.vkbd_out = defaultdict(lambda: 0)

    def joy2keys(self, ev_in, key_min, key_max):
        absinfo = self.dev_in.absinfo[ev_in.code]
        if abs(ev_in.value) <= absinfo.resolution:
            return [InputEvent(key_min, 0), InputEvent(key_max, 0)]
        elif ev_in.value == absinfo.minimum:
            return [InputEvent(key_min, 1)]
        elif ev_in.value == absinfo.maximum:
            return [InputEvent(key_max, 1)]
        return None

    def abs2rel(self, ev_in, code, coeff):
        if (not ev_in.value) or (not self.state_in[ev_in.code]): return None
        delta = ev_in.value - self.state_in[ev_in.code]
        return [InputEvent(code, int(delta * coeff))]

    def vkbd_keypos(self):
        absinfo = self.dev_in.absinfo[EV_ABS.ABS_HAT0X]
        y  = abs((self.state_in[EV_ABS.ABS_HAT0Y] - absinfo.maximum) * len(self.LAYOUT[0]))
        y /= (absinfo.maximum * 2) + 1
        y = int(y)
        x = (self.state_in[EV_ABS.ABS_HAT0X] + absinfo.maximum) * len(self.LAYOUT[0][0])
        x /= (absinfo.maximum * 2) + 1
        x = int(x)
        return x, y

    def vkbd_clear(self):
        evs_out = [InputEvent(key, 0) for key in self.vkbd_out.keys()]
        self.vkbd_out.clear()
        return evs_out

    def key2vkdb(self, ev_in, layout, fallback_key):
        if self.state_in[EV_KEY.BTN_8]:
            x, y = self.vkbd_keypos()
            key = layout[y][x]
            if key is None:
                return None
            elif ev_in.value:
                self.vkbd_out[key] = ev_in.value
                return [InputEvent(key, ev_in.value)]
            else:
                return self.vkbd_clear()
        else:
            self.vkbd_out[fallback_key] = ev_in.value
            return [InputEvent(fallback_key, ev_in.value)]

    def pointer(self, ev_in):
        match ev_in.code:
            case EV_KEY.BTN_TL:
                return [InputEvent(EV_KEY.BTN_RIGHT, ev_in.value)]
            case EV_KEY.BTN_TR:
                return [InputEvent(EV_KEY.BTN_LEFT, ev_in.value)]
            case EV_KEY.BTN_THUMBR:
                return [InputEvent(EV_KEY.BTN_MIDDLE, ev_in.value)]
            case EV_KEY.BTN_TL2:
                return [InputEvent(EV_KEY.BTN_SIDE, ev_in.value)]
            case EV_KEY.BTN_TR2:
                return [InputEvent(EV_KEY.BTN_EXTRA, ev_in.value)]
            case EV_ABS.ABS_HAT1X:
                return self.abs2rel(ev_in, EV_REL.REL_X, 0.01)
            case EV_ABS.ABS_HAT1Y:
                return self.abs2rel(ev_in, EV_REL.REL_Y, -0.01)
        return None

    def keyboard(self, ev_in):
        match ev_in.code:
            case EV_KEY.BTN_SOUTH:
                return self.key2vkdb(ev_in, self.LAYOUT[0], EV_KEY.KEY_ENTER)
            case EV_KEY.BTN_EAST:
                return self.key2vkdb(ev_in, self.LAYOUT[1], EV_KEY.KEY_ESC)
            case EV_KEY.BTN_NORTH:
                return self.key2vkdb(ev_in, self.LAYOUT[2], EV_KEY.KEY_BACKSPACE)
            case EV_KEY.BTN_WEST:
                return self.key2vkdb(ev_in, self.LAYOUT[3], EV_KEY.KEY_SPACE)
            case EV_KEY.BTN_8:
                return self.vkbd_clear()
            case EV_KEY.BTN_DPAD_UP:
                return [InputEvent(EV_KEY.KEY_UP, ev_in.value)]
            case EV_KEY.BTN_DPAD_DOWN:
                return [InputEvent(EV_KEY.KEY_DOWN, ev_in.value)]
            case EV_KEY.BTN_DPAD_LEFT:
                return [InputEvent(EV_KEY.KEY_LEFT, ev_in.value)]
            case EV_KEY.BTN_DPAD_RIGHT:
                return [InputEvent(EV_KEY.KEY_RIGHT, ev_in.value)]
            case EV_KEY.BTN_TRIGGER_HAPPY1:
                return [InputEvent(EV_KEY.KEY_LEFTSHIFT, ev_in.value)]
            case EV_KEY.BTN_TRIGGER_HAPPY3:
                return [InputEvent(EV_KEY.KEY_LEFTCTRL, ev_in.value)]
            case EV_KEY.BTN_TRIGGER_HAPPY2:
                return [InputEvent(EV_KEY.KEY_LEFTMETA, ev_in.value)]
            case EV_KEY.BTN_TRIGGER_HAPPY4:
                return [InputEvent(EV_KEY.KEY_LEFTALT, ev_in.value)]
            case EV_KEY.BTN_SELECT:
                return [InputEvent(EV_KEY.KEY_TAB, ev_in.value)]
            case EV_KEY.BTN_START:
                return [InputEvent(EV_KEY.KEY_COMPOSE, ev_in.value)]
            case EV_ABS.ABS_Y:
                return self.joy2keys(ev_in, EV_KEY.KEY_PAGEUP, EV_KEY.KEY_PAGEDOWN)
            case EV_ABS.ABS_X:
                return self.joy2keys(ev_in, EV_KEY.KEY_HOME, EV_KEY.KEY_END)
        return None

    def curses_keyboard(self, stdscr):
        stdscr.clear()
        for y, row in enumerate(self.LAYOUT[0]):
            for x, key in enumerate(row):
                attrs = curses.A_STANDOUT if self.vkbd_keypos() == (x, y) else 0
                stdscr.addstr(f'{key} ', attrs)
            stdscr.addstr('\n')
        stdscr.refresh()

    def run(self, stdscr):
        self.curses_keyboard(stdscr)
        while ev_in := next(self.dev_in.events()):
            if ev_in.matches(EV_KEY.BTN_MODE, 0):
                self.kbd_mode = not self.kbd_mode
            elif not self.kbd_mode:
                self.dev_out.send_events([ev_in])
            elif evs_out := self.pointer(ev_in) or self.keyboard(ev_in):
                evs_out.append(InputEvent(EV_SYN.SYN_REPORT, 0))
                self.dev_out.send_events(evs_out)
            self.state_in[ev_in.code] = ev_in.value
            self.curses_keyboard(stdscr)

if __name__ == '__main__':
    curses.wrapper(SDMap().run)
