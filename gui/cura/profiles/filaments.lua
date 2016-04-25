local filaments = {}

filaments.list = {
    ["3Dmoniak_blue"] = {
        filament_diameter = 1.75,
        filament_flow = 100,
        print_temperature = 205.0,
        print_bed_temperature = 0
    }
}

function filaments.toString()
    local str = "filaments: "
    for k in pairs(filaments.list) do str = str .. k .. " " end
    str = str .. "\n"
    
    return str
end

return filaments
