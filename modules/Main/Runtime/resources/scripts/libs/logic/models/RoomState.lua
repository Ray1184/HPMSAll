--
-- Created by Ray1184.
-- DateTime: 08/10/2020 17:04
--
-- Model for room, keeping the state of current player, actors, collectibles and variables.
--


dependencies = {
    'libs/logic/templates/AbstractObject.lua',
    'libs/backend/HPMSFacade.lua',
    'libs/thirdparty/Inspect.lua'
}

room_state = { }

function room_state:ret(id)
    lib = backend:get()
    k = game_mechanics_consts:get()
    insp = inspector:get()
    local id = 'room_state/' .. id
    local ret = abstract_object:ret(id)

    local this = context_get_object(id, true,
    function()
        log_debug('New room_state object ' .. id)

        local new = {
            serializable =
            {
                collectibles = { },
                variables = { }
            }
        }

        return merge_tables(ret, new)
    end )

    local metainf =
    {
        metainfo =
        {
            object_type = 'room_state',
            parent_type = 'abstract_object',
            override =
            { }
        }
    }

    local this = merge_tables(this, metainf)

    setmetatable(this, self)
    self.__index = self
    self.__tostring = function(o)
        return insp.inspect(o)
    end

    function room_state:get_var(varName)
        return self.serializable.variables[varName]
    end

    function room_state:set_var(varName, var)
        self.serializable.variables[varName] = var
    end

    function room_state:has_item(id)
        for i = 1, #self.serializable.collectibles do
            if self.serializable.collectibles[i].id == id then
                return true
            end
        end
        return false
    end

    function room_state:get_item(id)
        for i = 1, #self.serializable.collectibles do
            if self.serializable.collectibles[i].id == id then
                return self.serializable.collectibles[i]
            end
        end
        return nil
    end

    function room_state:add_collectible(ser)
        table.insert(self.serializable.collectibles, ser)
    end

    function room_state:remove_collectible(ser)
        remove_serializable_by_id(self.serializable.collectibles, ser.id)
    end

    function room_state:load_dropped_collectibles(player)
        for i = 1, #self.serializable.collectibles do
            local fullRef = context_get_full_ref(self.serializable.collectibles[i].id)
            fullRef:fill_transient_data()            
        end
    end

    function room_state:delete_dropped_collectibles()
        for i = 1, #self.serializable.collectibles do
            local fullRef = context_get_full_ref(self.serializable.collectibles[i].id)
            fullRef:delete_transient_data()
        end
    end

    context_put_full_ref_obj(this)

    return this
end
