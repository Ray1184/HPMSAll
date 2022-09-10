--
-- Created by Ray1184.
-- DateTime: 04/10/2020 17:04
--
-- Standard stateless game object.
--

dependencies = {
    'libs/utils/TransformsCommon.lua',
    'libs/logic/templates/AbstractVolatileObject.lua',
    'libs/backend/HPMSFacade.lua'
}

volatile_game_item = { }

function volatile_game_item:ret(path)
    lib = backend:get()
    trx = transform:get()
    insp = inspector:get()

    local transientDataInit = false
    local ret = abstract_volatile_object:ret()

    local this = { }

    local notSer = {
        not_serializable =
        {
            visible = true
        }
    }

    this = merge_tables(this, notSer)

    local metainf =
    {
        metainfo =
        {
            object_type = 'volatile_game_object',
            parent_type = 'abstract_volatile_object',
            override = { }
        }
    }

    this = merge_tables(this, metainf)

    setmetatable(this, self)
    self.__index = self
    self.__tostring = function(o)
        return insp.inspect(o)
    end

    function volatile_game_item:set_position(x, y, z)
        local node = self.transient.node
        node.position = lib.vec3(x, y, z)
    end

    function volatile_game_item:get_position()
        local pos = node.position
        return { pos.x, pos.y, pos.z }
    end

    function volatile_game_item:move_dir(ratio, dir)
        local node = self.transient.node
        local dir = dir or lib.get_direction(node.rotation, lib.vec3(0, -1, 0))
        node.position = lib.vec3_add(node.position, lib.vec3(ratio * dir.x, ratio * dir.y, 0))
    end

    function volatile_game_item:rotate(rx, ry, rz)
        local node = self.transient.node
        trx.rotate(node, rx, ry, rz)
    end

    function volatile_game_item:scale(sx, sy, sz)
        local node = self.transient.node
        node.scale = lib.vec3(sx, sy, sz)
    end

    function volatile_game_item:delete_transient_data()
        if not self.transientDataInit then
            return
        end
        self.transientDataInit = false
        lib.delete_node(self.transient.node)
        lib.delete_node(self.transient.ctrl_node)
        if self.transient.entity ~= nil then
            lib.delete_entity(self.transient.entity)
        end

    end

    function volatile_game_item:fill_transient_data()
        if self.transientDataInit then
            return
        end
        local controlNode = lib.make_node('ctrl_node_vol_' .. self.not_serializable.id)
        local ent = nil
        if path ~= nil then
            ent = lib.make_entity(path)
        end
        local tra = {

            transient =
            {
                entity = ent,
                ctrl_node = controlNode,
                node = lib.make_child_node('node_vol_' .. self.not_serializable.id,controlNode)

            }
        }
        self = merge_tables(self, tra)
        local node = self.transient.node
        if self.transient.entity ~= nil then
            lib.set_node_entity(node, self.transient.entity)
        end
        self.transientDataInit = true

    end

    function volatile_game_item:update()

        if self.transient.entity ~= nil then
            self.transient.entity.visible = self.not_serializable.visual_info.visible
        end
        local node = self.transient.node
        local rot = lib.to_euler(node.rotation)
    end

    function volatile_game_item:set_event_callback(evt_callback)
        self.metainfo.evt_callback = evt_callback
    end

    function volatile_game_item:event(evt_info)
        if self.metainfo.instance ~= nil then
            self.metainfo.instance:event(evt_info)
        end
    end

    return this
end
