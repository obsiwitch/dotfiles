from libevdev import EV_KEY as K

LAYOUT = [
    [[K.KEY_F1,        K.KEY_F2,  K.KEY_F3,    K.KEY_F4, K.KEY_F5,],
     [K.KEY_1,         K.KEY_2,   K.KEY_3,     K.KEY_4,  K.KEY_5, ],
     [K.KEY_Q,         K.KEY_W,   K.KEY_E,     K.KEY_R,  K.KEY_T, ],
     [K.KEY_A,         K.KEY_S,   K.KEY_D,     K.KEY_F,  K.KEY_G, ],
     [K.KEY_Z,         K.KEY_X,   K.KEY_C,     K.KEY_V,  K.KEY_B, ],],

    [[K.KEY_F10,       K.KEY_F9,  K.KEY_F8,    K.KEY_F7, K.KEY_F6,],
     [K.KEY_0,         K.KEY_9,   K.KEY_8,     K.KEY_7,  K.KEY_6, ],
     [K.KEY_P,         K.KEY_O,   K.KEY_I,     K.KEY_U,  K.KEY_Y, ],
     [K.KEY_SEMICOLON, K.KEY_L,   K.KEY_K,     K.KEY_J,  K.KEY_H, ],
     [K.KEY_SLASH,     K.KEY_DOT, K.KEY_COMMA, K.KEY_M,  K.KEY_N, ],],

    [[K.KEY_PAUSE, K.KEY_SCROLLLOCK, K.KEY_SYSRQ, K.KEY_F12,        K.KEY_F11,       ],
     [None,        None,             None,        K.KEY_EQUAL,      K.KEY_MINUS,     ],
     [None,        None,             None,        K.KEY_RIGHTBRACE, K.KEY_LEFTBRACE, ],
     [None,        None,             None,        K.KEY_BACKSLASH,  K.KEY_APOSTROPHE,],
     [None,        None,             None,        None,             K.KEY_GRAVE,     ],],

    [[None, None, None, None, None,],
     [None, None, None, None, None,],
     [None, None, None, None, None,],
     [None, None, None, None, None,],
     [None, None, None, None, None,],],
]
