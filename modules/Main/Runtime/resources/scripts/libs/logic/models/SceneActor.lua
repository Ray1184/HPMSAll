--
-- Created by Ray1184.
-- DateTime: 08/10/2020 17:04
--
-- Generic scene object with animation, collision and behavior (player, static, npc, etc...).
--


dependencies = {
    'libs/backend/HPMSFacade.lua',
    'libs/logic/templates/AnimCollisionGameItem.lua',
    'libs/logic/GameMechanicsConsts.lua'
}

scene_actor = { }

function scene_actor:ret(path, id, rad, rect, ghost, template)
    k = game_mechanics_consts:get()
    insp = inspector:get()
    local id = 'scene_actor/' .. id
    local ret = anim_collision_game_item:ret(path, id, rad, rect, ghost)

    local this = context_get_object(id, not(template or false),
    function()
        log_debug('New scene_actor object ' .. id)

        local new = {
            serializable =
            {
                id = id,
                action_mode = k.actor_action_mode.SEARCH,
                move_mode = k.actor_move_mode.IDLE,
                performing_action = false,
                movable = false,
                pushable = false,
                searchable = false,
                hittable = true,
                stats =
                { }
            }
        }
        return merge_tables(ret, new)
    end )

    local notSer = {
        not_serializable =
        {

        }
    }

    notSer.not_serializable = merge_tables(notSer.not_serializable, ret.not_serializable)
    this = merge_tables(this, notSer)

    local metainf = {
        metainfo =
        {
            object_type = 'scene_actor',
            parent_type = 'anim_collision_game_item',
            override =
            {
                anim_collision_game_item =
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

    function scene_actor:set_move_mode(moveMode)
        if not table_contains(k.actor_move_mode, moveMode) then
            log_error('Actor walk mode ' .. moveMode .. ' not defined. Check managed actor walk modes inside libs/logic/GameMechanicsConsts.lua or extend them')
        end
        self.serializable.move_mode = moveMode
    end

    function scene_actor:set_action_mode(actionMode)
        if not table_contains(k.actor_action_mode, actionMode) then
            log_error('Actor action mode ' .. actionMode .. ' not defined. Check managed actor action modes inside libs/logic/GameMechanicsConsts.lua or extend them')
        end
        self.serializable.action_mode = actionMode
    end

    function scene_actor:set_stats(stats)
        self.serializable.stats = stats
    end

    function scene_actor:get_stats()
        return self.serializable.stats
    end


    function scene_actor:set_position(x, y, z)
        self.metainfo.override.anim_collision_game_item.set_position(self, x, y, z)
    end

    function scene_actor:get_position()
        return self.metainfo.override.anim_collision_game_item.get_position(self)
    end

    function scene_actor:move_dir(ratio, dir)
        self.metainfo.override.anim_collision_game_item.move_dir(self, ratio, dir)
    end

    function scene_actor:rotate(rx, ry, rz)
        self.metainfo.override.anim_collision_game_item.rotate(self, rx, ry, rz)
    end

    function scene_actor:scale(sx, sy, sz)
        self.metainfo.override.anim_collision_game_item.scale(self, sx, sy, sz)
    end

    function scene_actor:get_scaled_rad()
        return self.metainfo.override.anim_collision_game_item.get_scaled_rad(self)
    end

    function scene_actor:ghost()
        -- Manage collisor only
        return self.metainfo.override.anim_collision_game_item.ghost(self)
    end

    function scene_actor:delete_transient_data()
        self.metainfo.override.anim_collision_game_item.delete_transient_data(self)
    end

    function scene_actor:fill_transient_data(walkmap)
        self.metainfo.override.anim_collision_game_item.fill_transient_data(self, walkmap)
    end

    function scene_actor:update(tpf)
        self.metainfo.override.anim_collision_game_item.update(self, tpf)
    end

    function scene_actor:set_anim(name)
        self.metainfo.override.anim_collision_game_item.set_anim(self, name)
    end

    function scene_actor:play(mode, slowdown, slice)
        self.metainfo.override.anim_collision_game_item.play(self, mode, slowdown, slice)
    end

    function scene_actor:set_event_callback(evtCallback)
        self.metainfo.evt_callback = evtCallback
    end

    function scene_actor:event(tpf, evtInfo)
        if self.metainfo.evt_callback ~= nil then
            self.metainfo.evt_callback(tpf, evtInfo)
        end
    end

    function scene_actor:kill_instance()
        self.metainfo.override.anim_collision_game_item.kill_instance(self)
    end

    context_put_full_ref_obj(this)

    return this
end
