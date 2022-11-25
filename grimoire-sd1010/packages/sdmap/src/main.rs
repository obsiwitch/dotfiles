use evdev::{uinput, InputEvent, AbsoluteAxisType as Abs, RelativeAxisType as Rel,
            Key, DeviceState, EventType, AbsInfo};

fn key2key(evt_in: InputEvent, key: Key) -> InputEvent {
    return InputEvent::new(EventType::KEY, key.0, evt_in.value());
}

fn hat2rel(cache: &DeviceState, evt_in: InputEvent, rel: Rel, coeff: f32)
-> InputEvent
{
    let past_absinfo = cache.abs_vals().unwrap()[evt_in.code() as usize];
    let delta = if evt_in.value() == 0 || past_absinfo.value == 0 {
        0.0
    } else {
        (evt_in.value() - past_absinfo.value) as f32 * coeff
    } as i32;
    return InputEvent::new(EventType::RELATIVE, rel.0, delta);
}

// map the minimum and maximum values of a joystick axis to the `key_min` and
// `key_max` events.
fn joy2keys(evt_in: InputEvent, absinfo: AbsInfo, key_min: Key, key_max: Key)
-> Vec<InputEvent>
{
    if evt_in.value().abs() <= absinfo.resolution() {
        vec!(InputEvent::new(EventType::KEY, key_min.0, 0),
             InputEvent::new(EventType::KEY, key_max.0, 0))
    } else if evt_in.value() == absinfo.minimum() {
        vec!(InputEvent::new(EventType::KEY, key_min.0, 1))
    } else if evt_in.value() == absinfo.maximum() {
        vec!(InputEvent::new(EventType::KEY, key_max.0, 1))
    } else {
        vec!()
    }
}

fn kbd_map(cache: &DeviceState, evt_in: InputEvent) -> Vec<InputEvent> {
    if evt_in.code() == Key::BTN_TL.0 {
        vec!(key2key(evt_in, Key::BTN_RIGHT))
    } else if evt_in.code() == Key::BTN_TR.0 {
        vec!(key2key(evt_in, Key::BTN_LEFT))
    } else if evt_in.code() == Key::BTN_TL2.0 {
        vec!(key2key(evt_in, Key::BTN_MIDDLE))
    } else if evt_in.code() == Key::BTN_TR2.0 {
        vec!(key2key(evt_in, Key::KEY_LEFTMETA))
    } else if evt_in.code() == Key::BTN_DPAD_UP.0 {
        vec!(key2key(evt_in, Key::KEY_UP))
    } else if evt_in.code() == Key::BTN_DPAD_DOWN.0 {
        vec!(key2key(evt_in, Key::KEY_DOWN))
    } else if evt_in.code() == Key::BTN_DPAD_LEFT.0 {
        vec!(key2key(evt_in, Key::KEY_LEFT))
    } else if evt_in.code() == Key::BTN_DPAD_RIGHT.0 {
        vec!(key2key(evt_in, Key::KEY_RIGHT))
    } else if evt_in.code() == Key::BTN_TRIGGER_HAPPY1.0 {
        vec!(key2key(evt_in, Key::KEY_LEFTSHIFT))
    } else if evt_in.code() == Key::BTN_TRIGGER_HAPPY3.0 {
        vec!(key2key(evt_in, Key::KEY_LEFTCTRL))
    } else if evt_in.code() == Key::BTN_TRIGGER_HAPPY2.0 {
        vec!(key2key(evt_in, Key::KEY_RIGHTALT))
    } else if evt_in.code() == Key::BTN_TRIGGER_HAPPY4.0 {
        vec!(key2key(evt_in, Key::KEY_LEFTALT))
    } else if evt_in.code() == Key::BTN_SELECT.0 {
        vec!(key2key(evt_in, Key::KEY_TAB))
    } else if evt_in.code() == Key::BTN_START.0 {
        vec!(key2key(evt_in, Key::KEY_COMPOSE))
    } else if evt_in.code() == Abs::ABS_HAT1X.0 {
        vec!(hat2rel(&cache, evt_in, Rel::REL_X, 0.01))
    } else if evt_in.code() == Abs::ABS_HAT1Y.0 {
        vec!(hat2rel(&cache, evt_in, Rel::REL_Y, -0.01))
    } else if evt_in.code() == Abs::ABS_Y.0 {
        joy2keys(evt_in, AbsInfo::new(0, -32767, 32767, 0, 0, 6553),
                 Key::KEY_PAGEUP, Key::KEY_PAGEDOWN)
    } else if evt_in.code() == Abs::ABS_X.0 {
        joy2keys(evt_in, AbsInfo::new(0, -32767, 32767, 0, 0, 6553),
                 Key::KEY_HOME, Key::KEY_END)
    } else {
        vec!()
    }
}

fn main() -> std::io::Result<()> {
    let path_in = "/dev/input/by-id/usb-Valve_Software_Steam_Controller_123456789ABCDEF-if02-event-joystick";
    let mut dev_in = evdev::Device::open(path_in)?;
    dev_in.grab()?;

    let mut dev_keyboard = uinput::VirtualDeviceBuilder::new()?
        .name("Steam Deck sdmapd keyboard")
        .with_keys(&evdev::AttributeSet::from_iter([
            Key::BTN_RIGHT, Key::BTN_LEFT, Key::BTN_MIDDLE, Key::KEY_LEFTMETA,
            Key::KEY_UP, Key::KEY_DOWN, Key::KEY_LEFT, Key::KEY_RIGHT,
            Key::KEY_LEFTSHIFT, Key::KEY_LEFTCTRL, Key::KEY_RIGHTALT,
            Key::KEY_LEFTALT, Key::KEY_TAB, Key::KEY_COMPOSE, Key::KEY_PAGEUP,
            Key::KEY_PAGEDOWN, Key::KEY_HOME, Key::KEY_END,
        ]))?
        .with_relative_axes(&evdev::AttributeSet::from_iter([
            Rel::REL_X, Rel::REL_Y
        ]))?
        .build()?;


    let mut dev_gamepad = uinput::VirtualDeviceBuilder::new()?
        .name("Steam Deck sdmapd gamepad")
        .with_keys(dev_in.supported_keys().unwrap())?
        .build()?;

    let mut kbd_mode = true;

    loop {
        let cache: DeviceState = dev_in.cached_state().clone();
        let new_events: Vec<InputEvent> = dev_in.fetch_events()?.collect();

        if cache.key_vals().unwrap().iter().eq([Key::BTN_BASE, Key::BTN_MODE]) {
            kbd_mode = !kbd_mode;
            continue;
        }

        for evt_in in new_events {
            if kbd_mode {
                dev_keyboard.emit(&kbd_map(&cache, evt_in))?;
            } else {
                dev_gamepad.emit(&[evt_in])?;
            }
        }
    }
}
