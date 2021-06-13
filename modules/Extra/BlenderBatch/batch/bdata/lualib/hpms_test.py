import unittest
import hpms_lua_script_data
import hpms_lua_script_generator
import os

dir_path = os.path.dirname(os.path.realpath(__file__))


class LuaTest(unittest.TestCase):
    @staticmethod
    def test_script_format():
        # Whole script
        lua_script = hpms_lua_script_data.LuaScript('TestRoom')
        lua_script.name = 'TestRoom2'
        # Dependencies
        dep_section = hpms_lua_script_data.LuaMacroSection('dependencies')
        d1 = hpms_lua_script_data.LuaStatement('luatest/Dep1.lua', True)
        d2 = hpms_lua_script_data.LuaStatement('luatest/Dep2.lua', True)
        dep_section.add_statement(d1)
        dep_section.add_statement(d2)

        # Scene
        scene_section = hpms_lua_script_data.LuaMacroSection('scene')
        f1 = hpms_lua_script_data.LuaField('name', 'TestRoom')
        f2 = hpms_lua_script_data.LuaField('quit', 'false', hpms_lua_script_data.LuaFieldType.BOOL)
        scene_section.add_field(f1)
        scene_section.add_field(f2)
        setup_cbk = hpms_lua_script_data.LuaCallback('setup')
        s1 = hpms_lua_script_data.LuaStatement('hpms.set_ambient(hpms.vec3(0.1, 0.1, 0.1))')
        s2 = hpms_lua_script_data.LuaStatement('cam = hpms.get_camera()')
        s3 = hpms_lua_script_data.LuaStatement('cam.near = 0.5')
        setup_cbk.add_statement_pre(s1)
        setup_cbk.add_statement_pre(s2)
        setup_cbk.add_statement_pre(s3)
        # u = hpms_lua_script_data.LuaUserCode('hpms.set_debug_draw(true)')
        # setup_cbk.set_user_section(u)
        s4 = hpms_lua_script_data.LuaStatement('light = hpms.make_light(hpms.vec3(0, 0, 0))')
        setup_cbk.add_statement_post(s4)
        scene_section.add_callback(setup_cbk)

        update_cbk = hpms_lua_script_data.LuaCallback('update')
        p1 = hpms_lua_script_data.LuaStatement('s = hpms.sample_sector()')
        update_cbk.add_statement_pre(p1)
        u = hpms_lua_script_data.LuaUserCode('print(s.name)\nprint(framerate)')
        update_cbk.set_user_section(u)
        p2 = hpms_lua_script_data.LuaStatement('hpms.poll_events()')
        update_cbk.add_statement_post(p2)
        scene_section.add_callback(update_cbk)

        lua_script.add_section(dep_section)
        lua_script.add_section(scene_section)

        with open(dir_path + '/../bin/01-test-script.lua', 'w') as script_file:
            script_file.write(lua_script.get_script())

    @staticmethod
    def test_script_template():
        generator = hpms_lua_script_generator.LuaScriptTemplate()
        template = generator.generate_scene_template()

        with open(dir_path + '/../bin/02-test-template.lua', 'w') as script_file:
            script_file.write(template.get_script())


if __name__ == '__main__':
    unittest.main()
