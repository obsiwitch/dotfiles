#!/usr/bin/env python3

import sys
from collections import defaultdict
from enum import Enum
import libevdev
from libevdev import InputEvent, EV_SYN, EV_KEY, EV_KEY as K, EV_ABS, EV_REL

LAYOUT = [[[K.KEY_1, K.KEY_2, K.KEY_3, K.KEY_4],
           [K.KEY_5, K.KEY_6, K.KEY_7, K.KEY_8],
           [K.KEY_9, K.KEY_0, K.KEY_MINUS, K.KEY_EQUAL]],
          [[K.KEY_Q, K.KEY_W, K.KEY_E, K.KEY_R],
           [K.KEY_T, K.KEY_Y, K.KEY_U, K.KEY_I],
           [K.KEY_O, K.KEY_P, K.KEY_LEFTBRACE, K.KEY_RIGHTBRACE]],
          [[K.KEY_A, K.KEY_S, K.KEY_D, K.KEY_F],
           [K.KEY_G, K.KEY_H, K.KEY_J, K.KEY_K],
           [K.KEY_L, K.KEY_SEMICOLON, K.KEY_APOSTROPHE, K.KEY_BACKSLASH]],
          [[K.KEY_Z, K.KEY_X, K.KEY_C, K.KEY_V],
           [K.KEY_B, K.KEY_N, K.KEY_M, K.KEY_COMMA],
           [K.KEY_DOT, K.KEY_SLASH, K.KEY_GRAVE, K.KEY_102ND]],
          [[K.KEY_F1, K.KEY_F2, K.KEY_F3, K.KEY_F4],
           [K.KEY_F5, K.KEY_F6, K.KEY_F7, K.KEY_F8],
           [K.KEY_F9, K.KEY_SYSRQ, K.KEY_SCROLLLOCK, K.KEY_PAUSE]]]

