import bpy


class HPMSTriggerDataPanel(bpy.types.Panel):
    """Creates a HPMS Trigger utils panel in the Object properties window"""
    bl_label = "HPMS Trigger"
    bl_idname = "object.hpmstrigger"
    bl_space_type = 'PROPERTIES'
    bl_region_type = 'WINDOW'
    bl_context = "object"

    @classmethod
    def poll(cls, context):
        return context.object.type == 'MESH'

    def draw(self, context):
        layout = self.layout
        row = layout.row()
        row.prop(context.object.hpms_trigger_obj_prop, "trigger")
        obj = context.object
        if obj.hpms_trigger_obj_prop.trigger:
            self.draw_data(context)
        else:
            layout.label(text="Enable to define HPMS trigger")

    def draw_data(self, context):

        layout = self.layout
        layout.label(text="Trigger enabled")


class HPMSTriggerObjectProperties(bpy.types.PropertyGroup):
    """Group of properties representing a trigger configuration."""
    trigger: bpy.props.BoolProperty(
        name="Activate HPMS Trigger",
        description="Toggle for mark this object as HPMS trigger")


classes = (
    HPMSTriggerObjectProperties,
    HPMSTriggerDataPanel
)


def register():
    for cls in classes:
        bpy.utils.register_class(cls)
    bpy.types.Object.hpms_trigger_obj_prop = bpy.props.PointerProperty(type=HPMSTriggerDataPanel)


def unregister():
    del bpy.types.Object.hpms_trigger_obj_prop

    for cls in reversed(classes):
        bpy.utils.unregister_class(cls)
