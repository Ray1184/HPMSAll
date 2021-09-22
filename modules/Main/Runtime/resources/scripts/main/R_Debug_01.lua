-- R_Debug_01
-- Generated with Blend2HPMS batch on date 2021/09/12

dependencies = {
    Framework.lua
}

scene = {
    name = 'R_Debug_01',
    version = '1.0',
    quit = false,
    finished = false,
    next = 'TBD',
    setup = function()
        -- Base scene setup
        lib = backend:get()
        cam = lib.get_camera()
        cam.near = 0.05
        cam.far = 50
        cam.fovy = lib.to_radians(40)
        light = lib.make_light(lib.vec3(0, 0, 0))
        scn_mgr = scene_manager:new(scene.name, cam)

        -- Collision map R_Debug_01 setup
        walkmap_r_debug_01 = lib.make_walkmap('R_Debug_01.walkmap')

        -- View CM_01 setup
        background_cm_01 = lib.make_background('R_Debug_01/CM_01.png')
        scn_mgr:sample_view_by_callback(function() if current_sector ~= nil then return current_sector.id == 'SG_01' else return false end end, background_cm_01, lib.vec3(0.0, -4.699999809265137, 1.5), lib.quat(0.7933533787727356, 0.6087613701820374, 0.0, -0.0))

        -- Entity EY_DummyAnim setup
        entity_ey_dummyanim = lib.make_entity('EY_DummyAnim.mesh')
        entity_node_ey_dummyanim = lib.make_node('EY_DummyAnimNode')
        entity_node_ey_dummyanim.scale = lib.vec3(1.0, 1.0, 1.0)
        lib.set_node_entity(entity_node_ey_dummyanim, entity_ey_dummyanim)

        -- Collisor EY_DummyAnim setup
        collisor_ey_dummyanim = lib.make_node_collisor(entity_node_ey_dummyanim, walkmap_r_debug_01, TRESHOLD)
        collisor_ey_dummyanim.position = lib.vec3(0.0, 0.0, 0.0)
        collisor_ey_dummyanim.rotation = lib.quat(1.0, 0.0, 0.0, 0.0)

        -- CUSTOM CODE STARTS HERE, DO NOT REMOVE THIS LINE [setup]
        -- TODO
        -- CUSTOM CODE STOPS HERE, DO NOT REMOVE THIS LINE [setup]

    end,
    input = function(keys, mouse_buttons, x, y)

        -- CUSTOM CODE STARTS HERE, DO NOT REMOVE THIS LINE [input]
        -- TODO
        -- CUSTOM CODE STOPS HERE, DO NOT REMOVE THIS LINE [input]

    end,
    update = function(tpf)

        -- CUSTOM CODE STARTS HERE, DO NOT REMOVE THIS LINE [update]
        current_sector = collisor_ey_dummyanim.sector
        -- CUSTOM CODE STOPS HERE, DO NOT REMOVE THIS LINE [update]

        scn_mgr:update()
    end,
    cleanup = function()

        -- CUSTOM CODE STARTS HERE, DO NOT REMOVE THIS LINE [cleanup]
        -- TODO
        -- CUSTOM CODE STOPS HERE, DO NOT REMOVE THIS LINE [cleanup]

        -- Collisor EY_DummyAnim delete
        lib.delete_collisor(collisor_ey_dummyanim)

        -- Entity EY_DummyAnim cleanup
        lib.delete_node(entity_node_ey_dummyanim)
        lib.delete_entity(entity_ey_dummyanim)

        -- View CM_01 delete
        lib.delete_background(background_cm_01)

        -- Collision map R_Debug_01 delete
        lib.delete_walkmap(walkmap_r_debug_01)

        -- Base scene delete
        lib.delete_light(light)
    end
}

-- CUSTOM CODE STARTS HERE, DO NOT REMOVE THIS LINE [common]
-- TODO
-- CUSTOM CODE STOPS HERE, DO NOT REMOVE THIS LINE [common]