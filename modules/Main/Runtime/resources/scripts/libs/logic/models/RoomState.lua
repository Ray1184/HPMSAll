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

    local this = context:inst():get_object(id, true,
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

    function room_state:add_collectible(obj)
        table.insert(self.serializable.collectibles, obj)
    end

    function room_state:load_dropped_collectibles()
        for i = 1, #self.serializable.collectibles do
            self.serializable.collectibles[i].fill_transient_data()
        end
    end

    function room_state:delete_dropped_collectibles()
        for i = 1, #self.serializable.collectibles do
            self.serializable.collectibles[i].delete_transient_data()
        end
    end

    context:put_full_ref_obj(this)

    return this
end
