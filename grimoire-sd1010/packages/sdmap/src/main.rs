use evdev::{uinput, InputEvent, AbsoluteAxisType as Abs, RelativeAxisType as Rel,
            Key, DeviceState, EventType};
use libc::input_absinfo;

// Virtual keyboard layout. Unused key slots should be mapped to KEY_UNKNOWN.
const VKBD_LAYOUT: [[[Key; 4]; 3]; 5] = [
    [[Key::KEY_F1, Key::KEY_F2, Key::KEY_F3, Key::KEY_F4],
     [Key::KEY_F5, Key::KEY_F6, Key::KEY_F7, Key::KEY_F8],
     [Key::KEY_F9, Key::KEY_SYSRQ, Key::KEY_SCROLLLOCK, Key::KEY_PAUSE]],
    [[Key::KEY_1, Key::KEY_2, Key::KEY_3, Key::KEY_4],
     [Key::KEY_5, Key::KEY_6, Key::KEY_7, Key::KEY_8],
     [Key::KEY_9, Key::KEY_0, Key::KEY_MINUS, Key::KEY_EQUAL]],
    [[Key::KEY_Q, Key::KEY_W, Key::KEY_E, Key::KEY_R],
     [Key::KEY_T, Key::KEY_Y, Key::KEY_U, Key::KEY_I],
     [Key::KEY_O, Key::KEY_P, Key::KEY_LEFTBRACE, Key::KEY_RIGHTBRACE]],
    [[Key::KEY_A, Key::KEY_S, Key::KEY_D, Key::KEY_F],
     [Key::KEY_G, Key::KEY_H, Key::KEY_J, Key::KEY_K],
     [Key::KEY_L, Key::KEY_SEMICOLON, Key::KEY_APOSTROPHE, Key::KEY_BACKSLASH]],
    [[Key::KEY_Z, Key::KEY_X, Key::KEY_C, Key::KEY_V],
     [Key::KEY_B, Key::KEY_N, Key::KEY_M, Key::KEY_COMMA],
     [Key::KEY_DOT, Key::KEY_SLASH, Key::KEY_GRAVE, Key::KEY_102ND]],
];

// Map a key event to another key.
fn key2key(evt_in: InputEvent, key: Key) -> InputEvent {
    return InputEvent::new(EventType::KEY, key.0, evt_in.value());
}

// Map an absolute event (hat) to a relative one.
fn hat2rel(cache: &DeviceState, evt_in: InputEvent, rel: Rel, coeff: f32)
-> InputEvent
{
    let absvals = cache.abs_vals().unwrap()[evt_in.code() as usize];
    let delta = if evt_in.value() == 0 || absvals.value == 0 {
        0.0
    } else {
        (evt_in.value() - absvals.value) as f32 * coeff
    } as i32;
    return InputEvent::new(EventType::RELATIVE, rel.0, delta);
}

