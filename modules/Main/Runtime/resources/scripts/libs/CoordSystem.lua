---
--- Created by Ray1184.
--- DateTime: 04/04/2021 17:04
---
--- Modify transformations based on coordinate systems.
---
local lib = require('data/scripts/libs/HPMSFacade')
require('data/scripts/libs/Context')

if context:is_coord_system_blender() then
    return {
        adapt_position = function(x, y, z)
            return lib.vec3(x, z, -y)
        end,
        adapt_position = function(position)
            return adapt_position(position.x, position.y, position.z)
        end,
        adapt_rotation = function(rotation)
            return adapt_position(position.x, position.y, position.z)
        end
    }
end