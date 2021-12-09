dependencies = {
    'libs/Context.lua',
    'libs/utils/Utils.lua',
    'libs/backend/HPMSFacade.lua',
    'libs/logic/models/Player.lua',
    'libs/logic/GameMechanicsConsts.lua',
    'inst/GameplayConsts.lua'
}

player_dummy = { }

function player_dummy:ret()
    k = game_mechanics_consts:get()
    g = gameplay_consts:get()
    insp = inspector:get()
    
    local path = g.res_refs.PLAYER_DUMMY
    local id = 'player/' .. path .. '/' ..(anagr.name or 'Joe Dummy')
    local ret = anim_collision_game_item:ret(path, rad)

    local this = context:inst():get(cats.OBJECTS, id,
    function()
        log_debug('New player object ' .. id)
        local ret = { }
        return ret
    end )
    return this
end
