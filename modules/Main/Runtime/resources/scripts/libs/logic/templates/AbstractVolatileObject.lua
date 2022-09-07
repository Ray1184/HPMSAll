--
-- Created by Ray1184.
-- DateTime: 04/10/2020 17:04
--
-- Abstract stateless game object. Used as template for all object that don't need to keep their state.
-- Each child has usually the following structure
-- this = {
--     metainfo =
--     {
--         object_type = 'my_object',
--         parent_type = 'parent_object',
--         override = { ... }
--     },
--     transient = { ... }
-- }
--

abstract_object = { }

function abstract_object:ret(id)
    local this = {        
    }

    local metainf = {
        metainfo =
        {
            object_type = 'abstract_volatile_object',
            parent_type = nil,
            override = { }
        }
    }

    this = merge_tables(this, metainf)

    setmetatable(this, self)
    self.__index = self
    self.__tostring = function(o)
        return inspect.inspect(o)
    end

    return this
end