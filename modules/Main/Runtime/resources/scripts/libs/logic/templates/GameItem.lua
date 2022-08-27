--
-- Created by Ray1184.
-- DateTime: 04/10/2020 17:04
--
-- Standard stateful game object.
--

dependencies = {
    'libs/utils/TransformsCommon.lua',
    'libs/logic/templates/AbstractObject.lua',
    'libs/backend/HPMSFacade.lua'
}

game_item = { }

function game_item:ret(path, id)
    lib = backend:get()
    trx = transform:get()
    insp = inspector:get()

    local transientDataInit = false
    local id = 'game_item/' .. id
    local ret = abstract_object:ret(id)

    local this = context_get_object(id, false,
    function()
        log_debug('New game_item object ' .. id)

        local new = {
            serializable =
            {
                id = id,
                path = path or '',
                expired = false,
                visual_info =
                {
                    position = { x = 0, y = 0, z = 0 },
                    rotation = { x = 0, y = 0, z = 0 },
                    scale = { x = 1, y = 1, z = 1 },
                    visible = true

                }
            }
        }

        return merge_tables(ret, new)
    end )

    local notSer = {
        not_serializable = { }
    }

    this = merge_tables(this, notSer)

    local metainf =
    {
        metainfo =
        {
            object_type = 'game_object',
            parent_type = 'abstract_object',
            override = { }
        }
    }

    this = merge_tables(this, metainf)

    setmetatable(this, self)
    self.__index = self
    self.__tostring = function(o)
        return insp.inspect(o)
    end

    function game_item:set_position(x, y, z)
        if self.serializable.expired then
            return
        end
        log_warn(self.serializable.id)
        local node = self.transient.node        
        node.position = lib.vec3(x, y, z)
        self.serializable.visual_info.position = { x = node.position.x, y = node.position.y, z = node.position.z }
    end

    function game_item:get_position()
        return self.serializable.visual_info.position
    end

    function game_item:move_dir(ratio, dir)
        if self.serializable.expired then
            return
        end
        local node = self.transient.node
        local dir = dir or lib.get_direction(node.rotation, lib.vec3(0, -1, 0))
        node.position = lib.vec3_add(node.position, lib.vec3(ratio * dir.x, ratio * dir.y, 0))
    end

    function game_item:rotate(rx, ry, rz)
        if self.serializable.expired then
            return
        end
        local node = self.transient.node
        trx.rotate(node, rx, ry, rz)
    end

    function game_item:scale(sx, sy, sz)
        if self.serializable.expired then
            return
        end
        local node = self.transient.node
        node.scale = lib.vec3(sx, sy, sz)
    end

    function game_item:delete_transient_data()
        if not self.transientDataInit then
            return
        end
        self.transientDataInit = false
        lib.delete_node(self.transient.node)
        lib.delete_node(self.transient.ctrl_node)
        lib.delete_entity(self.transient.entity)

    end

    function game_item:fill_transient_data()
        if self.serializable.expired or self.transientDataInit then
            return
        end
        local controlNode = lib.make_node('ctrl_node_' .. self.serializable.id)
        local tra = {
            transient =
            {
                entity = lib.make_entity(self.serializable.path),
                ctrl_node = controlNode,
                node = lib.make_child_node('node_' .. self.serializable.id,controlNode)

            }
        }
        self = merge_tables(self, tra)
        local node = self.transient.node
        local visualInfo = self.serializable.visual_info
        local pos = visualInfo.position
        local rot = visualInfo.rotation
        local sca = visualInfo.scale
        node.position = lib.vec3(pos.x, pos.y, pos.z)
        node.rotation = lib.from_euler(rot.x, rot.y, rot.z)
        node.scale = lib.vec3(sca.x, sca.y, sca.z)
        lib.set_node_entity(node, self.transient.entity)
        self.transientDataInit = true

    end

    function game_item:update()
        if self.serializable.expired then
            return
        end
        self.transient.entity.visible = self.serializable.visual_info.visible
        local node = self.transient.node
        local rot = lib.to_euler(node.rotation)
        self.serializable.visual_info.rotation = { x = rot.x, y = rot.y, z = rot.z }
        self.serializable.visual_info.position = { x = node.position.x, y = node.position.y, z = node.position.z }
        self.serializable.visual_info.scale = { x = node.scale.x, y = node.scale.y, z = node.scale.z }
    end

    function game_item:kill_instance()
        -- WARNING, here change state forever after call.
        self:update()
        self.serializable.expired = true
    end

    function game_item:set_event_callback(evt_callback)
        self.metainfo.evt_callback = evt_callback
    end

    function game_item:event(evt_info)
        if self.metainfo.instance ~= nil then
            self.metainfo.instance:event(evt_info)
        end
    end

    return this
end
