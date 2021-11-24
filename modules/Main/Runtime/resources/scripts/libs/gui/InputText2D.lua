---
--- Created by Ray1184.
--- DateTime: 04/07/2021 17:04
---
--- Input text area.
---

dependencies = { 'libs/gui/Image2D.lua',
                 'libs/backend/HPMSFacade.lua' }

local lib = backend:get()

input_text_2d = {}

local char_map = {}

char_map['TAB'] = '    '
char_map['RETURN'] = 'RETURN'
char_map['SPACE'] = ' '
char_map['BACK'] = 'BACK'

char_map['0'] = '0'
char_map['1'] = '1'
char_map['2'] = '2'
char_map['3'] = '3'
char_map['4'] = '4'
char_map['5'] = '5'
char_map['6'] = '6'
char_map['7'] = '7'
char_map['8'] = '8'
char_map['9'] = '9'
char_map['A'] = 'a'
char_map['B'] = 'b'
char_map['C'] = 'c'
char_map['D'] = 'd'
char_map['E'] = 'e'
char_map['F'] = 'f'
char_map['G'] = 'g'
char_map['H'] = 'h'
char_map['I'] = 'i'
char_map['J'] = 'j'
char_map['K'] = 'k'
char_map['L'] = 'l'
char_map['M'] = 'm'
char_map['N'] = 'n'
char_map['O'] = 'o'
char_map['P'] = 'p'
char_map['Q'] = 'q'
char_map['R'] = 'r'
char_map['S'] = 's'
char_map['T'] = 't'
char_map['U'] = 'u'
char_map['V'] = 'v'
char_map['W'] = 'w'
char_map['X'] = 'x'
char_map['Y'] = 'y'
char_map['Z'] = 'z'
char_map['SH_0'] = '='
char_map['SH_1'] = '!'
char_map['SH_2'] = '\"'
char_map['SH_3'] = 'L'
char_map['SH_4'] = '$'
char_map['SH_5'] = '%'
char_map['SH_6'] = '&'
char_map['SH_7'] = '/'
char_map['SH_8'] = '('
char_map['SH_9'] = ')'
char_map['SH_A'] = 'A'
char_map['SH_B'] = 'B'
char_map['SH_C'] = 'C'
char_map['SH_D'] = 'D'
char_map['SH_E'] = 'E'
char_map['SH_F'] = 'F'
char_map['SH_G'] = 'G'
char_map['SH_H'] = 'H'
char_map['SH_I'] = 'I'
char_map['SH_J'] = 'J'
char_map['SH_K'] = 'K'
char_map['SH_L'] = 'L'
char_map['SH_M'] = 'M'
char_map['SH_N'] = 'N'
char_map['SH_O'] = 'O'
char_map['SH_P'] = 'P'
char_map['SH_Q'] = 'Q'
char_map['SH_R'] = 'R'
char_map['SH_S'] = 'S'
char_map['SH_T'] = 'T'
char_map['SH_U'] = 'U'
char_map['SH_V'] = 'V'
char_map['SH_W'] = 'W'
char_map['SH_X'] = 'X'
char_map['SH_Y'] = 'Y'
char_map['SH_Z'] = 'Z'

function input_text_2d:new(data, x, y, image, order, id, font_name, font_size, font_color, max_lines)
    local ret = image_2d:new(TYPE_POLYGON, data, x, y, image, order)
    local new = {
        textarea = lib.make_textarea(id, font_name, font_size, data[1].x, data[1].y, data[3].x, data[3].y, order + 1, font_color),
        max_chars_per_line = (data[3].x - data[1].x) / (font_size / 2) - 1,
        max_lines = max_lines,
        text_buffer = '',
        focus = false,
        override_image_2d = {
            point_inside = ret.point_inside,
            set_position = ret.set_position,
            set_visible = ret.set_visible,
            delete = ret.delete
        }
    }
    local this = merge_tables(ret, new)
    setmetatable(this, self)
    self.__index = self

    function input_text_2d:point_inside(px, py)
        return self.override_image_2d.point_inside(self, px, py)
    end

    function input_text_2d:set_position(dx, dy)
        self.override_image_2d.set_position(self, dx, dy)
        self.textarea.position = lib.vec3(dx, dy, self.order)
    end

    function input_text_2d:set_visible(flag)
        self.override_image_2d.visible = flag
        self.textarea.visible = flag
    end

    function input_text_2d:delete()
        self.override_image_2d.delete(self)
        lib.delete_textarea(self.textarea)
    end

    function input_text_2d:set_focus(flag)
        self.focus = flag
        self.override_image_2d.visible = flag
    end

    function input_text_2d:get_focus()
        return self.focus
    end

    function input_text_2d:consume_key(key)
        if not self.focus or key == nil then
            return
        end
        local char = char_map[key]

        if char == nil then
            return
        end

        if char == 'BACK' then
            if #self.text_buffer > 2 then
                self.text_buffer = self.text_buffer:sub(1, -2)
            end
        else
            self.text_buffer = self.text_buffer .. char
        end
        if #self.text_buffer < self.max_chars_per_line then
            self.textarea.text = self.text_buffer
        else
            self.textarea.text = string.sub(self.text_buffer, #self.text_buffer - self.max_chars_per_line, #self.text_buffer)
        end
    end
    return this
end



