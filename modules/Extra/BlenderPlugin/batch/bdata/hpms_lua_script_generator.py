"""
HPMS Lua script generators.

"""
import hpms_lua_script_data
import re
from hpms_lua_script_data import LuaScript, LuaField, LuaFieldType, LuaCallback, LuaMacroSection, LuaUserCode


class LuaScriptTemplate:
    def __init__(self):
        pass

    def restore_template_with_user_data(self, script_content):
        user_data_by_section = self.extract_sections_content(script_content)
        script = self.generate_scene_template()
        self.set_section_user_data(script, 'scene', 'setup', user_data_by_section)
        self.set_section_user_data(script, 'scene', 'input', user_data_by_section)
        self.set_section_user_data(script, 'scene', 'update', user_data_by_section)
        self.set_section_user_data(script, 'scene', 'cleanup', user_data_by_section)
        return script

    @staticmethod
    def set_section_user_data(script, section, callback, user_data_by_section):
        script.get_section(section).get_callback(callback).set_user_section(LuaUserCode(user_data_by_section[callback]))

    @staticmethod
    def generate_scene_template():
        template = LuaScript('SceneTemplate')
        template.add_section(LuaMacroSection('dependencies'))

        scene = LuaMacroSection('scene')
        scene.add_field(LuaField('name', 'SceneTemplate', LuaFieldType.STRING))
        scene.add_field(LuaField('version', '1.0', LuaFieldType.STRING))
        scene.add_field(LuaField('quit', 'false', LuaFieldType.BOOL))
        scene.add_field(LuaField('finished', 'false', LuaFieldType.BOOL))
        scene.add_field(LuaField('next', 'TBD', LuaFieldType.STRING))
        scene.add_callback(LuaCallback('setup'))
        scene.add_callback(LuaCallback('input', ['keys', 'mouse_buttons', 'x', 'y']))
        scene.add_callback(LuaCallback('update', ['tpf']))
        scene.add_callback(LuaCallback('cleanup'))
        template.add_section(scene)
        return template

    @staticmethod
    def extract_sections_content(script_content):
        lines = script_content.splitlines()
        user_section_found = False
        user_data = []
        user_data_by_section = {}
        last_section = ''
        for line in lines:
            if line.strip().startswith(hpms_lua_script_data.USER_SECTION_START):
                user_section_found = True
                st = '['
                end = ']'
                last_section = line[line.find(st) + 1: line.find(end)]
            if line.strip().startswith(hpms_lua_script_data.USER_SECTION_END):
                user_section_found = False
                user_data.pop(0)
                diff = len(user_data[0]) - len(user_data[0].strip())
                user_data_formatted = []
                for user_data_exp in user_data:
                    user_data_exp_formatted = user_data_exp[diff:]
                    user_data_formatted.append(user_data_exp_formatted)
                user_data_by_section[last_section] = "\n".join(user_data_formatted)
                user_data = []
            if user_section_found and line.strip():
                user_data.append(line)
        return user_data_by_section
