#!/usr/bin/env python3

import bpy

# Reset
bpy.ops.wm.read_factory_settings()

# Set startup file
bpy.ops.object.select_all(action = 'SELECT')
bpy.ops.object.delete()
bpy.ops.wm.save_homefile()

# Preferences
bpy.context.preferences.view.show_tooltips_python = True
bpy.context.preferences.view.show_developer_ui = True
bpy.context.preferences.inputs.use_auto_perspective = False

# Addons
bpy.ops.preferences.addon_enable(module = 'mesh_f2')

# Save
bpy.ops.wm.save_userpref()
