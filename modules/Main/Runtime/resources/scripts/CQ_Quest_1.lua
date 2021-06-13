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

        load_switches()

        light = hpms.make_light(hpms.vec3(0, 0, 0))

        back1 = hpms.make_background("LifeTreeQuest2.png")
        back1.visible = true

        cursor = hpms.make_overlay("Cursor.png", 0, 0, 100)

        clicked = false

        current_index = 0

        codes = {}
        codes[1] = {}
        codes[2] = {}
        codes[3] = {}
        codes[4] = {}
        codes[5] = {}
        codes[6] = {}
        codes[7] = {}

        for i = 1, 7 do
            for j = 1, 7 do
                codes[i][j] = false

            end

        end


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

            if hpms.key_action_performed(keys, 'B', 1) and not fading then
                st_quit_qt1 = true
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

            fade_in(tpf, function()
                -- Nothing to do
            end)

            cursor.position = hpms.vec3(mx - 30, my - 20, 100)



            for i = 1, 7 do
                pos = switches[i][1].position -- basta prendere il primo
                check = mouse_in_area(pos.x + 15, pos.y + 15, 15)
                if check and clicked then
                    hide_switches(i)
                    if (current_index == 7) then
                        current_index = 0
                    end
                    current_index = current_index + 1
                    switches[i][current_index].visible = true
                    codes[i][current_index] = true
                end
            end
            clicked = false

            if codes[7][2] == true and codes[6][4] == true and codes[2][1] == true and codes[5][3] == true and
                    codes[3][6] == true and codes[1][5] == true and codes[4][7] == true then
                st_quest_1_done = true
                st_key1 = true
            end

            if st_quit_qt1 then
                cursor.visible = false
                for i = 1, 7 do
                    hide_switches(i)

                end
                fade_out(tpf, function()
                    st_quit_qt1 = false
                    scene.next = 'CQ_Home.lua'
                    scene.finished = true

                end)
            end

            if st_quest_1_done and not st_quit_qt1 then
                msg_box('E\' uscita una chiave da dietro il quadro!', function()

                    st_quit_qt1 = true
                end)
            end

            -- consume pending actions
            action = false

        end


    end,
    cleanup = function()
        -- Close function callback.
        hpms.delete_background(back1)
        for i = 1, 7 do
            hide_switches(i)
            for j = 1, 7 do
                hpms.delete_overlay(switches[i][j])
            end
        end

    end
}
function hide_switches(index)
    for j = 1, 7 do
        switches[index][j].visible = false
        codes[index][j] = false

    end
end

