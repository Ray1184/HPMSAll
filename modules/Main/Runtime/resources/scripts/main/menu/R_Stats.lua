-- Scene script.
dependencies = {
    'libs/gui/Image2D.lua',
    'libs/gui/OutputText2D.lua',
    'libs/logic/managers/TextHelper.lua',
    'libs/logic/templates/AbstractObject.lua',
    'libs/backend/HPMSFacade.lua',
    'libs/logic/managers/GlobalStateManager.lua',
    'libs/thirdparty/Inspect.lua',
    'Framework.lua'
}


scene = {
    name = 'R_Inventory',
    version = '1.0.0',
    quit = false,
    finished = false,
    next = 'undef',
    setup = function()
        -- Init function callback.
        lib = backend:get()
        k = game_mechanics_consts:get()
        insp = inspector:get()
        gsm = global_state_manager:new()
        cam = lib.get_camera()
        cam.near = 0.05
        cam.far = 100
        cam.fovy = lib.to_radians(40)
        scn_mgr = scene_manager:new(scene.name, cam)
        actors_mgr = actors_manager:new(scn_mgr)
        wk = workflow:new(scn_mgr)
        seq = workflow_sequences:new()
        player = gsm:get_session_var(k.session_vars.CURRENT_PLAYER_REF)

        wk:add_workflow( {
            seq:fade_out(0)
        } , nil, false, 'Inventory fade out')

        wk:add_workflow( {
            seq:fade_in(1)
        } , nil, false, 'Inventory fade in')

        wk:add_workflow( {
            seq:pipe( function()
                local lastRoom = gsm:get_session_var(k.session_vars.LAST_ROOM)
                gsm:put_session_var(k.session_vars.LAST_ROOM, scene.name)
                scene.next = 'main/scenes/' .. lastRoom .. '.lua'
                scene.finished = true
            end )
        } , function() return input_prf:action_done_once('INVENTORY') end, false, 'Exit inventory')

        -- Base graphics
        local invBox = { lib.vec2(10, 0), lib.vec2(320, 0), lib.vec2(320, 200), lib.vec2(0, 200) }
        background = image_2d:new(TYPE_POLYGON, invBox, 0, 0, 'menu/B_Stats.png', 98)
        gui = image_2d:new(TYPE_POLYGON, invBox, 0, 0, 'menu/O_Stats.png', 101)
        background:set_visible(true)
        gui:set_visible(true)



        -- Labels 
        --nameLabel = create_text_label('player_name', player:get_anagr().name, lib, 220, 63, 'Alagard', 16)
        lvLabel = create_text_label('player_level', player:get_stat(k.stats.standard_params.LV), lib, 165, 63, 'Tamzen', 16, lib.vec4(1.0, 0.9, 0.7, 1.0))
        moneyLabel = create_text_label('player_money', player:get_stat(k.stats.standard_params.MONEY), lib, 115, 79, 'Tamzen', 16, lib.vec4(0.2, 0.7, 0.1, 1.0))
      

        -- Bars
        healthBar = fill_bar(43, 68, player:get_stat(k.stats.standard_params.HP), player:get_stat(k.stats.standard_params.MAX_HP), 'menu/ST_Health.png')
        sanityBar = fill_bar(43, 84, player:get_stat(k.stats.standard_params.SP), player:get_stat(k.stats.standard_params.MAX_SP), 'menu/ST_Sanity.png')
        vigorBar = fill_bar(43, 100, player:get_stat(k.stats.standard_params.VP), player:get_stat(k.stats.standard_params.MAX_VP), 'menu/ST_Vigor.png')
        expBar = fill_bar(119, 68, player:get_stat(k.stats.standard_params.EXP), player:get_stat(k.stats.standard_params.EXP_NEXT), 'menu/ST_Exp.png')

    end,
    input = function(keys, mouse_buttons, x, y)
        -- Input function callback.
        input_prf:poll_inputs(keys, mouse_buttons)


    end,
    update = function(tpf)
        -- Update function callback.

        scn_mgr:poll_events(tpf)
        wk:poll_events(tpf)

    end,
    cleanup = function()
        -- Cleanup function callback.
        delete_bar(healthBar)
        delete_bar(sanityBar)
        delete_bar(vigorBar)
        delete_bar(expBar)
        delete_text_label(moneyLabel)
        delete_text_label(lvLabel)
        --delete_text_label(nameLabel)
        scn_mgr:delete_all()
        actors_mgr:delete_all()
        seq:delete_all()
        background:delete()
        gui:delete()

    end
}

function fill_bar(x, y, val, max, iconName)
    local amount = 32.0 * (val / max)
    local refs = {}
    local xPos = x
    for i = 1, amount do
         local ref = image_2d:new(TYPE_POLYGON, invBox, xPos, y, iconName, 100)
         ref:set_visible(true)
         xPos = xPos + 1
         table.insert(refs, ref)
    end
    return refs
end

function delete_bar(bar)
    for i = 1, #bar do
        bar[i]:delete()
    end
end
