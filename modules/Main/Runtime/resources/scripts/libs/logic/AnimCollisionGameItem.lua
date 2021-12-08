-- -
--- Created by Ray1184.
--- DateTime: 04/10/2020 17:04
-- -
--- Animated and collidable stateful game object.
-- -

dependencies = {
    'libs/Context.lua',
    'libs/utils/Utils.lua',
    'libs/logic/GameItem.lua',
    'libs/backend/HPMSFacade.lua',
    'libs/logic/CollisionGameItem.lua',
    'libs/logic/AnimGameItem.lua',
    'thirdparty/Inspect.lua'
}

anim_collision_game_item = { }

function anim_collision_game_item:ret(path, bounding_radius)
    lib = backend:get()
    insp = inspector:get()

    local id = 'anim_collision_game_item/' .. path
    local ret = anim_game_item:ret(path)
    local ret2 = collision_game_item:ret(path, bounding_radius)
    
    local this = context:inst():get(cats.OBJECTS, id,
    function()
        log_debug('New anim_collision_game_item object ' .. id)

        local new = {
            serializable =
            {
                id = id
            }
        }

        ret3 = merge_tables(ret, ret2)
        ret4 = merge_tables(ret3, new)
        return ret4
        
    end )


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


    function anim_collision_game_item:move_dir(ratio)
        -- Manage collisor only
        self.metainfo.override.collision_game_item.move_dir(self, ratio)
    end

    function anim_collision_game_item:rotate(rx, ry, rz)
        -- Manage collisor only
        self.metainfo.override.collision_game_item.rotate(self, rx, ry, rz)
    end

    function anim_collision_game_item:delete_transient_data()
        -- Manage collisor only
        self.metainfo.override.collision_game_item.delete_transient_data(self)
    end

    function anim_collision_game_item:fill_transient_data(walkmap)
        -- Manage collisor only
        self.metainfo.override.collision_game_item.fill_transient_data(self, walkmap)
    end

    function anim_collision_game_item:update(tpf)
        self.metainfo.override.anim_game_item.update(self, tpf)
        self.metainfo.override.collision_game_item.update(self)

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
