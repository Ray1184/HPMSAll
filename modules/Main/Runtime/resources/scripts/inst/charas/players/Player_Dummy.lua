dependencies = {
    'libs/Context.lua',
    'libs/utils/Utils.lua',
    'libs/backend/HPMSFacade.lua',
    'libs/logic/models/Player.lua',
    'libs/logic/GameMechanicsConsts.lua',
    'inst/GameplayConsts.lua'
}

player_dummy = { }

function player_dummy:ret(anagr)
    k = game_mechanics_consts:get()
    g = game_consts:get()
    insp = inspector:get()

    if anagr == nil then
        anagr = { }
    end

    local path = g.res_refs.PLAYER_DUMMY.PATH
    local rad = g.res_refs.PLAYER_DUMMY.B_RAD
    local id = 'player/Player_Dummy'
    anagr = {
        name = anagr.name or 'Joe Dummy',
        birth_date = anagr.birth_date or '1900-01-01',
        birth_place = anagr.birth_place or 'Nowhere',
        country = anagr.country or 'Outworld',
        job = anagr.job or 'Test Dummy',
        height = anagr.height or 180,
        weight = anagr.weight or 80,
        info = anagr.info or 'I\'m just a dummy for tests...',
        photo = anagr.photo or 'gui/photos/Dummy.png'
    }


    this = player:ret(path, id, rad, anagr)
    
    self.__tostring = function(o)
        return insp.inspect(o)
    end

    return this
end
