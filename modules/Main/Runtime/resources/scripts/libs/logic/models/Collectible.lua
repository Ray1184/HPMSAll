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
lib = backend:get()

collectible = { }

function collectible:ret(path, id)
    lib = backend:get()
    k = game_mechanics_consts:get()
    insp = inspector:get()

    local id = 'collectible/' .. id
    local ret = game_item:ret(path)

    local this = context:inst():get(cats.OBJECTS, id,
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
                    move_dir = ret.move_dir,
                    rotate = ret.rotate,
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

    function collectible:move_dir(ratio)
        self.metainfo.override.game_item.move_dir(ratio)
    end

    function collectible:rotate(rx, ry, rz)
        self.metainfo.override.game_item.rotate(rx, ry, rz)
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
