dependencies = {
    ----'Context.lua',
    --'libs/utils/Utils.lua',
    'libs/backend/HPMSFacade.lua',
    'libs/logic/models/Player.lua',
    'libs/logic/GameMechanicsConsts.lua',
    'inst/GameplayConsts.lua'
}

dummy_player = { }

function dummy_player:ret()
    k = game_mechanics_consts:get()
    g = game_consts:get()
    insp = inspector:get()

    local path = g.res_refs.players.DUMMY_PLAYER.PATH
    local rad = g.res_refs.players.DUMMY_PLAYER.B_RAD
    local rect = g.res_refs.players.DUMMY_PLAYER.B_RECT
    local ghost = g.res_refs.players.DUMMY_PLAYER.GHOST
    local id = g.res_refs.players.DUMMY_PLAYER.ID
    local anagr = {
        name = 'Joe Dummy',
        birth_date = '1900-01-01',
        birth_place = 'New Yates',
        country = 'US',
        job = 'Test Dummy',
        height = 180,
        weight = 80,
        info = 'Just a dummy for tests',
        photo = 'gui/photos/Dummy.png'
    }
    local stats =
    {

        { k.stats.standard_params.HP, 180 },
        { k.stats.standard_params.MAX_HP, 250 },
        { k.stats.standard_params.SP, 85 },
        { k.stats.standard_params.MAX_SP, 250 },
        { k.stats.standard_params.VP, 230 },
        { k.stats.standard_params.MAX_VP, 250 },
        { k.stats.standard_params.EXP, 120 },
        { k.stats.standard_params.EXP_NEXT, 1500 },
        { k.stats.standard_params.LV, 85 },
        { k.stats.standard_params.AP, 99 },
        { k.stats.standard_params.MONEY, 49999.99 },
        { k.stats.standard_params.ARMOR, 100 },

        { k.stats.support_params.STRENGTH, 100 },
        { k.stats.support_params.STAMINA, 100 },
        { k.stats.support_params.INTELLIGENCE, 100 },
        { k.stats.support_params.SCIENCE, 100 },
        { k.stats.support_params.HANDYMAN, 100 },
        { k.stats.support_params.DEXTERITY, 100 },
        { k.stats.support_params.OCCULT, 100 },
        { k.stats.support_params.CHARISMA, 100 },
        { k.stats.support_params.FORTUNE, 100 },

        { k.stats.negative_status_params.SLEEP, false, 1 },
        { k.stats.negative_status_params.POISON, false, 1 },
        { k.stats.negative_status_params.TOXIN, false, 1 },
        { k.stats.negative_status_params.BURN, false, 1 },
        { k.stats.negative_status_params.FREEZE, false, 1 },
        { k.stats.negative_status_params.BLIND, false, 1 },
        { k.stats.negative_status_params.PARALYSIS, false, 1 },
        { k.stats.negative_status_params.SHOCK, false, 1 },

        { k.stats.positive_status_params.REGEN, false, 1 },
        { k.stats.positive_status_params.RAD, false, 1 },
        { k.stats.positive_status_params.INVINCIBLITY, false },

        { k.stats.phobies.ARACHNOPHOBIA, false, 1 },
        { k.stats.phobies.HEMOPHOBIA, false, 1 },
        { k.stats.phobies.ANTHROPOPHOBIA, false, 1 },
        { k.stats.phobies.AQUAPHOBIA, false, 1 },
        { k.stats.phobies.PYROPHOBIA, false, 1 },
        { k.stats.phobies.ACROPHOBIA, false, 1 },
        { k.stats.phobies.NECROPHOBIA, false, 1 },
        { k.stats.phobies.AEROPHOBIA, false, 1 },
        { k.stats.phobies.AVIOPHOBIA, false, 1 },
        { k.stats.phobies.PHOTOPHOBIA, false, 1 },
        { k.stats.phobies.NYCTOPHOBIA, false, 1 }

    }

    local this = player:ret(path, id, rad, rect, ghost)

    this:set_anagr(anagr)
    this:set_stats(stats)

    self.__tostring = function(o)
        return insp.inspect(o)
    end

    this:set_event_callback( function(tpf, evt_info)
        -- TODO
    end )

    return this
end
