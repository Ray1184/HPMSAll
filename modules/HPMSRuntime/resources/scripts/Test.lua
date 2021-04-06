-- Scene script.
scene = {
    name = "Scene_01",
    version = "1.0.0",
    quit = false,
    setup = function()
        -- Init function callback.
        hpms.set_ambient(hpms.vec3(0.1, 0.1, 0.1))
        local cam = hpms.get_camera()
        cam.position = hpms.vec3(5, 5, 5)
        cam.near = 0.5
        cam.far = 50
        mx = 0
        my = 0
        hpms.camera_lookat(cam, hpms.vec3(0, 0, 0))
        entity = hpms.make_entity("Cube.mesh")
        node = hpms.make_node("CubeNode")
        hpms.set_node_entity(node, entity)
        dentity = hpms.make_depth_entity("DepthCube.mesh")
        dnode = hpms.make_node("DepthCubeNode")
        hpms.set_node_entity(dnode, dentity)
        back = hpms.make_background("Derceto.png")
        hpms_title = hpms.make_overlay("HPMS.png", 0, 0, 0)
        cursor = hpms.make_overlay("Cursor.png", 0, 0, 100)

        text = hpms.make_textarea("HPMSText", "Alagard", 14, 20, 80, 550, 400, 10, hpms.vec4(1.0, 0.8, 0.1, 1.0))
        rem = hpms.stream_text(text, "Richard Prinn alzò la testa.", 8)
        text.color = hpms.vec4(1.0, 0.8, 0.1, 1.0)

        text2 = hpms.make_textarea("HPMSText2", "Alagard", 14, 0, 20, 320, 200, 10, hpms.vec4(1.0, 0.8, 0.1, 1.0))
        text2.text = 'Text example number 2'

        light = hpms.make_light(hpms.vec3(0, 0, 0))
        light.position = hpms.vec3(5, 5, 5)

    end,
    input = function(keys, mouse_buttons, x, y)
        -- Input function callback.
        if keys ~= nil then
            if hpms.key_action_performed(keys, 'ESC', 1) then
                scene.quit = true
            end
        end
        mx = limitx(x)
        my = limity(y)

    end,
    update = function(tpf)
        -- Update loop function callback.
        local rot = node.rotation
        local nrot = hpms.from_euler(0, tpf, 0)
        node.rotation = hpms.quat_mul(rot, nrot)
        cursor.position = hpms.vec3(mx - 30, my - 20, 100)
        --text.position = hpms.vec3(mx - 50, my + 40, 100)

    end,
    cleanup = function()
        -- Close function callback.
        hpms.delete_textarea(text2)
        hpms.delete_textarea(text)
        hpms.delete_light(light)
        hpms.delete_overlay(hpms_title)
        hpms.delete_overlay(cursor)
        hpms.delete_background(back)
        hpms.delete_node(dnode)
        hpms.delete_entity(dentity)
        hpms.delete_node(node)
        hpms.delete_entity(entity)
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