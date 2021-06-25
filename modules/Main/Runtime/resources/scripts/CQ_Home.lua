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
        depth = hpms.make_depth_entity("HomeDepth.mesh")
        depthnode = hpms.make_node("DepthNode")

        cipo_node.scale = hpms.vec3(0.3, 0.3, 0.3)



        hpms.set_node_entity(cipo_node, cipo)
        hpms.set_node_entity(depthnode, depth)

        map = hpms.make_walkmap("Home.walkmap")

        --hpms.debug_draw_walkmap(map)
        collisor = hpms.make_node_collisor(cipo_node, map, 0)
        collisor.position = st_player_pos
        collisor.rotation = st_player_rot
        create_backgrounds_1()
        reset_backgrounds_1()

        light = hpms.make_light(hpms.vec3(0, 0, 0))

        animating = false
        hpms.play_anim(cipo, "my_animation")
        --hpms.debug_draw_aabb(cipo)

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

        hpms.debug_draw_clear()
        hpms.debug_draw_aabb(cipo)

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
        hpms.delete_background(back4)
        hpms.delete_background(back5)
        hpms.delete_background(back6)
        hpms.delete_background(back7)
        hpms.delete_background(back8)
        hpms.delete_background(back9)
        hpms.delete_background(back10)
        hpms.delete_background(back11)
        hpms.delete_background(back12)
        hpms.delete_node(doornode)
        hpms.delete_entity(door)
        hpms.delete_node(cipo_node)
        hpms.delete_entity(weapon)
        hpms.delete_entity(cipo)
        print('CLEAN DONE')
    end
}

