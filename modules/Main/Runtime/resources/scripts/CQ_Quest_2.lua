-- Scene script.
dependencies = { 'CQ_Utils.lua' }
scene = {
    name = "Scene_00",
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

        back1 = hpms.make_background("LockQuest2.png")
        back1.visible = true

        cursor = hpms.make_overlay("TextCursor.png", 0, 0, 100)

        clicked = false

        textarea1 = hpms.make_textarea("N1", "BlueHighway", 42, 30, 40, 50, 80, 10, hpms.vec4(0.8, 0.8, 0.8, 1.0))
        textarea2 = hpms.make_textarea("N2", "BlueHighway", 42, 105, 40, 50, 80, 10, hpms.vec4(0.8, 0.8, 0.8, 1.0))
        textarea3 = hpms.make_textarea("N3", "BlueHighway", 42, 180, 40, 50, 80, 10, hpms.vec4(0.8, 0.8, 0.8, 1.0))
        textarea4 = hpms.make_textarea("N4", "BlueHighway", 42, 255, 40, 50, 80, 10, hpms.vec4(0.8, 0.8, 0.8, 1.0))


        current_index = 0


        cursx = 15
        cursy = 110
        curr_lock = 1
        num_by_lock = {}
        num_by_lock[1] = 0
        num_by_lock[2] = 0
        num_by_lock[3] = 0
        num_by_lock[4] = 0


    end,
    input = function(keys, mouse_buttons, x, y)
        -- Input function callback.


        speed = 0
        rotate = 0


        -- Input function callback.


        if keys ~= nil then
            if hpms.key_action_performed(keys, '0', 1) then
                num_by_lock[curr_lock] = 0
            end
            if hpms.key_action_performed(keys, '1', 1) then
                num_by_lock[curr_lock] = 1
            end
            if hpms.key_action_performed(keys, '2', 1) then
                num_by_lock[curr_lock] = 2
            end
            if hpms.key_action_performed(keys, '3', 1) then
                num_by_lock[curr_lock] = 3
            end
            if hpms.key_action_performed(keys, '4', 1) then
                num_by_lock[curr_lock] = 4
            end
            if hpms.key_action_performed(keys, '5', 1) then
                num_by_lock[curr_lock] = 5
            end
            if hpms.key_action_performed(keys, '6', 1) then
                num_by_lock[curr_lock] = 6
            end
            if hpms.key_action_performed(keys, '7', 1) then
                num_by_lock[curr_lock] = 7
            end
            if hpms.key_action_performed(keys, '8', 1) then
                num_by_lock[curr_lock] = 8
            end
            if hpms.key_action_performed(keys, '9', 1) then
                num_by_lock[curr_lock] = 9
            end

            if hpms.key_action_performed(keys, 'ESC', 1) then
                scene.quit = true
            end
            if hpms.key_action_performed(keys, 'E', 1) then
                -- print("enter")
                action = true
            end

            if hpms.key_action_performed(keys, 'B', 1) and not fading then
                st_quit_qt2 = true
            end
            if hpms.key_action_performed(keys, 'UP', 2) then
                speed = 0.2
            elseif hpms.key_action_performed(keys, 'DOWN', 2) then
                speed = -0.2
            else
                speed = 0
            end

            if hpms.key_action_performed(keys, 'RIGHT', 1) then
                if (cursx >= 220) then
                    cursx = 15
                    cursy = 110
                    curr_lock = 1
                else
                    cursx = cursx + 70
                    cursy = 110
                    curr_lock = curr_lock + 1
                end
            elseif hpms.key_action_performed(keys, 'LEFT', 1) then
                if (cursx <= 20) then
                    cursx = 225
                    cursy = 110
                    curr_lock = 4
                else
                    cursx = cursx - 70
                    cursy = 110
                    curr_lock = curr_lock - 1
                end
            else
                rotate = 0
            end
            if hpms.key_action_performed(keys, 'I', 1) then
                -- TODO Inventary
            end
            if hpms.mbutton_action_performed(mouse_buttons, 'LEFT', 1) then
                clicked = true
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

            cursor.position = hpms.vec3(cursx, cursy, 5)

            hpms.stream_text(textarea1, tostring(num_by_lock[1]), 1)
            hpms.stream_text(textarea2, tostring(num_by_lock[2]), 1)
            hpms.stream_text(textarea3, tostring(num_by_lock[3]), 1)
            hpms.stream_text(textarea4, tostring(num_by_lock[4]), 1)

            fade_in(tpf, function()
                -- Nothing to do
            end)

            if num_by_lock[1] == 2 and num_by_lock[2] == 2 and
                    num_by_lock[3] == 6 and num_by_lock[4] == 5 then
                st_quest_2_done = true
                st_key2 = true
            end


            if st_quit_qt2 then
                cursor.visible = false
                textarea1.text = ''
                textarea2.text = ''
                textarea3.text = ''
                textarea4.text = ''
                fade_out(tpf, function()
                    st_quit_qt2 = false
                    scene.next = 'CQ_Home.lua'
                    scene.finished = true

                end)
            end

            if st_quest_2_done and not st_quit_qt2 then
                msg_box('C\'era una chiave nascosta qui!', function()

                    st_quit_qt2 = true
                end)
            end

            -- consume pending actions
            action = false

        end


    end,
    cleanup = function()
        -- Close function callback.
        -- TODO BUG SU CANCELLAZIONE OVERLAY

        hpms.delete_overlay(cursor)
        hpms.delete_textarea(textarea1)
        hpms.delete_textarea(textarea2)
        hpms.delete_textarea(textarea3)
        hpms.delete_textarea(textarea4)
        hpms.delete_background(back1)


    end
}