-- Scene script.
dependencies = {
    'libs/utils/TransformsCommon.lua',
    'libs/gui/Image2D.lua',
    'libs/gui/OutputText2D.lua',
    'libs/logic/gameplay/TextHelper.lua',
    'libs/logic/templates/AbstractObject.lua',
    'libs/backend/HPMSFacade.lua',
    'libs/logic/managers/GlobalStateManager.lua',
    'libs/thirdparty/Inspect.lua',
    'libs/logic/managers/BundleManager.lua',
    'libs/logic/gameplay/InventoryHelper.lua',
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
        SCOPE_LIST = 1
        SCOPE_ACTIONS = 2

        lib = backend:get()
        k = game_mechanics_consts:get()
        insp = inspector:get()
        gsm = global_state_manager:new()
        bm = bundle_manager:new()
        trx = transform:get()

        cam = lib.get_camera()
        cam.near = 0.05
        cam.far = 100
        cam.fovy = lib.to_radians(40)

        scnMgr = scene_manager:new(scene.name, cam)
        actorsMgr = actors_manager:new(scnMgr)
        inputPrf = input_profile:new(context:get_input_profile())

        wk = workflow:new(scnMgr)
        wkModels = workflow:new(scnMgr)
        seq = workflow_sequences:new()

        player = gsm:get_session_var(k.session_vars.CURRENT_PLAYER_REF)

        lamp = lib.make_light(lib.vec3(2, 2, 2))
        lamp.position = lib.vec3(-0.675, -2, 0.55)

        scnMgr:sample_view_by_callback( function() return true end, 'menu/B_Inventory.png', lib.vec3(-0.675, -2, 0.55), lib.quat(0.707107, 0.707107, 0, 0))

        slots = { }
        actionSlots = { }
        itemsBar = nil
        currentDescr = nil
        currentAmount = nil
        selectedIndex = 1
        actionIndex = 1
        scope = SCOPE_LIST
        selectedItem = nil
        selectedModel = nil

        wk:add_workflow( {
            seq:fade_out(0)
        } , nil, false, 'Inventory fade out')

        wk:add_workflow( {
            seq:fade_in(1)
        } , nil, false, 'Inventory fade in')

        wk:add_workflow( {
            seq:pipe( function(tpf)

                local cbks = { }
                cbks[SCOPE_LIST] = function()
                    local lastRoom = gsm:get_session_var(k.session_vars.LAST_ROOM)
                    gsm:put_session_var(k.session_vars.LAST_ROOM, scene.name)
                    scene.next = 'main/scenes/' .. lastRoom .. '.lua'
                    scene.finished = true
                end
                cbks[SCOPE_ACTIONS] = function()
                    scope = SCOPE_LIST
                    update_view(player:get_inventory(), false)
                end
                cbks[scope]()


            end )
        } , function() return inputPrf:action_done_once(k.input_actions.INVENTORY) or inputPrf:action_done_once(k.input_actions.EXIT) end, true, 'Go back')

        wk:add_workflow( {
            seq:pipe( function(tpf)
                local cbks = { }
                cbks[SCOPE_LIST] = function()
                    scope = SCOPE_ACTIONS
                    -- Reset action index.
                    actionIndex = 1
                    update_view(player:get_inventory(), true)
                end
                cbks[SCOPE_ACTIONS] = function()
                    local evt =
                    {
                        name = k.item_events.ACTION,
                        player = player,
                        action = selectedItem:get_properties().allowed_actions[actionIndex]
                    }
                    log_debug('Triggering action ' .. tostring(evt.action) .. ' for item ' .. selectedItem.serializable.id)
                    selectedItem:event(tpf, evt)
                    evt.response = evt.response or { }
                    if evt.response.quit_inventory then
                        local lastRoom = gsm:get_session_var(k.session_vars.LAST_ROOM)
                        gsm:put_session_var(k.session_vars.LAST_ROOM, scene.name)
                        scene.next = 'main/scenes/' .. lastRoom .. '.lua'
                        scene.finished = true
                    else
                        scope = SCOPE_LIST
                        update_view(player:get_inventory(), false)
                    end
                end
                cbks[scope]()
            end )
        } , function() return inputPrf:action_done_once(k.input_actions.ACTION_1) end, true, 'Go ahead')


        wk:add_workflow( {
            seq:pipe( function(tpf)
                local cbks = { }
                cbks[SCOPE_LIST] = function()
                    if selectedIndex > 1 then
                        selectedIndex = selectedIndex - 1
                        update_view(player:get_inventory(), true)
                    end
                end
                cbks[SCOPE_ACTIONS] = function()
                    if actionIndex > 1 then
                        actionIndex = actionIndex - 1
                        update_view(player:get_inventory(), true)
                    end
                end
                cbks[scope]()
            end )
        } , function() return inputPrf:action_done_once(k.input_actions.UP) end, true, 'Move slot up')

        wk:add_workflow( {
            seq:pipe( function(tpf)
                local cbks = { }
                cbks[SCOPE_LIST] = function()
                    if selectedIndex < #player:get_inventory().objects then
                        selectedIndex = selectedIndex + 1
                        update_view(player:get_inventory(), true)
                    end
                end
                cbks[SCOPE_ACTIONS] = function()
                    if actionIndex < #selectedItem:get_properties().allowed_actions then
                        actionIndex = actionIndex + 1
                        update_view(player:get_inventory(), true)
                    end
                end
                cbks[scope]()
            end )
        } , function() return inputPrf:action_done_once(k.input_actions.DOWN) end, true, 'Move slot down')

        -- Base graphics.
        local invBox = { lib.vec2(10, 0), lib.vec2(320, 0), lib.vec2(320, 200), lib.vec2(0, 200) }
        gui = image_2d:new(TYPE_POLYGON, invBox, 0, 0, 'menu/O_Inventory.png', 99)
        gui:set_visible(true)

        -- Item list.
        local barBox = { lib.vec2(0, 0), lib.vec2(147, 0), lib.vec2(147, 20), lib.vec2(0, 20) }
        itemsBar = image_2d:new(TYPE_POLYGON, barBox, 0, 0, 'menu/Bar_Items.png', 100)


        -- Actions graphics (visible only on actions scope).
        actionsGui = image_2d:new(TYPE_POLYGON, invBox, 86, 67, 'menu/O_InventoryActions.png', 109)
        actionsGui:set_visible(false)

        -- Item list.
        local actBox = { lib.vec2(0, 0), lib.vec2(134, 0), lib.vec2(134, 20), lib.vec2(0, 20) }
        actionsBar = image_2d:new(TYPE_POLYGON, actBox, 0, 0, 'menu/Bar_Actions.png', 110)
        actionsBar:set_visible(false)
        actionsBar:set_position(91, 72)

        -- Draw
        update_view(player:get_inventory(), true)

    end,
    input = function(keys, mouse_buttons, x, y)
        -- Input function callback.
        inputPrf:poll_inputs(keys, mouse_buttons)


    end,
    update = function(tpf)
        -- Update function callback.
        scnMgr:poll_events(tpf)
        wk:poll_events(tpf)
        wkModels:poll_events(tpf)

    end,
    cleanup = function()
        -- Cleanup function callback.
        clear_item_list(slots)
        clear_actions(actionSlots)
        lib.delete_light(lamp)
        scnMgr:delete_all()
        actorsMgr:delete_all()
        seq:delete_all()
        gui:delete()
        itemsBar:delete()
        actionsGui:delete()
        actionsBar:delete()
        if selectedModel ~= nil then
            selectedModel:delete_transient_data()
        end

        if currentDescr ~= nil then
            delete_text_label(currentDescr)
        end

        if currentAmount ~= nil then
            delete_text_label(currentAmount)
        end

        lib.cleanup_pending()

    end
}

