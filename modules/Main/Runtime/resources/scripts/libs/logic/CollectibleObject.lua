---
--- Created by Ray1184.
--- DateTime: 08/10/2020 17:04
---
--- Generic collectible and usable object.
---


require('data/scripts/libs/Context')
require('data/scripts/libs/AbstractObject')

local insp = require('data/scripts/thirdparty/Inspect')

local cats = require('data/scripts/libs/Categories')
local utils = require('data/scripts/libs/Utils')
local lib = require('data/scripts/libs/HPMSFacade')

collectible_item = {}

function collectible_item:ret(path)
    local id = 'collectible_item/' .. path
    local this = context:inst():get(cats.OBJECTS, id,
            function()
                utils.debug('New collectible_item object.')
                local ret = game_item:ret(path)
                local new = {
                    serializable = {
                        gui = {
                            visual_info = {
                                position = lib.vec3(0, 0, 0),
                                rotation = lib.from_euler(0, 0, 0),
                                selected = false
                            }
                        },
                        override_game_item = {
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

    function collectible_item:move_dir(ratio)
        self.serializable.override_game_item.move_dir(ratio)
    end

    function collectible_item:rotate(rx, ry, rz)
        self.serializable.override_game_item.rotate(rx, ry, rz)
    end

    function collectible_item:delete_transient_data()
        self.serializable.override_game_item.delete_transient_data(self)
    end

    function collectible_item:fill_transient_data()
        self.serializable.override_game_item.fill_transient_data(self)
    end

    function collectible_item:update()
        self.serializable.override_game_item.update(self)
        if context:inst():is_mode_r25d() or context:inst():is_mode_3d() then
            self.transient.node.position = self.serializable.visual_info.position
        else
            self.transient.entity.visible = self.serializable.gui.visual_info.selected
            self.transient.node.position = self.serializable.gui.visual_info.position
            self:rotate(0, 1, 0)
        end
    end


    return this
end
