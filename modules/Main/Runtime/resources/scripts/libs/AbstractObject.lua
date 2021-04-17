---
--- Created by Ray1184.
--- DateTime: 04/10/2020 17:04
---
--- Abstract object.
---

abstract_object = {}

function abstract_object:ret(id)
    local this = {
        serializable = {
            id = 'object/' .. (id or 'UNDEF')
        },
        transient = {}
    }
    setmetatable(this, self)
    self.__index = self
    self.__tostring = function(o)
        return 'abstract_object[id=' .. o.serializable.id .. ']'
    end
    return this
end