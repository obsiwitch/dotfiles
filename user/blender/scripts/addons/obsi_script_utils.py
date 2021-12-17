import sys, bpy
from pathlib import Path
from pprint import pprint

bl_info = {
    "name": "Script Utilities",
    "author": "Obsidienne",
    "blender": (2, 80, 0),
    "category": "Development",
}
keymaps = []

# Monkey patch Mesh.__repr__ to be more verbose (dump vertices, edges and faces).
mesh_repr_old = bpy.types.Mesh.__repr__
def mesh_repr_new(mesh):
    return mesh_repr_old(mesh) \
         + f"\nvertices={[ tuple(v.co) for v in mesh.vertices ]}" \
         + f"\nedges={[ tuple(e.vertices) for e in mesh.edges ]}" \
         + f"\nfaces={[ tuple(f.vertices) for f in mesh.polygons ]}"
bpy.types.Mesh.__repr__ = mesh_repr_new

# Reload and run script from anywhere in one operator.
class ScriptReloadRun(bpy.types.Operator):
    bl_idname = 'wm.script_reload_run'
    bl_label = 'Reload and run script'
    def execute(self, context):
        override = {}
        override['screen'] = bpy.data.screens['Scripting']
        override['area'] = next(area for area in override['screen'].areas
                                if area.type == 'TEXT_EDITOR')
        override['region'] = next(region for region in override['area'].regions
                                  if region.type == 'WINDOW')
        bpy.ops.text.reload(override)
        bpy.ops.text.run_script(override)
        return {"FINISHED"}

# Print content of bpy.context to stdout.
# ref: https://blender.stackexchange.com/a/215967
class PrintContext(bpy.types.Operator):
    bl_idname = 'ui.print_context'
    bl_label = "print context to stdout"
    def execute(self, context):
        pprint(context.copy())
        return {"FINISHED"}

def register():
    # add operators
    bpy.utils.register_class(ScriptReloadRun)
    bpy.utils.register_class(PrintContext)

    # add keymaps
    kc = bpy.context.window_manager.keyconfigs.addon
    km = kc.keymaps.new(name='Window', space_type='EMPTY')
    kmi = km.keymap_items.new('wm.script_reload_run', 'F5', 'PRESS')
    keymaps.append((km, kmi))

def unregister():
    # remove operators
    bpy.utils.unregister_class(ScriptReloadRun)
    bpy.utils.unregister_class(PrintContext)

    # remove keymaps
    for km, kmi in keymaps:
        km.keymap_items.remove(kmi)
    keymaps.clear()

if __name__ == "__main__":
    register()
