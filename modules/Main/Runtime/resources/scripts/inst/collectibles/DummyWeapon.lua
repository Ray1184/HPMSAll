--
-- Created by Ray1184.
-- DateTime: 08/10/2020 17:04
--
-- Dummy weapon for test.
--

require('data/scripts/libs/CollectibleObject')

local cats = require('data/scripts/libs/Categories')
local utils = require('data/scripts/libs/Utils')

local res = require('data/scripts/inst/GameConst')

local bundle = require('data/scripts/bundles/Objects')

dummy_weapon = {}

function dummy_weapon:get(unique_id)
    local path = res.paths.DUMMY_WEAPON
    local id = 'dummy_weapon/' .. path .. '/' .. tostring(unique_id)
    local lang = context:inst():get_lang()
    local this = context:inst():get(cats.OBJECTS, id,
            function()
                utils.debug('New dummy_weapon object.')
                local ret = collectible_item:ret(path)
                local new = {
                    serializable = {
                        obj_properties = {
                            name = bundle[lang].dummy_weapon,
                            description = bundle[lang].dummy_weapon_desc,
                            money_value = 50,
                            sellable = true,
                            transport_license_required = res.item_license.NONE,
                            type = res.item_types.WEAPON,
                            menu_actions = {
                                equip = {
                                    label = bundle[lang].equip,
                                    on_press = function()
                                    end
                                },

                            },
                            weapon_properties = {
                                initial_ammo = 100,
                                max_ammo_loaded = 100,
                                ammo_types = { res.ammo_types.DUMMY_NORMAL, res.ammo_types.DUMMY_SUPER },
                                ammo_loaded = { dummy_ammo:ret(unique_id) },
                                damage = ammo_loaded.serializable.obj_properties.ammo_properties.damage,
                                piercing = ammo_loaded.serializable.obj_properties.ammo_properties.piercing,
                                effects = ammo_loaded.serializable.obj_properties.ammo_properties.effects,
                                ratio = 60

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

    return this

end