import sys, bpy
from pathlib import Path

bl_info = {
    "name": "Script Reload & Run",
    "author": "Obsidienne",
    "blender": (2, 80, 0),
    "category": "Development",
}
keymaps = []

def dump(mesh):
    print(f"vertices={[ tuple(v.co) for v in mesh.vertices ]}")
    print(f"edges={[ tuple(e.vertices) for e in mesh.edges ]}")
    print(f"faces={[ tuple(f.vertices) for f in mesh.polygons ]}")

class ScriptReloadRun(bpy.types.Operator):
    bl_idname = 'text.reload_run'
    bl_label = 'Reload and run script'
    def execute(self, context):
        bpy.ops.text.reload()
        bpy.ops.text.run_script()
        return {"FINISHED"}

def register():
    # add operators
    bpy.utils.register_class(ScriptReloadRun)

    # add keymaps
    kc = bpy.context.window_manager.keyconfigs.addon
    km = kc.keymaps.new(name='Text', space_type='TEXT_EDITOR')
    kmi = km.keymap_items.new('text.reload_run', 'P', 'PRESS', alt=True)
    keymaps.append((km, kmi))

def unregister():
    # remove operators
    bpy.utils.unregister_class(ScriptReloadRun)

    # remove keymaps
    for km, kmi in keymaps:
        km.keymap_items.remove(kmi)
    keymaps.clear()

if __name__ == "__main__":
    register()
