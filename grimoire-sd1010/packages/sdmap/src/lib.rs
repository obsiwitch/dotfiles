use evdev::Key;

// Virtual keyboard layout. Unused key slots should be mapped to KEY_UNKNOWN.
pub const VKBD_LAYOUT: [[[Key; 4]; 3]; 5] = [
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
