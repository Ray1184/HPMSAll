-- -
--- Created by Ray1184.
--- DateTime: 04/10/2020 17:04
-- -
--- Collidable stateful game object.
-- -

dependencies = {
    'libs/Context.lua',
    'libs/utils/Utils.lua',
    'libs/logic/GameItem.lua',
    'libs/backend/HPMSFacade.lua',
    'libs/utils/TransformsCommon.lua',
    'thirdparty/Inspect.lua'
}

collision_game_item = { }

function collision_game_item:ret(path, bounding_radius)
    lib = backend:get()
    trx = transform:get()
    insp = inspector:get()

    local id = 'collision_game_item/' .. path
    local this = context:inst():get(cats.OBJECTS, id,
    function()
        log_debug('New collision_game_item object ' .. id)
        local ret = game_item:ret(path)
        local new = {
            serializable =
            {
                data =
                {
                    collision_info =
                    {
                        bounding_radius = bounding_radius or 0
                    }
                },
                metainfo =
                {
                    object_type = 'collision_game_object',
                    parent_type = 'game_object',
                    override =
                    {
                        game_item =
                        {
                            move_dir = ret.move_dir,
                            rotate = ret.rotate,
                            delete_transient_data = ret.delete_transient_data,
                            fill_transient_data = ret.fill_transient_data,
                            update = ret.update,
                            kill_instance = ret.kill_instance
                        }
                    }
                }
            }
        }

        ret = merge_tables(ret, new)

        return ret
    end )

    setmetatable(this, self)
    self.__index = self
    self.__tostring = function(o)
        return insp.inspect(o)
    end

    function collision_game_item:move_dir(ratio)
        if self.serializable.data.expired then
            return
        end
        local collisor = self.transient.collisor
        local dir = lib.get_direction(collisor.rotation, lib.vec3(0, -1, 0))
        local nextPos = lib.vec3_add(collisor.position, lib.vec3(ratio * dir.x, ratio * dir.y, 0))
        lib.move_collisor_dir(collisor, nextPos, lib.vec2(dir.x, dir.y))
        self.serializable.data.visual_info.position = collisor.position
    end

    function collision_game_item:rotate(rx, ry, rz)
        if self.serializable.data.expired then
            return
        end
        local collisor = self.transient.collisor
        trx.rotate(collisor, rx, ry, rz)
        self.serializable.data.visual_info.rotation = collisor.rotation
    end

    function collision_game_item:delete_transient_data()
        self.serializable.metainfo.override.game_item.delete_transient_data(self)
        if not self.serializable.data.expired then
            lib.delete_collisor(self.transient.collisor)
        end
    end

    function collision_game_item:fill_transient_data(walkmap)
        self.serializable.metainfo.override.game_item.fill_transient_data(self)
        if not self.serializable.data.expired then
            local tra = {
                transient =
                {
                    collisor = lib.make_node_collisor(self.transient.node,walkmap,self.serializable.data.collision_info.bounding_radius)
                }
            }
            self = merge_tables(self, tra)
        end
    end

    function collision_game_item:update()
        self.serializable.metainfo.override.game_item.update(self)
        if self.serializable.data.expired then
            return
        end
        lib.update_collisor(self.transient.collisor)
        hpms.debug_draw_aabb(self.transient.collisor)
    end

    function collision_game_item:kill_instance()
        self.serializable.metainfo.override.game_item.kill_instance(self)
    end

    return this
end
