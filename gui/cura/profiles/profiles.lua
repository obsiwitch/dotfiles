local profiles = {}

local general = {
    retraction_enable = "True",
    fill_density = 17,
    nozzle_size = 0.4,
    support = "None",
    platform_adhesion = "None",
    support_dual_extrusion = "Both",
    wipe_tower = "False",
    wipe_tower_volume = 15,
    ooze_shield = "False",
    retraction_speed = 50,
    retraction_amount = 4,
    retraction_dual_amount = 16.5,
    retraction_min_travel = 1.5,
    retraction_combing = "True",
    retraction_minimal_extrusion = 0.02,
    retraction_hop = 0,
    bottom_thickness = 0.26,
    layer0_width_factor = 100,
    object_sink = 0,
    overlap_dual = 0.15,
    bottom_layer_speed = 17,
    cool_min_layer_time = 10,
    fan_enabled = "True",
    skirt_line_count = 2,
    skirt_gap = 3,
    skirt_minimal_length = 150,
    fan_full_height = 0.5,
    fan_speed = 50,
    fan_speed_max = 100,
    cool_min_feedrate = 20,
    cool_head_lift = "False",
    solid_top = "True",
    solid_bottom = "True",
    fill_overlap = 25,
    support_type = "Lines",
    support_angle = 50,
    support_fill_rate = 15,
    support_xy_distance = 0.7,
    support_z_distance = 0.15,
    spiralize = "False",
    simple_mode = "False",
    brim_line_count = 10,
    raft_margin = 5,
    raft_line_spacing = 3,
    raft_base_thickness = 0.3,
    raft_base_linewidth = 1,
    raft_interface_thickness = 0.27,
    raft_interface_linewidth = 0.4,
    raft_airgap = 0.22,
    raft_surface_layers = 2,
    fix_horrible_union_all_type_a = "True",
    fix_horrible_union_all_type_b = "False",
    fix_horrible_use_open_bits = "False",
    fix_horrible_extensive_stitching = "False",
    plugin_config = "",
    object_center_x = -1,
    object_center_y = -1,
}

profiles.list = {
    fast = {
        layer_height = 0.2,
        wall_thickness = 0.8,
        solid_layer_thickness = 1,
        print_speed = 80,
        travel_speed = 150,
        infill_speed = 80,
        inset0_speed = 70,
        insetx_speed = 80,
        print_temperature_mod = 20
    },

    standard = {
        layer_height = 0.15,
        wall_thickness = 1.2,
        solid_layer_thickness = 1.05,
        print_speed = 45,
        travel_speed = 60,
        infill_speed = 50,
        inset0_speed = 40,
        insetx_speed = 45,
        print_temperature_mod = 15
    },

    slow = {
        layer_height = 0.1,
        wall_thickness = 1.2,
        solid_layer_thickness = 1,
        print_speed = 35,
        travel_speed = 60,
        infill_speed = 50,
        inset0_speed = 40,
        insetx_speed = 45,
        print_temperature_mod = 15
    }
}

function profiles.toString()
    local str = "profiles: "
    for k in pairs(profiles.list) do str = str .. k .. " " end
    str = str .. "\n"
    
    return str
end

function profiles.get(profile, filament)
    filament.print_temperature = filament.print_temperature
                               + profile.print_temperature_mod
    
    local completeProfile = {}
    
    for k,v in pairs(general) do completeProfile[k] = v end
    for k,v in pairs(profile) do completeProfile[k] = v end
    for k,v in pairs(filament) do completeProfile[k] = v end
    
    return completeProfile
end

return profiles
