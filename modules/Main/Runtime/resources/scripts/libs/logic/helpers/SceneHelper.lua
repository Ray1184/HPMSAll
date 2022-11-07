--
-- Created by Ray1184.
-- DateTime: 25/10/2022 17:04
--
-- Helper for base scene management.
--

dependencies = {
    'libs/backend/HPMSFacade.lua',
    'libs/logic/GameMechanicsConsts.lua',
    'libs/utils/MathUtils.lua'
}

function go_to_room(gsm, scene, name)
    gsm:put_session_var(k.session_vars.LAST_ROOM, scene.name)
    scene.next = 'main/scenes/' .. name .. '.lua'
    scene.finished = true
end

function go_to_puzzle(gsm, scene, name)
    gsm:put_session_var(k.session_vars.LAST_ROOM, scene.name)
    scene.next = 'main/puzzles/' .. name .. '.lua'
    scene.finished = true
end

function go_to_menu(gsm, scene, name)
    gsm:put_session_var(k.session_vars.LAST_ROOM, scene.name)
    scene.next = 'main/menu/' .. name .. '.lua'
    scene.finished = true
end

function go_back(gsm, scene)
    local lastRoom = gsm:get_session_var(k.session_vars.LAST_ROOM)
    gsm:put_session_var(k.session_vars.LAST_ROOM, scene.name)
    scene.next = 'main/scenes/' .. lastRoom .. '.lua'
    scene.finished = true
end

