-- -
--- Created by Ray1184.
--- DateTime: 08/10/2020 17:04
-- -
--- Main player.
-- -


dependencies = {
    'libs/Context.lua',
    'libs/utils/Utils.lua',
    'libs/backend/HPMSFacade.lua',
    'libs/logic/templates/AnimCollisionGameItem.lua',
    'libs/logic/GameMechanicsConsts.lua'
}

player = { }

function player:ret(path, id, rad, anagr)
    k = game_mechanics_consts:get()
    insp = inspector:get()

    local id = 'player/' .. id
    local ret = anim_collision_game_item:ret(path, id, rad)


    local this = context:inst():get_object(id,
    function()
        log_debug('New player object ' .. id)

        local new = {
            serializable =
            {
                id = id,
                action_mode = k.player_action_mode.SEARCH,
                walk_mode = k.player_walk_mode.IDLE,
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
                stats =
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

                },
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

    local metainf = {
        metainfo =
        {
            object_type = 'player',
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

    function player:set_anagr(anagr)
        self.serializable.anagr = anagr
    end

    function player:set_stats(stats)
        self.serializable.stats = stats
    end

    function player:modify_stat(stat_type, stat_name, stat_value, stat_affection)
        for i = 1, #self.serializable.stats[stat_type] do
            if self.serializable.stats[stat_type][i][1] == stat_name then
                self.serializable.stats[stat_type][i][2] = stat_value
                if stat_affection ~= nil then
                    if #self.serializable.stats[stat_type][i] == 3 then
                        self.serializable.stats[stat_type][i][3] = stat_affection
                    else
                        log_warn('State affection ratio not available for ' .. stat_name)
                    end
                end
                return
            end
        end
        log_warn('State with name ' .. stat_name .. ' not available')
    end

    function player:set_walk_mode(walk_mode)
        if not table_contains(k.player_walk_mode, walk_mode) then
            log_error('Player walk mode ' .. walk_mode .. ' not defined. Check managed player walk modes inside libs/logic/GameMechanicsConsts.lua or extend them')
        end
        self.serializable.walk_mode = walk_mode
    end

    function player:set_action_mode(action_mode)
        if not table_contains(k.player_action_mode, action_mode) then
            log_error('Player action mode ' .. action_mode .. ' not defined. Check managed player action modes inside libs/logic/GameMechanicsConsts.lua or extend them')
        end
        self.serializable.action_mode = action_mode
    end

    function player:set_position(x, y, z)
        self.metainfo.override.anim_collision_game_item.set_position(self, x, y, z)
    end

    function player:get_position()
        return self.metainfo.override.anim_collision_game_item.get_position(self)
    end

    function player:move_dir(ratio)
        local moveRatio = ratio
        if self.serializable.run then
            moveRatio = moveRatio * 2
        end        
        self.metainfo.override.anim_collision_game_item.move_dir(self, moveRatio)
    end

    function player:rotate(rx, ry, rz)
        self.metainfo.override.anim_collision_game_item.rotate(self, rx, ry, rz)
    end

    function player:scale(sx, sy, sz)
        self.metainfo.override.anim_collision_game_item.scale(self, sx, sy, sz)
    end

    function player:get_scaled_rad()
        return self.metainfo.override.anim_collision_game_item.get_scaled_rad(self)
    end

    function player:delete_transient_data()
        self.metainfo.override.anim_collision_game_item.delete_transient_data(self)
    end

    function player:fill_transient_data(walkmap)
        self.metainfo.override.anim_collision_game_item.fill_transient_data(self, walkmap)
    end

    function player:update(tpf)
        self.metainfo.override.anim_collision_game_item.update(self, tpf)
    end

    function player:set_anim(name)
        self.metainfo.override.anim_collision_game_item.set_anim(self, name)
    end

    function player:play(mode, slowdown, slice)
        self.metainfo.override.anim_collision_game_item.play(self, mode, slowdown, slice)
    end

    function player:set_event_callback(evt_callback)
        self.metainfo.evt_callback = evt_callback
    end

    function player:event(tpf, evt_info)
        if self.metainfo.evt_callback ~= nil then
            self.metainfo.evt_callback(tpf, evt_info)
        end
    end

    function player:kill_instance()
        self.metainfo.override.anim_collision_game_item.kill_instance(self)
    end

    return this
end
