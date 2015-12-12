#!/usr/bin/lua

local conf = {
    normal_bg = "#282828",
    normal_fg = "#F8F8F2",
    selected_bg = "#D6D6D6",
    selected_fg = "#282828"
}

local actions = {
    ["1. reload"] = "i3-msg restart",
    ["2. sleep"] = "systemctl suspend;xflock4",
    ["3. hibernate"] = "systemctl hibernate;xflock4",
    ["4. logout"] = "i3-msg exit",
    ["5. restart"] = "systemctl reboot",
    ["6. shutdown"] = "systemctl poweroff",
}

function get_menu_choices()
    local action_names = {}
    for name,_ in pairs(actions) do
        table.insert(action_names, name)
    end
    table.sort(action_names)
    
    return table.concat(action_names, "\n")
end

function get_menu_cmd()
    local cmd_args = {
        "-nb '" .. conf.normal_bg .. "'",
        "-nf '" .. conf.normal_fg .. "'",
        "-sb '" .. conf.selected_bg .. "'",
        "-sf '" .. conf.selected_fg .. "'"
    }
    local cmd_args_str = table.concat(cmd_args, " ")
    
    return "dmenu " .. cmd_args_str
end

-- Display the dialog
function display_menu()
    local cmd = io.popen("echo '" .. get_menu_choices() .. "'|" .. get_menu_cmd())
    local choice = cmd:read("*l")
    
    os.execute(actions[choice])
end

display_menu()
