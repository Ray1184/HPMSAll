---
--- Created by Ray1184.
--- DateTime: 04/10/2020 17:04
---
--- Collidable stateful game object.
---

require('data/scripts/libs/Context')
require('data/scripts/libs/GameItem')

local insp = require('data/scripts/thirdparty/Inspect')

local cats = require('data/scripts/libs/Categories')
local utils = require('data/scripts/libs/Utils')
local lib = require('data/scripts/libs/HPMSFacade')

collision_game_item = {}

function collision_game_item:ret(path, walkmap)
    local id = 'collision_game_item/' .. path
    local this = context:inst():get(cats.OBJECTS, id,
            function()
                utils.debug("New collision_game_item object.")
                local ret = game_item:ret(path)
                local new = {
                    serializable = {
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

    function collision_game_item:move_dir(ratio)
        if self.serializable.expired then
            return
        end
        local collisor = self.transient.collisor
        trx.move_collisor_towards_direction(collisor, ratio)
        self.serializable.visual_info.position = collisor.position
        self.serializable.visual_info.rotation = collisor.rotation
    end

    function collision_game_item:rotate(rx, ry, rz)
        self.serializable.override_game_item:rotate(rx, ry, rz)
    end

    function collision_game_item:delete_transient_data()
        self.serializable.override_game_item.delete_transient_data(self)
        if not self.serializable.expired then
            lib.delete_collisor(self.transient.collisor)
        end
    end

    function collision_game_item:fill_transient_data()
        self.serializable.override_game_item.fill_transient_data(self)
        if not self.serializable.expired then
            local tra = {
                transient = {
                    collisor = lib.make_collisor(self.transient.node, walkmap, 1)
                }
            }
            self = utils.merge(self, tra)
        end
    end

    function anim_game_item:update()
        self.serializable.override_game_item.update(self)
        if not self.serializable.expired and self.serializable.visual_info.visible then
            lib.update_controller(self.transient.collisor, 'COLLISOR')
        end
    end


    return this
end
