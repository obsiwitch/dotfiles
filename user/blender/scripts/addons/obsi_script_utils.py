import sys, bpy
from pathlib import Path

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

# Reload and run script in one operator.
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
