--
-- Created by Ray1184.
-- DateTime: 08/10/2020 17:04
--
-- Main player.
--


dependencies = {
    ----'Context.lua',
    -- 'libs/utils/Utils.lua',
    'libs/backend/HPMSFacade.lua',
    'libs/logic/models/SceneActor.lua',
    'libs/logic/GameMechanicsConsts.lua'
}

player = { }

function player:ret(path, id, rad, rect, ghost)
    k = game_mechanics_consts:get()
    insp = inspector:get()

    local id = 'player/' .. id
    local ret = scene_actor:ret(path, id, rad, rect, ghost, true)
    local this = context:inst():get_object(id, true,
    function()
        log_debug('New player object ' .. id)

        local new = {
            serializable =
            {
                id = id,
                equip = nil,
                inventory =
                {
                    size = 10,
                    weapons = { },
                    supplies = { },
                    key_items = { },
                    reading_items = { },
                    misc_items = { }
                }

            }
        }

        return merge_tables(ret, new)
    end )

    local notSer = {
        not_serializable =
        {
            anagr =
            {
                name = 'Player',
                birth_date = '0000-01-01',
                birth_place = 'Nowhere',
                country = 'Outworld',
                job = 'Nothing',
                height = 0,
                weight = 0,
                info = 'N/A',
                photo = 'N/A'
            },
        }
    }

    notSer.not_serializable = merge_tables(notSer.not_serializable, ret.not_serializable)
    this = merge_tables(this, notSer)

    local metainf = {
        metainfo =
        {
            object_type = 'player',
            parent_type = 'scene_actor',
            override =
            {
                scene_actor =
                {
                    set_position = ret.set_position,
                    get_position = ret.get_position,
                    move_dir = ret.move_dir,
                    rotate = ret.rotate,
                    scale = ret.scale,
                    get_scaled_rad = ret.get_scaled_rad,
                    ghost = ret.ghost,
                    delete_transient_data = ret.delete_transient_data,
                    fill_transient_data = ret.fill_transient_data,
                    update = ret.update,
                    set_anim = ret.set_anim,
                    play = ret.play,
                    set_stats = ret.set_stats,
                    modify_stat = ret.modify_stat,
                    get_stat = ret.get_stat,
                    set_move_mode = ret.set_move_mode,
                    set_action_mode = ret.set_action_mode,
                    event = ret.event,
                    set_event_callback = ret.set_event_callback,
                    kill_instance = ret.kill_instance
                }
            }
        }
    }

    metainf.metainfo.override = merge_tables(metainf.metainfo.override, ret.metainfo.override)

    this = merge_tables(this, metainf)

    setmetatable(this, self)
    self.__index = self
    self.__tostring = function(o)
        return insp.inspect(o)
    end

    function player:set_move_mode(move_mode)
        self.metainfo.override.scene_actor.set_move_mode(self, move_mode)
    end

    function player:set_action_mode(action_mode)
        self.metainfo.override.scene_actor.set_action_mode(self, action_mode)
    end

    function player:set_anagr(anagr)
        self.not_serializable.anagr = anagr
    end

    function player:get_anagr()
        return self.not_serializable.anagr
    end

    function player:set_stats(stats)
        self.serializable.stats = stats
    end

    function player:modify_stat(stat_name, stat_value, stat_affection)
        self.metainfo.override.scene_actor.modify_stat(self, stat_name, stat_value, stat_affection)
    end

    function player:get_stat(stat_name)
        return self.metainfo.override.scene_actor.get_stat(self, stat_name)
    end

    function player:set_position(x, y, z)
        self.metainfo.override.scene_actor.set_position(self, x, y, z)
    end

    function player:get_position()
        return self.metainfo.override.scene_actor.get_position(self)
    end

    function player:move_dir(ratio, dir)
        local moveRatioByAction = { }

        moveRatioByAction[k.actor_action_mode.SEARCH] = 0
        moveRatioByAction[k.actor_action_mode.COMBAT] = 0
        moveRatioByAction[k.actor_action_mode.EQUIP_HANDGUN] = 0
        moveRatioByAction[k.actor_action_mode.EQUIP_SHOTGUN] = 0
        moveRatioByAction[k.actor_action_mode.EQUIP_MG] = 0
        moveRatioByAction[k.actor_action_mode.EQUIP_RIFLE] = 0
        moveRatioByAction[k.actor_action_mode.EQUIP_THROWABLE] = 0
        moveRatioByAction[k.actor_action_mode.PUSH] = k.actor_move_ratio.SLOW
        moveRatioByAction[k.actor_action_mode.STEALTH] = k.actor_move_ratio.SLOWER
        moveRatioByAction[k.actor_action_mode.SWIM] = k.actor_move_ratio.SLOW
        moveRatioByAction[k.actor_action_mode.JUMP] = 0

        local moveRatio = ratio * k.actor_move_ratio.NORMAL

        if self.serializable.performing_action then
            moveRatio = ratio * moveRatioByAction[self.serializable.action_mode]
        else
            if self.serializable.move_mode == k.actor_move_mode.RUN then
                moveRatio = ratio * k.actor_move_ratio.FASTER
            end
        end
        self.metainfo.override.scene_actor.move_dir(self, moveRatio, dir)
    end

    function player:rotate(rx, ry, rz)
        self.metainfo.override.scene_actor.rotate(self, rx, ry, rz)
    end

    function player:scale(sx, sy, sz)
        self.metainfo.override.scene_actor.scale(self, sx, sy, sz)
    end

    function player:get_scaled_rad()
        return self.metainfo.override.scene_actor.get_scaled_rad(self)
    end

    function player:ghost()
        -- Manage collisor only
        return self.metainfo.override.scene_actor.ghost(self)
    end

    function player:delete_transient_data()
        self.metainfo.override.scene_actor.delete_transient_data(self)
    end

    function player:fill_transient_data(walkmap)
        self.metainfo.override.scene_actor.fill_transient_data(self, walkmap)
    end

    function player:update(tpf)
        self.metainfo.override.scene_actor.update(self, tpf)
    end

    function player:set_anim(name)
        self.metainfo.override.scene_actor.set_anim(self, name)
    end

    function player:play(mode, slowdown, slice)
        self.metainfo.override.scene_actor.play(self, mode, slowdown, slice)
    end

    function player:set_event_callback(evt_callback)
        self.metainfo.override.scene_actor.set_event_callback(self, evt_callback)
    end

    function player:event(tpf, evt_info)
        self.metainfo.override.scene_actor.event(self, tpf, evt_info)
    end

    function player:kill_instance()
        self.metainfo.override.scene_actor.kill_instance(self)
    end

    return this
end
