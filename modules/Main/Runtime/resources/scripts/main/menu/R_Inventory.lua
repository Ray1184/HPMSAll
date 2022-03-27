-- Scene script.
dependencies = {
    'libs/gui/Image2D.lua',
    'libs/gui/OutputText2D.lua',
    'libs/logic/gameplay/TextHelper.lua',
    'libs/logic/templates/AbstractObject.lua',
    'libs/backend/HPMSFacade.lua',
    'libs/logic/managers/GlobalStateManager.lua',
    'libs/thirdparty/Inspect.lua',
    'libs/logic/managers/BundleManager.lua',
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
        bm = bundle_manager:new()

        cam = lib.get_camera()
        cam.near = 0.05
        cam.far = 100
        cam.fovy = lib.to_radians(40)

        scn_mgr = scene_manager:new(scene.name, cam)
        actors_mgr = actors_manager:new(scn_mgr)

        wk = workflow:new(scn_mgr)
        seq = workflow_sequences:new()

        player = gsm:get_session_var(k.session_vars.CURRENT_PLAYER_REF)

        lamp = lib.make_light(lib.vec3(2, 2, 2))
        lamp.position = lib.vec3(-0.675, -2, 0.55)

        scn_mgr:sample_view_by_callback( function() return true end, 'menu/B_Inventory.png', lib.vec3(-0.675, -2, 0.55), lib.quat(0.707107, 0.707107, 0, 0))


        wk:add_workflow( {
            seq:fade_out(0)
        } , nil, false, 'Inventory fade out')

        wk:add_workflow( {
            seq:fade_in(1)
        } , nil, false, 'Inventory fade in')

        wk:add_workflow( {
            seq:pipe( function(tpf)
                local lastRoom = gsm:get_session_var(k.session_vars.LAST_ROOM)
                gsm:put_session_var(k.session_vars.LAST_ROOM, scene.name)
                scene.next = 'main/scenes/' .. lastRoom .. '.lua'
                scene.finished = true
            end )
        } , function() return input_prf:action_done_once('INVENTORY') end, false, 'Exit inventory')

        -- Base graphics
        local invBox = { lib.vec2(10, 0), lib.vec2(320, 0), lib.vec2(320, 200), lib.vec2(0, 200) }
        gui = image_2d:new(TYPE_POLYGON, invBox, 0, 0, 'menu/O_Inventory.png', 100)
        gui:set_visible(true)
        slots = { }
        selectedIndex = 1
        draw_item_list(player:get_inventory(), slots, selectedIndex)



    end,
    input = function(keys, mouse_buttons, x, y)
        -- Input function callback.
        input_prf:poll_inputs(keys, mouse_buttons)


    end,
    update = function(tpf)
        -- Update function callback.

        scn_mgr:poll_events(tpf)
        wk:poll_events(tpf)

    end,
    cleanup = function()
        -- Cleanup function callback.
        lib.delete_light(lamp)
        scn_mgr:delete_all()
        actors_mgr:delete_all()
        seq:delete_all()
        gui:delete()
        clear_item_list(slots)

    end
}

function clear_item_list(slots)
    for i = 1, #slots do
        delete_text_label(slots[i])
    end
end

function draw_item_list(inventory, slots, selectedIndex)
    clear_item_list(slots)
    local countItems = #inventory.objects
    local from = limit_up(selectedIndex - 4, 1)
    local to = limit_down(selectedIndex + 4, countItems)
    local rndIndex = 0
    for i = from, to do
        local id = inventory.objects[i].id
        local currObject = context:get_full_ref(id)
        local invLabel = bm:msg(currObject:get_properties().name)
        table.insert(slots, create_text_label('inv_item_' .. rndIndex, invLabel, lib, 12, 58 +(16 * rndIndex)))
        rndIndex = rndIndex + 1
    end


end

function limit_up(val, limit)
    if val <= limit then
        return limit
    else
        return val
    end
end

function limit_down(val, limit)
    if val >= limit then
        return limit
    else
        return val
    end
end