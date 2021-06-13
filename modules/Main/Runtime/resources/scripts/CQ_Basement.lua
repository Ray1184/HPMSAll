-- Scene script.
dependencies = { 'CQ_Utils.lua' }
scene = {
    name = "Scene_01",
    version = "1.0.0",
    quit = false,
    finished = false,
    next = 'undef',
    setup = function()
        -- Init function callback.

        init_all()

        cipo = hpms.make_entity("EY_DummyAnim.mesh")
        cipo_node = hpms.make_node("DummyAnimNode")
        cipohead = hpms.make_entity("CipoD.mesh")
        hpms.set_bone_node("Head", cipohead, cipo, hpms.vec3(0, 0.2, 0), hpms.from_euler(0, 0, 0))


        cipo2 = hpms.make_entity("EY_DummyAnim.mesh")
        cipo_node2 = hpms.make_node("DummyAnimNode2")
        cipohead2 = hpms.make_entity("CipoN.mesh")
        hpms.set_bone_node("Head", cipohead2, cipo2, hpms.vec3(0, 0.2, 0), hpms.from_euler(0, 0, 0))
        cipo_node2.position = hpms.vec3(-1.3039803504943848, 2.3961775302886963, 0.0)
        cipo_node2.rotation = hpms.from_euler(0.0, 0.0, 90.0)


        endadv = hpms.make_overlay("End.png", 0, 0, 150)
        endadv.visible = false

        depth = hpms.make_depth_entity("BasementDepth.mesh")
        depthnode = hpms.make_node("DepthNode")

        cipo_node.scale = hpms.vec3(0.3, 0.3, 0.3)
        cipo_node2.scale = hpms.vec3(0.3, 0.3, 0.3)

        hpms.set_node_entity(cipo_node, cipo)
        hpms.set_node_entity(cipo_node2, cipo2)
        hpms.set_node_entity(depthnode, depth)

        map = hpms.make_walkmap("Basement.walkmap")

        st_player_pos = hpms.vec3(-1.46471, 1.75764, 0)

        --hpms.debug_draw_walkmap(map)
        collisor = hpms.make_node_collisor(cipo_node, map, 0)
        collisor.position = st_player_pos
        collisor.rotation = hpms.from_euler(0.0, 0.0, 90.0)
        create_backgrounds_1()
        reset_backgrounds_1()

        light = hpms.make_light(hpms.vec3(0, 0, 0))

        animating = false
        hpms.play_anim(cipo, "my_animation")
        game_end = false


    end,
    input = function(keys, mouse_buttons, x, y)
        -- Input function callback.


        speed = 0
        rotate = 0

        if keys ~= nil then
            if hpms.key_action_performed(keys, 'ESC', 1) then
                scene.quit = true
            end
            if hpms.key_action_performed(keys, 'E', 1) then
                -- print("enter")
                action = true
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
            end
        end

        mx = limitx(x)
        my = limity(y)


    end,
    update = function(tpf)

        if block_time then
            if action then
                flush_message_box(textbuffer)
            end
        else
            if speed == 0 and rotate == 0 then
                animating = false--hpms.stop_anim(cipo)
            else
                animating = true
            end
            fade_in(tpf, function()
                -- Nothing to do
            end)
            hpms.update_collisor(collisor)
            if not fading then

                if animating then
                    hpms.update_anim(cipo, "my_animation", tpf / 2)
                end
                f_move_collisor_towards_direction(collisor, speed * tpf)
                f_rotate(cipo_node, 0, 0, rotate * tpf * 10)
            end

            sector = collisor.sector
            if sector ~= nil and sector.id ~= nil then
                --print(sector.id)
                sampled = sector.id
                reset_backgrounds_1()
                change_view()
            end

            check_triggers_1(tpf)

            -- consume pending actions
            action = false

            st_player_pos = collisor.position
            st_player_rot = collisor.rotation
        end


    end,
    cleanup = function()
        -- Close function callback.
        --hpms.delete_textarea(text2)
        hpms.delete_light(light)
        hpms.delete_textarea(text)
        hpms.delete_collisor(collisor)
        hpms.delete_walkmap(map)
        hpms.delete_background(back1)
        hpms.delete_background(back2)
        hpms.delete_background(back3)

        hpms.delete_node(doornode)
        hpms.delete_entity(door)
        hpms.delete_node(cipo_node)
        hpms.delete_entity(weapon)
        hpms.delete_entity(cipo)
        print('CLEAN DONE')
    end
}

function check_triggers_1(tpf)
    -- TRIGGER OGGETTO T_Cn
    trigger_dist(hpms.vec3(-1.1117143630981445, 2.5647716522216797, 0.09647953510284424), 0.3, cipo_node, function()
        msg_box('Amore ma cosa ci fai qui? Non ti trovavo da nessuna parte!', function()
            msg_box('Complimenti amore, hai risolto tutti gli enigmi e mi hai trovato! BUON COMPLETANNO!!!', function()
                msg_box('Era una caccia al tesoro?', function()
                    msg_box('Esatto, e hai trovato il tesoro! Ehehehe, scherzi a parte, il mio alter-ego ti dara\' il tuo regalo di compleanno, sperando apprezzerai, e sperando tu abbia apprezzato questo tentativo molto buggoso di avventura virtuale sviluppata appositamente per te! Ora andiamo amore, dopo che avrai aperto il tuo regalo ci aspetta una bella abbuffata!', function()
                        msg_box('Ehm amore... abbiamo un piccolo problema con il vicino...', function()
                            game_end = true
                        end)
                    end)
                end)
            end)
        end)
    end)
    -- TRIGGER OGGETTO T_Skel
    trigger_dist(hpms.vec3(-0.5463956594467163, 1.7576429843902588, 0.09647953510284424), 0.2, cipo_node, function()
        msg_box('Ops... forse questa volta ho esagerato un po\'...', function()

        end)
    end)

    if game_end then
        fade_out(tpf, function()
            endadv.visible = true
        end)
    end

end

function reset_backgrounds_1()
    back1.visible = false
    back2.visible = false
    back3.visible = false

end

function create_backgrounds_1()
    back1 = hpms.make_background("B1.png")
    back2 = hpms.make_background("B2.png")
    back3 = hpms.make_background("B3.png")

end

function change_view()
    if sampled ~= nil then
        print(sampled)
    end
    if sampled == 'B_1' then
        cam.position = hpms.vec3(-0.3539507985115051, 1.7715107202529907, 0.2900119423866272)
        light.position = hpms.vec3(-0.3539507985115051, 1.7715107202529907, 0.2900119423866272)
        cam.rotation = hpms.quat(-0.3535531163215637, -0.3535531461238861, -0.6123725771903992, -0.6123725771903992)
        back1.visible = true
    end
    if sampled == 'B_2' then
        cam.position = hpms.vec3(-1.4685640335083008, 1.4523136615753174, 0.2668105661869049)
        light.position = hpms.vec3(-1.4685640335083008, 1.4523136615753174, 0.2668105661869049)
        cam.rotation = hpms.quat(0.5792279243469238, 0.5792279839515686, -0.4055798053741455, -0.4055797755718231)
        back2.visible = true
    end
    if sampled == 'B_3' then
        cam.position = hpms.vec3(-0.46740126609802246, 2.4049699306488037, 0.35668063163757324)
        light.position = hpms.vec3(-0.46740126609802246, 2.4049699306488037, 0.35668063163757324)
        cam.rotation = hpms.quat(0.4999999701976776, 0.5, 0.5, 0.5)
        back3.visible = true
    end

end
