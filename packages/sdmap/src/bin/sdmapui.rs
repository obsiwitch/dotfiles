use std::{fs, path::Path};
use anyhow::Result;
use evdev::{*, AbsoluteAxisType as Abs};
use glob::glob;
use xkbcommon::xkb;
use sdmap::VKBD_LAYOUT;

struct VkbdState { state: xkb::State }
impl VkbdState {
    const EVDEV_OFFSET: u32 = 8;

    pub fn new() -> Self {
        let ctx = xkb::Context::new(0);
        let keymap = xkb::Keymap::new_from_names(&ctx, "", "", "fr", "", None, 0).unwrap();
        Self { state: xkb::State::new(&keymap) }
    }

    fn set_mods(&mut self, mods: &[Key], enable: bool) {
        for keymod in mods {
            self.state.update_key(
                keymod.0 as u32 + Self::EVDEV_OFFSET,
                if enable { xkb::KeyDirection::Down }
                else { xkb::KeyDirection::Up },
            );
        }
    }

    fn keystring(&mut self, evkey: Key, mods: &[Key]) -> String {
        if evkey == Key::KEY_UNKNOWN {
            return "".into();
        }

        self.set_mods(mods, true);
        let mut result = self.state.key_get_utf8(evkey.0 as u32 + Self::EVDEV_OFFSET);
        if result.is_empty() {
            let keysym = self.state.key_get_one_sym(evkey.0 as u32 + Self::EVDEV_OFFSET);
            result = xkb::keysym_get_name(keysym);
        }
        self.set_mods(mods, false);

        match result.as_str() {
            "Pause"           => "Br",
            "Scroll_Lock"     => "SL",
            "Print"           => "PS",
            "dead_circumflex" => "^",
            "dead_acute"      => "´",
            "dead_grave"      => "`",
            "dead_diaeresis"  => "¨",
            "dead_belowdot" | "dead_hook" => "",
            result => result,
        }.into()
    }

    fn kbdstring(&mut self, mods: &[Key]) -> String {
        let mut result: String = "".into();
        for row in VKBD_LAYOUT {
            for col in row {
                for key in col {
                    result.push_str(&self.keystring(key, mods));
                    result.push(' ');
                }
                result.push('|');
            }
            result.push('\n');
        }
        result
    }
}

fn dev_sdmapd_keyboard() -> Result<Device> {
    let mut event_kbd = glob("/sys/devices/virtual/input/*/name")?
        .map(|f| f.unwrap())
        .find(|f| fs::read_to_string(f).unwrap() == "Steam Deck sdmapd keyboard\n")
        .unwrap();
    event_kbd.pop();
    event_kbd.push("event*");
    let event_kbd = glob(event_kbd.to_str().unwrap())?
        .next().unwrap()?;
    let event_kbd = event_kbd.file_name().unwrap();
    let path_kbd = Path::new("/dev/input/").join(event_kbd);
    Ok(Device::open(path_kbd)?)
}

fn main() -> Result<()> {
    let mut vkbd = VkbdState::new();

    let mut dev_kbd = dev_sdmapd_keyboard()?;
    let abs_x = Abs::ABS_HAT0X;
    let abs_y = Abs::ABS_HAT0Y;
    loop {
        let cache_in = dev_kbd.cached_state().clone();
        let absvals = cache_in.abs_vals().unwrap();
        for event in dev_kbd.fetch_events()? {
            let vkbd_x = if event.code() == abs_x.0 { event.value() }
                       else { absvals[abs_x.0 as usize].value };
            let vkbd_y = if event.code() == abs_y.0 { event.value() }
                       else { absvals[abs_y.0 as usize].value };
            println!("{},{} {}", vkbd_x, vkbd_y, vkbd.kbdstring(&[]));
        }
    }

}
