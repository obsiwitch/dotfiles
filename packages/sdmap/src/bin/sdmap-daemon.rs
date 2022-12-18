use evdev::{*, uinput::*, AbsoluteAxisType as Abs, RelativeAxisType as Rel};
use libc::input_absinfo;
use sdmap::VKBD_LAYOUT;

struct Daemon {
    dev_in: Device,
    absinfos_in: [input_absinfo; 64],
    cache_in: DeviceState,
    dev_out: VirtualDevice,
    kbd_mode: bool,
}
impl Daemon {
    pub fn new() -> std::io::Result<Self> {
        let path_in = "/dev/input/by-id/usb-Valve_Software_Steam_Controller_123456789ABCDEF-if02-event-joystick";
        let mut dev_in = Device::open(path_in)?;
        dev_in.grab()?;
        let absinfos_in = dev_in.get_abs_state()?;

        let dev_out = VirtualDeviceBuilder::new()?
            .name("Steam Deck sdmapd")
            .with_keys(&AttributeSet::from_iter(
                VKBD_LAYOUT.into_iter().flatten().flatten().chain([
                Key::KEY_LEFTMETA, Key::KEY_UP, Key::KEY_DOWN, Key::KEY_LEFT,
                Key::KEY_RIGHT, Key::KEY_LEFTSHIFT, Key::KEY_LEFTCTRL, Key::KEY_RIGHTALT,
                Key::KEY_LEFTALT, Key::KEY_TAB, Key::KEY_COMPOSE, Key::KEY_PAGEUP,
                Key::KEY_PAGEDOWN, Key::KEY_HOME, Key::KEY_END, Key::KEY_ENTER,
                Key::KEY_ESC, Key::KEY_BACKSPACE, Key::KEY_SPACE, Key::KEY_DELETE,
                Key::KEY_F1, Key::KEY_F2, Key::KEY_F3, Key::KEY_F4, Key::BTN_RIGHT,
                Key::BTN_LEFT, Key::BTN_MIDDLE,
            ])))?
            .with_relative_axes(&AttributeSet::from_iter([Rel::REL_X, Rel::REL_Y]))?
            .build()?;

        Ok(Self {
            absinfos_in,
            cache_in: dev_in.cached_state().clone(),
            dev_in,
            dev_out,
            kbd_mode: true,
        })
    }

    // Create a new Key event. (shortcut)
    fn new_key(key: Key, value: i32) -> InputEvent {
        InputEvent::new(EventType::KEY, key.0, value)
    }

    // Map an absolute event to a relative one.
    fn abs2rel(&self, evt_in: InputEvent, rel: Rel, coeff: f32) -> InputEvent {
        let absval = self.cache_in.abs_vals().unwrap()[evt_in.code() as usize];
        let delta = if evt_in.value() == 0 || absval.value == 0 { 0.0 }
                   else { (evt_in.value() - absval.value) as f32 * coeff } as i32;
        InputEvent::new(EventType::RELATIVE, rel.0, delta)
    }

    // Map the minimum and maximum values of a joystick axis to the `key_min` and
    // `key_max` key events.
    fn joy2keys(&self, evt_in: InputEvent, key_min: Key, key_max: Key)
    -> Vec<InputEvent> {
        let absinfo = self.absinfos_in[evt_in.code() as usize];
        if evt_in.value().abs() <= absinfo.resolution {
            vec!(Self::new_key(key_min, 0), Self::new_key(key_max, 0))
        } else if evt_in.value() == absinfo.minimum {
            vec!(Self::new_key(key_min, 1))
        } else if evt_in.value() == absinfo.maximum {
            vec!(Self::new_key(key_max, 1))
        } else {
            vec!()
        }
    }

    // Returns the position on the virtual keyboard based on the position of
    // ABS_HAT0. Return None if ABS_HAT0 isn't used.
    pub fn vkbd_keypos(&self, evt_in: InputEvent)
    -> Option<(usize, usize)> {
        let absvals = self.cache_in.abs_vals().unwrap();
        let absinfo = self.absinfos_in[Abs::ABS_HAT0X.0 as usize];

        let absx = if evt_in.code() == Abs::ABS_HAT0X.0 { evt_in.value() }
                   else { absvals[Abs::ABS_HAT0X.0 as usize].value };
        let absy = if evt_in.code() == Abs::ABS_HAT0Y.0 { evt_in.value() }
                   else { absvals[Abs::ABS_HAT0Y.0 as usize].value };
        if absx == 0 && absy == 0 { return None; }

        let vkbdy = (absy - absinfo.maximum).abs() * VKBD_LAYOUT.len() as i32
                    / ((absinfo.maximum * 2) + 1);
        let vkbdx = (absx + absinfo.maximum) * VKBD_LAYOUT[0].len() as i32
                    / ((absinfo.maximum * 2) + 1);
        Some((vkbdx as usize, vkbdy as usize))
    }

    // Map a physical key to a key of the virtual keyboard depending on the current
    // value of ABS_HAT0{X,Y}. If ABS_HAT0 isn't used send the `fallback_key`.
    // `ki` corresponds to the section of the virtual keyboard to use.
    fn key2vkbd(&self, evt_in: InputEvent, ki: usize, fallback_key: Key)
    -> Vec<InputEvent> {
        if evt_in.value() == 0 {
            vec!()
        } else if let Some(keypos) = self.vkbd_keypos(evt_in) {
            let key = VKBD_LAYOUT[keypos.1][keypos.0][ki];
            vec!(Self::new_key(key, 1), Self::new_key(key, 0))
        } else {
            vec!(Self::new_key(fallback_key, 1), Self::new_key(fallback_key, 0))
        }
    }

