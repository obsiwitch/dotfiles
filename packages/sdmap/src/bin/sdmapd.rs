use evdev::{*, AbsoluteAxisType as Abs, RelativeAxisType as Rel};
use libc::input_absinfo;
use sdmap::VKBD_LAYOUT;

struct Sdmapd {
    dev_in: Device,
    absinfos_in: [input_absinfo; 64],
    cache_in: DeviceState,
    dev_keyboard: uinput::VirtualDevice,
    kbd_mode: bool,
}
impl Sdmapd {
    pub fn new() -> std::io::Result<Self> {
        let path_in = "/dev/input/by-id/usb-Valve_Software_Steam_Controller_123456789ABCDEF-if02-event-joystick";
        let mut dev_in = Device::open(path_in)?;
        dev_in.grab()?;

        // keyboard & mouse
        let dev_keyboard = uinput::VirtualDeviceBuilder::new()?
            .name("Steam Deck sdmapd keyboard")
            .with_keys(&AttributeSet::from_iter(
                VKBD_LAYOUT.into_iter().flatten().flatten().chain([
                Key::BTN_RIGHT, Key::BTN_LEFT, Key::BTN_MIDDLE, Key::KEY_LEFTMETA,
                Key::KEY_UP, Key::KEY_DOWN, Key::KEY_LEFT, Key::KEY_RIGHT,
                Key::KEY_LEFTSHIFT, Key::KEY_LEFTCTRL, Key::KEY_RIGHTALT,
                Key::KEY_LEFTALT, Key::KEY_TAB, Key::KEY_COMPOSE, Key::KEY_PAGEUP,
                Key::KEY_PAGEDOWN, Key::KEY_HOME, Key::KEY_END, Key::KEY_ENTER,
                Key::KEY_ESC, Key::KEY_BACKSPACE, Key::KEY_SPACE
            ])))?
            .with_relative_axes(&AttributeSet::from_iter([
                Rel::REL_X, Rel::REL_Y
            ]))?
            .build()?;

        Ok(Self {
            absinfos_in: dev_in.get_abs_state()?,
            cache_in: dev_in.cached_state().clone(),
            dev_in: dev_in,
            dev_keyboard: dev_keyboard,
            kbd_mode: true,
        })
    }

    // Map a key event to another key.
    fn key2key(&self, evt_in: InputEvent, key: Key) -> InputEvent {
        InputEvent::new(EventType::KEY, key.0, evt_in.value())
    }

    // Map an absolute event (hat) to a relative one.
    fn hat2rel(&self, evt_in: InputEvent, rel: Rel, coeff: f32) -> InputEvent {
        let absval = self.cache_in.abs_vals().unwrap()[evt_in.code() as usize];
        let delta = if evt_in.value() == 0 || absval.value == 0 {
            0.0
        } else {
            (evt_in.value() - absval.value) as f32 * coeff
        } as i32;
        InputEvent::new(EventType::RELATIVE, rel.0, delta)
    }

    // Map the minimum and maximum values of a joystick axis to the `key_min` and
    // `key_max` key events.
    fn joy2keys(&self, evt_in: InputEvent, key_min: Key, key_max: Key)
    -> Vec<InputEvent> {
        let absinfo = self.absinfos_in[evt_in.code() as usize];
        if evt_in.value().abs() <= absinfo.resolution {
            vec!(InputEvent::new(EventType::KEY, key_min.0, 0),
                 InputEvent::new(EventType::KEY, key_max.0, 0))
        } else if evt_in.value() == absinfo.minimum {
            vec!(InputEvent::new(EventType::KEY, key_min.0, 1))
        } else if evt_in.value() == absinfo.maximum {
            vec!(InputEvent::new(EventType::KEY, key_max.0, 1))
        } else {
            vec!()
        }
    }

    fn vkbd_keypos(&self) -> (usize, usize) {
        let absinfo = self.absinfos_in[Abs::ABS_HAT0X.0 as usize];
        let absvals = self.cache_in.abs_vals().unwrap();
        let y = (
            (absvals[Abs::ABS_HAT0Y.0 as usize].value - absinfo.maximum).abs()
            * VKBD_LAYOUT.len() as i32
        ) / ((absinfo.maximum * 2) + 1);
        let x = (
            (absvals[Abs::ABS_HAT0X.0 as usize].value + absinfo.maximum)
            * VKBD_LAYOUT[0].len() as i32
        ) / ((absinfo.maximum * 2) + 1);
        (x as usize, y as usize)
    }

