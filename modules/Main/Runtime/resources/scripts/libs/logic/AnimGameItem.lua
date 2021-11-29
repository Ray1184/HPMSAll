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

ANIM_MODE_LOOP = 0
ANIM_MODE_ONCE = 1
ANIM_MODE_FRAME = 2

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
                        mode = ANIM_MODE_FRAME,
                        playing = false,
                        slowdown = 1,
                        slice = 1
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
       
    function anim_game_item:update(tpf)
        self.serializable.metainfo.override.game_item.update(self)
        if self.serializable.data.expired then
            return
        end

        if self.serializable.data.anim_data.playing then

            if self.serializable.data.anim_data.mode == ANIM_MODE_ONCE then
                local finished = lib.anim_finished(self.transient.entity, self.serializable.data.anim_data.channel_name)
                if finished then
                    lib.stop_rewind_anim(self.transient.entity)
                    self.serializable.data.anim_data.playing = false
                    return
                end
            end

            time = tpf / self.serializable.data.anim_data.slowdown
            lib.update_anim(self.transient.entity, self.serializable.data.anim_data.channel_name, time)

            if self.serializable.data.anim_data.mode == ANIM_MODE_FRAME then
                self.serializable.data.anim_data.playing = false
            end
        end
    end

    function anim_game_item:set_anim(name)
        if self.serializable.data.expired then
            return
        end
        self.serializable.data.anim_data.channel_name = name   
    end

    function anim_game_item:play(mode, slowdown, slice)
        if self.serializable.data.expired or self.serializable.data.anim_data.playing then
            return
        end
        self.serializable.data.anim_data.mode = mode
        self.serializable.data.anim_data.slowdown = slowdown or 1
        self.serializable.data.anim_data.slice = slice or 1
        self.serializable.data.anim_data.playing = true        
        lib.slice_anim(self.transient.entity, self.serializable.data.anim_data.channel_name, self.serializable.data.anim_data.slice)
        lib.play_anim(self.transient.entity, self.serializable.data.anim_data.channel_name)        
    end

    return this
end
