use evdev::uinput;

fn main() -> std::io::Result<()> {
    let path_in = "/dev/input/by-id/usb-Valve_Software_Steam_Controller_123456789ABCDEF-if02-event-joystick";
    let mut dev_in = evdev::Device::open(path_in)?;
    dev_in.grab()?;

    let mut dev_gamepad = uinput::VirtualDeviceBuilder::new()?
        .name("Steam Deck sdmapd gamepad")
        .with_keys(&dev_in.supported_keys().unwrap())?
        .build()?;

    loop {
        for evt_in in dev_in.fetch_events()? {
            dev_gamepad.emit(&[evt_in])?;
        }
    }
}

