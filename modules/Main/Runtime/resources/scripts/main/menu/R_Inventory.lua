-- Scene script.
dependencies = {
    'libs/gui/Image2D.lua',
    'libs/gui/OutputText2D.lua',
    'libs/logic/templates/AbstractObject.lua',
    'libs/backend/HPMSFacade.lua',
    'libs/logic/managers/GlobalStateManager.lua',
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
        gsm = global_state_manager:new()
        cam = lib.get_camera()
        cam.near = 0.05
        cam.far = 100
        cam.fovy = lib.to_radians(40)
        scn_mgr = scene_manager:new(scene.name, cam)
        cin = workflow:new(scn_mgr)
        seq = workflow_sequences:new()

        local invBox = { lib.vec2(10, 0), lib.vec2(320, 0), lib.vec2(320, 200), lib.vec2(0, 200) }
        background = image_2d:new(TYPE_POLYGON, invBox, 0, 0, 'menu/MenuShade.png', 98)
        gui = image_2d:new(TYPE_POLYGON, invBox, 0, 0, 'menu/Inventory.png', 101)
        background:set_visible(true)
        gui:set_visible(true)

        cin:add_workflow( {
            seq:fade_out(0)
        } , nil, false, 'Inventory fade out')

        cin:add_workflow( {
            seq:fade_in(1)
        } , nil, false, 'Inventory fade in')

        cin:add_workflow( {
            seq:pipe( function()
                local lastRoom = gsm:get_session_var(k.session_vars.LAST_ROOM)
                gsm:put_session_var(k.session_vars.LAST_ROOM, scene.name)
                scene.next = 'main/scenes/' .. lastRoom .. '.lua'
                scene.finished = true
            end )
        } , function() return input_prf:action_done_once('INVENTORY') end, false, 'Exit inventory')


    end,
    input = function(keys, mouse_buttons, x, y)
        -- Input function callback.
        input_prf:poll_inputs(keys, mouse_buttons)


    end,
    update = function(tpf)
        -- Update function callback.
        
        scn_mgr:poll_events(tpf)
        cin:poll_events(tpf)

    end,
    cleanup = function()
        -- Cleanup function callback.
        scn_mgr:delete_all()
        seq:delete_all()
        background:delete()
        gui:delete()

    end
}
