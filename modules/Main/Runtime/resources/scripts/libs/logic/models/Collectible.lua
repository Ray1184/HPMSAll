-- -
--- Created by Ray1184.
--- DateTime: 08/10/2020 17:04
-- -
--- Generic collectible and usable object.
-- -


dependencies = {
    'libs/Context.lua',
    'libs/utils/Utils.lua',
    'libs/logic/templates/GameItem.lua',
    'libs/backend/HPMSFacade.lua',
    'libs/thirdparty/Inspect.lua'
}

collectible = { }

function collectible:ret(path, id)
    lib = backend:get()
    k = game_mechanics_consts:get()
    insp = inspector:get()

    local id = 'collectible/' .. id
    local ret = game_item:ret(path)

    local this = context:inst():get_object(id,
    function()
        log_debug('New collectible object ' .. id)

        local new = {
            serializable =
            {
                id = id,
                visual_info_2d =
                {
                    position = { 0, 0, 0 },
                    rotation = { 0, 0, 0 },
                    scale = { 0, 0, 0 }
                },
                selected = false,
                obj_info =
                {
                    name = 'Collectible',
                    description = 'N/A',
                    item_type = k.item_types.ACTIONS,
                    item_license = k.item_license.NONE,
                    amount = 1,
                    available_actions = { k.item_actions.USE, k.item_actions.CHECK, k.item_actions.DROP },
                    show_amount = true,
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

    local metainf =
    {
        metainfo =
        {
            object_type = 'collectible',
            parent_type = 'game_object',
            override =
            {
                game_item =
                {
                    set_position = ret.set_position,
                    get_position = ret.get_position,
                    move_dir = ret.move_dir,
                    rotate = ret.rotate,
                    scale = ret.scale,
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

    function collectible:set_position(x, y, z)
        self.metainfo.override.anim_collision_game_item.set_position(self, x, y, z)
    end

    function collectible:get_position()
        return self.metainfo.override.anim_collision_game_item.get_position(self)
    end

    function collectible:move_dir(ratio)
        self.metainfo.override.game_item.move_dir(self, ratio)
    end

    function collectible:rotate(rx, ry, rz)
        self.metainfo.override.game_item.rotate(self, rx, ry, rz)
    end

    function collectible:scale(sx, sy, sz)
        self.metainfo.override.anim_collision_game_item.scale(self, sx, sy, sz)
    end

    function collectible:delete_transient_data()
        self.metainfo.override.game_item.delete_transient_data(self)
    end

    function collectible:fill_transient_data(actions)
        self.metainfo.override.game_item.fill_transient_data(self)
        if self.serializable.expired then
            return
        end
        self.transient.available_actions = { }
        local available_actions = self.serializable.obj_info.available_actions
        for i = 1, #actions do
            if table_contains(available_actions, actions[i][1]) then
                table.insert(self.transient.available_actions, actions[i][1])
            else
                log_warn('Action ' .. actions[i][1] .. ' not available for collectible item ' .. self.serializable.obj_info)
            end
        end
    end

    function collectible:update()
        self.metainfo.override.game_item.update(self)
    end


    return this
end
