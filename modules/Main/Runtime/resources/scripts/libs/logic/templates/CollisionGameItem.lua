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
    'libs/thirdparty/Inspect.lua',
    'libs/logic/GameMechanicsConsts.lua'
}

collision_game_item = { }

function collision_game_item:ret(path, id, bounding_radius, ghost)
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
        --lib.update_collisor(self.transient.collisor, 0)
        self.serializable.visual_info.last_position = self.get_position(self)
        self.serializable.visual_info.position = { x = x, y = y, z = z }
        --self.serializable.visual_info.position = { x = collisor.position.x, y = collisor.position.y, z = collisor.position.z }
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
        local collPos = collisor.position

        self.serializable.visual_info.last_position = self.get_position(self)
        self.serializable.visual_info.position = { x = collPos.x, y = collPos.y, z = collPos.z }        
    end

    function collision_game_item:rotate(rx, ry, rz)
        if self.serializable.expired then
            return
        end
        local collisor = self.transient.collisor
        trx.rotate(collisor, rx, ry, rz)
        local collRot = lib.to_euler(collisor.rotation)
        self.serializable.visual_info.rotation = { x = collRot.x, y = collRot.y, z = collRot.z }
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
        local scaledRad = self.get_scaled_rad(self)
        local conf = lib.collisor_config()
        conf.gravity_affection = k.DEFAULT_GAVITY
        conf.active = not self.serializable.collision_info.ghost
        conf.max_step_height = k.DEFAULT_MAX_STEP_HEIGHT
        conf.bounding_radius = scaledRad
        --conf.bounding_rect = TODO
        local tra = {
            transient =
            {
                collisor = lib.make_node_collisor(self.transient.node,walkmap,conf)
            }
        }
        self = merge_tables(self, tra)

    end

    function collision_game_item:update(tpf)
        self.metainfo.override.game_item.update(self)
        if self.serializable.expired then
            return
        end
        --lib.update_collisor(self.transient.collisor, tpf)
    end

    function collision_game_item:kill_instance()
        self.metainfo.override.game_item.kill_instance(self)
    end

    return this
end
