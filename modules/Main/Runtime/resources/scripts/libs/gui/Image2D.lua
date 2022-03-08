--
-- Created by Ray1184.
-- DateTime: 04/07/2021 17:04
--
-- 2D image on screen for gui elements.
--

dependencies = {
    'libs/utils/MathUtils.lua',
    'libs/gui/Area2D.lua',
    'libs/backend/HPMSFacade.lua'
}

image_2d = { }

TYPE_CIRCLE = 0
TYPE_POLYGON = 1

function image_2d:new(type, data, x, y, image, order)
    local lib = backend:get()
    local ret = area_2d:new(type, data, x, y)
    local new = {
        overlay = lib.make_overlay(image,x,y,order),
        order = order,
        override_area_2d =
        {
            point_inside = ret.point_inside,
            set_position = ret.set_position
        }
    }
    local this = merge_tables(ret, new)
    setmetatable(this, self)
    self.__index = self

    function image_2d:point_inside(px, py)
        return self.override_area_2d.point_inside(self, px, py)

    end

    function image_2d:set_position(dx, dy)
        self.override_area_2d.set_position(self, dx, dy)
        self.overlay.position = lib.vec3(dx, dy, self.order)
    end

    function image_2d:set_visible(flag)
        self.overlay.visible = flag
    end

    function image_2d:delete()
        lib.delete_overlay(self.overlay)
    end

    function image_2d:alpha(a)
        lib.overlay_alpha(self.overlay, a)
    end

    return this
end



