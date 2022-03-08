-- Scene script.
dependencies = {
    'libs/gui/Image2D.lua',
    'libs/gui/OutputText2D.lua',
    'libs/logic/templates/AbstractObject.lua',
    'libs/backend/HPMSFacade.lua',
    'libs/thirdparty/Inspect.lua',
    'Framework.lua'
}


scene = {
    name = 'R_Inventory',
    version = '1.0.0',
    quit = false,
    finished = false,
    next = 'undef',
    setup = function()
        -- Init function callback.

        lib = backend:get()
        k = game_mechanics_consts:get()
        insp = inspector:get()

        local invBox = { lib.vec2(10, 0), lib.vec2(320, 0), lib.vec2(320, 200), lib.vec2(0, 200) }
        background = image_2d:new(TYPE_POLYGON, invBox, 0, 0, 'menu/MenuShade.png', 98)
        gui = image_2d:new(TYPE_POLYGON, invBox, 0, 0, 'menu/Inventory.png', 101)
        background:set_visible(true)
        gui:set_visible(true)


    end,
    input = function(keys, mouse_buttons, x, y)
        -- Input function callback.
        input_prf:poll_inputs(keys, mouse_buttons)


    end,
    update = function(tpf)
        -- Update function callback.
        if input_prf:action_done_once('INVENTORY') then
            scene.next = 'main/scenes/R_Debug_01.lua' -- TODO must be dynamic
            scene.finished = true
        end

    end,
    cleanup = function()
        -- Cleanup function callback.
        background:delete()
        gui:delete()

    end
}
