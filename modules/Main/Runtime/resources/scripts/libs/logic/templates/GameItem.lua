-- -
--- Created by Ray1184.
--- DateTime: 04/10/2020 17:04
-- -
--- Standard stateful game object.
-- -

dependencies = {
    'libs/Context.lua',
    'libs/utils/Utils.lua',
    'libs/utils/TransformsCommon.lua',
    'libs/logic/templates/AbstractObject.lua',
    'libs/backend/HPMSFacade.lua',
    'libs/thirdparty/Inspect.lua'
}

game_item = { }

function game_item:ret(path, id)
    lib = backend:get()
    trx = transform:get()
    insp = inspector:get()


    local id = 'game_item/' .. id
    local ret = abstract_object:ret(id)

    local this = context:inst():get_object(id,
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
                    position = { 0, 0, 0 },
                    rotation = { 0, 0, 0 },
                    scale = { 1, 1, 1 },
                    visible = true

                }
            }
        }

        return merge_tables(ret, new)
    end )

    local metainf =
    {
        metainfo =
        {
            object_type = 'game_object',
            parent_type = 'abstract_object',
            override = { }
        }
    }

    local this = merge_tables(this, metainf)

    setmetatable(this, self)
    self.__index = self
    self.__tostring = function(o)
        return insp.inspect(o)
    end

    function game_item:set_position(x, y, z)
        if self.serializable.expired then
            return
        end
        local node = self.transient.node
        node.position = lib.vec3(x, y, z)
        self.serializable.visual_info.position = { x, y, node.position.z }
    end

     function game_item:get_position()
        return self.serializable.visual_info.position
    end

    function game_item:move_dir(ratio)
        if self.serializable.expired then
            return
        end
        local node = self.transient.node
        local dir = lib.get_direction(node.rotation, lib.vec3(0, -1, 0))
        node.position = lib.vec3_add(node.position, lib.vec3(ratio * dir.x, ratio * dir.y, 0))
        self.serializable.visual_info.position = { node.position.x, node.position.y, node.position.z }
    end

    function game_item:rotate(rx, ry, rz)
        if self.serializable.expired then
            return
        end
        local node = self.transient.node
        trx.rotate(node, rx, ry, rz)
        local rot = lib.to_euler(node.rotation)
        self.serializable.visual_info.rotation = { rot.x, rot.y, rot.z }
    end

    function game_item:scale(sx, sy, sz)
        if self.serializable.expired then
            return
        end
        local node = self.transient.node
        node.scale = lib.vec3(sx, sy, sz)
        self.serializable.visual_info.scale = { node.scale.x, node.scale.y, node.scale.z }
    end

    function game_item:delete_transient_data()
        if self.serializable.expired then
            return
        end
        lib.delete_node(self.transient.node)
        lib.delete_entity(self.transient.entity)

    end

    function game_item:fill_transient_data()
        if self.serializable.expired then
            return
        end
        local tra = {
            transient =
            {
                entity = lib.make_entity(self.serializable.path),
                node = lib.make_node('node_' .. self.serializable.id)
            }
        }
        self = merge_tables(self, tra)
        local node = self.transient.node
        local visualInfo = self.serializable.visual_info
        local pos = visualInfo.position
        local rot = visualInfo.rotation
        local sca = visualInfo.scale
        node.position = lib.vec3(pos[1], pos[2], pos[3])
        node.rotation = lib.from_euler(rot[1], rot[2], rot[3])
        node.scale = lib.vec3(sca[1], sca[2], sca[3])
        lib.set_node_entity(node, self.transient.entity)

    end

    function game_item:update()
        if self.serializable.expired then
            return
        end
        self.transient.entity.visible = self.serializable.visual_info.visible
    end

    function game_item:kill_instance()
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
