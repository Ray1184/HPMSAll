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
    local id = 'player/' .. path
    local this = context:inst():get(cats.OBJECTS, id,
    function()
        utils.debug("New player object.")
        local ret = anim_collision_game_item:ret(path, rad)
        local new = {
            serializable =
            {
                data =
                {
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
                        status_params =
                        {
                            sleep = false,
                            poison = false,
                            toxin = false,
                            burn = false,
                            freeze = false,
                            blind = false,
                            paralysis = false,
                            shock = false,
                            regen = false,
                            rad = false
                        },
                        other_params =
                        {
                            armor = 0,
                            invincible = false
                        },
                        current_inventory = { },
                        current_weapon = { }

                    },
                    equip = nil,
                    inventory =
                    {
                        weapons = { k.items_names.DUMMY_WEAPON, 1 }
                    }
                },
                metainfo =
                {
                    object_type = 'player',
                    parent_type = 'anim_collision_game_object',
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
        }

        ret = utils.merge(ret, new)

        return ret
    end )

    setmetatable(this, self)
    self.__index = self
    self.__tostring = function(o)
        return insp.inspect(o)
    end

    function player:move_dir(ratio)
        self.metainfo.override_collision_game_item.move_dir(ratio)
    end

    function player:delete_transient_data()
        self.metainfo.override_collision_game_item.delete_transient_data(self)
    end

    function player:fill_transient_data()
        self.metainfo.override_collision_game_item.fill_transient_data(self)
    end

    function anim_game_item:update()
        self.metainfo.override_collision_game_item.update(self)
    end

    if walkmap ~= nil then
        this:fill_transient_data()
    end

    return this
end
