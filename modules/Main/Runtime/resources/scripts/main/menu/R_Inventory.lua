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
    'libs/logic/managers/EventQueueManager.lua',
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
        trx = transform:get()

        cam = lib.get_camera()
        cam.near = 0.05
        cam.far = 100
        cam.fovy = lib.to_radians(40)

        scnMgr = scene_manager:new(scene.name, cam)
        actorsMgr = actors_manager:new(scnMgr)
        inputPrf = input_profile:new(context_get_input_profile())
        eqm = event_queue_manager:new()

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
        actionsBar = nil
        pickBar = nil
        currentDescr = nil
        currentAmount = nil
        currentChoiceYes = nil
        currentChoiceNo = nil
        selectedIndex = 1
        actionIndex = 1
        scope = gsm:get_session_var(k.session_vars.INV_ACTION)
        selectedItem = nil
        selectedModel = nil
        pickChoice = 0
        canPick = true
        pickedItemId = gsm:get_session_var(k.session_vars.PICKED_ITEM_ID)
        pickedItemAmount = gsm:get_session_var(k.session_vars.PICKED_ITEM_AMOUNT)

        wk:add_workflow( {
            seq:fade_out(0)
        } , nil, false, 'Inventory fade out')

        wk:add_workflow( {
            seq:fade_in(1)
        } , nil, false, 'Inventory fade in')

        wk:add_workflow( {
            seq:pipe( function(tpf)

                local cbks = { }
                cbks[k.inventory_scope.SCOPE_LIST] = function()
                    go_back(scene)
                end
                cbks[k.inventory_scope.SCOPE_PICK] = function()
                    go_back(scene)
                end
                cbks[k.inventory_scope.SCOPE_ACTIONS] = function()
                    scope = k.inventory_scope.SCOPE_LIST
                    update_view(player:get_inventory(), false)
                end
                cbks[scope]()


            end )
        } , function() return inputPrf:action_done_once(k.input_actions.INVENTORY) or inputPrf:action_done_once(k.input_actions.EXIT) end, true, 'Go back')

        wk:add_workflow( {
            seq:pipe( function(tpf)
                local cbks = { }
                cbks[k.inventory_scope.SCOPE_LIST] = function()
                    scope = k.inventory_scope.SCOPE_ACTIONS
                    -- Reset action index.
                    actionIndex = 1
                    update_view(player:get_inventory(), true)
                end
                cbks[k.inventory_scope.SCOPE_ACTIONS] = function()
                    local evt =
                    {
                        name = k.item_events.ACTION,
                        room_id = gsm:get_session_var(k.session_vars.LAST_ROOM),
                        player = player,
                        action = selectedItem:get_properties().allowed_actions[actionIndex]
                    }
                    log_debug('Triggering action ' .. tostring(evt.action) .. ' for item ' .. selectedItem.serializable.id)
                    selectedItem:event(tpf, evt)
                    evt.response = evt.response or { }
                    if evt.response.quit_inventory then
                        go_back(scene)
                    else
                        scope = k.inventory_scope.SCOPE_LIST
                        update_view(player:get_inventory(), false)
                    end
                end
                cbks[k.inventory_scope.SCOPE_PICK] = function()
                    if canPick then
                        if pickChoice == 0 then
                            add_to_inventory(player, selectedItem)
                            scope = k.inventory_scope.SCOPE_LIST
                            go_back(scene)
                        else
                            go_back(scene)
                        end
                    else
                        go_back(scene)
                    end
                end
                cbks[scope]()

            end )
        } , function() return inputPrf:action_done_once(k.input_actions.ACTION_1) end, true, 'Go ahead')


        wk:add_workflow( {
            seq:pipe( function(tpf)
                local cbks = { }
                cbks[k.inventory_scope.SCOPE_LIST] = function()
                    if selectedIndex > 1 then
                        selectedIndex = selectedIndex - 1
                        update_view(player:get_inventory(), true)
                    end
                end
                cbks[k.inventory_scope.SCOPE_ACTIONS] = function()
                    if actionIndex > 1 then
                        actionIndex = actionIndex - 1
                        update_view(player:get_inventory(), true)
                    end
                end
                cbks[k.inventory_scope.SCOPE_PICK] = function()
                    if not canPick then
                        return
                    end
                    pickChoice = 0
                    update_view(player:get_inventory(), false)
                end
                cbks[scope]()
            end )
        } , function() return inputPrf:action_done_once(k.input_actions.UP) end, true, 'Move slot up')

        wk:add_workflow( {
            seq:pipe( function(tpf)
                local cbks = { }
                cbks[k.inventory_scope.SCOPE_LIST] = function()
                    if selectedIndex < #player:get_inventory().objects then
                        selectedIndex = selectedIndex + 1
                        update_view(player:get_inventory(), true)
                    end
                end
                cbks[k.inventory_scope.SCOPE_ACTIONS] = function()
                    if actionIndex < #selectedItem:get_properties().allowed_actions then
                        actionIndex = actionIndex + 1
                        update_view(player:get_inventory(), true)
                    end
                end
                cbks[k.inventory_scope.SCOPE_PICK] = function()
                    if not canPick then
                        return
                    end
                    pickChoice = 1
                    update_view(player:get_inventory(), false)
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
        itemsBar:set_visible(false)

        -- Actions graphics (visible only on actions scope).
        actionsGui = image_2d:new(TYPE_POLYGON, invBox, 86, 70, 'menu/O_InventoryActions.png', 109)
        actionsGui:set_visible(false)

        -- Item list.
        local actBox = { lib.vec2(0, 0), lib.vec2(134, 0), lib.vec2(134, 20), lib.vec2(0, 20) }
        actionsBar = image_2d:new(TYPE_POLYGON, actBox, 0, 0, 'menu/Bar_Actions.png', 110)
        actionsBar:set_visible(false)
        actionsBar:set_position(91, 72)

        -- Pick request bar choice (visible only on pick scope).
        local pickBox = { lib.vec2(0, 0), lib.vec2(134, 0), lib.vec2(134, 20), lib.vec2(0, 20) }
        pickBar = image_2d:new(pickBox, actBox, 0, 0, 'menu/Bar_Choice.png', 110)
        pickBar:set_visible(false)

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
        pickBar:delete()
        actionsGui:delete()
        actionsBar:delete()
        if selectedModel ~= nil then
            selectedModel:delete_transient_data()
        end

        if currentDescr ~= nil then
            delete_text_label(currentDescr)
        end

        if currentChoiceYes ~= nil then
            delete_text_label(currentChoiceYes)
        end

        if currentChoiceNo ~= nil then
            delete_text_label(currentChoiceNo)
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

function clear_pick()
end

function update_view(inventory, redraw)
    local cbks = { }
    cbks[k.inventory_scope.SCOPE_LIST] = function()
        clear_actions(actionSlots)
        itemsBar:set_visible(true)
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
            local currObject = context_get_full_ref(id)
            local invLabel = bm:msg(currObject:get_properties().name)
            table.insert(slots, create_text_label('inv_item_' .. rndIndex, invLabel, lib, 12, 57 +(16 * rndIndex)))
            rndIndex = rndIndex + 1
        end

        -- Model
        local id = inventory.objects[selectedIndex].id
        selectedItem = context_get_full_ref(id)
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
        display_current_info(selectedItem, k.inventory_scope.SCOPE_LIST, inventory)

    end

    cbks[k.inventory_scope.SCOPE_ACTIONS] = function()
        clear_actions(actionSlots)

        local countItems = #inventory.objects

        if countItems == 0 then
            scope = k.inventory_scope.SCOPE_LIST
            return
        end

        actionsGui:set_visible(true)
        actionsBar:set_visible(true)

        local actions = selectedItem:get_properties().allowed_actions
        local countItems = #actions
        local settings = calculate_cursor_and_offset(actionIndex, k.ACTIONS_DISPLAY_LIST_SIZE, countItems)

        -- Cursor
        actionsBar:set_position(91, 75 +(16 *(settings.cursor_slot - 1)))

        -- Labels
        local from = settings.display_from
        local to = settings.display_to
        local rndIndex = 0
        for i = from, to do
            local actionLabel = bm:msg(actions[i])
            table.insert(actionSlots, create_text_label('inv_action_' .. rndIndex, actionLabel, lib, 93, 77 +(16 * rndIndex), 1, 130))
            rndIndex = rndIndex + 1
        end

    end

    cbks[k.inventory_scope.SCOPE_PICK] = function()

        -- Cursor
        pickBar:set_position(135, 159 +(14 * pickChoice))

        if not redraw then
            return
        end

        clear_item_list(slots)

        local countItems = #inventory.objects

        if countItems ~= 0 then
            local settings = calculate_cursor_and_offset(selectedIndex, k.INVENTORY_DISPLAY_LIST_SIZE, countItems)

            -- Labels (not interaction, just to avoid empty list on left)
            local from = settings.display_from
            local to = settings.display_to
            local rndIndex = 0
            for i = from, to do
                local id = inventory.objects[i].id
                local currObject = context_get_full_ref(id)
                local invLabel = bm:msg(currObject:get_properties().name)
                table.insert(slots, create_text_label('inv_item_' .. rndIndex, invLabel, lib, 12, 57 +(16 * rndIndex)))
                rndIndex = rndIndex + 1
            end
        end




        -- Model
        selectedItem = context_get_full_ref(pickedItemId)
        if selectedModel ~= nil then
            selectedModel:delete_transient_data()
        end
        selectedModel = game_item:ret(selectedItem.serializable.path, selectedItem.serializable.id .. '/inv_menu_model')
        selectedModel:fill_transient_data()
        local offsetPos = selectedItem:get_properties().inventory_position_offset
        local offsetRot = selectedItem:get_properties().inventory_rotation_offset
        local offsetScale = selectedItem:get_properties().inventory_scale_offset
        selectedModel:rotate(offsetRot.x, offsetRot.y, offsetRot.z)
        selectedModel:scale(offsetScale.x, offsetScale.y, offsetScale.z)
        selectedModel.transient.ctrl_node.position = lib.vec3(offsetPos.x, offsetPos.y, offsetPos.z)



        display_current_info(selectedItem, k.inventory_scope.SCOPE_PICK, inventory)

        wkModels:clear()

        wkModels:add_workflow( {
            seq:pipe( function(tpf)
                trx.rotate(selectedModel.transient.ctrl_node, 0, 0, 200 * tpf)
                selectedModel:update(tpf)
            end,true)
        } , nil, true, 'Animate model')
    end

    cbks[scope]()
end

function display_current_info(item, scope, inventory)
    local cbks = { }
    cbks[k.inventory_scope.SCOPE_LIST] = function()
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
        if item:get_properties().show_amount then
            local amountLabel = tostring(item.serializable.amount)
            currentAmount = create_text_label('item_amount', amountLabel, lib, 165, 57, 1)
        end
    end

    cbks[k.inventory_scope.SCOPE_PICK] = function()
        if currentDescr ~= nil then
            delete_text_label(currentDescr)
            currentDescr = nil
        end
        if currentChoiceYes ~= nil then
            delete_text_label(currentChoiceYes)
        end
        if currentChoiceNo ~= nil then
            delete_text_label(currentChoiceNo)
        end
        local descrLabel = nil


        if #inventory.objects >= inventory.size then
            descrLabel = bm:msg('inv_no_space') .. ' ' .. bm:msg(item:get_properties().name)
            canPick = false
            pickBar:set_visible(false)
        else
            descrLabel = bm:msg('inv_wanna_pick') .. ' ' .. bm:msg(item:get_properties().name) .. '?'
            currentChoiceYes = create_text_label('pick_item_choice_yes', bm:msg('inv_yes'), lib, 155, 161, 1, 130)
            currentChoiceNo = create_text_label('pick_item_choice_no', bm:msg('inv_no'), lib, 155, 175, 1, 130)
            canPick = true
            pickBar:set_visible(true)
        end
        currentDescr = create_text_label('pick_item_description', descrLabel, lib, 12, 144, 3)

    end

    cbks[scope]()
end

function go_back(scene)
    local lastRoom = gsm:get_session_var(k.session_vars.LAST_ROOM)
    gsm:put_session_var(k.session_vars.LAST_ROOM, scene.name)
    scene.next = 'main/scenes/' .. lastRoom .. '.lua'
    scene.finished = true
end