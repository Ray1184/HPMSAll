-- R_Debug_01
-- Generated with Blend2HPMS batch on date 2021/09/12

dependencies = {
    'Framework.lua',
    'libs/logic/models/Player.lua',
    'libs/backend/HPMSFacade.lua',
    'libs/utils/Utils.lua',
    'thirdparty/JsonHelper.lua'
}

scene = {
    name = 'R_Debug_01',
    version = '1.0',
    quit = false,
    finished = false,
    next = 'TBD',
    setup = function()
        -- TODOBATCH-BEGIN
        changed = true

        speed = 0
        rotate = 0
        enable_debug()
        context:inst():disable_dummy()
        lib = backend:get()
        -- > gestirlo via scene_manager
        walkmap = lib.make_walkmap("Dummy_Scene.walkmap")
        -- > gestirlo via scene_manager
        item = player:ret('DummyAnim.mesh', 'main_player', 0.3098)
        
        --item2 = player:ret('EY_DummyAnim.mesh', 'main_player_dopplelanger', 0.3098)

        --log_debug(item)
        item:fill_transient_data(walkmap)
        item:play(ANIM_MODE_LOOP, 2, 1)
        --item2:fill_transient_data(walkmap)
        
        json = json_helper:get()
        -- log_debug(item)


        -- TODOBATCH-END

        -- Base scene setup
        lib = backend:get()
        cam = lib.get_camera()
        cam.near = 0.05
        cam.far = 50
        cam.fovy = lib.to_radians(40)
        light = lib.make_light(lib.vec3(0, 0, 0))
        scn_mgr = scene_manager:new(scene.name, cam)

        -- Collision map R_Debug_01 setup
        -- walkmap_r_debug_01 = lib.make_walkmap('Dummy_Scene.walkmap')

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
                item:delete_transient_data()
                item = player:ret('EY_DummyAnim.mesh', 'main_player', 0.3098)
                item:fill_transient_data(walkmap)
                log_debug('JSON ---> ' .. json.encode(item.serializable))
            end

            if lib.key_action_performed(keys, 'UP', 2) then
                speed = 1
            elseif lib.key_action_performed(keys, 'DOWN', 2) then
                speed = -1
            else
                speed = 0
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
        walkF = speed > 0 or rotate ~= 0
        walkB = speed < 0
        if walkF then
            item:set_anim('Walk_Forward')            
            item:play(ANIM_MODE_LOOP, 2, 2)
        elseif walkB then
            item:set_anim('Walk_Back')            
            item:play(ANIM_MODE_LOOP, 2, 2)
        else
            item:set_anim('Idle')
            item:play(ANIM_MODE_LOOP, 2, 1)
        end
        item:rotate(0, 0, 50 * tpf * rotate)
        item:move_dir(tpf * speed * 0.7)
        item:update(tpf)



        -- TODOBATCH-END

        -- CUSTOM CODE STARTS HERE, DO NOT REMOVE THIS LINE [update]

        hpms.debug_draw_perimeter(walkmap)

        -- CUSTOM CODE STOPS HERE, DO NOT REMOVE THIS LINE [update]

        scn_mgr:update()
    end,
    cleanup = function()

        -- CUSTOM CODE STARTS HERE, DO NOT REMOVE THIS LINE [cleanup]
        -- TODO
        lib.delete_walkmap(walkmap)
        -- CUSTOM CODE STOPS HERE, DO NOT REMOVE THIS LINE [cleanup]

        item:delete_transient_data()
        --item2:delete_transient_data()

        -- Collisor EY_DummyAnim delete
        -- lib.delete_collisor(collisor_ey_dummyanim)

        ---- Entity EY_DummyAnim cleanup
        -- lib.delete_node(entity_node_ey_dummyanim)
        -- lib.delete_entity(entity_ey_dummyanim)

        -- View CM_01 delete
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