-- TestHPMS
-- Generated with Blend2HPMS batch on date 04-07-2021

dependencies = {
}

scene = {
    name = 'SceneTemplate',
    version = '1.0',
    quit = false,
    finished = false,
    next = 'TBD',
    setup = function()
        x = 25
        y = hpms.det(x)
        if x > y then
            if hpms.valid() then
                print('GOOD')
            end
        else
            hpms.next_calc()
        end
        -- CUSTOM CODE STARTS HERE, DO NOT REMOVE THIS LINE [setup]
        hpms.debug_draw()
        -- CUSTOM CODE STOPS HERE, DO NOT REMOVE THIS LINE [setup]
    end,
    input = function(keys, mouse_buttons, x, y)
        -- CUSTOM CODE STARTS HERE, DO NOT REMOVE THIS LINE [input]
        -- TODO
        -- CUSTOM CODE STOPS HERE, DO NOT REMOVE THIS LINE [input]
    end,
    update = function(tpf)
        -- CUSTOM CODE STARTS HERE, DO NOT REMOVE THIS LINE [update]
        -- TODO
        -- CUSTOM CODE STOPS HERE, DO NOT REMOVE THIS LINE [update]
    end,
    cleanup = function()
        -- CUSTOM CODE STARTS HERE, DO NOT REMOVE THIS LINE [cleanup]
        -- TODO
        -- CUSTOM CODE STOPS HERE, DO NOT REMOVE THIS LINE [cleanup]
    end
}