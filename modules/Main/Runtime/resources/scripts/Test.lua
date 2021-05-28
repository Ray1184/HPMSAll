-- Scene script.
scene = {
    name = "Scene_01",
    version = "1.0.0",
    quit = false,
    finished = false,
    next = 'undef',
    setup = function()
        -- Init function callback.
        hpms.set_ambient(hpms.vec3(0.1, 0.1, 0.1))
        cam = hpms.get_camera()
        cam.near = 0.05
        cam.far = 50
        cam.fovy = hpms.to_radians(45)
        mx = 0
        my = 0

        entity = hpms.make_entity("EY_DummyAnim.mesh")
        node = hpms.make_node("DummyAnimNode")
        depth = hpms.make_depth_entity("HomeDepth.mesh")
        depthnode = hpms.make_node("DepthNode")

        node.scale = hpms.vec3(0.3, 0.3, 0.3)
        hpms.play_anim(entity, "my_animation")

        hpms.set_node_entity(node, entity)
        hpms.set_node_entity(depthnode, depth)

        map = hpms.make_walkmap("Home.walkmap")

        hpms.debug_draw_walkmap(map)
        collisor = hpms.make_node_collisor(node, map, 0)
        collisor.position = hpms.vec3(1, -0.7, 0.0)

        create_backgrounds()

        cursor = hpms.make_overlay("Cursor.png", 0, 0, 100)

        light = hpms.make_light(hpms.vec3(0, 0, 0))
        speed = 0
        rotate = 0
        action = false
        block_time = false

        -- MESSAGE MGMT
        msg_showing = false
        textarea = hpms.make_textarea("Footer", "Alagard", 16, 10, 150, 300, 40, 10, hpms.vec4(1, 1, 0.8, 1.0))
        textbuffer = ''


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
            if hpms.key_action_performed(keys, 'E', 1) then
                print("enter")
                action = true
            end
            if hpms.key_action_performed(keys, 'N', 1) then
                scene.next = 'Test_2.lua'
                scene.finished = true
            end
            if hpms.key_action_performed(keys, 'UP', 2) then
                speed = 0.2
            elseif hpms.key_action_performed(keys, 'DOWN', 2) then
                speed = -0.2
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
                msg_box('Mhhh... devo essermi addormentata. Che ore sono? La sveglia non funziona, probabilmente e\' saltata la corrente... Ma... amore dove sei? C\'e\' nessuno?')
            end
        end

        mx = limitx(x)
        my = limity(y)

    end,
    update = function(tpf)

        if block_time then
            if action then
                msg_box(textbuffer)
            end
        else
            cursor.position = hpms.vec3(mx - 30, my - 20, 100)
            hpms.update_anim(entity, "my_animation", tpf / 2)
            hpms.update_collisor(collisor)
            f_move_collisor_towards_direction(collisor, speed * tpf)
            f_rotate(node, 0, 0, rotate * tpf * 10)

            sector = collisor.sector
            if sector ~= nil and sector.id ~= nil then
                --print(sector.id)
                sampled = sector.id
                reset_background()
                change_view()
            end
        end


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
        hpms.delete_background(back2)
        hpms.delete_node(doornode)
        hpms.delete_entity(door)
        hpms.delete_node(node)
        hpms.delete_entity(weapon)
        hpms.delete_entity(entity)
    end
}
--
-- UTILITY FUNCTIONS!!!!!
--
function reset_background()
    back1.visible = false
    back2.visible = false
    back3.visible = false
    back4.visible = false
    back5.visible = false
    back6.visible = false
    back7.visible = false
    back8.visible = false
    back9.visible = false
    back10.visible = false
    back11.visible = false
    back12.visible = false
end

function create_backgrounds()
    back1 = hpms.make_background("S1.png")
    back2 = hpms.make_background("S2.png")
    back3 = hpms.make_background("S3.png")
    back4 = hpms.make_background("S4.png")
    back5 = hpms.make_background("S5.png")
    back6 = hpms.make_background("S6.png")
    back7 = hpms.make_background("S7.png")
    back8 = hpms.make_background("S8.png")
    back9 = hpms.make_background("S9.png")
    back10 = hpms.make_background("S10.png")
    back11 = hpms.make_background("S11.png")
    back12 = hpms.make_background("S12.png")

end

