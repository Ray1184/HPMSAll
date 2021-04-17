-- Scene script.
scene = {
    name = "Scene_01",
    version = "1.0.0",
    quit = false,
    setup = function(scene, camera)
        context:inst().dummy = false
        ctx = { mode = 'play' }



        -- Init function callback.
        e = hpms.make_entity('data/models/Dummy_Anim.hmdat')
        w = hpms.make_walkmap('data/maps/Basement.hrdat')
        a = hpms.make_animator(e, 'Dummy_Anim')
        b = hpms.make_background('data/screens/B01_B.png')
        d = hpms.make_depth_mask('data/masks/B01_D.png')
        i = hpms.make_background('data/screens/Inventory.png')
        n = hpms.make_node("NODE_01")
        c = hpms.make_node_collisor(n, w, 1)

        a.anim_channel = 0
        a.loop = true

        a.slow_down_factor = 2

        hpms.add_anim(a, 'move', 0, 25)
        hpms.add_anim(a, 'back', 26, 51)
        hpms.add_anim(a, 'rest', 53, 53)
        hpms.set_anim(a, 'rest')
        hpms.rewind_anim(a)
        a.play = true

        common.loc_rot_scale(e, 0, 0.8, 0, 0, 180, 0, 1.1, 1.1, 1.1)
        common.loc_rot_scale(n, 0, 0, 0, 0, 0, 0, 0.2, 0.2, 0.2)

        camera.position = hpms.vec3(3.5, 1, -3)
        camera.rotation = hpms.vec3(0, hpms.to_radians(-120), 0)
        scene.ambient_light = hpms.vec3(1, 1, 1)
        hpms.set_node_entity(n, e)
        hpms.add_node_to_scene(n, scene)
        --
        --hpms.add_entity_to_scene(e, scene)
        hpms.add_picture_to_scene(i, scene)
        hpms.add_picture_to_scene(b, scene)
        hpms.add_picture_to_scene(d, scene)

        ctx.mode = 'play'
    end,
    input = function(keys)
        speed = 0
        rotate = 0


        -- Input function callback.

        if keys ~= nil then
            if hpms.action_performed(keys, 'ESC', input.PRESSED) then
                scene.quit = true
            end
            if hpms.action_performed(keys, 'UP', input.PRESSED) then
                speed = 3
            elseif hpms.action_performed(keys, 'DOWN', input.PRESSED) then
                speed = -3
            else
                speed = 0
            end

            if hpms.action_performed(keys, 'RIGHT', input.PRESSED) then
                rotate = -5
            elseif hpms.action_performed(keys, 'LEFT', input.PRESSED) then
                rotate = 5
            else
                rotate = 0
            end
            if hpms.action_performed(keys, 'I', input.PRESSED_FIRST_TIME) then
                if ctx.mode == 'play' then
                    ctx.mode = 'menu'
                else
                    ctx.mode = 'play'
                end
            end
        end
    end,
    update = function(scene, camera)
        -- Update loop function callback.

        if ctx.mode == 'play' then
            hpms.add_picture_to_scene(b, scene)
            camera.position = hpms.vec3(3.5, 1, -3)
            camera.rotation = hpms.vec3(0, hpms.to_radians(-120), 0)
            hpms.update_view(camera)
            hpms.update_animator(a)
            hpms.update_collisor(c)
            common.move_collisor_towards_direction(c, speed / 120.0)
            common.rotate(n, 0, rotate / 3.0, 0)

            local play_strategy = {
                animator = a,
                anim_sets = {
                    { 'move', function() return speed > 0 or (rotate ~= 0 and speed == 0) end },
                    { 'back', function() return speed < 0 end },
                    { 'rest', function() return speed == 0 and rotate == 0 end }
                }
            }

            anim_util.play(play_strategy)



        else
            hpms.add_picture_to_scene(i, scene)
            camera.position = hpms.vec3(0, 0, 0)
            camera.rotation = hpms.vec3(0, 0, 0)
            hpms.update_view(camera)
        end
    end,
    cleanup = function()
        -- Close function callback.
        hpms.delete_collisor(c)
        hpms.delete_node(n)
        hpms.delete_animator(a)
        hpms.delete_walkmap(w)
        hpms.delete_entity(e)
        hpms.delete_background(b)
        hpms.delete_background(i)
        hpms.delete_depth_mask(d)
    end
}