// Map the minimum and maximum values of a joystick axis to the `key_min` and
// `key_max` key events.
fn joy2keys(absinfo: input_absinfo, evt_in: InputEvent, key_min: Key, key_max: Key)
-> Vec<InputEvent>
{
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

fn vkbd_keypos(absinfo: input_absinfo, absvals: &[input_absinfo])
-> (usize, usize)
{
    let y = (
        (absvals[Abs::ABS_HAT0Y.0 as usize].value - absinfo.maximum).abs()
        * VKBD_LAYOUT.len() as i32
    ) / ((absinfo.maximum * 2) + 1);
    let x = (
        (absvals[Abs::ABS_HAT0X.0 as usize].value + absinfo.maximum)
        * VKBD_LAYOUT[0].len() as i32
    ) / ((absinfo.maximum * 2) + 1);
    return (x as usize, y as usize);
}

// Map a physical key to a key of the virtual keyboard depending on the current
// value of ABS_HAT0{X,Y}. If ABS_HAT0{X,Y} == (0, 0), send the `fallback_key`.
fn key2vkbd(absinfo: input_absinfo, cache: &DeviceState, evt_in: InputEvent,
            ki: usize, fallback_key: Key) -> Vec<InputEvent>
{
    let abs_vals = cache.abs_vals().unwrap();
    if evt_in.value() != 1 {
        return vec!();
    } else if abs_vals[Abs::ABS_HAT0X.0 as usize].value != 0
           || abs_vals[Abs::ABS_HAT0Y.0 as usize].value != 0
    {
        let keypos = vkbd_keypos(absinfo, abs_vals);
        let key = VKBD_LAYOUT[keypos.1][keypos.0][ki];
        return vec!(InputEvent::new(EventType::KEY, key.0, 1),
                    InputEvent::new(EventType::KEY, key.0, 0));
    } else {
        return vec!(InputEvent::new(EventType::KEY, fallback_key.0, 1),
                    InputEvent::new(EventType::KEY, fallback_key.0, 0));
    }
}

fn kbd_map(absinfos: &[input_absinfo; 64], cache: &DeviceState, evt_in: InputEvent)
-> Vec<InputEvent>
{
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
        vec!(hat2rel(cache, evt_in, Rel::REL_X, 0.01))
    } else if evt_in.code() == Abs::ABS_HAT1Y.0 {
        vec!(hat2rel(cache, evt_in, Rel::REL_Y, -0.01))
    } else if evt_in.code() == Abs::ABS_Y.0 {
        let absinfo = absinfos[evt_in.code() as usize];
        joy2keys(absinfo, evt_in, Key::KEY_PAGEUP, Key::KEY_PAGEDOWN)
    } else if evt_in.code() == Abs::ABS_X.0 {
        let absinfo = absinfos[evt_in.code() as usize];
        joy2keys(absinfo, evt_in, Key::KEY_HOME, Key::KEY_END)
    } else if evt_in.code() == Key::BTN_SOUTH.0 {
        let absinfo = absinfos[Abs::ABS_HAT0X.0 as usize];
        key2vkbd(absinfo, cache, evt_in, 0, Key::KEY_ENTER)
    } else if evt_in.code() == Key::BTN_EAST.0 {
        let absinfo = absinfos[Abs::ABS_HAT0X.0 as usize];
        key2vkbd(absinfo, cache, evt_in, 1, Key::KEY_ESC)
    } else if evt_in.code() == Key::BTN_NORTH.0 {
        let absinfo = absinfos[Abs::ABS_HAT0X.0 as usize];
        key2vkbd(absinfo, cache, evt_in, 2, Key::KEY_BACKSPACE)
    } else if evt_in.code() == Key::BTN_WEST.0 {
        let absinfo = absinfos[Abs::ABS_HAT0X.0 as usize];
        key2vkbd(absinfo, cache, evt_in, 3, Key::KEY_SPACE)
    } else {
        vec!()
    }
}

fn main() -> std::io::Result<()> {
    let path_in = "/dev/input/by-id/usb-Valve_Software_Steam_Controller_123456789ABCDEF-if02-event-joystick";
    let mut dev_in = evdev::Device::open(path_in)?;
    dev_in.grab()?;
    let absinfos = dev_in.get_abs_state()?;

    let mut dev_keyboard = uinput::VirtualDeviceBuilder::new()?
        .name("Steam Deck sdmapd keyboard")
        .with_keys(&evdev::AttributeSet::from_iter(
            VKBD_LAYOUT.into_iter().flatten().flatten().chain([
            Key::BTN_RIGHT, Key::BTN_LEFT, Key::BTN_MIDDLE, Key::KEY_LEFTMETA,
            Key::KEY_UP, Key::KEY_DOWN, Key::KEY_LEFT, Key::KEY_RIGHT,
            Key::KEY_LEFTSHIFT, Key::KEY_LEFTCTRL, Key::KEY_RIGHTALT,
            Key::KEY_LEFTALT, Key::KEY_TAB, Key::KEY_COMPOSE, Key::KEY_PAGEUP,
            Key::KEY_PAGEDOWN, Key::KEY_HOME, Key::KEY_END, Key::KEY_ENTER,
            Key::KEY_ESC, Key::KEY_BACKSPACE, Key::KEY_SPACE
        ])))?
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
        if cache.key_vals().unwrap().iter().eq([Key::BTN_BASE, Key::BTN_MODE]) {
            kbd_mode = !kbd_mode;
            continue;
        }

        for evt_in in dev_in.fetch_events()? {
            if kbd_mode {
                dev_keyboard.emit(&kbd_map(&absinfos, &cache, evt_in))?;
            } else {
                dev_gamepad.emit(&[evt_in])?;
            }
        }
    }
}
