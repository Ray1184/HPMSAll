---
--- Created by Ray1184.
--- DateTime: 04/10/2020 17:04
---
--- Animated and collidable stateful game object.
---

require('data/scripts/libs/Context')
require('data/scripts/libs/AnimGameItem')
require('data/scripts/libs/CollisionGameItem')

local insp = require('data/scripts/thirdparty/Inspect')

local cats = require('data/scripts/libs/Categories')
local utils = require('data/scripts/libs/Utils')
local lib = require('data/scripts/libs/HPMSFacade')

anim_collision_game_item = {}

function anim_collision_game_item:ret(path, walkmap)
    local id = 'anim_collision_game_item/' .. path
    local this = context:inst():get(cats.OBJECTS, id,
            function()
                utils.debug('New anim_collision_game_item object.')
                local ret = anim_game_item:ret(path)
                local ret2 = collision_game_item:ret(path, walkmap)
                local new = {
                    serializable = {
                        override_anim_game_item = {
                            move_dir = ret.move_dir,
                            rotate = ret.rotate,
                            delete_transient_data = ret.delete_transient_data,
                            fill_transient_data = ret.fill_transient_data,
                            update = ret.update
                        },
                        override_collision_game_item = {
                            move_dir = ret2.move_dir,
                            rotate = ret2.rotate,
                            delete_transient_data = ret2.delete_transient_data,
                            fill_transient_data = ret2.fill_transient_data,
                            update = ret2.update
                        }
                    }
                }

                ret = utils.merge(ret, ret2)
                ret = utils.merge(ret, new)

                return ret
            end)

    setmetatable(this, self)
    self.__index = self
    self.__tostring = function(o)
        return insp.inspect(o)
    end

    function anim_collision_game_item:move_dir(ratio)
        self.serializable.override_collision_game_item:move_dir(ratio)
    end

    function anim_collision_game_item:rotate(rx, ry, rz)
        self.serializable.override_collision_game_item:rotate(rx, ry, rz)
    end

    function anim_collision_game_item:delete_transient_data()
        self.serializable.override_game_item.delete_transient_data(self)
        if not self.serializable.expired then
            lib.delete_animator(self.transient.animator)
            lib.delete_collisor(self.transient.collisor)
        end
    end

    function anim_collision_game_item:fill_transient_data()
        self.serializable.override_game_item.fill_transient_data(self)
        if not self.serializable.expired then
            local tra = {
                transient = {
                    animator = lib.make_animator(self.transient.entity),
                    collisor = lib.make_collisor(self.transient.node, walkmap, 1)
                }
            }
            self = utils.merge(self, tra)
        end
    end

    function anim_collision_game_item:update()
        self.serializable.override_game_item.update(self)
        if not self.serializable.expired and self.serializable.visual_info.visible then
            lib.update_controller(self.transient.animator, 'ANIMATOR')
            lib.update_controller(self.transient.collisor, 'COLLISOR')
        end
    end


    return this
end
