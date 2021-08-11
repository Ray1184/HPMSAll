---
--- Created by Ray1184.
--- DateTime: 04/10/2021 17:04
---
--- Scene management functions.
---

dependencies = { 'libs/utils/Utils.lua' }

scene_manager = {}

function scene_manager:new(scene_name, camera)
    local this = {
        scene_name = scene_name,
        camera = camera,
        views_map = {}
    }

    setmetatable(this, self)
    self.__index = self



    function scene_manager:sample_view_by_callback(condition, background, position, rotation)
        local sample = {
            condition = condition,
            settings = {
                background = background,
                position = position,
                rotation = rotation
            }
        }
        table.insert(self.views_map, sample)
    end

    function scene_manager:update()
        local settings_to_apply
        for i = 1, #self.views_map do
            if self.views_map[i].condition() then
                settings_to_apply = self.views_map[i].settings
                break
            end
        end
        if settings_to_apply == nil then
            log_warn('No sector view condition defined for scene ' .. self.scene_name)
            return
        end

        for i = 1, #self.views_map do
            self.views_map[i].settings.background.visible = false
        end

        settings_to_apply.background.visible = true
        self.camera.position = settings_to_apply.position
        self.camera.rotation = settings_to_apply.rotation
    end

    return this
end