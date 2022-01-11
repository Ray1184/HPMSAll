-- R_Debug_01
-- Generated with Blend2HPMS batch on date 2021/09/12

dependencies = {
    'Framework.lua',
    'libs/logic/models/Player.lua',
    'libs/backend/HPMSFacade.lua',
    'libs/utils/Utils.lua',
    'libs/thirdparty/JsonHelper.lua',
    'libs/thirdparty/Inspect.lua',
    'inst/Instances.lua',
    'inst/GameplayConsts.lua'
}

scene = {
    name = 'R_Debug_01',
    version = '1.0',
    quit = false,
    finished = false,
    next = 'TBD',
    setup = function()
        -- TODOBATCH-BEGIN



        -- TODOBATCH-END

        -- Base scene setup
        lib = backend:get()
        cam = lib.get_camera()
        cam.near = 0.05
        cam.far = 50
        cam.fovy = lib.to_radians(40)
        light = lib.make_light(lib.vec3(0, 0, 0))
        light.position = lib.vec3(0.0, -4.699999809265137, 1.5)
        scn_mgr = scene_manager:new(scene.name, cam)
        actors_mgr = actors_manager:new(scn_mgr)

        -- Collision map R_Debug_01 setup
        -- walkmap_r_debug_01 = lib.make_walkmap('Dummy_Scene.walkmap')


        changed = true
        register_all_instances()
        action = true

        walkRatio = 0
        walk = 0
        rotate = 0
        enable_debug()
        context:inst():disable_dummy()
        lib = backend:get()
        insp = inspector:get()
        -- > gestirlo via scene_manager
        -- walkmap = lib.make_walkmap("Dummy_Scene.walkmap")
        -- > gestirlo via scene_manager
        -- player = player:ret('DummyAnim.mesh', 'main_player', 0.3098)
        -- player = dummy_player:ret()
        scn_mgr:create_walkmap('Dummy_Scene.walkmap')
        player = actors_mgr:create_player(g.res_refs.players.DUMMY_PLAYER.ID)
        player:set_action_mode(7)
        player.serializable.performing_action = true
        player:set_position(0, 0, 0.0)
        -- actor_action_mode.PUSH
        chest = actors_mgr:create_actor(g.res_refs.actors.DUMMY_CHEST.ID)
        chest:set_position(2, 1, 0)

        chest2 = actors_mgr:create_actor(g.res_refs.actors.DUMMY_CHEST.ID)
        chest2:set_position(-2, -1, 0)

        chest3 = actors_mgr:create_actor(g.res_refs.actors.DUMMY_CHEST.ID)
        chest3:set_position(-1, 2, 0)
        chest3:scale(0.5, 0.5, 0.5)

        -- log_warn(insp.inspect(player))
        -- item2 = player:ret('EY_DummyAnim.mesh', 'main_player_dopplelanger', 0.3098)

        -- log_debug(player)
        -- log_debug(chest)
        -- player:fill_transient_data(walkmap)
        player:play(ANIM_MODE_LOOP, 2, 1)
        -- item2:fill_transient_data(walkmap)

        json = json_helper:get()
        -- log_debug(player)

        -- View CM_01 setup
        -- background_cm_01 = lib.make_background('R_Debug_01/CM_01.png')
        -- scn_mgr:sample_view_by_callback(function() if current_sector ~= nil then return current_sector.id == 'SG_01' else return false end end, background_cm_01, lib.vec3(0.0, -4.699999809265137, 1.5), lib.quat(0.7933533787727356, 0.6087613701820374, 0.0, -0.0))
        scn_mgr:sample_view_by_callback( function() return true end, 'R_Debug_01/CM_01.png', lib.vec3(0.0, -4.699999809265137, 1.5), lib.quat(0.7933533787727356, 0.6087613701820374, 0.0, -0.0))
        log_debug(scn_mgr)
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

        -- CUSTOM CODE STARTS HERE, DO NOT REMOVE THIS LINE [input]
        if keys ~= nil then
            if lib.key_action_performed(keys, 'ESC', 1) then
                scene.quit = true
            end

            if lib.key_action_performed(keys, 'E', 1) then
                debug_console_exec()
            end

            if lib.key_action_performed(keys, 'P', 1) then
                -- player:delete_transient_data()
                -- player = player:ret('EY_DummyAnim.mesh', 'main_player', 0.3098)
                -- player:fill_transient_data(walkmap)
                -- log_debug('JSON ---> ' .. json.encode(player.serializable))
            end

            if lib.key_action_performed(keys, 'UP', 2) then
                walk = 1
            elseif lib.key_action_performed(keys, 'DOWN', 2) then
                walk = -1
            else
                walk = 0
            end

            if lib.key_action_performed(keys, 'SPACE', 2) then
                action = true
            else
                action = false
            end

            if lib.key_action_performed(keys, 'RIGHT', 2) then
                rotate = -1
            elseif lib.key_action_performed(keys, 'LEFT', 2) then
                rotate = 1
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
            walkRatio = walkRatio + tpf * tpf * 30
            if walkRatio > 1 then
                walkRatio = 1
            end
        elseif walk == -1 then
            walkRatio = walkRatio - tpf * tpf * 30
            if walkRatio < -1 then
                walkRatio = -1
            end
        else
            if walkRatio > 0 then
                walkRatio = walkRatio - tpf * tpf * 30
                if walkRatio < 0 then
                    walkRatio = 0
                end
            else
                walkRatio = walkRatio + tpf * tpf * 30
                if walkRatio > 0 then
                    walkRatio = 0
                end
            end

        end
        turn = rotate ~= 0
        walkF = walk > 0
        walkB = walk < 0
        player.serializable.performing_action = false
        if action or(action and rotate) or(action and walkF) then
            player:set_anim('Push')
            player:play(ANIM_MODE_LOOP, 2)
            player.serializable.performing_action = true
        elseif walkF or(walkF and rotate) then
            player:set_anim('Walk_Forward')
            player:play(ANIM_MODE_LOOP, 2)
        elseif walkB or(walkB and rotate) then
            player:set_anim('Walk_Back')
            player:play(ANIM_MODE_LOOP, 2)
        elseif turn then
            player:set_anim('Idle')
            player:play(ANIM_MODE_LOOP, 2)

            -- player.serializable.performing_action = true
        else
            -- player.serializable.performing_action = false
            player:set_anim('Idle')
            player:play(ANIM_MODE_LOOP, 2, 1)
        end
        player:rotate(0, 0, 50 * tpf * rotate)
        player:move_dir(tpf * walkRatio)
        -- player:update(tpf)



        -- TODOBATCH-END

        -- CUSTOM CODE STARTS HERE, DO NOT REMOVE THIS LINE [update]

        hpms.debug_draw_perimeter(scn_mgr:get_walkmap())
        hpms.debug_draw_aabb(player.transient.collisor)
        hpms.debug_draw_aabb(chest.transient.collisor)
        hpms.debug_draw_aabb(chest2.transient.collisor)
        hpms.debug_draw_aabb(chest3.transient.collisor)

        -- CUSTOM CODE STOPS HERE, DO NOT REMOVE THIS LINE [update]

        scn_mgr:poll_events(tpf)
        actors_mgr:poll_events(tpf)
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

        ---- Entity EY_DummyAnim cleanup
        -- lib.delete_node(entity_node_ey_dummyanim)
        -- lib.delete_entity(entity_ey_dummyanim)

        -- View CM_01 delete
        actors_mgr:delete_all()
        scn_mgr:delete_all()

        -- Collision map R_Debug_01 delete
        -- lib.delete_walkmap(walkmap_r_debug_01)

        -- Base scene delete
        lib.delete_light(light)
    end
}

-- CUSTOM CODE STARTS HERE, DO NOT REMOVE THIS LINE [common]
-- TODO
-- CUSTOM CODE STOPS HERE, DO NOT REMOVE THIS LINE [common]