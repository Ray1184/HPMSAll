--
-- Created by Ray1184.
-- DateTime: 08/10/2020 17:04
--
-- Model for room, keeping the state of current player, actors, collectibles and variables.
--


dependencies = {
    'libs/Context.lua',
    'libs/utils/Utils.lua',
    'libs/logic/templates/AbstractObject.lua',
    'libs/backend/HPMSFacade.lua',
    'libs/thirdparty/Inspect.lua'
}

room_state = { }

function room_state:ret(id, items)
    lib = backend:get()
    k = game_mechanics_consts:get()
    insp = inspector:get()

    local id = 'room_state/' .. id
    local ret = abstract_object:ret(id)

    local this = context:inst():get_object(id,
    function()
        log_debug('New room_state object ' .. id)

        local new = {
            serializable =
            {
                state =
                {
                    actors = items.actors,
                    collectibles = items.collectibles,
                    variables = items.variables
                }
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

    function room_state:get_state()
        return self.serializable.state
    end

    function room_state:get_object(objectCat, objectId)
        return self.serializable.state[objectCat][objectId]
    end

    function room_state:set_object(objectCat, objectId, object)
        if object == nil then
            remove_by_key(self.serializable.state[objectCat], objectId)
        else
            self.serializable.state[objectCat][objectId] = object
        end
    end

    return this
end
