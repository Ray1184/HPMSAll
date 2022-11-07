-- R_Debug_01
-- Generated with Blend2HPMS batch on date 2021/09/12

dependencies = {
    'Framework.lua',
    'libs/backend/HPMSFacade.lua',
    'libs/input/InputProfile.lua',
    'libs/logic/helpers/Workflow.lua',
    'libs/logic/helpers/WorkflowSequences.lua',
    'inst/gui/Shapes.lua',
    'inst/GameplayConsts.lua',
    'libs/logic/helpers/PuzzleHelper.lua',
    'libs/logic/managers/PuzzleManager.lua',
    'libs/logic/managers/GlobalStateManager.lua',
    'libs/logic/helpers/SceneHelper.lua',
    'libs/logic/GameMechanicsConsts.lua'
}

scene = {
    name = 'P_Debug_01',
    version = '1.0',
    quit = false,
    finished = false,
    next = 'TBD',
    setup = function()

        context_disable_dummy()
        disable_debug()

        -- Base scene setup
        lib = backend:get()
        shp = shapes:get()
        k = game_mechanics_consts:get()
        cam = lib.get_camera()
        scnMgr = scene_manager:new(scene.name, cam)
        wk = workflow:new(scnMgr)
        seq = workflow_sequences:new()
        gsm = global_state_manager:new()
        inputPrf = input_profile:new(context_get_input_profile())
        interactive = true
        completed = false
        dragging = false

        wk:add_workflow( {
            seq:fade_out(0)
        } , nil, false, scene.name .. ' fade out')

        wk:add_workflow( {
            seq:fade_in(1)
        } , nil, false, scene.name .. ' fade in')

        wk:add_workflow( {
            seq:message_box('Bene, così dovrebbe andare...', function(tpf, timer) return timer > 2 end,k.diplay_msg_styles.MSG_BOX,true,true),
            seq:wait(1),
            seq:pipe( function(tpf) go_back(gsm, scene) end)
        } , function() return completed end, false, 'exit puzzle')




        cursor = image_2d:new(TYPE_POLYGON, nil, 160, 100, 'gui/Cursor.png', 250)

        local puzzle = {
            background = 'R_Debug_01/Puzzles/Pz_Bak_Debug01_Munch.png',
            data =
            {
                t0 = { path = 'R_Debug_01/Puzzles/Pz_Debug01_0.png', shape = shp.DEBUG_01_PICTURE_PUZZLE_PIECE },
                t1 = { path = 'R_Debug_01/Puzzles/Pz_Debug01_1.png', shape = shp.DEBUG_01_PICTURE_PUZZLE_PIECE },
                t2 = { path = 'R_Debug_01/Puzzles/Pz_Debug01_2.png', shape = shp.DEBUG_01_PICTURE_PUZZLE_PIECE },
                t3 = { path = 'R_Debug_01/Puzzles/Pz_Debug01_3.png', shape = shp.DEBUG_01_PICTURE_PUZZLE_PIECE },
                t4 = { path = 'R_Debug_01/Puzzles/Pz_Debug01_4.png', shape = shp.DEBUG_01_PICTURE_PUZZLE_PIECE },
                t5 = { path = 'R_Debug_01/Puzzles/Pz_Debug01_5.png', shape = shp.DEBUG_01_PICTURE_PUZZLE_PIECE },
                t6 = { path = 'R_Debug_01/Puzzles/Pz_Debug01_6.png', shape = shp.DEBUG_01_PICTURE_PUZZLE_PIECE },
                t7 = { path = 'R_Debug_01/Puzzles/Pz_Debug01_7.png', shape = shp.DEBUG_01_PICTURE_PUZZLE_PIECE }
            },
            tmp = { },
            init = function(w)
                w['t5'] = { x = 20, y = 61 }
                w['t7'] = { x = 255, y = 61 }
                w['t3'] = { x = 10, y = 102 }
                w['t2'] = { x = 245, y = 102 }
                w['t6'] = { x = 20, y = 143 }
                w['t4'] = { x = 255, y = 143 }
                w['t1'] = { x = 10, y = 20 }
                w['t0'] = { x = 245, y = 20 }
            end,
            mechanism = function(w, tpf, mx, my)

                dragging = drag_and_drop(w, mx, my, inputPrf, 8)

            end,
            behavior =
            {
                fragments =
                {
                    t0 = { check_completed = function(w) return complete(w, 't0', 105, 24) end },
                    t1 = { check_completed = function(w) return complete(w, 't1', 160, 24) end },
                    t2 = { check_completed = function(w) return complete(w, 't2', 105, 61) end },
                    t3 = { check_completed = function(w) return complete(w, 't3', 160, 61) end },
                    t4 = { check_completed = function(w) return complete(w, 't4', 105, 98) end },
                    t5 = { check_completed = function(w) return complete(w, 't5', 160, 98) end },
                    t6 = { check_completed = function(w) return complete(w, 't6', 105, 135) end },
                    t7 = { check_completed = function(w) return complete(w, 't7', 160, 135) end }
                },
                on_complete = function()
                    completed = not dragging
                end
            }


        }




        puzzleManager = puzzle_manager:new(scene.name, puzzle)
        puzzleManager:init_puzzle()

        mx = 0
        my = 0


    end,
    input = function(keys, mouseButtons, x, y)




        mx = x
        my = y


        if keys ~= nil then
            if lib.key_action_performed(keys, 'ESC', 1) then
                scene.quit = true
            end

            inputPrf:poll_inputs(keys, mouseButtons)
        end


        -- CUSTOM CODE STOPS HERE, DO NOT REMOVE THIS LINE [input]

    end,
    update = function(tpf)

        puzzleManager:poll_events(tpf, mx, my)
        wk:poll_events(tpf)
        cursor:set_position(mx, my, 250)

    end,
    cleanup = function()

        cursor:delete()
        seq:delete_all()
        puzzleManager:delete_all()
        scnMgr:delete_all()
        lib.cleanup_pending()

    end
}

-- CUSTOM CODE STARTS HERE, DO NOT REMOVE THIS LINE [common]
complete = function(w, t, x, y)
    local ok = inside_coords(w[t].x, w[t].y, x, y)
    if ok then
        local image = w.transient.images[t]
        image:set_position(x, y)
    end
    return ok
end
-- CUSTOM CODE STOPS HERE, DO NOT REMOVE THIS LINE [common]