function load_switches()
    switches = {}
    switches[1] = {}
    switches[2] = {}
    switches[3] = {}
    switches[4] = {}
    switches[5] = {}
    switches[6] = {}
    switches[7] = {}

    switches[1][1] = hpms.make_overlay("S_Yellow.png", 126, 41, 5)
    switches[1][1].visible = false
    switches[1][2] = hpms.make_overlay("S_Red.png", 126, 41, 5)
    switches[1][2].visible = false
    switches[1][3] = hpms.make_overlay("S_Orange.png", 126, 41, 5)
    switches[1][3].visible = false
    switches[1][4] = hpms.make_overlay("S_Green.png", 126, 41, 5)
    switches[1][4].visible = false
    switches[1][5] = hpms.make_overlay("S_Blue.png", 126, 41, 5)
    switches[1][5].visible = false
    switches[1][6] = hpms.make_overlay("S_LightBlue.png", 126, 41, 5)
    switches[1][6].visible = false
    switches[1][7] = hpms.make_overlay("S_White.png", 126, 41, 5)
    switches[1][7].visible = false

    switches[2][1] = hpms.make_overlay("S_Yellow.png", 140, 6, 5)
    switches[2][1].visible = false
    switches[2][2] = hpms.make_overlay("S_Red.png", 140, 6, 5)
    switches[2][2].visible = false
    switches[2][3] = hpms.make_overlay("S_Orange.png", 140, 6, 5)
    switches[2][3].visible = false
    switches[2][4] = hpms.make_overlay("S_Green.png", 140, 6, 5)
    switches[2][4].visible = false
    switches[2][5] = hpms.make_overlay("S_Blue.png", 140, 6, 5)
    switches[2][5].visible = false
    switches[2][6] = hpms.make_overlay("S_LightBlue.png", 140, 6, 5)
    switches[2][6].visible = false
    switches[2][7] = hpms.make_overlay("S_White.png", 140, 6, 5)
    switches[2][7].visible = false

    switches[3][1] = hpms.make_overlay("S_Yellow.png", 192, 52, 5)
    switches[3][1].visible = false
    switches[3][2] = hpms.make_overlay("S_Red.png", 192, 52, 5)
    switches[3][2].visible = false
    switches[3][3] = hpms.make_overlay("S_Orange.png", 192, 52, 5)
    switches[3][3].visible = false
    switches[3][4] = hpms.make_overlay("S_Green.png", 192, 52, 5)
    switches[3][4].visible = false
    switches[3][5] = hpms.make_overlay("S_Blue.png", 192, 52, 5)
    switches[3][5].visible = false
    switches[3][6] = hpms.make_overlay("S_LightBlue.png", 192, 52, 5)
    switches[3][6].visible = false
    switches[3][7] = hpms.make_overlay("S_White.png", 192, 52, 5)
    switches[3][7].visible = false

    switches[4][1] = hpms.make_overlay("S_Yellow.png", 104, 88, 5)
    switches[4][1].visible = false
    switches[4][2] = hpms.make_overlay("S_Red.png", 104, 88, 5)
    switches[4][2].visible = false
    switches[4][3] = hpms.make_overlay("S_Orange.png", 104, 88, 5)
    switches[4][3].visible = false
    switches[4][4] = hpms.make_overlay("S_Green.png", 104, 88, 5)
    switches[4][4].visible = false
    switches[4][5] = hpms.make_overlay("S_Blue.png", 104, 88, 5)
    switches[4][5].visible = false
    switches[4][6] = hpms.make_overlay("S_LightBlue.png", 104, 88, 5)
    switches[4][6].visible = false
    switches[4][7] = hpms.make_overlay("S_White.png", 104, 88, 5)
    switches[4][7].visible = false

    switches[5][1] = hpms.make_overlay("S_Yellow.png", 147, 112, 5)
    switches[5][1].visible = false
    switches[5][2] = hpms.make_overlay("S_Red.png", 147, 112, 5)
    switches[5][2].visible = false
    switches[5][3] = hpms.make_overlay("S_Orange.png", 147, 112, 5)
    switches[5][3].visible = false
    switches[5][4] = hpms.make_overlay("S_Green.png", 147, 112, 5)
    switches[5][4].visible = false
    switches[5][5] = hpms.make_overlay("S_Blue.png", 147, 112, 5)
    switches[5][5].visible = false
    switches[5][6] = hpms.make_overlay("S_LightBlue.png", 147, 112, 5)
    switches[5][6].visible = false
    switches[5][7] = hpms.make_overlay("S_White.png", 147, 112, 5)
    switches[5][7].visible = false

    switches[6][1] = hpms.make_overlay("S_Yellow.png", 188, 79, 5)
    switches[6][1].visible = false
    switches[6][2] = hpms.make_overlay("S_Red.png", 188, 79, 5)
    switches[6][2].visible = false
    switches[6][3] = hpms.make_overlay("S_Orange.png", 188, 79, 5)
    switches[6][3].visible = false
    switches[6][4] = hpms.make_overlay("S_Green.png", 188, 79, 5)
    switches[6][4].visible = false
    switches[6][5] = hpms.make_overlay("S_Blue.png", 188, 79, 5)
    switches[6][5].visible = false
    switches[6][6] = hpms.make_overlay("S_LightBlue.png", 188, 79, 5)
    switches[6][6].visible = false
    switches[6][7] = hpms.make_overlay("S_White.png", 188, 79, 5)
    switches[6][7].visible = false

    switches[7][1] = hpms.make_overlay("S_Yellow.png", 166, 37, 5)
    switches[7][1].visible = false
    switches[7][2] = hpms.make_overlay("S_Red.png", 166, 37, 5)
    switches[7][2].visible = false
    switches[7][3] = hpms.make_overlay("S_Orange.png", 166, 37, 5)
    switches[7][3].visible = false
    switches[7][4] = hpms.make_overlay("S_Green.png", 166, 37, 5)
    switches[7][4].visible = false
    switches[7][5] = hpms.make_overlay("S_Blue.png", 166, 37, 5)
    switches[7][5].visible = false
    switches[7][6] = hpms.make_overlay("S_LightBlue.png", 166, 37, 5)
    switches[7][6].visible = false
    switches[7][7] = hpms.make_overlay("S_White.png", 166, 37, 5)
    switches[7][7].visible = false
end
