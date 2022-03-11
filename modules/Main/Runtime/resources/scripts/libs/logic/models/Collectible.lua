--
-- Created by Ray1184.
-- DateTime: 08/10/2020 17:04
--
-- Generic collectible and usable object.
--


dependencies = {
    ----'Context.lua',
    -- 'libs/utils/Utils.lua',
    'libs/logic/templates/GameItem.lua',
    'libs/backend/HPMSFacade.lua',
    'libs/thirdparty/Inspect.lua'
}

collectible = { }

function collectible:ret(path, id, amount, showAmount)
    lib = backend:get()
    k = game_mechanics_consts:get()
    insp = inspector:get()

    local id = 'collectible/' .. id
    local ret = game_item:ret(path)

    local this = context:inst():get_object(id, true,
    function()
        log_debug('New collectible object ' .. id)

        local new = {
            serializable =
            {
                id = id,
                selected = false,
                amount = amount or 1,
                show_amount = showAmount or false
            }
        }

        return merge_tables(ret, new)
    end )

    local notSer = {
        not_serializable = { }
    }
   
    notSer.not_serializable = merge_tables(notSer.not_serializable, ret.not_serializable)
    this = merge_tables(this, notSer)

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

    metainf.metainfo.override = merge_tables(metainf.metainfo.override, ret.metainfo.override)

    this = merge_tables(this, metainf)

    setmetatable(this, self)
    self.__index = self
    self.__tostring = function(o)
        return insp.inspect(o)
    end

    function collectible:set_position(x, y, z)
        self.metainfo.override.game_item.set_position(self, x, y, z)
    end

    function collectible:get_position()
        return self.metainfo.override.game_item.get_position(self)
    end

    function collectible:move_dir(ratio, dir)
        self.metainfo.override.game_item.move_dir(self, ratio, dir)
    end

    function collectible:rotate(rx, ry, rz)
        self.metainfo.override.game_item.rotate(self, rx, ry, rz)
    end

    function collectible:scale(sx, sy, sz)
        self.metainfo.override.game_item.scale(self, sx, sy, sz)
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

    function collectible:set_action_callback(action_callback)
        self.metainfo.action_callback = action_callback
    end

    function collectible:action(action_info)
        if self.metainfo.action_callback ~= nil then
            self.metainfo.action_callback(action_info)
        end
    end

    function scene_actor:kill_instance()
        self.metainfo.override.game_item.kill_instance(self)
    end

    return this
end
