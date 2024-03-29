--
-- Created by Ray1184.
-- DateTime: 04/10/2020 17:04
--
-- Abstract game object. Used as template for all object that need to keep their state
-- within game cycle (after save games etc...)
-- Each child has usually the following structure
-- this = {
--     serializable = { ... },
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
        serializable =
        {
            id = 'object/' ..(id or 'UNDEF')
        }
    }

    local metainf = {
        metainfo =
        {
            object_type = 'abstract_object',
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