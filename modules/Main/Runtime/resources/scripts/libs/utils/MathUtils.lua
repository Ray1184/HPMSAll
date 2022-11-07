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

function point_inside_polygon(px, py, tx, ty, data)
    -- Due to luabridge problemes to manage vectors, for GUI is calculated script side.
    local polygon = { }
    for i = 1, #data - 1 do
        local coord = { x = data[i], y = data[i + 1] }
        table.insert(polygon, coord)
    end

    local x = px - tx;
    local y = py - ty;
    local oddNodes = false
    local j = #polygon
    for i = 1, #polygon do
        if (polygon[i].y < y and polygon[j].y >= y or polygon[j].y < y and polygon[i].y >= y) then
            if (polygon[i].x +(y - polygon[i].y) /(polygon[j].y - polygon[i].y) *(polygon[j].x - polygon[i].x) < x) then
                oddNodes = not oddNodes;
            end
        end
        j = i;
    end
    return oddNodes

end

function circle_intersect_line(p1, p2, center, radius)
    local lib = backend:get()
    return lib.circle_intersect_line(lib.vec2(p1.x, p1.y), lib.vec2(p2.x, p2.y), lib.vec2(center.x, center.y), radius)
end

function abs(a)
    if a <= 0 then
        return 0 - a
    else
        return a
    end
end
