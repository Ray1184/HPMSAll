-- -
--- Created by Ray1184.
--- DateTime: 08/10/2020 17:04
-- -
--- Generic non-playable scene object with behavior.
-- -


dependencies = {
    'libs/Context.lua',
    'libs/utils/Utils.lua',
    'libs/backend/HPMSFacade.lua',
    'libs/logic/templates/AnimCollisionGameItem.lua',
    'libs/logic/GameMechanicsConsts.lua'
}

scene_object = { }

function scene_object:ret(path, id, rad)
    k = game_mechanics_consts:get()
    insp = inspector:get()

    local id = 'scene_object/' .. id
    local ret = anim_collision_game_item:ret(path, id, rad)

    local this = context:inst():get_object(id,
    function()
        log_debug('New scene_object object ' .. id)

        local new = {
            serializable =
            {
                id = id,
                obj_info =
                {
                    pushable = true,
                    searchable = true,
                    hittable = true,
                    modifiers =
                    {

                        -- Amount
                        { k.stats.standard_params.HP, 0 },
                        { k.stats.standard_params.MAX_HP, 0 },
                        { k.stats.standard_params.SP, 0 },
                        { k.stats.standard_params.MAX_SP, 0 },
                        { k.stats.standard_params.VP, 0 },
                        { k.stats.standard_params.MAX_VP, 0 },
                        { k.stats.standard_params.LV, 0 },
                        { k.stats.standard_params.AP, 0 },
                        { k.stats.standard_params.MONEY, 0 },
                        { k.stats.standard_params.ARMOR, 0 },

                        { k.stats.support_params.STRENGTH, 0 },
                        { k.stats.support_params.STAMINA, 0 },
                        { k.stats.support_params.INTELLIGENCE, 0 },
                        { k.stats.support_params.SCIENCE, 0 },
                        { k.stats.support_params.HANDYMAN, 0 },
                        { k.stats.support_params.DEXTERITY, 0 },
                        { k.stats.support_params.OCCULT, 0 },
                        { k.stats.support_params.CHARISMA, 0 },
                        { k.stats.support_params.FORTUNE, 0 },

                        -- Affection flag, affection ratio (1: 100%, 0: 0%)
                        -- Amount
                        { k.stats.standard_params.HP, 0 },
                        { k.stats.standard_params.MAX_HP, 0 },
                        { k.stats.standard_params.SP, 0 },
                        { k.stats.standard_params.MAX_SP, 0 },
                        { k.stats.standard_params.VP, 0 },
                        { k.stats.standard_params.MAX_VP, 0 },
                        { k.stats.standard_params.LV, 0 },
                        { k.stats.standard_params.AP, 0 },
                        { k.stats.standard_params.MONEY, 0 },
                        { k.stats.standard_params.ARMOR, 0 },

                        { k.stats.support_params.STRENGTH, 0 },
                        { k.stats.support_params.STAMINA, 0 },
                        { k.stats.support_params.INTELLIGENCE, 0 },
                        { k.stats.support_params.SCIENCE, 0 },
                        { k.stats.support_params.HANDYMAN, 0 },
                        { k.stats.support_params.DEXTERITY, 0 },
                        { k.stats.support_params.OCCULT, 0 },
                        { k.stats.support_params.CHARISMA, 0 },
                        { k.stats.support_params.FORTUNE, 0 },

                        -- Affection flag, affection ratio (1: 100%, 0: 0%)
                        { k.stats.negative_status_params.SLEEP, false, 1 },
                        { k.stats.negative_status_params.POISON, false, 1 },
                        { k.stats.negative_status_params.TOXIN, false, 1 },
                        { k.stats.negative_status_params.BURN, false, 1 },
                        { k.stats.negative_status_params.FREEZE, false, 1 },
                        { k.stats.negative_status_params.BLIND, false, 1 },
                        { k.stats.negative_status_params.PARALYSIS, false, 1 },
                        { k.stats.negative_status_params.SHOCK, false, 1 },

                        { k.stats.positive_status_params.REGEN, false, 1 },
                        { k.stats.positive_status_params.RAD, false, 1 },
                        { k.stats.positive_status_params.INVINCIBLITY, false },

                        { k.stats.phobies.ARACHNOPHOBIA, false, 1 },
                        { k.stats.phobies.HEMOPHOBIA, false, 1 },
                        { k.stats.phobies.ANTHROPOPHOBIA, false, 1 },
                        { k.stats.phobies.AQUAPHOBIA, false, 1 },
                        { k.stats.phobies.PYROPHOBIA, false, 1 },
                        { k.stats.phobies.ACROPHOBIA, false, 1 },
                        { k.stats.phobies.NECROPHOBIA, false, 1 },
                        { k.stats.phobies.AEROPHOBIA, false, 1 },
                        { k.stats.phobies.AVIOPHOBIA, false, 1 },
                        { k.stats.phobies.PHOTOPHOBIA, false, 1 },
                        { k.stats.phobies.NYCTOPHOBIA, false, 1 },
                        { k.stats.phobies.CRYOPHOBIA, false, 1 }

                    }
                }

            }
        }
        return merge_tables(ret, new)
    end )

    local metainf = {
        metainfo =
        {
            object_type = 'scene_object',
            parent_type = 'anim_collision_game_item',
            override =
            {
                anim_collision_game_item =
                {
                    set_position = ret.set_position,
                    get_position = ret.get_position,
                    move_dir = ret.move_dir,
                    rotate = ret.rotate,
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

    local this = merge_tables(this, metainf)

    setmetatable(this, self)
    self.__index = self
    self.__tostring = function(o)
        return insp.inspect(o)
    end

    function scene_object:set_position(x, y, z)
        self.metainfo.override.anim_collision_game_item.set_position(self, x, y, z)
    end

    function scene_object:get_position()
        return self.metainfo.override.anim_collision_game_item.get_position(self)
    end

    function scene_object:move_dir(ratio)
        local moveRatio = ratio
        if self.serializable.run then
            moveRatio = moveRatio * 2
        end
        self.metainfo.override.anim_collision_game_item.move_dir(self, moveRatio)
    end

    function scene_object:rotate(rx, ry, rz)
        self.metainfo.override.anim_collision_game_item.rotate(self, rx, ry, rz)
    end

    function scene_object:delete_transient_data()
        self.metainfo.override.anim_collision_game_item.delete_transient_data(self)
    end

    function scene_object:fill_transient_data(walkmap)
        self.metainfo.override.anim_collision_game_item.fill_transient_data(self, walkmap)
    end

    function scene_object:update(tpf)
        self.metainfo.override.anim_collision_game_item.update(self, tpf)
    end

    function scene_object:set_anim(name)
        self.metainfo.override.anim_collision_game_item.set_anim(self, name)
    end

    function scene_object:play(mode, slowdown, slice)
        self.metainfo.override.anim_collision_game_item.play(self, mode, slowdown, slice)
    end

    function scene_object:set_event_callback(evt_callback)
        self.metainfo.evt_callback = evt_callback
    end

    function scene_object:event(tpf, evt_info)
        if self.metainfo.evt_callback ~= nil then
            self.metainfo.evt_callback(tpf, evt_info)
        end
    end

    function scene_object:kill_instance()
        self.metainfo.override.anim_collision_game_item.kill_instance(self)
    end

    return this
end
