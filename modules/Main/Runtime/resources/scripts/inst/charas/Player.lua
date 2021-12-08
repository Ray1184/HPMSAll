-- -
--- Created by Ray1184.
--- DateTime: 08/10/2020 17:04
-- -
--- Main player.
-- -


dependencies = {
    'libs/Context.lua',
    'libs/utils/Utils.lua',
    'libs/logic/GameItem.lua',
    'libs/backend/HPMSFacade.lua',
    'libs/logic/AnimCollisionGameItem.lua',
    'libs/logic/AnimGameItem.lua',
    'inst/GameConst.lua'
}

player = { }

function player:ret(path, rad, anagr)
    k = consts:get()
    insp = inspector:get()
    local name = 'Joe Dummy'
    if anagr == nil then
        anagr = { }
    end
    local id = 'player/' .. path .. '/' ..(anagr.name or 'Joe Dummy')
    local ret = anim_collision_game_item:ret(path, rad)

    local this = context:inst():get(cats.OBJECTS, id,
    function()
        log_debug('New player object ' .. id)

        local new = {
            serializable =
            {
                id = id,
                mode = k.player_modes.SEARCH,
                stats =
                {
                    anagr =
                    {
                        name = anagr.name or 'Joe Dummy',
                        birth_date = anagr.birth_date or '1900-01-01',
                        birth_place = anagr.birth_place or 'Nowhere',
                        country = anagr.country or 'Outworld',
                        job = anagr.job or 'Test Dummy',
                        height = anagr.height or 180,
                        weight = anagr.weight or 80,
                        info = anagr.info or 'I\'m just a dummy for tests...',
                        photo = anagr.photo or 'gui/photos/Dummy.png'
                    },

                    standard_params =
                    {
                        hp = 50,
                        max_hp = 50,
                        sp = 30,
                        max_sp = 30,
                        vp = 20,
                        max_vp = 20,
                        lv = 1,
                        ap = 0,
                        money = 0
                    },
                    support_params =
                    {
                        strength = 0,
                        stamina = 0,
                        intelligence = 0,
                        science = 0,
                        handyman = 0,
                        dexterity = 0,
                        occult = 0,
                        charisma = 0,
                        fortune = 0
                    },
                    negative_status_params =
                    {
                        sleep = false,
                        poison = false,
                        toxin = false,
                        burn = false,
                        freeze = false,
                        blind = false,
                        paralysis = false,
                        shock = false

                    },
                    negative_status_affection =
                    {
                        sleep = 1,
                        poison = 1,
                        toxin = 1,
                        burn = 1,
                        freeze = 1,
                        blind = 1,
                        paralysis = 1,
                        shock = 1
                    },
                    positive_status_params =
                    {
                        regen = false,
                        rad = false
                    },
                    other_params =
                    {
                        armor = 0,
                        invincible = false
                    }

                },
                equip = nil,
                inventory =
                {
                    weapons = { id = k.items_names.DUMMY_WEAPON, amount = 1 },
                    supplies = { id = k.items_names.DUMMY_FOOD, amount = 3 },
                    key_items = { id = k.items_names.DUMMY_KEY, amount = 1 },
                    reading_items = { id = k.items_names.DUMMY_BOOK, amount = 1 },
                    misc_items = { id = k.items_names.DUMMY_TRESAURE, amount = 1 }
                }

            }
        }
        ret = merge_tables(ret, new)
        return ret
    end )

    local metainf = {
        metainfo =
        {
            object_type = 'player',
            parent_type = 'anim_collision_game_item',
            override =
            {
                anim_collision_game_item =
                {
                    move_dir = ret.move_dir,
                    rotate = ret.rotate,
                    delete_transient_data = ret.delete_transient_data,
                    fill_transient_data = ret.fill_transient_data,
                    update = ret.update,
                    set_anim = ret.set_anim,
                    play = ret.play,
                    kill_instance = ret.kill_instance
                }
            }
        }
    }

    metainf.metainfo.override = merge_tables(metainf.metainfo.override, ret.metainfo.override)

    this = merge_tables(this, metainf)

    setmetatable(this, self)
    self.__index = self
    self.__tostring = function(o)
        return insp.inspect(o)
    end

    function player:move_dir(ratio)
        self.metainfo.override.anim_collision_game_item.move_dir(self, ratio)
    end

    function player:rotate(rx, ry, rz)
        self.metainfo.override.anim_collision_game_item.rotate(self, rx, ry, rz)
    end

    function player:delete_transient_data()
        self.metainfo.override.anim_collision_game_item.delete_transient_data(self)
    end

    function player:fill_transient_data(walkmap)
        log_debug('WALKMAP')
        log_debug(walkmap)
        self.metainfo.override.anim_collision_game_item.fill_transient_data(self, walkmap)
    end

    function player:update(tpf)
        self.metainfo.override.anim_collision_game_item.update(self, tpf)
    end

    function player:set_anim(name)
        self.metainfo.override.anim_collision_game_item.set_anim(self, name)
    end

    function player:play(mode, slowdown, slice)
        self.metainfo.override.anim_collision_game_item.play(self, mode, slowdown, slice)
    end

    function player:kill_instance()
        self.metainfo.override.anim_collision_game_item.kill_instance(self)
    end

    return this
end