    // Map a physical key to a key of the virtual keyboard depending on the current
    // value of ABS_HAT0{X,Y}. If ABS_HAT0{X,Y} == (0, 0), send the `fallback_key`.
    fn key2vkbd(&self, evt_in: InputEvent, ki: usize, fallback_key: Key)
    -> Vec<InputEvent> {
        let absvals = self.cache_in.abs_vals().unwrap();
        if evt_in.value() == 0 {
            vec!()
        } else if absvals[Abs::ABS_HAT0X.0 as usize].value != 0
               && absvals[Abs::ABS_HAT0Y.0 as usize].value != 0
        {
            let keypos = self.vkbd_keypos();
            let key = VKBD_LAYOUT[keypos.1][keypos.0][ki];
            vec!(InputEvent::new(EventType::KEY, key.0, 1),
                 InputEvent::new(EventType::KEY, key.0, 0))
        } else {
            vec!(InputEvent::new(EventType::KEY, fallback_key.0, 1),
                 InputEvent::new(EventType::KEY, fallback_key.0, 0))
        }
    }

    fn kbd_map(&self, evt_in: InputEvent) -> Vec<InputEvent> {
        if evt_in.code() == Key::BTN_TL.0 {
            vec!(self.key2key(evt_in, Key::BTN_RIGHT))
        } else if evt_in.code() == Key::BTN_TR.0 {
            vec!(self.key2key(evt_in, Key::BTN_LEFT))
        } else if evt_in.code() == Key::BTN_TL2.0 {
            vec!(self.key2key(evt_in, Key::BTN_MIDDLE))
        } else if evt_in.code() == Key::BTN_TR2.0 {
            vec!(self.key2key(evt_in, Key::KEY_LEFTMETA))
        } else if evt_in.code() == Key::BTN_DPAD_UP.0 {
            vec!(self.key2key(evt_in, Key::KEY_UP))
        } else if evt_in.code() == Key::BTN_DPAD_DOWN.0 {
            vec!(self.key2key(evt_in, Key::KEY_DOWN))
        } else if evt_in.code() == Key::BTN_DPAD_LEFT.0 {
            vec!(self.key2key(evt_in, Key::KEY_LEFT))
        } else if evt_in.code() == Key::BTN_DPAD_RIGHT.0 {
            vec!(self.key2key(evt_in, Key::KEY_RIGHT))
        } else if evt_in.code() == Key::BTN_TRIGGER_HAPPY1.0 {
            vec!(self.key2key(evt_in, Key::KEY_LEFTSHIFT))
        } else if evt_in.code() == Key::BTN_TRIGGER_HAPPY3.0 {
            vec!(self.key2key(evt_in, Key::KEY_LEFTCTRL))
        } else if evt_in.code() == Key::BTN_TRIGGER_HAPPY2.0 {
            vec!(self.key2key(evt_in, Key::KEY_RIGHTALT))
        } else if evt_in.code() == Key::BTN_TRIGGER_HAPPY4.0 {
            vec!(self.key2key(evt_in, Key::KEY_LEFTALT))
        } else if evt_in.code() == Key::BTN_SELECT.0 {
            vec!(self.key2key(evt_in, Key::KEY_TAB))
        } else if evt_in.code() == Key::BTN_START.0 {
            vec!(self.key2key(evt_in, Key::KEY_COMPOSE))
        } else if evt_in.code() == Abs::ABS_HAT1X.0 {
            vec!(self.hat2rel(evt_in, Rel::REL_X, 0.005))
        } else if evt_in.code() == Abs::ABS_HAT1Y.0 {
            vec!(self.hat2rel(evt_in, Rel::REL_Y, -0.005))
        } else if evt_in.code() == Abs::ABS_Y.0 {
            self.joy2keys(evt_in, Key::KEY_PAGEUP, Key::KEY_PAGEDOWN)
        } else if evt_in.code() == Abs::ABS_X.0 {
            self.joy2keys(evt_in, Key::KEY_HOME, Key::KEY_END)
        } else if evt_in.code() == Key::BTN_SOUTH.0 {
            self.key2vkbd(evt_in, 0, Key::KEY_ENTER)
        } else if evt_in.code() == Key::BTN_EAST.0 {
            self.key2vkbd(evt_in, 1, Key::KEY_ESC)
        } else if evt_in.code() == Key::BTN_NORTH.0 {
            self.key2vkbd(evt_in, 2, Key::KEY_BACKSPACE)
        } else if evt_in.code() == Key::BTN_WEST.0 {
            self.key2vkbd(evt_in, 3, Key::KEY_SPACE)
        } else {
            vec!()
        }
    }

    pub fn run(&mut self) -> std::io::Result<()> {
        loop {
            self.cache_in = self.dev_in.cached_state().clone();
            if self.cache_in.key_vals().unwrap().iter()
                   .eq([Key::BTN_BASE, Key::BTN_MODE]) {
                self.kbd_mode = !self.kbd_mode;
                if self.kbd_mode {
                    self.dev_in.grab()?;
                } else {
                    self.dev_in.ungrab()?;
                }
            }

            let events: Vec<InputEvent> = self.dev_in.fetch_events()?.collect();
            for evt_in in events {
                if self.kbd_mode {
                    self.dev_keyboard.emit(&self.kbd_map(evt_in))?;
                }
            }
        }
    }
}

fn main() -> std::io::Result<()> {
    let mut sdmapd = Sdmapd::new()?;
    sdmapd.run()?;
    Ok(())
}
