--
-- Created by Ray1184.
-- DateTime: 04/10/2021 17:04
--
-- Scene management functions.
--

dependencies = {
    'libs/backend/HPMSFacade.lua'
}

scene_manager = { }

SIMPLE_BACKGROUND = 1
ANIMATED_BACKGROUND = 2

function scene_manager:new(sceneName, camera)
    lib = backend:get()
    insp = inspector:get()
    local this = {
        module_name = 'scene_manager',

        -- Room info
        scene_name = sceneName,
        camera = camera,
        views_map = { },
        loaded_walkmap = nil,
        loaded_env = lib.make_collision_env(),
        loaded_images = { },
        paused = false,
        timer = 9999
    }
    log_debug('Creating scene module for room ' .. sceneName)
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

    function scene_manager:set_paused(flag)
        self.paused = flag
    end

    function scene_manager:is_paused()
        return self.paused
    end

    function scene_manager:create_walkmap(walkmapName)
        if self.loaded_walkmap == nil then
            self.loaded_walkmap = lib.make_walkmap(walkmapName)
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
        if background.sequences ~= nil then
            self:sample_view_by_callback_animated(condition, background, position, rotation)
        else
            self:sample_view_by_callback_simple(condition, background, position, rotation)
        end
    end

    function scene_manager:sample_view_by_callback_simple(condition, background, position, rotation)
        if self.loaded_images[background] == nil then
            self.loaded_images[background] = lib.make_background(background)
        end
        local sample = {
            condition = condition,
            settings =
            {
                mode = SIMPLE_BACKGROUND,
                background = self.loaded_images[background],
                position = position,
                rotation = rotation
            }
        }
        table.insert(self.views_map, sample)
    end

    function scene_manager:sample_view_by_callback_animated(condition, background, position, rotation)

        for i = 1, #background.sequences do
            self.loaded_images[background.sequences[i]] = lib.make_background(background.sequences[i])
        end
        local sample = {
            condition = condition,
            settings =
            {
                mode = ANIMATED_BACKGROUND,
                backgrounds = { },
                frame_duration = background.frame_duration,
                loop = background.loop,
                index = 1,
                position = position,
                rotation = rotation
            }
        }
        for i = 1, #background.sequences do
            sample.settings.backgrounds[i] = self.loaded_images[background.sequences[i]]
        end
        table.insert(self.views_map, sample)
    end

    function scene_manager:poll_events(tpf)
        if self.paused then
            return
        end
        local settings_to_apply
        for i = 1, #self.views_map do
            if self.views_map[i].condition() then
                settings_to_apply = self.views_map[i].settings
                break
            end
        end
        if settings_to_apply == nil then
            return
        end

        for k, v in pairs(self.loaded_images) do
            v.visible = false
        end



        self.camera.position = settings_to_apply.position
        self.camera.rotation = settings_to_apply.rotation

        if settings_to_apply.mode == SIMPLE_BACKGROUND then
            settings_to_apply.background.visible = true
        else
            if self.timer < settings_to_apply.frame_duration then
                self.timer = self.timer + tpf
            else
                self.timer = 0

                if settings_to_apply.index < #settings_to_apply.backgrounds then
                    settings_to_apply.index = settings_to_apply.index + 1
                elseif settings_to_apply.loop then
                    settings_to_apply.index = 1
                end                
            end
            settings_to_apply.backgrounds[settings_to_apply.index].visible = true
        end

    end

    return this
end