function clear_item_list(slots)
    for i = 1, #slots do
        delete_text_label(slots[i])
        slots[i] = nil
    end
end

function clear_actions(actionSlots)
    actionsGui:set_visible(false)
    actionsBar:set_visible(false)
    for i = 1, #actionSlots do
        delete_text_label(actionSlots[i])
        actionSlots[i] = nil
    end
end

function update_view(inventory, redraw)
    local cbks = { }
    cbks[SCOPE_LIST] = function()
        clear_actions(actionSlots)
        if not redraw then
            return
        end

        clear_item_list(slots)

        local countItems = #inventory.objects

        if countItems == 0 then
            return
        end
        local settings = calculate_cursor_and_offset(selectedIndex, k.INVENTORY_DISPLAY_LIST_SIZE, countItems)

        -- Cursor
        itemsBar:set_position(10, 55 +(16 *(settings.cursor_slot - 1)))

        -- Labels
        local from = settings.display_from
        local to = settings.display_to
        local rndIndex = 0
        for i = from, to do
            local id = inventory.objects[i].id
            local currObject = context:get_full_ref(id)
            local invLabel = bm:msg(currObject:get_properties().name)
            table.insert(slots, create_text_label('inv_item_' .. rndIndex, invLabel, lib, 12, 56 +(16 * rndIndex)))
            rndIndex = rndIndex + 1
        end

        -- Model
        local id = inventory.objects[selectedIndex].id
        selectedItem = context:get_full_ref(id)
        if selectedModel ~= nil then
            selectedModel:delete_transient_data()
        end

        -- Note: for position offset use control node and child node for rotation and scale
        selectedModel = game_item:ret(selectedItem.serializable.path, selectedItem.serializable.id .. '/inv_menu_model')
        selectedModel:fill_transient_data()
        local offsetPos = selectedItem:get_properties().inventory_position_offset
        local offsetRot = selectedItem:get_properties().inventory_rotation_offset
        local offsetScale = selectedItem:get_properties().inventory_scale_offset
        selectedModel:rotate(offsetRot.x, offsetRot.y, offsetRot.z)
        selectedModel:scale(offsetScale.x, offsetScale.y, offsetScale.z)
        selectedModel.transient.ctrl_node.position = lib.vec3(offsetPos.x, offsetPos.y, offsetPos.z)
        wkModels:clear()

        wkModels:add_workflow( {
            seq:pipe( function(tpf)
                trx.rotate(selectedModel.transient.ctrl_node, 0, 0, 200 * tpf)
                selectedModel:update(tpf)
            end,true)
        } , nil, true, 'Animate model')

        -- Short description
        display_current_info(selectedItem)

    end

    cbks[SCOPE_ACTIONS] = function()
        clear_actions(actionSlots)
        actionsGui:set_visible(true)
        actionsBar:set_visible(true)

        local actions = selectedItem:get_properties().allowed_actions
        local countItems = #actions
        local settings = calculate_cursor_and_offset(actionIndex, k.ACTIONS_DISPLAY_LIST_SIZE, countItems)

        -- Cursor
        actionsBar:set_position(91, 72 +(16 *(settings.cursor_slot - 1)))

        -- Labels
        local from = settings.display_from
        local to = settings.display_to
        local rndIndex = 0
        for i = from, to do
            local actionLabel = bm:msg(actions[i])
            table.insert(actionSlots, create_text_label('inv_action_' .. rndIndex, actionLabel, lib, 92, 73 +(16 * rndIndex), 1, 130))
            rndIndex = rndIndex + 1
        end

    end

    cbks[scope]()
end

function display_current_info(item)
    if currentDescr ~= nil then
        delete_text_label(currentDescr)
        currentDescr = nil
    end
    if currentAmount ~= nil then
        delete_text_label(currentAmount)
        currentAmount = nil
    end
    local descrLabel = bm:msg(item:get_properties().description)
    currentDescr = create_text_label('short_item_description', descrLabel, lib, 12, 144, 3)
    log_debug('id --> ' .. tostring(item.serializable.id) .. '/amount --> ' .. tostring(item.serializable.amount))
    if item:get_properties().show_amount then
        local amountLabel = tostring(item.serializable.amount)
        currentAmount = create_text_label('item_amount', amountLabel, lib, 168, 56, 1)
    end
end
