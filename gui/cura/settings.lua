local dagoma = {
    name = "D200",
    
    machine_depth = 200,
    machine_height = 200,
    machine_nozzle_size = 0.4,
    machine_head_with_fans_polygon = {
        {-15, 115},
        {-15, -40},
        {15, 115},
        {15, -40}
    },
    gantry_height = 35,
    machine_width = 200,
    
    startGcode = [[
        G90 ; absolute positioning
    	M107 ; fan off
    	M82 ; extruder absolute mode
    	G28 ; home
    	G29 ; Z-Probe
    	
    	G28 Z ; home Z
    	G92 Z1.42 ; offset
    	
    	G1 X100 Y190 Z5 ; move nozzle close to bed
    	M109 S225 ; {print_temperature}
    	G92 E0 ; zero the extruded length
    	G1 E1 ; extrude filament
    	G92 E0 ; zero the extruded length
    	
    	G1 F150 ; set {travel_speed}
    ]],
    endGcode = [[
        M104 S0 ; extruder heater off
        M106 S255 ; fan full power
        G1 X10 Y190 Z10 ; move head
        G4 P300000 ; wait 5m
        M908 ; stop fan
        M84 ; shut down motors
    ]]
}

local general = {
    material_print_temperature = 225,
    material_diameter = 1.75,
    
    retraction_speed = 50,
    retraction_hop_enabled = True,
    
    cool_fan_speed_min = 75.0
}

return {
    dagoma = dagoma,
    general = general
}
