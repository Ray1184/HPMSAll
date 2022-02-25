--
-- Created by Ray1184.
-- DateTime: 04/10/2020 17:04
--
-- Animated stateful game object.
--

dependencies = {
    'libs/Context.lua',
    'libs/utils/Utils.lua',
    'libs/logic/templates/GameItem.lua',
    'libs/backend/HPMSFacade.lua',
    'libs/thirdparty/Inspect.lua',
    'libs/logic/GameMechanicsConsts.lua'
}

anim_game_item = { }

function anim_game_item:ret(path, id)
    lib = backend:get()
    k = game_mechanics_consts:get()
    insp = inspector:get()

    local id = 'anim_game_item/' .. id
    local ret = game_item:ret(path, id)

    local this = context:inst():get_object(id,
    function()
        log_debug('New anim_game_item object ' .. id)

        local new = {
            serializable =
            {
                id = id,
                anim_data =
                {
                    channel_name = k.default_animations.IDLE,
                    mode = k.anim_modes.ANIM_MODE_FRAME,
                    playing = false,
                    changed = true,
                    slowdown = 1,
                    slice = 1
                }
            }
        }

        return merge_tables(ret, new)
    end )

    local metainf =
    {
        metainfo =
        {
            object_type = 'anim_game_item',
            parent_type = 'game_object',
            override =
            {
                game_item =
                {
                    move_dir = ret.move_dir,
                    rotate = ret.rotate,
                    scale = ret.scale,
                    set_position = ret.set_position,
                    get_position = ret.get_position,
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

    function anim_game_item:set_position(x, y, z)
        self.metainfo.override.game_item.set_position(self, x, y, z)
    end

    function anim_game_item:get_position()
        return self.metainfo.override.game_item.get_position(self)
    end

    function anim_game_item:move_dir(ratio, dir)
        self.metainfo.override.game_item.move_dir(self, ratio, dir)
    end

    function anim_game_item:rotate(rx, ry, rz)
        self.metainfo.override.game_item.rotate(self, rx, ry, rz)
    end

    function anim_game_item:scale(sx, sy, sz)
        self.metainfo.override.game_item.scale(self, sx, sy, sz)
    end

    function anim_game_item:delete_transient_data()
        self.metainfo.override.game_item.delete_transient_data(self)
    end

    function anim_game_item:fill_transient_data()
        self.metainfo.override.game_item.fill_transient_data(self)
    end

    function anim_game_item:update(tpf)
        self.metainfo.override.game_item.update(self)
        if self.serializable.expired then
            return
        end

        if self.serializable.anim_data.playing then

            if self.serializable.anim_data.mode == k.anim_modes.ANIM_MODE_ONCE then
                local finished = lib.anim_finished(self.transient.entity, self.serializable.anim_data.channel_name)
                if finished then
                    lib.stop_rewind_anim(self.transient.entity)
                    self.serializable.anim_data.playing = false
                    return
                end
            end

            time = tpf / self.serializable.anim_data.slowdown
            lib.update_anim(self.transient.entity, time, true, k.DEFAULT_ANIM_TRANSITION_TIME)

            if self.serializable.anim_data.mode == k.anim_modes.ANIM_MODE_FRAME then
                self.serializable.anim_data.playing = false
            end
        end
    end

    function anim_game_item:set_anim(name)
        if self.serializable.expired or self.serializable.anim_data.channel_name == name then
            return
        end
        self.serializable.anim_data.channel_name = name
        self.serializable.anim_data.changed = true
    end

    function anim_game_item:play(mode, slowdown, slice)
        if self.serializable.expired or not self.serializable.anim_data.changed then
            return
        end
        self.serializable.anim_data.changed = false
        self.serializable.anim_data.mode = mode
        self.serializable.anim_data.slowdown = slowdown or 1
        self.serializable.anim_data.slice = slice or 1
        self.serializable.anim_data.playing = true
        lib.slice_anim(self.transient.entity, self.serializable.anim_data.channel_name, self.serializable.anim_data.slice)
        lib.play_anim(self.transient.entity, self.serializable.anim_data.channel_name)
    end

    function anim_game_item:kill_instance()
        self.metainfo.override.game_item.kill_instance(self)
    end

    return this
end
