--
-- Created by Ray1184.
-- DateTime: 04/07/2021 17:04
--
-- Input text area.
--

dependencies = {
    'libs/gui/Image2D.lua',
    'libs/backend/HPMSFacade.lua'
}


output_text_2d = { }


function output_text_2d:new(data, x, y, image, order, id, font_name, font_size, font_color, max_lines)

    lib = backend:get()
    local ret = image_2d:new(TYPE_POLYGON, data, x, y, image, order)
    local new = {
        textarea = lib.make_textarea(id,font_name,font_size,data[1].x,data[1].y,data[3].x,data[3].y,order + 1,font_color),
        max_chars_per_line = (data[3].x - data[1].x) /(font_size / 2) -1,
        max_lines = max_lines,
        text_buffer = '',
        override_image_2d =
        {
            point_inside = ret.point_inside,
            set_position = ret.set_position,
            set_visible = ret.set_visible,
            delete = ret.delete
        }
    }
    local this = merge_tables(ret, new)
    setmetatable(this, self)
    self.__index = self

    function output_text_2d:point_inside(px, py)
        return self.override_image_2d.point_inside(self, px, py)
    end

    function output_text_2d:set_position(dx, dy)
        self.override_image_2d.set_position(self, dx, dy)
        self.textarea.position = lib.vec3(dx, dy, self.order)
    end

    function output_text_2d:set_visible(flag)
        self.override_image_2d.set_visible(self, flag)
        self.textarea.visible = flag
    end

    function output_text_2d:delete()
        self.override_image_2d.delete(self)
        lib.delete_textarea(self.textarea)
    end

    function output_text_2d:stream(text)
        return lib.stream_text(self.textarea, text, self.max_lines)        
    end
    return this

end



