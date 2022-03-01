--
-- Created by Ray1184.
-- DateTime: 04/10/2020 17:04
--
-- Collidable stateful game object.
--

dependencies = {
    ----'Context.lua',
    --'libs/utils/Utils.lua',
    'libs/logic/templates/GameItem.lua',
    'libs/backend/HPMSFacade.lua',
    'libs/utils/TransformsCommon.lua',
    'libs/thirdparty/Inspect.lua',
    'libs/logic/GameMechanicsConsts.lua'
}

collision_game_item = { }

function collision_game_item:ret(path, id, bounding_radius, bounding_rect, ghost)
    lib = backend:get()
    k = game_mechanics_consts:get()
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
                    bounding_radius = bounding_radius or 0,
                    bounding_rect = bounding_rect or { x = 0, y = 0 },
                    ghost = ghost or false
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
                    scale = ret.scale,
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
        if self.serializable.expired then
            return
        end
        local collisor = self.transient.collisor
        collisor.position = lib.vec3(x, y, z)
    end

    function collision_game_item:get_position()
        return self.metainfo.override.game_item.get_position(self)
    end

    function collision_game_item:move_dir(ratio, dir)
        if self.serializable.expired then
            return
        end
        local collisor = self.transient.collisor
        local dir = dir or lib.get_direction(collisor.rotation, lib.vec3(0, -1, 0))
        local nextPos = lib.vec3_add(collisor.position, lib.vec3(ratio * dir.x, ratio * dir.y, 0))
        lib.move_collisor_dir(collisor, nextPos, lib.vec2(dir.x, dir.y))
    end

    function collision_game_item:rotate(rx, ry, rz)
        self.metainfo.override.game_item.rotate(self, rx, ry, rz)
    end

    function collision_game_item:scale(sx, sy, sz)
        self.metainfo.override.game_item.scale(self, sx, sy, sz)
    end

    function collision_game_item:get_scaled_rad()
        return self.serializable.collision_info.bounding_radius *((self.serializable.visual_info.scale.x + self.serializable.visual_info.scale.y) / 2)
    end

    function collision_game_item:ghost()
        return self.serializable.collision_info.ghost
    end

    function collision_game_item:delete_transient_data()
        if self.serializable.expired then
            return
        end
        lib.delete_collisor(self.transient.collisor)
        self.metainfo.override.game_item.delete_transient_data(self)
    end

    function collision_game_item:fill_transient_data(walkmap)
        self.metainfo.override.game_item.fill_transient_data(self)
        if self.serializable.expired then
            return
        end
        local rad = self.serializable.collision_info.bounding_radius
        local rect = lib.vec2(self.serializable.collision_info.bounding_rect.x, self.serializable.collision_info.bounding_rect.y)
        local conf = lib.get_collisor_config(not self.serializable.collision_info.ghost, k.DEFAULT_GAVITY, k.DEFAULT_MAX_STEP_HEIGHT, rad, rect)

        local tra = {
            transient =
            {
                collisor = lib.make_node_collisor(self.transient.node,walkmap,conf)
            }
        }
        self = merge_tables(self, tra)
        local collisor = self.transient.collisor
        local visualInfo = self.serializable.visual_info
        local pos = visualInfo.position
        local rot = visualInfo.rotation
        collisor.position = lib.vec3(pos.x, pos.y, pos.z)
        collisor.rotation = lib.from_euler(rot.x, rot.y, rot.z)

    end

    function collision_game_item:update(tpf)
        self.metainfo.override.game_item.update(self)
        if self.serializable.expired then
            return
        end
        local collisor = self.transient.collisor
        local collPos = collisor.position
        self.serializable.visual_info.position = { x = collPos.x, y = collPos.y, z = collPos.z }
    end

    function collision_game_item:kill_instance()
        self.metainfo.override.game_item.kill_instance(self)
    end

    return this
end
