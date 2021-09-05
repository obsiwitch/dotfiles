#!/usr/bin/env -S blender --factory-startup --python

import bpy

# Set startup file (startup.blend)
bpy.ops.wm.save_homefile()

# Set user preferences (userpref.blend)
bpy.context.preferences.view.show_splash = False
bpy.context.preferences.view.show_tooltips_python = True
bpy.context.preferences.view.show_developer_ui = True
bpy.context.preferences.view.show_statusbar_memory = True
bpy.context.preferences.view.show_statusbar_stats = True
bpy.context.preferences.inputs.use_auto_perspective = False
bpy.context.preferences.filepaths.save_version = 0
bpy.context.preferences.filepaths.use_load_ui = False

## UI required (--background flag won't work)
bpykc = bpy.context.window_manager.keyconfigs[0]
bpykc.preferences.use_select_all_toggle = True
bpykc.preferences.spacebar_action = 'SEARCH'

## Addons
bpy.ops.preferences.addon_enable(module = 'mesh_f2')
bpy.ops.preferences.addon_enable(module = 'rigify')
bpy.ops.preferences.addon_enable(module = 'obsi_script_utils')

## Save
bpy.ops.wm.save_userpref()

# Close window
bpy.ops.wm.quit_blender()
