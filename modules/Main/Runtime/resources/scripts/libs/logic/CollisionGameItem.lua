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
    local ret = game_item:ret(path)

    local this = context:inst():get(cats.OBJECTS, id,
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

        ret = merge_tables(ret, new)

        return ret
    end )

    local metainf =
    {
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

    this = merge_tables(this, metainf)

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
        local dir = lib.get_direction(collisor.rotation, lib.vec3(0, -1, 0))
        local nextPos = lib.vec3_add(collisor.position, lib.vec3(ratio * dir.x, ratio * dir.y, 0))
        lib.move_collisor_dir(collisor, nextPos, lib.vec2(dir.x, dir.y))
        local collPos = collisor.position
        self.serializable.visual_info.position = { collPos.x, collPos.y, collPos.z }
    end

    function collision_game_item:rotate(rx, ry, rz)
        if self.serializable.expired then
            return
        end
        local collisor = self.transient.collisor
        trx.rotate(collisor, rx, ry, rz)
        local collRot = lib.to_euler(collisor.rotation)
        self.serializable.visual_info.rotation = { collRot.x, collRot.y, collRot.z }
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
        hpms.debug_draw_aabb(self.transient.collisor)
    end

    function collision_game_item:kill_instance()
        self.metainfo.override.game_item.kill_instance(self)
    end

    return this
end
