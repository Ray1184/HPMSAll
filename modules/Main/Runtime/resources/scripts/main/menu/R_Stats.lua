-- Scene script.
dependencies = {
    'libs/gui/Image2D.lua',
    'libs/gui/OutputText2D.lua',
    'libs/logic/gameplay/TextHelper.lua',
    'libs/logic/templates/AbstractObject.lua',
    'libs/backend/HPMSFacade.lua',
    'libs/logic/managers/GlobalStateManager.lua',
    'libs/thirdparty/Inspect.lua',
    'Framework.lua'
}


scene = {
    name = 'R_Stats',
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
        
        lamp = lib.make_light(lib.vec3(2, 2, 2))
        lamp.position = lib.vec3(-0.675, -2, 0.55)

        scn_mgr:sample_view_by_callback( function() return true end, 'menu/B_Stats.png', lib.vec3(-0.675, -2, 0.55), lib.quat(0.707107, 0.707107, 0, 0))


        wk:add_workflow( {
            seq:fade_out(0)
        } , nil, false, 'Inventory fade out')

        wk:add_workflow( {
            seq:fade_in(1)
        } , nil, false, 'Inventory fade in')

        wk:add_workflow( {
            seq:pipe( function(tpf)
                local lastRoom = gsm:get_session_var(k.session_vars.LAST_ROOM)
                gsm:put_session_var(k.session_vars.LAST_ROOM, scene.name)
                scene.next = 'main/scenes/' .. lastRoom .. '.lua'
                scene.finished = true
            end )
        } , function() return input_prf:action_done_once('INVENTORY') end, false, 'Exit inventory')

        -- Base graphics
        local invBox = { lib.vec2(10, 0), lib.vec2(320, 0), lib.vec2(320, 200), lib.vec2(0, 200) }
        gui = image_2d:new(TYPE_POLYGON, invBox, 0, 0, 'menu/O_Stats.png', 100)
        gui:set_visible(true)

        -- Model
        playerModel = anim_game_item:ret(player.serializable.path, player.serializable.id .. '/inv_model')
        playerModel:fill_transient_data()
        playerModel:set_position(0, 0, 0)
        playerModel:scale(0.4, 0.4, 0.4)
        playerModel:set_anim(k.default_animations.WALK_FORWARD)
        playerModel:play(k.anim_modes.ANIM_MODE_LOOP, 1)
        wk:add_workflow( {
            seq:pipe( function(tpf)
                playerModel:rotate(0, 0, 200 * tpf)
                playerModel:update(tpf)
            end, true )
        } , nil, true, 'Animate model')

        -- Labels
        nameLabel = create_text_label('player_name', player:get_anagr().name, lib, 205, 63)
        lvLabel = create_text_label('player_level', player:get_stats().lv, lib, 162, 63)
        moneyLabel = create_text_label('player_money', player:get_stats().money, lib, 113, 78)


        -- Bars
        healthBar = fill_bar(43, 68, player:get_stats().hp, player:get_stats().max_hp, 'menu/ST_Health.png')
        sanityBar = fill_bar(43, 84, player:get_stats().sp, player:get_stats().max_sp, 'menu/ST_Sanity.png')
        vigorBar = fill_bar(43, 100, player:get_stats().vp, player:get_stats().max_vp, 'menu/ST_Vigor.png')
        expBar = fill_bar(119, 68, player:get_stats().exp, player:get_stats().next_exp, 'menu/ST_Exp.png')

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
        lib.delete_light(lamp)
        playerModel:delete_transient_data()
        delete_bar(healthBar)
        delete_bar(sanityBar)
        delete_bar(vigorBar)
        delete_bar(expBar)
        delete_text_label(moneyLabel)
        delete_text_label(lvLabel)
        delete_text_label(nameLabel)
        scn_mgr:delete_all()
        actors_mgr:delete_all()
        seq:delete_all()
        gui:delete()

    end
}

function fill_bar(x, y, val, max, iconName)
    local amount = 32.0 *(val / max)
    local refs = { }
    local xPos = x
    for i = 1, amount do
        local ref = image_2d:new(TYPE_POLYGON, invBox, xPos, y, iconName, 105)
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
