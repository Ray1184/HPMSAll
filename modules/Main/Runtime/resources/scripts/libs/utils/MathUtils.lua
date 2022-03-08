--
-- Created by Ray1184.
-- DateTime: 04/08/2021 17:04
--
-- Common math.
--

dependencies = { 'libs/backend/HPMSFacade.lua' }

function point_inside_circle(x, y, cx, cy, radius)
    local lib = backend:get()
    return lib.point_inside_circle(lib.vec2(x, y), lib.vec2(cx, cy), radius)
end

function point_inside_polygon(x, y, cx, cy, data)
    local lib = backend:get()
    return lib.point_inside_polygon(lib.vec2(x, y), lib.vec2(cx, cy), data)
end
