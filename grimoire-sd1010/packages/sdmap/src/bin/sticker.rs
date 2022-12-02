use xkbcommon::xkb;
use evdev::Key;
use sdmap::VKBD_LAYOUT;

const EVDEV_OFFSET: u32 = 8;

fn keystring(state: &mut xkb::State, evkey: Key, mods: &[Key]) -> String {
    if evkey == Key::KEY_UNKNOWN {
        return "".into();
    }

    for keymod in mods {
        state.update_key(keymod.0 as u32 + EVDEV_OFFSET, xkb::KeyDirection::Down);
    }

    let mut result = state.key_get_utf8(evkey.0 as u32 + EVDEV_OFFSET);
    if result == "" {
        let keysym = state.key_get_one_sym(evkey.0 as u32 + EVDEV_OFFSET);
        result = xkb::keysym_get_name(keysym);
    }

    for keymod in mods {
        state.update_key(keymod.0 as u32 + EVDEV_OFFSET, xkb::KeyDirection::Up);
    }

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

fn keymods(state: &mut xkb::State, evkey: Key) -> String {
    let mut result = vec!();
    for mods in [vec!(), vec!(Key::KEY_LEFTSHIFT), vec!(Key::KEY_RIGHTALT)] {
        let ks = keystring(state, evkey, &mods);
        if !result.contains(&ks) {
            result.push(ks.clone());
        }
        if "abcdefghijklmnopqrstuvwxyz".contains(&ks) {
            break;
        }
    }
    return result.iter().enumerate().map(|(i, ks)|
        format!("<span class=\"l{}\">{}</span>", i, ks)
    ).collect::<Vec<String>>().join(" ");
}

fn main() {
    let ctx = xkb::Context::new(0);
    let keymap = xkb::Keymap::new_from_names(&ctx, "", "", "fr", "", None, 0).unwrap();
    let mut state = xkb::State::new(&keymap);

    println!(r#"<!DOCTYPE html><html><body>
        <style type="text/css">
        body {{font-family:monospace;}}
        table {{border-collapse: collapse; width:378px; height:378px;}}
        td {{border:1px solid #DDD;}}
        td .l0 {{font-size:24px;}}
        td .l1 {{font-size:24px;}}
        td .l2 {{font-size:24px;}}
        td.x {{border-width: 3px 1px 1px 3px;}}
        td.y {{border-width: 3px 3px 1px 1px;}}
        td.a {{border-width: 1px 1px 3px 3px;}}
        td.b {{border-width: 1px 3px 3px 1px;}}
        .a {{color:limegreen;}}
        .b {{color:crimson;}}
        .x {{color:dodgerblue;}}
        .y {{color:orange;}}
        </style>
        <table>"#);
    for row in VKBD_LAYOUT {
        println!("<tr class=\"top\">");
        for col in row {
             println!("<td class=\"x\">{}</td><td class=\"y\">{}</td>",
                      keymods(&mut state, col[2]), keymods(&mut state, col[3]));
        }
        println!("</tr><tr class=\"bottom\">");
        for col in row {
             println!("<td class=\"a\">{}</td><td class=\"b\">{}</td>",
                      keymods(&mut state, col[0]), keymods(&mut state, col[1]));
        }
        println!("</tr>");
    }
    println!("</table></body></html>");
}