function change_view()
    if sampled == 'S_1' then
        cam.position = hpms.vec3(0.6499999761581421, -0.25, 0.699999988079071)
        light.position = hpms.vec3(0.6499999761581421, -0.25, 0.699999988079071)
        cam.rotation = hpms.quat(0.34618860483169556, 0.24240386486053467, -0.5198367834091187, -0.7424038648605347)
        back1.visible = true
    end
    if sampled == 'S_10' then
        cam.position = hpms.vec3(0.10000000149011612, -0.10000000149011612, 0.4000000059604645)
        light.position = hpms.vec3(0.10000000149011612, -0.10000000149011612, 0.4000000059604645)
        cam.rotation = hpms.quat(0.49240389466285706, 0.41317591071128845, 0.49240386486053467, 0.5868241190910339)
        back10.visible = true
    end
    if sampled == 'S_11' then
        cam.position = hpms.vec3(-1.100000023841858, 0.0, 0.5)
        light.position = hpms.vec3(-1.100000023841858, 0.0, 0.5)
        cam.rotation = hpms.quat(0.4115953743457794, 0.34536948800086975, -0.5421215891838074, -0.6460753679275513)
        back11.visible = true
    end
    if sampled == 'S_12' then
        cam.position = hpms.vec3(0.05000000074505806, 0.949999988079071, 0.7000000476837158)
        light.position = hpms.vec3(0.05000000074505806, 0.949999988079071, 0.7000000476837158)
        cam.rotation = hpms.quat(0.4330126643180847, 0.25, 0.4330127239227295, 0.75)
        back12.visible = true
    end
    if sampled == 'S_2' then
        cam.position = hpms.vec3(1.4500000476837158, -1.399999976158142, 0.5)
        light.position = hpms.vec3(1.4500000476837158, -1.399999976158142, 0.5)
        cam.rotation = hpms.quat(0.7077327966690063, 0.5938583016395569, 0.24598416686058044, 0.2931525409221649)
        back2.visible = true
    end
    if sampled == 'S_3' then
        cam.position = hpms.vec3(0.4000000059604645, -0.699999988079071, 0.5)
        light.position = hpms.vec3(0.4000000059604645, -0.699999988079071, 0.5)
        cam.rotation = hpms.quat(0.8660253882408142, 0.5, 0.0, 0.0)
        back3.visible = true
    end
    if sampled == 'S_4' then
        cam.position = hpms.vec3(0.4000000059604645, -0.20000000298023224, 0.5)
        light.position = hpms.vec3(0.4000000059604645, -0.20000000298023224, 0.5)
        cam.rotation = hpms.quat(0.8652011156082153, 0.4995241165161133, 0.021809693425893784, 0.03777549788355827)
        back4.visible = true
    end
    if sampled == 'S_5' then
        cam.position = hpms.vec3(0.4000000059604645, 0.4000000059604645, 0.6499999761581421)
        light.position = hpms.vec3(0.4000000059604645, 0.4000000059604645, 0.6499999761581421)
        cam.rotation = hpms.quat(0.48296287655830383, 0.129409521818161, 0.2241438776254654, 0.8365163207054138)
        back5.visible = true
    end
    if sampled == 'S_6' then
        cam.position = hpms.vec3(1.2999999523162842, 0.8999999761581421, 0.30000001192092896)
        light.position = hpms.vec3(1.2999999523162842, 0.8999999761581421, 0.30000001192092896)
        cam.rotation = hpms.quat(0.0962340384721756, 0.0881822481751442, 0.66981041431427, 0.7309698462486267)
        back6.visible = true
    end
    if sampled == 'S_7' then
        cam.position = hpms.vec3(0.699999988079071, -0.125, 0.6000000238418579)
        light.position = hpms.vec3(0.699999988079071, -0.125, 0.6000000238418579)
        cam.rotation = hpms.quat(0.8043566942214966, 0.5124317407608032, -0.16156910359859467, -0.2536126971244812)
        back7.visible = true
    end
    if sampled == 'S_8' then
        cam.position = hpms.vec3(0.30000001192092896, -0.5, 0.05000000074505806)
        light.position = hpms.vec3(0.30000001192092896, -0.5, 0.05000000074505806)
        cam.rotation = hpms.quat(-0.035628192126750946, -0.07571376115083694, 0.9016537070274353, 0.42428603768348694)
        back8.visible = true
    end
    if sampled == 'S_9' then
        cam.position = hpms.vec3(-1.100000023841858, -1.2000000476837158, 0.3499999940395355)
        light.position = hpms.vec3(-1.100000023841858, -1.2000000476837158, 0.3499999940395355)
        cam.rotation = hpms.quat(0.6644627451896667, 0.6644633412361145, -0.24184486269950867, -0.24184465408325195)
        back9.visible = true
    end
end

function msg_box(message)
    textbuffer = hpms.stream_text(textarea, message, 3)
    action = false
    if textbuffer == '' and message == '' then
        block_time = false
    else
        block_time = true
    end

end

--
-- MOVE FUNCTIONS
--
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

