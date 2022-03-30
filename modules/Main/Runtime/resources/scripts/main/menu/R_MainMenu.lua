-- Scene script.
dependencies = {
    'Framework.lua',
    'libs/logic/models/Player.lua',
    'libs/logic/models/RoomState.lua',
    'libs/backend/HPMSFacade.lua',
    'libs/input/InputProfile.lua',
    'libs/thirdparty/JsonHelper.lua',
    'libs/thirdparty/Inspect.lua',
    'libs/logic/strats/Workflow.lua',
    'libs/logic/strats/WorkflowSequences.lua',
    'inst/Instances.lua',
    'inst/GameplayConsts.lua',
    'libs/logic/managers/GlobalStateManager.lua'
}


scene = {
    name = 'R_MainMenu',
    version = '1.0.0',
    quit = false,
    finished = false,
    next = 'undef',
    setup = function()
        -- Init function callback.

        lib = backend:get()
        cam = lib.get_camera()
        cam.near = 0.05
        cam.far = 100
        cam.fovy = lib.to_radians(40)
        k = game_mechanics_consts:get()
        insp = inspector:get()
        gsm = global_state_manager:new()
        scn_mgr = scene_manager:new(scene.name, cam)
        cin = workflow:new(scn_mgr)
        seq = workflow_sequences:new()
        input_prf = input_profile:new('default')

        callback = function(tpf, timer)
            if input_prf:action_done_once(k.input_actions.ACTION_1) then
                scene.next = 'main/scenes/R_Debug_01.lua'
                scene.finished = true
                return true
            elseif input_prf:action_done_once(k.input_actions.ACTION_2) then
                local state = gsm:load_data('data/save/savedata00.json')
                scene.next = 'main/scenes/' .. state.current_room .. '.lua'
                scene.finished = true
                return true
            else
                return false
            end
        end
        cin:add_workflow( {
            seq:message_box('Premi E per iniziare una nuova sessione di gioco e SPACE per caricare',callback,k.diplay_msg_styles.MSG_BOX,true)
        } , nil, false)


    end,
    input = function(keys, mouse_buttons, x, y)
        -- Input function callback.
        input_prf:poll_inputs(keys, mouse_buttons)


    end,
    update = function(tpf)
        -- Update function callback.
        scn_mgr:poll_events(tpf)
        cin:poll_events(tpf)

    end,
    cleanup = function()
        -- Cleanup function callback.
        scn_mgr:delete_all()
        seq:delete_all()
        lib.cleanup_pending()

    end
}
