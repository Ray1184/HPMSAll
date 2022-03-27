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
        input_prf = input_profile:new(context:get_input_profile())

        wk = workflow:new(scn_mgr)
        seq = workflow_sequences:new()

        player = gsm:get_session_var(k.session_vars.CURRENT_PLAYER_REF)

        lamp = lib.make_light(lib.vec3(2, 2, 2))
        lamp.position = lib.vec3(-0.675, -2, 0.55)

        scn_mgr:sample_view_by_callback( function() return true end, 'menu/B_Inventory.png', lib.vec3(-0.675, -2, 0.55), lib.quat(0.707107, 0.707107, 0, 0))

        slots = { }
        itemsBar = nil
        selectedIndex = 1

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
        } , function() return input_prf:action_done_once(k.input_actions.INVENTORY) end, false, 'Exit inventory')

        wk:add_workflow( {
            seq:pipe( function(tpf)
                if selectedIndex > 1 then
                    selectedIndex = selectedIndex - 1
                    local barBoxIndex = selectedIndex - 1
                    itemsBar:set_position(10, 55 +(16 * barBoxIndex))
                end
            end )
        } , function() return input_prf:action_done_once(k.input_actions.UP) end, true, 'Move slot up')

        wk:add_workflow( {
            seq:pipe( function(tpf)
                if selectedIndex < 5 then
                    selectedIndex = selectedIndex + 1
                    local barBoxIndex = selectedIndex - 1
                    itemsBar:set_position(10, 55 +(16 * barBoxIndex))
                end
            end )
        } , function() return input_prf:action_done_once(k.input_actions.DOWN) end, true, 'Move slot down')

        -- Base graphics.
        local invBox = { lib.vec2(10, 0), lib.vec2(320, 0), lib.vec2(320, 200), lib.vec2(0, 200) }
        gui = image_2d:new(TYPE_POLYGON, invBox, 0, 0, 'menu/O_Inventory.png', 99)
        gui:set_visible(true)

        -- Item list.       
        local barBox = { lib.vec2(0, 0), lib.vec2(147, 0), lib.vec2(147, 20), lib.vec2(0, 20) }
        itemsBar = image_2d:new(TYPE_POLYGON, barBox, 0, 0, 'menu/Bar_Items.png', 100)
        
        draw_item_list(player:get_inventory(), slots, selectedIndex, itemsBar)





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
        itemsBar:delete()

    end
}

function clear_item_list(slots)
    for i = 1, #slots do
        delete_text_label(slots[i])
    end
   
end

function draw_item_list(inventory, slots, selectedIndex, itemsBar)
    clear_item_list(slots)
    local itemToDisplay = k.INVENTORY_DISPLAY_LIST_SIZE
    local barBoxIndex = selectedIndex - 1
    itemsBar:set_position(10, 55 +(20 * barBoxIndex))

    local countItems = #inventory.objects
    local from = 1 -- TODO
    local to = itemToDisplay -- TODO
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