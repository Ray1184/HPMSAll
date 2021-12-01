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
    'thirdparty/Inspect.lua'
}

anim_collision_game_item = { }

function anim_collision_game_item:ret(path, bounding_radius)
    lib = backend:get()
    insp = inspector:get()
    local id = 'anim_collision_game_item/' .. path
    local this = context:inst():get(cats.OBJECTS, id,
    function()
        utils.debug('New anim_collision_game_item object.')
        local ret = anim_game_item:ret(path)
        local ret2 = collision_game_item:ret(path, bounding_radius)
        local new = {
            serializable =
            {
                metainfo =
                {
                    object_type = 'anim_collision_game_object',
                    parent_type = { 'anim_game_object', 'collision_game_object' },
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
                            kill_instance = ret.kill_instance
                        }
                    }
                }
            }
        }

        ret = merge_tables(ret, ret2)
        ret = merge_tables(ret, new)

        return ret
    end )

    setmetatable(this, self)
    self.__index = self
    self.__tostring = function(o)
        return insp.inspect(o)
    end

    function anim_collision_game_item:move_dir(ratio)
        self.serializable.override.collision_game_item:move_dir(ratio)
    end

    function anim_collision_game_item:rotate(rx, ry, rz)
        self.serializable.override.collision_game_item:rotate(rx, ry, rz)
    end

    function anim_collision_game_item:delete_transient_data()
        self.serializable.override.anim_game_item.delete_transient_data(self)
        self.serializable.override.collision_game_item.delete_transient_data(self)
    end

    function anim_collision_game_item:fill_transient_data(walkmap)
        self.serializable.override.anim_game_item.fill_transient_data(self)
        self.serializable.override.collision_game_item.delete_transient_data(self, walkmap)
    end

    function anim_collision_game_item:update()
        self.serializable.override.anim_game_item.update(self)
        self.serializable.override.collision_game_item.update(self)

    end

    return this
end
