-- R_Debug_02
-- Generated with Blend2HPMS batch on date 2021/09/12

dependencies = {
    'Framework.lua',
    'libs/logic/models/Player.lua',
    'libs/logic/models/RoomState.lua',
    'libs/backend/HPMSFacade.lua',
    'libs/input/InputProfile.lua',
    'libs/thirdparty/JsonHelper.lua',
    'libs/thirdparty/Inspect.lua',
    'libs/logic/gameplay/Workflow.lua',
    'libs/logic/gameplay/WorkflowSequences.lua',
    'libs/logic/gameplay/InventoryHelper.lua',
    'inst/Instances.lua',
    'inst/GameplayConsts.lua',
    'libs/logic/managers/GlobalStateManager.lua',
    'libs/logic/managers/EventQueueManager.lua'
}

scene = {
    name = 'R_Debug_02',
    version = '1.0',
    quit = false,
    finished = false,
    next = 'TBD',
    setup = function()
        -- TODOBATCH-BEGIN g.res_refs.actors.DUMMY_PLAYER.ID

        context_disable_dummy()
        disable_debug()
        -- TODOBATCH-END

        -- Base scene setup
        lib = backend:get()
        cam = lib.get_camera()
        cam.near = 0.05
        cam.far = 100
        cam.fovy = lib.to_radians(40)
        interactive = true

        room_st = room_state:ret(scene.name)
        gsm = global_state_manager:new()


        input_prf = input_profile:new(context_get_input_profile())
        scn_mgr = scene_manager:new(scene.name, cam)
        actors_mgr = actors_manager:new(scn_mgr)
        wk = workflow:new(scn_mgr)
        seq = workflow_sequences:new()
        eqm = event_queue_manager:new()


        -- Collision map R_Debug_02 setup
        -- walkmap_r_debug_01 = lib.make_walkmap('Dummy_Scene.walkmap')

        action = false

        walkRatio = 0
        walk = 0
        rotate = 0


        lib = backend:get()
        insp = inspector:get()
        -- > gestirlo via scene_manager
        -- walkmap = lib.make_walkmap("Dummy_Scene.walkmap")
        -- > gestirlo via scene_manager
        -- player = player:ret('DummyAnim.mesh', 'main_player', 0.3098)
        -- player = dummy_player:ret()
        scn_mgr:create_walkmap('Dummy_Scene.walkmap')

        mask = lib.make_depth_entity('DummyMask.mesh')
        mask_node = lib.make_node("DummyMaskNode")
        lib.set_node_entity(mask_node, mask)

        player = actors_mgr:create_player(gsm:get_session_var(k.session_vars.CURRENT_PLAYER_ID))
        gsm:put_session_var(k.session_vars.CURRENT_PLAYER_REF, player)

        recover_inventory_items(player, actors_mgr)




        eqm:consume_all()
        room_st:load_dropped_collectibles(player, actors_mgr)
        actors_mgr:init_events()

        -- log_warn(insp.inspect(player))
        -- item2 = player:ret('EY_DummyAnim.mesh', 'main_player_dopplelanger', 0.3098)

        -- log_debug(player)
        -- log_debug(chest)
        -- player:fill_transient_data(walkmap)
        player:play(k.anim_modes.ANIM_MODE_LOOP, 2, 1)
        -- item2:fill_transient_data(walkmap)

        json = json_helper:get()
        -- log_debug(player)
        nextPressed = false
        scn_mgr:sample_view_by_callback( function() if current_sector ~= nil then return current_sector.id == 'S_01' else return false end end, 'R_Debug_02/CM_01.png', lib.vec3(0.0, -4.699999809265137, 1.5), lib.quat(0.7933533787727356, 0.6087613701820374, 0.0, -0.0))
        scn_mgr:sample_view_by_callback( function() if current_sector ~= nil then return current_sector.id == 'S_02' else return false end end, 'R_Debug_02/CM_02.png', lib.vec3(0.0, 5.838781833648682, 1.5), lib.quat(-3.467857823125087e-08, -2.6609807690647358e-08, 0.6087614297866821, 0.7933533191680908))
        scn_mgr:sample_view_by_callback( function() if current_sector ~= nil then return current_sector.id == 'S_03' else return false end end, 'R_Debug_02/CM_03.png', lib.vec3(0.0, 12.0, 3.5), lib.quat(8.921578142917497e-08, -4.213227988714152e-09, -0.5735764503479004, -0.8191520571708679))
        scn_mgr:sample_view_by_callback( function() if current_sector ~= nil then return current_sector.id == 'S_04' else return false end end, 'R_Debug_02/CM_04.png', lib.vec3(5.5, 15.0, 3.0), lib.quat(-0.13912473618984222, -0.16580234467983246, -0.6275509595870972, -0.7478861212730408))
        scn_mgr:sample_view_by_callback( function() if current_sector ~= nil then return current_sector.id == 'S_05' else return false end end, 'R_Debug_02/CM_05.png', lib.vec3(5.627859115600586, 6.149685859680176, 3.0989725589752197), lib.quat(-0.48958826065063477, -0.4014081358909607, -0.4459995925426483, -0.6326603889465332))

        local animBack = {
            sequences = { 'R_Debug_02/CM_06_01.png', 'R_Debug_02/CM_06_02.png', 'R_Debug_02/CM_06_03.png', 'R_Debug_02/CM_06_04.png' },
            loop = true,
            frame_duration = 0.3
        }

        scn_mgr:sample_view_by_callback( function() if current_sector ~= nil then return current_sector.id == 'S_06' else return false end end, animBack, lib.vec3(-6.351622581481934, -11.026840209960938, -0.13639304041862488), lib.quat(0.641304, 0.652595, -0.287829, -0.282849))


        wk:add_workflow( {
            seq:fade_out(0)
        } , nil, false, 'fade out')

        wk:add_workflow( {
            seq:fade_in(1)
        } , nil, false, 'fade in')

   
        wk:add_workflow( {
            seq:pipe( function(tpf) gsm:save_data('data/save/savedata00.json', { room_id = scene.name }) end),
            seq:message_box('Game saved', function(tpf, timer) return input_prf:action_done_once(k.input_actions.ACTION_1) end,k.diplay_msg_styles.MSG_BOX,true)
        } , function() return input_prf:action_done_once(k.input_actions.ACTION_3) end, true, 'save_data_flow')

      

        lamp = lib.make_light(lib.vec3(0.3, 0.3, 0.3))
        lamp.position = lib.vec3(-0.0026106834411621094, 0.02561706304550171, 1.5122439861297607)


        lamp_01 = lib.make_light(lib.vec3(0.3, 0.3, 0.3))
        lamp_01.position = lib.vec3(1.57603919506073, 13.489124298095703, 3.434197425842285)


        lamp_02 = lib.make_light(lib.vec3(0.3, 0.3, 0.3))
        lamp_02.position = lib.vec3(5.0, 6.813676357269287, 3.434197425842285)


        lamp_03 = lib.make_light(lib.vec3(0.3, 0.3, 0.3))
        lamp_03.position = lib.vec3(-1.6572145223617554, 13.457348823547363, 2.8559913635253906)


        lamp_04 = lib.make_light(lib.vec3(0.3, 0.3, 0.3))
        lamp_04.position = lib.vec3(-4.067772388458252, 0.02561706304550171, 1.5122439861297607)

        -- View CM_01 setup
        -- background_cm_01 = lib.make_background('R_Debug_02/CM_01.png')
        -- scn_mgr:sample_view_by_callback(function() if current_sector ~= nil then return current_sector.id == 'SG_01' else return false end end, background_cm_01, lib.vec3(0.0, -4.699999809265137, 1.5), lib.quat(0.7933533787727356, 0.6087613701820374, 0.0, -0.0))
        -- scn_mgr:sample_view_by_callback( function() return true end, 'R_Debug_02/CM_01.png', lib.vec3(0.0, -4.699999809265137, 1.5), lib.quat(0.7933533787727356, 0.6087613701820374, 0.0, -0.0))

        -- Entity EY_DummyAnim setup
        -- entity_ey_dummyanim = lib.make_entity('EY_DummyAnim.mesh')
        -- entity_node_ey_dummyanim = lib.make_node('EY_DummyAnimNode')
        -- entity_node_ey_dummyanim.scale = lib.vec3(1.0, 1.0, 1.0)
        -- lib.set_node_entity(entity_node_ey_dummyanim, entity_ey_dummyanim)

        -- Collisor EY_DummyAnim setup
        -- collisor_ey_dummyanim = lib.make_node_collisor(entity_node_ey_dummyanim, walkmap_r_debug_01, 0.3098)
        -- collisor_ey_dummyanim.position = lib.vec3(0.0, 0.0, 0.0)
        -- collisor_ey_dummyanim.rotation = lib.quat(1.0, 0.0, 0.0, 0.0)

        -- CUSTOM CODE STARTS HERE, DO NOT REMOVE THIS LINE [setup]
        -- TODO
        -- CUSTOM CODE STOPS HERE, DO NOT REMOVE THIS LINE [setup]

    end,
    input = function(keys, mouse_buttons, x, y)

        input_prf:poll_inputs(keys, mouse_buttons)
        if not interactive then
            return
        end

        -- CUSTOM CODE STARTS HERE, DO NOT REMOVE THIS LINE [input]
        if keys ~= nil then
            if lib.key_action_performed(keys, 'ESC', 1) then
                scene.quit = true
            end

            -- if lib.key_action_performed(keys, 'E', 1) then
            --    debug_console_exec()
            -- end

            if lib.key_action_performed(keys, 'S', 1) then
                nextPressed = true
            else
                nextPressed = false
            end

            if lib.key_action_performed(keys, 'P', 1) then
                -- player:delete_transient_data()
                -- player = player:ret('EY_DummyAnim.mesh', 'main_player', 0.3098)
                -- player:fill_transient_data(walkmap)
                -- log_debug('JSON --> ' .. json.encode(player.serializable))
            end

            if lib.key_action_performed(keys, k.input_actions.UP, 2) then
                walk = 1
            elseif lib.key_action_performed(keys, k.input_actions.DOWN, 2) then
                walk = -1
            else
                walk = 0
            end

            if lib.key_action_performed(keys, 'SPACE', 2) then
                action = true
            else
                action = false
            end

            if lib.key_action_performed(keys, k.input_actions.RIGHT, 2) then
                rotate = -2
            elseif lib.key_action_performed(keys, k.input_actions.LEFT, 2) then
                rotate = 2
            else
                rotate = 0
            end
        end
        -- CUSTOM CODE STOPS HERE, DO NOT REMOVE THIS LINE [input]

    end,
    update = function(tpf)
        -- TODOBATCH-BEGIN
        -- lib.update_collisor(collisor_ey_dummyanim)
        -- current_sector = collisor_ey_dummyanim.sector
        hpms.debug_draw_clear()
        if walk == 1 then
            walkRatio = walkRatio + tpf * 10
            if walkRatio > 1 then
                walkRatio = 1
            end
        elseif walk == -1 then
            walkRatio = walkRatio - tpf * 10
            if walkRatio < -1 then
                walkRatio = -1
            end
        else
            if walkRatio > 0 then
                walkRatio = walkRatio - tpf * 10
                if walkRatio < 0 then
                    walkRatio = 0
                end
            else
                walkRatio = walkRatio + tpf * 10
                if walkRatio > 0 then
                    walkRatio = 0
                end
            end

        end
        turn = rotate ~= 0
        walkF = walk > 0
        walkB = walk < 0
        player.serializable.performing_action = false
        if interactive then
            if action then
                player:set_anim('Push')
                player:play(k.anim_modes.ANIM_MODE_LOOP, 1)
                player.serializable.performing_action = true
            elseif walkF or(walkF and turn) then
                player:set_anim('Walk_Forward')
                player:play(k.anim_modes.ANIM_MODE_LOOP, 1)
            elseif walkB or(walkB and turn) then
                player:set_anim('Walk_Back')
                player:play(k.anim_modes.ANIM_MODE_LOOP, 1)
            elseif turn then
                player:set_anim('Idle')
                player:play(k.anim_modes.ANIM_MODE_LOOP, 1)
                -- lib.look_collisor_at(player.transient.collisor, lib.vec3(0, 0, 0), 0.5)

                -- player.serializable.performing_action = true
            else
                -- player.serializable.performing_action = false
                player:set_anim('Idle')
                player:play(k.anim_modes.ANIM_MODE_LOOP, 2, 1)
            end
        end
        if not action then
            player:rotate(0, 0, 50 * tpf * rotate)
        end
        player:move_dir(tpf * walkRatio * 1)
        -- player:update(tpf)

        -- INVENTORY PICK TEST
        if input_prf:action_done_once(k.input_actions.INVENTORY) then
            gsm:put_session_var(k.session_vars.INV_ACTION, k.inventory_scope.SCOPE_LIST)
            gsm:put_session_var(k.session_vars.CURRENT_PLAYER_REF, player)
            gsm:put_session_var(k.session_vars.LAST_ROOM, scene.name)
            scene.next = 'main/menu/R_Inventory.lua'
            scene.finished = true
        end

          -- SWITCH ROOM TEST
        if input_prf:action_done_once(k.input_actions.PAUSE) then
            gsm:put_session_var(k.session_vars.LAST_ROOM, scene.name)
            scene.next = 'main/scenes/R_Debug_01.lua'
            scene.finished = true
        end
        -- if input_prf:action_done_once(k.input_actions.ACTION_3) then
        --    gsm:put_session_var(k.session_vars.INV_ACTION, k.inventory_scope.SCOPE_PICK)
        --    gsm:put_session_var(k.session_vars.CURRENT_PLAYER_REF, player)
        --    gsm:put_session_var(k.session_vars.LAST_ROOM, scene.name)
        --    gsm:put_session_var(k.session_vars.PICKED_ITEM_ID, obj1.serializable.id)
        --    gsm:put_session_var(k.session_vars.PICKED_ITEM_AMOUNT, 1)
        --    scene.next = 'main/menu/R_Inventory.lua'
        --    scene.finished = true
        -- end


        -- TODOBATCH-END

        -- CUSTOM CODE STARTS HERE, DO NOT REMOVE THIS LINE [update]

        -- hpms.debug_draw_perimeter(scn_mgr:get_walkmap())
        -- hpms.debug_draw_aabb(player.transient.collisor)
        -- hpms.debug_draw_aabb(chest.transient.collisor)
        -- hpms.debug_draw_aabb(chest2.transient.collisor)
        -- hpms.debug_draw_aabb(chest3.transient.collisor)

        -- CUSTOM CODE STOPS HERE, DO NOT REMOVE THIS LINE [update]
        current_sector = player.transient.collisor.sector
        -- log_warn(current_sector.id)
        scn_mgr:poll_events(tpf)
        actors_mgr:poll_events(tpf)
        wk:poll_events(tpf)
        -- log_debug('CURR TPF: ' .. tostring(1 / tpf))
    end,
    cleanup = function()

        -- CUSTOM CODE STARTS HERE, DO NOT REMOVE THIS LINE [cleanup]
        -- TODO
        -- lib.delete_walkmap(walkmap)
        -- CUSTOM CODE STOPS HERE, DO NOT REMOVE THIS LINE [cleanup]

        -- player:delete_transient_data()
        -- item2:delete_transient_data()

        -- Collisor EY_DummyAnim delete
        -- lib.delete_collisor(collisor_ey_dummyanim)

        -- Entity EY_DummyAnim cleanup
        -- lib.delete_entity(entity_ey_dummyanim)

        -- View CM_01 delete
        room_st:delete_dropped_collectibles()
        actors_mgr:delete_all()
        scn_mgr:delete_all()
        seq:delete_all()

        -- Collision map R_Debug_02 delete
        -- lib.delete_walkmap(walkmap_r_debug_01)

        -- Base scene delete
        lib.delete_light(lamp_04)
        lib.delete_light(lamp_03)
        lib.delete_light(lamp_02)
        lib.delete_light(lamp_01)
        lib.delete_light(lamp)
        lib.delete_node(mask_node)
        lib.delete_entity(mask)

        lib.cleanup_pending()


    end
}

-- CUSTOM CODE STARTS HERE, DO NOT REMOVE THIS LINE [common]
-- TODO
-- CUSTOM CODE STOPS HERE, DO NOT REMOVE THIS LINE [common]