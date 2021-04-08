#!/usr/bin/env -S blender --factory-startup --python

import bpy

# Set startup file (startup.blend)
for data_type in (bpy.data.actions, bpy.data.cameras, bpy.data.lights,
                  bpy.data.meshes, bpy.data.objects, bpy.data.collections):
    for item in data_type: data_type.remove(item)
bpy.ops.wm.save_homefile()

# Set user preferences (userpref.blend)
bpy.context.preferences.view.show_splash = False
bpy.context.preferences.view.show_tooltips_python = True
bpy.context.preferences.view.show_developer_ui = True
bpy.context.preferences.view.show_statusbar_memory = True
bpy.context.preferences.view.show_statusbar_stats = True
bpy.context.preferences.inputs.use_auto_perspective = False

## UI required (--background flag won't work)
bpykc = bpy.context.window_manager.keyconfigs['blender']
bpykc.preferences.use_select_all_toggle = True
bpykc.preferences.spacebar_action = 'SEARCH'

## Addons
bpy.ops.preferences.addon_enable(module = 'mesh_f2')

## Save
bpy.ops.wm.save_userpref()

bpy.ops.wm.quit_blender()
