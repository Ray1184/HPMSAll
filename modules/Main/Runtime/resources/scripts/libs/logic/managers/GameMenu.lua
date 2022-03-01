--
-- Created by Ray1184.
-- DateTime: 04/02/2022 17:04
--
-- Game main menù.
--


dependencies = {
    ----'Context.lua',
    --'libs/utils/Utils.lua',
    'libs/gui/Image2D.lua',
    'libs/gui/OutputText2D.lua',
    'libs/logic/templates/AbstractObject.lua',
    'libs/backend/HPMSFacade.lua',
    'libs/thirdparty/Inspect.lua'
}

game_menu = { }



function game_menu:get(info, current_page)
    lib = backend:get()
    k = game_mechanics_consts:get()
    insp = inspector:get()

    local invBox = { lib.vec2(10, 0), lib.vec2(320, 0), lib.vec2(320, 200), lib.vec2(0, 200) }

    local this = {
        module_name = 'game_menu',

        -- Backend data ref
        loaded_background = { },
        loaded_gui = { },
        opened = false


    }
    log_debug('Creating game menu module')
    setmetatable(this, self)
    self.__index = self
    self.__tostring = function(o)
        return insp.inspect(o)
    end


    function game_menu:open()
        if not self.opened then
            local mode = current_page or k.menu_modes.STATISTICS
            local backgroundImage = info.background_image
            local guiImage = info.gui_images[mode]
            self.loaded_background = image_2d:new(TYPE_POLYGON, invBox, 0, 0, backgroundImage, 98)
            self.loaded_gui = image_2d:new(TYPE_POLYGON, invBox, 0, 0, guiImage, 101)
            self.loaded_background:set_visible(true)
            self.loaded_gui:set_visible(true)
            self.opened = true
        end

    end

    function game_menu:close()
        if self.opened then
            local mode = info.mode or k.menu_modes.STATISTICS
            self.loaded_background:delete()
            self.loaded_gui:delete()
            self.opened = false
        end

    end

    function game_menu:update()
        local mode = info.mode or k.menu_modes.STATISTICS
        if mode == k.menu_modes.STATISTICS then
            self:update_stats()
        elseif mode == k.menu_modes.INVENTORY then
            self:update_inventory()
        elseif mode == k.menu_modes.SKILLS then
            self:update_skills()
        else
            self:update_opts()
        end
    end

    return this

end
