#!/usr/bin/lua

local ALL_TAGS = { "obside", "cli", "gui" }

-- Prints the help message.
function printHelp()
    local help =
        "usage: " .. arg[0] .. " <command> [<tags>]\n\n" ..
        "The available commands are:\n" ..
        "install\t\t" .. "Install configuration files related to <tags>\n" ..
        "Remove\t\t" .. "Remove configuration files related to <tags>\n\n" ..
        "Tags are categories of configuration files. The available tags " ..
        "are:\n"
    
    for _,tag in ipairs(ALL_TAGS) do
        help = help .. tag .. " "
    end
    
    print(help)
end

-- Retrieves tags from the cli.
function parseTags()
    tags = {}
    
    for k,tag in ipairs(arg) do
        if (k ~= 1) then
            table.insert(tags, tag)
        end
    end
    
    return tags
end

-- Executes a script related to the given `tags`.
function exec(cmd, tags)
    for _,tag in ipairs(tags) do
        os.execute(tag .. "/" .. cmd .. ".sh")
    end
end

-- Main
if (#arg < 1) then
    printHelp()
    os.exit(1)
end

-- Parse tags. If no tags are specified, retrieve all tags.
local tags
if (#arg < 2) then
    tags = ALL_TAGS
else
    tags = parseTags()
end

-- Execute command
if (arg[1] == "install") then
    exec("install", tags)
elseif (arg[1] == "remove") then
    exec("remove", tags)
else
    printHelp()
    os.exit(1)
end