function check_triggers_1(tpf)
    -- TRIGGER OGGETTO T_Bagno_Doccia
    trigger_dist(hpms.vec3(0.24518108367919922, 0.2266765832901001, 0.09647953510284424), 0.2, cipo_node, function()
        if st_neib_killed then
            msg_box('Credo di aver fatto abbastanza danni... forse ho esagerato', function()

            end)

        elseif st_acid and st_sdriver then
            msg_box('Ok con il cacciavite posso aprire la griglia di scarico...e ora... proviamo a versare lo sgorgatore... blahhh... che puzza!', function()
                st_acid = true
                st_neib_killed = true
            end)

        elseif st_sdriver and not st_acid then
            msg_box('Col cacciavite potrei aprire la griglia, ma che ci faccio una volta aperta?', function()

            end)

        else
            msg_box('Sembra potersi svitare in qualche modo...', function()

            end)
        end

    end)
    -- TRIGGER OGGETTO T_Bagno_Vasca
    trigger_dist(hpms.vec3(0.3330761790275574, 0.7540470361709595, 0.09647953510284424), 0.3, cipo_node, function()
        msg_box('Ho appena pulito la vasca e si e\' gia\' riempita di polvere... uffi!', function()
            -- TODO
        end)
    end)
    -- TRIGGER OGGETTO T_Cucina_Forno
    trigger_dist(hpms.vec3(-0.9252113699913025, 0.6568999290466309, 0.09647953510284424), 0.2, cipo_node, function()
        msg_box('Il forno, con questo caldo non ho intenzione di accenderlo per nessun motivo!', function()
            -- TODO
        end)
    end)
    -- TRIGGER OGGETTO T_Cucina_Mobile
    trigger_dist(hpms.vec3(-0.8465684056282043, 0.43022316694259644, 0.09647953510284424), 0.2, cipo_node, function()
        if st_acid then
            msg_box('Non mi serve nient\'altro', function()

            end)

        elseif st_key2 then
            msg_box('Aperto, ho trovato UN DISOTTURANTE', function()
                st_acid = true

            end)

        else
            msg_box('Non posso aprirlo, e\' chiuso a chiave.', function()
                -- TODO
            end)
        end


    end)
    -- TRIGGER OGGETTO T_Sala_Cornice_El
    trigger_dist(hpms.vec3(-1.0234955549240112, -0.41203904151916504, 0.019540950655937195), 0.2, cipo_node, function()
        if not st_quest_2_done then
            msg_box('Uno schermo acceso, ci sono dei simboli sopra...', function()
                st_look_qt2 = true

            end)

        else
            msg_box('Non ho altro da fare qui', function()

            end)
        end
    end)
    -- TRIGGER OGGETTO T_Sala_Lib3
    trigger_dist(hpms.vec3(-0.01887434720993042, 0.03534939885139465, 0.09953634440898895), 0.15, cipo_node, function()
        msg_box('Un libro rosso... c\'e\' una frase evidenziata... \'Mi apro alla chiusura\'', function()
            -- TODO
        end)
    end)
    -- TRIGGER OGGETTO T_Sala_Lib4
    trigger_dist(hpms.vec3(-0.6406164765357971, 0.03534939885139465, 0.09953634440898895), 0.15, cipo_node, function()
        msg_box('Un libro verde... c\'e\' una frase evidenziata... \'La Grandezza ispira l\'Invidia, l\'Invidia genera Rancore, il Rancore produce Menzogne\'', function()
            -- TODO
        end)
    end)

    -- TRIGGER OGGETTO T_Sala_Lib5
    trigger_dist(hpms.vec3(-0.8460134267807007, 0.03534939885139465, 0.09953634440898895), 0.15, cipo_node, function()
        msg_box('Un libro giallo... c\'e\' una frase evidenziata... \'Sono le scelte che facciamo, che dimostrano quel che siamo veramente, molto piu\' delle nostre capacita\'\'', function()
            -- TODO
        end)
    end)
    -- TRIGGER OGGETTO T_Sala_TV
    trigger_dist(hpms.vec3(-0.7216647863388062, -0.41203904151916504, 0.019540950655937195), 0.2, cipo_node, function()
        msg_box('Non mi sembra il momento di guardar la TV', function()
            -- TODO
        end)
    end)
    -- TRIGGER OGGETTO T_Sgab_Mobile
    trigger_dist(hpms.vec3(0.4070930480957031, -0.8049339056015015, 0.09647953510284424), 0.2, cipo_node, function()
        if st_sdriver then
            msg_box('Non mi serve nient\'altro', function()

            end)

        elseif st_key1 then
            msg_box('Aperto, ho trovato UN CACCIAVITE', function()
                st_sdriver = true

            end)

        else
            msg_box('Ma... e\' chiuso a chiave, chissa\' dove l\'ho messa...', function()

            end)
        end

    end)
    -- TRIGGER OGGETTO T_Stanza_Letto
    trigger_dist(hpms.vec3(1.1324589252471924, -0.7248109579086304, 0.09647953510284424), 0.2, cipo_node, function()
        msg_box('Credo di aver dormito anche troppo... e in effetti e\' molto strano, considerando che riuscire a dormire fino alle 7 e\' un\'impresa.', function()
            -- TODO
        end)
    end)
    -- TRIGGER OGGETTO T_Stanza_Scriv
    trigger_dist(hpms.vec3(1.0566445589065552, 0.2908232808113098, 0.09233757108449936), 0.3, cipo_node, function()
        msg_box('La scrivania, l\'ho appena riordinata, speriamo duri.', function()
            -- TODO
        end)
    end)
    -- TRIGGER OGGETTO T_Stanza_Tab
    trigger_dist(hpms.vec3(0.6716316342353821, -0.6367788314819336, 0.09647953510284424), 0.2, cipo_node, function()
        if not st_quest_1_done then
            msg_box('Non me lo ricordavo cosi\' questo...', function()
                st_look_qt1 = true

            end)

        else
            msg_box('Non ho altro da fare qui', function()

            end)
        end
    end)
    -- TRIGGER OGGETTO T_Stanza_Lib7
    trigger_dist(hpms.vec3(1.1605558395385742, -0.059480760246515274, 0.08970452100038528), 0.1, cipo_node, function()
        msg_box('Un libro arancio... c\'e\' una frase evidenziata... \'E\' stato il tuo cuore a salvarti.\'\'', function()
            -- TODO
        end)
    end)
    -- TRIGGER OGGETTO T_Stanza_Lib6
    trigger_dist(hpms.vec3(1.06138, -0.443235, 0.02260158210992813), 0.2, cipo_node, function()
        msg_box('Un libro azzurro... c\'e\' una frase evidenziata... \'Non vado in cerca di guai. Di solito sono i guai che trovano me.\'\'', function()
            -- TODO
        end)
    end)
    -- TRIGGER OGGETTO T_Stanza_Lib2
    trigger_dist(hpms.vec3(1.3015581369400024, 0.02711903676390648, 0.08970452100038528), 0.1, cipo_node, function()
        msg_box('Un libro blu... c\'e\' una frase evidenziata... \'Non serve a niente rifugiarsi nei sogni e dimenticarsi di vivere\'', function()
            -- TODO
        end)
    end)
    -- TRIGGER OGGETTO T_Stanza_Lib1
    trigger_dist(hpms.vec3(0.9385051131248474, -0.059480760246515274, 0.08970452100038528), 0.1, cipo_node, function()
        msg_box('Un libro bianco... c\'e\' una frase evidenziata... \'Capire e\' il primo passo per accettare, e solo accettando si puo\' guarire\'', function()
            -- TODO
        end)
    end)
    -- TRIGGER OGGETTO T_Sala_Ingresso
    trigger_dist(hpms.vec3(-1.052520990371704, -0.04498466104269028, 0.09953634440898895), 0.2, cipo_node, function()
        if st_neib_killed then
            msg_box('Bene, ora credo di poter scendere senza nessun disturbo...', function()
                st_go_to_basement = true
            end)

        elseif st_esci_casa == 0 then
            msg_box('Prima di andare a vedere in cantina forse e\' meglio controllare bene in casa...', function()
                st_esci_casa = 1
            end)
        elseif st_esci_casa == 1 then
            msg_box('In casa non c\'e\' nessuno, andiamo in cantina, sperando di non trovare nessuno...', function()
                st_esci_casa = 2
                st_go_to_basement = true
            end)
        elseif st_esci_casa == 2 then
            msg_box('Non posso scendere di nuovo, devo prima trovare un modo per liberarmi del vicino...', function()

            end)
        end
    end)

    if st_look_qt1 then
        fade_out(tpf, function()
            st_look_qt1 = false
            scene.next = 'CQ_Quest_1.lua'
            scene.finished = true

        end)
    end

    if st_look_qt2 then
        fade_out(tpf, function()
            st_look_qt2 = false
            scene.next = 'CQ_Quest_2.lua'
            scene.finished = true

        end)
    end

    if st_go_to_basement then
        fade_out(tpf, function()
            st_go_to_basement = false
            if not st_neib_killed then
                scene.next = 'CQ_Catched.lua'
                scene.finished = true
            else
                scene.next = 'CQ_Basement.lua'
                scene.finished = true
            end
        end)
    end

end

function reset_backgrounds_1()
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

function create_backgrounds_1()
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
        cam.position = hpms.vec3(0.6499999761581421, -0.37614867091178894, 0.49240946769714355)
        light.position = hpms.vec3(0.6499999761581421, -0.37614867091178894, 0.49240946769714355)
        cam.rotation = hpms.quat(0.3265744745731354, 0.26128023862838745, -0.5674629211425781, -0.709272563457489)
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
        cam.rotation = hpms.quat(0.51259, 0.430114, -0.47768, -0.569276)
        back11.visible = true
    end
    if sampled == 'S_12' then
        cam.position = hpms.vec3(0.05000000074505806, 0.949999988079071, 0.7000000476837158)
        light.position = hpms.vec3(0.05000000074505806, 0.949999988079071, 0.7000000476837158)
        cam.rotation = hpms.quat(0.4330126643180847, 0.25, 0.4330127239227295, 0.75)
        back12.visible = true
    end
    if sampled == 'S_2' then
        cam.position = hpms.vec3(1.3504865169525146, -1.399999976158142, 0.5)
        light.position = hpms.vec3(1.3504865169525146, -1.399999976158142, 0.5)
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
