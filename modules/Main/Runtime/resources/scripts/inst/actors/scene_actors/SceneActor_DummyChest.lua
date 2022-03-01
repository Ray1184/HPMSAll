dependencies = {
    ----'Context.lua',
    --'libs/utils/Utils.lua',
    'libs/backend/HPMSFacade.lua',
    'libs/logic/models/SceneActor.lua',
    'libs/logic/GameMechanicsConsts.lua',
    'inst/GameplayConsts.lua'
}

dummy_chest = { }

function dummy_chest:ret(id_suffix)
    k = game_mechanics_consts:get()
    g = game_consts:get()
    insp = inspector:get()

    local path = g.res_refs.actors.DUMMY_CHEST.PATH
    local rad = g.res_refs.actors.DUMMY_CHEST.B_RAD
    local rect = g.res_refs.actors.DUMMY_CHEST.B_RECT
    local ghost = g.res_refs.actors.DUMMY_CHEST.GHOST
    local id = g.res_refs.actors.DUMMY_CHEST.ID .. '/' .. id_suffix

    local this = scene_actor:ret(path, id, rad, rect, ghost)
    this.serializable.pushable = true

    self.__tostring = function(o)
        return insp.inspect(o)
    end

    this:set_event_callback( function(tpf, evt_info)
        --if evt_info.first then
        --    log_warn('RICORRENZA-CHEST ' .. this.serializable.id .. ': ' .. tostring(evt_info.first))
        --end
        --this:rotate(0, 0, 50 * tpf)
    end )

    return this
end
