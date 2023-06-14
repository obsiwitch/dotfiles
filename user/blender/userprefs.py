#!/usr/bin/env -S blender --factory-startup --python

import bpy

# Save factory startup (startup.blend)
bpy.ops.wm.save_homefile()

# Set general preferences
bpy.ops.script.execute_preset(
    filepath=f"/usr/share/blender/{bpy.app.version_string.rpartition('.')[0]}"
            + "/scripts/presets/interface_theme/Blender_Light.xml",
    menu_idname="USERPREF_MT_interface_theme_presets"
) # default: Blender_Dark.xml
BCP = bpy.context.preferences
BCP.view.ui_scale = 1.7 # default: 1.0
BCP.view.show_splash = False
BCP.view.show_tooltips_python = True
BCP.view.show_developer_ui = True
BCP.view.show_statusbar_memory = True
BCP.view.show_statusbar_stats = True
BCP.inputs.use_auto_perspective = False
BCP.inputs.use_emulate_numpad = True
BCP.filepaths.save_version = 0 # default: 1
BCP.edit.undo_steps = 256 # default: 32
BCP.filepaths.use_load_ui = False

# Set keybindings (UI required, --background flag won't work)
BCWMKC = bpy.context.window_manager.keyconfigs[0]
BCWMKC.preferences.use_select_all_toggle = True

# Enable addons
BOP = bpy.ops.preferences
BOP.addon_enable(module = 'mesh_f2')
BOP.addon_enable(module = 'mesh_looptools')
BOP.addon_enable(module = 'measureit')
BOP.addon_enable(module = 'obsi_script_utils')

# Save preferences (userpref.blend)
bpy.ops.wm.save_userpref()

# Close window
bpy.ops.wm.quit_blender()
