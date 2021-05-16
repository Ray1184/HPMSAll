-- Scene script.
--require('data/scripts/libs/Context')
--common = require("data/scripts/libs/TransformsCommon")
scene = {
    name = "Scene_01",
    version = "1.0.0",
    quit = false,
    setup = function()
        -- Init function callback.
        --context:inst().dummy = false
        hpms.set_ambient(hpms.vec3(0.1, 0.1, 0.1))
        cam = hpms.get_camera()
        --cam.position = hpms.vec3(0, 1.5, 3)
        --cam.rotation = hpms.from_euler(hpms.to_radians(90 - 75), hpms.to_radians(0.0), hpms.to_radians(0.0))
        --cam.near = 0.5
        --cam.far = 100
        --cam.fovy = hpms.to_radians(40)
        --mx = 0
        --my = 0
        cam.position = hpms.vec3(0, -3, 1.5)
        cam.rotation = hpms.quat(0.793353, 0.608761, 0, 0)
        cam.near = 0.5
        cam.far = 100
        cam.fovy = hpms.to_radians(40)
        mx = 0
        my = 0

        entity = hpms.make_entity("EY_DummyAnim.mesh")
        door = hpms.make_entity("Door.mesh")
        weapon = hpms.make_entity("EY_DummySword.mesh")
        node = hpms.make_node("DummyAnimNode")
        doornode = hpms.make_node("DoorNode")
        hpms.set_bone_node("Hand.L", weapon, entity, hpms.vec3(0, 0.3, 0), hpms.from_euler(0, 0, 0))
        hpms.play_anim(entity, "my_animation")

        doornode.position = hpms.vec3(0, 4.6, 0)
        hpms.set_node_entity(node, entity)
        hpms.set_node_entity(doornode, door)

        map = hpms.make_walkmap("Dummy_Scene.walkmap")

        hpms.debug_draw_walkmap(map)
        collisor = hpms.make_node_collisor(node, map, 0)

        back = hpms.make_background("B_01.png")
        hpms_title = hpms.make_overlay("HPMS.png", 0, 0, 0)
        cursor = hpms.make_overlay("Cursor.png", 0, 0, 100)

        text = hpms.make_textarea("HPMSText", "Alagard", 16, 20, 80, 320, 400, 10, hpms.vec4(1.0, 0.8, 0.1, 1.0))
        rem = hpms.stream_text(text, "HPMS test label 123456789123456789 qwertyuiopasdfghjklzxcvbnm 12345678909876543.", 8)
        --text.color = hpms.vec4(1.0, 0.8, 0.1, 1.0)



        light = hpms.make_light(hpms.vec3(0, 0, 0))
        light.position = hpms.vec3(0, -3, 1.5)

        rotcam = 0
        speedcam = 0

    end,
    input = function(keys, mouse_buttons, x, y)
        -- Input function callback.


        speed = 0
        rotate = 0


        -- Input function callback.
        hpms.debug_draw_clear()
        hpms.debug_draw_walkmap(map)
        hpms.debug_draw_collisor_triangle(collisor)

        if keys ~= nil then
            if hpms.key_action_performed(keys, 'S', 1) then
                sector = collisor.sector
                if sector ~= nil then
                    print('Current sector: ' .. sector.id)
                else
                    print('Current sector NIL')
                end

            end
            if hpms.key_action_performed(keys, 'ESC', 1) then
                scene.quit = true
            end
            if hpms.key_action_performed(keys, 'UP', 2) then
                speed = 1
            elseif hpms.key_action_performed(keys, 'DOWN', 2) then
                speed = -1
            else
                speed = 0
            end

            if hpms.key_action_performed(keys, 'RIGHT', 2) then
                rotate = -5
            elseif hpms.key_action_performed(keys, 'LEFT', 2) then
                rotate = 5
            else
                rotate = 0
            end
            if hpms.key_action_performed(keys, 'I', 1) then
                -- TODO Inventary
            end
        end

        mx = limitx(x)
        my = limity(y)

    end,
    update = function(tpf)
        -- Update loop function callback.
        --local rot = node.rotation
        --local nrot = hpms.from_euler(0, 0, tpf)
        --node.rotation = hpms.quat_mul(rot, nrot)
        cursor.position = hpms.vec3(mx - 30, my - 20, 100)
        hpms.update_anim(entity, "my_animation", tpf / 2)
        hpms.update_collisor(collisor)
        f_move_collisor_towards_direction(collisor, speed * tpf)
        f_rotate(node, 0, 0, rotate * tpf * 10)
        ----text.position = hpms.vec3(mx - 50, my + 40, 100)

    end,
    cleanup = function()
        -- Close function callback.
        --hpms.delete_textarea(text2)
        hpms.delete_light(light)
        hpms.delete_textarea(text)
        hpms.delete_collisor(collisor)
        hpms.delete_walkmap(map)
        hpms.delete_overlay(hpms_title)
        hpms.delete_overlay(cursor)
        hpms.delete_background(back)
        --hpms.delete_node(dnode)
        --hpms.delete_entity(dentity)
        hpms.delete_node(node)
        hpms.delete_entity(weapon)
        hpms.delete_entity(entity)
    end
}

function f_move_collisor_towards_direction(coll, ratio)
    local dir = hpms.get_direction(coll.rotation, hpms.vec3(0, -1, 0))
    local nextPos = hpms.vec3_add(coll.position, hpms.vec3(ratio * dir.x, ratio * dir.y, 0))
    hpms.move_collisor_dir(coll, nextPos, hpms.vec2(dir.x, dir.y))
end

function f_rotate(actor, rx, ry, rz)
    actor.rotation = hpms.quat_mul(actor.rotation, hpms.from_euler(hpms.to_radians(rx), hpms.to_radians(ry), hpms.to_radians(rz)))
end

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