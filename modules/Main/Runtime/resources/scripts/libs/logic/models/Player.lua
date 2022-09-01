--
-- Created by Ray1184.
-- DateTime: 08/10/2020 17:04
--
-- Main player.
--


dependencies = {
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
    local this = context_get_object(id, true,
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
                    objects = { }
                }

            }
        }

        return merge_tables(ret, new)
    end )

    local notSer = {
        not_serializable =
        {

            equip_attachable = nil,
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
                    get_stats = ret.get_stats,
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

    function player:set_move_mode(moveMode)
        self.metainfo.override.scene_actor.set_move_mode(self, moveMode)
    end

    function player:set_action_mode(actionMode)
        self.metainfo.override.scene_actor.set_action_mode(self, actionMode)
    end

    function player:set_anagr(anagr)
        self.not_serializable.anagr = anagr
    end

    function player:get_inventory()
        return self.serializable.inventory
    end

    function player:get_anagr()
        return self.not_serializable.anagr
    end

    function player:set_stats(stats)
        self.metainfo.override.scene_actor.set_stats(self, stats)
    end

    function player:get_stats()
        return self.metainfo.override.scene_actor.get_stats(self)
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
        moveRatioByAction[k.actor_action_mode.EQUIP] = 0
        moveRatioByAction[k.actor_action_mode.PUSH] = k.actor_move_ratio.SLOW
        moveRatioByAction[k.actor_action_mode.STEALTH] = k.actor_move_ratio.SLOWER
        moveRatioByAction[k.actor_action_mode.CROWL] = k.actor_move_ratio.SLOWER
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
        if not self.transientDataInit then
            return
        end
        if self.not_serializable.equip_attachable ~= nil then
            local equipWeaponModel = self.not_serializable.equip_attachable
            equipWeaponModel:delete_transient_data()
        end
        self.metainfo.override.scene_actor.delete_transient_data(self)
    end

    function player:fill_transient_data(walkmap)
        self.metainfo.override.scene_actor.fill_transient_data(self, walkmap)
        if self.serializable.expired then
            return
        end
        if self.serializable.equip ~= nil then
            local weapon = context_get_full_ref(self.serializable.equip)
            if weapon == nil then
                local id, suffix = get_full_id_parts(self.serializable.equip)
                weapon = context_get_instance(k.inst_cat.COLLECTIBLES, id, suffix, 1)
            end
            local attachTo = weapon:get_properties().weapon_properties.attach_to
            local parentEntity = self.transient.entity

            local posOffset = weapon:get_properties().weapon_properties.equip_position_offset
            local rotOffset = weapon:get_properties().weapon_properties.equip_rotation_offset
            local scale = weapon:get_properties().weapon_properties.equip_scale
            self.not_serializable.equip_attachable = attachable:ret(weapon.serializable.path, weapon.serializable.id, parentEntity, attachTo, posOffset, rotOffset, scale)
            self.not_serializable.equip_attachable:fill_transient_data()
        end
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

    function player:set_event_callback(evtCallback)
        self.metainfo.override.scene_actor.set_event_callback(self, evtCallback)
    end

    function player:event(tpf, evtInfo)
        self.metainfo.override.scene_actor.event(self, tpf, evtInfo)
    end

    function player:kill_instance()
        self.metainfo.override.scene_actor.kill_instance(self)
    end

    context_put_full_ref_obj(this)

    return this
end
