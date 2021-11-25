-- -
--- Created by Ray1184.
--- DateTime: 04/10/2020 17:04
-- -
--- Animated stateful game object.
-- -


dependencies = {
    'libs/Context.lua',
    'libs/utils/Utils.lua',
    'libs/logic/GameItem.lua',
    'libs/backend/HPMSFacade.lua',
    'thirdparty/Inspect.lua'
}
lib = backend:get()

anim_game_item = { }

function anim_game_item:ret(path)
    lib = backend:get()
    insp = inspector:get()
    local id = 'anim_game_item/' .. path
    local this = context:inst():get(cats.OBJECTS, id,
    function()
        log_debug('New anim_game_item object ' .. id)
        local ret = game_item:ret(path)
        local new = {
            serializable =
            {
                data =
                {
                    anim_data =
                    {
                        channel_name = 'my_animation',
                        current_frame = 0,
                        frame_count = 0,
                        loop = false,
                        play = false,
                        slowdown = 1
                    }
                },
                metainfo =
                {
                    object_type = 'anim_game_object',
                    parent_type = 'game_object',
                    override =
                    {
                        game_item =
                        {
                            move_dir = ret.move_dir,
                            rotate = ret.rotate,
                            delete_transient_data = ret.delete_transient_data,
                            fill_transient_data = ret.fill_transient_data,
                            update = ret.update
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

    function anim_game_item:move_dir(ratio)
        self.serializable.metainfo.override.game_item:move_dir(ratio)
    end

    function anim_game_item:rotate(rx, ry, rz)
        self.serializable.metainfo.override.game_item:rotate(rx, ry, rz)
    end

    function anim_game_item:delete_transient_data()
        self.serializable.metainfo.override.game_item.delete_transient_data(self)        
    end

    function anim_game_item:fill_transient_data()
        self.serializable.metainfo.override.game_item.fill_transient_data(self)        
    end

    function anim_game_item:update()
        self.serializable.metainfo.override.game_item.update(self)        
    end

    function anim_game_item:set_anim(name)
        if self.serializable.data.expired then
            return
        end
        self.serializable.data.anim_data.channel_name = name
        lib.play_anim(self.transient.entity, name)
        
    end


    return this
end
