-- -
--- Created by Ray1184.
--- DateTime: 04/10/2020 17:04
-- -
--- Collidable stateful game object.
-- -

dependencies = {
    'libs/Context.lua',
    'libs/utils/Utils.lua',
    'libs/logic/templates/GameItem.lua',
    'libs/backend/HPMSFacade.lua',
    'libs/utils/TransformsCommon.lua',
    'libs/thirdparty/Inspect.lua'
}

collision_game_item = { }

function collision_game_item:ret(path, id, bounding_radius)
    lib = backend:get()
    trx = transform:get()
    insp = inspector:get()

    local id = 'collision_game_item/' .. id
    local ret = game_item:ret(path, id)

    local this = context:inst():get_object(id,
    function()
        log_debug('New collision_game_item object ' .. id)

        local new = {
            serializable =
            {
                id = id,
                collision_info =
                {
                    bounding_radius = bounding_radius or 0
                }
            }
        }

        return merge_tables(ret, new)
    end )

    local metainf =
    {
        metainfo =
        {
            object_type = 'collision_game_item',
            parent_type = 'game_object',
            override =
            {
                game_item =
                {
                    move_dir = ret.move_dir,
                    set_position = ret.set_position,
                    get_position = ret.get_position,
                    rotate = ret.rotate,
                    delete_transient_data = ret.delete_transient_data,
                    fill_transient_data = ret.fill_transient_data,
                    update = ret.update,
                    kill_instance = ret.kill_instance
                }
            }
        }
    }

    local this = merge_tables(this, metainf)

    setmetatable(this, self)
    self.__index = self
    self.__tostring = function(o)
        return insp.inspect(o)
    end

    function collision_game_item:set_position(x, y, z)
        self.metainfo.override.game_item.set_position(self, x, y, z)
    end

    function collision_game_item:get_position()
        return self.metainfo.override.game_item.get_position(self)
    end

    function collision_game_item:move_dir(ratio)
        self.metainfo.override.game_item.move_dir(self, ratio)
    end

    function collision_game_item:rotate(rx, ry, rz)
        self.metainfo.override.game_item.rotate(self, rx, ry, rz)
    end

    function collision_game_item:delete_transient_data()
        self.metainfo.override.game_item.delete_transient_data(self)
        if self.serializable.expired then
            return
        end
        lib.delete_collisor(self.transient.collisor)

    end

    function collision_game_item:fill_transient_data(walkmap)
        self.metainfo.override.game_item.fill_transient_data(self)
        if self.serializable.expired then
            return
        end
        local scaledRad = self.serializable.collision_info.bounding_radius *((self.serializable.visual_info.scale[1] + self.serializable.visual_info.scale[2]) / 2)
        local tra = {
            transient =
            {
                collisor = lib.make_node_collisor(self.transient.node,walkmap,scaledRad)
            }
        }
        self = merge_tables(self, tra)

    end

    function collision_game_item:update()
        self.metainfo.override.game_item.update(self)
        if self.serializable.expired then
            return
        end
        lib.update_collisor(self.transient.collisor)
    end

    function collision_game_item:kill_instance()
        self.metainfo.override.game_item.kill_instance(self)
    end

    return this
end
