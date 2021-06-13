-- TestRoom2
-- Generated with Blend2HPMS batch on date 10-06-2021

dependencies = {
    'luatest/Dep1.lua',
    'luatest/Dep2.lua'
}

scene = {
    name = 'TestRoom',
    quit = false,
    setup = function()
        hpms.set_ambient(hpms.vec3(0.1, 0.1, 0.1))
        cam = hpms.get_camera()
        cam.near = 0.5
        -- USER SECTION START
        
        -- Write here additional code...
        
        -- USER SECTION END
        light = hpms.make_light(hpms.vec3(0, 0, 0))
    end,
    update = function()
        s = hpms.sample_sector()
        -- USER SECTION START
        print(s.name)
        print(framerate)
        -- USER SECTION END
        hpms.poll_events()
    end
}