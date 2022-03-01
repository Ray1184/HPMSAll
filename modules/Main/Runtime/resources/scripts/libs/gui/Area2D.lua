--
-- Created by Ray1184.
-- DateTime: 04/07/2021 17:04
--
-- Abstract 2D item on screen.
--

dependencies = {
    'libs/utils/MathUtils.lua'
    -- 'libs/utils/Utils.lua'
}

area_2d = { }

TYPE_CIRCLE = 0
TYPE_POLYGON = 1

function area_2d:new(type, data, x, y)
    local this = {
        type = type,
        data = data,
        x = x or 0,
        y = y or 0
    }
    setmetatable(this, self)
    self.__index = self

    function area_2d:point_inside(px, py)
        if self.type == TYPE_CIRCLE then
            return point_inside_circle(px, py, self.x, self.y, data)
        elseif self.type == TYPE_POLYGON then
            return point_inside_polygon(px, py, self.x, self.y, data)
        else
            log_error('Only CIRCLE (0) and POLYGON (1) types are supported. Currently using: ' .. self.type)
            return false
        end

    end

    function area_2d:set_position(dx, dy)
        self.x = dx
        self.y = dy
    end

    return this
end



