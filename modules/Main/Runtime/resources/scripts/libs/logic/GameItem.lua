---
--- Created by Ray1184.
--- DateTime: 04/10/2020 17:04
---
--- Standard stateful game object.
---

dependencies = { 
    'libs/Context.lua',
    'libs/utils/Utils.lua',
    'libs/utils/TransformsCommon.lua',
    'libs/logic/AbstractObject.lua',
    'libs/backend/HPMSFacade.lua',
    'thirdparty/Inspect.lua'
}

game_item = {}

function game_item:ret(path)
    lib = backend:get()
    trx = transform:get()
    insp = inspector:get()
    
    local id = 'game_item/' .. path
    local this = context:inst():get(cats.OBJECTS, id,
            function()
                log_debug('New game_item object ' .. id)
                local ret = abstract_object:ret(id)
                local new = {                   
                    serializable = {                       
                        path = path or '',
                        expired = false,
                        visual_info = {
                            position = lib.vec3(0, 0, 0),
                            rotation = lib.from_euler(0, 0, 0),
                            scale = lib.vec3(1, 1, 1),
                            visible = true
                        }
                    },
                    parent = {'abstract_object'}
                }

                ret = merge_tables(ret, new)
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

    function game_item:scale(sx, sy, sz)
        if self.serializable.expired then
            return
        end
        local node = self.transient.node
        node.scale = lib.vec3(sx, sy, sz)
        self.serializable.visual_info.scale = node.scale
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
            self = merge_tables(self, tra)
            local node = self.transient.node
            node.scale = lib.vec3(1, 1, 1)
            lib.set_node_entity(node, self.transient.entity)
        end
    end

    function game_item:update()
        if not self.serializable.expired then
            self.transient.entity.visible = self.serializable.visual_info.visible
        end
    end

    return this
end
