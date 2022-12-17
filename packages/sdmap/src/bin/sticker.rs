use xkbcommon::xkb;
use evdev::Key;
use sdmap::VKBD_LAYOUT;

const EVDEV_OFFSET: u32 = 8;
const BUTTONS: [char; 6] = ['a', 'b', 'y', 'x', 's', 'd'];

struct Sticker { state: xkb::State }
impl Sticker {
    pub fn new() -> Self {
        let ctx = xkb::Context::new(0);
        let keymap = xkb::Keymap::new_from_names(&ctx, "", "", "fr", "", None, 0).unwrap();
        Self { state: xkb::State::new(&keymap) }
    }

    fn keymods(&mut self, mods: &[Key], enable: bool) {
        for keymod in mods {
            self.state.update_key(
                keymod.0 as u32 + EVDEV_OFFSET,
                if enable { xkb::KeyDirection::Down }
                else { xkb::KeyDirection::Up },
            );
        }
    }

    fn keystring(&mut self, evkey: Key, mods: &[Key]) -> String {
        if evkey == Key::KEY_UNKNOWN {
            return "".into();
        }

        self.keymods(mods, true);
        let mut result = self.state.key_get_utf8(evkey.0 as u32 + EVDEV_OFFSET);
        if result.is_empty() {
            let keysym = self.state.key_get_one_sym(evkey.0 as u32 + EVDEV_OFFSET);
            result = xkb::keysym_get_name(keysym);
        }
        self.keymods(mods, false);

        match result.as_str() {
            "dead_circumflex" => "^",
            "dead_acute"      => "´",
            "dead_grave"      => "`",
            "dead_diaeresis"  => "¨",
            "dead_belowdot"   => ".",
            result => result,
        }.into()
    }

    pub fn print_html(&mut self) {
        println!(r#"<!DOCTYPE html><html><body>
            <style type="text/css">
            body {{font-family:monospace; font-size:18px;}}
            table {{border-collapse: collapse; width:378px; height:378px;}}
            td {{border:1px solid #DDD; text-align: center;}}
            td.a {{border-width: 4px 1px 4px 4px; color:LimeGreen;}}
            td.b {{border-width: 4px 1px 4px 1px; color:Crimson;}}
            td.x {{border-width: 4px 1px 4px 1px; color:DodgerBlue;}}
            td.y {{border-width: 4px 1px 4px 1px; color:Orange;}}
            td.s {{border-width: 4px 1px 4px 1px; color:MediumPurple;}}
            td.d {{border-width: 4px 4px 4px 1px; color:SlateGray}}
            span.l0 {{font-size:30px; font-weight:bold;}}
            </style>
            <table>"#);
        for row in VKBD_LAYOUT {
            println!("<tr>");
            for col in row {
                for (i, key) in col.into_iter().enumerate() {
                    let btn = BUTTONS[i];
                    // TODO vertically align text
                    let l0 = self.keystring(key, &[]);
                    let print_mods = !"abcdefghijklmnopqrstuvwxyz".contains(&l0);
                    let l1 = if print_mods { self.keystring(key, &[Key::KEY_LEFTSHIFT]) }
                           else { "".into() };
                    let l2 = if print_mods { self.keystring(key, &[Key::KEY_RIGHTALT]) }
                           else { "".into() };
                    println!("<td class=\"{}\">{} <span class=\"l0\">{}</span> {}</td>",
                         btn, l1, l0, l2);
                }
            }
            println!("</tr>");
        }
        println!("</table></body></html>");
    }
}

fn main() {
    Sticker::new().print_html();
}
