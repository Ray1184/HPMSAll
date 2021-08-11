---
--- Created by Ray1184.
--- DateTime: 04/10/2020 17:04
---
--- Standard stateful game object.
---

require('data/scripts/libs/Context')
require('data/scripts/libs/AbstractObject')

local insp = require('data/scripts/thirdparty/Inspect')

local cats = require('data/scripts/libs/Categories')
local utils = require('data/scripts/libs/Utils')
local lib = require('data/scripts/libs/HPMSFacade')
local trx = require('data/scripts/libs/TransformsCommon')

game_item = {}

function game_item:ret(path)
    local id = 'game_item/' .. path
    local this = context:inst():get(cats.OBJECTS, id,
            function()
                utils.debug('New game_item object.')
                local ret = abstract_object:ret(id)
                local new = {
                    serializable = {
                        path = path or '',
                        expired = false,
                        visual_info = {
                            position = lib.vec3(0, 0, 0),
                            rotation = lib.from_euler(0, 0, 0),
                            visible = true
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

    function game_item:move_dir(ratio)
        if self.serializable.expired then
            return
        end
        local node = self.transient.node
        trx.move_towards_direction(node, ratio)
        self.serializable.visual_info.position = node.position
    end

    function game_item:rotate(rx, ry, rz)
        if self.serializable.expired then
            return
        end
        local node = self.transient.node
        trx.rotate(node, rx, ry, rz)
        self.serializable.visual_info.rotation = node.rotation
    end

    function game_item:delete_transient_data()
        if not self.serializable.expired then
            lib.delete_node(self.transient.node)
            lib.delete_entity(self.transient.entity)
        end
    end

    function game_item:fill_transient_data()
        if not self.serializable.expired then
            local tra = {
                transient = {
                    entity = lib.make_entity(self.serializable.path),
                    node = lib.make_node('NODE_' .. self.serializable.path)
                }
            }
            self = utils.merge(self, tra)
            lib.set_node_entity(self.transient.node, self.transient.entity)
            lib.add_node_to_scene(self.transient.node, context:inst():get_scene())
        end
    end

    function game_item:update()
        if not self.serializable.expired then
            self.transient.entity.visible = self.serializable.visual_info.visible
        end
    end

    return this
end
