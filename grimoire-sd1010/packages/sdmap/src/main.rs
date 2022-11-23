use evdev::{uinput, Key};

fn main() -> std::io::Result<()> {
    let path_in = "/dev/input/by-id/usb-Valve_Software_Steam_Controller_123456789ABCDEF-if02-event-joystick";
    let mut dev_in = evdev::Device::open(path_in)?;
    dev_in.grab()?;

    let mut kbd_mode = true;

    let mut dev_gamepad = uinput::VirtualDeviceBuilder::new()?
        .name("Steam Deck sdmapd gamepad")
        .with_keys(&dev_in.supported_keys().unwrap())?
        .build()?;

    loop {
        if let Some(cached_keys) = dev_in.cached_state().key_vals() {
            println!("{:?}", cached_keys); // DEBUG
            if cached_keys.iter().eq([Key::BTN_BASE, Key::BTN_MODE]) {
                kbd_mode = !kbd_mode;
            }
        }
        for evt_in in dev_in.fetch_events()? {
            if kbd_mode {
                    println!("KEYBOARD {:?}", evt_in); // DEBUG
            } else {
                    println!("GAMEPAD {:?}", evt_in); // DEBUG
                    dev_gamepad.emit(&[evt_in])?;
            }
        }
    }
}

