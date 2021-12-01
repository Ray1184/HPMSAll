---
--- Created by Ray1184.
--- DateTime: 08/10/2020 17:04
---
--- Main player.
---


require('data/scripts/libs/Context')
require('data/scripts/libs/CollisionAnimGameItem')

local insp = require('data/scripts/thirdparty/Inspect')

local cats = require('data/scripts/libs/Categories')
local utils = require('data/scripts/libs/Utils')

local res = require('data/scripts/inst/GameConst')

player = {}

function player:ret(walkmap)
    local path = res.paths.PATH_PLAYER
    local id = 'player/' .. path
    local this = context:inst():get(cats.OBJECTS, id,
            function()
                utils.debug("New player object.")
                local ret = anim_collision_game_item:ret(path, walkmap)
                local new = {
                    serializable = {
                        mode = res.player_modes.SEARCH,
                        stats = {
                            standard_params = {
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
                            support_params = {
                                frz = 0,
                                res = 0,
                                int = 0,
                                sci = 0,
                                tut = 0,
                                dex = 0,
                                par = 0,
                                car = 0,
                                ftn = 0
                            },
                            status_effects = {
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
                            hidden_params = {
                                armor0 = 0,
                                armor10 = 0,
                                armor100 = 0
                            },
                            current_inventory = {},
                            current_weapon = {}

                        },
                        inventory = {
                            actions_object:ret(id)
                        },

                        override_collision_game_item = {
                            move_dir = ret.move_dir,
                            rotate = ret.rotate,
                            delete_transient_data = ret.delete_transient_data,
                            fill_transient_data = ret.fill_transient_data,
                            update = ret.update
                        }
                    },
                }

                ret = utils.merge(ret, new)

                return ret
            end)

    setmetatable(this, self)
    self.__index = self
    self.__tostring = function(o)
        return insp.inspect(o)
    end

    function player:move_dir(ratio)
        self.serializable.metainfo.override_collision_game_item.move_dir(ratio)
    end

    function player:delete_transient_data()
        self.serializable.metainfo.override_collision_game_item.delete_transient_data(self)
    end

    function player:fill_transient_data()
        self.serializable.metainfo.override_collision_game_item.fill_transient_data(self)
    end

    function anim_game_item:update()
        self.serializable.metainfo.override_collision_game_item.update(self)
    end

    if walkmap ~= nil then
        this:fill_transient_data()
    end

    return this
end
