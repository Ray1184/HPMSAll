-- Scene script.

dependencies = {'CQ_Utils.lua'}
scene = {
    name = "Scene_02",
    version = "1.0.0",
    quit = false,
    finished = false,
    next = 'undef',
    setup = function()
        -- Init function callback.
        -- INIT VARS
        init_all()

        hpms.set_ambient(hpms.vec3(0.1, 0.1, 0.1))
        cam = hpms.get_camera()
        cam.near = 0.05
        cam.far = 50
        cam.fovy = hpms.to_radians(45)


        light = hpms.make_light(hpms.vec3(0, 0, 0))

        textarea = hpms.make_textarea("Footer", "Alagard", 16, 10, 150, 300, 40, 10, hpms.vec4(1, 1, 0.8, 1.0))



    end,
    input = function(keys, mouse_buttons, x, y)
        -- Input function callback.


        speed = 0
        rotate = 0


        -- Input function callback.


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

            msg_box('Oh no!', function()
                msg_box('UEEEE MI SCUSHH SIGNORIII\' IAMM FACENN A MO NA RIUNIONE PER I TURNI DELLE SCHALE, CHE C\'HA DIECI MINUTI??', function()
                    msg_box('....', function()
                        msg_box('Devi trovare un modo per liberarti del vicino prima di scendere, con le buone... o con le cattive...', function()
                            scene.next = 'CQ_Home.lua'
                            scene.finished = true
                        end)
                    end)
                end)
            end)

            -- consume pending actions
            action = false
        end


    end,
    cleanup = function()
        -- Close function callback.
        --hpms.delete_textarea(text2)

    end
}
