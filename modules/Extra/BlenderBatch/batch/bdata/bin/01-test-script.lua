-- TestRoom2
-- Generated with Blend2HPMS batch on date 17-06-2021

dependencies = {
    'luatest/Dep1.lua',
    'luatest/Dep2.lua'
}

scene = {
    name = TestRoom,
    quit = false,
    setup = function()
        hpms.set_ambient(hpms.vec3(0.1, 0.1, 0.1))
        cam = hpms.get_camera()
        cam.near = 0.5
        -- CUSTOM CODE STARTS HERE, DO NOT REMOVE THIS LINE [setup]
        -- TODO
        -- CUSTOM CODE STOPS HERE, DO NOT REMOVE THIS LINE [setup]
        light = hpms.make_light(hpms.vec3(0, 0, 0))
    end,
    update = function()
        s = hpms.sample_sector()
        -- CUSTOM CODE STARTS HERE, DO NOT REMOVE THIS LINE [update]
        print(s.name)
        print(framerate)
        -- CUSTOM CODE STOPS HERE, DO NOT REMOVE THIS LINE [update]
        hpms.poll_events()
    end
}