class SDMap:
    DEVICE = '/dev/input/by-id/usb-Valve_Software_Steam_Controller_123456789ABCDEF-if02-event-joystick'

    def __init__(self):
        # input
        fd = open(self.DEVICE, 'rb')
        self.dev_in = libevdev.Device(fd)
        self.dev_in.grab()

        # gamepad output: games can access the device without any privilege.
        # Events only happen when self.kbd_mode == False.
        self.dev_in.name = 'Steam Deck sdmapd gamepad'
        self.dev_gamepad = self.dev_in.create_uinput_device()

        # pointer
        self.dev_in.enable(EV_KEY.BTN_LEFT)
        self.dev_in.enable(EV_KEY.BTN_RIGHT)
        self.dev_in.enable(EV_KEY.BTN_MIDDLE)
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
        self.dev_in.enable(EV_KEY.KEY_RIGHTALT)
        self.dev_in.enable(EV_KEY.KEY_ENTER)
        self.dev_in.enable(EV_KEY.KEY_ESC)
        self.dev_in.enable(EV_KEY.KEY_BACKSPACE)
        self.dev_in.enable(EV_KEY.KEY_SPACE)
        self.dev_in.enable(EV_KEY.KEY_TAB)
        self.dev_in.enable(EV_KEY.KEY_COMPOSE)
        for row in LAYOUT:
            for col in row:
                for key in col:
                    if key is None: continue
                    self.dev_in.enable(key)

        # keyboard & pointer output: requires privileges.
        # Events only happen when self.kbd_mode == True.
        self.dev_in.name = 'Steam Deck sdmapd keyboard'
        self.dev_kbd = self.dev_in.create_uinput_device()
        self.kbd_mode = True

        # contains past events from dev_in
        self.state_in = defaultdict(lambda: 0)

        # contains virtual keyboard keys that aren't yet released
        self.vkbd_out = defaultdict(lambda: 0)

    # map the minimum and maximum values of a joystick axis to the `key_min` and
    # `key_max` events.
    def joy2keys(self, ev_in, key_min, key_max):
        absinfo = self.dev_in.absinfo[ev_in.code]
        if abs(ev_in.value) <= absinfo.resolution:
            return [InputEvent(key_min, 0), InputEvent(key_max, 0)]
        elif ev_in.value == absinfo.minimum:
            return [InputEvent(key_min, 1)]
        elif ev_in.value == absinfo.maximum:
            return [InputEvent(key_max, 1)]
        return None

    def hat2rel(self, ev_in, code, coeff):
        if (not ev_in.value) or (not self.state_in[ev_in.code]): return None
        delta = ev_in.value - self.state_in[ev_in.code]
        return [InputEvent(code, int(delta * coeff))]

    def vkbd_keypos(self):
        absinfo = self.dev_in.absinfo[EV_ABS.ABS_HAT0X]
        y = abs((self.state_in[EV_ABS.ABS_HAT0Y] - absinfo.maximum) * len(LAYOUT))
        y /= (absinfo.maximum * 2) + 1
        y = int(y)
        x = (self.state_in[EV_ABS.ABS_HAT0X] + absinfo.maximum) * len(LAYOUT[0])
        x /= (absinfo.maximum * 2) + 1
        x = int(x)
        return x, y

    # returns events to release all pressed keys from the virtual keyboard
    def vkbd_clear(self):
        evs_out = [InputEvent(key, 0) for key in self.vkbd_out.keys()]
        self.vkbd_out.clear()
        return evs_out

    # map a key to a button of the virtual keyboard
    def key2vkdb(self, ev_in, bi, fallback_key):
        if self.state_in[EV_ABS.ABS_HAT0X] and self.state_in[EV_ABS.ABS_HAT0Y]:
            x, y = self.vkbd_keypos()
            key = LAYOUT[y][x][bi]
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

    def remap(self, ev_in):
        match ev_in.code:
            case EV_KEY.BTN_TL:
                return [InputEvent(EV_KEY.BTN_RIGHT, ev_in.value)]
            case EV_KEY.BTN_TR:
                return [InputEvent(EV_KEY.BTN_LEFT, ev_in.value)]
            case EV_KEY.BTN_TL2:
                return [InputEvent(EV_KEY.BTN_MIDDLE, ev_in.value)]
            case EV_KEY.BTN_TR2:
                return [InputEvent(EV_KEY.KEY_RIGHTALT, ev_in.value)]
            case EV_ABS.ABS_HAT1X:
                return self.hat2rel(ev_in, EV_REL.REL_X, 0.01)
            case EV_ABS.ABS_HAT1Y:
                return self.hat2rel(ev_in, EV_REL.REL_Y, -0.01)
            case EV_KEY.BTN_SOUTH:
                return self.key2vkdb(ev_in, 0, EV_KEY.KEY_ENTER)
            case EV_KEY.BTN_EAST:
                return self.key2vkdb(ev_in, 1, EV_KEY.KEY_ESC)
            case EV_KEY.BTN_NORTH:
                return self.key2vkdb(ev_in, 2, EV_KEY.KEY_BACKSPACE)
            case EV_KEY.BTN_WEST:
                return self.key2vkdb(ev_in, 3, EV_KEY.KEY_SPACE)
            case EV_ABS.ABS_HAT0X | EV_ABS.ABS_HAT0Y:
                if not ev_in.value: return self.vkbd_clear()
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

    def run(self):
        while ev_in := next(self.dev_in.events()):
            if ev_in.matches(EV_KEY.BTN_MODE, 0):
                self.kbd_mode = not self.kbd_mode
            elif not self.kbd_mode:
                self.dev_gamepad.send_events([ev_in])
            elif evs_out := self.remap(ev_in):
                evs_out.append(InputEvent(EV_SYN.SYN_REPORT, 0))
                self.dev_kbd.send_events(evs_out)
            self.state_in[ev_in.code] = ev_in.value

if __name__ == '__main__':
    SDMap().run()
