-- Scene script.
dependencies = {
    'Framework.lua'
}

speed = 0
rotate = 0
mx = 0
my = 0
sector = nil

scene = {
    name = 'Scene_00',
    version = '1.0.0',
    quit = false,
    finished = false,
    next = 'undef',
    setup = function()
        -- Init function callback.
        enable_debug()
        context:inst():disable_dummy()

        lib = backend:get()

        -- Actors
        player = lib.make_entity("EY_DummyAnim.mesh")
        player_node = lib.make_node("DummyAnimNode")
        lib.play_anim(player, "my_animation")
        lib.set_node_entity(player_node, player)

        -- Collisions
        map = lib.make_walkmap("Dummy_Scene.walkmap")
        collisor = lib.make_node_collisor(player_node, map, 0.3098)

        -- Backgrounds
        back = lib.make_background("CM_01.png")

        -- Views
        lib.set_ambient(lib.vec3(0.1, 0.1, 0.1))
        cam = lib.get_camera()
        cam.near = 0.05
        cam.far = 50
        cam.fovy = lib.to_radians(40)
        scn_mgr = scene_manager:new(scene.name, cam)
        -- @formatter:off
        scn_mgr:sample_view_by_callback(function() return sector.id == 'SG_01' end, back, lib.vec3(0.0, -4.699999809265137, 1.5), lib.quat(0.7933533787727356, 0.6087613701820374, 0.0, -0.0))
        -- @formatter:on

        -- Light
        light = lib.make_light(lib.vec3(0, 0, 0))
        light.position = lib.vec3(0.0, -4.699999809265137, 1.5)

        -- GUI
        cursor = lib.make_overlay('Pointer.png', 0, 0, 200)
        --points = {0, 0, 320, 0, 320, 50, 0, 50}
        points = { lib.vec2(0, 0), lib.vec2(320, 0), lib.vec2(320, 50), lib.vec2(0, 50) }
        text2d = input_text_2d:new(points, 0, 0, 'Console_White.png', 100, 'DebugConsoleArea', 'Tamzen', 16, lib.vec4(1.0, 1.0, 1.0, 1.0), 5)
        text2d:set_position(0, 0)

        -- Debug
        --hpms.debug_draw_walkmap(map)


    end,
    input = function(keys, mouse_buttons, x, y)
        -- Input function callback.
        --if text2d:point_inside(x, y) then
        --    print ('INSIDE ' .. x .. ',' .. y)
        --else
        --    print('OUTSIDE')
        --end


        if keys ~= nil then
            if lib.key_action_performed(keys, 'ESC', 1) then
                scene.quit = true
            end
            if lib.key_action_performed(keys, 'E', 1) then
                -- print('enter')
                debug_console_exec()
            end
            if lib.key_action_performed(keys, 'UP', 2) then
                speed = 1
            elseif lib.key_action_performed(keys, 'DOWN', 2) then
                speed = -1
            else
                speed = 0
            end

            if lib.key_action_performed(keys, 'RIGHT', 2) then
                rotate = -5
            elseif lib.key_action_performed(keys, 'LEFT', 2) then
                rotate = 5
            else
                rotate = 0
            end

        end

        mx = limitx(x)
        my = limity(y)


    end,
    update = function(tpf)
        lib.update_collisor(collisor)
        cursor.position = lib.vec3(mx, my, 100)

        if speed == 0 and rotate == 0 then
            animating = false
        else
            animating = true
        end
        if animating then
            lib.update_anim(player, "my_animation", tpf / 2)
        end
        f_move_collisor_towards_direction(collisor, speed * tpf)
        f_rotate(player, 0, 0, rotate * tpf * 10)
        hpms.debug_draw_clear()
        hpms.debug_draw_perimeter(map)
        hpms.debug_draw_aabb(player)
        sector = collisor.sector
        scn_mgr:update()

    end,
    cleanup = function()

        text2d:delete()
        lib.delete_overlay(cursor)
        lib.delete_light(light)
        lib.delete_background(back)
        lib.delete_collisor(collisor)
        lib.delete_walkmap(map)
        lib.delete_node(player_node)
        lib.delete_entity(player)


    end
}

function limitx(val)
    return limit(val, 320, 0)
end

function limity(val)
    return limit(val, 200, 0)
end

function limit(val, max, min)
    if val > max then
        return max
    end
    if val < min then
        return min
    end
    return val
end

function f_move_collisor_towards_direction(coll, ratio)
    local dir = lib.get_direction(coll.rotation, lib.vec3(0, -1, 0))
    local nextPos = lib.vec3_add(coll.position, lib.vec3(ratio * dir.x, ratio * dir.y, 0))
    lib.move_collisor_dir(coll, nextPos, lib.vec2(dir.x, dir.y))
end

function f_rotate(actor, rx, ry, rz)
    actor.rotation = lib.quat_mul(actor.rotation, lib.from_euler(lib.to_radians(rx), lib.to_radians(ry), lib.to_radians(rz)))
end