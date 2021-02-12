---
--- Created by Ray1184.
--- DateTime: 08/10/2020 17:04
---
--- Base player actions.
---

require('data/scripts/libs/CollectibleObject')

local cats = require('data/scripts/libs/Categories')
local utils = require('data/scripts/libs/Utils')

local res = require('data/scripts/inst/GameConst')

local bundle = require('data/scripts/bundles/Objects')

default_actions = {}

function default_actions:get(unique_id)
    local path = res.paths.DEFAULT_ACTIONS
    local id = 'default_actions/' .. path .. '/' .. tostring(unique_id)
    local lang = context:inst():get_lang()
    local this = context:inst():get(cats.OBJECTS, id,
            function()
                utils.debug('New default_actions object.')
                local ret = collectible_item:ret(path)
                local new = {
                    serializable = {
                        obj_properties = {
                            name = bundle[lang].default_actions,
                            description = bundle[lang].default_actions_desc,
                            money_value = 0,
                            sellable = false,
                            transport_license_required = res.item_license.NONE,
                            type = res.item_types.ACTIONS,
                            menu_actions = {
                                search = {
                                    label = bundle[lang].search,
                                    enabled = true,
                                    on_press = function()
                                        player:ret().serializable.mode = res.player_modes.SEARCH
                                    end
                                },
                                combat = {
                                    label = bundle[lang].combat,
                                    enabled = false,
                                    on_press = function()
                                        player:ret().serializable.mode = res.player_modes.COMBAT
                                    end
                                },
                                push = {
                                    label = bundle[lang].push,
                                    enabled = false,
                                    on_press = function()
                                        player:ret().serializable.mode = res.player_modes.PUSH
                                    end
                                },
                                stealth = {
                                    label = bundle[lang].stealth,
                                    enabled = false,
                                    on_press = function()
                                        player:ret().serializable.mode = res.player_modes.STEALTH
                                    end
                                },
                                swim = {
                                    label = bundle[lang].swim,
                                    enabled = false,
                                    on_press = function()
                                        player:ret().serializable.mode = res.player_modes.SWIM
                                    end
                                },
                                jump = {
                                    label = bundle[lang].jump,
                                    enabled = false,
                                    on_press = function()
                                        player:ret().serializable.mode = res.player_modes.JUMP
                                    end
                                },
                            }
                        },
                        override_collectible_item = {
                            move_dir = ret.move_dir,
                            rotate = ret.rotate,
                            delete_transient_data = ret.delete_transient_data,
                            fill_transient_data = ret.fill_transient_data,
                            update = ret.update
                        }
                    }
                }

                ret = utils.merge(ret, new)

                return ret
            end)

    setmetatable(this, self)
    self.__index = self
    self.__tostring = function(o)
        return insp.inspect(o)
    end


    function default_actions:move_dir(ratio)
        self.serializable.collectible_item.move_dir(ratio)
    end

    function default_actions:rotate(rx, ry, rz)
        self.serializable.collectible_item.rotate(rx, ry, rz)
    end

    function default_actions:delete_transient_data()
        self.serializable.collectible_item.delete_transient_data(self)
    end

    function default_actions:fill_transient_data()
        self.serializable.collectible_item.fill_transient_data(self)
    end

    function default_actions:update()
        self.serializable.collectible_item.update(self)
    end

    this:fill_transient_data()

    return this

end