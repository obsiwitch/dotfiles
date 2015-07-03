#!/usr/bin/lua

local json = require("cjson")

local conf = {
    bg_title = "#282828",
    fg_title = "#D6D6D6",
    bg = "#D6D6D6",
    fg = "#282828",
    width = 200,
    font = "-*-fixed-*-*-*-*-12-*-*-*-*-*-*-*"
}

local actions = {
    { name = "restart i3 (1)", key="key_1", cmd = "i3-msg restart" },
    { name = "sleep (2)", key="key_2", cmd = "xflock4:systemctl suspend" },
    { name = "hibernate (3)", key="key_3", cmd = "xflock4:systemctl hibernate" },
    { name = "logout (4)", key="key_4", cmd = "i3-msg exit" },
    { name = "restart (5)", key="key_5", cmd = "systemctl reboot" },
    { name = "shutdown (6)", key="key_6", cmd = "systemctl poweroff" },
}

function get_current_workspace_rect()
    local cmd_out = io.popen("i3-msg -t get_workspaces")
    local jsonWorkspaces = cmd_out:read("*l")
    local workspaces = json.decode(jsonWorkspaces)
    
    for _,ws in pairs(workspaces) do
        if ws.focused and ws.visible then
            return ws.rect
        end
    end
end

-- place dialog at the center of the current workspace
function get_dialog_position()
    local ws_rect = get_current_workspace_rect()
    
    return {
        x = ws_rect.x + ws_rect.width/2 - conf.width/2,
        y = ws_rect.y + ws_rect.height/2 - conf.width/2,
    }
end

-- List of events handled by dzen2. Filled with entries from the actions table.
function get_events()
    local events = {
        "onstart=uncollapse,grabkeys", -- uncollapsed menu, grab keys
        "key_Escape=exit"
    }
    
    for _,action in pairs(actions) do
        table.insert(events, action.key .. "=exec:" .. action.cmd .. ",exit")
    end
    
    return events
end

function get_dialog_title()
    return "^fg(" .. conf.fg_title .. ")^bg(" .. conf.bg_title .. ")" ..
           "Shutdown options" ..
           "^fg()^bg()\n"
end

-- Text to display inside the dialog
function get_dialog_msg()
    local action_names = {}
    for _,action in pairs(actions) do
        table.insert(action_names, action.name)
    end
    
    return table.concat(action_names, "\n")
end

-- Command to display the dialog
function get_dialog_cmd()
    local events_str = table.concat(get_events(), ";")
    local pos = get_dialog_position()
    
    local cmd_args = {
        "-p", -- persist EOF
        "-l " .. #actions, -- number of lines in the dialog
        "-x " .. pos.x,
        "-y " .. pos.y,
        "-w " .. conf.width,
        "-sa c", -- alignment of slave window
        "-fn '" .. conf.font .. "'", -- font
        "-bg '" .. conf.bg .. "'",
        "-fg '" .. conf.fg .. "'",
        "-e '" .. events_str .. "'"
    }
    local cmd_args_str = table.concat(cmd_args, " ")
    
    return "dzen2 " .. cmd_args_str
end

-- Display the dialog
function display_dialog()
    local cmd = "echo '" .. get_dialog_title() .. get_dialog_msg() .. "'" ..
                "|" .. get_dialog_cmd()
    
    os.execute(cmd)
end

display_dialog()
