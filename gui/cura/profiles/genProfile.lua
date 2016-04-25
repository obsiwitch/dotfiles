#!/usr/bin/lua

local pl = {
    file = require("pl.file"),
    pretty = require("pl.pretty")
}

local machines = require("machines")
local profiles = require("profiles")
local filaments = require("filaments")

-- Returns a string with the keys and values stored in `table`.
-- The `title` variable is appended at the beginning of the string.
local function tableToString(title, table)
    local str = "[" .. title .. "]\n"
    
    for k,v in pairs(table) do
        if type(v) ~= "table" then
            str = str .. k .. " = " .. v .. "\n"
        end
    end
    
    return str
end

-- Generates a profile and outputs it to the specified file name `out`.
local function generateProfile(machine, profile, out)
    local alterations = machine.alterations
    local str = tableToString("machine", machine) .. "\n"
             .. tableToString("profile", profile) .. "\n"
             .. tableToString("alterations", machine.alterations) .. "\n"
    
    pl.file.write(out, str)
end

local notEnoughArgsErr = (#arg < 4)
local machineDoesNotExistErr = not machines.list[arg[1]]
local profileDoesNotExistErr = not profiles.list[arg[2]]
local filamentDoesNotExistErr = not filaments.list[arg[3]]

if notEnoughArgsErr or machineDoesNotExistErr or
   profileDoesNotExistErr or filamentDoesNotExistErr
then
    print("Usage: " .. arg[0] .. " machine profile filament out\n")
    
    print(machines.toString())
    print(profiles.toString())
    print(filaments.toString())
    
    os.exit()
end


generateProfile(
    machines.list[arg[1]],
    profiles.get(
        profiles.list[arg[2]],
        filaments.list[arg[3]]
    ),
    arg[4]
)
