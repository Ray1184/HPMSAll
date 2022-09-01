dependencies = {
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

    local path = g.res_refs.actors.DUMMY_PLAYER.PATH
    local rad = g.res_refs.actors.DUMMY_PLAYER.B_RAD
    local rect = g.res_refs.actors.DUMMY_PLAYER.B_RECT
    local ghost = g.res_refs.actors.DUMMY_PLAYER.GHOST
    local id = g.res_refs.actors.DUMMY_PLAYER.ID
    local anagr = {
        name = 'Test Player',
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
        -- Main params.
        hp = 180,
        max_hp = 250,
        sp = 85,
        max_sp = 250,
        vp = 230,
        max_vp = 250,
        exp = 120,
        next_exp = 1500,
        lv = 38,
        ap = 15,
        money = 750.65,

        -- Support params.
        str = 65,
        sta = 50,
        int = 80,
        sci = 55,
        hnd = 42,
        dex = 35,
        occ = 20,
        cha = 35,
        frt = 15,

        -- Negative status.
        sleep = { false, 1 },
        poison = { false, 1 },
        toxin = { false, 1 },
        burn = { false, 1 },
        freeze = { false, 1 },
        blind = { false, 1 },
        paralysis = { false, 1 },
        shock = { false, 1 },


        regen = { false, 1 },
        rad = { false, 1 },
        armor = { false, 1 },
        invincibility = { false, 1 },

        -- Phobies.
        arachnophobia = { false, 1 },
        hemophobia = { false, 1 },
        anthropophobia = { false, 1 },
        aquaphobia = { false, 1 },
        pyrophobia = { false, 1 },
        acrophobia = { false, 1 },
        necrophobia = { false, 1 },
        aerophobia = { false, 1 },
        aviophobia = { false, 1 },
        photophobia = { false, 1 },
        nyctophobia = { false, 1 }

    }

    local this = player:ret(path, id, rad, rect, ghost)
    this.serializable.inventory.size = 20
    this:set_anagr(anagr)
    this:set_stats(stats)

    self.__tostring = function(o)
        return insp.inspect(o)
    end

    this:set_event_callback( function(tpf, evtInfo)
        -- TODO
    end )

    return this
end
