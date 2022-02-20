--
-- Created by Ray1184.
-- DateTime: 04/10/2021 17:04
--
-- Scene management functions.
--

dependencies = {
    'libs/utils/Utils.lua',
    'libs/backend/HPMSFacade.lua'
}

scene_manager = { }

function scene_manager:new(scene_name, camera)
    lib = backend:get()
    insp = inspector:get()
    local this = {
        module_name = 'scene_manager',

        -- Room info
        scene_name = scene_name,
        camera = camera,
        views_map = { },
        loaded_walkmap = nil,
        loaded_env = lib.make_collision_env(),
        loaded_images = { }
    }
    log_debug('Creating scene module for room ' .. scene_name)
    setmetatable(this, self)
    self.__index = self
    self.__tostring = function(o)
        return insp.inspect(o)
    end

    function scene_manager:delete_all()
        for kb, background in pairs(self.loaded_images) do
            lib.delete_background(background)
        end
        if self.loaded_walkmap ~= nil then
            lib.delete_walkmap(self.loaded_walkmap)
        end
         if self.loaded_env ~= nil then
            lib.delete_collision_env(self.loaded_env)
        end

        self.views_map = { }
        self.loaded_walkmap = nil
        self.loaded_env = nil
        self.loaded_images = { }

    end

    function scene_manager:create_walkmap(walkmap_name)
        if self.loaded_walkmap == nil then
            self.loaded_walkmap = lib.make_walkmap(walkmap_name)
            lib.set_walkmap_to_env(self.loaded_env, self.loaded_walkmap)
        end
    end

    function scene_manager:get_collision_env()
        return self.loaded_env
    end

    function scene_manager:get_walkmap()
        return self.loaded_walkmap
    end

    function scene_manager:get_scene_name()
        return self.scene_name
    end

    function scene_manager:sample_view_by_callback(condition, background, position, rotation)
        if self.loaded_images[background] == nil then
            self.loaded_images[background] = lib.make_background(background)
        end
        local sample = {
            condition = condition,
            settings =
            {
                background = self.loaded_images[background],
                position = position,
                rotation = rotation
            }
        }
        table.insert(self.views_map, sample)
    end

    function scene_manager:poll_events()
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