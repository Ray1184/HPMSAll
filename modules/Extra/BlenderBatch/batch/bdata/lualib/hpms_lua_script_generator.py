"""
HPMS Lua script generators.

"""

from hpms_lua_script_data import LuaScript, LuaField, LuaFieldType, LuaCallback, LuaMacroSection


class LuaScriptTemplate:
    def __init__(self):
        pass

    @staticmethod
    def generate_scene_template():
        script = LuaScript('SceneTemplate')
        script.add_section(LuaMacroSection('dependencies'))

        scene = LuaMacroSection('scene')
        scene.add_field(LuaField('name', 'SceneTemplate'))
        scene.add_field(LuaField('version', '1.0'))
        scene.add_field(LuaField('quit', 'false', LuaFieldType.BOOL))
        scene.add_field(LuaField('finished', 'false', LuaFieldType.BOOL))
        scene.add_field(LuaField('next', 'TBD'))
        scene.add_callback(LuaCallback('setup'))
        scene.add_callback(LuaCallback('input', ['keys', 'mouse_buttons', 'x', 'y']))
        scene.add_callback(LuaCallback('update', ['tpf']))
        scene.add_callback(LuaCallback('cleanup'))
        script.add_section(scene)

        return script