    fn meta_map(&mut self, evt_in: InputEvent) {
        let key_vals = self.cache_in.key_vals().unwrap();

        // switch between keyboard+mouse mode and gamepad mode
        if evt_in.value() == 1 && key_vals.contains(Key::BTN_MODE) {
            self.kbd_mode = !self.kbd_mode;
            if self.kbd_mode {
                self.dev_in.grab().unwrap();
            } else {
                self.dev_in.ungrab().unwrap();
            }
        }
    }

    fn remap(&mut self, evt_in: InputEvent) -> Vec<InputEvent> {
        if evt_in.code() == Key::BTN_TR2.0 {
            vec!(Self::new_key(Key::KEY_LEFTMETA, evt_in.value()))
        } else if evt_in.code() == Key::BTN_DPAD_UP.0 {
            vec!(Self::new_key(Key::KEY_UP, evt_in.value()))
        } else if evt_in.code() == Key::BTN_DPAD_DOWN.0 {
            vec!(Self::new_key(Key::KEY_DOWN, evt_in.value()))
        } else if evt_in.code() == Key::BTN_DPAD_LEFT.0 {
            vec!(Self::new_key(Key::KEY_LEFT, evt_in.value()))
        } else if evt_in.code() == Key::BTN_DPAD_RIGHT.0 {
            vec!(Self::new_key(Key::KEY_RIGHT, evt_in.value()))
        } else if evt_in.code() == Key::BTN_TRIGGER_HAPPY1.0 {
            vec!(Self::new_key(Key::KEY_LEFTSHIFT, evt_in.value()))
        } else if evt_in.code() == Key::BTN_TRIGGER_HAPPY3.0 {
            vec!(Self::new_key(Key::KEY_LEFTCTRL, evt_in.value()))
        } else if evt_in.code() == Key::BTN_TRIGGER_HAPPY2.0 {
            vec!(Self::new_key(Key::KEY_RIGHTALT, evt_in.value()))
        } else if evt_in.code() == Key::BTN_TRIGGER_HAPPY4.0 {
            vec!(Self::new_key(Key::KEY_LEFTALT, evt_in.value()))
        } else if evt_in.code() == Key::BTN_SELECT.0 {
            vec!(Self::new_key(Key::KEY_TAB, evt_in.value()))
        } else if evt_in.code() == Abs::ABS_Y.0 {
            self.joy2keys(evt_in, Key::KEY_PAGEUP, Key::KEY_PAGEDOWN)
        } else if evt_in.code() == Abs::ABS_X.0 {
            self.joy2keys(evt_in, Key::KEY_HOME, Key::KEY_END)
        } else if evt_in.code() == Abs::ABS_RY.0 {
            self.joy2keys(evt_in, Key::KEY_F3, Key::KEY_F1)
        } else if evt_in.code() == Abs::ABS_RX.0 {
            self.joy2keys(evt_in, Key::KEY_F4, Key::KEY_F2)
        } else if evt_in.code() == Key::BTN_SOUTH.0 {
            self.key2vkbd(evt_in, 0, Key::KEY_ENTER)
        } else if evt_in.code() == Key::BTN_EAST.0 {
            self.key2vkbd(evt_in, 1, Key::KEY_ESC)
        } else if evt_in.code() == Key::BTN_NORTH.0 {
            self.key2vkbd(evt_in, 3, Key::KEY_BACKSPACE)
        } else if evt_in.code() == Key::BTN_WEST.0 {
            self.key2vkbd(evt_in, 2, Key::KEY_SPACE)
        } else if evt_in.code() == Key::BTN_START.0 {
            self.key2vkbd(evt_in, 4, Key::KEY_DELETE)
        } else if evt_in.code() == Key::BTN_BASE.0 {
            self.key2vkbd(evt_in, 5, Key::KEY_COMPOSE)
        } else if evt_in.code() == Key::BTN_TL.0 {
            vec!(Self::new_key(Key::BTN_RIGHT, evt_in.value()))
        } else if evt_in.code() == Key::BTN_TR.0 {
            vec!(Self::new_key(Key::BTN_LEFT, evt_in.value()))
        } else if evt_in.code() == Key::BTN_TL2.0 {
            vec!(Self::new_key(Key::BTN_MIDDLE, evt_in.value()))
        } else if evt_in.code() == Abs::ABS_HAT1X.0 {
            vec!(self.abs2rel(evt_in, Rel::REL_X, 0.01))
        } else if evt_in.code() == Abs::ABS_HAT1Y.0 {
            vec!(self.abs2rel(evt_in, Rel::REL_Y, -0.01))
        } else {
            vec!()
        }
    }

    pub fn run(&mut self) -> std::io::Result<()> {
        loop {
            self.cache_in = self.dev_in.cached_state().clone();
            let events_in: Vec<InputEvent> = self.dev_in.fetch_events()?.collect();

            events_in.iter().cloned().for_each(|evt_in|
                self.meta_map(evt_in)
            );
            if !self.kbd_mode { continue; }

            let events_out: Vec<InputEvent> = events_in.iter().cloned()
                .flat_map(|evt_in| self.remap(evt_in))
                .collect();
            self.dev_out.emit(&events_out)?;
        }
    }
}

fn main() -> std::io::Result<()> {
    let mut daemon = Daemon::new()?;
    daemon.run()?;
    Ok(())
}
