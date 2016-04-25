local machines = {}

machines.list = {
    d200 = {
        machine_name = "Discovery200",
        machine_type = "Dagoma",
        machine_width = 200,
        machine_depth = 200,
        machine_height = 200,
        machine_center_is_zero = "False",
        machine_shape = "Square",
        ultimaker_extruder_upgrade = "False",
        has_heated_bed = "False",
        gcode_flavor = "RepRap (Marlin/Sprinter)",
        extruder_amount = 1,
        steps_per_e = 0,
        
        serial_port = "AUTO",
        serial_port_auto = "",
        serial_baud = "AUTO",
        serial_baud_auto = "",
        
        extruder_head_size_min_x = 15,
        extruder_head_size_min_y = 40,
        extruder_head_size_max_x = 15,
        extruder_head_size_max_y = 115,
        extruder_head_size_height = 35,
        
        -- printing surface offset + extruder offset
        -- positive value lowers head
        extruder_head_offset_z = 0.75 + 1.85
    }
}

machines.list.d200.alterations = {
    ["start.gcode"] = [[
    
    G90  ; absolute positioning
    M107 ; fan off
    M82  ; extruder absolute mode
    G28  ; home
    G29  ; Z-Probe
    
    G28 Z  ; home Z
    G92 Z]] .. machines.list.d200.extruder_head_offset_z .. [[ ; offset
    
    G1 X100 Y190 Z5           ; move nozzle close to bed
    M109 S{print_temperature} ; heat
    G92 E0                    ; zero the extruded length
    G1 E1                     ; extrude filament
    G92 E0                    ; zero the extruded length

    G1 F{travel_speed} ; set travel speed]],
    
    ["end.gcode"] = [[
    
    M104 S0         ; extruder heater off
    M106 S255       ; fan full power
    G1 X10 Y190 Z10 ; move head
    G4 P300000      ; wait 5m
    M908            ; stop fan
    M84             ; shut down motors]],
    
    ["support_start.gcode"] = "",
    ["support_end.gcode"] = "",
    ["cool_start.gcode"] = "",
    ["cool_end.gcode"] = "",
    ["replace.csv"] = "",
    ["preswitchextruder.gcode"] = "",
    ["postswitchextruder.gcode"] = ""
}

function machines.toString()
    local str = "machines: "
    for k in pairs(machines.list) do str = str .. k .. " " end
    str = str .. "\n"
    
    return str
end

return machines
