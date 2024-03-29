--
-- Created by Ray1184.
-- DateTime: 04/10/2020 17:04
--
-- Animated and collidable stateful game object.
--

dependencies = {
    ----'Context.lua',
    --'libs/utils/Utils.lua',
    'libs/backend/HPMSFacade.lua',
    'libs/logic/templates/CollisionGameItem.lua',
    'libs/logic/templates/AnimGameItem.lua'
}

anim_collision_game_item = { }

function anim_collision_game_item:ret(path, id, bounding_radius, bounding_rect, ghost)
    lib = backend:get()
    insp = inspector:get()

    local id = 'anim_collision_game_item/' .. id
    local ret = anim_game_item:ret(path, id)
    local ret2 = collision_game_item:ret(path, id, bounding_radius, bounding_rect, ghost)

    local this = context_get_object(id, false, 
    function()
        log_debug('New anim_collision_game_item object ' .. id)

        local new = {
            serializable =
            {
                id = id
            }
        }

        local ret3 = merge_tables(ret, ret2)
        return merge_tables(ret3, new)

    end )

    local notSer = {
        not_serializable = { }
    }
   
    notSer.not_serializable = merge_tables(notSer.not_serializable, ret.not_serializable)
    this = merge_tables(this, notSer)


    local metainf = {
        metainfo =
        {
            object_type = 'anim_collision_game_item',
            parent_type = { 'anim_game_item', 'collision_game_item' },
            override =
            {
                anim_game_item =
                {
                    move_dir = ret.move_dir,
                    rotate = ret.rotate,
                    scale = ret.scale,
                    set_position = ret.set_position,
                    get_position = ret.get_position,
                    delete_transient_data = ret.delete_transient_data,
                    fill_transient_data = ret.fill_transient_data,
                    update = ret.update,
                    set_anim = ret.set_anim,
                    play = ret.play,
                    kill_instance = ret.kill_instance
                },
                collision_game_item =
                {
                    move_dir = ret2.move_dir,
                    rotate = ret2.rotate,
                    scale = ret2.scale,
                    get_scaled_rad = ret2.get_scaled_rad,
                    ghost = ret2.ghost,
                    set_position = ret2.set_position,
                    get_position = ret2.get_position,
                    delete_transient_data = ret2.delete_transient_data,
                    fill_transient_data = ret2.fill_transient_data,
                    update = ret2.update,
                    kill_instance = ret2.kill_instance
                }
            }
        }
    }

    metainf.metainfo.override = merge_tables(metainf.metainfo.override, ret.metainfo.override)
    metainf.metainfo.override = merge_tables(metainf.metainfo.override, ret2.metainfo.override)

    this = merge_tables(this, metainf)

    setmetatable(this, self)
    self.__index = self
    self.__tostring = function(o)
        return insp.inspect(o)
    end

    function anim_collision_game_item:set_position(x, y, z)
        -- Manage collisor only
        self.metainfo.override.collision_game_item.set_position(self, x, y, z)
    end

    function anim_collision_game_item:get_position()
        -- Manage collisor only
        return self.metainfo.override.collision_game_item.get_position(self)
    end


    function anim_collision_game_item:move_dir(ratio, dir)
        -- Manage collisor only
        self.metainfo.override.collision_game_item.move_dir(self, ratio, dir)
    end

    function anim_collision_game_item:rotate(rx, ry, rz)
        -- Manage collisor only
        self.metainfo.override.collision_game_item.rotate(self, rx, ry, rz)
    end

    function anim_collision_game_item:scale(sx, sy, sz)
        -- Manage collisor only
        self.metainfo.override.collision_game_item.scale(self, sx, sy, sz)
    end

    function anim_collision_game_item:get_scaled_rad()
        -- Manage collisor only
        return self.metainfo.override.collision_game_item.get_scaled_rad(self)
    end

    function anim_collision_game_item:ghost()
        -- Manage collisor only
        return self.metainfo.override.collision_game_item.ghost(self)
    end

    function anim_collision_game_item:delete_transient_data()
        -- Manage collisor only
        self.metainfo.override.collision_game_item.delete_transient_data(self)
    end

    function anim_collision_game_item:fill_transient_data(walkmap)
        -- Manage collisor only, for anim data just reset
        self.serializable.anim_data =
        {
            channel_name = k.default_animations.IDLE,
            mode = k.anim_modes.ANIM_MODE_LOOP,
            playing = false,
            changed = true,
            slowdown = 1,
            slice = 1
        }
        self.metainfo.override.collision_game_item.fill_transient_data(self, walkmap)
    end

    function anim_collision_game_item:update(tpf)
        self.metainfo.override.anim_game_item.update(self, tpf)
        self.metainfo.override.collision_game_item.update(self, tpf)

    end

    function anim_collision_game_item:set_anim(name)
        self.metainfo.override.anim_game_item.set_anim(self, name)
    end

    function anim_collision_game_item:play(mode, slowdown, slice)
        self.metainfo.override.anim_game_item.play(self, mode, slowdown, slice)
    end

    function anim_collision_game_item:kill_instance()
        self.metainfo.override.anim_game_item.kill_instance(self)
        self.metainfo.override.collision_game_item.kill_instance(self)
    end

    return this
end
